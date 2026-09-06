       IDENTIFICATION DIVISION.
       PROGRAM-ID. E10T1CXX.
       AUTHOR. YOUR NAME.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 TestOutputs.
              05 TestsPassed PIC 9(5) VALUE 0.
              05 TestsFailed PIC 9(5) VALUE 0.
           01 TestResult PIC 9 VALUE 0.

      * ================================================================
      * ================== START YOUR VARS HERE ========================
           01 ConditionFlag PIC 9 VALUE 0. *> change to whatever

      * =================== END YOUR VARS HERE =========================
      * ================================================================
       LINKAGE SECTION.
           01 LSTestOutputs.
              05 LSTestsPassed PIC 9(5).
              05 LSTestsFailed PIC 9(5).

       PROCEDURE DIVISION USING LSTestOutputs.

      * ================================================================
      * ==================== Start Test Case 1 =========================
      
      * Assume it will fail, but if it passes, change thie to a 1
           MOVE 0 TO TestResult.

      * ==================== START YOUR CODE HERE ======================

           IF ConditionFlag = 1
              MOVE 1 TO TestResult
           END-IF

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
      

      * any more tests here


      
      * ================================================================
           MOVE TestsPassed TO LSTestsPassed.
           MOVE TestsFailed TO LSTestsFailed.
           GOBACK. *> the return statement
