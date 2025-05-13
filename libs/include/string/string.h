#ifndef NOESIS_STRING_H
#define NOESIS_STRING_H

#include "../noesis_types.h"

/* String manipulation functions */
char* nlibc_strcpy(char* dest, const char* src);
char* nlibc_strncpy(char* dest, const char* src, size_t n);
char* nlibc_strcat(char* dest, const char* src);
char* nlibc_strncat(char* dest, const char* src, size_t n);

/* String examination functions */
size_t nlibc_strlen(const char* s);
int nlibc_strcmp(const char* s1, const char* s2);
int nlibc_strncmp(const char* s1, const char* s2, size_t n);
char* nlibc_strchr(const char* s, int c);
char* nlibc_strrchr(const char* s, int c);
char* nlibc_strstr(const char* haystack, const char* needle);
char* nlibc_strtok(char* str, const char* delim);

/* Memory manipulation functions */
void* nlibc_memcpy(void* dest, const void* src, size_t n);
void* nlibc_memmove(void* dest, const void* src, size_t n);
int nlibc_memcmp(const void* s1, const void* s2, size_t n);
void* nlibc_memset(void* s, int c, size_t n);
void* nlibc_memchr(const void* s, int c, size_t n);

/* Error handling */
char* nlibc_strerror(int errnum);

/* Utility functions */
size_t nlibc_strspn(const char* s, const char* accept);
size_t nlibc_strcspn(const char* s, const char* reject);
char* nlibc_strpbrk(const char* s, const char* accept);
char* nlibc_strdup(const char* s);
char* nlibc_strndup(const char* s, size_t n);

#endif /* NOESIS_STRING_H */
