
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INCOLLEGE-CORE IS INITIAL PROGRAM.
       DATE-WRITTEN. 9/3/2026.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-FILE ASSIGN TO WS-INPUT-FILE
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-INPUT-STAT.

           SELECT OUTPUT-FILE ASSIGN TO WS-OUTPUT-FILE
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-OUTPUT-STAT.

           SELECT OPTIONAL ACCOUNTS-FILE ASSIGN TO WS-ACCOUNTS-FILE
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-ACCOUNTS-STAT.

           SELECT PROFILES-FILE ASSIGN TO "Profiles.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROFILES-STAT.

       DATA DIVISION.
       FILE SECTION.
       FD IN-FILE.
       01 INPUT-LINE    PIC X(100).

       FD OUTPUT-FILE.
       01 OUTPUT-LINE   PIC X(100).

       FD ACCOUNTS-FILE.
       01 ACCOUNT-INSTANCE.
           05 ACC-USERNAME  PIC X(20).
           05 ACC-PASSWORD  PIC X(20).

      *    EPIC 2 PROFILE FILE FIELD INFORMATION
       FD PROFILES-FILE.
       01  PROFILE-INSTANCE.
           05 PROF-USER        PIC X(20).
           05 PROF-FIRST-NAME  PIC X(20).
           05 PROF-LAST-NAME   PIC X(20).
           05 PROF-SCHOOL      PIC X(50).
           05 PROF-MAJOR       PIC X(30).
           05 PROF-GRAD-YEAR   PIC 9(4).
           05 PROF-ABOUT       PIC X(200).
           05 PROF-EXP-CNT   PIC 9.
           05 PROF-EXP-INST OCCURS 3 TIMES.
               10 EXP-TITLE   PIC 9(20).
               10 EXP-ORGAN   PIC X(50).
               10 EXP-DATES   PIC X(35).
               10 EXP-DESCR   PIC X(100).
           05 PROF-EDU-CNT  PIC 9.
           05 PROF-TOTAL-EDU  OCCURS 3 TIMES.
               10 EDU-DEGREE  PIC X(35).
               10 EDU-SCHOOL  PIC X(50).
               10 EDU-YEARS   PIC X(35).
           05 HAS-PROF        PIC X.




       WORKING-STORAGE SECTION.

       01 WS-INPUT-STAT     PIC XX.
       01 WS-OUTPUT-STAT    PIC XX.

       01 WS-ACCOUNTS-FILE PIC X(100).

       01 WS-ACCOUNTS-STAT PIC XX.

       01 WS-INPUT-EOF    PIC X   VALUE "N".
           88  END-OF-INPUT        VALUE "Y".
       01 WS-ACCOUNTS-EOF PIC X   VALUE "N".
           88  END-OF-ACCOUNTS     VALUE "Y".
       01 WS-LOGGED-IN    PIC X   VALUE "N".
           88 LOGGED-IN         VALUE "Y".
       01 WS-RUNNING      PIC X   VALUE "Y".
           88 STILL-RUNNING        VALUE "Y".


       01 WS-TOTAL-ACCOUNTS     PIC 9       VALUE 0.
       01 WS-ACCOUNTS.
           05   WS-ACCOUNT-ENTRY OCCURS 5 TIMES.
               10   WS-USERNAME     PIC X(20).
               10   WS-PASSWORD     PIC X(20).

       01 WS-INPUT-LINE     PIC X(100).
       01 WS-INPUT-FILE  PIC X(100).
       01 WS-OUTPUT-LINE    PIC X(100).
       01 WS-OUTPUT-FILE PIC X(100).
       01 WS-CHOICE         PIC X(5).
       01 WS-NEW-USER       PIC X(20).
       01 WS-NEW-PASS       PIC X(12).
       01 WS-LOGIN-USER     PIC X(20).
       01 WS-LOGIN-PASS     PIC X(12).

       01 WS-VALID-PASS     PIC X      VALUE "Y".
           88 PASSWORD-VALID           VALUE "Y".

       01 WS-INDEX          PIC 9      VALUE 0.

       01  WS-SEARCH-USERNAME   PIC X(20).
       01  WS-ACCOUNT-FOUND     PIC X       VALUE "N".
           88  ACCOUNT-FOUND                VALUE "Y".
       01  WS-FOUND-INDEX       PIC 9       VALUE 0.
       01  WS-SEARCH-IDX        PIC 9.

       01  WS-CHECK-PASSWORD    PIC X(20).
       01  WS-PASSWORD-MATCH    PIC X       VALUE "N".
           88  PASSWORD-MATCHES             VALUE "Y".

       01  WS-USER-LEN           PIC 9(3).
       01  WS-PW-LEN             PIC 9(3).
       01  WS-PW-IDX             PIC 9(3).
       01  WS-PW-CHAR            PIC X.
       01  WS-HAS-UPPER          PIC X       VALUE "N".
       01  WS-HAS-DIGIT          PIC X       VALUE "N".
       01  WS-HAS-SPECIAL        PIC X       VALUE "N".

       01  WS-SKILL-GO-BACK      PIC X       VALUE "N".
           88  SKILL-GO-BACK                 VALUE "Y".

      *    EPIC 2 WS SECTION
       01  WS-PROFILES-STAT     PIC XX.
       01  WS-PROFILES-EOF      PIC X       VALUE "N".
           88 END-OF-PROFILES               VALUE "Y".

       01 WS-PROFILES.
           05 WS-PROFILE-INST OCCURS 5 TIMES.
               10 WS-PROF-USER        PIC X(20).
               10 WS-PROF-FIRST-NAME  PIC X(20).
               10 WS-PROF-LAST-NAME   PIC X(20).
               10 WS-PROF-SCHOOL      PIC X(50).
               10 WS-PROF-MAJOR       PIC X(30).
               10 WS-PROF-GRAD-YEAR   PIC 9(4).
               10 WS-PROF-ABOUT       PIC X(200).
               10 WS-PROF-EXP-CNT     PIC 9    VALUE 0.
               10 WS-PROF-EXP-INST OCCURS 3 TIMES.
                   15 WS-EXP-TITLE    PIC 9(20).
                   15 WS-EXP-ORGAN    PIC X(50).
                   15 WS-EXP-DATES    PIC X(35).
                   15 WS-EXP-DESCR    PIC X(100).
               10 WS-PROF-EDU-CNT     PIC 9    VALUE 0.
               10 WS-PROF-TOTAL-EDU   OCCURS 3 TIMES.
                   15 WS-EDU-DEGREE   PIC X(35).
                   15 WS-EDU-SCHOOL   PIC X(50).
                   15 WS-EDU-YEARS    PIC X(35).
               10 WS-HAS-PROF         PIC X    VALUE "N".
                   88 WS-PROF-EXISTS           VALUE "Y".


       01 WS-PROF-IDX      PIC 9       VALUE 0.
       01 WS-EXP-IDX       PIC 9       VALUE 0.
       01 WS-EDU-IDX       PIC 9       VALUE 0.
       01 WS-FIELD-LEN     PIC 9(3)    VALUE 0.


       01  WS-VALID-RESPONSE    PIC X       VALUE "N".
           88 VALIDATED                    VALUE "Y".



       LINKAGE SECTION.
       01  LS-INPUT   PIC X(100).
       01  LS-OUTPUT  PIC X(100).
       01  LS-ACOUNTS PIC X(100).

       PROCEDURE DIVISION USING LS-INPUT LS-OUTPUT LS-ACOUNTS.

           MOVE LS-INPUT TO WS-INPUT-FILE
           MOVE LS-OUTPUT TO WS-OUTPUT-FILE
           MOVE LS-ACOUNTS TO WS-ACCOUNTS-FILE

           PERFORM START-FILES
           MOVE "Welcome to InCollege!" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           PERFORM UNTIL LOGGED-IN OR END-OF-INPUT
               PERFORM LOG-IN-SCREEN
           END-PERFORM

           IF LOGGED-IN
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "Welcome, " FUNCTION TRIM(WS-LOGIN-USER) "!"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF

           PERFORM UNTIL (NOT STILL-RUNNING) OR END-OF-INPUT
               PERFORM SITE-MENU
           END-PERFORM

           PERFORM CLOSE-FILES
           MOVE "---END_OF_PROGRAM---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           GOBACK.




       START-FILES.
           OPEN INPUT IN-FILE
           IF WS-INPUT-STAT NOT = "00"
                DISPLAY "Error opening input file: " WS-INPUT-FILE
                DISPLAY "File status: " WS-INPUT-STAT
               STOP RUN
           END-IF.

           OPEN OUTPUT OUTPUT-FILE
           IF WS-OUTPUT-STAT NOT = "00"
               DISPLAY "ERROR: cannot open output file: " WS-OUTPUT-FILE
                DISPLAY "  FILE STATUS: " WS-OUTPUT-STAT
               STOP RUN
           END-IF.


           OPEN INPUT ACCOUNTS-FILE
           IF WS-ACCOUNTS-STAT = "00"
               PERFORM UNTIL END-OF-ACCOUNTS OR WS-TOTAL-ACCOUNTS > 5
                   READ ACCOUNTS-FILE INTO ACCOUNT-INSTANCE
                       AT END
                           MOVE "Y" TO WS-ACCOUNTS-EOF
                       NOT AT END
                           ADD 1 TO WS-TOTAL-ACCOUNTS
                           MOVE ACC-USERNAME
                               TO WS-USERNAME(WS-TOTAL-ACCOUNTS)
                           MOVE ACC-PASSWORD
                               TO WS-PASSWORD(WS-TOTAL-ACCOUNTS)
                   END-READ
               END-PERFORM
           END-IF
           CLOSE ACCOUNTS-FILE

           OPEN INPUT PROFILES-FILE
           IF WS-PROFILES-STAT = "00"
               PERFORM UNTIL END-OF-PROFILES OR WS-PROF-IDX > 5
                   READ PROFILES-FILE INTO PROFILE-INSTANCE
                       AT END
                           MOVE "Y" TO WS-PROFILES-EOF
                       NOT AT END
                           ADD 1 TO WS-PROF-IDX
                           MOVE PROF-USER
                               TO WS-PROF-USER(WS-PROF-IDX)
                           MOVE PROF-FIRST-NAME
                               TO WS-PROF-FIRST-NAME(WS-PROF-IDX)
                           MOVE PROF-LAST-NAME
                               TO WS-PROF-LAST-NAME(WS-PROF-IDX)
                           MOVE PROF-SCHOOL
                               TO WS-PROF-SCHOOL(WS-PROF-IDX)
                           MOVE PROF-MAJOR
                               TO WS-PROF-MAJOR(WS-PROF-IDX)
                           MOVE PROF-GRAD-YEAR
                               TO WS-PROF-GRAD-YEAR(WS-PROF-IDX)
                           MOVE PROF-ABOUT
                               TO WS-PROF-ABOUT(WS-PROF-IDX)
                           MOVE PROF-EXP-CNT
                               TO WS-PROF-EXP-CNT(WS-PROF-IDX)
                           PERFORM VARYING WS-EXP-IDX FROM 1 BY 1
                                   UNTIL WS-EXP-IDX > 3
                               MOVE EXP-TITLE(WS-EXP-IDX)
                                   TO WS-EXP-TITLE(WS-PROF-IDX,
                                       WS-EXP-IDX)
                               MOVE EXP-ORGAN(WS-EXP-IDX)
                                   TO WS-EXP-ORGAN(WS-PROF-IDX,
                                       WS-EXP-IDX)
                               MOVE EXP-DATES(WS-EXP-IDX)
                                   TO WS-EXP-DATES(WS-PROF-IDX,
                                       WS-EXP-IDX)
                               MOVE EXP-DESCR(WS-EXP-IDX)
                                   TO WS-EXP-DESCR(WS-PROF-IDX,
                                       WS-EXP-IDX)
                           END-PERFORM
                           MOVE PROF-EDU-CNT
                               TO WS-PROF-EDU-CNT(WS-PROF-IDX)
                           PERFORM VARYING WS-EDU-IDX FROM 1 BY 1
                                   UNTIL WS-EDU-IDX > 3
                               MOVE EDU-DEGREE(WS-EDU-IDX)
                                   TO WS-EDU-DEGREE(WS-PROF-IDX,
                                       WS-EDU-IDX)
                               MOVE EDU-SCHOOL(WS-EDU-IDX)
                                   TO WS-EDU-SCHOOL(WS-PROF-IDX,
                                       WS-EDU-IDX)
                               MOVE EDU-YEARS(WS-EDU-IDX)
                                   TO WS-EDU-YEARS(WS-PROF-IDX,
                                       WS-EDU-IDX)
                           END-PERFORM
                           MOVE HAS-PROF
                               TO WS-HAS-PROF(WS-PROF-IDX)
                   END-READ
               END-PERFORM
           END-IF
           CLOSE PROFILES-FILE.


       CLOSE-FILES.
           CLOSE IN-FILE
           CLOSE OUTPUT-FILE.

       WRITE-OUTPUT.
           DISPLAY WS-OUTPUT-LINE
           WRITE OUTPUT-LINE FROM WS-OUTPUT-LINE.

       READ-INPUT.
           READ IN-FILE INTO WS-INPUT-LINE
               AT END
                   MOVE "Y" TO WS-INPUT-EOF
                   MOVE SPACES TO WS-INPUT-LINE
           END-READ
           IF NOT END-OF-INPUT
               MOVE WS-INPUT-LINE TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF.

       LOG-IN-SCREEN.
           MOVE "1. Log-In" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "2. Create New Account" To WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "Enter your choice:" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           PERFORM READ-INPUT
           IF NOT END-OF-INPUT
               MOVE WS-INPUT-LINE TO WS-CHOICE
               EVALUATE WS-CHOICE
                   WHEN "1"
                       PERFORM LOG-IN
                   WHEN "2"
                       PERFORM CREATE-ACCOUNT
                   WHEN OTHER
                       MOVE "Invalid Option, Try Again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
               END-EVALUATE
           END-IF.

       LOG-IN.
           PERFORM UNTIL LOGGED-IN OR END-OF-INPUT
               MOVE "Please enter your username:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE WS-INPUT-LINE TO WS-LOGIN-USER
                   MOVE WS-LOGIN-USER TO WS-SEARCH-USERNAME
                   PERFORM FIND-ACCOUNT-BY-USERNAME

                   MOVE "Please enter your password:" TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
                   PERFORM READ-INPUT
                   IF NOT END-OF-INPUT
                       MOVE WS-INPUT-LINE TO WS-LOGIN-PASS
                       MOVE WS-LOGIN-PASS TO WS-CHECK-PASSWORD

                       IF ACCOUNT-FOUND
                           PERFORM CHECK-PASSWORD-FOR-INDEX
                       ELSE
                           MOVE "N" TO WS-PASSWORD-MATCH
                       END-IF

                       IF PASSWORD-MATCHES
                           MOVE "You have successfully logged in."
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                           MOVE "Y" TO WS-LOGGED-IN
                       ELSE
                           MOVE
           "Incorrect username/password, please try again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.


       CREATE-ACCOUNT.
           IF WS-TOTAL-ACCOUNTS >= 5
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "All permitted accounts have been created, "
                      "please come back later"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               END-STRING
               PERFORM WRITE-OUTPUT
           ELSE
               MOVE "Please enter your username:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               MOVE WS-INPUT-LINE TO WS-NEW-USER

               COMPUTE WS-USER-LEN =
                   FUNCTION LENGTH(FUNCTION TRIM (WS-INPUT-LINE))

               MOVE WS-NEW-USER TO WS-SEARCH-USERNAME
               PERFORM FIND-ACCOUNT-BY-USERNAME

               IF ACCOUNT-FOUND
                   MOVE
           "That username is already taken, please try again"
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               ELSE
                   IF WS-USER-LEN = 0
                       MOVE "Blank Usernames not allowed"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   ELSE
                       MOVE "Please enter your password:"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                       PERFORM READ-INPUT
                       MOVE WS-INPUT-LINE TO WS-NEW-PASS

                       PERFORM PASSWORD-VALIDATION

                       IF PASSWORD-VALID
                           MOVE WS-INPUT-LINE TO WS-NEW-PASS
                           ADD 1 TO WS-TOTAL-ACCOUNTS
                           MOVE WS-NEW-USER
                               TO WS-USERNAME(WS-TOTAL-ACCOUNTS)
                           MOVE WS-NEW-PASS
                               TO WS-PASSWORD(WS-TOTAL-ACCOUNTS)
                           PERFORM SAVE-TO-ACCOUNTS
                           MOVE "Account Created!" TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                           MOVE WS-TOTAL-ACCOUNTS TO WS-FOUND-INDEX
                       ELSE
                           MOVE
               "Password doesn't satisfy requirements, try again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                       END-IF
                   END-IF
               END-IF
           END-IF.

       PASSWORD-VALIDATION.
           MOVE "N" TO WS-HAS-UPPER
           MOVE "N" TO WS-HAS-DIGIT
           MOVE "N" TO WS-HAS-SPECIAL
           MOVE "N" TO WS-VALID-PASS
           COMPUTE WS-PW-LEN =
               FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-LINE))

           IF WS-PW-LEN >= 8 AND WS-PW-LEN <= 12
               PERFORM VARYING WS-PW-IDX FROM 1 BY 1
                       UNTIL WS-PW-IDX > WS-PW-LEN
                   MOVE WS-INPUT-LINE(WS-PW-IDX:1) TO WS-PW-CHAR
                   IF WS-PW-CHAR >= "A" AND WS-PW-CHAR <= "Z"
                       MOVE "Y" TO WS-HAS-UPPER
                   END-IF
                   IF WS-PW-CHAR >= "0" AND WS-PW-CHAR <= "9"
                       MOVE "Y" TO WS-HAS-DIGIT
                   END-IF
                   IF NOT (WS-PW-CHAR >= "A" AND WS-PW-CHAR <= "Z")
                      AND NOT (WS-PW-CHAR >= "a" AND WS-PW-CHAR <= "z")
                      AND NOT (WS-PW-CHAR >= "0" AND WS-PW-CHAR <= "9")
                      AND WS-PW-CHAR NOT = SPACE
                       MOVE "Y" TO WS-HAS-SPECIAL
                   END-IF
               END-PERFORM

               IF WS-HAS-UPPER = "Y" AND WS-HAS-DIGIT = "Y"
                  AND WS-HAS-SPECIAL = "Y"
                   MOVE "Y" TO WS-VALID-PASS
               END-IF
           END-IF.

       SAVE-TO-ACCOUNTS.
           OPEN OUTPUT ACCOUNTS-FILE
           PERFORM VARYING WS-INDEX FROM 1 BY 1
                   UNTIL WS-INDEX > WS-TOTAL-ACCOUNTS
               MOVE WS-USERNAME(WS-INDEX) TO ACC-USERNAME
               MOVE WS-PASSWORD(WS-INDEX) TO ACC-PASSWORD
               WRITE ACCOUNT-INSTANCE
           END-PERFORM
           CLOSE ACCOUNTS-FILE.

       SAVE-TO-PROFILES.
           OPEN OUTPUT PROFILES-FILE
           PERFORM VARYING WS-INDEX FROM 1 BY 1
                   UNTIL WS-INDEX > WS-PROF-IDX
               MOVE WS-PROF-USER(WS-PROF-IDX) TO PROF-USER
               MOVE WS-PROF-FIRST-NAME(WS-PROF-IDX) TO PROF-FIRST-NAME
               MOVE WS-PROF-LAST-NAME(WS-PROF-IDX) TO PROF-LAST-NAME
               MOVE WS-PROF-SCHOOL(WS-PROF-IDX) TO PROF-SCHOOL
               MOVE WS-PROF-MAJOR(WS-PROF-IDX) TO PROF-MAJOR
               MOVE WS-PROF-GRAD-YEAR(WS-PROF-IDX) TO PROF-GRAD-YEAR
               MOVE WS-PROF-ABOUT(WS-PROF-IDX) TO PROF-ABOUT
               MOVE WS-PROF-EXP-CNT(WS-PROF-IDX) TO PROF-EXP-CNT
               PERFORM VARYING WS-EXP-IDX FROM 1 BY 1
                       UNTIL WS-EXP-IDX > 3
                   MOVE WS-EXP-TITLE(WS-PROF-IDX, WS-EXP-IDX)
                       TO EXP-TITLE(WS-EXP-IDX)
                   MOVE WS-EXP-ORGAN(WS-PROF-IDX, WS-EXP-IDX)
                       TO EXP-ORGAN(WS-EXP-IDX)
                   MOVE WS-EXP-DATES(WS-PROF-IDX, WS-EXP-IDX)
                       TO EXP-DATES(WS-EXP-IDX)
                   MOVE WS-EXP-DESCR(WS-PROF-IDX, WS-EXP-IDX)
                       TO EXP-DESCR(WS-EXP-IDX)
               END-PERFORM
               MOVE WS-PROF-EDU-CNT(WS-PROF-IDX) TO PROF-EDU-CNT
               PERFORM VARYING WS-EDU-IDX FROM 1 BY 1
                       UNTIL WS-EDU-IDX > 3
                   MOVE WS-EDU-DEGREE(WS-PROF-IDX, WS-EDU-IDX)
                       TO EDU-DEGREE(WS-EDU-IDX)
                   MOVE WS-EDU-SCHOOL(WS-PROF-IDX, WS-EDU-IDX)
                       TO EDU-SCHOOL(WS-EDU-IDX)
                   MOVE WS-EDU-YEARS(WS-PROF-IDX, WS-EDU-IDX)
                       TO EDU-YEARS(WS-EDU-IDX)
               END-PERFORM
               MOVE WS-HAS-PROF(WS-PROF-IDX) TO HAS-PROF
               WRITE PROFILE-INSTANCE
           END-PERFORM
           CLOSE PROFILES-FILE.

       FIND-ACCOUNT-BY-USERNAME.
           MOVE "N" TO WS-ACCOUNT-FOUND
           MOVE 0   TO WS-FOUND-INDEX
           PERFORM VARYING WS-SEARCH-IDX FROM 1 BY 1
                   UNTIL WS-SEARCH-IDX > WS-TOTAL-ACCOUNTS
               IF WS-USERNAME(WS-SEARCH-IDX) = WS-SEARCH-USERNAME
                   MOVE "Y" TO WS-ACCOUNT-FOUND
                   MOVE WS-SEARCH-IDX TO WS-FOUND-INDEX
               END-IF
           END-PERFORM.

       CHECK-PASSWORD-FOR-INDEX.
           MOVE "N" TO WS-PASSWORD-MATCH
           IF WS-PASSWORD(WS-FOUND-INDEX) = WS-CHECK-PASSWORD
               MOVE "Y" TO WS-PASSWORD-MATCH
           END-IF.

       SITE-MENU.
           MOVE "1. Create/Edit My Profile" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "2. View My Profile" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "3. Search for a job" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "4. Find someone you know" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "5. Learn a new skill" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "6. Logout" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "Enter your choice:" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           PERFORM READ-INPUT
           IF NOT END-OF-INPUT
               MOVE WS-INPUT-LINE TO WS-CHOICE
               EVALUATE WS-CHOICE
                   WHEN "1"
                       PERFORM CREATE-PROFILE
                   WHEN "2"
                       PERFORM VIEW-PROFILE
                   WHEN "3"
                       MOVE
           "Job search/internship is under construction."
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   WHEN "4"
                       MOVE
           "Find someone you know is under construction."
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   WHEN "5"
                       PERFORM SKILL-MENU-LOOP
                   WHEN "6"
                       MOVE "N" TO WS-RUNNING
                   WHEN OTHER
                       MOVE "Invalid Option, Try Again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
               END-EVALUATE
           END-IF.


       SKILL-MENU-LOOP.
           MOVE "N" TO WS-SKILL-GO-BACK
           PERFORM UNTIL SKILL-GO-BACK OR END-OF-INPUT
               MOVE "Learn a New Skill:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "1. Financial Literacy" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "2. Public Speaking" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "3. Time Management" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "4. Coding Fundamentals" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "5. Networking Skills" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "6. Go Back" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "Enter your choice:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT

               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE WS-INPUT-LINE TO WS-CHOICE
                   EVALUATE WS-CHOICE
                       WHEN "6"
                           MOVE "Y" TO WS-SKILL-GO-BACK
                       WHEN "1" THRU "5"
                           MOVE "This skill is under construction."
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                       WHEN OTHER
                           MOVE "Invalid Option, Try Again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                   END-EVALUATE
               END-IF
           END-PERFORM.

       CREATE-PROFILE.
           MOVE "---Create/Edit Profile---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           PERFORM GET-FIRST-NAME
           PERFORM GET-LAST-NAME
           PERFORM GET-SCHOOL
           PERFORM GET-MAJOR
           PERFORM GET-GRAD-YEAR
           PERFORM GET-ABOUT-ME
           PERFORM GET-EXPERIENCE
           PERFORM GET-EDUCATION

           MOVE "---Profile Created/Updated---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.


       VIEW-PROFILE.
           


       GET-FIRST-NAME.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter First Name: " TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   COMPUTE WS-FIELD-LEN =
                       FUNCTION LENGTH(FUNCTION TRIM (WS-INPUT-LINE))
                   IF WS-FIELD-LEN > 0
                       MOVE WS-INPUT-LINE
                           TO WS-PROF-FIRST-NAME(WS-FOUND-INDEX)
                       MOVE "Y" TO WS-VALID-RESPONSE
                   ELSE
                       MOVE "First Name cannot be blank, try again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.

       GET-LAST-NAME.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter Last Name: " TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   COMPUTE WS-FIELD-LEN =
                       FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-LINE))
                   IF WS-FIELD-LEN > 0
                       MOVE WS-INPUT-LINE
                           TO WS-PROF-LAST-NAME(WS-FOUND-INDEX)
                       MOVE "Y" TO WS-VALID-RESPONSE
                   ELSE
                       MOVE "Last Name cannot be blank, try again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.


       GET-SCHOOL.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter university name: " TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   COMPUTE WS-FIELD-LEN =
                       FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-LINE))
                   IF WS-FIELD-LEN > 0
                       MOVE WS-INPUT-LINE
                           TO WS-PROF-SCHOOL(WS-FOUND-INDEX)
                       MOVE "Y" TO WS-VALID-RESPONSE
                   ELSE
                       MOVE "University name cannot be blank"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.

       GET-MAJOR.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter the name of your major: " TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   COMPUTE WS-FIELD-LEN =
                       FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-LINE))
                   IF WS-FIELD-LEN > 0
                       MOVE WS-INPUT-LINE
                           TO WS-PROF-MAJOR(WS-FOUND-INDEX)
                       MOVE "Y" TO WS-VALID-RESPONSE
                   ELSE
                       MOVE "Major cannot be left blank"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.

        GET-GRAD-YEAR.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter Graduation Year (YYYY): " TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE FUNCTION TRIM(WS-INPUT-LINE) TO WS-INPUT-LINE
                   COMPUTE WS-FIELD-LEN =
                       FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-LINE))

                   IF WS-FIELD-LEN = 4
                       IF WS-INPUT-LINE IS NUMERIC
                           IF FUNCTION NUMVAL(WS-INPUT-LINE) > 2025
                               AND FUNCTION NUMVAL(WS-INPUT-LINE) < 2034
                               MOVE WS-INPUT-LINE
                                   TO WS-PROF-GRAD-YEAR(WS-FOUND-INDEX)
                               MOVE "Y" TO WS-VALID-RESPONSE
                           ELSE
                               MOVE
                 "Graduation year must be between 2026 and 2033"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                           END-IF
                       ELSE
                           MOVE
                 "Graduation year must be numeric, Please try again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                       END-IF
                   ELSE
                       MOVE
                 "Graduation year must be 4 digits, Please try again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.

       GET-ABOUT-ME.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter About Me (optional): " TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE FUNCTION TRIM(WS-INPUT-LINE) TO WS-INPUT-LINE
                   MOVE WS-INPUT-LINE
                       TO WS-PROF-ABOUT(WS-FOUND-INDEX)
                   MOVE "Y" TO WS-VALID-RESPONSE
               END-IF
           END-PERFORM.

       GET-EXPERIENCE.
           MOVE "N" TO WS-VALID-RESPONSE
           MOVE 0 TO WS-PROF-EXP-CNT(WS-FOUND-INDEX)
           PERFORM UNTIL VALIDATED OR (WS-PROF-EXP-CNT(WS-FOUND-INDEX)
                   > 3) OR END-OF-INPUT
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "Add Experience (optional, max 3 entries."
               "Enter 'DONE' to finish or any input to continue):"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   IF WS-INPUT-LINE = "DONE"
                       MOVE "Y" TO WS-VALID-RESPONSE
                       EXIT PERFORM
                   ELSE
                       ADD 1 TO WS-PROF-EXP-CNT(WS-FOUND-INDEX)
                       MOVE WS-PROF-EXP-CNT(WS-FOUND-INDEX)
                           TO WS-EXP-IDX
                       MOVE SPACES TO WS-OUTPUT-LINE
                       STRING "Experience #" WS-EXP-IDX " - Title: "
                           DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                       PERFORM READ-INPUT
                       IF NOT END-OF-INPUT
                           COMPUTE WS-FIELD-LEN = FUNCTION LENGTH(
                               FUNCTION TRIM(WS-INPUT-LINE))
                           IF WS-FIELD-LEN > 0
                               MOVE WS-INPUT-LINE
                                   TO WS-EXP-TITLE(WS-FOUND-INDEX,
                                       WS-EXP-IDX)
                           ELSE
                               MOVE "Title cannot be blank, try again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                               SUBTRACT 1 FROM 
                                   WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                               EXIT PERFORM CYCLE
                           END-IF
                       END-IF
                       MOVE SPACES TO WS-OUTPUT-LINE
                       STRING "Experience #" WS-EXP-IDX
                           " - Company/Organization: "
                               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                       PERFORM READ-INPUT
                       IF NOT END-OF-INPUT
                           COMPUTE WS-FIELD-LEN = FUNCTION LENGTH(
                               FUNCTION TRIM(WS-INPUT-LINE))
                           IF WS-FIELD-LEN > 0
                               MOVE WS-INPUT-LINE
                                   TO WS-EXP-ORGAN(WS-FOUND-INDEX,
                                       WS-EXP-IDX)
                           ELSE
                               MOVE "Company cannot be blank, try again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                               SUBTRACT 1 FROM 
                                   WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                               EXIT PERFORM CYCLE
                           END-IF
                       END-IF
                       MOVE SPACES TO WS-OUTPUT-LINE
                       STRING "Exp #" WS-EXP-IDX " - Years: "
                           DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                       PERFORM READ-INPUT
                       IF NOT END-OF-INPUT
                           COMPUTE WS-FIELD-LEN = FUNCTION LENGTH(
                               FUNCTION TRIM(WS-INPUT-LINE))
                           IF WS-FIELD-LEN > 0
                               MOVE WS-INPUT-LINE
                                   TO WS-EXP-DATES(WS-FOUND-INDEX,
                                       WS-EXP-IDX)
                           ELSE
                               MOVE "Years cannot be blank, try again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                               SUBTRACT 1 FROM
                                   WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                               EXIT PERFORM CYCLE
                           END-IF
                       END-IF
                       MOVE SPACES TO WS-OUTPUT-LINE
                       STRING "Exp #" WS-EXP-IDX
                           " - Description (optional, max 100 chars): "
                                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                       PERFORM READ-INPUT
                       IF NOT END-OF-INPUT
                           MOVE WS-INPUT-LINE
                               TO WS-EXP-DESCR(WS-FOUND-INDEX,
                                   WS-EXP-IDX)
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.



       GET-EDUCATION.
           MOVE "N" TO WS-VALID-RESPONSE
           MOVE 0 TO WS-PROF-EDU-CNT(WS-FOUND-INDEX)
           PERFORM UNTIL VALIDATED OR (WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                   >= 3) OR END-OF-INPUT
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "Add Education (optional, max 3 entries."
               " Enter 'DONE' to finish or any input to continue):"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   IF WS-INPUT-LINE = "DONE"
                       MOVE "Y" TO WS-VALID-RESPONSE
                       EXIT PERFORM
                   ELSE
                       ADD 1 TO WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                       MOVE WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                           TO WS-EDU-IDX

                       MOVE SPACES TO WS-OUTPUT-LINE
                       STRING "Education #" WS-EDU-IDX
                           " - Degree: "
                           DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                       PERFORM READ-INPUT
                       IF NOT END-OF-INPUT
                           COMPUTE WS-FIELD-LEN =
                               FUNCTION LENGTH(
                                   FUNCTION TRIM(WS-INPUT-LINE))
                           IF WS-FIELD-LEN > 0
                               MOVE WS-INPUT-LINE
                                   TO WS-EDU-DEGREE(WS-FOUND-INDEX,
                                       WS-EDU-IDX)
                           ELSE
                               MOVE "Degree cannot be blank, try again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                               SUBTRACT 1 FROM
                                   WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                               EXIT PERFORM CYCLE
                           END-IF
                       END-IF

                       IF NOT END-OF-INPUT
                           MOVE SPACES TO WS-OUTPUT-LINE
                           STRING "Education #" WS-EDU-IDX
                               " - University/College: "
                               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                           PERFORM READ-INPUT
                           IF NOT END-OF-INPUT
                               COMPUTE WS-FIELD-LEN =
                                   FUNCTION LENGTH(
                                       FUNCTION TRIM(WS-INPUT-LINE))
                               IF WS-FIELD-LEN > 0
                                   MOVE WS-INPUT-LINE
                                       TO WS-EDU-SCHOOL(WS-FOUND-INDEX,
                                           WS-EDU-IDX)
                               ELSE
                                   MOVE
                         "University blank, try again"
                                       TO WS-OUTPUT-LINE
                                   PERFORM WRITE-OUTPUT
                                   SUBTRACT 1 FROM
                                       WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                                   EXIT PERFORM CYCLE
                               END-IF
                           END-IF
                       END-IF

                       IF NOT END-OF-INPUT
                           MOVE SPACES TO WS-OUTPUT-LINE
                           STRING "Education #" WS-EDU-IDX
                               " - Years Attended: "
                               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                           PERFORM READ-INPUT
                           IF NOT END-OF-INPUT
                               COMPUTE WS-FIELD-LEN =
                                   FUNCTION LENGTH(
                                       FUNCTION TRIM(WS-INPUT-LINE))
                               IF WS-FIELD-LEN > 0
                                   MOVE WS-INPUT-LINE
                                       TO WS-EDU-YEARS(WS-FOUND-INDEX,
                                           WS-EDU-IDX)
                               ELSE
                                   MOVE
                         "Years Attended blank, try again"
                                       TO WS-OUTPUT-LINE
                                   PERFORM WRITE-OUTPUT
                                   SUBTRACT 1 FROM
                                       WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                                   EXIT PERFORM CYCLE
                               END-IF
                           END-IF
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.
