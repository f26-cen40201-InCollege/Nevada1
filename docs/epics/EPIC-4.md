Objective: This week, your team will implement the functionality for users to send and store
connection requests to other users within the InCollege platform. This lays the groundwork for
users to build their professional networks. All program input will continue to be read from a
file, all output will be displayed on the screen, and that same output will also be written to a
file.
Focus Areas:
1. Sending Connection Requests:
- After successfully searching for and viewing another user's profile (from Week
3), the system should present the option to "Send Connection Request" to that
user.
- When a user sends a request, the system must record this pending connection.
- The sending user should be informed that their request has been sent.
- Constraint: A user should only be able to send a connection request to someone
they are not already connected with and who has not already sent them a
pending request. Your system should validate this. If an invalid request is made
(e.g., trying to connect with someone already connected, or someone who has
already sent them a request), an appropriate message should be displayed (e.g.,
"You are already connected with this user," or "This user has already sent you a
connection request").
- The user will be presented with an option to return to the top level menu.
2. Storing Pending Requests:
- All pending connection requests must be saved persistently. This means they
should be stored in a way that allows them to be retrieved even after the
application is closed and reopened.
- You'll need to define a data structure to store who sent the request and to
whom it was sent.
3. Viewing Pending Requests:
- A new option should be available from the main post-login menu (e.g., "View My
Pending Connection Requests").
- When a user selects this option, the system should display a list of all users who
have sent them a connection request that is still pending.
4. I/O Requirements:
- Input: All user input (e.g., menu selections, confirmation of sending requests)
will be read from a predefined input file.
- Output Display: All program output (e.g., prompts, confirmation messages,
displayed lists of pending requests, error messages) must be displayed on the
screen (standard output).
- Output Preservation: The exact same output displayed on the screen must also
be written to a separate output file for testing and record-keeping purposes.