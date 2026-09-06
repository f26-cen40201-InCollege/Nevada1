      * This is the main test entry point. When run, it will execute all test cases.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. Tests.
       AUTHOR. Ian Koratsky.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT test-main ASSIGNED TO Test-Cases.
           ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 TestsPassed PIC 9(5) VALUE 0.
           01 TestsFailed PIC 9(5) VALUE 0.

       PROCEDURE DIVISION.
           CALL ""
           