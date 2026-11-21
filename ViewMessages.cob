      *    EPIC 9: STREAM THE LOGGED-IN USER'S RECEIVED MESSAGES.
       VIEW-MESSAGES.
           MOVE "N" TO WS-MESSAGES-EOF WS-MESSAGES-FOUND
               WS-MESSAGES-FAILED
           MOVE "--- Your Messages ---" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
      *    A DIRECTORY CAN LOOK LIKE EOF TO LINE-SEQUENTIAL READ.
      *    DIRECTORY/. EXISTS ONLY IF THE STORAGE PATH IS A DIRECTORY.
           CALL "CBL_CHECK_FILE_EXIST" USING
               "Messages.txt/." WS-MESSAGE-FILE-INFO
               RETURNING WS-MESSAGE-PATH-STAT
           END-CALL
           IF WS-MESSAGE-PATH-STAT = 0
               PERFORM MESSAGE-READ-ERROR
               EXIT PARAGRAPH
           END-IF
           OPEN INPUT MESSAGES-FILE
           IF WS-MESSAGES-STAT NOT = "00" AND NOT = "05"
               PERFORM MESSAGE-READ-ERROR
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL WS-MESSAGES-EOF = "Y"
               READ MESSAGES-FILE
               END-READ
               EVALUATE WS-MESSAGES-STAT
                   WHEN "00"
                       IF MSG-RECIPIENT = WS-LOGIN-USER
                           PERFORM DISPLAY-RECEIVED-MESSAGE
                       END-IF
                   WHEN "10"
                       MOVE "Y" TO WS-MESSAGES-EOF
                   WHEN OTHER
                       MOVE "Y" TO WS-MESSAGES-EOF
                           WS-MESSAGES-FAILED
               END-EVALUATE
           END-PERFORM
           CLOSE MESSAGES-FILE
           IF WS-MESSAGES-STAT NOT = "00"
               MOVE "Y" TO WS-MESSAGES-FAILED
           END-IF

           IF WS-MESSAGES-FAILED = "Y"
               PERFORM MESSAGE-READ-ERROR
           ELSE
               IF WS-MESSAGES-FOUND NOT = "Y"
                   MOVE "You have no messages at this time."
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               END-IF
           END-IF
           MOVE "---------------------" TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.

       DISPLAY-RECEIVED-MESSAGE.
           IF WS-MESSAGES-FOUND = "Y"
               MOVE "---" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF
           MOVE "Y" TO WS-MESSAGES-FOUND
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "From: " FUNCTION TRIM(MSG-SENDER TRAILING)
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           END-STRING
           PERFORM WRITE-OUTPUT
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Message: " FUNCTION TRIM(MSG-CONTENT TRAILING)
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           END-STRING
           PERFORM WRITE-OUTPUT
           MOVE SPACES TO WS-OUTPUT-LINE
           STRING "Sent: " FUNCTION TRIM(MSG-TIMESTAMP TRAILING)
               DELIMITED BY SIZE INTO WS-OUTPUT-LINE
           END-STRING
           PERFORM WRITE-OUTPUT.

       MESSAGE-READ-ERROR.
           MOVE "Unable to read your messages." TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT.
