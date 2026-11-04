# **EPIC #5: ACCEPT/REJECT CONNECTIONS & NETWORK DISPLAY**
### **SPRINT ROLE ASSIGNMENTS**

| Role | Owner |
| --- | --- |
| **Scrum Master** | Aref Khondaker |
| **Developer #1** | Tangil Khondaker |
| **Developer #2** | Ian Koratsky |
| **Tester #1** | Connor Kouznetsov |
| **Tester #2** | Jude Joyson |

## **GLOBAL OBJECTIVE | SPRINT #5 | October 14, 2026 → October 21, 2026**

Finalize the core connection feature by allowing users to accept or reject pending connection requests and to view their complete network of established connections. Increase system capacity from 5 to 10 users.

All input continues to be read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

## **FOCUS AREAS**

### **1. Managing Pending Connection Requests**

- When a user selects `View My Pending Connection Requests` (Epic 4), present each pending request one at a time with `1. Accept` and `2. Reject` options.
- **Accepting a request:**
  - Establish a permanent, bidirectional connection between the two users (both users see each other in their network).
  - Remove the request from the pending requests list.
- **Rejecting a request:**
  - Remove the request from the pending requests list. No connection is established.
  - The rejected sender must never be permitted to send another connection request to the rejecting user. The Epic 4 send-request validation must be extended to block this case with an appropriate message.
- In both cases, display clear confirmation of the outcome to the user performing the action, for example `Connection request from OtherUser accepted!`.
- Processing one request must not disturb the remaining pending requests. Accepting several, rejecting several, and mixed sequences must all leave the pending list and the connections data correct.

### **2. Storing Established Connections**

- Persist established connections in a new data structure that is distinct from the pending requests file, so they survive closing and reopening the application. A file of connected username pairs is the suggested approach.
- Each accepted request adds one connection record, and the same record must resolve to both users.
- Persist the removal of accepted and rejected requests from the pending requests file.
- Persist the rejection record that blocks future requests from the rejected sender to the rejecting user.
- The file handling must support adding, deleting, and updating records across the user profiles, pending requests, and established connections files.

### **3. Displaying the Established Network**

- Add a post-login menu option `5. View My Network`.
- Display all users the logged-in user is currently connected with, cross-referencing the user profile data to retrieve details.
- For each connection, display at least the connected user's full name. University and Major may also be shown, for example `Connected with: OtherUser (University: Another U, Major: Marketing)`.
- The list must not include pending or rejected requests.
- Handle users with no connections, one connection, and multiple connections.
- Provide an option to return to the top-level menu.

### **4. Increasing System Capacity**

- Increase the maximum number of allowed system accounts from 5 to 10.
- The 10th account must be created successfully and an 11th attempt must be rejected with the existing account-limit message.
- Table sizes and loop bounds for users, pending requests, and connections must be reviewed so they support the new limit.

### **5. I/O Requirements**

- **Input:** Read menu selections and accept/reject choices from a predefined input file.
- **Output display:** Display prompts, confirmations, pending-request lists, network lists, and errors on standard output.
- **Output preservation:** Write the exact displayed output to a separate output file for testing and record-keeping. Console output and the output file must be identical for all connection management and network display scenarios.

### **6. Implementation Notes**

- Place the network and connection-management code in a separate copybook, `VIEWNET_SRC` (`ViewNetwork.cob`).
- Request processing flow: read through the pending requests, prompt for accept or reject on each, then update the established connections file (accept only) and remove the request from the pending requests file (both cases).
- The program must integrate with all previous epics' functionality (login, profile, user search, skills, send and view requests).

## **TESTING FOCUS**

Testers create test cases in Jira covering the following. Positive, negative, and edge cases are required for each story.

| Area | Scenarios |
| --- | --- |
| **Accepting requests** | Accept a single request; accept multiple requests |
| **Rejecting requests** | Reject a single request; reject multiple requests; rejected sender blocked from re-sending |
| **Mixed scenarios** | Accept some and reject others in one sequence |
| **Network display** | User with no connections, one connection, and multiple connections; network excludes rejected and pending users; both users see the connection |
| **System capacity** | 10th account succeeds; 11th account rejected |
| **Persistence** | Accepted connections and removed requests persist after a program restart |
| **I/O consistency** | Console output is identical to the output file for every scenario |

Test inputs are submitted as `Epic5-Storyx-Test-Input.zip` and actual outputs as `Epic5-Storyx-Test-Output.zip`. Every discrepancy requires a Jira bug ticket with steps to reproduce, actual result, and expected result.

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 5 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.