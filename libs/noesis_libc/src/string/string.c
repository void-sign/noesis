/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/string/string.h"

/* Temporary system call wrappers for memory allocation */
static void* temp_malloc(size_t size) {
    void* ptr;

    /* Use mmap directly to allocate memory */
    __asm__ volatile (
        "movq $0x20000c5, %%rax\n"  /* mmap syscall for macOS */
        "movq $0, %%rdi\n"          /* addr = NULL */
        "movq %1, %%rsi\n"          /* length = size */
        "movl $3, %%edx\n"          /* prot = PROT_READ | PROT_WRITE */
        "movl $0x1002, %%r10d\n"    /* flags = MAP_PRIVATE | MAP_ANON */
        "movq $-1, %%r8\n"          /* fd = -1 */
        "movq $0, %%r9\n"           /* offset = 0 */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (ptr)
        : "r" (size)
        : "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9"
    );

    /* Check for errors */
    if (ptr == (void*)-1) {
        return NULL;
    }

    return ptr;
}

/* Calculate the length of a string */
size_t nlibc_strlen(const char* s) {
    const char* start = s;
    while (*s) {
        s++;
    }
    return (size_t)(s - start);
}

/* Copy a string */
char* nlibc_strcpy(char* dest, const char* src) {
    char* original_dest = dest;
    while ((*dest++ = *src++)) {
        /* Loop continues until null terminator is copied */
    }
    return original_dest;
}

/* Copy at most n characters of a string */
char* nlibc_strncpy(char* dest, const char* src, size_t n) {
    char* original_dest = dest;
    size_t i;
    
    /* Copy up to n characters from src to dest */
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    
    /* Pad with null characters if necessary */
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    
    return original_dest;
}

/* Concatenate two strings */
char* nlibc_strcat(char* dest, const char* src) {
    char* original_dest = dest;
    
    /* Find end of dest */
    while (*dest) {
        dest++;
    }
    
    /* Copy src to the end of dest */
    while ((*dest++ = *src++)) {
        /* Loop continues until null terminator is copied */
    }
    
    return original_dest;
}

/* Concatenate at most n characters of src onto dest */
char* nlibc_strncat(char* dest, const char* src, size_t n) {
    char* original_dest = dest;
    size_t dest_len, i;
    
    /* Find end of dest */
    dest_len = 0;
    while (dest[dest_len]) {
        dest_len++;
    }
    
    /* Copy at most n characters from src */
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[dest_len + i] = src[i];
    }
    
    /* Null-terminate the result */
    dest[dest_len + i] = '\0';
    
    return original_dest;
}

/* Compare two strings */
int nlibc_strcmp(const char* s1, const char* s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

/* Compare at most n characters of two strings */
int nlibc_strncmp(const char* s1, const char* s2, size_t n) {
    if (n == 0) {
        return 0;
    }
    
    while (n-- > 0 && *s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

/* Find the first occurrence of character c in string s */
char* nlibc_strchr(const char* s, int c) {
    while (*s) {
        if (*s == (char)c) {
            return (char*)s;
        }
        s++;
    }
    
    /* Also check the null terminator */
    if ((char)c == '\0') {
        return (char*)s;
    }
    
    return NULL;
}

/* Find the last occurrence of character c in string s */
char* nlibc_strrchr(const char* s, int c) {
    const char* last = NULL;
    
    /* Loop through string, looking for character */
    while (*s) {
        if (*s == (char)c) {
            last = s;
        }
        s++;
    }
    
    /* Also check the null terminator */
    if ((char)c == '\0') {
        return (char*)s;
    }
    
    return (char*)last;
}

/* Find the first occurrence of the substring needle in haystack */
char* nlibc_strstr(const char* haystack, const char* needle) {
    size_t needle_len = nlibc_strlen(needle);
    
    /* Empty needle always matches */
    if (needle_len == 0) {
        return (char*)haystack;
    }
    
    /* Loop through haystack, comparing substrings */
    while (*haystack) {
        if (*haystack == *needle && nlibc_strncmp(haystack, needle, needle_len) == 0) {
            return (char*)haystack;
        }
        haystack++;
    }
    
    return NULL;
}

/* Copy memory area */
void* nlibc_memcpy(void* dest, const void* src, size_t n) {
    unsigned char* d = (unsigned char*)dest;
    const unsigned char* s = (const unsigned char*)src;
    size_t i;
    
    /* Simple byte-by-byte copy */
    for (i = 0; i < n; i++) {
        d[i] = s[i];
    }
    
    return dest;
}

/* Copy memory area, even if the areas overlap */
void* nlibc_memmove(void* dest, const void* src, size_t n) {
    unsigned char* d = (unsigned char*)dest;
    const unsigned char* s = (const unsigned char*)src;
    
    /* Check for overlapping memory regions */
    if (d < s) {
        /* Copy from beginning to end (forward) */
        size_t i;
        for (i = 0; i < n; i++) {
            d[i] = s[i];
        }
    } else if (d > s) {
        /* Copy from end to beginning (backward) */
        while (n--) {
            d[n] = s[n];
        }
    }
    
    return dest;
}

/* Compare memory areas */
int nlibc_memcmp(const void* s1, const void* s2, size_t n) {
    const unsigned char* p1 = (const unsigned char*)s1;
    const unsigned char* p2 = (const unsigned char*)s2;
    
    while (n-- > 0) {
        if (*p1 != *p2) {
            return *p1 - *p2;
        }
        p1++;
        p2++;
    }
    
    return 0;
}

/* Fill memory with a constant byte */
void* nlibc_memset(void* s, int c, size_t n) {
    unsigned char* p = (unsigned char*)s;
    
    while (n-- > 0) {
        *p++ = (unsigned char)c;
    }
    
    return s;
}

/* Duplicate a string */
char* nlibc_strdup(const char* s) {
    size_t len = nlibc_strlen(s) + 1;  /* +1 for null terminator */
    char* new_str = (char*)temp_malloc(len);  /* Use temporary malloc */
    
    if (new_str) {
        nlibc_memcpy(new_str, s, len);
    }
    
    return new_str;
}

/* Duplicate at most n bytes of a string */
char* nlibc_strndup(const char* s, size_t n) {
    size_t len = 0;
    
    /* Calculate string length, but not more than n */
    while (len < n && s[len]) {
        len++;
    }
    
    /* Allocate memory for the duplicate */
    char* new_str = (char*)temp_malloc(len + 1);  /* Use temporary malloc */
    
    if (new_str) {
        nlibc_memcpy(new_str, s, len);
        new_str[len] = '\0';  /* Ensure null termination */
    }
    
    return new_str;
}
