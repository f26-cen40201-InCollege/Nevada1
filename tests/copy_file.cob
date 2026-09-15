       identification division.
       program-id. COPY-FILE.
       author. Ian Koratsky.

       environment division.
       input-output section.
       file-control.
           select source-file assign to ws-source-name
               organization is sequential
               file status is ws-source-status.
           select target-file assign to ws-target-name
               organization is sequential
               file status is ws-target-status.
       
       data division.
       file section.
           fd source-file.
           01 source-record PIC X(200).
           fd target-file.
           01 target-record PIC X(200).

       working-storage section.
           01 ws-eof PIC X value 'N'.
           01 ws-source-name pic x(100).
           01 ws-target-name pic x(100).
           01 ws-source-status pic xx.
           01 ws-target-status pic xx.
       
       linkage section.
           01 lk-source-file-path pic x(100).
           01 lk-target-file-path pic x(100).
           01 lk-return-code pic 9(4) comp.

       procedure division using 
               lk-source-file-path 
               lk-target-file-path
               lk-return-code.

           move 'N' to ws-eof.
           move lk-source-file-path to ws-source-name.
           move lk-target-file-path to ws-target-name.
           move 0 to lk-return-code.

           open input source-file.
           if ws-source-status not = "00"
               move 1 to lk-return-code
               goback
           end-if

           open output target-file.
           if ws-target-status not = "00"
               move 2 to lk-return-code
               close source-file
               goback
           end-if


           perform until ws-eof = 'Y'
               read source-file
                   at end move 'Y' to ws-eof
                   not at end
                       write target-record from source-record
               end-read
           end-perform

           close source-file
           close target-file
           goback.