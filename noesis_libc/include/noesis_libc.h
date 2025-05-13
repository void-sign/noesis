#ifndef NOESIS_LIBC_H
#define NOESIS_LIBC_H

/* Meta-header for the Noesis custom libc implementation */

/* Include all standard library headers */
#include "noesis_types.h"
#include "stdlib/stdlib.h"
#include "stdio/stdio.h"
#include "string/string.h"
#include "math/math.h"
#include "unistd/unistd.h"
#include "sys/syscall.h"

/* Version information */
#define NOESIS_LIBC_VERSION_MAJOR 1
#define NOESIS_LIBC_VERSION_MINOR 0
#define NOESIS_LIBC_VERSION_PATCH 0

/* Initialize the library */
int noesis_libc_init(void);

/* Clean up resources used by the library */
void noesis_libc_cleanup(void);

#endif /* NOESIS_LIBC_H */
