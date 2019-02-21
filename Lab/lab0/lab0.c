// File: lab0.c
// Author: taoky

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        puts("Missing R0 or base");
        return -1;
    }
    signed short r0 = strtol(argv[1], (char **)NULL, atoi(argv[2]));
    // printf("%hd\n", r0);
    signed short result = r0 >> 1;
    printf("x%04hX\n", result);
    return 0;
}
