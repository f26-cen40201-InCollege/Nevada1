
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INCOLLEGE-CORE.
       DATE-WRITTEN. 9/3/2026.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-FILE ASSIGN TO WS-INPUT-FILE
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-INPUT-STAT.

           SELECT OUTPUT-FILE ASSIGN TO "InCollege-Output.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-OUTPUT-STAT.

           SELECT OPTIONAL ACCOUNTS-FILE ASSIGN TO "Accounts.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-ACCOUNTS-STAT.

       DATA DIVISION.
       FILE SECTION.
       FD IN-FILE.
       01 INPUT-LINE    PIC X(50).

       FD OUTPUT-FILE.
       01 OUTPUT-LINE   PIC X(100).

       FD ACCOUNTS-FILE.
       01 ACCOUNT-INSTANCE. 
           05 ACC-USERNAME  PIC X(20).
           05 ACC-PASSWORD  PIC X(20).

       WORKING-STORAGE SECTION.

       01  WS-INPUT-STAT     PIC XX.
       01  WS-OUTPUT-STAT    PIC XX.
       01  WS-ACCOUNTS-STAT  PIC XX.
           
       01  WS-INPUT-EOF    PIC X   VALUE "N".
           88  END-OF-INPUT        VALUE "Y".
       01  WS-ACCOUNTS-EOF PIC X   VALUE "N".
           88  END-OF-ACCOUNTS     VALUE "Y".
       01  WS-LOGGED-IN    PIC X   VALUE "N".
           88 LOGGED-IN         VALUE "Y".
       01  WS-RUNNING      PIC X   VALUE "Y".
           88 STILL-RUNNING        VALUE "Y".


       01 WS-TOTAL-ACCOUNTS     PIC 9       VALUE 0.
       01 WS-ACCOUNTS.
           05   WS-ACCOUNT-ENTRY OCCURS 5 TIMES.
               10   WS-USERNAME     PIC X(20).
               10   WS-PASSWORD     PIC X(20).

       01 WS-INPUT-LINE     PIC X(50).
       01 WS-OUTPUT-LINE    PIC X(100).
       01 WS-CHOICE         PIC X.
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

       01  WS-PW-LEN             PIC 9(3).
       01  WS-PW-IDX             PIC 9(3).
       01  WS-PW-CHAR            PIC X.
       01  WS-HAS-UPPER          PIC X       VALUE "N".
       01  WS-HAS-DIGIT          PIC X       VALUE "N".
       01  WS-HAS-SPECIAL        PIC X       VALUE "N".

       01  WS-SKILL-GO-BACK      PIC X       VALUE "N".
           88  SKILL-GO-BACK                 VALUE "Y".
       
       LINKAGE SECTION.
       01  LS-INPUT   PIC X(50).

       PROCEDURE DIVISION USING LS-INPUT.

           MOVE LS-INPUT TO WS-INPUT-LINE

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

           GOBACK.




       START-FILES.
           OPEN INPUT IN-FILE
           IF WS-INPUT-STAT NOT = "00"
               STOP RUN
           END-IF.

           OPEN OUTPUT OUTPUT-FILE
           IF WS-OUTPUT-STAT NOT = "00"
               STOP RUN
           END-IF.

           OPEN INPUT ACCOUNTS-FILE
           IF WS-ACCOUNTS-STAT = "00"
               PERFORM UNTIL END-OF-ACCOUNTS OR WS-TOTAL-ACCOUNTS >= 5
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
           CLOSE ACCOUNTS-FILE.

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
                           TO WS-INPUT-LINE
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
               MOVE "All permitted accounts have been created,
      -             "please come back later" 
                       TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           ELSE
               MOVE "Please enter your username:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               MOVE WS-INPUT-LINE TO WS-NEW-USER
               MOVE WS-NEW-USER TO WS-SEARCH-USERNAME
               PERFORM FIND-ACCOUNT-BY-USERNAME

               IF ACCOUNT-FOUND
                   MOVE
           "That username is already taken, please try again"
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               ELSE
                   MOVE "Please enter your password:" TO WS-OUTPUT-LINE
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
                   ELSE 
                       MOVE
           "Password doesn't satisfy requirements, try again"
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
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
           MOVE "1. Search for a job" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "2. Find someone you know" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "3. Learn a new skill" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "4. Logout" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "Enter your choice:" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           PERFORM READ-INPUT
           IF NOT END-OF-INPUT
               MOVE WS-INPUT-LINE TO WS-CHOICE
               EVALUATE WS-CHOICE
                   WHEN "1"
                       MOVE
           "Job search/internship is under construction."
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   WHEN "2"
                       MOVE
           "Find someone you know is under construction."
                           TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   WHEN "3"
                       PERFORM SKILL-MENU-LOOP
                   WHEN "4"
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
           
           

       



      