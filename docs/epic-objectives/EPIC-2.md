# **EPIC #2: USER PROFILE CREATION**
### **SPRINT ROLE ASSIGNMENTS**

| ROLES | OWNER |
| --- | --- |
| **Scrum Master** | Connor Kouznetsov |
| **Developer #1** | Jude Joyson |
| **Developer #2** | Aref Khondaker |
| **Tester #1** | Tangil Khondaker |
| **Tester #2** | Ian Koratsky |

## **GLOBAL OBJECTIVE | SPRINT #2 | September 9, 2026 → September 16, 2026**

Extend the authentication foundation so users can create and manage personal profiles in InCollege.

All inputs continue to be read from a file, displayed output is written to the screen, and the same output is written to an output file.

Requirements should also be entered into Jira as Epics and decomposed into development stories.

## **FOCUS AREAS**

### **1. Profile Information Capture**

After successful login, present a `Create/Edit My Profile` option. The profile workflow must capture:

- **First Name:** Required Chartfield.
- **Last name:** Required Chartfield.
- **University/college attended:** Required Chartfield.
- **Major:** Required Chartfield.
- **Graduation Year:** Required; a valid four-digit year greater than 2025 and less than 2034.
- **About Me:** Optional short description.
- **Experience:** Optional, up to three entries. Each entry includes a title, company or organization, dates, and an optional description.
- **Education:** Optional, up to three entries. Each entry includes a degree, university or college, and years attended.

After the profile is created, provide an option to return to the top-level menu.

### **2. Profile Persistence**

Save all profile information and associate it with the user's Epic 1 account so the information remains available across application restarts.

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 2 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.