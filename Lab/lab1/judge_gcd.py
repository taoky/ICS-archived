#!/usr/bin/env python2

from random import *
from pwn import *
from fractions import gcd
import time

#context.log_level = 'debug'

cnt_list1 = []
cnt_list2 = []

lc3sim = process(argv=["lc3sim", "asm2.obj"])

for i in range(0, 512):
    lc3sim.recvuntil("x3000\n")
    r0 = randint(1, 32767)
    r1 = randint(1, 32767)
    print "Testing R0={}, R1={}".format(hex(r0), hex(r1))
    halt_point = "3011"
    expected_res = "x" + hex(gcd(r0, r1))[2:].rjust(4, "0")
    lc3sim.send("r r0 {}\nr r1 {}\nb s {}\n".format(hex(r0), hex(r1), halt_point))
    lc3sim.recvuntil("at x{}.\n".format(halt_point.upper()))
    cnt = 0
    while True:
        #pause()
        lc3sim.sendline("n")
        #time.sleep(0.001)
        ret = lc3sim.recvlines(3)
        line_now = ret[-1][20:24].lower()
        #print line_now
        #print ret
        if "breakpoint" in ret[0]:
            # compare result
            lc3_result = ret[-1][3:8].lower()
            if lc3_result != expected_res:
                print "ERROR: expected {}, got {}".format(expected_res, lc3_result)
                exit(0)
            if (abs(r0-r1)<50 and r0>10000) or (abs(r0-r1)>10000 and ((r0>10000 and r1<100) or (r1>10000 and r0<100))):
                cnt_list1.append([r0, r1, cnt])
            if cnt > 2000:
                cnt_list2.append([r0, r1, cnt])
            print("Passed. Used {} steps".format(cnt))
            #lc3sim.close()
            lc3sim.sendline("reset")
            break
        cnt += 1

print cnt_list1
print cnt_list2
