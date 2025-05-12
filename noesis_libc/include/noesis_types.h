#ifndef NOESIS_TYPES_H
#define NOESIS_TYPES_H

/* Basic type definitions for our libc */

/* Primitive types */
typedef signed char         int8_t;
typedef unsigned char       uint8_t;
typedef signed short        int16_t;
typedef unsigned short      uint16_t;
typedef signed int          int32_t;
typedef unsigned int        uint32_t;
typedef signed long long    int64_t;
typedef unsigned long long  uint64_t;

/* Size type */
typedef unsigned long       size_t;
typedef signed long         ssize_t;
typedef long                ptrdiff_t;

/* Time type */
typedef long                time_t;

/* Null pointer */
#ifndef NULL
#define NULL ((void*)0)
#endif

/* Boolean type */
typedef int                 bool;
#define true                1
#define false               0

/* Maximum values */
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
#define INT64_MIN           (-9223372036854775807LL - 1)
#define UINT64_MAX          18446744073709551615ULL
#define SIZE_MAX            UINT64_MAX

/* Variable arguments */
typedef __builtin_va_list   va_list;
#define va_start(v,l)       __builtin_va_start(v,l)
#define va_end(v)           __builtin_va_end(v)
#define va_arg(v,l)         __builtin_va_arg(v,l)
#define va_copy(d,s)        __builtin_va_copy(d,s)

/* Unix-specific types */
typedef int                 pid_t;      /* Process ID */
typedef int                 uid_t;      /* User ID */
typedef int                 gid_t;      /* Group ID */
typedef long                off_t;      /* File offset */
typedef int                 mode_t;     /* File mode */
typedef int                 dev_t;      /* Device ID */
typedef unsigned long       ino_t;      /* Inode number */
typedef unsigned int        nlink_t;    /* Link count */
typedef long                blksize_t;  /* Block size */
typedef long                blkcnt_t;   /* Block count */
typedef long                time_t;     /* Time in seconds */
typedef long                suseconds_t; /* Time in microseconds */
typedef int                 clockid_t;  /* Clock ID */
typedef unsigned int        useconds_t; /* Microseconds */

#endif /* NOESIS_TYPES_H */
