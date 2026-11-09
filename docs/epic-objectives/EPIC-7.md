# **EPIC #7: BROWSE & APPLY TO JOBS/INTERNSHIPS (WITH APPLICATION REPORT)**
### **SPRINT ROLE ASSIGNMENTS**

| Role | Owner |
| --- | --- |
| **Scrum Master** | Connor Kouznetsov |
| **Developer #1** | Jude Joyson |
| **Developer #2** | Aref Khondaker |
| **Tester #1** | Tangil Khondaker |
| **Tester #2** | Ian Koratsky |

## **GLOBAL OBJECTIVE | SPRINT #7 | October 28, 2026 → November 4, 2026**

Complete the basic job board by allowing users to browse all available job and internship listings, view the full details of a listing, simulate applying for it, and generate a summary report of their own applications. The `Browse Jobs/Internships` option, previously an "under construction" message, becomes fully functional. This work continues Jira Epic #4: Job Board Functionality, started in Epic 6.

All input continues to be read from a file, displayed output is written to the screen, and the same output is preserved in an output file.

## **FOCUS AREAS**

### **1. Job/Internship Browse**

- Selecting `Browse Jobs/Internships` from the `--- Job Search/Internship Menu ---` displays `--- Available Job Listings ---`, a list of all job and internship postings created in Epic 6.
- Each listing shows at least the Job Title, Employer, and Location, in the format `Software Intern at TechCorp (New York, NY)`.
- The list is followed by a separator line and the prompt `Enter job number to view details, or 0 to go back:`.
- Entering `0` leaves the list and returns to the Job Search/Internship menu, as shown in the sample output.
- An empty job file must display a clear message and return the user to the Job Search/Internship menu without a crash.

### **2. Viewing Full Job Details**

- The user selects a listing by its number to display `--- Job Details ---` with:
  - `Title:`
  - `Description:`
  - `Employer:`
  - `Location:`
  - `Salary:` (shown when provided)
- The details are followed by a separator line and the options `Apply for this Job` and `Back to Job List`, with the prompt `Enter your choice:`.
- Selecting a number that does not exist must produce an error message and re-display the list without a crash. Zero, non-numeric, and out-of-range values must all be handled.
- `Back to Job List` returns to `--- Available Job Listings ---`.

### **3. Simulated Application Process**

- Choosing `Apply for this Job` registers the logged-in user's interest in that specific job. No resume or cover letter is required in this alpha version.
- Display a confirmation using the job's actual values, for example `Your application for Software Intern at TechCorp has been submitted.`
- After applying, the user is returned to `--- Available Job Listings ---`, as shown in the sample output.
- Record the application persistently in a new data structure that links the applying user's username to the specific job posting, for example by job ID. Applications must survive closing and reopening the application.
- The PDF does not state what happens when a user applies to the same job twice. The team must decide and document the rule (for example, block it with a clear message).

### **4. Job Application Summary Report Generation**

- Add `View My Applications` to the Job Search/Internship menu. The menu now offers:
  - `Post a Job/Internship`
  - `Browse Jobs/Internships`
  - `View My Applications`
  - `Back to Main Menu`
- The report lists only the applications of the currently logged-in user and is displayed in this layout:
  - Header: `--- Your Job Applications ---`
  - Subheader: `Application Summary for <username>`
  - A separator line, then one block per application showing `Job Title:`, `Employer:`, and `Location:`, with `---` between blocks
  - A closing separator, `Total Applications: N`, and a final separator
- A unique identifier for the application or job may also be shown (optional per the PDF).
- The report must handle a user with no applications, one application, and multiple applications.
- The PDF says the report can be requested after applying or from the new menu option. The sample output shows only the menu path, so the menu option is the required entry point unless the team decides otherwise.
- The report must be displayed on screen and written to the output file identically.

### **5. I/O Requirements**

- **Input:** Read menu selections, job number selections, apply choices, and report requests from a predefined input file.
- **Output display:** Display menus, job lists, job details, confirmation messages, the application report, and errors on standard output.
- **Output preservation:** Write the exact displayed output to a separate output file for testing and record-keeping. Console output and the output file must be identical for all job browse, application, and report scenarios.

### **6. Implementation Notes**

- Place the apply code in the copybook `APPLYJOB_SRC` (`ApplyJob.cob`) and the report code in `VIEWAPPS_SRC` (`ViewApplications.cob`). The PDF describes these as the Browse and Apply Jobs copybooks, but Browse already lives in `BROWSEJOBS_SRC` (`BrowseJobs.cob`) from Epic 6, so the team should confirm where the new browse code goes.
- Job listing retrieval and display: read all job postings from the persistent storage created in Epic 6 and display them in a list format.
- Detailed job display: retrieve and display the full details of the selected posting.
- Application data structure: a new sequential file, or an addition to an existing one, with fields linking the applying username to the specific job posting (job ID or a combination of job details).
- File I/O for applications: implement COBOL file operations to write new application records to persistent storage.
- Report generation module: read the persistent application data, filter to the logged-in user, resolve job details for display, format the header, detail lines, and total count, and use DISPLAY for the screen and WRITE for the output file at the same time.
- Menu integration: Browse navigates correctly, the Apply option appears on the details screen, and `View My Applications` is added to the Job Search/Internship menu.
- The program must integrate with all previous epics' functionality (login, profile, user search, skills, connection requests, network, job posting, and saved jobs).

## **TESTING FOCUS**

Testers create test cases in Jira covering the following. Positive, negative, and edge cases are required for each story.

| Area | Scenarios |
| --- | --- |
| **Browse jobs** | Empty job list; list with one job; list with multiple jobs; `0` returns to the Job Search/Internship menu |
| **Viewing job details** | Select existing jobs; select non-existent job numbers; non-numeric input; Back to Job List returns to the list |
| **Applying to jobs** | Successfully apply to a job; confirmation shows the correct title and employer; apply to multiple jobs; duplicate application per the team's rule |
| **Report generation** | No applications, one application, and multiple applications; verify the header, detail lines, separators, and total count; report shows only the logged-in user's applications |
| **Persistence** | Applications and the data used for the report persist across program restarts; earlier records are unchanged by new applications |
| **I/O consistency** | All inputs read from the input file; console output identical to the output file for every browse, application, and report scenario |
| **Regression** | Login, profile, search, skills, connections, network, and Epic 6 job posting still work |

Test inputs are submitted as `Epic7-Storyx-Test-Input.zip` and actual outputs as `Epic7-Storyx-Test-Output.zip`. Every discrepancy requires a Jira bug ticket with steps to reproduce, actual result, and expected result.

## **DELIVERABLES**

- `Roles.txt`, `InCollege.cob`, `InCollege-Input.txt`, `InCollege-Output.txt`
- `Epic7-Storyx-Test-Input.zip` and `Epic7-Storyx-Test-Output.zip`
- `Jira.jpg` (updated board), two burndown charts (Monday and sprint completion), and `GitHub.jpg` (commit history)
- `README.md` updated with how to prepare browse, apply, and report input and where to find the output, including the new report

## **GIT ISSUES & SIGN-OFF REFERENCE**

Track implementation, test evidence, defects, and documentation changes in [GIT-ISSUES.md](../GIT-ISSUES.md).

Before Epic 7 work is included in the final ZIP, the linked Git issue must identify the affected files, Jira issue, validation command, and output evidence, and must receive the required Developer, Tester, and active Sprint Scrum Master approvals.

Use the role assignments above when resolving questions about ownership. Use [JIRA.md](../JIRA.md) for Epic hierarchy and acceptance criteria questions, and [PROCEDURES.md](../PROCEDURES.md) for handoff, testing, and sprint-closeout questions.