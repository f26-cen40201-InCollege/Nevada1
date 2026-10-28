
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

           SELECT OPTIONAL PROFILES-FILE ASSIGN TO "Profiles.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROFILES-STAT.

           SELECT OPTIONAL CONNECTIONS-FILE ASSIGN TO "Connections.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CONNECTIONS-STAT.

           SELECT OPTIONAL JOBS-FILE ASSIGN TO "Jobs.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-JOBS-STAT.

       DATA DIVISION.
       FILE SECTION.
       FD IN-FILE.
       01 INPUT-LINE    PIC X(250).

       FD OUTPUT-FILE.
       01 OUTPUT-LINE   PIC X(250).

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
               10 EXP-TITLE   PIC X(20).
               10 EXP-ORGAN   PIC X(50).
               10 EXP-DATES   PIC X(35).
               10 EXP-DESCR   PIC X(100).
           05 PROF-EDU-CNT  PIC 9.
           05 PROF-TOTAL-EDU  OCCURS 3 TIMES.
               10 EDU-DEGREE  PIC X(35).
               10 EDU-SCHOOL  PIC X(50).
               10 EDU-YEARS   PIC X(35).
           05 HAS-PROF        PIC X.

       FD CONNECTIONS-FILE.
       01 CONNECTION-INSTANCE.
           05 REQ-SENDER      PIC X(20).
           05 REQ-RECIPIENT   PIC X(20).
           05 REQ-STATUS      PIC X.

      *    EPIC 6 JOB FIELD INFORMATION
       FD JOBS-FILE.
       01 JOB-INSTANCE.
           05 JOB-ID          PIC 9(4).
           05 JOB-POSTER      PIC X(20).
           05 JOB-TITLE       PIC X(50).
           05 JOB-DESCR       PIC X(200).
           05 JOB-EMPLOYER    PIC X(50).
           05 JOB-LOCATION    PIC X(50).
           05 JOB-SALARY      PIC X(30).

       WORKING-STORAGE SECTION.

       01 WS-INPUT-STAT     PIC XX.
       01 WS-OUTPUT-STAT    PIC XX.
         01 WS-CONNECTIONS-STAT PIC XX.

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


       01 WS-TOTAL-ACCOUNTS     PIC 9(2)       VALUE 0.
       01 WS-ACCOUNTS.
           05   WS-ACCOUNT-ENTRY OCCURS 10 TIMES.
               10   WS-USERNAME     PIC X(20).
               10   WS-PASSWORD     PIC X(20).

       01 WS-INPUT-LINE     PIC X(250).
       01 WS-INPUT-FILE  PIC X(100).
       01 WS-OUTPUT-LINE    PIC X(250).
       01 WS-OUTPUT-FILE PIC X(100).
       01 WS-CHOICE         PIC X(5).
       01 WS-NEW-USER       PIC X(20).
       01 WS-NEW-PASS       PIC X(12).
       01 WS-LOGIN-USER     PIC X(20).
       01 WS-LOGIN-PASS     PIC X(12).

       01 WS-CONNECTIONS-EOF PIC X VALUE "N".
           88 END-OF-CONNECTIONS VALUE "Y".
       01 WS-TOTAL-CONNECTIONS PIC 9(3) VALUE 0.
       01 WS-CONNECTIONS.
           05 WS-CONNECTION OCCURS 100 TIMES.
               10 WS-REQ-SENDER    PIC X(20).
               10 WS-REQ-RECIPIENT PIC X(20).
               10 WS-REQ-STATUS    PIC X.
       01 WS-REQUEST-IDX PIC 9(3) VALUE 0.
       01 WS-TARGET-USERNAME PIC X(20).
       01 WS-CONNECTION-FOUND PIC X VALUE "N".
           88 CONNECTION-FOUND VALUE "Y".
       01 WS-CONNECTION-STATUS PIC X.
       01 WS-CONNECTION-ACTION PIC X(5).

       01 WS-SAVE-IDX      PIC 9(3) VALUE 0.
       01 WS-LOOKUP-USER   PIC X(20).
       01 WS-NET-IDX       PIC 9(2) VALUE 0.
       01 WS-NET-FOUND     PIC 9(2) VALUE 0.

       01 WS-VALID-PASS     PIC X      VALUE "Y".
           88 PASSWORD-VALID           VALUE "Y".

       01 WS-INDEX          PIC 9(2)      VALUE 0.

       01  WS-SEARCH-USERNAME   PIC X(20).
       01  WS-ACCOUNT-FOUND     PIC X       VALUE "N".
           88  ACCOUNT-FOUND                VALUE "Y".
       01  WS-FOUND-INDEX       PIC 9(2)       VALUE 0.
       01  WS-SEARCH-IDX        PIC 9(2).

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
           05 WS-PROFILE-INST OCCURS 10 TIMES.
               10 WS-PROF-USER        PIC X(20).
               10 WS-PROF-FIRST-NAME  PIC X(20).
               10 WS-PROF-LAST-NAME   PIC X(20).
               10 WS-PROF-SCHOOL      PIC X(50).
               10 WS-PROF-MAJOR       PIC X(30).
               10 WS-PROF-GRAD-YEAR   PIC 9(4).
               10 WS-PROF-ABOUT       PIC X(200).
               10 WS-PROF-EXP-CNT     PIC 9    VALUE 0.
               10 WS-PROF-EXP-INST OCCURS 3 TIMES.
                   15 WS-EXP-TITLE    PIC X(20).
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


       01 WS-PROF-IDX      PIC 9(2)       VALUE 0.
         01 WS-PROFILE-IDX   PIC 9(2)       VALUE 0.

       01 WS-PROFILE-2-IDX PIC 9(2) VALUE 0.
       01 WS-ANOTHER-USER-SEARCH     PIC X(20).

       

       01 WS-EXP-IDX       PIC 9       VALUE 0.
       01 WS-EDU-IDX       PIC 9       VALUE 0.
       01 WS-FIELD-LEN     PIC 9(3)    VALUE 0.


       01  WS-VALID-RESPONSE    PIC X       VALUE "N".
           88 VALIDATED                    VALUE "Y".

       01 WS-SEARCH-FULL-NAME PIC X(100).
         01 WS-PROFILE-NAME-UPPER PIC X(100).
         01 WS-SEARCH-NAME-UPPER  PIC X(100).

      *    EPIC 6 WS SECTION
       01 WS-JOBS-STAT     PIC XX.
       01 WS-JOBS-EOF      PIC X       VALUE "N".
           88 END-OF-JOBS              VALUE "Y".
       01 WS-TOTAL-JOBS    PIC 9(3)    VALUE 0.
       01 WS-MAX-JOB-ID    PIC 9(4)    VALUE 0.
       01 WS-JOBS.
           05 WS-JOB-INST OCCURS 100 TIMES.
               10 WS-JOB-ID        PIC 9(4).
               10 WS-JOB-POSTER    PIC X(20).
               10 WS-JOB-TITLE     PIC X(50).
               10 WS-JOB-DESCR     PIC X(200).
               10 WS-JOB-EMPLOYER  PIC X(50).
               10 WS-JOB-LOCATION  PIC X(50).
               10 WS-JOB-SALARY    PIC X(30).
       01 WS-JOB-IDX       PIC 9(3)     VALUE 0.

       01 WS-JOB-MENU-DONE PIC X       VALUE "N".
           88 JOB-MENU-DONE            VALUE "Y".

       01 WS-FIELD-PROMPT  PIC X(60).
       01 WS-FIELD-NAME    PIC X(20).
       01 WS-FIELD-VALUE   PIC X(250).
       01 WS-FIELD-MAX     PIC 9(3)    VALUE 0.
       01 WS-FIELD-DISP    PIC ZZ9.
       01 WS-FIELD-REQ     PIC X       VALUE "Y".
           88 FIELD-REQUIRED           VALUE "Y".


       LINKAGE SECTION.
       01  LS-INPUT   PIC X(100).
       01  LS-OUTPUT  PIC X(100).
       01  LS-ACCOUNTS PIC X(100).

       PROCEDURE DIVISION USING LS-INPUT LS-OUTPUT LS-ACCOUNTS.

           MOVE LS-INPUT TO WS-INPUT-FILE
           MOVE LS-OUTPUT TO WS-OUTPUT-FILE
           MOVE LS-ACCOUNTS TO WS-ACCOUNTS-FILE

           PERFORM START-FILES
           MOVE "WELCOME TO INCOLLEGE!" TO WS-OUTPUT-LINE
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

           MOVE "---END_OF_PROGRAM---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           PERFORM CLOSE-FILES

           GOBACK.




       START-FILES.
           OPEN INPUT IN-FILE
           IF WS-INPUT-STAT NOT = "00"
                DISPLAY "ERROR: Cannot Open Input File: " WS-INPUT-FILE
                DISPLAY "File Status: " WS-INPUT-STAT
               STOP RUN
           END-IF.

           OPEN OUTPUT OUTPUT-FILE
           IF WS-OUTPUT-STAT NOT = "00"
               DISPLAY "ERROR: Cannot Open Output File: " WS-OUTPUT-FILE
                DISPLAY "  File Status: " WS-OUTPUT-STAT
               STOP RUN
           END-IF.


           OPEN INPUT ACCOUNTS-FILE
           IF WS-ACCOUNTS-STAT = "00"
               PERFORM UNTIL END-OF-ACCOUNTS OR WS-TOTAL-ACCOUNTS >= 10
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
               PERFORM UNTIL END-OF-PROFILES OR WS-PROF-IDX >= 10
                   READ PROFILES-FILE INTO PROFILE-INSTANCE
                       AT END
                           MOVE "Y" TO WS-PROFILES-EOF
                       NOT AT END
                           MOVE PROF-USER TO WS-SEARCH-USERNAME
                           PERFORM FIND-ACCOUNT-BY-USERNAME
                           IF ACCOUNT-FOUND
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
                           END-IF
                   END-READ
               END-PERFORM
           END-IF
           CLOSE PROFILES-FILE

           PERFORM LOAD-CONNECTIONS
           PERFORM LOAD-JOBS.


       CLOSE-FILES.
           CLOSE IN-FILE
           CLOSE OUTPUT-FILE.

       LOAD-CONNECTIONS.
           OPEN INPUT CONNECTIONS-FILE
           IF WS-CONNECTIONS-STAT = "00"
               PERFORM UNTIL END-OF-CONNECTIONS
                   OR WS-TOTAL-CONNECTIONS >= 100
                   READ CONNECTIONS-FILE INTO CONNECTION-INSTANCE
                       AT END
                           MOVE "Y" TO WS-CONNECTIONS-EOF
                       NOT AT END
                           ADD 1 TO WS-TOTAL-CONNECTIONS
                           MOVE REQ-SENDER
                               TO WS-REQ-SENDER(WS-TOTAL-CONNECTIONS)
                           MOVE REQ-RECIPIENT
                               TO WS-REQ-RECIPIENT(WS-TOTAL-CONNECTIONS)
                           MOVE REQ-STATUS
                               TO WS-REQ-STATUS(WS-TOTAL-CONNECTIONS)
                   END-READ
               END-PERFORM
           END-IF.
           CLOSE CONNECTIONS-FILE.

       WRITE-OUTPUT.
           DISPLAY FUNCTION TRIM(WS-OUTPUT-LINE TRAILING)
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
           MOVE "1. LOG-IN" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "2. CREATE NEW ACCOUNT" To WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "ENTER YOUR CHOICE:" TO WS-OUTPUT-LINE
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
               MOVE "Please Enter Your username:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE WS-INPUT-LINE TO WS-LOGIN-USER
                   MOVE WS-LOGIN-USER TO WS-SEARCH-USERNAME
                   PERFORM FIND-ACCOUNT-BY-USERNAME

                   MOVE "Please Enter Your password:" TO WS-OUTPUT-LINE
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
                           MOVE "You Have Successfully Logged In."
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                           MOVE "Y" TO WS-LOGGED-IN
                       ELSE
                           MOVE
           "Incorrect Username/Password, Please Try Again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.


       CREATE-ACCOUNT.
           IF WS-TOTAL-ACCOUNTS >= 10
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "All Permitted Accounts Have Been Created, "
                      "Please Come Back Later"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               END-STRING
               PERFORM WRITE-OUTPUT
           ELSE
               MOVE "Please Enter Your username:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               MOVE WS-INPUT-LINE TO WS-NEW-USER

               COMPUTE WS-USER-LEN =
                   FUNCTION LENGTH(FUNCTION TRIM (WS-INPUT-LINE))

               MOVE WS-NEW-USER TO WS-SEARCH-USERNAME
               MOVE WS-NEW-USER TO WS-LOGIN-USER
               PERFORM FIND-ACCOUNT-BY-USERNAME

               IF ACCOUNT-FOUND
                   MOVE
           "That USERNAME Is Already Taken, Please Try Again"
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               ELSE
                   IF WS-USER-LEN = 0
                       MOVE "Blank Usernames not allowed"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   ELSE
                       MOVE "Please Enter Your Password:"
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
                           MOVE "You Have Successfully Logged In."
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                           MOVE "Y" TO WS-LOGGED-IN
                           MOVE WS-TOTAL-ACCOUNTS TO WS-FOUND-INDEX
                       ELSE
                           MOVE
               "Password Doesn't Satisfy Requirements, Try Again"
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
               MOVE WS-PROF-USER(WS-INDEX) TO PROF-USER
               MOVE WS-PROF-FIRST-NAME(WS-INDEX) TO PROF-FIRST-NAME
               MOVE WS-PROF-LAST-NAME(WS-INDEX) TO PROF-LAST-NAME
               MOVE WS-PROF-SCHOOL(WS-INDEX) TO PROF-SCHOOL
               MOVE WS-PROF-MAJOR(WS-INDEX) TO PROF-MAJOR
               MOVE WS-PROF-GRAD-YEAR(WS-INDEX) TO PROF-GRAD-YEAR
               MOVE WS-PROF-ABOUT(WS-INDEX) TO PROF-ABOUT
               MOVE WS-PROF-EXP-CNT(WS-INDEX) TO PROF-EXP-CNT
               PERFORM VARYING WS-EXP-IDX FROM 1 BY 1
                       UNTIL WS-EXP-IDX > 3
                   MOVE WS-EXP-TITLE(WS-INDEX, WS-EXP-IDX)
                       TO EXP-TITLE(WS-EXP-IDX)
                   MOVE WS-EXP-ORGAN(WS-INDEX, WS-EXP-IDX)
                       TO EXP-ORGAN(WS-EXP-IDX)
                   MOVE WS-EXP-DATES(WS-INDEX, WS-EXP-IDX)
                       TO EXP-DATES(WS-EXP-IDX)
                   MOVE WS-EXP-DESCR(WS-INDEX, WS-EXP-IDX)
                       TO EXP-DESCR(WS-EXP-IDX)
               END-PERFORM
               MOVE WS-PROF-EDU-CNT(WS-INDEX) TO PROF-EDU-CNT
               PERFORM VARYING WS-EDU-IDX FROM 1 BY 1
                       UNTIL WS-EDU-IDX > 3
                   MOVE WS-EDU-DEGREE(WS-INDEX, WS-EDU-IDX)
                       TO EDU-DEGREE(WS-EDU-IDX)
                   MOVE WS-EDU-SCHOOL(WS-INDEX, WS-EDU-IDX)
                       TO EDU-SCHOOL(WS-EDU-IDX)
                   MOVE WS-EDU-YEARS(WS-INDEX, WS-EDU-IDX)
                       TO EDU-YEARS(WS-EDU-IDX)
               END-PERFORM
               MOVE WS-HAS-PROF(WS-INDEX) TO HAS-PROF
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
           MOVE "3. Search For a job" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "4. Search For someone you know" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "5. Learn a New Skill" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "6. Logout" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "7. Pending Connection Requests" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "8. View My Network" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "ENTER YOUR CHOICE:" TO WS-OUTPUT-LINE
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
                       PERFORM JOB-MENU
                   WHEN "4"
                       PERFORM FIND-SOMEONE
                   WHEN "5"
                       PERFORM SKILL-MENU-LOOP
                   WHEN "6"
                       MOVE "N" TO WS-RUNNING
                   WHEN "7"
                       PERFORM VIEW-PENDING-REQUESTS
                   WHEN "8"
                       PERFORM VIEW-MY-NETWORK
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
               MOVE "ENTER YOUR CHOICE:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT

               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE WS-INPUT-LINE TO WS-CHOICE
                   EVALUATE WS-CHOICE
                       WHEN "6"
                           MOVE "Y" TO WS-SKILL-GO-BACK
                       WHEN "1" THRU "5"
                           MOVE "This Skill Is Under Construction."
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

           PERFORM FIND-PROFILE-BY-USERNAME
           IF WS-PROFILE-IDX = 0
               ADD 1 TO WS-PROF-IDX
               MOVE WS-PROF-IDX TO WS-PROFILE-IDX
           END-IF
           MOVE WS-PROFILE-IDX TO WS-FOUND-INDEX

           PERFORM GET-FIRST-NAME
           PERFORM GET-LAST-NAME
           PERFORM GET-SCHOOL
           PERFORM GET-MAJOR
           PERFORM GET-GRAD-YEAR
           PERFORM GET-ABOUT-ME
           PERFORM GET-EXPERIENCE
           PERFORM GET-EDUCATION

           MOVE WS-LOGIN-USER TO WS-PROF-USER(WS-FOUND-INDEX)
           MOVE "Y" TO WS-HAS-PROF(WS-FOUND-INDEX)
           PERFORM SAVE-TO-PROFILES

           MOVE "---Profile Created/Updated---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.

        FIND-SOMEONE.
            MOVE "Enter Full Name:" TO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            PERFORM READ-INPUT

            MOVE SPACES TO WS-SEARCH-FULL-NAME
            MOVE WS-INPUT-LINE TO WS-SEARCH-FULL-NAME
            MOVE 0 TO WS-FOUND-INDEX

            PERFORM VARYING WS-SEARCH-IDX FROM 1 BY 1
                    UNTIL WS-SEARCH-IDX > WS-PROF-IDX
                IF WS-HAS-PROF(WS-SEARCH-IDX) = "Y"
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING
                        FUNCTION TRIM(WS-PROF-FIRST-NAME(WS-SEARCH-IDX))
                        " "
                        FUNCTION TRIM(WS-PROF-LAST-NAME(WS-SEARCH-IDX))
                        DELIMITED BY SIZE
                        INTO WS-OUTPUT-LINE
                    END-STRING

                    MOVE FUNCTION UPPER-CASE(WS-OUTPUT-LINE)
                        TO WS-PROFILE-NAME-UPPER
                    MOVE FUNCTION UPPER-CASE(WS-SEARCH-FULL-NAME)
                        TO WS-SEARCH-NAME-UPPER
                    IF FUNCTION TRIM(WS-PROFILE-NAME-UPPER) =
                       FUNCTION TRIM(WS-SEARCH-NAME-UPPER)
                        MOVE WS-SEARCH-IDX TO WS-FOUND-INDEX
                    END-IF
                END-IF
            END-PERFORM

            IF WS-FOUND-INDEX = 0
                MOVE "Profile Cannot Be Found" TO WS-OUTPUT-LINE
                PERFORM WRITE-OUTPUT
            ELSE
                PERFORM DISPLAY-PROFILE
                PERFORM CONNECTION-ACTION
            END-IF. 

       CONNECTION-ACTION.
            MOVE "1. Send Connection Request" TO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            MOVE "2. Return to Main Menu" TO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            MOVE "ENTER YOUR CHOICE:" TO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            PERFORM READ-INPUT
            IF NOT END-OF-INPUT
                MOVE WS-INPUT-LINE TO WS-CONNECTION-ACTION
                EVALUATE WS-CONNECTION-ACTION
                    WHEN "1"
                        MOVE WS-PROF-USER(WS-FOUND-INDEX)
                            TO WS-TARGET-USERNAME
                        IF WS-TARGET-USERNAME = WS-LOGIN-USER
                            MOVE "CANNOT SEND A REQUEST TO YOURSELF."
                                TO WS-OUTPUT-LINE
                            PERFORM WRITE-OUTPUT
                        ELSE
                            PERFORM SEND-CONNECTION-REQUEST
                        END-IF
                    WHEN "2"
                        CONTINUE
                    WHEN OTHER
                        MOVE "INVALID OPTION, TRY AGAIN."
                            TO WS-OUTPUT-LINE
                        PERFORM WRITE-OUTPUT
                END-EVALUATE
            END-IF.

       SEND-CONNECTION-REQUEST.
            MOVE "N" TO WS-CONNECTION-FOUND
            MOVE SPACES TO WS-CONNECTION-STATUS
            PERFORM VARYING WS-REQUEST-IDX FROM 1 BY 1
                    UNTIL WS-REQUEST-IDX > WS-TOTAL-CONNECTIONS
                IF WS-REQ-SENDER(WS-REQUEST-IDX) = WS-TARGET-USERNAME
                   AND WS-REQ-RECIPIENT(WS-REQUEST-IDX) = WS-LOGIN-USER
                    MOVE "Y" TO WS-CONNECTION-FOUND
                    MOVE WS-REQ-STATUS(WS-REQUEST-IDX)
                        TO WS-CONNECTION-STATUS
                    IF WS-CONNECTION-STATUS = "P"
                        MOVE "This User Already Sent a Request"
                            TO WS-OUTPUT-LINE
                        PERFORM WRITE-OUTPUT
                    END-IF
                    IF WS-CONNECTION-STATUS = "C"
                        MOVE "You Are Already Connected With User"
                            TO WS-OUTPUT-LINE
                        PERFORM WRITE-OUTPUT
                    END-IF
                    IF WS-CONNECTION-STATUS = "R"
                        PERFORM SHOW-REJECTED-BLOCK
                    END-IF
                END-IF
                IF WS-REQ-SENDER(WS-REQUEST-IDX) = WS-LOGIN-USER
                    IF WS-REQ-RECIPIENT(WS-REQUEST-IDX)
                       = WS-TARGET-USERNAME
                        MOVE "Y" TO WS-CONNECTION-FOUND
                        MOVE WS-REQ-STATUS(WS-REQUEST-IDX)
                            TO WS-CONNECTION-STATUS
                        IF WS-CONNECTION-STATUS = "P"
                            MOVE "Request Already Sent"
                                TO WS-OUTPUT-LINE
                            PERFORM WRITE-OUTPUT
                        END-IF
                        IF WS-CONNECTION-STATUS = "C"
                            MOVE "You Are Already Connected With User"
                                TO WS-OUTPUT-LINE
                            PERFORM WRITE-OUTPUT
                        END-IF
                        IF WS-CONNECTION-STATUS = "R"
                            PERFORM SHOW-REJECTED-BLOCK
                        END-IF
                    END-IF
                END-IF
                
            END-PERFORM

            IF NOT CONNECTION-FOUND
                IF WS-TOTAL-CONNECTIONS < 100
                    ADD 1 TO WS-TOTAL-CONNECTIONS
                    MOVE WS-LOGIN-USER
                        TO WS-REQ-SENDER(WS-TOTAL-CONNECTIONS)
                    MOVE WS-TARGET-USERNAME
                        TO WS-REQ-RECIPIENT(WS-TOTAL-CONNECTIONS)
                    MOVE "P" TO WS-REQ-STATUS(WS-TOTAL-CONNECTIONS)
                    PERFORM SAVE-CONNECTIONS
                    MOVE "Connection Request Sent." TO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                ELSE
                    MOVE "Unable To Send Request. Storage Is Full."
                        TO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                END-IF
            END-IF.

       SAVE-CONNECTIONS.
           OPEN OUTPUT CONNECTIONS-FILE
           PERFORM VARYING WS-SAVE-IDX FROM 1 BY 1
                   UNTIL WS-SAVE-IDX > WS-TOTAL-CONNECTIONS
               MOVE WS-REQ-SENDER(WS-SAVE-IDX) TO REQ-SENDER
               MOVE WS-REQ-RECIPIENT(WS-SAVE-IDX) TO REQ-RECIPIENT
               MOVE WS-REQ-STATUS(WS-SAVE-IDX) TO REQ-STATUS
               WRITE CONNECTION-INSTANCE
           END-PERFORM
           CLOSE CONNECTIONS-FILE.

       VIEW-PENDING-REQUESTS.
           MOVE "--- Pending Connection Requests ---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "N" TO WS-CONNECTION-FOUND
           PERFORM VARYING WS-REQUEST-IDX FROM 1 BY 1
                   UNTIL WS-REQUEST-IDX > WS-TOTAL-CONNECTIONS
                      OR END-OF-INPUT
               IF WS-REQ-RECIPIENT(WS-REQUEST-IDX) = WS-LOGIN-USER
                  AND WS-REQ-STATUS(WS-REQUEST-IDX) = "P"
                   MOVE "Y" TO WS-CONNECTION-FOUND
                   PERFORM PROCESS-ONE-REQUEST
               END-IF
           END-PERFORM
           IF CONNECTION-FOUND
               MOVE "-----------------------------------"
                   TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           ELSE
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "You have no pending connection requests "
                   "at this time."
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF.
       VIEW-MY-NETWORK.
           MOVE "--- Your Network ---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "N" TO WS-CONNECTION-FOUND
           PERFORM VARYING WS-REQUEST-IDX FROM 1 BY 1
                   UNTIL WS-REQUEST-IDX > WS-TOTAL-CONNECTIONS
               IF WS-REQ-STATUS(WS-REQUEST-IDX) = "C"
                   AND (WS-REQ-RECIPIENT(WS-REQUEST-IDX) = WS-LOGIN-USER
                       OR WS-REQ-SENDER(WS-REQUEST-IDX) = WS-LOGIN-USER)

                   MOVE "Y" to WS-CONNECTION-FOUND

                   IF WS-REQ-RECIPIENT(WS-REQUEST-IDX) = WS-LOGIN-USER
                       MOVE WS-REQ-SENDER(WS-REQUEST-IDX)
                           TO WS-ANOTHER-USER-SEARCH
                   ELSE
                       MOVE WS-REQ-RECIPIENT(WS-REQUEST-IDX)
                           TO WS-ANOTHER-USER-SEARCH
                   END-IF

                   PERFORM FIND-ANOTHER-PROFILE-BY-USERNAME

                   MOVE SPACES TO WS-OUTPUT-LINE
                   IF WS-PROFILE-2-IDX > 0
                       STRING "Connected with: "
                         FUNCTION TRIM(WS-ANOTHER-USER-SEARCH)
                         " (University: "
                         FUNCTION TRIM(WS-PROF-SCHOOL(WS-PROFILE-2-IDX))
                         ", Major: "
                         FUNCTION TRIM(WS-PROF-MAJOR(WS-PROFILE-2-IDX))
                         ")"
                       DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                   ELSE
                       STRING "Connected with: "
                           FUNCTION TRIM(WS-ANOTHER-USER-SEARCH)
                           DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                   END-IF
                   PERFORM WRITE-OUTPUT
               END-IF
           END-PERFORM
           

           IF WS-CONNECTION-FOUND = "N"
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "You have no connections in your network "
                   "at this time."
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF
           MOVE "--------------------" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.


       PROCESS-ONE-REQUEST.
           MOVE WS-REQ-SENDER(WS-REQUEST-IDX) TO WS-TARGET-USERNAME
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Request from: " FUNCTION TRIM(WS-TARGET-USERNAME)
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "1. Accept" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "2. Reject" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "Enter your choice for "
                   FUNCTION TRIM(WS-TARGET-USERNAME) ":"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE WS-INPUT-LINE TO WS-CHOICE
                   EVALUATE WS-CHOICE
                       WHEN "1"
                           PERFORM ACCEPT-REQUEST
                           MOVE "Y" TO WS-VALID-RESPONSE
                       WHEN "2"
                           PERFORM REJECT-REQUEST
                           MOVE "Y" TO WS-VALID-RESPONSE
                       WHEN OTHER
                           MOVE "Invalid Option, Try Again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                   END-EVALUATE
               END-IF
           END-PERFORM.

       ACCEPT-REQUEST.
           MOVE "C" TO WS-REQ-STATUS(WS-REQUEST-IDX)
           PERFORM SAVE-CONNECTIONS
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Connection request from "
               FUNCTION TRIM(WS-TARGET-USERNAME) " accepted!"
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.    

       REJECT-REQUEST.
           MOVE "R" TO WS-REQ-STATUS(WS-REQUEST-IDX)
           PERFORM SAVE-CONNECTIONS
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Connection request from "
               FUNCTION TRIM(WS-TARGET-USERNAME) " rejected!"
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.

       SHOW-REJECTED-BLOCK.
           MOVE "You Cannot Send A Connection Request To This User."
               TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.

       VIEW-PROFILE.
           PERFORM FIND-PROFILE-BY-USERNAME

           IF WS-PROFILE-IDX = 0
               MOVE "No Profile Has Been Created Yet."
                   TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           ELSE 
               MOVE WS-PROFILE-IDX TO WS-FOUND-INDEX
               PERFORM DISPLAY-PROFILE
           END-IF.
        
        DISPLAY-PROFILE.
            MOVE SPACES TO WS-OUTPUT-LINE
            STRING "==== Profile For "
                FUNCTION TRIM(WS-PROF-FIRST-NAME(WS-FOUND-INDEX))
                " "
                FUNCTION TRIM(WS-PROF-LAST-NAME(WS-FOUND-INDEX))
                " ===="
                DELIMITED BY SIZE INTO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            MOVE SPACES TO WS-OUTPUT-LINE
            STRING "Name: "
                FUNCTION TRIM(WS-PROF-FIRST-NAME(WS-FOUND-INDEX))
                " "
                FUNCTION TRIM(WS-PROF-LAST-NAME(WS-FOUND-INDEX))
                DELIMITED BY SIZE INTO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            MOVE SPACES TO WS-OUTPUT-LINE
            STRING "University: "
                FUNCTION TRIM(WS-PROF-SCHOOL(WS-FOUND-INDEX))
                DELIMITED BY SIZE INTO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            MOVE SPACES TO WS-OUTPUT-LINE
            STRING "Major: "
                FUNCTION TRIM(WS-PROF-MAJOR(WS-FOUND-INDEX))
                DELIMITED BY SIZE INTO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            MOVE SPACES TO WS-OUTPUT-LINE
            STRING "Graduation Year: "
                WS-PROF-GRAD-YEAR(WS-FOUND-INDEX)
                DELIMITED BY SIZE INTO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT
            MOVE SPACES TO WS-OUTPUT-LINE
            STRING "About Me: "
                FUNCTION TRIM(WS-PROF-ABOUT(WS-FOUND-INDEX))
                DELIMITED BY SIZE INTO WS-OUTPUT-LINE
            PERFORM WRITE-OUTPUT

            IF WS-PROF-EXP-CNT(WS-FOUND-INDEX) > 0
                MOVE "Experience:" TO WS-OUTPUT-LINE
                PERFORM WRITE-OUTPUT
                PERFORM VARYING WS-EXP-IDX FROM 1 BY 1
                        UNTIL WS-EXP-IDX >
                            WS-PROF-EXP-CNT(WS-FOUND-INDEX)
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING " Title: "
                        FUNCTION TRIM(WS-EXP-TITLE(WS-FOUND-INDEX,
                            WS-EXP-IDX))
                        DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING " Company: "
                        FUNCTION TRIM(WS-EXP-ORGAN(WS-FOUND-INDEX,
                            WS-EXP-IDX))
                        DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING " Dates: "
                        FUNCTION TRIM(WS-EXP-DATES(WS-FOUND-INDEX,
                            WS-EXP-IDX))
                        DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING " Description: "
                        FUNCTION TRIM(WS-EXP-DESCR(WS-FOUND-INDEX,
                            WS-EXP-IDX))
                        DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                END-PERFORM
            END-IF

            IF WS-PROF-EDU-CNT(WS-FOUND-INDEX) > 0
                MOVE "Education:" TO WS-OUTPUT-LINE
                PERFORM WRITE-OUTPUT
                PERFORM VARYING WS-EDU-IDX FROM 1 BY 1
                        UNTIL WS-EDU-IDX >
                            WS-PROF-EDU-CNT(WS-FOUND-INDEX)
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING " Degree: "
                        FUNCTION TRIM(WS-EDU-DEGREE(WS-FOUND-INDEX,
                            WS-EDU-IDX))
                        DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING " University: "
                        FUNCTION TRIM(WS-EDU-SCHOOL(WS-FOUND-INDEX,
                            WS-EDU-IDX))
                        DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                    MOVE SPACES TO WS-OUTPUT-LINE
                    STRING " Years: "
                        FUNCTION TRIM(WS-EDU-YEARS(WS-FOUND-INDEX,
                            WS-EDU-IDX))
                        DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                    PERFORM WRITE-OUTPUT
                END-PERFORM
            END-IF.

       FIND-PROFILE-BY-USERNAME.
           MOVE 0 TO WS-PROFILE-IDX
           MOVE WS-LOGIN-USER TO WS-SEARCH-USERNAME
           PERFORM VARYING WS-SEARCH-IDX FROM 1 BY 1
                   UNTIL WS-SEARCH-IDX > WS-PROF-IDX
                       OR WS-PROFILE-IDX > 0
               IF WS-PROF-USER(WS-SEARCH-IDX) = WS-SEARCH-USERNAME
                   MOVE WS-SEARCH-IDX TO WS-PROFILE-IDX
               END-IF
           END-PERFORM.

       FIND-ANOTHER-PROFILE-BY-USERNAME.
           MOVE 0 TO WS-PROFILE-2-IDX
           PERFORM VARYING WS-SEARCH-IDX FROM 1 BY 1
                   UNTIL WS-SEARCH-IDX > WS-PROF-IDX
                       OR WS-PROFILE-2-IDX > 0
               IF WS-PROF-USER(WS-SEARCH-IDX) = WS-ANOTHER-USER-SEARCH
                   MOVE WS-SEARCH-IDX TO WS-PROFILE-2-IDX
               END-IF
           END-PERFORM.


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
                       MOVE "First Name CANNOT Be Blank, Try Again"
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
                       MOVE "Last Name CANNOT Be Blank, Try Again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.


       GET-SCHOOL.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter University Name: " TO WS-OUTPUT-LINE
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
                       MOVE "University Name Cannot Be Blank"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.

       GET-MAJOR.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter The Name Of Your Major: " TO WS-OUTPUT-LINE
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
                       MOVE "Major Cannot Be Blank, Try Again"
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
                       IF WS-INPUT-LINE(1:WS-FIELD-LEN) IS NUMERIC
                           IF FUNCTION NUMVAL(WS-INPUT-LINE) > 2025
                               AND FUNCTION NUMVAL(WS-INPUT-LINE) < 2034
                               MOVE WS-INPUT-LINE
                                   TO WS-PROF-GRAD-YEAR(WS-FOUND-INDEX)
                               MOVE "Y" TO WS-VALID-RESPONSE
                           ELSE
                               MOVE
                 "Graduation Year Must Be Between 2026 And 2033"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                           END-IF
                       ELSE
                           MOVE
                 "Graduation Year Must Be Numeric, Please Try Again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                       END-IF
                   ELSE
                       MOVE
                 "Graduation Year Must Be 4 Digits, Please Try Again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
               END-IF
           END-PERFORM.

       GET-ABOUT-ME.
           MOVE "N" TO WS-VALID-RESPONSE
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE "Enter About Me (Optional): " TO WS-OUTPUT-LINE
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
                   >= 3) OR END-OF-INPUT
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "Add Experience (Optional, Max 3 Entries)."
               "Enter 'DONE' To Finish Or Any Input To Continue):"
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
                               MOVE "Title Cannot Be Blank, Try Again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                               SUBTRACT 1 FROM 
                                   WS-PROF-EXP-CNT(WS-FOUND-INDEX)
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
                               MOVE "Company Cannot Be Blank, Try Again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                               SUBTRACT 1 FROM 
                                   WS-PROF-EXP-CNT(WS-FOUND-INDEX)
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
                               MOVE "Years Cannot Be Blank, Try Again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                               SUBTRACT 1 FROM
                                   WS-PROF-EXP-CNT(WS-FOUND-INDEX)
                               EXIT PERFORM CYCLE
                           END-IF
                       END-IF
                       MOVE SPACES TO WS-OUTPUT-LINE
                       STRING "Exp #" WS-EXP-IDX
                           " - Description (Optional, Max 100 Chars): "
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
               STRING "Add Education (Optional, Max 3 Entries)."
               " Enter 'DONE' To Finish Or Any Input To Continue):"
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
                               MOVE "Degree Cannot Be Blank, Try Again"
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
                         "University Name Blank, Try Again"
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
                         "Years Attended Blank, Try Again"
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

         COPY "Jobs.cob".
         COPY "BrowseJobs.cob".
