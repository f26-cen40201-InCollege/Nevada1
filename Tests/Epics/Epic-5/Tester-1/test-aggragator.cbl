       IDENTIFICATION DIVISION.
       PROGRAM-ID. E5T1Ag.
       AUTHOR. Ian Koratsky.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 CountTestsPassed PIC 9(5) VALUE 0.
           01 CountTestsFailed PIC 9(5) VALUE 0.
           01 TestOutputs.
              05 TestsPassed PIC 9(5) VALUE 0.
              05 TestsFailed PIC 9(5) VALUE 0.

       LINKAGE SECTION.
           01 LSTestOutputs.
              05 LSTestsPassed PIC 9(5).
              05 LSTestsFailed PIC 9(5).

       PROCEDURE DIVISION USING LSTestOutputs.
           CALL "EXT1CXX" USING TestOutputs.
               ADD TestsPassed TO CountTestsPassed.
               ADD TestsFailed TO CountTestsFailed.

      * Aggregate and return

           MOVE CountTestsPassed TO LSTestsPassed.
           MOVE CountTestsFailed TO LSTestsFailed.

           GOBACK.