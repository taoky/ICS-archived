.ORIG x3000

START ; initialization
      LD R6, STACK_BASE ; R6 is the stack pointer
      LD R5, STACK_MAX
      AND R0, R0, #0
      AND R1, R0, #0
      AND R2, R0, #0
      AND R3, R0, #0
      AND R4, R0, #0

      JSR MAIN ; return value in top of the stack
      HALT

MAIN ; main()
     ; check if enough space for storing 8 elements?
     ADD R4, R6, R5
     ADD R4, R4, #-8
     BRnz STACK_OVERFLOW

     ADD R6, R6, #-1
     STR R7, R6, #0

     GETC
    ;  OUT ; for debug only
     ADD R0, R0, #-16
     ADD R0, R0, #-16
     ADD R0, R0, #-16 ; now, R0 = n
     ADD R6, R6, #-7 ; 7 arguments
     STR R0, R6, #0
     STR R1, R6, #1 ; R1 = 0 now
     STR R1, R6, #2
     STR R1, R6, #3
     STR R1, R6, #4
     STR R1, R6, #5
     STR R1, R6, #6

     JSR FUNC
     LDR R7, R6, #0
     ; R0 is naturally the return value, directly return
     RET

FUNC ADD R4, R6, R5
     ADD R4, R4, #-3
     BRnz STACK_OVERFLOW

     ADD R6, R6, #-1
     STR R7, R6, #0
     ADD R6, R6, #-2 ; 2 local variables: t, x; y won't be stored in stack
     
     GETC
    ;  OUT ; for debug only
     ADD R0, R0, #-16
     ADD R0, R0, #-16
     ADD R0, R0, #-16
     LDR R1, R6, #4 ; a
     ADD R0, R0, R1
     LDR R1, R6, #5
     ADD R0, R0, R1
     LDR R1, R6, #6
     ADD R0, R0, R1
     LDR R1, R6, #7
     ADD R0, R0, R1
     LDR R1, R6, #8
     ADD R0, R0, R1
     LDR R1, R6, #9
     ADD R0, R0, R1
     STR R0, R6, #1 ; stores t
     LDR R2, R6, #3 ; loads n
     ADD R2, R2, #-1 ; R2 = n - 1
     BRp BRANCH1
     ; BRANCH2
     ; R0 still stores t, so
     LDR R7, R6, #2
     ADD R6, R6, #10
     RET
     BRANCH1 ; now R2 stores n - 1
             ADD R6, R6, #-7
             ADD R4, R6, R5
             BRnz STACK_OVERFLOW

             STR R2, R6, #0
             AND R3, R3, #0
             STR R3, R6, #1 
             STR R3, R6, #2 
             STR R3, R6, #3 
             STR R3, R6, #4 
             STR R3, R6, #5 
             STR R3, R6, #6
             JSR FUNC ; after that, return value is in R0
             STR R0, R6, #0 ; store the return value x
             LDR R2, R6, #3 ; reload n
             ADD R2, R2, #-2
             ADD R6, R6, #-7

             ADD R4, R6, R5
             BRnz STACK_OVERFLOW

             AND R3, R3, #0
             STR R2, R6, #0
             STR R3, R6, #1 
             STR R3, R6, #2 
             STR R3, R6, #3 
             STR R3, R6, #4 
             STR R3, R6, #5 
             STR R3, R6, #6
             JSR FUNC ; y = R0
             LDR R2, R6, #0 ; loads x
             ADD R0, R0, R2
             LDR R2, R6, #1 ; loads t
             ADD R0, R0, R2
             ADD R0, R0, #-1 ; ret value
             LDR R7, R6, #2
             ADD R6, R6, #10
             RET

STACK_OVERFLOW LEA R0, MEG
               PUTS
               HALT

GLOBAL 
       STACK_BASE .FILL xFE00
       STACK_MAX .FILL x1200 ; -xEE00
    ;    STACK_MAX .FILL x0300 ; -xFD00
       MEG .STRINGZ "Stack overflow detected. This computer will be halting immediately."
       .FILL x1234
       TESTTT   .BLKW #11
       .BLKW x12
.END