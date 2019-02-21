.ORIG x3000

GCD
    ; R0 = a, R1 = b
    NOT R2, R1
    ADD R2, R2, #1 ; R2 = -b
    ADD R3, R0, R2 ; check a - b
    BRz END
    BRn HANDLE_B_MINUS_A
    ADD R0, R3, #0
    BRnzp GCD
    HANDLE_B_MINUS_A NOT R2, R0
                     ADD R2, R2, #1
                     ADD R1, R1, R2 ; b - a
                     BRnzp GCD

END HALT

.END
