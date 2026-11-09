      *    EPIC 8: MESSAGES MENU AND CONNECTED-USER SEND FLOW
       MESSAGES-MENU.
           MOVE "N" TO WS-MESSAGES-DONE
           PERFORM UNTIL WS-MESSAGES-DONE = "Y" OR END-OF-INPUT
               MOVE "--- Messages Menu ---" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "1. Send a New Message" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "2. View My Messages" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "3. Back to Main Menu" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               MOVE "Enter your choice:" TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               PERFORM READ-INPUT
               IF NOT END-OF-INPUT
      *            CHECK THE RECORD BEFORE USING THE MENU BUFFER.
                   IF WS-INPUT-STAT NOT = "00"
                       OR WS-INPUT-LENGTH >
                           FUNCTION LENGTH(WS-INPUT-LINE)
                       MOVE SPACES TO WS-INPUT-LINE
                   END-IF
                   EVALUATE FUNCTION TRIM(WS-INPUT-LINE)
                       WHEN "1"
                           PERFORM SEND-MESSAGE
                       WHEN "2"
                           PERFORM VIEW-MESSAGES
                       WHEN "3"
                           MOVE "Y" TO WS-MESSAGES-DONE
                       WHEN OTHER
                           MOVE "Invalid Option, Try Again"
                               TO WS-OUTPUT-LINE
                           PERFORM WRITE-OUTPUT
                   END-EVALUATE
               END-IF
           END-PERFORM.

       SEND-MESSAGE.
           MOVE "Enter recipient's username (must be a connection):"
               TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           PERFORM READ-MESSAGE-LINE
           IF END-OF-INPUT
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-MESSAGE-CONN
           MOVE FUNCTION TRIM(WS-MESSAGE-RAW) TO WS-MESSAGE-USER
           COMPUTE WS-MESSAGE-LEN = FUNCTION LENGTH(
               FUNCTION TRIM(WS-MESSAGE-RAW))
           IF WS-MESSAGE-LEN > 0 AND WS-MESSAGE-LEN <= 20
               AND WS-MESSAGE-USER NOT = WS-LOGIN-USER
               AND WS-INPUT-LENGTH <= 20
               AND WS-INPUT-STAT = "00"
               MOVE WS-MESSAGE-USER TO WS-SEARCH-USERNAME
               PERFORM FIND-ACCOUNT-BY-USERNAME
               IF ACCOUNT-FOUND
                   PERFORM CHECK-MESSAGE-CONNECTION
               END-IF
           END-IF
           IF WS-MESSAGE-CONN NOT = "Y"
               MOVE
                   "You can only message users you are connected with."
                   TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
               EXIT PARAGRAPH
           END-IF

           MOVE "Enter your message (max 200 chars):"
               TO WS-OUTPUT-LINE
           PERFORM WRITE-OUTPUT
           PERFORM READ-MESSAGE-LINE
           IF END-OF-INPUT
               EXIT PARAGRAPH
           END-IF
           EVALUATE TRUE
               WHEN WS-MESSAGE-RAW = SPACES
                   MOVE "Message content cannot be empty."
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               WHEN WS-INPUT-LENGTH > 200
                   OR WS-INPUT-STAT NOT = "00"
                   MOVE "Message content exceeds 200 characters."
                       TO WS-OUTPUT-LINE
                   PERFORM WRITE-OUTPUT
               WHEN OTHER
                   MOVE WS-MESSAGE-RAW TO WS-MESSAGE-TEXT
                   PERFORM SAVE-MESSAGE
           END-EVALUATE.

       CHECK-MESSAGE-CONNECTION.
           PERFORM VARYING WS-MESSAGE-IDX FROM 1 BY 1
               UNTIL WS-MESSAGE-IDX > WS-TOTAL-CONNECTIONS
                   OR WS-MESSAGE-CONN = "Y"
               IF WS-REQ-STATUS(WS-MESSAGE-IDX) = "C"
                   IF (WS-REQ-SENDER(WS-MESSAGE-IDX) = WS-LOGIN-USER
                       AND WS-REQ-RECIPIENT(WS-MESSAGE-IDX) =
                           WS-MESSAGE-USER)
                       OR (WS-REQ-RECIPIENT(WS-MESSAGE-IDX) =
                           WS-LOGIN-USER
                       AND WS-REQ-SENDER(WS-MESSAGE-IDX) =
                           WS-MESSAGE-USER)
                       MOVE "Y" TO WS-MESSAGE-CONN
                   END-IF
               END-IF
           END-PERFORM.

      *    VARIABLE RECORD LENGTH DETECTS OVERLONG PADDED INPUT,
      *    INCLUDING LINES THAT EXCEED THE PHYSICAL INPUT BUFFER.
      *    ECHO USES THE SAME 250-COLUMN TRANSCRIPT AS EXISTING INPUT.
       READ-MESSAGE-LINE.
           MOVE SPACES TO WS-MESSAGE-RAW
           READ IN-FILE INTO WS-MESSAGE-RAW
               AT END
                   MOVE "Y" TO WS-INPUT-EOF
           END-READ
           IF NOT END-OF-INPUT
               MOVE WS-MESSAGE-RAW TO WS-OUTPUT-LINE
               PERFORM WRITE-OUTPUT
           END-IF.

       SAVE-MESSAGE.
           MOVE "N" TO WS-MESSAGE-SAVED
           OPEN EXTEND MESSAGES-FILE
           IF WS-MESSAGES-STAT = "00" OR "05"
               MOVE SPACES TO MESSAGE-INSTANCE
               MOVE WS-LOGIN-USER TO MSG-SENDER
               MOVE WS-MESSAGE-USER TO MSG-RECIPIENT
               MOVE WS-MESSAGE-TEXT TO MSG-CONTENT
               MOVE FUNCTION CURRENT-DATE TO WS-SENT-DATE
               STRING WS-SENT-DATE(1:4) "-" WS-SENT-DATE(5:2)
                   "-" WS-SENT-DATE(7:2) "T" WS-SENT-DATE(9:2)
                   ":" WS-SENT-DATE(11:2) ":" WS-SENT-DATE(13:2)
                   WS-SENT-DATE(17:3) ":" WS-SENT-DATE(20:2)
                   DELIMITED BY SIZE INTO MSG-TIMESTAMP
               END-STRING
               WRITE MESSAGE-INSTANCE
               IF WS-MESSAGES-STAT = "00"
                   MOVE "Y" TO WS-MESSAGE-SAVED
               END-IF
               CLOSE MESSAGES-FILE
               IF WS-MESSAGES-STAT NOT = "00"
                   MOVE "N" TO WS-MESSAGE-SAVED
               END-IF
           END-IF
           IF WS-MESSAGE-SAVED = "Y"
               MOVE SPACES TO WS-OUTPUT-LINE
               STRING "Message sent to "
                   FUNCTION TRIM(WS-MESSAGE-USER) " successfully!"
                   DELIMITED BY SIZE INTO WS-OUTPUT-LINE
               END-STRING
           ELSE
               MOVE "Unable to save message." TO WS-OUTPUT-LINE
           END-IF
           PERFORM WRITE-OUTPUT.
