/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software under the following conditions:
 *
 * 1. The Software may be used, copied, modified, merged, published, distributed,
 *    sublicensed, and sold under the terms specified in this license.
 *
 * 2. Redistribution of the Software or modifications thereof must include the
 *    original copyright notice and this license.
 *
 * 3. Any use of the Software in production or commercial environments must provide
 *    clear attribution to the original author(s) as defined in the copyright notice.
 *
 * 4. The Software may not be used for any unlawful purpose, or in a way that could
 *    harm other humans, animals, or living beings, either directly or indirectly.
 *
 * 5. Any modifications made to the Software must be clearly documented and made
 *    available under the same Noesis License or a compatible license.
 *
 * 6. If the Software is a core component of a profit-generating system, 
 *    the user must donate 10% of the net profit directly resulting from such
 *    use to a recognized non-profit or charitable foundation supporting humans 
 *    or other living beings.
 */

// noesis_lib_tests.c - Unit tests for Noesis-specific utility functions

#include "../include/utils/noesis_lib.h"
#include "../include/utils/timer.h"

// Test function for noesis_print
void test_noesis_print() {
    noesis_print("Testing noesis_print function.\n");
}

// Test function for noesis_get_time
void test_noesis_get_time() {
    unsigned long time1 = noesis_get_time();
    unsigned long time2 = noesis_get_time();

    if (time2 > time1) {
        noesis_print("noesis_get_time test passed.\n");
    } else {
        noesis_print("noesis_get_time test failed.\n");
    }
}

// Main function to run all tests
int main() {
    test_noesis_print();
    test_noesis_get_time();

    return 0;
}
