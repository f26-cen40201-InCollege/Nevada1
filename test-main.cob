      * ================================================================
      * =================== START INSTRUCTIONS =========================

      * This is the main test entry point.
      * All tests will be run through it
      * It's already set up to run all your tests, you just need
      * To focus on your Epic and Tester File

      * IMPORTANT: YOU MUST UPDATE THE COMPILE CODE IF YOU ADD A FILE TO BE TESTED:

      * cobc -x -o incollege test-main.cob InCollege-Core.cob  #<your-code.cob here>
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


       DATA DIVISION.
       FILE SECTION.
           FD OUTPUT-FILE.
           01 OUTPUT-FILE-LINE PIC X(100).
           
           FD EXPECTED-FILE.
           01 EXPECTED-FILE-LINE PIC X(100).

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

      * Output
           01 WS-OUTPUT-LINE PIC X(100).
           01 WS-OUTPUT-FILE PIC X(100).
           01 WS-OUTPUT-STAT PIC XX.

      * Expected
           01 WS-EXPECTED-LINE PIC X(100).
           01 WS-EXPECTED-FILE PIC X(100).
           01 WS-EXPECTED-STAT PIC XX.


       PROCEDURE DIVISION.

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

           MOVE "tests/epic-1/tester-1/account-creation-pos-2/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/account-creation-neg-1/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/account-creation-neg-2/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           

           MOVE "tests/epic-1/tester-1/menus-pos-1/" TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/menus-pos-2/" TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/menus-neg-1/" TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/menus-neg-2/" TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/menus-neg-3/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.

           MOVE "tests/epic-1/tester-1/menus-neg-4/" 
               TO WS-FOLDER.
           PERFORM COUNTER-UPDATE.


       DISPLAY "Total Tests Passed: " TotalTestsPassed.
       DISPLAY "Total Tests Failed: " TotalTestsFailed.
       STOP RUN.


       START-FILES.
           
           OPEN INPUT OUTPUT-FILE
           IF WS-OUTPUT-STAT NOT = "00"
               DISPLAY "Error opening output file: " WS-OUTPUT-FILE
               DISPLAY "File status: " WS-OUTPUT-STAT
               STOP RUN
           END-IF.
           
           OPEN INPUT EXPECTED-FILE
           IF WS-EXPECTED-STAT NOT = "00"
             DISPLAY "Error opening expected file: " WS-EXPECTED-FILE
             DISPLAY "File status: " WS-EXPECTED-STAT
             STOP RUN
           END-IF.


       CLOSE-FILES.
           CLOSE OUTPUT-FILE.
           CLOSE EXPECTED-FILE.



       COUNTER-UPDATE.

           STRING WS-FOLDER DELIMITED BY SPACE
              "input.txt" DELIMITED BY SIZE
               INTO WS-TEST-INPUT
               ON OVERFLOW
                   DISPLAY "Error: WS-TEST-INPUT"
           END-STRING

           STRING WS-FOLDER DELIMITED BY SPACE
              "output.txt" DELIMITED BY SIZE
               INTO WS-OUTPUT-FILE
               ON OVERFLOW
                   DISPLAY "Error: WS-OUTPUT-FILE"
           END-STRING
           
           STRING WS-FOLDER DELIMITED BY SPACE
              "expected.txt" DELIMITED BY SIZE
               INTO WS-EXPECTED-FILE
               ON OVERFLOW
                   DISPLAY "Error: WS-EXPECTED-FILE"
           END-STRING

           CALL WS-TEST-CODE USING WS-TEST-INPUT WS-OUTPUT-FILE.
       
           PERFORM START-FILES.

           PERFORM UNTIL WS-OUTPUT-END
                   OR WS-EXPECTED-END 
                   OR MISMATCH-FOUND
               PERFORM READ-OUTPUT
               PERFORM READ-EXPECTED
               IF WS-OUTPUT-LINE NOT = WS-EXPECTED-LINE 
                   MOVE "Y" TO WS-MISMATCH
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

       READ-EXPECTED.
           READ EXPECTED-FILE INTO WS-EXPECTED-LINE
               AT END
                   MOVE "Y" TO WS-EXPECTED-EOF
                   MOVE SPACES TO WS-EXPECTED-LINE
           END-READ.

       READ-OUTPUT.
           READ OUTPUT-FILE INTO WS-OUTPUT-LINE
               AT END
                   MOVE "Y" TO WS-OUTPUT-EOF
                   MOVE SPACES TO WS-OUTPUT-LINE
           END-READ.
           