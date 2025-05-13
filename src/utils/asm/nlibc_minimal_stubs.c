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

/* String operations */
char* nlibc_strchr(const char* s, int c) {
    (void)s; (void)c;
    return (void*)0;
}

size_t nlibc_strlen(const char* s) {
    (void)s;
    return 0;
}

int nlibc_strcmp(const char* s1, const char* s2) {
    (void)s1; (void)s2;
    return 0;
}

/* Memory operations */
void* nlibc_malloc(size_t size) {
    (void)size;
    return (void*)0;
}

void nlibc_free(void* ptr) {
    (void)ptr;
}

/* File I/O stubs */
size_t nlibc_fread(void* ptr, size_t size, size_t nmemb, FILE* stream) {
    (void)ptr; (void)size; (void)nmemb; (void)stream;
    return 0;
}

size_t nlibc_fwrite(const void* ptr, size_t size, size_t nmemb, FILE* stream) {
    (void)ptr; (void)size; (void)nmemb; (void)stream;
    return 0;
}

/* Error handling stubs */
int nlibc_ferror(FILE* stream) {
    (void)stream;
    return 0;
}

int nlibc_feof(FILE* stream) {
    (void)stream;
    return 0;
}

void nlibc_clearerr(FILE* stream) {
    (void)stream;
}

/* Other common stubs that might be needed */
int nlibc_printf(const char* format, ...) {
    (void)format;
    return 0;
}

int nlibc_sprintf(char* str, const char* format, ...) {
    (void)str; (void)format;
    return 0;
}

int nlibc_snprintf(char* str, size_t size, const char* format, ...) {
    (void)str; (void)size; (void)format;
    return 0;
}

/* Character I/O stubs */
int nlibc_fgetc(FILE* stream) {
    (void)stream;
    return -1; /* Return EOF */
}

int nlibc_fputc(int c, FILE* stream) {
    (void)c; (void)stream;
    return 0;
}

/* File positioning stubs */
int nlibc_fseek(FILE* stream, long offset, int whence) {
    (void)stream; (void)offset; (void)whence;
    return 0;
}

long nlibc_ftell(FILE* stream) {
    (void)stream;
    return 0;
}

void nlibc_rewind(FILE* stream) {
    (void)stream;
}
