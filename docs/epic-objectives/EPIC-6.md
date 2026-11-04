# **EPIC #6: JOB/INTERNSHIP POSTINGS**
### **SPRINT ROLE ASSIGNMENTS**

| Role | Owner |
| --- | --- |
| **Scrum Master** | Jude Joyson |
| **Developer #1** | Aref Khondaker |
| **Developer #2** | Tangil Khondaker |
| **Tester #1** | Ian Koratsky |
| **Tester #2** | Connor Kouznetsov |

## **GLOBAL OBJECTIVE | SPRINT #6 | October 21, 2026 → October 28, 2026**

Implement the foundational capability for logged-in users to post job and internship listings on the InCollege platform. The existing "Search for a job" menu option, previously an "under construction" message, becomes functional. Listings capture essential details and are stored persistently so they survive closing and reopening the application. Students can also save jobs they are interested in, unmark them, and see that list again on a later login.

All input continues to be read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

## **FOCUS AREAS**

### **1. Job Search/Internship Menu**

- Selecting `1. Search for a job` from the post-login menu opens `--- Job Search/Internship Menu ---` with:
  - `1. Post a Job/Internship`
  - `2. Browse Jobs/Internships`
  - `3. Back to Main Menu`
- `Post a Job/Internship` starts the job posting flow (Focus Area 2).
- `Browse Jobs/Internships` remains under construction this sprint. It displays `Browse Jobs/Internships is under construction.` and returns to the Job Search/Internship menu.
- `Back to Main Menu` returns the user to the top-level post-login menu.
- After a job is posted, the user is returned to the Job Search/Internship menu.

### **2. Capturing Job Details**

When the user selects `Post a Job/Internship`, display `--- Post a New Job/Internship ---` and prompt for each field in this order, reading every answer from the input file:

| Field | Prompt | Required | Notes |
| --- | --- | --- | --- |
| **Job Title** | `Enter Job Title:` | Yes | e.g., "Software Intern", "Data Analyst" |
| **Description** | `Enter Description (max 200 chars):` | Yes | Brief text description of the role; 200-character limit |
| **Employer** | `Enter Employer Name:` | Yes | Company or organization name |
| **Location** | `Enter Location:` | Yes | e.g., "Remote", "New York, NY" |
| **Salary** | `Enter Salary (optional, enter 'NONE' to skip):` | No | e.g., "$100,000/year", "$50/hour"; `NONE` stores the posting without a salary |

- A required field left blank must be rejected with a clear error message and must not create a posting (no partial records).
- Input longer than a field's PIC length must be handled predictably (truncated or rejected) and the behavior documented.
- On success, display `Job posted successfully!`.

### **3. Posting Persistence**

- Define a new sequential data file dedicated to job and internship listings, distinct from the user profile, pending request, and connection files.
- Each record holds: a unique sequential Job ID, the posting user's username, Job Title, Description, Employer, Location, and Salary.
- The next Job ID is derived from the existing file on startup so IDs stay unique and increasing across restarts.
- New postings are appended. Existing postings must never be overwritten or lost when the program is closed and reopened.
- Associating each posting with its creator is the intended design. Storing the listing is the primary goal this sprint.

### **4. Saving Jobs You Are Interested In**

- A student can mark a job as "saved" when interested but not ready to apply.
- A student can generate a list of the jobs they have saved.
- A student can unmark a saved job.
- Saved jobs are persisted in a separate data structure, e.g., username + Job ID pairs, so the list is retained and displayed the next time the student logs in.
- A user must not be able to save the same job twice, and the saved list is per-user.
- Applied-for jobs are mentioned in the requirement as retained data. Applying is not defined for this sprint, so any storage for it is scoped by the team through JIRA.
- Because Browse Jobs/Internships stays under construction, the entry point for save, list, and unmark is a team decision and must be recorded in the Jira story and README.

### **5. I/O Requirements**

- **Input:** Read menu selections and all job detail fields from a predefined input file.
- **Output display:** Display menus, prompts, confirmations, errors, and the under-construction message on standard output.
- **Output preservation:** Write the exact displayed output to a separate output file for testing and record-keeping. Console output and the output file must be identical for all job posting scenarios.

### **6. Implementation Notes**

- Place the job posting code in the copybook `JOBS_SRC` (`Jobs.cob`) and the browse code in `BROWSEJOBS_SRC` (`BrowseJobs.cob`).
- Job posting data structure: a sequential file with fields for Job ID, poster username, Title, Description, Employer, Location, and Salary.
- File I/O: implement COBOL file operations to write new postings to persistent storage.
- Input handling: prompt for each field, validate required fields, and store the values correctly. All values come from the designated input file.
- Output handling: every prompt and confirmation is displayed on screen and identically written to the output file.
- Menu integration: add the Job Search/Internship submenu to the existing main menu path. The Browse option keeps its under-construction message.
- The program must integrate with all previous epics' functionality (login, profile, user search, skills, connection requests, network, 10-user account limit).

## **TESTING FOCUS**

Testers create test cases in Jira covering the following. Positive, negative, and edge cases are required for each story.

| Area | Scenarios |
| --- | --- |
| **Positive** | Post a job with all required fields; post a job with optional salary included; post a job with salary `NONE` |
| **Negative** | Missing required fields (title, description, employer, location each blank in turn); input exceeding PIC limits; invalid menu choices in the job menu |
| **Edge cases** | Description of exactly 200 characters and 201 characters; multiple postings in one run; postings by different users; input file ending mid-posting |
| **Navigation** | Main menu → Job menu → Post → back to Job menu; Browse shows under-construction message; Back to Main Menu returns to top level |
| **Persistence** | Posted jobs remain in the data file after restart; Job IDs continue sequentially after restart; posting user recorded on each record |
| **Saved jobs** | Save a job; list saved jobs; unmark a job; saved list retained after logout and restart |
| **I/O consistency** | All inputs read from the input file; console output identical to the output file for every scenario |
| **Regression** | Login, profile, search, skills, send/view requests, accept/reject, and network display still work |

Test inputs are submitted as `Epic6-Storyx-Test-Input.zip` and actual outputs as `Epic6-Storyx-Test-Output.zip`. Every discrepancy requires a Jira bug ticket with steps to reproduce, actual result, and expected result.

## **USER STORIES & TESTER #2 SUBTASKS**

### **Posting Jobs**

- "As a logged-in user, I want to post a new job or internship listing so I can recruit for my company/organization."
- "As a user posting a job, I want to enter a job title, description, employer, and location."
- "As a user posting a job, I want the option to include a salary for the listing."
- "As a user, I want my posted job listings to be saved persistently."
- "As a user, I want the 'Job search/internship' menu option to allow me to post jobs."

### **Testing Stories**

| Story | Owner | Subtasks |
| --- | --- | --- |
| "As a tester, I want the program to read all user inputs for job posting from a file so I can automate testing." | **Tester #2 (Connor Kouznetsov)** | 1. "Update COBOL I/O for job posting features to read from InCollege-Input.txt"<br>2. "Execute test cases using the automated input files" |
| "As a tester, I want the program to write all screen output related to job posting to a file so I can easily verify results." | Tracked in [JIRA.md](../JIRA.md) | Tracked in [JIRA.md](../JIRA.md) |

The step-by-step procedure for Tester #2's subtasks is in `EPIC-6-TESTER2-SCRIPT.txt`.

## **DELIVERABLES**

- `Roles.txt`, `InCollege.cob`, `InCollege-Input.txt`, `InCollege-Output.txt`
- `Epic6-Storyx-Test-Input.zip` and `Epic6-Storyx-Test-Output.zip`
- `Jira.jpg` (updated board), two burndown charts (Monday and sprint completion), and `GitHub.jpg` (commit history)
- `README.md` updated with how to prepare job posting input and where to find the output

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 6 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.
