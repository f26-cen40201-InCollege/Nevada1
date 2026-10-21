# **EPIC #1: LOG IN**
### **SPRINT ROLE ASSIGNMENTS**

| ROLES | OWNER |
| --- | --- |
| **Scrum Master** | Jude Joyson |
| **Developer #1** | Aref Khondaker |
| **Developer #2** | Tangil Khondaker |
| **Tester #1** | Ian Koratsky |
| **Tester #2** | Connor Kouznetsov |

## **GLOBAL OBJECTIVE | SPRINT #1 | September 2, 2026 → September 9, 2026**

Establish the foundational InCollege authentication system through user registration, login, and initial application navigation. 

All inputs are read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

## **FOCUS AREAS**

### **1. Simulated User Interface and I/O**

The initial screen must provide options to log in with an existing account or create a new account. The COBOL application should simulate this interaction through clear console prompts.

- **Input:** Read usernames, passwords, and menu selections from a predefined input file.
- **Output display:** Display prompts, confirmations, and errors on standard output.
- **Output preservation:** Write the exact displayed output, including user input, to a separate output file for testing and record-keeping.

### 2. **Account Management**

- **New Account Creation:** Support up to five unique student accounts with unique usernames and secure passwords.
- **Password Requirements:** Passwords must contain 8 to 12 characters, at least one capital letter, one digit, and one special character.
- **Persistence:** Save accounts and load them when the application starts again. A sequential file or similar COBOL-managed data structure is acceptable for this alpha version.
- **Account Limit:** On the sixth account-creation attempt, display: `All permitted accounts have been created, please come back later`.

### 3. **Login Functionality**

When a student enters a recognized username and password, display: `You have successfully logged in`.

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 1 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.