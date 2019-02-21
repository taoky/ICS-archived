import struct

s = """0101 100 100 1 00000 ; AND R4 R4 1 #0
0001 001 100 1 00010 ; ADD R1 R4 1 #2
0001 010 100 1 00001 ; ADD R2 R4 1 #1
0101 011 001 0 00 000 ; AND R3 R1 0 00 R0
0000 010 000000001 ; BR z #1
0001 100 100 0 00 010 ; ADD R4 R4 0 00 R2
0001 010 010 0 00 010 ; ADD R2 R2 0 00 R2
0001 001 001 0 00 001 ; ADD R1 R1 0 00 R1
0000 101 111111010 ; BR np #-6
0101 000 000 0 00 010 ; AND R0 R0 0 00 R2
0001 000 000 0 00 100 ; ADD R0 R0 0 00 R4
1111 0000 00100101 ; TRAP x25"""

a = s.splitlines()
f = open("program.bin", "wb")

for i in a:
    new_i = i.strip()
    x = int("0b"+new_i[:new_i.find(" ;")].replace(" ", ""), 2)
    print(hex(x), end=' ')
    binary = struct.pack(">H", x)
    f.write(binary)

