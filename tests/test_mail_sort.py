import datetime
import importlib.util
import os
import pathlib
import tempfile
import unittest

path = os.environ.get("MAIL_SORT", pathlib.Path(__file__).parent.parent / "modules/home/automations/mail-sort/mail_sort.py")
spec = importlib.util.spec_from_file_location("mail_sort", path)
ms = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ms)

NOW = datetime.datetime(2026, 11, 24, 12)
RULES = {"bin_after_days": 3, "bin_old": ["alerts@x.com"], "bin": ["shop.com", {"sender": "steam", "subject": "wishlist"}], "folders": {"Dev & Tech": ["github.com"]}}


class Gmail:
    """Enough of Gmail's IMAP to check what happens to each message."""

    def __init__(self, messages):
        self.m = {str(i + 1).encode(): {"labels": {"\\Inbox"}, "flags": "", "date": "24-Nov-2026 09:00:00 +1300", **x} for i, x in enumerate(messages)}

    refuse = False

    def list(self):
        return "OK", [b'(\\HasNoChildren) "/" "INBOX"', b'(\\All \\HasNoChildren) "/" "[Gmail]/All Mail"']

    def select(self, box):
        self.box = box.strip('"')
        return "OK", []

    def uid(self, cmd, *a):
        if cmd == "SEARCH":
            return "OK", [b" ".join(k for k, v in self.m.items() if "\\Inbox" in v["labels"])]
        if cmd == "FETCH" and "X-GM-LABELS" in a[1]:
            q = lambda l: (l if " " not in l else f'"{l}"').replace("&", "&-")
            return "OK", [f'1 (X-GM-LABELS ({" ".join(q(l) for l in sorted(self.m[k]["labels"]))}) UID {k.decode()})'.encode() for k in a[0].split(b",")]
        if cmd == "FETCH":
            out = []
            for k in a[0].split(b","):
                v = self.m[k]
                out += [(f'1 (UID {k.decode()} FLAGS ({v["flags"]}) INTERNALDATE "{v["date"]}" BODY {{9}}'.encode(), f'From: {v["s"]}\r\nSubject: {v["t"]}\r\n\r\n'.encode()), b")"]
            return "OK", out
        if "&" in a[2].replace("&-", ""):
            raise ms.imaplib.IMAP4.error("BAD [b'Could not parse command']")
        label = a[2].strip('()"').replace("&-", "&")
        if self.refuse and label[0] != "\\":
            return "NO", []
        if self.box == "INBOX" and label == "\\Inbox":
            return "OK", []  # Gmail ignores changes to the label of the open folder
        for k in a[0].split(b","):
            labels = self.m[k]["labels"]
            (labels.add if a[1][0] == "+" else labels.discard)(label)
            if label == "\\Trash" and a[1][0] == "+":
                labels.discard("\\Inbox")
        return "OK", []

    def labels(self, i):
        return self.m[str(i).encode()]["labels"]


class MailSort(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        ms.JOURNAL = pathlib.Path(self.tmp.name) / "j.log"
        self.addCleanup(self.tmp.cleanup)

    def run_on(self, *messages, dry=False):
        self.g = Gmail(list(messages))
        return ms.sort_gmail(self.g, "a", RULES, dry, NOW)

    def test_files_once_and_never_bins_filed_mail(self):
        self.run_on(dict(s="x@github.com", t="hi"))
        self.assertEqual(self.g.labels(1), {"Dev & Tech"})
        self.assertEqual(ms.sort_gmail(self.g, "a", RULES, False, NOW), {})

    def test_bin_is_logged(self):
        self.run_on(dict(s="promo@shop.com", t="Sale"))
        self.assertEqual(self.g.labels(1), {"\\Trash"})
        self.assertIn("Sale", ms.JOURNAL.read_text())

    def test_receipts_from_binned_senders_are_filed(self):
        for t in ("Receipt - Your ride with Flamingo", "Order #123 confirmed", "Tax invoice", "Your booking"):
            self.run_on(dict(s="promo@shop.com", t=t))
            self.assertEqual(self.g.labels(1), {"Receipts & Orders"}, t)

    def test_starred_and_answered_are_left(self):
        self.run_on(dict(s="promo@shop.com", t="Sale", flags="\\Seen \\Flagged"), dict(s="promo@shop.com", t="Sale", flags="\\Answered"))
        self.assertEqual((self.g.labels(1), self.g.labels(2)), ({"\\Inbox"}, {"\\Inbox"}))

    def test_too_many_bins_bins_none_but_still_files(self):
        self.run_on(*[dict(s="promo@shop.com", t="Sale")] * (ms.MAX_BIN + 1), dict(s="x@github.com", t="hi"))
        self.assertEqual(self.g.labels(1), {"\\Inbox"})
        self.assertEqual(self.g.labels(ms.MAX_BIN + 2), {"Dev & Tech"})

    def test_backlog_can_be_cleared_on_purpose(self):
        self.g = Gmail([dict(s="promo@shop.com", t="Sale")] * (ms.MAX_BIN + 1))
        ms.sort_gmail(self.g, "a", RULES, False, NOW, limit=None)
        self.assertEqual(self.g.labels(1), {"\\Trash"})

    def test_urgent_mail_from_binned_senders_is_left(self):
        for t in ("example.net is expiring soon", "[Action Required] Permissions update", "Your account will be deleted", "Payment failed"):
            self.run_on(dict(s="promo@shop.com", t=t))
            self.assertEqual(self.g.labels(1), {"\\Inbox"}, t)

    def test_one_bad_folder_does_not_stop_the_others(self):
        self.g = Gmail([dict(s="x@github.com", t="hi"), dict(s="y@pay.com", t="hi")])
        ms.sort_gmail(self.g, "a", {"folders": {"Māori": ["github.com"], "Money & Admin": ["pay.com"]}}, False, NOW)
        self.assertEqual((self.g.labels(1), self.g.labels(2)), ({"\\Inbox"}, {"Money & Admin"}))

    def test_label_failure_keeps_it_in_the_inbox(self):
        self.g = Gmail([dict(s="x@github.com", t="hi")])
        self.g.refuse = True
        ms.sort_gmail(self.g, "a", RULES, False, NOW)
        self.assertEqual(self.g.labels(1), {"\\Inbox"})

    def test_old_alerts_only(self):
        self.run_on(dict(s="alerts@x.com", t="New sign in"), dict(s="alerts@x.com", t="New sign in", date="10-Nov-2026 09:00:00 +1300"))
        self.assertEqual((self.g.labels(1), self.g.labels(2)), ({"\\Inbox"}, {"\\Trash"}))

    def test_dry_run_changes_nothing(self):
        self.assertEqual(self.run_on(dict(s="promo@shop.com", t="Sale"), dry=True), {"Bin": 1})
        self.assertEqual(self.g.labels(1), {"\\Inbox"})
        self.assertFalse(ms.JOURNAL.exists())

    def test_no_password_means_untouched(self):
        ms.app_password = lambda address: ""
        self.assertIsNone(ms.run_gmail("a", "a@gmail.com", RULES, False))

    def test_mail_app_never_moves_to_all_mail(self):
        self.assertNotIn("All Mail", ms.build_script("a", [("Dev & Tech", "x")], 3, False))


unittest.main()
