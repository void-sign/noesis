#include "../../include/stdlib/stdlib.h"

/* Global state for random number generator */
static unsigned int rand_state = 1;

/* Simple random number generation algorithm 
 * Uses a linear congruential generator (LCG) with parameters:
 * - multiplier: 1103515245
 * - increment: 12345
 * - modulus: 2^31
 */
int nlibc_rand(void) {
    rand_state = (rand_state * 1103515245 + 12345) & 0x7fffffff;
    return (int)(rand_state & 0x7fff);
}

/* Seed the random number generator */
void nlibc_srand(unsigned int seed) {
    rand_state = seed;
}
