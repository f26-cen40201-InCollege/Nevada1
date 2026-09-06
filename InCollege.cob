
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INCOLLEGE.
       DATE-WRITTEN. 9/3/2026.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "InCollege-Input.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-INPUT-STAT.

           SELECT OUTPUT-FILE ASSIGN TO "InCollege-Output.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-OUTPUT-STAT.

           SELECT ACCOUNTS-FILE ASSIGN TO "Accounts.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-ACCOUNTS-STAT.

       DATA DIVISION.
       FILE SECTION.
       FD INPUT-FILE.
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
       


       PROCEDURE DIVISION.

           PERFORM START-FILES
           MOVE "Welcome to InCollege!" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           PERFORM UNTIL LOGGED-IN OR END-OF-INPUT
               PERFORM LOG-IN-SCREEN
           END-PERFORM

           PERFORM UNTIL (NOT STILL-RUNNING) OR END-OF-INPUT
               PERFORM SITE-MENU
           END-PERFORM



           PERFORM CLOSE-FILES

           STOP RUN.




       START-FILES.
           OPEN INPUT INPUT-FILE
           IF WS-INPUT-STAT NOT = "00"
               STOP RUN
           END-IF.

           OPEN OUTPUT OUTPUT-FILE
           IF WS-OUTPUT-STAT NOT = "00"
               STOP RUN
           END-IF.

           OPEN INPUT ACCOUNTS-FILE
           IF WS-ACCOUNTS-STAT NOT = "00"
               STOP RUN
           END-IF.

           PERFORM UNTIL END-OF-ACCOUNTS
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
           CLOSE ACCOUNTS-FILE.

       CLOSE-FILES.
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE.

       WRITE-OUTPUT.
           DISPLAY WS-OUTPUT-LINE
           WRITE OUTPUT-LINE FROM WS-OUTPUT-LINE.

       READ-INPUT.
           READ INPUT-FILE INTO WS-INPUT-LINE
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
           MOVE "OPTION 1 PICKED" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.


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
               MOVE "Please enter your password:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               MOVE WS-INPUT-LINE TO WS-NEW-PASS

               PERFORM PASSWORD-VALIDATION

               IF PASSWORD-VALID
                   MOVE WS-INPUT-LINE TO WS-NEW-PASS
                   ADD 1 TO WS-TOTAL-ACCOUNTS
                   MOVE WS-NEW-USER TO WS-USERNAME(WS-TOTAL-ACCOUNTS)
                   MOVE WS-NEW-PASS TO WS-PASSWORD(WS-TOTAL-ACCOUNTS)
                   PERFORM SAVE-TO-ACCOUNTS
                   MOVE "Account Created!" TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               ELSE 
                   MOVE "Password doesn't satisfy requirements, 
      -                 "try again" 
                           TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               END-IF
           END-IF.
                   
       PASSWORD-VALIDATION.
           MOVE "Y" TO WS-VALID-PASS.
      *    DO VALIDATION IN THIS PARAGRAPH

       SAVE-TO-ACCOUNTS.
           OPEN OUTPUT ACCOUNTS-FILE
           PERFORM VARYING WS-INDEX FROM 1 BY 1
                   UNTIL WS-INDEX > WS-TOTAL-ACCOUNTS
               MOVE WS-USERNAME(WS-INDEX) TO ACC-USERNAME
               MOVE WS-PASSWORD(WS-INDEX) TO ACC-PASSWORD
               WRITE ACCOUNT-INSTANCE
           END-PERFORM
           CLOSE ACCOUNTS-FILE.

       SITE-MENU.
                   

           
           

       



      