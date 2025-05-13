/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#include "../../include/stdio/stdio.h"
#include "../../include/noesis_types.h"
#include "../../../include/utils/io_functions.h"  // For noesis_getchar

// Implementation of nlibc_getchar that uses our custom noesis_getchar
int nlibc_getchar(void) {
    return noesis_getchar();
}
