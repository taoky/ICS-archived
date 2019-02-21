.ORIG x3000
AND R1, R1, x0 ; R1 input mask
AND R2, R2, x0 ; R2 output mask
AND R4, R4, x0
ADD R1, R1, x2 ; 0b10
ADD R2, R2, x1 ; 0b01
START AND R3, R1, R0 ; R3 a temporary variable
BRz NSET
ADD R4, R4, R2 ; R4 output var
NSET ADD R2, R2, R2
ADD R1, R1, R1
BRnp START
AND R3, R2, R0
ADD R4, R4, R3
AND R0, R0, x0
ADD R0, R0, R4 ; R0 = R4
HALT
.END
