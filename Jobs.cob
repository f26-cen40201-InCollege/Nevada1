
       LOAD-JOBS.
           MOVE 0 TO WS-TOTAL-JOBS
           MOVE 0 TO WS-MAX-JOB-ID
           OPEN INPUT JOBS-FILE
           IF WS-JOBS-STAT = "00"
               PERFORM UNTIL END-OF-JOBS OR WS-TOTAL-JOBS >= 100
                   READ JOBS-FILE
                       AT END
                           MOVE "Y" TO WS-JOBS-EOF
                       NOT AT END
                           ADD 1 to WS-TOTAL-JOBS
                           MOVE JOB-ID TO WS-JOB-ID(WS-TOTAL-JOBS)
                           MOVE JOB-POSTER 
                               TO WS-JOB-POSTER(WS-TOTAL-JOBS)
                           MOVE JOB-TITLE TO WS-JOB-TITLE(WS-TOTAL-JOBS)
                           MOVE JOB-DESCR TO WS-JOB-DESCR(WS-TOTAL-JOBS)
                           MOVE JOB-EMPLOYER
                               TO WS-JOB-EMPLOYER(WS-TOTAL-JOBS)
                           MOVE JOB-LOCATION
                               TO WS-JOB-LOCATION(WS-TOTAL-JOBS)
                           MOVE JOB-SALARY
                               TO WS-JOB-SALARY(WS-TOTAL-JOBS)
                           IF JOB-ID > WS-MAX-JOB-ID
                               MOVE JOB-ID TO WS-MAX-JOB-ID
                           END-IF
                   END-READ
               END-PERFORM
           END-IF
           CLOSE JOBS-FILE.

       SAVE-JOBS.
           OPEN OUTPUT JOBS-FILE
           PERFORM VARYING WS-JOB-IDX FROM 1 BY 1 
                   UNTIL WS-JOB-IDX > WS-TOTAL-JOBS
               MOVE WS-JOB-ID(WS-JOB-IDX) TO JOB-ID
               MOVE WS-JOB-POSTER(WS-JOB-IDX) TO JOB-POSTER
               MOVE WS-JOB-TITLE(WS-JOB-IDX) TO JOB-TITLE
               MOVE WS-JOB-DESCR(WS-JOB-IDX) TO JOB-DESCR
               MOVE WS-JOB-EMPLOYER(WS-JOB-IDX) TO JOB-EMPLOYER
               MOVE WS-JOB-LOCATION(WS-JOB-IDX) TO JOB-LOCATION
               MOVE WS-JOB-SALARY(WS-JOB-IDX) TO JOB-SALARY
               WRITE JOB-INSTANCE
           END-PERFORM
           CLOSE JOBS-FILE.
       
       
       JOB-MENU.
           MOVE "N" TO WS-JOB-MENU-DONE
           MOVE "---Job Search/Internship Menu ---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           PERFORM UNTIL JOB-MENU-DONE OR END-OF-INPUT
               MOVE "1. Post a Job/Internship" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "2. Browse Jobs/Internships" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "3. Back to Main Menu" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "ENTER YOUR CHOICE: " TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT

               PERFORM READ-INPUT
                   IF NOT END-OF-INPUT
                       MOVE WS-INPUT-LINE TO WS-CHOICE
                       EVALUATE WS-CHOICE
                           WHEN "1"
                               PERFORM POST-JOB
                           WHEN "2"
                               PERFORM BROWSE-JOBS
                           WHEN "3"
                               MOVE "Y" TO WS-JOB-MENU-DONE
                           WHEN OTHER
                               MOVE "Invalid Option, Try Again"
                                   TO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                       END-EVALUATE
                   END-IF
               END-PERFORM.

       POST-JOB.
           IF WS-TOTAL-JOBS >= 100
               MOVE "Unable to Post Job. Max Jobs Stored."
                   TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           ELSE
               MOVE "--- Post a New Job/Internship ---"
                   TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE WS-TOTAL-JOBS TO WS-JOB-IDX
               ADD 1 TO WS-JOB-IDX
               MOVE SPACES TO WS-JOB-INST(WS-JOB-IDX)
               
               MOVE "Enter Job Title:" TO WS-FIELD-PROMPT
               MOVE "Job Title" TO WS-FIELD-NAME
               MOVE 50 TO WS-FIELD-MAX
               MOVE "Y" TO WS-FIELD-REQ
               PERFORM GET-JOB-FIELD
               MOVE WS-FIELD-VALUE TO WS-JOB-TITLE(WS-JOB-IDX)

               IF NOT END-OF-INPUT
                   MOVE "Enter Description (max 200 chars):"
                       TO WS-FIELD-PROMPT
                   MOVE "Description" TO WS-FIELD-NAME
                   MOVE 200 TO WS-FIELD-MAX
                   MOVE "Y" TO WS-FIELD-REQ
                   PERFORM GET-JOB-FIELD
                   MOVE WS-FIELD-VALUE TO WS-JOB-DESCR(WS-JOB-IDX)
               END-IF

               IF NOT END-OF-INPUT
                   MOVE "Enter Employer Name:"
                       TO WS-FIELD-PROMPT
                   MOVE "Employer Name" TO WS-FIELD-NAME
                   MOVE 50 TO WS-FIELD-MAX
                   MOVE "Y" TO WS-FIELD-REQ
                   PERFORM GET-JOB-FIELD
                   MOVE WS-FIELD-VALUE TO WS-JOB-EMPLOYER(WS-JOB-IDX)
               END-IF

               IF NOT END-OF-INPUT
                   MOVE "Enter Location:"
                       TO WS-FIELD-PROMPT
                   MOVE "Location" TO WS-FIELD-NAME
                   MOVE 50 TO WS-FIELD-MAX
                   MOVE "Y" TO WS-FIELD-REQ
                   PERFORM GET-JOB-FIELD
                   MOVE WS-FIELD-VALUE TO WS-JOB-LOCATION(WS-JOB-IDX)
               END-IF

               IF NOT END-OF-INPUT
                   MOVE "Enter Salary (optional, enter 'NONE' to skip):"
                       TO WS-FIELD-PROMPT
                   MOVE "Salary" TO WS-FIELD-NAME
                   MOVE 30 TO WS-FIELD-MAX
                   MOVE "N" TO WS-FIELD-REQ
                   PERFORM GET-JOB-FIELD
                   MOVE WS-FIELD-VALUE TO WS-JOB-SALARY(WS-JOB-IDX)
               END-IF

               IF NOT END-OF-INPUT
                   MOVE WS-JOB-IDX TO WS-TOTAL-JOBS
                   ADD 1 TO WS-MAX-JOB-ID
                   MOVE WS-MAX-JOB-ID TO WS-JOB-ID(WS-JOB-IDX)
                   MOVE WS-LOGIN-USER TO WS-JOB-POSTER(WS-JOB-IDX)
                   PERFORM SAVE-JOBS
                   MOVE "Job posted successfully!" TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
                   MOVE "----------------------------------"
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               END-IF
           END-IF.

       GET-JOB-FIELD.
           MOVE "N" TO WS-VALID-RESPONSE
           MOVE SPACES TO WS-FIELD-VALUE
           MOVE WS-FIELD-MAX TO WS-FIELD-DISP
           PERFORM UNTIL VALIDATED OR END-OF-INPUT
               MOVE WS-FIELD-PROMPT TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
                   MOVE SPACES TO WS-FIELD-VALUE
                   MOVE FUNCTION TRIM(WS-INPUT-LINE) TO WS-FIELD-VALUE
                   COMPUTE WS-FIELD-LEN = 
                       FUNCTION LENGTH(FUNCTION TRIM(WS-INPUT-LINE))
                   IF WS-FIELD-VALUE = SPACES
                       MOVE 0 TO WS-FIELD-LEN
                   END-IF

                   IF NOT FIELD-REQUIRED AND (WS-FIELD-LEN = 0 OR
                       FUNCTION UPPER-CASE(WS-FIELD-VALUE) = "NONE")
                       MOVE SPACES TO WS-FIELD-VALUE
                       MOVE "Y" TO WS-VALID-RESPONSE
                   ELSE
                       IF WS-FIELD-LEN = 0
                           MOVE SPACES TO WS-OUTPUT-LINE
                           STRING FUNCTION TRIM(WS-FIELD-NAME)
                               " Cannot Be Blank, Try Again"
                                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                       ELSE
                           IF WS-FIELD-LEN > WS-FIELD-MAX
                               MOVE SPACES TO WS-OUTPUT-LINE
                               STRING FUNCTION TRIM(WS-FIELD-NAME)
                                   " Cannot Exceed "
                                   FUNCTION TRIM(WS-FIELD-DISP)
                                   " Characters, Try Again"
                                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
                               PERFORM WRITE-OUTPUT
                           ELSE
                               MOVE "Y" TO WS-VALID-RESPONSE
                           END-IF
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.
