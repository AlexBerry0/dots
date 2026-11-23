"""Sort the Mail.app inboxes of every account using rules.json.

Runs only while Mail is open. Matching is by sender (and optional subject)
substring; rules run top to bottom, so the first rule that matches a message
wins. Binned messages go to that account's own Bin, and folders are created
inside each account, so mail never moves between accounts.

Each account is processed in small batches of rules, one osascript call per
batch, so a slow or failing batch is reported and the run carries on.

On Gmail accounts a filed message is also archived (moved to All Mail), because
moving into a Gmail label from Mail.app only adds the label.

Usage: mail_sort.py [--dry-run] [--rules PATH]
"""

import json
import pathlib
import subprocess
import sys
import time

HERE = pathlib.Path(__file__).resolve().parent
BATCH = 12


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
        # Gmail over IMAP can take minutes per batch on a first run.
        "with timeout of 1800 seconds",
        'tell application "Mail"',
        f"  set acc to account {q(account)}",
        '  set ib to mailbox "INBOX" of acc',
        # Gmail accounts: moving into a label folder only adds the label, so the
        # message is then archived (moved to All Mail) to take it out of the inbox.
        "  set allMail to missing value",
        "  repeat with mb in mailboxes of acc",
        '    if name of mb is "All Mail" then set allMail to contents of mb',
        "  end repeat",
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
            action = "delete m" if target == "BIN" else "move m to dest\n          if allMail is not missing value then move m to allMail"
            label = "Bin" if target == "BIN" else target
            # Gmail threads can move together, so skip messages that are already gone.
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


def osascript(script):
    return subprocess.run(["/usr/bin/osascript", "-"], input=script, text=True, capture_output=True)


def accounts():
    r = osascript('tell application "Mail" to return name of every account')
    return [a.strip() for a in r.stdout.strip().split(",") if a.strip()] if r.returncode == 0 else []


def mail_running():
    return subprocess.run(["/usr/bin/pgrep", "-x", "Mail"], capture_output=True).returncode == 0


def main(argv):
    dry_run = "--dry-run" in argv
    rules_path = HERE / "rules.json"
    if "--rules" in argv:
        rules_path = pathlib.Path(argv[argv.index("--rules") + 1])
    if not mail_running():
        print("[mail-sort] Mail is not open; skipping.")
        return 0
    rules = json.loads(rules_path.read_text())
    steps = steps_from(rules)
    days = rules.get("bin_after_days", 3)
    failures = 0
    for account in accounts():
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
