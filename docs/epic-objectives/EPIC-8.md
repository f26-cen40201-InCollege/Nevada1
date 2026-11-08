# **EPIC #8: BASIC MESSAGING SYSTEM — PART 1 (SEND MESSAGE)**
### **SPRINT ROLE ASSIGNMENTS**

| Role | Owner |
| --- | --- |
| **Scrum Master** | Ian Koratsky |
| **Developer #1** | Connor Kouznetsov |
| **Developer #2** | Jude Joyson |
| **Tester #1** | Aref Khondaker |
| **Tester #2** | Tangil Khondaker |

## **GLOBAL OBJECTIVE | SPRINT #8 | November 4, 2026 → November 11, 2026**

Implement the foundational capability for connected users to send private messages to each other within InCollege. Logged-in users can select a recipient by username, enter free-form message content, and save the message persistently for the recipient to retrieve in a later Epic. This work introduces Jira Epic #5: Messaging System. `View My Messages` remains under construction this week.

All input continues to be read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

## **FOCUS AREAS**

### **1. Messaging Option**

- Add `9. Messages` to the main post-login menu while preserving the existing login, profile, search, skills, connection, network, and job board paths.
- Selecting `Messages` opens `--- Messages Menu ---` with:
  - `1. Send a New Message`
  - `2. View My Messages`
  - `3. Back to Main Menu`
- `Send a New Message` starts recipient selection (Focus Area 2).
- `View My Messages` displays `View My Messages is under construction.` and returns to the Messages menu. Reading and displaying received messages is reserved for the next Epic.
- `Back to Main Menu` returns to the top-level post-login menu.
- After a message is sent, return the user to the Messages menu. Invalid menu input must produce a clear error and allow another selection.

### **2. Recipient Selection**

- When the user chooses `Send a New Message`, first display `Enter recipient's username (must be a connection):` and read the username from the input file.
- Validate that the recipient is a registered user and has an established connection with the logged-in sender, using the accepted connections from Epic 5.
- Connection validation must work in both directions: either user in an accepted connection can send a message to the other.
- A non-existent user, an unconnected user, a pending connection, or a rejected connection must not receive a message. Display a clear error such as `You can only message users you are connected with.` or `User not found in your network.`.
- A user cannot message themselves. Invalid recipients must be rejected before the program requests message content, and no message record may be written.

### **3. Message Content Input**

- Once a valid connected recipient is identified, display `Enter your message (max 200 chars):` and read the content from the input file.
- Message content is free-form text. The 200-character limit follows the PDF's sample prompt; ordinary punctuation and spaces must be supported.
- Reject blank content and content exceeding the supported limit with a clear message. Do not silently truncate a message or save a partial record.
- If the input file ends before a recipient or message is supplied, end the operation safely without sending an incomplete message.
- On successful persistence, display a confirmation with the actual recipient, for example `Message sent to ConnectedUser successfully!`.

### **4. Message Persistence**

- Store messages in a dedicated persistent data structure, separate from accounts, profiles, connection requests, established connections, jobs, and applications.
- Each record must contain:
  - Sender's username
  - Recipient's username
  - Message content
  - A timestamp for when the message was sent
- Append new messages without overwriting earlier records. Messages must survive closing and reopening the application, including messages sent in separate runs or by different users.
- Preserve enough information for the recipient's messages to be retrieved in the next Epic, while keeping `View My Messages` under construction this week.
- A storage failure must display an error and must not report that the message was sent successfully.

### **5. I/O Requirements**

- **Input:** Read all menu selections, recipient usernames, and message content from the predefined input file, `InCollege-Input.txt`.
- **Output display:** Display menus, prompts, confirmations, the under-construction message, and errors on standard output.
- **Output preservation:** Write the exact displayed output to `InCollege-Output.txt` for testing and record-keeping. Console output and the output file must be identical for every messaging scenario.

### **6. Implementation Notes**

- Place message sending code in the copybook `SENDMESSAGE_SRC` (`SendMessage.cob`) and the under-construction view entry point in `VIEWMESSAGES_SRC` (`ViewMessages.cob`), following the PDF's suggested separation.
- Store messages in `Messages.txt` as line-sequential records: sender username (20 characters), recipient username (20), local timestamp with UTC offset (25), and message content (up to 200). The timestamp uses `YYYY-MM-DDTHH:MM:SS+HH:MM`, with the actual positive or negative offset from COBOL `CURRENT-DATE`. Append complete records without an in-memory message-count limit.
- Reuse the established connections data from Epic 5 for recipient validation. Pending requests alone do not authorize messaging.
- Integrate the Messages submenu into the existing post-login menu and route every messaging prompt and response through the same screen/output-file handling.
- Document the message record format, content limit, timestamp representation, menu choice, and sample input sequence in `README.md` so testers can prepare Docker runs consistently.
- The program must integrate with all previous Epics' functionality, including login, profiles, user search, skills, connection requests, accepted/rejected connections, network display, and the job board.

## **TESTING FOCUS**

Testers create test cases in Jira covering the following. Positive, negative, and edge cases are required for each story.

| Area | Scenarios |
| --- | --- |
| **Messaging navigation** | Open Messages from the post-login menu; return to the main menu; invalid submenu choices; `View My Messages` shows the under-construction message |
| **Connected recipients** | Send to an existing accepted connection; validate both directions of a connection; send to different connected users |
| **Invalid recipients** | Non-existent user; existing unconnected user; pending request; rejected request; self-recipient; blank or overlong username; no message content requested or record written for invalid recipients |
| **Message content** | Ordinary free-form text; punctuation and spaces; exactly 200 characters; 201 characters; blank content; input file ending before the content is supplied |
| **Persistence** | Store sender, recipient, exact content, and timestamp; append multiple messages; preserve earlier records across restarts; storage failures do not produce a success confirmation |
| **I/O consistency** | Every input comes from the input file; console output is identical to the output file for successful, failed, and under-construction paths |
| **Regression** | Login, profiles, search, skills, connection management, network display, job posting, browsing, applying, and application reports still work |

Test inputs are submitted as `Epic8-Storyx-Test-Input.zip` and actual outputs as `Epic8-Storyx-Test-Output.zip`. Every discrepancy requires a Jira bug ticket with steps to reproduce, actual result, and expected result.

## **DELIVERABLES**

- `Roles.txt`, `InCollege.cob`, `InCollege-Input.txt`, `InCollege-Output.txt`, and the messaging copybooks integrated with the existing program
- `Epic8-Storyx-Test-Input.zip` and `Epic8-Storyx-Test-Output.zip`
- `Jira.jpg` (updated board), two burndown charts (Monday and sprint completion), and `GitHub.jpg` (commit history)
- `README.md` updated with how to prepare messaging input, the supported content and storage format, and where to find the corresponding output

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 8 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.