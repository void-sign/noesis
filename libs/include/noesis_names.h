/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#ifndef NOESIS_NAMES_H
#define NOESIS_NAMES_H

/* 
 * This file defines short aliases for Noesis libc functions
 * Short names are the recommended approach for Noesis libc
 */

/* I/O Functions */
    #define out     nlibc_printf
    #define fout    nlibc_fprintf
    #define sout    nlibc_sprintf
    #define slen    nlibc_snprintf
    #define vout    nlibc_vprintf
    #define vfout   nlibc_vfprintf
    #define vsout   nlibc_vsprintf
    #define vslen   nlibc_vsnprintf
    #define in      nlibc_scanf
    #define fin     nlibc_fscanf
    #define scan    nlibc_sscanf
    #define get     nlibc_getchar
    #define fget    nlibc_fgetc
    #define put     nlibc_putchar
    #define fput    nlibc_fputc
    #define gets    nlibc_fgets
    #define puts    nlibc_fputs
    #define write   nlibc_puts
    #define unget   nlibc_ungetc

    /* File Operations */
    #define open    nlibc_fopen
    #define close   nlibc_fclose
    #define load    nlibc_fread
    #define save    nlibc_fwrite
    #define jump    nlibc_fseek
    #define pos     nlibc_ftell
    #define flush   nlibc_fflush
    #define eof     nlibc_feof
    #define err     nlibc_ferror
    #define clear   nlibc_clearerr
    
    /* Memory Management */
    #define new     nlibc_malloc
    #define zero    nlibc_calloc
    #define grow    nlibc_realloc
    #define del     nlibc_free

    /* String Operations */
    #define copy    nlibc_strcpy
    #define ncpy    nlibc_strncpy
    #define cmp     nlibc_strcmp
    #define ncmp    nlibc_strncmp
    #define len     nlibc_strlen
    #define join    nlibc_strcat
    #define njoin   nlibc_strncat
    #define find    nlibc_strchr
    #define rfind   nlibc_strrchr
    #define seek    nlibc_strstr
    
    /* Memory Operations */
    #define mcpy    nlibc_memcpy
    #define move    nlibc_memmove
    #define fill    nlibc_memset
    #define mcmp    nlibc_memcmp
    
    /* Conversion Functions */
    #define toint   nlibc_atoi
    #define tolong  nlibc_atol
    #define tollong nlibc_atoll
    #define toflt   nlibc_atof
    #define itostr  nlibc_itoa
    #define ltostr  nlibc_ltoa
    #define lltostr nlibc_lltoa
    
    /* Math Operations */
    #define abs     nlibc_abs
    #define labs    nlibc_labs
    #define llabs   nlibc_llabs
    #define div     nlibc_div
    #define ldiv    nlibc_ldiv
    #define lldiv   nlibc_lldiv
    
    /* Misc Functions */
    #define rand    nlibc_rand
    #define srand   nlibc_srand
    #define sort    nlibc_qsort
    #define search  nlibc_bsearch
    #define exit    nlibc_exit
    #define halt    nlibc_abort
    #define onexit  nlibc_atexit
    #define qexit   nlibc_at_quick_exit
    #define getenv getenv
    #define setenv  nlibc_setenv
    #define unenv   nlibc_unsetenv
    #define putenv  nlibc_putenv
    #define sys     nlibc_system
    
/* Standard streams */
#define instr   nlibc_stdin
#define outstr  nlibc_stdout
#define errstr  nlibc_stderr

/* Explicit declarations for memory management functions */
void* nlibc_malloc(size_t size);
void nlibc_free(void* ptr);

#endif /* NOESIS_NAMES_H */
