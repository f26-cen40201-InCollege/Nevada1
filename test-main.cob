      * ================================================================
      * =================== START INSTRUCTIONS =========================

      * This is the main test entry point.
      * All tests will be run through it
      * It's already set up to run all your tests, you just need
      * To focus on your Epic and Tester File

      * IMPORTANT: YOU MUST UPDATE THE COMPILE CODE IF YOU ADD A FILE TO BE TESTED:

      * cobc -x -o test-main test-main.cob InCollege-Core.cob
      * ./test-main
      * then simply run: ./test-main to run all tests
      * if someone wants to make a way to add particular tests, feel free!

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
           FD OUTPUT-FILE.
           01 OUTPUT-FILE-REC PIC X(100).

           FD TEST-INPUT-FILE.
           01 TEST-INPUT-FILE-REC PIC X(100).

           FD TEST-INPUT-CONSOLIDATED.
           01 TEST-INPUT-CONSOLIDATED-REC PIC X(100).
           
           FD EXPECTED-FILE.
           01 EXPECTED-FILE-REC PIC X(100).

           FD OUTPUT-FILE-CONSOLIDATED.
           01 OUTPUT-CONSOLIDATED-REC PIC X(100).
           
           FD EXPECTED-FILE-CONSOLIDATED.
           01 EXPECTED-CONSOLIDATED-REC PIC X(100).
       WORKING-STORAGE SECTION.

      * Booleans
           01 WS-OUTPUT-EOF PIC X VALUE "N".
               88 WS-OUTPUT-END VALUE "Y".
           
           01 WS-EXPECTED-EOF PIC X VALUE "N".
                88 WS-EXPECTED-END VALUE "Y".

           01 WS-MISMATCH PIC X VALUE "N".
                88 MISMATCH-FOUND VALUE "Y".

           

      * Counters
           01 TotalTestsPassed PIC 9(5) VALUE 0.
           01 TotalTestsFailed PIC 9(5) VALUE 0.

      * Test Input
           01 WS-TEST-INPUT PIC X(100).
           01 WS-TEST-CODE PIC X(100).
           01 WS-FOLDER PIC X(100).

           01 WS-TEST-CONSOLDATED-LINE PIC X(100).

      * Output
           01 WS-OUTPUT-LINE PIC X(100).
           01 WS-OUTPUT-FILE PIC X(100).
           01 WS-OUTPUT-STAT PIC XX.
           01 WS-OUTPUT-STAT-CONSOLIDATED PIC XX.

      * Expected
           01 WS-EXPECTED-LINE PIC X(100).
           01 WS-EXPECTED-FILE PIC X(100).
           01 WS-EXPECTED-STAT PIC XX.
           01 WS-EXPECTED-STAT-CONSOLIDATED PIC XX.


      * Consolidated
           01 WS-OUTPUT-FILE-CONSOLIDATED PIC X(100)
               VALUE "tests-tester-1-output.txt".
           01 OUTPUT-CONSOLIDATED-LINE PIC X(100).
           01 WS-EXPECTED-FILE-CONSOLIDATED PIC X(100)
               VALUE "tests-tester-1-expected.txt".
           01 EXPECTED-CONSOLIDATED-LINE PIC X(100).

           01 WS-TEST-INPUT-STAT PIC XX.

           01 WS-TEST-INPUT-CONSOLIDATED PIC X(100)
               VALUE "tests-tester-1-input.txt".
           01 WS-TEST-INPUT-CONSOLIDATED-STAT PIC XX.
           01 WS-INPUT-LINE PIC X(100).
           01 WS-INPUT-EOF PIC X VALUE "N".
               88 WS-INPUT-END VALUE "Y".
               
      * helpers

           01 WS-TEST-HEADER PIC X(100).
           01 WS-PATH-SUFFIX PIC X(20).
           01 WS-BUILT-PATH PIC X(100).

           01 WS-CHECK-STAT PIC XX.
           01 WS-CHECK-NAME PIC X(100).

       PROCEDURE DIVISION.

           PERFORM START-CONSOLIDATE-FILES.

           MOVE 0 TO TotalTestsPassed.
           MOVE 0 TO TotalTestsFailed.

      * EXAMPLE USING EPIC 1 :
      *> * Use this to set a code you're going to test
           MOVE SPACES TO WS-TEST-CODE.
           MOVE "INCOLLEGE-CORE" TO WS-TEST-CODE. 
      
      * For Each test, copy this once and change the folder:
        *>    MOVE "tests/epic-1/tester-1/account-creation-neg-1/" TO WS-FOLDER.
        *>    PERFORM COUNTER-UPDATE.
      * And we're done with this test!
      
      * See how you don't need to change the WS-TEST-CODE?
      * That's because all the tests are for the same code
      * Until you need to change it!

      * Now just copy the below as often as you need:

           MOVE "tests/epic-1/tester-1/account-creation-pos-1/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/account-creation-neg-1/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/menus-neg-1/" TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

       PERFORM CLOSE-CONSOLIDATED-FILES.
       DISPLAY "Total Tests Passed: " TotalTestsPassed.
       DISPLAY "Total Tests Failed: " TotalTestsFailed.
       STOP RUN.


       START-FILES.

           OPEN INPUT  OUTPUT-FILE.
           MOVE WS-OUTPUT-STAT TO WS-CHECK-STAT.
           MOVE WS-OUTPUT-FILE TO WS-CHECK-NAME.
           PERFORM VERIFY-FILE-OPEN.
           
           OPEN INPUT  EXPECTED-FILE.
           MOVE WS-EXPECTED-STAT TO WS-CHECK-STAT.
           MOVE WS-EXPECTED-FILE TO WS-CHECK-NAME.
           PERFORM VERIFY-FILE-OPEN.


       CLOSE-FILES.
           CLOSE OUTPUT-FILE.
           CLOSE EXPECTED-FILE.

       VERIFY-FILE-OPEN.
           IF WS-CHECK-STAT NOT = "00"
               DISPLAY "ERROR OPENING" WS-CHECK-NAME
               DISPLAY "FILE STATUS: " WS-CHECK-STAT
               STOP RUN
           END-IF.

       START-CONSOLIDATE-FILES.

           OPEN OUTPUT  OUTPUT-FILE-CONSOLIDATED.
           MOVE WS-OUTPUT-STAT-CONSOLIDATED TO WS-CHECK-STAT.
           MOVE WS-OUTPUT-CONSOLIDATED TO WS-CHECK-NAME.
           PERFORM VERIFY-FILE-OPEN.
           
           OPEN OUTPUT  EXPECTED-FILE-CONSOLIDATED.
           MOVE WS-EXPECTED-STAT-CONSOLIDATED TO WS-CHECK-STAT.
           MOVE WS-EXPECTED-FILE-CONSOLIDATED TO WS-CHECK-NAME.
           PERFORM VERIFY-FILE-OPEN.

           OPEN OUTPUT  TEST-INPUT-CONSOLIDATED.
           MOVE WS-TEST-INPUT-CONSOLIDATED-STAT TO WS-CHECK-STAT.
           MOVE WS-TEST-INPUT-CONSOLIDATED TO WS-CHECK-NAME.
           PERFORM VERIFY-FILE-OPEN.


       COPY-INPUT.

           MOVE "N" TO WS-INPUT-EOF.
       
           OPEN INPUT TEST-INPUT-FILE
           IF WS-TEST-INPUT-STAT NOT = "00"
               DISPLAY "ERR"
               STOP RUN
           END-IF

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

       CLOSE-CONSOLIDATED-FILES.
           CLOSE OUTPUT-FILE-CONSOLIDATED.
           CLOSE EXPECTED-FILE-CONSOLIDATED.
           CLOSE TEST-INPUT-CONSOLIDATED.



       COUNTER-UPDATE.

           STRING 
               "==== TEST: "
               WS-FOLDER
               "===="
               DELIMITED BY SIZE 
               INTO WS-TEST-HEADER
           END-STRING.

           WRITE OUTPUT-CONSOLIDATED-REC
               FROM WS-TEST-HEADER.
           WRITE EXPECTED-CONSOLIDATED-REC
               FROM WS-TEST-HEADER.

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


           PERFORM UNTIL WS-OUTPUT-END
                   AND WS-EXPECTED-END 

               IF NOT WS-OUTPUT-END
                   PERFORM READ-OUTPUT
               END-IF

               IF NOT WS-EXPECTED-END
                   PERFORM READ-EXPECTED
               END-IF


               
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

           IF MISMATCH-FOUND OR WS-OUTPUT-EOF NOT = WS-EXPECTED-EOF
               ADD 1 TO TotalTestsFailed
           ELSE
               ADD 1 TO TotalTestsPassed
           END-IF.

           PERFORM CLOSE-FILES.
           MOVE "N" TO WS-MISMATCH.
           MOVE "N" TO WS-OUTPUT-EOF.
           MOVE "N" TO WS-EXPECTED-EOF.
           MOVE SPACES TO WS-FOLDER.
           MOVE SPACES TO WS-OUTPUT-LINE.
           MOVE SPACES TO WS-EXPECTED-LINE.
           MOVE SPACES TO WS-TEST-INPUT.
           MOVE SPACES TO WS-OUTPUT-FILE.
           MOVE SPACES TO WS-EXPECTED-FILE.


       BUILD-TEST-PATH.
           STRING WS-FOLDER delimited by space
               WS-PATH-SUFFIX delimited by size
             INTO WS-BUILT-PATH
             ON overflow
               DISPLAY "err building path" WS-PATH-SUFFIX
           END-STRING.

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
           