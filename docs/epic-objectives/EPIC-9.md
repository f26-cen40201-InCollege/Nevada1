# **EPIC #9: BASIC MESSAGING SYSTEM — PART 2 (VIEW MESSAGES)**
### **SPRINT ROLE ASSIGNMENTS**

| Role | Owner |
| --- | --- |
| **Scrum Master** | Tangil Khondaker |
| **Developer #1** | Ian Koratsky |
| **Developer #2** | Connor Kouznetsov |
| **Tester #1** | Jude Joyson |
| **Tester #2** | Aref Khondaker |

## **GLOBAL OBJECTIVE | SPRINT #9 | November 16, 2026 → November 23, 2026**

Complete the basic two-way messaging system by allowing logged-in users to retrieve and display all messages sent to their username. The `View My Messages` option, previously under construction in Epic 8, becomes fully functional. This work continues Jira Epic #5: Messaging System and uses the persistent message storage introduced in Epic 8.

All input continues to be read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

Source requirements: [InCollege-SW-Req-Epic9.pdf](../epic-pdfs/InCollege-SW-Req-Epic9.pdf).

## **FOCUS AREAS**

### **1. Viewing Received Messages**

- Selecting `9. Messages` from the existing post-login menu opens `--- Messages Menu ---` with:
  - `1. Send a New Message`
  - `2. View My Messages`
  - `3. Back to Main Menu`
- Selecting `View My Messages` displays `--- Your Messages ---` and retrieves every stored message whose recipient username exactly matches the logged-in user's username.
- Each received message must clearly show:
  - `From:` followed by the sender's username
  - `Message:` followed by the complete message content
  - `Sent:` followed by the stored timestamp
- Display message blocks with `---` between them and a closing separator, following the PDF's readable sample layout.
- Display messages in stored send order, oldest saved first. Read the append-only message file sequentially so the inbox supports all stored messages without imposing an in-memory message-count limit.
- Show only received messages. Messages sent by the logged-in user to someone else and messages exchanged between other users must not appear in their inbox.
- After displaying the inbox, return to the Messages menu. The user can select `3. Back to Main Menu` to return to the top-level post-login menu, as shown in the PDF's sample flow.
- Preserve existing menu numbering and input echoing from earlier Epics. The PDF's abbreviated top-level menu is illustrative; it does not replace the repository's established menu.
- Invalid Messages menu input must produce a clear error and allow another selection. Reopening the inbox must display the user's saved messages again.

### **2. Handling No Messages**

- If no messages are addressed to the logged-in user, display `You have no messages at this time.`.
- The same result applies when the message file is missing, the message file is empty, or the file contains only messages addressed to other users.
- Return to the Messages menu after the notice so the user can send a message, view messages again, or return to the main menu.
- A storage open or read failure must produce a clear error rather than an incorrect no-messages result. Viewing must not create, truncate, delete, or modify stored messages.
- A directory at `Messages.txt`, including a symbolic link resolving to a directory, must display `Unable to read your messages.` and return to the Messages menu. It must not display the no-messages notice.

### **3. Message Status (Optional)**

- Read/unread tracking is optional in the PDF and is deferred for this alpha version. Viewing messages is sufficient to meet Epic 9's message-status scope.
- Display all existing received messages on every visit. Do not remove messages or hide previously viewed messages.
- Preserve the Epic 8 record format so already-saved messages remain readable without migration or a new status field.

### **4. I/O Requirements**

- **Input:** Read all menu selections and navigation choices from the predefined input file, `InCollege-Input.txt`, using COBOL `READ` statements.
- **Output display:** Display menus, prompts, echoed input, message headers, senders, complete content, timestamps, separators, no-messages notices, and errors on standard output.
- **Output preservation:** Write the exact displayed output to `InCollege-Output.txt` for testing and record-keeping. Console output and the output file must be identical for every message-viewing scenario.
- Handle input-file exhaustion safely, including when the input ends immediately after selecting the inbox or before a return-menu selection. Do not wait for keyboard input or repeatedly display menus after end of input.

### **5. Implementation Notes**

- Implement message retrieval and display in the existing `VIEWMESSAGES_SRC` copybook (`ViewMessages.cob`), replacing its Epic 8 under-construction placeholder. Keep message sending in `SENDMESSAGE_SRC` (`SendMessage.cob`).
- Read the persistent `Messages.txt` file created in Epic 8. Each line-sequential record contains the sender username (20 characters), recipient username (20), timestamp (25), and message content (up to 200).
- Open the message file for input only, scan records once, compare each recipient with the logged-in username, and display matching records through the existing `WRITE-OUTPUT` routine. Close the file after each inbox visit and handle file-status errors without an infinite read loop.
- Before opening message storage, use the existing GnuCOBOL `CBL_CHECK_FILE_EXIST` routine on `Messages.txt/.` to reject a directory. GnuCOBOL can otherwise report end-of-file when a directory is opened as a line-sequential file. Keep the existing optional-file behavior for missing storage.
- Display the stored timestamp in its existing `YYYY-MM-DDTHH:MM:SS+HH:MM` format, preserving the actual positive or negative UTC offset. The focus-area requirements call for timestamps even though the sample output labels its timestamp line optional.
- Preserve ordinary punctuation, internal spaces, and the full supported 200-character content. Formatting labels must not cause truncation in the shared output buffer.
- Do not revalidate the current connection status when reading a received message; retrieval depends on the stored recipient. Epic 8 continues to validate an accepted connection before sending a new message.
- Reset retrieval state for each inbox visit so an earlier user's results or a previous lookup cannot affect the current display.
- Document the viewing input sequence, message order and format, no-messages behavior, return path, and output-file location in `README.md`.
- Supply a runnable developer example in the repository root: `InCollege-Input.txt` signs in as the existing `profileuser1` account and selects `9 → 2 → 3 → 6`; `Messages.txt` preserves the three Epic 8 records and two additional Epic 9 sample records, giving `profileuser1` three received messages from `profileuser2` and `profileuser3` while retaining the two messages addressed to `profileuser2`; `InCollege-Output.txt` preserves the actual received-message display. Sample timestamps are stored send-time values and remain unchanged when the inbox is viewed.
- Developer verification covers compilation, the existing send path, retrieval after restart, unchanged message storage, exact console/file output, and directory/missing/empty storage behavior. Preserve tester-owned inputs, expected outputs, and execution scripts during this handoff.
- Integrate with Epic 8 sending and all earlier functionality: login, profiles, search, skills, connection requests, accepted/rejected connections, network display, job posting, browsing, applying, and application reports.

## **TESTING FOCUS**

Testers create test cases in Jira covering the following. Positive, negative, persistence, and edge cases are required for the message-viewing stories.

| Area | Scenarios |
| --- | --- |
| **Messaging navigation** | Open Messages and select View My Messages; return through Back to Main Menu; invalid submenu choices; repeated inbox visits; under-construction text no longer appears |
| **Received messages** | One message; multiple messages; different senders; few and many stored messages; display all matching records in oldest-saved-first order |
| **Display formatting** | Correct sender, complete content, stored timestamp and UTC offset; punctuation and internal spaces; exactly 200 characters; readable separators |
| **Recipient filtering** | Mixed-recipient storage; outgoing messages excluded; other users' messages excluded; exact username matching; user with no matching records |
| **No messages** | Missing message file; empty file; only unrelated messages; clear no-messages notice followed by the Messages menu |
| **Persistence and status** | Messages sent through Epic 8 appear after a restart; earlier messages survive later sends; repeated views preserve the file and continue showing previously viewed messages |
| **Storage failures** | Open/read failures and a directory or symbolic link to a directory at `Messages.txt` display `Unable to read your messages.`; return to the Messages menu; no false empty-inbox result; no message records changed by viewing |
| **I/O consistency** | All input comes from the input file; console output is identical to the output file for populated, empty, error, and navigation paths; input exhaustion ends safely |
| **Regression** | Epic 8 message sending and persistent record format still work; login, profiles, search, skills, connections, network, and job board functionality remain integrated |

Test inputs are submitted as `Epic9-Storyx-Test-Input.zip` and actual outputs as `Epic9-Storyx-Test-Output.zip`. Every discrepancy requires a Jira bug ticket with steps to reproduce, actual result, and expected result. Testers compare actual console output against the generated output file for every message-viewing scenario.

## **DELIVERABLES**

Developers provide the working implementation, current roles, runtime sample files, and README instructions. Assigned testers own acceptance execution and test archives. The Scrum Master coordinates the board, burndown evidence, and team sign-off.

- `Roles.txt` updated with the Epic 9 role assignments above
- `InCollege.cob` and the integrated message-viewing implementation, including `InCollege-Core.cob`, `ViewMessages.cob`, and the existing send-message copybook
- `InCollege-Input.txt` demonstrating login, Messages navigation, View My Messages, and the return path
- `InCollege-Output.txt` demonstrating the received-message display or the no-messages notice, identical to the console output for that run
- `Messages.txt` preserving the three Epic 8 records and two additional messages generated through the send flow for the Epic 9 developer example
- `Epic9-Storyx-Test-Input.zip` and `Epic9-Storyx-Test-Output.zip`
- `Jira.jpg` (updated board), two burndown charts (Monday and sprint completion), and `GitHub.jpg` (commit history)
- `README.md` updated with how to prepare viewing input, the display and storage conventions, and where to find the corresponding output

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 9 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.