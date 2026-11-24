"""Sort the inboxes of every Mail.app account using a private rules file.

The rules live in ~/.config/mail-sort/rules.json, never in this repository.
rules.example.json shows the format.

Runs only while Mail is open. Matching is by sender (and optional subject)
substring; rules run top to bottom, so the first rule that matches a message
wins. Binned messages go to that account's own Bin, and folders are created
inside each account, so mail never moves between accounts.

Each account is processed in small batches of rules, one osascript call per
batch, so a slow or failing batch is reported and the run carries on.

Gmail accounts are sorted over IMAP with Gmail's own labels, never by moving
messages in Mail.app: Gmail turns those moves into copies and deletions, which
is how filed mail once ended up in the Bin. Each needs an app password in the
Keychain (service "mail-sort"); without one the account is left alone.

Nothing starred, replied to, urgent-looking, or that looks like a receipt is
ever binned, and a run that would bin more than MAX_BIN messages from one
account bins none. --clear-backlog lifts that limit for one run.

Usage: mail_sort.py [--dry-run] [--clear-backlog] [--rules PATH]
"""

import datetime
import email
import email.header
import imaplib
import json
import pathlib
import re
import subprocess
import sys
import time

BATCH = 12
MAX_BIN = 25
RECEIPT = re.compile(
    r"receipt|invoice|order (confirm|#|no|number|\d)|your order|order\b.*\b(confirmed|dispatched|shipped|on (the|its) way|collection)"
    r"|shipment|payment (received|confirm)|booking|e-?ticket|itinerary|refund|warranty",
    re.I,
)
IMPORTANT = re.compile(r"action (is )?required|expir|renew|recovery|suspen|overdue|final notice|terminat|will be (deleted|closed)|unauthori[sz]ed|payment failed|declined", re.I)
RECEIPTS = "Receipts & Orders"
JOURNAL = pathlib.Path.home() / "Library/Logs/mail-sort-binned.log"


def q(text):
    """Quote a Python string as an AppleScript string literal."""
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


def condition(rule, dated=False):
    if isinstance(rule, str):
        rule = {"sender": rule}
    parts = [f"sender contains {q(rule['sender'])}"]
    if rule.get("subject"):
        parts.append(f"subject contains {q(rule['subject'])}")
    if dated:
        parts.append("date received < cutoff")
    return " and ".join(parts)


def steps_from(rules):
    steps = [("BIN", condition(r, dated=True)) for r in rules.get("bin_old", [])]
    steps += [("BIN", condition(r)) for r in rules.get("bin", [])]
    for folder, entries in rules.get("folders", {}).items():
        steps += [(folder, condition(r)) for r in entries]
    return steps


def build_script(account, steps, days, dry_run):
    lines = [
        'set report to ""',
        f"set cutoff to (current date) - ({int(days)} * days)",
        "with timeout of 1800 seconds",
        'tell application "Mail"',
        f"  set acc to account {q(account)}",
        '  set ib to mailbox "INBOX" of acc',
    ]
    for target, cond in steps:
        lines += ["  try", f"    set ms to (messages of ib whose {cond})", "    set n to count of ms", "    if n > 0 then"]
        if dry_run:
            label = "Bin" if target == "BIN" else target
            lines.append(f"      set report to report & {q(label)} & tab & n & linefeed")
        else:
            if target != "BIN":
                lines += [
                    "      try",
                    f"        set dest to mailbox {q(target)} of acc",
                    "      on error",
                    f"        tell acc to make new mailbox with properties {{name:{q(target)}}}",
                    f"        set dest to mailbox {q(target)} of acc",
                    "      end try",
                ]
            action = "delete m" if target == "BIN" else "move m to dest"
            label = "Bin" if target == "BIN" else target
            # Threads can move together, so skip messages that are already gone.
            lines += [
                "      set done to 0",
                "      repeat with m in ms",
                "        try",
                f"          {action}",
                "          set done to done + 1",
                "        end try",
                "      end repeat",
                f"      set report to report & {q(label)} & tab & done & linefeed",
            ]
        lines += ["    end if", "  end try"]
    lines += ["end tell", "end timeout", "return report"]
    return "\n".join(lines)


def decide(sender, subject, received, flags, rules, now):
    """Where one message goes: a folder name, "BIN", or None to leave it alone."""
    sender, subject = sender.lower(), subject.lower()

    def hit(rule):
        rule = {"sender": rule} if isinstance(rule, str) else rule
        return rule["sender"].lower() in sender and rule.get("subject", "").lower() in subject

    old = received < now - datetime.timedelta(days=rules.get("bin_after_days", 3))
    if (old and any(map(hit, rules.get("bin_old", [])))) or any(map(hit, rules.get("bin", []))):
        if RECEIPT.search(subject):
            return RECEIPTS
        return None if IMPORTANT.search(subject) or {"\\Flagged", "\\Answered"} & flags else "BIN"
    return next((f for f, entries in rules.get("folders", {}).items() if any(map(hit, entries))), None)


def decode(value):
    try:
        return " ".join(str(email.header.make_header(email.header.decode_header(value or ""))).split())
    except (LookupError, UnicodeError, ValueError):
        return value or ""


def all_mail(conn):
    """The name of the All Mail folder, whatever language the account uses."""
    for line in conn.list()[1] or []:
        if line and b"\\All" in line:
            return re.search(rb'("[^"]*"|\S+)\s*$', line).group(1).decode()
    raise imaplib.IMAP4.error("could not find All Mail")


def ok(response):
    if response[0] != "OK":
        raise imaplib.IMAP4.error(f"Gmail refused a request: {response[0]}")
    return response[1]


def wire(label):
    """A label as IMAP writes it: "&" is special, and only plain characters are allowed."""
    if not label.isascii() or '"' in label or "\\" in label:
        raise imaplib.IMAP4.error(f"unsupported folder name: {label}")
    return '"' + label.replace("&", "&-") + '"'


def chunks(uids, size=200):
    return [b",".join(uids[i : i + size]) for i in range(0, len(uids), size)]


def inbox(conn):
    """Yield uid, sender, subject, received and flags for everything in the inbox.

    Read from All Mail, because Gmail ignores label changes to the folder that is open.
    """
    ok(conn.select(all_mail(conn)))
    uids = ok(conn.uid("SEARCH", None, "X-GM-RAW", '"in:inbox"'))[0].split()
    for part_uids in chunks(uids):
        for part in ok(conn.uid("FETCH", part_uids, "(UID FLAGS INTERNALDATE BODY.PEEK[HEADER.FIELDS (FROM SUBJECT)])")):
            if not isinstance(part, tuple):
                continue
            head = email.message_from_bytes(part[1])
            received = datetime.datetime.fromtimestamp(time.mktime(imaplib.Internaldate2tuple(part[0])))
            flags = {f.decode() for f in imaplib.ParseFlags(part[0])}
            yield re.search(rb"UID (\d+)", part[0]).group(1), decode(head["From"]), decode(head["Subject"]), received, flags


def labelled(conn, part_uids, label):
    """Which of these messages Gmail confirms have the label."""
    found = []
    for part in ok(conn.uid("FETCH", part_uids, "(UID X-GM-LABELS)")):
        part = part[0] + part[1] if isinstance(part, tuple) else part
        name = re.escape(wire(label).strip('"').encode())
        if part and re.search(rb'"' + name + rb'"|[( ]' + name + rb"[) ]", part):
            found.append(re.search(rb"UID (\d+)", part).group(1))
    return found


def sort_gmail(conn, account, rules, dry_run, now=None, limit=MAX_BIN):
    now = now or datetime.datetime.now()
    plan = {}
    for uid, sender, subject, received, flags in inbox(conn):
        target = decide(sender, subject, received, flags, rules, now)
        if target:
            plan.setdefault(target, []).append((uid, sender, subject))
    held = len(plan.get("BIN", []))
    if limit is not None and held > limit:
        del plan["BIN"]
        print(f"[mail-sort] {account}: {held} messages match bin rules, more than {limit}, so none were binned.", file=sys.stderr)
    done = {("Bin" if k == "BIN" else k): len(v) for k, v in plan.items()}
    if dry_run:
        return done
    for target, messages in plan.items():
        if target == "BIN":
            JOURNAL.parent.mkdir(parents=True, exist_ok=True)
            with JOURNAL.open("a") as f:
                f.writelines(f"{now:%Y-%m-%d %H:%M}\t{account}\t{sender}\t{subject}\n" for _, sender, subject in messages)
            for part_uids in chunks([m[0] for m in messages]):
                ok(conn.uid("STORE", part_uids, "+X-GM-LABELS", "(\\Trash)"))
            continue
        filed = 0
        try:
            for part_uids in chunks([m[0] for m in messages]):
                conn.uid("STORE", part_uids, "+X-GM-LABELS", f"({wire(target)})")
                # Only leave the inbox once Gmail confirms the label is on.
                if sure := labelled(conn, part_uids, target):
                    ok(conn.uid("STORE", b",".join(sure), "-X-GM-LABELS", "(\\Inbox)"))
                    filed += len(sure)
        except imaplib.IMAP4.abort:
            raise
        except imaplib.IMAP4.error as e:
            print(f"[mail-sort] {account}: {target}: {e}", file=sys.stderr)
        if filed < len(messages):
            print(f"[mail-sort] {account}: {len(messages) - filed} could not be filed in {target} and stayed in the inbox.", file=sys.stderr)
        done[target] = filed
    return {k: v for k, v in done.items() if v}


def app_password(address):
    r = subprocess.run(["/usr/bin/security", "find-generic-password", "-s", "mail-sort", "-a", address, "-w"], capture_output=True, text=True)
    return r.stdout.strip() if r.returncode == 0 else ""


def account_details(account):
    r = osascript(f'tell application "Mail" to tell account {q(account)} to return (user name) & linefeed & (server name)')
    user, _, server = r.stdout.strip().partition("\n")
    return user.strip(), server.strip()


def run_gmail(account, user, rules, dry_run, limit=MAX_BIN):
    password = app_password(user)
    if not password:
        return None
    with imaplib.IMAP4_SSL("imap.gmail.com", timeout=60) as conn:
        conn.login(user, password)
        return sort_gmail(conn, account, rules, dry_run, limit=limit)


def osascript(script):
    return subprocess.run(["/usr/bin/osascript", "-"], input=script, text=True, capture_output=True)


def accounts():
    r = osascript('tell application "Mail" to return name of every account')
    return [a.strip() for a in r.stdout.strip().split(",") if a.strip()] if r.returncode == 0 else []


def mail_running():
    return subprocess.run(["/usr/bin/pgrep", "-x", "Mail"], capture_output=True).returncode == 0


def main(argv):
    dry_run = "--dry-run" in argv
    rules_path = pathlib.Path.home() / ".config/mail-sort/rules.json"
    if "--rules" in argv:
        rules_path = pathlib.Path(argv[argv.index("--rules") + 1])
    if not mail_running():
        print("[mail-sort] Mail is not open; skipping.")
        return 0
    if not rules_path.exists():
        print(f"[mail-sort] No rules at {rules_path}; skipping.")
        return 0
    rules = json.loads(rules_path.read_text())
    steps = steps_from(rules)
    days = rules.get("bin_after_days", 3)
    failures = 0
    for account in accounts():
        if account in rules.get("skip_accounts", []):
            continue
        user, server = account_details(account)
        if "gmail" in server or "googlemail" in server or user.endswith("@gmail.com"):
            try:
                totals = run_gmail(account, user, rules, dry_run, None if "--clear-backlog" in argv else MAX_BIN)
            except (OSError, imaplib.IMAP4.error) as e:
                failures += 1
                print(f"[mail-sort] {account}: {e}", file=sys.stderr)
                continue
            if totals is None:
                print(f"[mail-sort] {account}: no app password in the Keychain, so it was left alone.")
                continue
            summary = ", ".join(f"{k} {v}" for k, v in sorted(totals.items())) or "nothing to do"
            print(f"[mail-sort] {account}: {summary}", flush=True)
            continue
        totals = {}
        for start in range(0, len(steps), BATCH):
            if start:
                time.sleep(1.5)  # give Mail a moment between batches
            result = osascript(build_script(account, steps[start : start + BATCH], days, dry_run))
            if result.returncode != 0:
                failures += 1
                print(f"[mail-sort] {account}: rules {start}-{start + BATCH - 1} failed: {result.stderr.strip()}", file=sys.stderr)
                continue
            for line in result.stdout.strip().splitlines():
                label, _, count = line.partition("\t")
                totals[label] = totals.get(label, 0) + int(count or 0)
        summary = ", ".join(f"{k} {v}" for k, v in sorted(totals.items())) or "nothing to do"
        print(f"[mail-sort] {account}: {summary}", flush=True)
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
