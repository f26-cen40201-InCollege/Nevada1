      * ================================================================
      * =================== START INSTRUCTIONS =========================

      *> This is the main test entry point.
      *> All tests will be run through it
      *> It's already set up to run all your tests, you just need
      *> To focus on your Epic and Tester File

      *> IMPORTANT: YOU MUST UPDATE THE COMPILE CODE IF YOU ADD A FILE TO BE TESTED:

      *> cobc -x -o test-main test-main.cob InCollege-Core.cob \ ./test-main
      *> then simply run: ./test-main to run all tests
      *> if someone wants to make a way to add particular tests, feel free!

      

      * ==================== END INSTRUCTIONS ==========================
      * ================================================================

       IDENTIFICATION DIVISION.
       PROGRAM-ID. test-main.
       AUTHOR. Ian Koratsky.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

         SELECT OUTPUT-FILE ASSIGN TO WS-OUTPUT-FILE
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-OUTPUT-STAT.

         SELECT EXPECTED-FILE ASSIGN TO WS-EXPECTED-FILE
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-EXPECTED-STAT.

         SELECT OUTPUT-FILE-CONSOLIDATED 
           ASSIGN TO WS-OUTPUT-FILE-CONSOLIDATED
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-OUTPUT-STAT-CONSOLIDATED.

         SELECT EXPECTED-FILE-CONSOLIDATED 
           ASSIGN TO WS-EXPECTED-FILE-CONSOLIDATED
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-EXPECTED-STAT-CONSOLIDATED.

         SELECT TEST-INPUT-FILE ASSIGN TO WS-TEST-INPUT
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-TEST-INPUT-STAT.
         
         SELECT TEST-INPUT-CONSOLIDATED
           ASSIGN TO WS-TEST-INPUT-CONSOLIDATED
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-TEST-INPUT-CONSOLIDATED-STAT.

       DATA DIVISION.
       FILE SECTION.


      *    ========================= Test Files ========================

           FD TEST-INPUT-FILE.
           01 TEST-INPUT-FILE-REC PIC X(100).

           FD OUTPUT-FILE.
           01 OUTPUT-FILE-REC PIC X(100).
           
           FD EXPECTED-FILE.
           01 EXPECTED-FILE-REC PIC X(100).

      *    ====================== Original Files =======================
           
           01 ACCOUNTS-PATH PIC X(100).

      *    ==================== Condolidation Files ====================

           FD TEST-INPUT-CONSOLIDATED.
           01 TEST-INPUT-CONSOLIDATED-REC PIC X(100).

           FD OUTPUT-FILE-CONSOLIDATED.
           01 OUTPUT-CONSOLIDATED-REC PIC X(100).
           
           FD EXPECTED-FILE-CONSOLIDATED.
           01 EXPECTED-CONSOLIDATED-REC PIC X(100).


       WORKING-STORAGE SECTION.

      *    ========================== Booleans==========================
           01 WS-OUTPUT-EOF PIC X VALUE "N".
               88 WS-OUTPUT-END VALUE "Y".
           
           01 WS-EXPECTED-EOF PIC X VALUE "N".
                88 WS-EXPECTED-END VALUE "Y".

           01 WS-MISMATCH PIC X VALUE "N".
                88 MISMATCH-FOUND VALUE "Y".

           01 NOT-FINAL-OUTPUT PIC X VALUE "N".
                88 FINAL-OUTPUT VALUE "Y".

      *    ========================== Counters========================== 

           01 TotalTestsPassed PIC 9(5) VALUE 0.
           01 TotalTestsFailed PIC 9(5) VALUE 0.

      *    ========================= Test Input========================= 

           01 WS-TEST-INPUT PIC X(100).
           01 WS-TEST-CODE PIC X(100).
           01 WS-FOLDER PIC X(100).

           01 WS-TEST-CONSOLDATED-LINE PIC X(100).

      *    =========================== Output=========================== 

           01 WS-OUTPUT-LINE PIC X(100).
           01 WS-OUTPUT-FILE PIC X(100).
           01 WS-OUTPUT-STAT PIC XX.
           01 WS-OUTPUT-STAT-CONSOLIDATED PIC XX.

      *    ========================== Expected========================== 
           01 WS-EXPECTED-LINE PIC X(100).
           01 WS-EXPECTED-FILE PIC X(100).
           01 WS-EXPECTED-STAT PIC XX.
           01 WS-EXPECTED-STAT-CONSOLIDATED PIC XX.


      *    ======================== Consolidated========================
           01 WS-OUTPUT-FILE-CONSOLIDATED PIC X(100)
               VALUE "tests-output.txt".
           01 OUTPUT-CONSOLIDATED-LINE PIC X(100).
           01 WS-EXPECTED-FILE-CONSOLIDATED PIC X(100)
               VALUE "tests-expected.txt".
           01 EXPECTED-CONSOLIDATED-LINE PIC X(100).

           01 WS-TEST-INPUT-STAT PIC XX.

           01 WS-TEST-INPUT-CONSOLIDATED PIC X(100)
               VALUE "tests-input.txt".
           01 WS-TEST-INPUT-CONSOLIDATED-STAT PIC XX.
           01 WS-INPUT-LINE PIC X(100).
           01 WS-INPUT-EOF PIC X VALUE "N".
               88 WS-INPUT-END VALUE "Y".
               
      *    ========================== Helpers ==========================

           01 WS-TEST-HEADER PIC X(100).
           01 WS-PATH-SUFFIX PIC X(20).
           01 WS-BUILT-PATH PIC X(100).
           01 WS-INITIAL-CONDITION PIC X(100).
           01 WS-OVERRIDE-INITIAL-CONDITON PIC X(100).
           01 WS-OVERRIDE-INITIAL-CONDITON-FILE PIC X(100).

           01 WS-CHECK-STAT PIC XX.
           01 WS-CHECK-NAME PIC X(100).

           01 WS-SHOW-HEADERS PIC X VALUE "N".
               88 SHOW-HEADERS VALUE "Y".

           01 RETURNCODE pic 9(4) comp.

       PROCEDURE DIVISION.
      
      *    =============================================================
      *    =============================================================
      *    ===================== START TOGGLE VARS =====================

      *    Uncomment the below to output headers for debugging

      *     SET SHOW-HEADERS TO TRUE.

      *    This will push the outputs to what we need to submit
           SET FINAL-OUTPUT TO TRUE.

      *    ===================== END TOGGLE VARS =======================
      *    =============================================================
      *    =============================================================

           PERFORM START-CONSOLIDATE-FILES.
           PERFORM SET-ORIGINAL-FILES. *> CALL ONLY ONCE!

           MOVE 0 TO TotalTestsPassed.
           MOVE 0 TO TotalTestsFailed.



      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =================== EXAMPLE USING EPIC 1 ====================

      *    Use this to set a code you're going to test
           MOVE SPACES TO WS-TEST-CODE.
           MOVE "INCOLLEGE-CORE" TO WS-TEST-CODE.       

      *    Now just copy the below as often as you need:

      *    ====================== Option 1: Basic ======================

           MOVE "tests/epic-1/tester-1/account-creation-neg-1/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

      *    ==================== Option 2: Advanced =====================

      *    If you need to set a file to a specific initial condition,
      *    use this instead
           MOVE "tests/epic-1/tester-1/account-creation-pos-1/" 
               TO WS-FOLDER.
           MOVE "accounts.txt" TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           PERFORM COUNTER-UPDATE.

      *    ======================= END EXAMPLE =========================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================




      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    ===================== START YOUR TESTS ======================    

           MOVE "tests/epic-1/tester-1/menus-neg-1/" TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.


      *    ====================== END YOUR TESTS =======================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================

      *    Now we close everything, and print the results

           PERFORM CLOSE-CONSOLIDATED-FILES.
           DISPLAY "Total Tests Passed: " TotalTestsPassed.
           DISPLAY "Total Tests Failed: " TotalTestsFailed.
           STOP RUN.

      *    =============================================================
      *    =============================================================
      *    ======================== PARAGRAPHS =========================
      *    =============================================================
      *    =============================================================
           COUNTER-UPDATE.
          
      *    ======================= Test Headers ========================
          
      *    Helps with debugging our tests
    
               IF SHOW-HEADERS
                   STRING 
                       "==== TEST: "
                       WS-FOLDER
                       "===="
                       DELIMITED BY SIZE 
                       INTO WS-TEST-HEADER
                   END-STRING
                   WRITE OUTPUT-CONSOLIDATED-REC
                       FROM WS-TEST-HEADER
                   WRITE EXPECTED-CONSOLIDATED-REC
                       FROM WS-TEST-HEADER
               END-IF.
    
    
      *    ==================== Input Output Copiers ===================
        
      *    These are used to rapidly copy our inputs and outputs to a
      *    reusable set of riles
    
               MOVE "input.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-TEST-INPUT.
    
               MOVE "output.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-OUTPUT-FILE.
    
               MOVE "expected.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-EXPECTED-FILE.
    
               CALL WS-TEST-CODE USING WS-TEST-INPUT WS-OUTPUT-FILE.
               PERFORM COPY-INPUT.
           
               PERFORM START-FILES.
    
    
      *    ============================ Loop ===========================
    
               PERFORM UNTIL WS-OUTPUT-END AND WS-EXPECTED-END
    
      *    This allows us to tst if a file is shorter than the other
                   IF NOT WS-OUTPUT-END
                       PERFORM READ-OUTPUT
                   END-IF
    
                   IF NOT WS-EXPECTED-END
                       PERFORM READ-EXPECTED
                   END-IF
    
      *        This allows us to test if a line mismatches
    
                   IF NOT WS-OUTPUT-END AND NOT WS-EXPECTED-END          
                       IF WS-OUTPUT-LINE NOT = WS-EXPECTED-LINE
                           MOVE "Y" TO WS-MISMATCH
                       END-IF
                   ELSE
                       IF WS-OUTPUT-EOF NOT = WS-EXPECTED-EOF
                           MOVE "Y" TO WS-MISMATCH
                       END-IF
                   END-IF
                   
               END-PERFORM.
    
      *        Case counter
    
               IF MISMATCH-FOUND OR WS-OUTPUT-EOF NOT = WS-EXPECTED-EOF
                   ADD 1 TO TotalTestsFailed
               ELSE
                   ADD 1 TO TotalTestsPassed
               END-IF.
    
      *        Clear vars and files
               PERFORM CLOSE-FILES.
               PERFORM RESET-ORIGINAL-FILES.
               MOVE "N" TO WS-MISMATCH.
               MOVE "N" TO WS-OUTPUT-EOF.
               MOVE "N" TO WS-EXPECTED-EOF.
               MOVE SPACES TO WS-FOLDER.
               MOVE SPACES TO WS-OUTPUT-LINE.
               MOVE SPACES TO WS-EXPECTED-LINE.
               MOVE SPACES TO WS-TEST-INPUT.
               MOVE SPACES TO WS-OUTPUT-FILE.
               MOVE SPACES TO WS-EXPECTED-FILE.




      *    Here we set any oringal files needed to 
           SET-ORIGINAL-FILES.
                move 0 to RETURNCODE.

      *    Now we set backups of any files that we use, such as accounts
      *    This allows us to change the file we need to mutate on the
      *    The fly before a test
      *    To set up a standard, just copy the below into both the
      *    Set and rest vars
                CALL "COPY-FILE" USING 
                    "Accounts.txt"
                    "Accounts-backup.txt" 
                    RETURNCODE.

           RESET-ORIGINAL-FILES.
                move 0 to RETURNCODE.
     
      *    Now we reset any files that we use, such as accounts

               CALL "COPY-FILE" USING 
                   "Accounts-backup.txt" 
                   "Accounts.txt"
                   RETURNCODE.
           
      *    ===================== Helper functions ======================

       

           BUILD-TEST-PATH.
               MOVE SPACES TO WS-BUILT-PATH.
               STRING WS-FOLDER delimited by space
                   WS-PATH-SUFFIX delimited by space
                 INTO WS-BUILT-PATH
                 ON overflow
                   DISPLAY "err building path" WS-PATH-SUFFIX
               END-STRING.
    
           MODIFY-INITIAL-CONDITON-FILE.
               
               MOVE WS-OVERRIDE-INITIAL-CONDITON TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-OVERRIDE-INITIAL-CONDITON-FILE.
    
    
               CALL "COPY-FILE" USING 
                   WS-OVERRIDE-INITIAL-CONDITON-FILE
                   WS-INITIAL-CONDITION
                   RETURNCODE.
          
           COPY-INPUT.
    
               MOVE "N" TO WS-INPUT-EOF.
           
               OPEN INPUT TEST-INPUT-FILE.
               IF WS-TEST-INPUT-STAT NOT = "00"
                   DISPLAY "ERR"
                   STOP RUN
               END-IF.
    
               PERFORM UNTIL WS-INPUT-END
                    READ TEST-INPUT-FILE INTO WS-INPUT-LINE
                         AT END
                              MOVE "Y" TO WS-INPUT-EOF
                         NOT AT END
                              WRITE TEST-INPUT-CONSOLIDATED-REC
                                FROM WS-INPUT-LINE
                    END-READ
               END-PERFORM
    
               CLOSE TEST-INPUT-FILE.
    
           VERIFY-FILE-OPEN.
               IF WS-CHECK-STAT NOT = "00"
                   DISPLAY "ERROR OPENING" WS-CHECK-NAME
                   DISPLAY "FILE STATUS: " WS-CHECK-STAT
                   STOP RUN
               END-IF.
    
           READ-EXPECTED.
               READ EXPECTED-FILE INTO WS-EXPECTED-LINE
                   AT END
                       MOVE "Y" TO WS-EXPECTED-EOF
                       MOVE SPACES TO WS-EXPECTED-LINE
                   NOT AT END
                       WRITE EXPECTED-CONSOLIDATED-REC
                           FROM WS-EXPECTED-LINE
               END-READ.
    
           READ-OUTPUT.
               READ OUTPUT-FILE INTO WS-OUTPUT-LINE
                   AT END
                       MOVE "Y" TO WS-OUTPUT-EOF
                       MOVE SPACES TO WS-OUTPUT-LINE
                   NOT AT END
                       WRITE OUTPUT-CONSOLIDATED-REC
                           FROM WS-OUTPUT-LINE
               END-READ.
    
    
           START-FILES.
    
               OPEN INPUT  OUTPUT-FILE.
               MOVE WS-OUTPUT-STAT TO WS-CHECK-STAT.
               MOVE WS-OUTPUT-FILE TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
               
               OPEN INPUT  EXPECTED-FILE.
               MOVE WS-EXPECTED-STAT TO WS-CHECK-STAT.
               MOVE WS-EXPECTED-FILE TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
    
    
           START-CONSOLIDATE-FILES.
    
      *        This ensures that we can submit all the tests
               IF FINAL-OUTPUT
                   MOVE "InCollege-Input.txt" 
                       TO WS-TEST-INPUT-CONSOLIDATED
                   MOVE "InCollege-Output.txt" 
                       TO WS-OUTPUT-FILE-CONSOLIDATED
               END-IF.
    
      *        If it's false, they get sent to the test files
    
               OPEN OUTPUT  OUTPUT-FILE-CONSOLIDATED.
               MOVE WS-OUTPUT-STAT-CONSOLIDATED TO WS-CHECK-STAT.
               MOVE WS-OUTPUT-FILE-CONSOLIDATED TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
               
               OPEN OUTPUT  EXPECTED-FILE-CONSOLIDATED.
               MOVE WS-EXPECTED-STAT-CONSOLIDATED TO WS-CHECK-STAT.
               MOVE WS-EXPECTED-FILE-CONSOLIDATED TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
    
               OPEN OUTPUT  TEST-INPUT-CONSOLIDATED.
               MOVE WS-TEST-INPUT-CONSOLIDATED-STAT TO WS-CHECK-STAT.
               MOVE WS-TEST-INPUT-CONSOLIDATED TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
    
    
           CLOSE-FILES.
               CLOSE OUTPUT-FILE.
               CLOSE EXPECTED-FILE.
    
           CLOSE-CONSOLIDATED-FILES.
               CLOSE OUTPUT-FILE-CONSOLIDATED.
               CLOSE EXPECTED-FILE-CONSOLIDATED.
               CLOSE TEST-INPUT-CONSOLIDATED.
           