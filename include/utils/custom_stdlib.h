// custom_stdlib.h - Header for custom standard library functions

#ifndef CUSTOM_STDLIB_H
#define CUSTOM_STDLIB_H

// Function prototypes for custom standard library functions
int noesis_scmp(const char* s1, const char* s2);
char* noesis_sdup(const char* s);
void noesis_printf(const char* format, ...);
void* noesis_malloc(unsigned long size);
void noesis_free(void* ptr);

#endif // CUSTOM_STDLIB_H
