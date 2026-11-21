      * =================== START INSTRUCTIONS =========================

      *>   This is the main test entry point.
      *>   All tests will be run through it
      *>   It's already set up to run all your tests, you just need
      *>   To focus on your Epic and Tester File

      *>   IMPORTANT: YOU MUST UPDATE THE COMPILE CODE IF YOU ADD A FILE TO BE TESTED:

            *>   cobc -x -o test-main test-main.cob InCollege-Core.cob
            *>       tests/copy_file.cob
      *>   ./test-main
      *>   then simply run: ./test-main to run all tests
      *>   if someone wants to make a way to add particular tests, feel free!

      * ==================== END INSTRUCTIONS ==========================

       IDENTIFICATION DIVISION.
       PROGRAM-ID. test-main.
       AUTHOR. Ian Koratsky.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT OUTPUT-FILE ASSIGN TO WS-OUTPUT-FILE
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-OUTPUT-STAT.

           SELECT EXPECTED-FILE ASSIGN TO WS-EXPECTED-FILE
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-EXPECTED-STAT.

           SELECT OUTPUT-FILE-CONSOLIDATED 
             ASSIGN TO WS-OUTPUT-FILE-CONSOLIDATED
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-OUTPUT-STAT-CONSOLIDATED.

           SELECT EXPECTED-FILE-CONSOLIDATED 
             ASSIGN TO WS-EXPECTED-FILE-CONSOLIDATED
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-EXPECTED-STAT-CONSOLIDATED.

           SELECT TEST-INPUT-FILE ASSIGN TO WS-TEST-INPUT
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-TEST-INPUT-STAT.
         
           SELECT TEST-INPUT-CONSOLIDATED
             ASSIGN TO WS-TEST-INPUT-CONSOLIDATED
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-TEST-INPUT-CONSOLIDATED-STAT.

           SELECT OPTIONAL JOBS-ACTUAL-FILE ASSIGN TO "Jobs.txt"
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-JOBS-ACT-STAT.

           SELECT OPTIONAL JOBS-EXPECTED-FILE
             ASSIGN TO WS-JOBS-EXP-PATH
             ORGANIZATION IS LINE SEQUENTIAL
             FILE STATUS IS WS-JOBS-EXP-STAT.

       DATA DIVISION.
       FILE SECTION.

      *    ========================= Test Files ========================

           FD TEST-INPUT-FILE.
           01 TEST-INPUT-FILE-REC PIC X(100).

           FD OUTPUT-FILE.
           01 OUTPUT-FILE-REC PIC X(100).
           
           FD EXPECTED-FILE.
           01 EXPECTED-FILE-REC PIC X(100).

      *    ==================== Condolidation Files ====================

           FD TEST-INPUT-CONSOLIDATED.
           01 TEST-INPUT-CONSOLIDATED-REC PIC X(100).

           FD OUTPUT-FILE-CONSOLIDATED.
           01 OUTPUT-CONSOLIDATED-REC PIC X(100).
           
           FD EXPECTED-FILE-CONSOLIDATED.
           01 EXPECTED-CONSOLIDATED-REC PIC X(100).

      *    ================== Jobs.txt comparison (Epic 6) =============
      *    One job record is 404 characters (4+20+50+200+50+50+30).

           FD JOBS-ACTUAL-FILE.
           01 JOBS-ACTUAL-REC PIC X(404).

           FD JOBS-EXPECTED-FILE.
           01 JOBS-EXPECTED-REC PIC X(404).

       WORKING-STORAGE SECTION.
      *    ====================== Original Files =======================
           
           01 ACCOUNTS-PATH PIC X(100).

      *    ========================== Booleans ==========================
           01 WS-OUTPUT-EOF PIC X VALUE "N".
               88 WS-OUTPUT-END VALUE "Y".
           
           01 WS-EXPECTED-EOF PIC X VALUE "N".
                88 WS-EXPECTED-END VALUE "Y".

           01 WS-MISMATCH PIC X VALUE "N".
                88 MISMATCH-FOUND VALUE "Y".

           01 NOT-FINAL-OUTPUT PIC X VALUE "N".
                88 FINAL-OUTPUT VALUE "Y".

         01 WS-SKIP-RESET PIC X VALUE "N".

      *    ========================== Counters ========================== 

           01 TotalTestsPassed PIC 9(5) VALUE 0.
           01 TotalTestsFailed PIC 9(5) VALUE 0.

      *    ========================= Test Input ========================= 

           01 WS-TEST-INPUT PIC X(100).
           01 WS-TEST-CODE PIC X(100).
           01 WS-FOLDER PIC X(100).

           01 WS-TEST-CONSOLDATED-LINE PIC X(100).

           01 WS-ACCOUNTS-FILE PIC X(100).

      * Output
           01 WS-OUTPUT-LINE PIC X(100).
           01 WS-OUTPUT-FILE PIC X(100).
           01 WS-OUTPUT-STAT PIC XX.
           01 WS-OUTPUT-STAT-CONSOLIDATED PIC XX.

      *    ========================== Expected ========================== 
           01 WS-EXPECTED-LINE PIC X(100).
           01 WS-EXPECTED-FILE PIC X(100).
           01 WS-EXPECTED-STAT PIC XX.
           01 WS-EXPECTED-STAT-CONSOLIDATED PIC XX.

      *    ======================== Consolidated ========================
           01 WS-OUTPUT-FILE-CONSOLIDATED PIC X(100)
               VALUE "tests-output.txt".
           01 OUTPUT-CONSOLIDATED-LINE PIC X(100).
           01 WS-EXPECTED-FILE-CONSOLIDATED PIC X(100)
               VALUE "tests-expected.txt".
           01 EXPECTED-CONSOLIDATED-LINE PIC X(100).

           01 WS-TEST-INPUT-STAT PIC XX.

           01 WS-TEST-INPUT-CONSOLIDATED PIC X(100)
               VALUE "tests-input.txt".
           01 WS-TEST-INPUT-CONSOLIDATED-STAT PIC XX.

      *    ================== Jobs.txt comparison (Epic 6) =============
           01 WS-JOBS-ACT-STAT PIC XX.
           01 WS-JOBS-EXP-STAT PIC XX.
           01 WS-JOBS-EXP-PATH PIC X(100).
           01 WS-JOBS-ACT-LINE PIC X(404).
           01 WS-JOBS-EXP-LINE PIC X(404).
           01 WS-JOBS-ACT-EOF PIC X VALUE "N".
               88 WS-JOBS-ACT-END VALUE "Y".
           01 WS-JOBS-EXP-EOF PIC X VALUE "N".
               88 WS-JOBS-EXP-END VALUE "Y".
           01 WS-JOBS-MISMATCH PIC X VALUE "N".
               88 JOBS-MISMATCH-FOUND VALUE "Y".
           01 WS-INPUT-LINE PIC X(100).
           01 WS-INPUT-EOF PIC X VALUE "N".
               88 WS-INPUT-END VALUE "Y".
               
      *    ========================== Helpers ==========================

           01 WS-TEST-HEADER PIC X(100).
           01 WS-PATH-SUFFIX PIC X(20).
           01 WS-BUILT-PATH PIC X(100).
           01 WS-INITIAL-CONDITION PIC X(100).
           01 WS-OVERRIDE-INITIAL-CONDITON PIC X(100).
           01 WS-OVERRIDE-INITIAL-CONDITON-FILE PIC X(100).

           01 WS-CHECK-STAT PIC XX.
           01 WS-CHECK-NAME PIC X(100).

           01 WS-SHOW-HEADERS PIC X VALUE "N".
               88 SHOW-HEADERS VALUE "Y".

           01 RETURNCODE pic 9(4) comp.

       PROCEDURE DIVISION.
      
      *    =============================================================
      *    =============================================================
      *    ===================== START TOGGLE VARS =====================

      *    Uncomment the below to output headers for debugging

           SET SHOW-HEADERS TO TRUE.

      *    This will push the outputs to what we need to submit
      *     SET FINAL-OUTPUT TO TRUE.

      *    ===================== END TOGGLE VARS =======================
      *    =============================================================
      *    =============================================================

           PERFORM START-CONSOLIDATE-FILES.
           PERFORM SET-ORIGINAL-FILES. *> CALL ONLY ONCE!

           MOVE 0 TO TotalTestsPassed.
           MOVE 0 TO TotalTestsFailed.


      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =================== EXAMPLE USING EPIC 1 ====================

      *    Use this to set a code you're going to test
           MOVE SPACES TO WS-TEST-CODE.
           MOVE "INCOLLEGE-CORE" TO WS-TEST-CODE.       

      *    Now just copy the below as often as you need:

      *    ====================== Option 1: Basic ======================

      *     MOVE "tests/epic-1/tester-1/account-creation-neg-1/" 
      *         TO WS-FOLDER.
      *     PERFORM COUNTER-UPDATE.

      *    ==================== Option 2: Advanced =====================

      *    If you need to set a file to a specific initial condition,
      *    use this instead
      *    (Commented out: account-creation-pos-1/ has no input.txt or
      *    expected.txt, which halted the entire harness with
      *    file status 35)
      *    MOVE "tests/epic-1/tester-1/account-creation-pos-1/"
      *        TO WS-FOLDER.
      *    MOVE "accounts.txt" TO WS-OVERRIDE-INITIAL-CONDITON.

      *    MOVE "Accounts.txt" TO WS-INITIAL-CONDITION.
      *    PERFORM MODIFY-INITIAL-CONDITON-FILE.
      *    PERFORM COUNTER-UPDATE.

      *    ======================= END EXAMPLE =========================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================




      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    ===================== START YOUR TESTS ======================

      *    =============================================================
      
           MOVE "tests/epic-1/tester-1/menus-pos-4/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-1/tester-1/menus-pos-4/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-1/tester-1/menus-pos-3/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-1/tester-1/menus-pos-3/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-1/tester-1/menus-pos-2/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-1/tester-1/menus-pos-2/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-1/tester-1/acc-creation-neg-2/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-1/tester-1/acc-creation-neg-2/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-1/tester-1/menus-pos-1/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-1/tester-1/menus-pos-1/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-1/tester-1/acc-creation-neg-1/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-1/tester-1/acc-creation-neg-1/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/persistence-restart/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/persistence-restart/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/max-3-entries-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/max-3-entries-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/prof-creation-neg-2/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/prof-creation-neg-2/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/blank-univ-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/blank-univ-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/gradyr-2025-bad-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/gradyr-2025-bad-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/gradyr-high-ok-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/gradyr-high-ok-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/blank-major-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/blank-major-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/expdesc-101bad-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/expdesc-101bad-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/gradyr-2034-bad-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/gradyr-2034-bad-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/aboutme-200ok-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/aboutme-200ok-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/gradyr-nonnum-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/gradyr-nonnum-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/gradyr-toolong-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/gradyr-toolong-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/blank-gradyear/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/blank-gradyear/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/edit-profile-pos/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/edit-profile-pos/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/gradyr-low-ok-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/gradyr-low-ok-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/expdesc-100ok-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/expdesc-100ok-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/menus-neg-1/"
                  TO WS-FOLDER.
           
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/acc-creation-pos-1/"
                  TO WS-FOLDER.
           
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/gradyr-tooshort-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/gradyr-tooshort-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/full-profile-pos/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/full-profile-pos/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/blank-firstname-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/blank-firstname-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/aboutme-201bad-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/aboutme-201bad-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-1/blank-lastname-neg/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-1/blank-lastname-neg/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-2/zero-optional-pos/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-2/zero-optional-pos/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-2/vw-no-profile-edge/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-2/vw-no-profile-edge/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-2/tester-2/two-users-check-pos/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-2/tester-2/two-users-check-pos/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/wrong-letter-case/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/wrong-letter-case/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/wrong-letter-case/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/same-name/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/same-name/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/same-name/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/search-persistence/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/search-persistence/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/search-persistence/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/too-much-inputs/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/too-much-inputs/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/too-much-inputs/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/profile-dne/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/profile-dne/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/profile-dne/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/partial-name/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/partial-name/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/partial-name/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/whitespace/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/whitespace/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/whitespace/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-1/max-optionals/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-1/max-optionals/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-3/tester-1/max-optionals/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/search-empty-query/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/search-empty-query/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/search-find-full/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/search-find-full/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/search-view-own/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/search-view-own/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/search-self/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/search-self/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/search-find-empty/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/search-find-empty/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/search-long-name/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/search-long-name/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/view-own-minimal/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/view-own-minimal/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-3/tester-2/view-own-full/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-3/tester-2/view-own-full/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-1/mutual-requests/"
                  TO WS-FOLDER.
           
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-1/pending-empty/"
                  TO WS-FOLDER.
           
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-1/pending-filter/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-1/pending-filter/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-2/send-conn/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-2/send-conn/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/send-conn/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/send-conn/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-2/no-profile/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-2/no-profile/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/no-profile/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/no-profile/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-2/duplicate-req/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-2/duplicate-req/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/duplicate-req/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/duplicate-req/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-2/send-self/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-2/send-self/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/send-self/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/send-self/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-2/send-unconn/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-2/send-unconn/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/send-unconn/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/send-unconn/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-2/request-not-acpt/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-2/request-not-acpt/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/request-not-acpt/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/request-not-acpt/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-4/tester-2/multi-requests/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-4/tester-2/multi-requests/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/multi-requests/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-4/tester-2/multi-requests/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-5/tester-1/mixed-ac-rej-net/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-5/tester-1/mixed-ac-rej-net/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-1/mixed-ac-rej-net/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-1/mixed-ac-rej-net/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-5/tester-2/rej-1-req/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-5/tester-2/rej-1-req/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/rej-1-req/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/rej-1-req/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-5/tester-2/acc-req-pers-p1/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-5/tester-2/acc-req-pers-p1/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/acc-req-pers-p1/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/acc-req-pers-p1/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-5/tester-2/rej-multi-req/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-5/tester-2/rej-multi-req/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/rej-multi-req/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/rej-multi-req/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-5/tester-2/accept-1-req/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-5/tester-2/accept-1-req/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/accept-1-req/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/accept-1-req/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-5/tester-2/acc-req-pers-p2/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-5/tester-2/acc-req-pers-p2/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/acc-req-pers-p2/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-5/tester-2/acc-multi-req/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-5/tester-2/acc-multi-req/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/acc-multi-req/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-5/tester-2/acc-multi-req/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/02-pos-new-job-d/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/02-pos-new-job-d/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/02-pos-new-job-d/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/02-pos-new-job-d/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/05-neg-new-job-s/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/05-neg-new-job-s/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/05-neg-new-job-s/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/05-neg-new-job-s/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/01-neg-new-job-t/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/01-neg-new-job-t/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/01-neg-new-job-t/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/01-neg-new-job-t/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/00-neg-new-job/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/00-neg-new-job/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/00-neg-new-job/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/00-neg-new-job/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/entry-exit-entry/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/entry-exit-entry/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/entry-exit-entry/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/entry-exit-entry/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/04-neg-new-job-l/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/04-neg-new-job-l/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/04-neg-new-job-l/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/04-neg-new-job-l/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/00-pos-new-job/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/00-pos-new-job/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/00-pos-new-job/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/00-pos-new-job/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/03-neg-new-job-e/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/03-neg-new-job-e/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/03-neg-new-job-e/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/03-neg-new-job-e/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/02-neg-new-job-d/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/02-neg-new-job-d/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/02-neg-new-job-d/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/02-neg-new-job-d/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/05-pos-new-job-s/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/05-pos-new-job-s/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/05-pos-new-job-s/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/05-pos-new-job-s/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/01-pos-new-job-t/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/01-pos-new-job-t/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/01-pos-new-job-t/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/01-pos-new-job-t/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/04-pos-new-job-l/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/04-pos-new-job-l/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/04-pos-new-job-l/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/04-pos-new-job-l/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-1/03-pos-new-job-e/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-1/03-pos-new-job-e/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/03-pos-new-job-e/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-1/03-pos-new-job-e/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/09-pers-r3-ln-only/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/09-pers-r3-ln-only/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/03-desc-201-rej/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/03-desc-201-rej/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/03-desc-201-rej/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/11-week6-sample-run/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/11-week6-sample-run/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/11-week6-sample-run/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/07-pers-r1-usr1-p/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/07-pers-r1-usr1-p/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/07-pers-r1-usr1-p/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/05-desc-exactly-200/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/05-desc-exactly-200/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/05-desc-exactly-200/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/04-post-salary-none/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/04-post-salary-none/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/04-post-salary-none/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/01-pend-nwk-p/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/01-pend-nwk-p/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/01-pend-nwk-p/profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/01-pend-nwk-p/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/01-pend-nwk-p/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/10-job-m-spec-wd/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/10-job-m-spec-wd/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/10-job-m-spec-wd/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/02-blank-req-fds/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/02-blank-req-fds/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/02-blank-req-fds/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/08-pers-r2-usr2-p/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/08-pers-r2-usr2-p/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-6/tester-2/06-two-jobs-one-run/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-6/tester-2/06-two-jobs-one-run/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-6/tester-2/06-two-jobs-one-run/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/prst-app-multi-user/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/prst-app-multi-user/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/prst-app-multi-user/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/rep-ord-m-app/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/rep-ord-m-app/application.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "application.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-ord-m-app/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-ord-m-app/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/browse-one-job/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/browse-one-job/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/browse-one-job/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/dets-inv-menu-op/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/dets-inv-menu-op/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/dets-inv-menu-op/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/post-job-sal-na/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/post-job-sal-na/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/details-b2l/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/details-b2l/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/details-b2l/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/rep-no-app/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/rep-no-app/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-no-app/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/persist-app/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/persist-app/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/persist-app/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/apply-success/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/apply-success/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/apply-success/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/post-job-s-w-sal/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/post-job-s-w-sal/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/browse-r2m/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/browse-r2m/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/browse-r2m/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/job-menu-view-app-e/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/job-menu-view-app-e/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/job-menu-view-app-e/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/post-job-des-lim/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/post-job-des-lim/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/apply-duplicate/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/apply-duplicate/application.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "application.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/apply-duplicate/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/apply-duplicate/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/prst-pst-job-brws/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/prst-pst-job-brws/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/dets-inv-inp/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/dets-inv-inp/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/dets-inv-inp/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/samp-w7-rep/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/samp-w7-rep/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/samp-w7-rep/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/rep-aft-app-in-sess/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/rep-aft-app-in-sess/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-aft-app-in-sess/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/p-j-blk-req-field/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/p-j-blk-req-field/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/rep-listing-rem/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/rep-listing-rem/application.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "application.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-listing-rem/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-listing-rem/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/browse-100-jobs/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/browse-100-jobs/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/browse-100-jobs/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/rep-multi-app/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/rep-multi-app/application.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "application.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-multi-app/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-multi-app/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/browse-multi-jobs/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/browse-multi-jobs/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/browse-multi-jobs/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/post-job-t-long/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/post-job-t-long/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/job-menu-ops-disp/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/job-menu-ops-disp/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/browse-empty/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/browse-empty/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/post-job-max-100/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/post-job-max-100/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/post-job-max-100/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/details-last-job/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/details-last-job/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/details-last-job/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/job-menu-header-fmt/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/job-menu-header-fmt/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/app-dup-sme-sess/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/app-dup-sme-sess/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/app-dup-sme-sess/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/dets-wo-sal/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/dets-wo-sal/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/dets-wo-sal/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/apply-multiple-jobs/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/apply-multiple-jobs/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/apply-multiple-jobs/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/job-menu-b2m/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/job-menu-b2m/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/app-o-u-j-unaff/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/app-o-u-j-unaff/application.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "application.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/app-o-u-j-unaff/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/app-o-u-j-unaff/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/job-menu-inv-option/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/job-menu-inv-option/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/io-inp-ends-in-d/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/io-inp-ends-in-d/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/io-inp-ends-in-d/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/details-ex-with-sal/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/details-ex-with-sal/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/details-ex-with-sal/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/dets-nonexis-num/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/dets-nonexis-num/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/dets-nonexis-num/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/rep-fil-by-usr/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/rep-fil-by-usr/application.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "application.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-fil-by-usr/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-fil-by-usr/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/rep-1-app/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/rep-1-app/application.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "application.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-1-app/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/rep-1-app/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-7/tester-1/io-inp-ends-in-b/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-7/tester-1/io-inp-ends-in-b/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-7/tester-1/io-inp-ends-in-b/jobs.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "jobs.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-1/empty-message/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-1/empty-message/Connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/empty-message/Messages.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Messages.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/empty-message/Profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/empty-message/Accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-1/send-message/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-1/send-message/Connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-message/Messages.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Messages.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-message/Profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-message/Accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-1/whitespace/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-1/whitespace/Connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/whitespace/Messages.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Messages.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/whitespace/Profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/whitespace/Accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-1/send-no-input/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-1/send-no-input/Connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-no-input/Messages.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Messages.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-no-input/Profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-no-input/Accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-1/send-different/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-1/send-different/Connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-different/Messages.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Messages.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-different/Profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-different/Accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-1/send-multiple/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-1/send-multiple/Connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-multiple/Messages.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Messages.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-multiple/Profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-multiple/Accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-1/send-bidir/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-1/send-bidir/Connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-bidir/Messages.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Messages.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-bidir/Profiles.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Profiles.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-1/send-bidir/Accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "Accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-mess-y/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-mess-y/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-mess-y/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/len-201/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/len-201/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/len-201/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/len200-exact/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/len200-exact/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/len200-exact/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-pnd-s2y/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-pnd-s2y/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-pnd-s2y/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/spec-suc-sep-li/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/spec-suc-sep-li/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/spec-suc-sep-li/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/l-usr-21-c-prx/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/l-usr-21-c-prx/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/l-usr-21-c-prx/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/len-5000/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/len-5000/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/len-5000/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/eof-at-mess-m/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/eof-at-mess-m/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/eof-at-mess-m/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/len-500/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/len-500/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/len-500/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/eof-aft-s-n-mess/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/eof-aft-s-n-mess/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/eof-aft-s-n-mess/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/l-usr-20-c/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/l-usr-20-c/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/l-usr-20-c/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-f-s-no-p-rec/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-f-s-no-p-rec/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-f-s-no-p-rec/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-nt-conn/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-nt-conn/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-nt-conn/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-inv-m-inp/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-inv-m-inp/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-inv-m-inp/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-sndr-0-conn/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-sndr-0-conn/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-sndr-0-conn/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/eof-aft-recp-pt/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/eof-aft-recp-pt/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/eof-aft-recp-pt/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-nonex-usr/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-nonex-usr/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-nonex-usr/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/eof-aft-snd-s/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/eof-aft-snd-s/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/eof-aft-snd-s/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-blank-recp/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-blank-recp/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-blank-recp/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-pnd-sby/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-pnd-sby/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-pnd-sby/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/l-usr-250-chrs/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/l-usr-250-chrs/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/l-usr-250-chrs/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/neg-rej-req/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/neg-rej-req/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/neg-rej-req/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
      *    =============================================================
      
           MOVE "tests/epic-8/tester-2/emp-mess/"
                  TO WS-FOLDER.
           
           MOVE "tests/epic-8/tester-2/emp-mess/connections.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "connections.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
           MOVE "tests/epic-8/tester-2/emp-mess/accounts.txt"
               TO WS-OVERRIDE-INITIAL-CONDITON.
           MOVE "accounts.txt" 
               TO WS-INITIAL-CONDITION.
           PERFORM MODIFY-INITIAL-CONDITON-FILE.
    
           PERFORM COUNTER-UPDATE.
    
    

      *    ====================== END YOUR TESTS =======================
      *    =============================================================
      *    =============================================================
      *    =============================================================
      *    =============================================================

      *    Now we close everything, and print the results

           PERFORM CLOSE-CONSOLIDATED-FILES.
           DISPLAY "Total Tests Passed: " TotalTestsPassed.
           DISPLAY "Total Tests Failed: " TotalTestsFailed.
           STOP RUN.

      *    =============================================================
      *    =============================================================
      *    ======================== PARAGRAPHS =========================
      *    =============================================================
      *    =============================================================
           COUNTER-UPDATE.
          
      *    ======================= Test Headers ========================
          
      *    Helps with debugging our tests
    
               IF SHOW-HEADERS
                   STRING 
                       "==== TEST: "
                       WS-FOLDER
                       "===="
                       DELIMITED BY SIZE 
                       INTO WS-TEST-HEADER
                   END-STRING
                   WRITE OUTPUT-CONSOLIDATED-REC
                       FROM WS-TEST-HEADER
                   WRITE EXPECTED-CONSOLIDATED-REC
                       FROM WS-TEST-HEADER
               END-IF.
    
    
      *    ==================== Input Output Copiers ===================
        
      *    These are used to rapidly copy our inputs and outputs to a
      *    reusable set of riles
    
               MOVE "input.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-TEST-INPUT.
    
               MOVE "output.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-OUTPUT-FILE.
    
               MOVE "expected.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-EXPECTED-FILE.

               MOVE "accounts.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-ACCOUNTS-FILE.
    
               CALL WS-TEST-CODE USING 
                   WS-TEST-INPUT 
                   WS-OUTPUT-FILE
                   WS-ACCOUNTS-FILE.
               PERFORM COPY-INPUT.
           
               PERFORM START-FILES.
    
      *    ============================ Loop ===========================
    
               PERFORM UNTIL WS-OUTPUT-END AND WS-EXPECTED-END
    
      *    This allows us to tst if a file is shorter than the other
                   IF NOT WS-OUTPUT-END
                       PERFORM READ-OUTPUT
                   END-IF
    
                   IF NOT WS-EXPECTED-END
                       PERFORM READ-EXPECTED
                   END-IF
    
      *        This allows us to test if a line mismatches
    
                   IF NOT WS-OUTPUT-END AND NOT WS-EXPECTED-END          
                       IF WS-OUTPUT-LINE NOT = WS-EXPECTED-LINE
                           MOVE "Y" TO WS-MISMATCH
                       END-IF
                   ELSE
                       IF WS-OUTPUT-EOF NOT = WS-EXPECTED-EOF
                           MOVE "Y" TO WS-MISMATCH
                       END-IF
                   END-IF
                   
               END-PERFORM.
    
      *        Case counter
    
               IF MISMATCH-FOUND OR WS-OUTPUT-EOF NOT = WS-EXPECTED-EOF
                   ADD 1 TO TotalTestsFailed
               ELSE
                   ADD 1 TO TotalTestsPassed
               END-IF.
    
      *        Clear vars and files
               PERFORM CLOSE-FILES.
               IF WS-SKIP-RESET = "N"
                   PERFORM RESET-ORIGINAL-FILES
               ELSE
                   MOVE "N" TO WS-SKIP-RESET
               END-IF.
               MOVE "N" TO WS-MISMATCH.
               MOVE "N" TO WS-OUTPUT-EOF.
               MOVE "N" TO WS-EXPECTED-EOF.
               MOVE SPACES TO WS-OUTPUT-LINE.
               MOVE SPACES TO WS-EXPECTED-LINE.
               MOVE SPACES TO WS-TEST-INPUT.
               MOVE SPACES TO WS-OUTPUT-FILE.
               MOVE SPACES TO WS-EXPECTED-FILE.

      *    Here we set any oringal files needed to 
           SET-ORIGINAL-FILES.
                move 0 to RETURNCODE.

      *    Now we set backups of any files that we use, such as accounts
      *    This allows us to change the file we need to mutate on the
      *    The fly before a test
      *    To set up a standard, just copy the below into both the
      *    Set and rest vars
                CALL "COPY-FILE" USING 
                    "Accounts.txt"
                    "Accounts-backup.txt" 
                    RETURNCODE.
                CALL "COPY-FILE" USING 
                    "Profiles.txt"
                    "Profiles-backup.txt" 
                    RETURNCODE.
                CALL "COPY-FILE" USING 
                    "Connections.txt"
                    "Connections-backup.txt" 
                    RETURNCODE.

           RESET-ORIGINAL-FILES.
                move 0 to RETURNCODE.
     
      *    Now we reset any files that we use, such as accounts

               CALL "COPY-FILE" USING 
                   "Accounts-backup.txt" 
                   "Accounts.txt"
                   RETURNCODE.
               CALL "COPY-FILE" USING 
                   "Profiles-backup.txt" 
                   "Profiles.txt"
                   RETURNCODE.
               CALL "COPY-FILE" USING 
                   "Connections-backup.txt" 
                   "Connections.txt"
                   RETURNCODE.
           
      *    ===================== Helper functions ======================

           BUILD-TEST-PATH.
               MOVE SPACES TO WS-BUILT-PATH.
               STRING WS-FOLDER delimited by space
                   WS-PATH-SUFFIX delimited by space
                 INTO WS-BUILT-PATH
                 ON overflow
                   DISPLAY "err building path" WS-PATH-SUFFIX
               END-STRING.
    
           MODIFY-INITIAL-CONDITON-FILE.
               
               MOVE WS-OVERRIDE-INITIAL-CONDITON TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-OVERRIDE-INITIAL-CONDITON-FILE.
    
    
               CALL "COPY-FILE" USING 
                   WS-OVERRIDE-INITIAL-CONDITON-FILE
                   WS-INITIAL-CONDITION
                   RETURNCODE.
          
           COPY-INPUT.
    
               MOVE "N" TO WS-INPUT-EOF.
           
               OPEN INPUT TEST-INPUT-FILE.
               IF WS-TEST-INPUT-STAT NOT = "00"
                   DISPLAY "ERR"
                   STOP RUN
               END-IF.
    
               PERFORM UNTIL WS-INPUT-END
                    READ TEST-INPUT-FILE INTO WS-INPUT-LINE
                         AT END
                              MOVE "Y" TO WS-INPUT-EOF
                         NOT AT END
                              WRITE TEST-INPUT-CONSOLIDATED-REC
                                FROM WS-INPUT-LINE
                    END-READ
               END-PERFORM
    
               CLOSE TEST-INPUT-FILE.
    
           VERIFY-FILE-OPEN.
               IF WS-CHECK-STAT NOT = "00"
                   DISPLAY "ERROR OPENING" WS-CHECK-NAME
                   DISPLAY "FILE STATUS: " WS-CHECK-STAT
                   STOP RUN
               END-IF.
    
           READ-EXPECTED.
               READ EXPECTED-FILE INTO WS-EXPECTED-LINE
                   AT END
                       MOVE "Y" TO WS-EXPECTED-EOF
                       MOVE SPACES TO WS-EXPECTED-LINE
                   NOT AT END
                       WRITE EXPECTED-CONSOLIDATED-REC
                           FROM WS-EXPECTED-LINE
               END-READ.
    
           READ-OUTPUT.
               READ OUTPUT-FILE INTO WS-OUTPUT-LINE
                   AT END
                       MOVE "Y" TO WS-OUTPUT-EOF
                       MOVE SPACES TO WS-OUTPUT-LINE
                   NOT AT END
                       WRITE OUTPUT-CONSOLIDATED-REC
                           FROM WS-OUTPUT-LINE
               END-READ.
    
    
           START-FILES.
    
               OPEN INPUT  OUTPUT-FILE.
               MOVE WS-OUTPUT-STAT TO WS-CHECK-STAT.
               MOVE WS-OUTPUT-FILE TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
               
               OPEN INPUT  EXPECTED-FILE.
               MOVE WS-EXPECTED-STAT TO WS-CHECK-STAT.
               MOVE WS-EXPECTED-FILE TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
    
    
           START-CONSOLIDATE-FILES.
    
      *        This ensures that we can submit all the tests
               IF FINAL-OUTPUT
                   MOVE "InCollege-Input.txt" 
                       TO WS-TEST-INPUT-CONSOLIDATED
                   MOVE "InCollege-Output.txt" 
                       TO WS-OUTPUT-FILE-CONSOLIDATED
               END-IF.
    
      *        If it's false, they get sent to the test files
    
               OPEN OUTPUT  OUTPUT-FILE-CONSOLIDATED.
               MOVE WS-OUTPUT-STAT-CONSOLIDATED TO WS-CHECK-STAT.
               MOVE WS-OUTPUT-FILE-CONSOLIDATED TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
               
               OPEN OUTPUT  EXPECTED-FILE-CONSOLIDATED.
               MOVE WS-EXPECTED-STAT-CONSOLIDATED TO WS-CHECK-STAT.
               MOVE WS-EXPECTED-FILE-CONSOLIDATED TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
    
               OPEN OUTPUT  TEST-INPUT-CONSOLIDATED.
               MOVE WS-TEST-INPUT-CONSOLIDATED-STAT TO WS-CHECK-STAT.
               MOVE WS-TEST-INPUT-CONSOLIDATED TO WS-CHECK-NAME.
               PERFORM VERIFY-FILE-OPEN.
    
    
           CLOSE-FILES.
               CLOSE OUTPUT-FILE.
               CLOSE EXPECTED-FILE.
    
           T2-RUN.
               MOVE "jobs.txt" TO WS-OVERRIDE-INITIAL-CONDITON.
               MOVE "Jobs.txt" TO WS-INITIAL-CONDITION.
               PERFORM MODIFY-INITIAL-CONDITON-FILE.
               PERFORM T2-RUN-CONTINUE.

           T2-RUN-CONTINUE.
               PERFORM COUNTER-UPDATE.
               PERFORM T2-VERIFY-JOBS.

           T2-VERIFY-JOBS.
      *        Jobs.txt as saved by the program vs expected-jobs.txt.
               MOVE "expected-jobs.txt" TO WS-PATH-SUFFIX.
               PERFORM BUILD-TEST-PATH.
               MOVE WS-BUILT-PATH TO WS-JOBS-EXP-PATH.

               MOVE "N" TO WS-JOBS-MISMATCH.
               MOVE "N" TO WS-JOBS-ACT-EOF.
               MOVE "N" TO WS-JOBS-EXP-EOF.

               OPEN INPUT JOBS-ACTUAL-FILE.
               OPEN INPUT JOBS-EXPECTED-FILE.

               PERFORM UNTIL WS-JOBS-ACT-END AND WS-JOBS-EXP-END
                   IF NOT WS-JOBS-ACT-END
                       READ JOBS-ACTUAL-FILE INTO WS-JOBS-ACT-LINE
                           AT END
                               MOVE "Y" TO WS-JOBS-ACT-EOF
                               MOVE SPACES TO WS-JOBS-ACT-LINE
                       END-READ
                   END-IF

                   IF NOT WS-JOBS-EXP-END
                       READ JOBS-EXPECTED-FILE INTO WS-JOBS-EXP-LINE
                           AT END
                               MOVE "Y" TO WS-JOBS-EXP-EOF
                               MOVE SPACES TO WS-JOBS-EXP-LINE
                       END-READ
                   END-IF

      *            Different record counts, or a record that differs
                   IF WS-JOBS-ACT-EOF NOT = WS-JOBS-EXP-EOF
                       MOVE "Y" TO WS-JOBS-MISMATCH
                   ELSE
                       IF NOT WS-JOBS-ACT-END
                           IF WS-JOBS-ACT-LINE NOT = WS-JOBS-EXP-LINE
                               MOVE "Y" TO WS-JOBS-MISMATCH
                           END-IF
                       END-IF
                   END-IF
               END-PERFORM.

               CLOSE JOBS-ACTUAL-FILE.
               CLOSE JOBS-EXPECTED-FILE.

               IF JOBS-MISMATCH-FOUND
                   ADD 1 TO TotalTestsFailed
                   DISPLAY "JOBS.TXT MISMATCH: " WS-FOLDER
               ELSE
                   ADD 1 TO TotalTestsPassed
               END-IF.

           CLOSE-CONSOLIDATED-FILES.
               CLOSE OUTPUT-FILE-CONSOLIDATED.
               CLOSE EXPECTED-FILE-CONSOLIDATED.
               CLOSE TEST-INPUT-CONSOLIDATED.
           