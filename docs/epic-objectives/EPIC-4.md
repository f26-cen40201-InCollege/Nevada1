# **EPIC #4: CONNECTION REQUEST**
### **SPRINT ROLE ASSIGNMENTS**

| Role | Owner |
| --- | --- |
| **Scrum Master** | Tangil Khondaker |
| **Developer #1** | Ian Koratsky |
| **Developer #2** | Connor Kouznetsov |
| **Tester #1** | Jude Joyson |
| **Tester #2** | Aref Khondaker |

## **GLOBAL OBJECTIVE | SPRINT #4 | September 23, 2026 → September 30, 2026**

Allow users to send and store connection requests to other InCollege users, establishing the foundation for professional networks. 

All input continues to be read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

## **FOCUS AREAS**

### **1. Sending Connection Requests**

- After a user searches for and views another user's profile, present a `Send Connection Request` option.
- Record pending requests and inform the sender when the request is sent.
- Allow requests only when the users are not already connected and the recipient has not already sent the sender a pending request.
- For invalid requests, display an appropriate message such as `You are already connected with this user` or `This user has already sent you a connection request`.
- Provide an option to return to the top-level menu.

### **2. Storing Pending Requests**

Persist all pending connection requests so they can be retrieved after the application is closed and reopened. The data structure must identify both the sender and recipient.

### **3. Viewing Pending Requests**

- Add a post-login menu option such as `View My Pending Connection Requests`.
- Display all users who have sent the logged-in user a request that is still pending.

### **4. I/O Requirements**

- **Input:** Read menu selections and connection-request actions from a predefined input file.
- **Output display:** Display prompts, confirmations, pending-request lists, and errors on standard output.
- **Output preservation:** Write the exact displayed output to a separate output file for testing and record-keeping.

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 4 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.