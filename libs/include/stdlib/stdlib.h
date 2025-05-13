#ifndef NOESIS_STDLIB_H
#define NOESIS_STDLIB_H

#include "../noesis_types.h"

/* 
 * Division structures are now defined in noesis_types.h
 * No need to redefine them here
 */

/* First declare the implementation functions */
div_t nlibc_div(int numer, int denom);
ldiv_t nlibc_ldiv(long numer, long denom);
lldiv_t nlibc_lldiv(long long numer, long long denom);

/* Then create the standard C aliases using macros */
#define div nlibc_div
#define ldiv nlibc_ldiv
#define lldiv nlibc_lldiv

/* Memory allocation constants */
#ifndef NULL
#define NULL ((void *)0)
#endif

/* Maximum size_t value */
#ifndef SIZE_MAX
#define SIZE_MAX ((size_t)-1)
#endif

/* Function prototypes */
void *malloc(size_t size);
void free(void *ptr);
void *realloc(void *ptr, size_t size);
void *calloc(size_t nmemb, size_t size);

int atoi(const char *str);
long atol(const char *str);
long long atoll(const char *str);
double atof(const char *str);

/* Standard C division functions that map to our implementations */

int abs(int n);
long labs(long n);
long long llabs(long long n);

int rand(void);
void srand(unsigned int seed);

void qsort(void *base, size_t nmemb, size_t size,
           int (*compar)(const void *, const void *));

void *bsearch(const void *key, const void *base,
              size_t nmemb, size_t size,
              int (*compar)(const void *, const void *));

void exit(int status);
void abort(void);
int atexit(void (*func)(void));
int at_quick_exit(void (*func)(void));
void quick_exit(int status);

char *getenv(const char *name);
int setenv(const char *name, const char *value, int overwrite);
int unsetenv(const char *name);
int putenv(char *string);

/* Integer to string conversion functions with explicit implementations */
char *nlibc_itoa(int value, char *str, int base);
char *nlibc_ltoa(long value, char *str, int base);
char *nlibc_lltoa(long long value, char *str, int base);

/* Define standard aliases using macros */
#define itoa nlibc_itoa
#define ltoa nlibc_ltoa
#define lltoa nlibc_lltoa

/* Execute a shell command */
int system(const char *command);

/* Maximum value returned by the rand function */
#define RAND_MAX 32767

/* Constants for exit status */
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

#endif /* NOESIS_STDLIB_H */
