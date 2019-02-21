.ORIG x3000

CHOOSE NOT R2, R1
       ADD R2, R2, #1
       ADD R2, R0, R2
       BRz STOP
       BRp CON1
       NOT R2, R2
       ADD R2, R2, #1
       ADD R3, R0, #0
       ADD R0, R1, #0
       ADD R1, R3, #0 ; R2 = abs(R0 - R1), R0 > R1
       CON1 LD R3, HUNDRED
            ADD R3, R3, R2
            BRp CON2
            LD R3, TTHOUSAND
            ADD R3, R4, R0
            BRn CON2
            BRzp GCD2
       CON2 LD R3, TTHOUSAND
            ADD R4, R3, R2
            BRn GCD1
            ADD R4, R3, R0
            BRn GCD1
            LD R3, THUNDRED
            ADD R3, R3, R1
            BRnz GCD2
            
GCD1 NOT R2, R1
     ADD R2, R2, #1 ; R2 = -b
     ADD R2, R0, R2 ; check a - b
     BRz STOP
     BRn HANDLE_B_MINUS_A
     ADD R0, R2, #0
     BRnzp GCD1
     HANDLE_B_MINUS_A NOT R1, R2
                      ADD R1, R1, #1
                      BRnzp GCD1

GCD2 AND R2, R2, #0 ; shift

S1 AND R3, R0, #1 ; is R0 odd?
   BRnp S2
   AND R3, R1, #1 ; is R1 odd?
   BRnp S2
   R0RS0 ; uses R3, R4, R5 and R6
     AND R6, R6, #0
     ADD R5, R6, #1
     START ADD R4, R5, R5
           AND R3, R4, R0 ; R3: tmp
           BRz NSET
           ADD R6, R6, R5
           NSET ADD R5, R5, R5
           BRnp START
     AND R0, R0, R5
     ADD R0, R0, R6
   R1RS0 ; uses R3, R4, R5 and R6
     AND R6, R6, #0
     ADD R5, R6, #1
     START1 ADD R4, R5, R5
            AND R3, R4, R1 ; R3: tmp
            BRz NSET1
            ADD R6, R6, R5
            NSET1 ADD R5, R5, R5
            BRnp START1
     AND R1, R1, R5
     ADD R1, R1, R6
   ADD R2, R2, #1
   BRnzp S1

S2 AND R3, R0, #1
   BRnp S3
   R0RS1 ; uses R3, R4, R5 and R6
     AND R6, R6, #0
     ADD R5, R6, #1
     START2 ADD R4, R5, R5
           AND R3, R4, R0 ; R3: tmp
           BRz NSET2
           ADD R6, R6, R5
           NSET2 ADD R5, R5, R5
           BRnp START2
     AND R0, R0, R5
     ADD R0, R0, R6
   BRnzp S2

S3 AND R3, R1, #1
   BRnp S4
   R1RS1 ; uses R3, R4, R5 and R6
     AND R6, R6, #0
     ADD R5, R6, #1
     START3 ADD R4, R5, R5
            AND R3, R4, R1 ; R3: tmp
            BRz NSET3
            ADD R6, R6, R5
            NSET3 ADD R5, R5, R5
            BRnp START3
     AND R1, R1, R5
     ADD R1, R1, R6
   BRnzp S3

S4 NOT R3, R1
   ADD R3, R3, R0
   ADD R3, R3, #1 ; R3 = R0 - R1
   BRnz S5
   ADD R4, R1, #0
   ADD R1, R0, #0
   ADD R0, R4, #0 ; swap R0 and R1

S5 ADD R1, R3, #0
   BRp S3
   BRz S6
   NOT R1, R1
   ADD R1, R1, #1
   BRnzp S3

S6 ADD R2, R2, #-1
   BRn STOP
   ADD R0, R0, R0
   BRnzp S6

STOP HALT

HUNDRED .FILL #-100
TTHOUSAND .FILL #-10000
THUNDRED .FILL #-200

.END
