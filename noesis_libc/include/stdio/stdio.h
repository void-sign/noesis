#ifndef NOESIS_STDIO_H
#define NOESIS_STDIO_H

#include "../noesis_types.h"

/* File operations */
typedef struct _FILE FILE;
extern FILE* nlibc_stdin;
extern FILE* nlibc_stdout;
extern FILE* nlibc_stderr;

/* Definition of FILE structure */
struct _FILE {
    int fd;          /* File descriptor */
    int flags;       /* File status flags */
    int error;       /* Error indicator */
    int eof;         /* End-of-file indicator */
    char* buffer;    /* Buffer for I/O */
    size_t buf_size; /* Size of the buffer */
    size_t buf_pos;  /* Current position in the buffer */
    size_t buf_end;  /* End of the buffer */
    int buf_mode;    /* Buffering mode (_IOFBF, _IOLBF, _IONBF) */
};

/* File status flags */
#define _FILE_FLAG_READ  0x01
#define _FILE_FLAG_WRITE 0x02
#define _FILE_FLAG_OPEN  0x04

/* File manipulation functions */
FILE* nlibc_fopen(const char* pathname, const char* mode);
int nlibc_fclose(FILE* stream);
size_t nlibc_fread(void* ptr, size_t size, size_t nmemb, FILE* stream);
size_t nlibc_fwrite(const void* ptr, size_t size, size_t nmemb, FILE* stream);
int nlibc_fseek(FILE* stream, long offset, int whence);
long nlibc_ftell(FILE* stream);
void nlibc_rewind(FILE* stream);
int nlibc_fflush(FILE* stream);
int nlibc_feof(FILE* stream);
int nlibc_ferror(FILE* stream);
void nlibc_clearerr(FILE* stream);

/* Formatted input/output functions */
int nlibc_printf(const char* format, ...);
int nlibc_fprintf(FILE* stream, const char* format, ...);
int nlibc_sprintf(char* str, const char* format, ...);
int nlibc_snprintf(char* str, size_t size, const char* format, ...);
int nlibc_vprintf(const char* format, va_list ap);
int nlibc_vfprintf(FILE* stream, const char* format, va_list ap);
int nlibc_vsprintf(char* str, const char* format, va_list ap);
int nlibc_vsnprintf(char* str, size_t size, const char* format, va_list ap);

int nlibc_scanf(const char* format, ...);
int nlibc_fscanf(FILE* stream, const char* format, ...);
int nlibc_sscanf(const char* str, const char* format, ...);

/* Character input/output functions */
int nlibc_fgetc(FILE* stream);
int nlibc_getc(FILE* stream);
int nlibc_getchar(void);
int nlibc_fputc(int c, FILE* stream);
int nlibc_putc(int c, FILE* stream);
int nlibc_putchar(int c);
char* nlibc_fgets(char* s, int size, FILE* stream);
int nlibc_fputs(const char* s, FILE* stream);
int nlibc_puts(const char* s);
int nlibc_ungetc(int c, FILE* stream);

/* Direct input/output functions */
size_t nlibc_fread(void* ptr, size_t size, size_t nmemb, FILE* stream);
size_t nlibc_fwrite(const void* ptr, size_t size, size_t nmemb, FILE* stream);

/* File positioning functions */
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

/* End-of-file and error indicators */
#define EOF (-1)

/* Buffer handling */
#define _IOFBF 0
#define _IOLBF 1
#define _IONBF 2
int nlibc_setvbuf(FILE* stream, char* buf, int mode, size_t size);
void nlibc_setbuf(FILE* stream, char* buf);

/* Misc functions */
int nlibc_remove(const char* pathname);
int nlibc_rename(const char* oldname, const char* newname);
FILE* nlibc_tmpfile(void);
char* nlibc_tmpnam(char* s);
int nlibc_fileno(FILE* stream);

#endif /* NOESIS_STDIO_H */
