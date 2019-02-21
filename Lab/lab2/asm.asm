.ORIG x3000

START ; initialization
      LD R6, STACK_BASE ; R6 is the stack pointer
      AND R0, R0, #0
      AND R1, R0, #0
      AND R2, R0, #0
      AND R3, R0, #0
      AND R4, R0, #0
      AND R5, R0, #0
      ; as __start() is not a function, the value will be set in main() 

      JSR MAIN ; return value in top of the stack
      LDR R0, R6, #0
      HALT

MAIN ; main()
     ; we can assume that main() can be run only once during the control flow
     ; so the stack structure of main() can be simplified
     ADD R6, R6, #-2
     STR R7, R6, #0

     GETC
     OUT ; for debug only
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

     LDR R0, R6, #0
     LDR R7, R6, #8
     ADD R6, R6, #9
     STR R0, R6, #0
     RET

FUNC ADD R6, R6, #-2
     STR R7, R6, #0
     ADD R6, R6, #-3 ; 3 local variables: t, x and y
     
     GETC
     OUT ; for debug only
     ADD R0, R0, #-16
     ADD R0, R0, #-16
     ADD R0, R0, #-16
     LDR R1, R6, #6 ; a
     ADD R0, R0, R1
     LDR R1, R6, #7
     ADD R0, R0, R1
     LDR R1, R6, #8
     ADD R0, R0, R1
     LDR R1, R6, #9
     ADD R0, R0, R1
     LDR R1, R6, #10
     ADD R0, R0, R1
     LDR R1, R6, #11
     ADD R0, R0, R1
     STR R0, R6, #2 ; stores t
     LDR R2, R6, #5 ; loads n
     ADD R2, R2, #-1 ; R2 = n - 1
     BRp BRANCH1
     ; BRANCH2
     ; R0 still stores t, so
     STR R0, R6, #4
     LDR R7, R6, #3
     ADD R6, R6, #4
     RET
     BRANCH1 ; now R2 stores n - 1
             ADD R6, R6, #-7
             STR R2, R6, #0
             AND R3, R3, #0
             STR R3, R6, #1 
             STR R3, R6, #2 
             STR R3, R6, #3 
             STR R3, R6, #4 
             STR R3, R6, #5 
             STR R3, R6, #6
             JSR FUNC
             LDR R3, R6, #0 ; the return value x
             ADD R6, R6, #7 ; pop arguments
             LDR R2, R6, #6 ; reload n
             ADD R2, R2, #-2
             STR R3, R6, #2
             ADD R6, R6, #-6
             AND R3, R3, #0
             STR R2, R6, #0
             STR R3, R6, #1 
             STR R3, R6, #2 
             STR R3, R6, #3 
             STR R3, R6, #4 
             STR R3, R6, #5 
             STR R3, R6, #6
             JSR FUNC
             LDR R3, R6, #0 ; the return value y
             ADD R6, R6, #7
             STR R3, R6, #1
             LDR R2, R6, #2 ; loads x
             LDR R1, R6, #3 ; loads t
             ADD R3, R3, R2
             ADD R3, R3, R1
             ADD R3, R3, #-1 ; ret value
             STR R3, R6, #5
             LDR R7, R6, #4
             ADD R6, R6, #5
             RET




GLOBAL 
       STACK_BASE .FILL xFE00
    ;    STACK_MAX .FILL xEDFF

.END