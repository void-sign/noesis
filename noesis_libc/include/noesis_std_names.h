/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#ifndef NOESIS_STD_NAMES_H
#define NOESIS_STD_NAMES_H

/* This file defines macros to map Noesis libc function names to standard C library names */

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

    /* stdlib.h functions */
    #define malloc      nlibc_malloc
    #define calloc      nlibc_calloc
    #define realloc     nlibc_realloc
    #define free        nlibc_free
    #define exit        nlibc_exit
    #define abort       nlibc_abort
    #define atoi        nlibc_atoi
    #define atol        nlibc_atol
    #define atoll       nlibc_atoll

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

    /* FILE type and standard streams */
    #define stdin       nlibc_stdin
    #define stdout      nlibc_stdout
    #define stderr      nlibc_stderr
#endif /* NOESIS_LIBC_USE_STD_NAMES */

#endif /* NOESIS_STD_NAMES_H */
