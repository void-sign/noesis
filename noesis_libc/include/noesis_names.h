/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#ifndef NOESIS_NAMES_H
#define NOESIS_NAMES_H

/* 
 * This file defines short aliases for Noesis libc functions
 * It consolidates both short names and standard names into one place
 * Use #define NOESIS_USE_SHORT_NAMES to enable short names
 * Use #define NOESIS_LIBC_USE_STD_NAMES to enable standard names (backward compatibility)
 */

/* Short names are now the recommended approach */
#ifdef NOESIS_USE_SHORT_NAMES
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
    #define getenv  nlibc_getenv
    #define setenv  nlibc_setenv
    #define unenv   nlibc_unsetenv
    #define putenv  nlibc_putenv
    #define sys     nlibc_system
    
    /* Standard streams */
    #define instr   nlibc_stdin
    #define outstr  nlibc_stdout
    #define errstr  nlibc_stderr
#endif /* NOESIS_USE_SHORT_NAMES */

/* For backward compatibility, also include standard C library names mapping */
#ifdef NOESIS_LIBC_USE_STD_NAMES
    /* stdio.h functions */
    #define printf      nlibc_printf
    #define fprintf     nlibc_fprintf
    #define sprintf     nlibc_sprintf
    #define snprintf    nlibc_snprintf
    #define vprintf     nlibc_vprintf
    #define vfprintf    nlibc_vfprintf
    #define vsprintf    nlibc_vsprintf
    #define vsnprintf   nlibc_vsnprintf
    #define scanf       nlibc_scanf
    #define fscanf      nlibc_fscanf
    #define sscanf      nlibc_sscanf
    #define fgetc       nlibc_fgetc
    #define getc        nlibc_getc
    #define getchar     nlibc_getchar
    #define fputc       nlibc_fputc
    #define putc        nlibc_putc
    #define putchar     nlibc_putchar
    #define fgets       nlibc_fgets
    #define fputs       nlibc_fputs
    #define puts        nlibc_puts
    #define ungetc      nlibc_ungetc
    #define fread       nlibc_fread
    #define fwrite      nlibc_fwrite
    #define fseek       nlibc_fseek
    #define ftell       nlibc_ftell
    #define fflush      nlibc_fflush
    #define feof        nlibc_feof
    #define ferror      nlibc_ferror
    #define clearerr    nlibc_clearerr
    #define fopen       nlibc_fopen
    #define fclose      nlibc_fclose

    /* stdlib.h functions */
    #define malloc      nlibc_malloc
    #define calloc      nlibc_calloc
    #define realloc     nlibc_realloc
    #define free        nlibc_free
    #define exit        nlibc_exit
    #define abort       nlibc_abort
    #define atexit      nlibc_atexit
    #define at_quick_exit nlibc_at_quick_exit
    #define quick_exit  nlibc_quick_exit
    #define atoi        nlibc_atoi
    #define atol        nlibc_atol
    #define atoll       nlibc_atoll
    #define atof        nlibc_atof
    #define div         nlibc_div
    #define ldiv        nlibc_ldiv
    #define lldiv       nlibc_lldiv
    #define abs         nlibc_abs
    #define labs        nlibc_labs
    #define llabs       nlibc_llabs
    #define rand        nlibc_rand
    #define srand       nlibc_srand
    #define qsort       nlibc_qsort
    #define bsearch     nlibc_bsearch
    #define getenv      nlibc_getenv
    #define setenv      nlibc_setenv
    #define unsetenv    nlibc_unsetenv
    #define putenv      nlibc_putenv
    #define system      nlibc_system
    /* Non-standard but common */
    #define itoa        nlibc_itoa
    #define ltoa        nlibc_ltoa
    #define lltoa       nlibc_lltoa

    /* string.h functions */
    #define memcpy      nlibc_memcpy
    #define memmove     nlibc_memmove
    #define memset      nlibc_memset
    #define memcmp      nlibc_memcmp
    #define strlen      nlibc_strlen
    #define strcpy      nlibc_strcpy
    #define strncpy     nlibc_strncpy
    #define strcat      nlibc_strcat
    #define strncat     nlibc_strncat
    #define strcmp      nlibc_strcmp
    #define strncmp     nlibc_strncmp
    #define strchr      nlibc_strchr
    #define strrchr     nlibc_strrchr
    #define strstr      nlibc_strstr

    /* FILE type and standard streams */
    #define stdin       nlibc_stdin
    #define stdout      nlibc_stdout
    #define stderr      nlibc_stderr
#endif /* NOESIS_LIBC_USE_STD_NAMES */

#endif /* NOESIS_NAMES_H */
