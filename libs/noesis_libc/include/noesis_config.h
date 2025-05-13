#ifndef NOESIS_CONFIG_H
#define NOESIS_CONFIG_H

/* Configuration flags for Noesis libc */

/* Define to use the system's standard library instead of Noesis libc */
/* #define USE_SYSTEM_LIBC */

/* When building Noesis itself, we may need to include some system headers */
#ifdef NOESIS_BUILDING_LIB
#define USE_SYSTEM_LIBC_SELECTIVELY
#endif

/* Helper macros for conditional system header inclusion */
#if defined(USE_SYSTEM_LIBC) || defined(USE_SYSTEM_LIBC_SELECTIVELY)
#define CAN_USE_SYSTEM_HEADERS 1
#else
#define CAN_USE_SYSTEM_HEADERS 0
#endif

#endif /* NOESIS_CONFIG_H */
