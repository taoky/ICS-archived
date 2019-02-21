.Orig x3000
INIT_CODE
LEA R6, #-1
ADD R5, R6, #0
ADD R6, R6, R6
ADD R6, R6, R6
ADD R6, R6, R5
ADD R6, R6, #-1
ADD R5, R5, R5
ADD R5, R6, #0
LD R4, GLOBAL_DATA_POINTER
LD R7, GLOBAL_MAIN_POINTER
jsrr R7
LDR R0, R6, #0 ; get the top stack value
HALT

GLOBAL_DATA_POINTER .FILL GLOBAL_DATA_START
GLOBAL_MAIN_POINTER .FILL main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;func;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lc3_func
ADD R6, R6, #-2
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #-1

ADD R6, R6, #-3
ADD R0, R4, #4
LDR R0, R0, #0 ; R0 = getchar()
jsrr R0
LDR R7, R6, #0
ADD R6, R6, #1
ADD R3, R4, #8
ldr R3, R3, #0
ADD R6, R6, #-1
STR R0, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0
NOT R3, R3
ADD R3, R3, #1
ADD R0, R7, R3
LDR R3, R6, #0
ADD R6, R6, #1
ADD R7, R0, #0
LDR R0, R6, #0
ADD R6, R6, #1
ldr R3, R5, #5
add R7, R7, R3
ldr R3, R5, #6
add R7, R7, R3
ldr R3, R5, #7
add R7, R7, R3
ldr R3, R5, #8
add R7, R7, R3
ldr R3, R5, #9
add R7, R7, R3
ldr R3, R5, #10
add R7, R7, R3
str R7, R5, #0
ldr R7, R5, #4
ADD R3, R4, #7
ldr R3, R3, #0
NOT R7, R7
ADD R7, R7, #1
ADD R7, R7, R3
BRn L7 ; if n - 1 < 0
ADD R7, R4, #1
LDR R7, R7, #0 ; R7 = lc3_L3_lc3
jmp R7
L7
ldr R7, R5, #10
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #9
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #8
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #7
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #6
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #5
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #4
ADD R3, R4, #7
ldr R3, R3, #0
ADD R6, R6, #-1
STR R0, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0
NOT R3, R3
ADD R3, R3, #1
ADD R0, R7, R3
LDR R3, R6, #0
ADD R6, R6, #1
ADD R7, R0, #0
LDR R0, R6, #0
ADD R6, R6, #1
ADD R6, R6, #-1
STR R7, R6, #0
ADD R0, R4, #0
LDR R0, R0, #0
jsrr R0
LDR R7, R6, #0
ADD R6, R6, #1
str R7, R5, #-1
ldr R7, R5, #10
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #9
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #8
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #7
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #6
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #5
ADD R6, R6, #-1
STR R7, R6, #0
ldr R7, R5, #4
ADD R3, R4, #6
ldr R3, R3, #0
ADD R6, R6, #-1
STR R0, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0
NOT R3, R3
ADD R3, R3, #1
ADD R0, R7, R3
LDR R3, R6, #0
ADD R6, R6, #1
ADD R7, R0, #0
LDR R0, R6, #0
ADD R6, R6, #1
ADD R6, R6, #-1
STR R7, R6, #0
ADD R0, R4, #0
LDR R0, R0, #0
jsrr R0
LDR R7, R6, #0
ADD R6, R6, #1
str R7, R5, #-2
ldr R7, R5, #-1
ldr R3, R5, #-2
add R7, R7, R3
ldr R3, R5, #0
add R7, R7, R3
ADD R3, R4, #7
ldr R3, R3, #0
ADD R6, R6, #-1
STR R0, R6, #0
ADD R6, R6, #-1
STR R3, R6, #0
NOT R3, R3
ADD R3, R3, #1
ADD R0, R7, R3
LDR R3, R6, #0
ADD R6, R6, #1
ADD R7, R0, #0
LDR R0, R6, #0
ADD R6, R6, #1
ADD R0, R4, #2
LDR R0, R0, #0
JMP R0
lc3_L3_lc3
ldr R7, R5, #0
lc3_L1_lc3
STR R7, R5, #3
ADD R6, R5, #1
LDR R5, R6, #0
ADD R6, R6, #1
LDR R7, R6, #0
ADD R6, R6, #1
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main
ADD R6, R6, #-2
STR R7, R6, #0
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #-1

ADD R6, R6, #-1
ADD R0, R4, #4
LDR R0, R0, #0
jsrr R0
LDR R7, R6, #0 ; R7 = return value
ADD R6, R6, #1 ; pop return value
ADD R3, R4, #8 ; load table
ldr R3, R3, #0 ; R3 = 48 ('0')
ADD R6, R6, #-1 ; prepare pushing
STR R0, R6, #0 ; push R0 (the address of lc3_getchar)
ADD R6, R6, #-1 ; prepare pushing
STR R3, R6, #0 ; push 48
NOT R3, R3
ADD R3, R3, #1 ; R3 = -48
ADD R0, R7, R3 ; R0 = GETC() - 48
LDR R3, R6, #0 ; R3 = 48 (reload R3)
ADD R6, R6, #1 ; pop 48
ADD R7, R0, #0 ; R7 = R0 = GETC() - 48
LDR R0, R6, #0 ; R0 = the address of lc3_getchar
ADD R6, R6, #1 ; pop 
str R7, R5, #0 ; store R7's result

ADD R7, R4, #5 ; load table
ldr R7, R7, #0 ; R7 = 0
ADD R6, R6, #-1
STR R7, R6, #0 ; stores 7th arg
ADD R6, R6, #-1
STR R7, R6, #0 ; stores 6th arg
ADD R6, R6, #-1
STR R7, R6, #0 ; stores 5th arg
ADD R6, R6, #-1
STR R7, R6, #0 ; stores 4th arg
ADD R6, R6, #-1
STR R7, R6, #0 ; stores 3rd arg
ADD R6, R6, #-1
STR R7, R6, #0 ; stores 2nd arg
ldr R7, R5, #0 ; load 1st arg = GETC() - 48
ADD R6, R6, #-1
STR R7, R6, #0 ; stores 1st arg
ADD R0, R4, #0 ; load table
LDR R0, R0, #0 ; R0 = address of func
jsrr R0
LDR R7, R6, #0
ADD R6, R6, #1
lc3_L8_lc3
STR R7, R5, #3 ; save return value as the return value
ADD R6, R5, #1 ; restore stack pointer
LDR R5, R6, #0 ; restore the R5 of caller
ADD R6, R6, #1 ; pop
LDR R7, R6, #0 ; restore the R7 (return address) of caller
ADD R6, R6, #1 ; pop
RET ; return

; char getchar(void)

lc3_getchar

STR R7, R6, #-3
STR R0, R6, #-2
GETC
; OUT
STR R0, R6, #-1
LDR R0, R6, #-2
LDR R7, R6, #-3
ADD R6, R6, #-1
RET

GLOBAL_DATA_START
func .FILL lc3_func
L3_lc3 .FILL lc3_L3_lc3
L1_lc3 .FILL lc3_L1_lc3
L8_lc3 .FILL lc3_L8_lc3
getchar .FILL lc3_getchar
L9_lc3 .FILL #0
L6_lc3 .FILL #2
L5_lc3 .FILL #1
L2_lc3 .FILL #48
.END
