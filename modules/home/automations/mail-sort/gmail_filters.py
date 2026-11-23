"""Build a Gmail filter import file (gmail-filters.xml) from rules.json.

Gmail filters run on Google's servers, so Gmail accounts stay sorted even when
the Mac is off. Import via Gmail > Settings > Filters and Blocked Addresses >
Import filters, and tick "Apply new filters to existing email".

- "bin" senders are moved to the Bin.
- "bin_old" senders (account/security alerts) are labelled "Account alerts",
  marked read and archived instead of binned, so a genuine alert is never lost.
- Each folder becomes a Gmail label, and matching mail skips the inbox.
"""

import json
import pathlib
import sys
from xml.sax.saxutils import quoteattr

HERE = pathlib.Path(__file__).resolve().parent
MAX_QUERY = 1200  # Gmail rejects very long "from" criteria


def chunks(senders):
    out, cur = [], []
    for s in senders:
        trial = " OR ".join(cur + [s])
        if cur and len(trial) > MAX_QUERY:
            out.append(cur)
            cur = [s]
        else:
            cur.append(s)
    if cur:
        out.append(cur)
    return out


def entry(props):
    lines = ["  <entry>", "    <category term='filter'></category>", "    <title>Mail Filter</title>", "    <content></content>"]
    for k, v in props:
        lines.append(f"    <apps:property name={quoteattr(k)} value={quoteattr(v)}/>")
    lines.append("  </entry>")
    return "\n".join(lines)


def build(rules):
    entries = []

    def add(rule_list, actions):
        plain = [r for r in rule_list if isinstance(r, str)]
        for group in chunks(plain):
            entries.append(entry([("from", " OR ".join(group))] + actions))
        for r in rule_list:
            if isinstance(r, dict):
                props = [("from", r["sender"])]
                if r.get("subject"):
                    props.append(("subject", r["subject"]))
                entries.append(entry(props + actions))

    add(rules.get("bin", []), [("shouldTrash", "true")])
    add(rules.get("bin_old", []), [("label", "Account alerts"), ("shouldMarkAsRead", "true"), ("shouldArchive", "true")])
    for folder, senders in rules.get("folders", {}).items():
        add(senders, [("label", folder), ("shouldArchive", "true")])

    return (
        "<?xml version='1.0' encoding='UTF-8'?>\n"
        "<feed xmlns='http://www.w3.org/2005/Atom' xmlns:apps='http://schemas.google.com/apps/2006'>\n"
        "  <title>Mail Filters</title>\n" + "\n".join(entries) + "\n</feed>\n"
    )


if __name__ == "__main__":
    rules = json.loads((HERE / "rules.json").read_text())
    out = HERE / "gmail-filters.xml"
    out.write_text(build(rules))
    print(f"Wrote {out} ({out.read_text().count('<entry>')} filters)")
