
       LOAD-APPS.
           MOVE 0 TO WS-TOTAL-APPS
           OPEN INPUT APPLICATIONS-FILE
           IF WS-APPS-STAT = "00"
               PERFORM UNTIL END-OF-APPS OR WS-TOTAL-APPS >= 500
                   READ APPLICATIONS-FILE
                       AT END
                           MOVE "Y" TO WS-APPS-EOF
                       NOT AT END
                           ADD 1 TO WS-TOTAL-APPS
                           MOVE APP-USER
                               TO WS-APP-USER(WS-TOTAL-APPS)
                           MOVE APP-JOB-ID
                               TO WS-APP-JOB-ID(WS-TOTAL-APPS)
                   END-READ
               END-PERFORM
           END-IF
           CLOSE APPLICATIONS-FILE.

       SAVE-APP.
           OPEN OUTPUT APPLICATIONS-FILE
           PERFORM VARYING WS-APP-IDX FROM 1 BY 1
                   UNTIL WS-APP-IDX > WS-TOTAL-APPS
               MOVE WS-APP-USER(WS-APP-IDX) TO APP-USER
               MOVE WS-APP-JOB-ID(WS-APP-IDX) TO APP-JOB-ID
               WRITE APPLICATION-INST
           END-PERFORM
           CLOSE APPLICATIONS-FILE.

       APPLY-JOB.
           MOVE "N" TO WS-ALR-APPLIED
           PERFORM VARYING WS-APP-IDX FROM 1 BY 1
                   UNTIL WS-APP-IDX > WS-TOTAL-APPS
               IF WS-APP-USER(WS-APP-IDX) = WS-LOGIN-USER
                   AND WS-APP-JOB-ID(WS-APP-IDX) = WS-JOB-ID(WS-JOB-SEL)
                   MOVE "Y" TO WS-ALR-APPLIED
               END-IF
           END-PERFORM

           IF ALR-APPLIED
               MOVE "You've already applied to this job." 
                   TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           ELSE
               IF WS-TOTAL-APPS >= 500
                   MOVE "Unable to Apply, Max Applications Stored"
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               ELSE
                   ADD 1 TO WS-TOTAL-APPS
                   MOVE WS-LOGIN-USER
                       TO WS-APP-USER(WS-TOTAL-APPS)
                   MOVE WS-JOB-ID(WS-JOB-SEL)
                       TO WS-APP-JOB-ID(WS-TOTAL-APPS)
                   PERFORM SAVE-APP
                   MOVE SPACES TO WS-OUTPUT-LINE
                   STRING "Your application for "
                       FUNCTION TRIM(WS-JOB-TITLE(WS-JOB-SEL))
                       " at "
                       FUNCTION TRIM(WS-JOB-EMPLOYER(WS-JOB-SEL))
                       " has been submitted."
                       DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                   END-STRING
                   PERFORM WRITE-OUTPUT
               END-IF
           END-IF.
       