
       VIEW-APPLICATIONS.
           MOVE "--- Your Job Applications ---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Application Summary for "
               FUNCTION TRIM(WS-LOGIN-USER)
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "------------------------------" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT

           MOVE 0 TO WS-APP-COUNT
           PERFORM VARYING WS-APP-IDX FROM 1 BY 1
                   UNTIL WS-APP-IDX > WS-TOTAL-APPS
               IF WS-APP-USER(WS-APP-IDX) = WS-LOGIN-USER
                   IF WS-APP-COUNT > 0
                       MOVE "---" TO WS-OUTPUT-LINE
                       PERFORM WRITE-OUTPUT
                   END-IF
                   ADD 1 TO WS-APP-COUNT
                   MOVE WS-APP-JOB-ID(WS-APP-IDX) TO WS-LOOKUP-JOB-ID
                   PERFORM FIND-JOB
                   PERFORM WRITE-APPLICATION
               END-IF
           END-PERFORM

           IF WS-APP-COUNT = 0
               MOVE "You have not applied to any jobs yet." 
                   TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF

           MOVE "------------------------------" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE WS-APP-COUNT TO WS-APP-DISP
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Total Applications: "
               FUNCTION TRIM(WS-APP-DISP)
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           MOVE "------------------------------" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.

       FIND-JOB.
           MOVE 0 TO WS-FOUND-JOB-IDX
           PERFORM VARYING WS-LOOKUP-JOB-IDX FROM 1 BY 1
                   UNTIL WS-LOOKUP-JOB-IDX > WS-TOTAL-JOBS
                       OR WS-FOUND-JOB-IDX > 0
               IF WS-JOB-ID(WS-LOOKUP-JOB-IDX) = WS-LOOKUP-JOB-ID
                   MOVE WS-LOOKUP-JOB-IDX TO WS-FOUND-JOB-IDX
               END-IF
           END-PERFORM.

       WRITE-APPLICATION.
           MOVE WS-LOOKUP-JOB-ID TO WS-JOB-ID-DISP
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Job ID: " WS-JOB-ID-DISP
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           IF WS-FOUND-JOB-IDX = 0
               MOVE "(This listing is not available.)" TO WS-OUTPUT-LINE
           ELSE
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "Job Title: "
                   FUNCTION TRIM(WS-JOB-TITLE(WS-FOUND-JOB-IDX))
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               STRING "Employer: "
                   FUNCTION TRIM(WS-JOB-EMPLOYER(WS-FOUND-JOB-IDX))
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               STRING "Location: "
                   FUNCTION TRIM(WS-JOB-LOCATION(WS-FOUND-JOB-IDX))
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF.
       