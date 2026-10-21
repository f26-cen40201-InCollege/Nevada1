# **EPIC #3: PROFILE VIEWING & BASIC SEARCH**
### **SPRINT ROLE ASSIGNMENTS**

| ROLE | Owner |
| --- | --- |
| **Scrum Master** | Ian Koratsky |
| **Developer #1** | Connor Kouznetsov |
| **Developer #2** | Jude Joyson |
| **Tester #1** | Aref Khondaker |
| **Tester #2** | Tangil Khondaker |

## **GLOBAL OBJECTIVE | SPRINT #3 | September 16, 2026 → September 23, 2026**

Enable users to view complete profiles and search for other registered users.

All input continues to be read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

## **FOCUS AREAS**

### **1. Enhanced Self-Profile Viewing**

Enhance the `View My Profile` option introduced in Epic 2 so it reliably displays the user's first name, last name, university or college, major, graduation year, About Me text, experience entries, and education entries.

Before the profile details, display:

`==== Profile for <first name> <last name>`

Format the profile clearly for console readability.

### **2. Basic User Search**

- Make `Find someone you know` functional.
- Allow searches for registered users by full name, such as `John Doe`.
- Perform an exact match against stored user names.
- Display the complete profile when a match is found.
- Inform the user when no matching profile can be found.
- Provide an option to return to the top-level menu.

### **3. I/O Requirements**

- **Input:** Read menu selections and search queries from a predefined input file.
- **Output display:** Display prompts, confirmations, profiles, search results, and errors on standard output.
- **Output preservation:** Write the exact displayed output to a separate output file for testing and record-keeping.

## **COBOL Implementation Notes**

Develop or enhance profile-display modules that retrieve complete profile data from persistent storage and format every Epic 2 field for console output.

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 3 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.