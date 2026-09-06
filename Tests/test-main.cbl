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

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
    *>    FILE-CONTROL.
    *>        SELECT test-main ASSIGNED TO Test-Cases.
    *>        ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 TestOutputs.
              05 TestsPassed PIC 9(5) VALUE 0.
              05 TestsFailed PIC 9(5) VALUE 0.
           
           01 TotalTestsPassed PIC 9(5) VALUE 0.
           01 TotalTestsFailed PIC 9(5) VALUE 0.

       PROCEDURE DIVISION.

      *    EPIC 1 
           CALL "Epics/Epic-1/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 2
           CALL "Epics/Epic-2/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 3 
           CALL "Epics/Epic-3/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 4
           CALL "Epics/Epic-4/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 5
           CALL "Epics/Epic-5/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 6
           CALL "Epics/Epic-6/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 7
           CALL "Epics/Epic-7/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 8
           CALL "Epics/Epic-8/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 9
           CALL "Epics/Epic-9/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

      *    EPIC 10
           CALL "Epics/Epic-10/test-aggragator" USING TestOutputs
              ADD TestOutputs(1) TO TotalTestsPassed
              ADD TestOutputs(2) TO TotalTestsFailed

           