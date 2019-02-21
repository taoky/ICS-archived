.ORIG x3000

; handling zero and negative situations
; "SUCCESS" stores in R2. R2 = 0 success, else failed
ADD R0, R0, #0
BRnz BAD_END
ADD R1, R1, #0
BRnz BAD_END

GCD
    ; R0 = a, R1 = b
    NOT R2, R1
    ADD R2, R2, #1 ; R2 = -b
    ADD R2, R0, R2 ; check a - b
    BRz END
    BRn HANDLE_B_MINUS_A
    ADD R0, R2, #0
    BRnzp GCD
    HANDLE_B_MINUS_A NOT R1, R2
                     ADD R1, R1, #1
                     ; swap R0 and R1
                     ADD R2, R1, #0
                     ADD R1, R0, #0
                     ADD R0, R2, #0
                     BRnzp GCD

END
    ; AND R2, R2, #0
    HALT

BAD_END
    AND R2, R2, #0
    ADD R2, R2, #-1
    HALT

.END
