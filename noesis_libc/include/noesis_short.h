/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

#ifndef NOESIS_SHORT_H
#define NOESIS_SHORT_H

/* This file defines short aliases for Noesis libc functions */

/* I/O Functions */
#define out     nlibc_printf
#define fout    nlibc_fprintf
#define sout    nlibc_sprintf
#define slen    nlibc_snprintf
#define in      nlibc_scanf
#define fin     nlibc_fscanf
#define scan    nlibc_sscanf
#define get     nlibc_getchar
#define put     nlibc_putchar

/* File Operations */
#define open    nlibc_fopen
#define close   nlibc_fclose
#define load    nlibc_fread
#define save    nlibc_fwrite
#define jump    nlibc_fseek
#define pos     nlibc_ftell

/* Memory Management */
#define new     nlibc_malloc
#define zero    nlibc_calloc
#define grow    nlibc_realloc
#define del     nlibc_free

/* String Operations */
#define copy    nlibc_strcpy
#define ncpy    nlibc_strncpy
#define cmp     nlibc_strcmp
#define len     nlibc_strlen
#define join    nlibc_strcat
#define find    nlibc_strchr
#define seek    nlibc_strstr

/* Memory Operations */
#define mcpy    nlibc_memcpy
#define move    nlibc_memmove
#define fill    nlibc_memset
#define mcmp    nlibc_memcmp

#endif /* NOESIS_SHORT_H */
