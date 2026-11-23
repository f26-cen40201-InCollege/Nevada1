#!/usr/bin/env python3
"""Exercise the compiled application with isolated file input and storage."""

import os, shutil, subprocess, tempfile, unittest
from pathlib import Path

EXECUTABLE = Path(os.environ.get("INCOLLEGE_EXECUTABLE", "/usr/local/bin/InCollege")).resolve()
RESULTS = os.environ.get("INCOLLEGE_TEST_RESULTS")
STAMP = "2026-11-11T09:30:00-05:00"
PASSWORD = "Passw0rd1!"
EMPTY = "You have no messages at this time."
HEADER = "--- Your Messages ---"
MENU = "--- Messages Menu ---"
MAIN = "1. Create/Edit My Profile"

def record(sender, recipient, content, timestamp=STAMP):
    return f"{sender:<20}{recipient:<20}{timestamp}{content}\n".encode("ascii")

class MessageTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="incollege-epic9-")
        self.addCleanup(self.temp.cleanup)
        self.work = Path(self.temp.name)
        self.run_number = 0
        self.accounts = ("ReceivingUser", "SendingUser", "AnotherConnection", "OtherUser", "receivinguser", "ReceivingUser2")
        (self.work / "Accounts.txt").write_text("".join(f"{name:<20}{PASSWORD:<20}\n" for name in self.accounts))
        self.seed = record("SendingUser", "ReceivingUser", "Hi there! Glad we connected on InCollege.")
        self.messages = self.work / "Messages.txt"

    def run_app(self, selections="9\n2\n3\n6\n", user="ReceivingUser"):
        self.run_number += 1
        source = f"1\n{user}\n{PASSWORD}\n{selections}"
        (self.work / "InCollege-Input.txt").write_text(source)
        result = subprocess.run(
            [str(EXECUTABLE)], cwd=self.work, input=b"",
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=10,
            env={**os.environ, "LC_ALL": "C"},
        )
        transcript = self.work / "InCollege-Output.txt"
        if RESULTS:
            evidence = Path(RESULTS) / self._testMethodName / str(self.run_number)
            evidence.mkdir(parents=True, exist_ok=True)
            for name in ("InCollege-Input.txt", "InCollege-Output.txt", "Messages.txt", "Accounts.txt", "Connections.txt"):
                path = self.work / name
                if path.is_file():
                    shutil.copyfile(path, evidence / name)
            (evidence / "stdout.txt").write_bytes(result.stdout)
            (evidence / "stderr.txt").write_bytes(result.stderr)
        self.assertEqual(result.returncode, 0, result.stderr.decode())
        self.assertEqual(result.stderr, b"")
        self.assertTrue(transcript.is_file())
        self.assertEqual(result.stdout, transcript.read_bytes(), "Console output must exactly match the output file")
        output = result.stdout.decode("ascii")
        self.assertIn("---END_OF_PROGRAM---", output)
        self.assertNotIn("under construction", output)
        return output

    def inbox(self, output):
        return output.split(HEADER + "\n", 1)[1].split(MENU, 1)[0]

    def test_one_received_message(self):
        self.messages.write_bytes(self.seed)
        output = self.run_app()
        self.assertEqual(self.inbox(output),
                         "From: SendingUser\n"
                         "Message: Hi there! Glad we connected on InCollege.\n"
                         f"Sent: {STAMP}\n---------------------\n")
        self.assertEqual(self.messages.read_bytes(), self.seed)

    def test_multiple_senders_and_stored_order(self):
        data = (self.seed
                + record("OtherUser", "OtherUser", "PRIVATE OTHER INBOX")
                + record("AnotherConnection", "ReceivingUser",
                         "Check out this interesting job posting I found!",
                         "2026-11-12T10:15:00+05:30"))
        self.messages.write_bytes(data)
        output = self.inbox(self.run_app())
        self.assertEqual(output.count("From: "), 2)
        self.assertLess(output.index("From: SendingUser"),
                        output.index("From: AnotherConnection"))
        self.assertIn("---\nFrom: AnotherConnection", output)
        self.assertIn("Sent: 2026-11-12T10:15:00+05:30", output)
        self.assertNotIn("PRIVATE OTHER INBOX", output)
        self.assertEqual(self.messages.read_bytes(), data)

    def test_missing_file_is_empty_and_not_created(self):
        self.assertIn(EMPTY, self.run_app())
        self.assertFalse(self.messages.exists())

    def test_empty_file(self):
        self.messages.write_bytes(b"")
        self.assertIn(EMPTY, self.run_app())
        self.assertEqual(self.messages.read_bytes(), b"")

    def test_only_other_users_messages(self):
        self.messages.write_bytes(record("SendingUser", "OtherUser", "PRIVATE"))
        output = self.inbox(self.run_app())
        self.assertIn(EMPTY, output)
        self.assertNotIn("PRIVATE", output)
        self.assertNotIn("From:", output)

    def test_exact_recipient_matching_and_no_outgoing_leak(self):
        self.messages.write_bytes(
            record("SendingUser", "receivinguser", "WRONG CASE")
            + record("SendingUser", "ReceivingUser2", "WRONG PREFIX")
            + record("ReceivingUser", "OtherUser", "OUTGOING")
            + self.seed
        )
        output = self.inbox(self.run_app())
        self.assertEqual(output.count("From:"), 1)
        for hidden in ("WRONG CASE", "WRONG PREFIX", "OUTGOING"):
            self.assertNotIn(hidden, output)

    def test_maximum_content_and_spaces(self):
        content = "  Meet at 10:00! Bring C++, COBOL & notes.  " + "x" * 156
        self.assertEqual(len(content), 200)
        self.messages.write_bytes(record("SendingUser", "ReceivingUser", content))
        output = self.inbox(self.run_app())
        self.assertIn("Message: " + content + "\n", output)

    def test_many_messages_have_no_table_limit(self):
        self.messages.write_bytes(b"".join(
            record("SendingUser", "ReceivingUser", f"Message number {i}")
            for i in range(1, 126)
        ))
        output = self.inbox(self.run_app())
        self.assertEqual(output.count("From: SendingUser\n"), 125)
        self.assertIn("Message: Message number 125\n", output)

    def test_repeated_views_preserve_messages(self):
        self.messages.write_bytes(self.seed)
        output = self.run_app("9\n2\n2\n3\n6\n")
        self.assertEqual(output.count(HEADER), 2)
        self.assertEqual(output.count("From: SendingUser\n"), 2)
        self.assertEqual(self.messages.read_bytes(), self.seed)

    def test_empty_then_populated_in_separate_runs(self):
        self.assertIn(EMPTY, self.run_app())
        self.messages.write_bytes(self.seed)
        output = self.run_app()
        self.assertIn("From: SendingUser", output)
        self.assertNotIn(EMPTY, output)

    def test_received_messages_remain_after_connection_removed(self):
        self.messages.write_bytes(self.seed)
        (self.work / "Connections.txt").write_bytes(b"")
        self.assertIn("From: SendingUser", self.run_app())

    def test_storage_failure_is_not_reported_as_empty(self):
        # A symlink loop forces a real OPEN error, even as root.
        self.messages.symlink_to(self.messages.name)
        output = self.run_app()
        self.assertIn("Unable to read your messages.", output)
        self.assertNotIn(EMPTY, output)

    def test_return_to_main_menu(self):
        output = self.run_app()
        after_inbox = output.split(HEADER, 1)[1]
        self.assertIn(MENU, after_inbox)
        self.assertIn("3\n" + MAIN, after_inbox)

    def test_invalid_menu_selection_then_view(self):
        output = self.run_app("9\ninvalid\n2\n3\n6\n")
        self.assertIn("Invalid Option, Try Again", output)
        self.assertIn(EMPTY, output)

    def test_eof_after_view_selection(self):
        self.messages.write_bytes(self.seed)
        output = self.run_app("9\n2\n")
        self.assertIn("From: SendingUser", output)
        self.assertEqual(output.count(HEADER), 1)

    def test_send_then_restart_and_view(self):
        (self.work / "Connections.txt").write_text(f"{'SendingUser':<20}{'ReceivingUser':<20}C\n")
        content = "Hello! Spaces, punctuation & COBOL persist."
        sent = self.run_app(f"9\n1\nReceivingUser\n{content}\n3\n6\n", user="SendingUser")
        self.assertIn("Message sent to ReceivingUser successfully!", sent)
        stored = self.messages.read_bytes()
        self.assertEqual(stored[:20].decode().rstrip(), "SendingUser")
        self.assertEqual(stored[20:40].decode().rstrip(), "ReceivingUser")
        self.assertRegex(stored[40:65].decode(),
                         r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[+-]\d{2}:\d{2}$")
        received = self.inbox(self.run_app())
        self.assertIn("Message: " + content + "\n", received)
        self.assertIn("Sent: " + stored[40:65].decode(), received)
        self.assertEqual(self.messages.read_bytes(), stored)

    def test_sending_appends_without_changing_received_messages(self):
        self.messages.write_bytes(self.seed)
        (self.work / "Connections.txt").write_text(f"{'ReceivingUser':<20}{'SendingUser':<20}C\n")
        output = self.run_app("9\n1\nSendingUser\nA reply.\n2\n3\n6\n")
        self.assertIn("Message sent to SendingUser successfully!", output)
        self.assertTrue(self.messages.read_bytes().startswith(self.seed))
        self.assertIn("Hi there! Glad we connected", self.inbox(output))
        self.assertNotIn("Message: A reply.", self.inbox(output))

    def test_invalid_recipient_does_not_write(self):
        self.messages.write_bytes(self.seed)
        output = self.run_app("9\n1\nOtherUser\n2\n3\n6\n")
        self.assertIn("You can only message users you are connected with.", output)
        self.assertNotIn("Enter your message", output)
        self.assertEqual(self.messages.read_bytes(), self.seed)

    def test_send_content_validation_still_works(self):
        (self.work / "Connections.txt").write_text(f"{'ReceivingUser':<20}{'SendingUser':<20}C\n")
        output = self.run_app("9\n1\nSendingUser\n\n1\nSendingUser\n" + "x" * 201 + "\n2\n3\n6\n")
        self.assertIn("Message content cannot be empty.", output)
        self.assertIn("Message content exceeds 200 characters.", output)
        self.assertIn(EMPTY, output)
        self.assertFalse(self.messages.exists())

if __name__ == "__main__":
    if not EXECUTABLE.is_file():
        raise SystemExit("Set INCOLLEGE_EXECUTABLE to the compiled InCollege program.")
    unittest.main(verbosity=2)