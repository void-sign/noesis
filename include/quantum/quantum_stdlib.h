#ifndef QUANTUM_STDLIB_H
#define QUANTUM_STDLIB_H

/* 
 * This header resolves conflicts between system stdlib.h and noesis stdlib.h
 * for the quantum module which needs to use system functions
 */

#ifdef NOESIS_BUILDING_LIB
/* When building the library, we mark div_t structures as already defined 
   to prevent redefinition errors when system stdlib.h is included */
#define div_t __system_div_t
#define ldiv_t __system_ldiv_t  
#define lldiv_t __system_lldiv_t

/* Include system stdlib */
#include <stdlib.h>

/* Restore our names */
#undef div_t
#undef ldiv_t
#undef lldiv_t

/* Ensure our types are available */
#include "noesis_libc/include/noesis_types.h"

#else
/* Normal case: just use our stdlib */
#include "noesis_libc/include/stdlib/stdlib.h"
#endif

#endif /* QUANTUM_STDLIB_H */
