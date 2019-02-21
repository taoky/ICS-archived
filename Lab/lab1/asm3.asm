.ORIG x3000

ST R7, SaveR7
AND R2, R2, #0 ; shift

S1 AND R3, R0, #1 ; is R0 odd?
   BRnp S2
   AND R3, R1, #1 ; is R1 odd?
   BRnp S2
   JSR R0RS
   JSR R1RS
   ADD R2, R2, #1
   BRnzp S1

S2 AND R3, R0, #1
   BRnp S3
   JSR R0RS
   BRnzp S2

S3 AND R3, R1, #1
   BRnp S4
   JSR R1RS
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

STOP LD R7, SaveR7
     HALT

R0RS ; uses R3, R4, R5 and R6
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
     RET

R1RS ; uses R3, R4, R5 and R6
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
     RET


SaveR7 .BLKW 1

.END
