      * ================================================================
      * =================== START INSTRUCTIONS =========================

      * This is a boilerplate template for creating new tests

      * You should change the provided template at the start of the week
      * in the following way:

      * Ensure you update your name and any configurations
      * Ensure you update the program ID
      **** EX - Epic X - Your epic number
      **** TXXX - Your Test Number

      * Afterwards, you can copy this file as often as you need,
      * you should only need to change the variables and code sections

      * If you want to stack multiple tests in here, that's fine,
      * Just make sure you're updating the test counters each time
      * I've made the test sections easily copiable in case you want to
      * add more tests to one file

      * ==================== END INSTRUCTIONS ==========================
      * ================================================================
      
       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXTXXX.
       AUTHOR. YOUR NAME.

      

    *>    ENVIRONMENT DIVISION.
    *>    INPUT-OUTPUT SECTION.
    *>    FILE-CONTROL.
    *>        SELECT X ASSIGNED TO Y.
    *>        ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * These are needed for the test framework

           01 TestOutputs.
              05 TestsPassed PIC 9(5) VALUE 0.
              05 TestsFailed PIC 9(5) VALUE 0.

           
           01 TestResult PIC 9 VALUE 0. *> the main result you need
           

      * ================================================================
      * ================== START YOUR VARS HERE ========================
           01 ConditionFlag PIC 9 VALUE 0. *> change to whatever

      * =================== END YOUR VARS HERE =========================
      * ================================================================


       PROCEDURE DIVISION USING TestOutputs.

      * ================================================================
      * ==================== Start Test Case 1 =========================
      
      * Assume it will fail, but if it passes, change thie to a 1
           TestResult = 0

      * ==================== START YOUR CODE HERE ======================

      * This is the result that needs to be updated if it passes
      * Feel free to modify the Condition Flag to be whatever, the
      * main thing is ito ensure the test result is updated to 1 or 
      * left at 0 by the end
           IF ConditionFlag = 1
              TestResult = 1



      * =================== END YOUR CODE HERE =========================

      * This is a simple test counter that will need to run each time
      * Make sure to add it after you update TestResult
           IF TestResult = 1
              ADD 1 TO TestsPassed 
           ELSE
              ADD 1 TO TestsFailed
           END-IF

      * ==================== End Test Case 1 ===========================
      * ================================================================
      
      
      * ================================================================
      * ================================================================
           GOBACK. *> the return statement
