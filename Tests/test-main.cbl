      * ================================================================
      * =================== START INSTRUCTIONS =========================

      * This is the main test entry point.
      * All tests will be run through it
      * It's already set up to run all your tests, you just need
      * To focus on your Epic and Tester File

      * ==================== END INSTRUCTIONS ==========================
      * ================================================================

       IDENTIFICATION DIVISION.
       PROGRAM-ID. Tests.
       AUTHOR. Ian Koratsky.


       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 TotalTestsPassed PIC 9(5) VALUE 0.
           01 TotalTestsFailed PIC 9(5) VALUE 0.

           01 TestOutputs.
              05 TestsPassed PIC 9(5).
              05 TestsFailed PIC 9(5).

       PROCEDURE DIVISION.

      *    EPIC 1 
           CALL "E1T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E1T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 2
           CALL "E2T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E2T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 3 
           CALL "E3T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E3T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 4
           CALL "E4T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E4T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 5
           CALL "E5T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E5T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 6
           CALL "E6T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E6T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 7
           CALL "E7T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E7T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 8
           CALL "E8T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E8T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 9
           CALL "E9T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E9T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

      *    EPIC 10
           CALL "E10T1Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.
           CALL "E10T2Ag" USING TestOutputs.
              ADD TestsPassed TO TotalTestsPassed.
              ADD TestsFailed TO TotalTestsFailed.

       DISPLAY "Total Tests Passed: " TotalTestsPassed.
       DISPLAY "Total Tests Failed: " TotalTestsFailed.
       STOP RUN.
           