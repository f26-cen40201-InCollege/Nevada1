
       BROWSE-JOBS.
           MOVE "N" TO WS-BROWSE-DONE
           PERFORM UNTIL BROWSE-DONE OR END-OF-INPUT
               MOVE "--- Available Job Listings ---" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               IF WS-TOTAL-JOBS = 0
                   MOVE "No jobs available now." TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
                   MOVE "-------------------" TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
                   MOVE "Y" TO WS-BROWSE-DONE
               ELSE
                   PERFORM LIST-ALL-JOBS
                   PERFORM SELECT-JOB
               END-IF
           END-PERFORM.

       LIST-ALL-JOBS.
           PERFORM VARYING WS-JOB-IDX FROM 1 BY 1
                   UNTIL WS-JOB-IDX > WS-TOTAL-JOBS
               MOVE WS-JOB-IDX TO WS-JOB-NUM-DISP
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING FUNCTION TRIM(WS-JOB-NUM-DISP) ". "
                   FUNCTION TRIM(WS-JOB-TITLE(WS-JOB-IDX))
                   " at "
                   FUNCTION TRIM(WS-JOB-EMPLOYER(WS-JOB-IDX))
                   " ("
                   FUNCTION TRIM(WS-JOB-LOCATION(WS-JOB-IDX))
                   ")"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               END-STRING
               PERFORM WRITE-OUTPUT
           END-PERFORM
           MOVE "-----------------------------" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.

       SELECT-JOB.
           MOVE "Enter job number to view details, or 0 to go back:"
               TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           PERFORM READ-INPUT
           IF NOT END-OF-INPUT
               PERFORM SELECTION-VALID
               IF NOT VALIDATED
                   MOVE "Invalid Job Number, Try Again." 
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               ELSE
                   IF WS-JOB-SEL = 0
                       MOVE "Y" TO WS-BROWSE-DONE
                   ELSE
                       PERFORM VIEW-DETAILS
                   END-IF
               END-IF
           END-IF.

       SELECTION-VALID.
           MOVE "N" TO WS-VALID-RESPONSE
           MOVE 0 TO WS-JOB-SEL
           IF WS-INPUT-LINE NOT = SPACES
               MOVE FUNCTION TRIM(WS-INPUT-LINE) TO WS-INPUT-LINE
               COMPUTE WS-FIELD-LEN = 
                   FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-LINE))
               IF WS-FIELD-LEN <= 3
                   IF WS-INPUT-LINE(1:WS-FIELD-LEN) IS NUMERIC
                       COMPUTE WS-JOB-SEL = FUNCTION NUMVAL(
                           WS-INPUT-LINE(1:WS-FIELD-LEN))
                       IF WS-JOB-SEL <= WS-TOTAL-JOBS
                           MOVE "Y" TO WS-VALID-RESPONSE
                       END-IF
                   END-IF
               END-IF
           END-IF.

       VIEW-DETAILS.
           MOVE "N" TO WS-DETAIL-DONE
           PERFORM UNTIL DETAIL-DONE OR END-OF-INPUT
               PERFORM DISPLAY-DETAILS
               MOVE "1. Apply for this Job" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "2. Back to Job List" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "Enter Your Choice:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE WS-INPUT-LINE TO WS-CHOICE
                   EVALUATE WS-CHOICE
                       WHEN "1"
                           PERFORM APPLY-JOB
                           MOVE "Y" TO WS-DETAIL-DONE
                       WHEN "2"
                           MOVE "Y" TO WS-DETAIL-DONE
                       WHEN OTHER
                           MOVE "Invalid Option, Try Again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                   END-EVALUATE
               END-IF
           END-PERFORM.

       DISPLAY-DETAILS.
           MOVE "--- Job Details ---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Title: "
               FUNCTION TRIM(WS-JOB-TITLE(WS-JOB-SEL))
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Description: "
               FUNCTION TRIM(WS-JOB-DESCR(WS-JOB-SEL))
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           STRING "Employer: "
               FUNCTION TRIM(WS-JOB-EMPLOYER(WS-JOB-SEL))
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           STRING "Location: "
               FUNCTION TRIM(WS-JOB-LOCATION(WS-JOB-SEL))
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           IF WS-JOB-SALARY(WS-JOB-SEL) NOT = SPACES
               STRING "Salary: "
                   FUNCTION TRIM(WS-JOB-SALARY(WS-JOB-SEL))
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF
           MOVE "-------------------" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.
       