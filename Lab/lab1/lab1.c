#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <assert.h>

signed short gcd_lc3impl(signed short a, signed short b) {
    assert(a > 0);
    assert(b > 0);
    while (true) {
        if (a == b) return a;
        else if (a > b) a = a - b;
        else b = b - a; // a < b
    }
}

signed short binary_gcd_lc3impl(signed short a, signed short b) {
    // assert(a > 0);
    // assert(b > 0);
    signed short shift = 0;

    for (; ((a | b) & 1) == 0; shift++)
    {
        a >>= 1; b >>= 1;
    }

    while ((a & 1) == 0)
        a >>= 1;

    do {
        while ((b & 1) == 0)
            b >>= 1;
        if (a > b) {
            signed short t = a; a = b; b = t;
        }

        b = b - a;
    } while (b != 0);

    return a << shift;
}

signed short gcd(signed short a, signed short b) {
    if (b == 0)
        return a;
    else
        return gcd(b, a % b);
}

int main(int argc, char *argv[]) {
    if (argc != 4) {
        puts("Missing R0, R1 or base");
        return -1;
    }
    signed short r0 = strtol(argv[1], (char **)NULL, atoi(argv[3]));
    signed short r1 = strtol(argv[2], (char **)NULL, atoi(argv[3]));
    assert(r0 > 0);
    assert(r1 > 0);
    signed short result = gcd(r0, r1);
    printf("x%04hX\n", result);
    return 0;
}