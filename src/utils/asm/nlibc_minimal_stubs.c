/*
 * nlibc_minimal_stubs.c
 * Minimal implementations of nlibc functions needed for linking
 * These don't actually use external libc functions but provide enough to compile
 */

/* File operations */
typedef struct FILE FILE;
/* Use assembly-style symbol name with leading underscore */
#ifndef __APPLE__
FILE* _nlibc_stderr = (void*)0;
#else
/* On macOS/Apple platforms, symbols have an underscore prefix */
FILE* nlibc_stderr = (void*)0; /* This will become _nlibc_stderr after compilation */
#endif
FILE* nlibc_stdin = (void*)0;
FILE* nlibc_stdout = (void*)0;

/* Stub implementations with minimal functionality */
FILE* nlibc_fopen(const char* pathname, const char* mode) { 
    (void)pathname; (void)mode;
    return (void*)0;
}

int nlibc_fclose(FILE* stream) {
    (void)stream;
    return 0;
}

int nlibc_fprintf(FILE* stream, const char* format, ...) {
    (void)stream; (void)format;
    return 0;
}

char* nlibc_fgets(char* s, int size, FILE* stream) {
    (void)size; (void)stream;
    if (s) s[0] = 0;
    return s;
}

int nlibc_printf(const char* format, ...) {
    (void)format;
    return 0;
}

/* Memory operations */
void* nlibc_malloc(unsigned long size) {
    (void)size;
    return (void*)0;
}

void nlibc_free(void* ptr) {
    (void)ptr;
}

/* String operations */
int nlibc_strcmp(const char* s1, const char* s2) {
    if (!s1 || !s2) return s1 ? 1 : (s2 ? -1 : 0);
    
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(unsigned char*)s1 - *(unsigned char*)s2;
}

unsigned long nlibc_strlen(const char* s) {
    if (!s) return 0;
    
    unsigned long len = 0;
    while (s[len]) len++;
    return len;
}
