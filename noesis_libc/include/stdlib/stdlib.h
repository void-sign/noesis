#ifndef NOESIS_STDLIB_H
#define NOESIS_STDLIB_H

#include "../noesis_types.h"

/* Memory allocation functions */
void* nlibc_malloc(size_t size);
void nlibc_free(void* ptr);
void* nlibc_calloc(size_t nmemb, size_t size);
void* nlibc_realloc(void* ptr, size_t size);
void* nlibc_aligned_alloc(size_t alignment, size_t size);

/* Conversion functions */
int nlibc_atoi(const char* nptr);
long nlibc_atol(const char* nptr);
long long nlibc_atoll(const char* nptr);
double nlibc_atof(const char* nptr);
long nlibc_strtol(const char* nptr, char** endptr, int base);
unsigned long nlibc_strtoul(const char* nptr, char** endptr, int base);
long long nlibc_strtoll(const char* nptr, char** endptr, int base);
unsigned long long nlibc_strtoull(const char* nptr, char** endptr, int base);
double nlibc_strtod(const char* nptr, char** endptr);

/* Random number generation */
int nlibc_rand(void);
void nlibc_srand(unsigned int seed);

/* Algorithm functions */
void nlibc_qsort(void* base, size_t nmemb, size_t size, int (*compar)(const void*, const void*));
void* nlibc_bsearch(const void* key, const void* base, size_t nmemb, size_t size, int (*compar)(const void*, const void*));

/* Environment functions */
int nlibc_atexit(void (*func)(void));
void nlibc_exit(int status);
void nlibc_abort(void);
char* nlibc_getenv(const char* name);
int nlibc_system(const char* command);

/* Types for div functions */
typedef struct {
    int quot;
    int rem;
} div_t;

typedef struct {
    long quot;
    long rem;
} ldiv_t;

typedef struct {
    long long quot;
    long long rem;
} lldiv_t;

/* Integer arithmetic */
int nlibc_abs(int j);
long nlibc_labs(long j);
long long nlibc_llabs(long long j);
div_t nlibc_div(int numer, int denom);
ldiv_t nlibc_ldiv(long numer, long denom);
lldiv_t nlibc_lldiv(long long numer, long long denom);

#endif /* NOESIS_STDLIB_H */
