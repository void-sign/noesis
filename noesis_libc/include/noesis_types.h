#ifndef NOESIS_TYPES_H
#define NOESIS_TYPES_H

/* Basic type definitions for our libc */

/* Primitive types */
#ifndef _INT8_T
#define _INT8_T
typedef signed char         int8_t;
#endif

#ifndef _UINT8_T
#define _UINT8_T
typedef unsigned char       uint8_t;
#endif

#ifndef _INT16_T
#define _INT16_T
typedef signed short        int16_t;
#endif

#ifndef _UINT16_T
#define _UINT16_T
typedef unsigned short      uint16_t;
#endif

#ifndef _INT32_T
#define _INT32_T
typedef signed int          int32_t;
#endif

#ifndef _UINT32_T
#define _UINT32_T
typedef unsigned int        uint32_t;
#endif

#ifndef _INT64_T
#define _INT64_T
typedef signed long long    int64_t;
#endif

#ifndef _UINT64_T
#define _UINT64_T
typedef unsigned long long  uint64_t;
#endif

/* Size type */
#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned long       size_t;
#endif

#ifndef _SSIZE_T
#define _SSIZE_T
typedef signed long         ssize_t;
#endif

#ifndef _PTRDIFF_T
#define _PTRDIFF_T
typedef long                ptrdiff_t;
#endif

/* Time type */
#ifndef __DEFINED_time_t
#ifndef __time_t_defined
typedef long                time_t;
#define __time_t_defined
#endif
typedef long                suseconds_t; /* Time in microseconds */
typedef int                 clockid_t;  /* Clock ID */
typedef unsigned int        useconds_t; /* Microseconds */
#define __DEFINED_time_t
#endif

/* Null pointer */
#ifndef NULL
#define NULL ((void*)0)
#endif

/* Boolean type */
#ifndef __DEFINED_bool
typedef int                 bool;
#define true                1
#define false               0
#define __DEFINED_bool
#endif

/* Maximum values */
#ifndef INT8_MAX
#define INT8_MAX            127
#define INT8_MIN            (-128)
#define UINT8_MAX           255
#define INT16_MAX           32767
#define INT16_MIN           (-32768)
#define UINT16_MAX          65535
#define INT32_MAX           2147483647
#define INT32_MIN           (-2147483648)
#define UINT32_MAX          4294967295U
#define INT64_MAX           9223372036854775807LL
#define INT64_MIN           (-INT64_MAX - 1LL)
#define UINT64_MAX          18446744073709551615ULL
#define SIZE_MAX            UINT64_MAX
#endif

/* Variable arguments */
#ifndef _VA_LIST
typedef __builtin_va_list   va_list;
#define _VA_LIST
#endif

#ifndef va_start
#define va_start(v,l)       __builtin_va_start(v,l)
#define va_end(v)           __builtin_va_end(v)
#define va_arg(v,l)         __builtin_va_arg(v,l)
#ifdef __GNUC__
#define va_copy(d,s)        __builtin_va_copy(d,s)
#else
#define va_copy(d,s)        ((d) = (s))
#endif
#endif

/* Unix-specific types - conditionally define if not already defined */

#if !defined(_PID_T) && !defined(__DEFINED_pid_t)
#define _PID_T
typedef int                 pid_t;      /* Process ID */
#define __DEFINED_pid_t
#endif

#if !defined(_UID_T) && !defined(__DEFINED_uid_t)
#define _UID_T
typedef int                 uid_t;      /* User ID */
#define __DEFINED_uid_t
#endif

#if !defined(_GID_T) && !defined(__DEFINED_gid_t)
#define _GID_T
typedef int                 gid_t;      /* Group ID */
#define __DEFINED_gid_t
#endif

#if !defined(_ID_T) && !defined(__DEFINED_id_t)
#define _ID_T
typedef int                 id_t;       /* General identifier */
#define __DEFINED_id_t
#endif

#if !defined(_OFF_T) && !defined(__DEFINED_off_t)
#define _OFF_T
typedef long                off_t;      /* File offset */
#define __DEFINED_off_t
#endif

#if !defined(_MODE_T) && !defined(__DEFINED_mode_t)
#define _MODE_T
typedef int                 mode_t;     /* File mode */
#define __DEFINED_mode_t
#endif

#if !defined(_DEV_T) && !defined(__DEFINED_dev_t)
#define _DEV_T
typedef int                 dev_t;      /* Device ID */
#define __DEFINED_dev_t
#endif

#if !defined(_INO_T) && !defined(__DEFINED_ino_t)
#define _INO_T
typedef unsigned long       ino_t;      /* Inode number */
#define __DEFINED_ino_t
#endif

#if !defined(_NLINK_T) && !defined(__DEFINED_nlink_t)
#define _NLINK_T
typedef unsigned int        nlink_t;    /* Link count */
#define __DEFINED_nlink_t
#endif

#if !defined(_BLKSIZE_T) && !defined(__DEFINED_blksize_t)
#define _BLKSIZE_T
typedef long                blksize_t;  /* Block size */
#define __DEFINED_blksize_t
#endif

#if !defined(_BLKCNT_T) && !defined(__DEFINED_blkcnt_t)
#define _BLKCNT_T
typedef long                blkcnt_t;   /* Block count */
#define __DEFINED_blkcnt_t
#endif

#if !defined(_FSBLKCNT_T) && !defined(__DEFINED_fsblkcnt_t)
#define _FSBLKCNT_T
typedef unsigned long       fsblkcnt_t; /* File system block count */
#define __DEFINED_fsblkcnt_t
#endif

#if !defined(_FSFILCNT_T) && !defined(__DEFINED_fsfilcnt_t)
#define _FSFILCNT_T
typedef unsigned long       fsfilcnt_t; /* File system file count */
#define __DEFINED_fsfilcnt_t
#endif

#if !defined(_KEY_T) && !defined(__DEFINED_key_t)
#define _KEY_T
typedef int                 key_t;      /* IPC key */
#define __DEFINED_key_t
#endif

/* Standard library division structure types */
#ifndef __DEFINED_div_t
struct div_t {
    int quot; /* Quotient */
    int rem;  /* Remainder */
};
typedef struct div_t div_t;
#define __DEFINED_div_t
#endif

#ifndef __DEFINED_ldiv_t
struct ldiv_t {
    long quot; /* Quotient */
    long rem;  /* Remainder */
};
typedef struct ldiv_t ldiv_t;
#define __DEFINED_ldiv_t
#endif

#ifndef __DEFINED_lldiv_t
struct lldiv_t {
    long long quot; /* Quotient */
    long long rem;  /* Remainder */
};
typedef struct lldiv_t lldiv_t;
#define __DEFINED_lldiv_t
#endif

/* This marker helps external code know our stdlib structures are defined */
#define NOESIS_STDLIB_TYPES_DEFINED

#endif /* NOESIS_TYPES_H */
