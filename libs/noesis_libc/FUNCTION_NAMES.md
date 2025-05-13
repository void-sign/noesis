# Noesis Short Function Names

This document outlines the short function name convention used in the Noesis project. Instead of using standard C library functions directly or prefixed functions like `nlibc_printf()`, we use short, intuitive function names.

## Why Short Names?

1. **Clarity**: Avoids confusion with standard C library functions
2. **Brevity**: Makes code more concise and readable
3. **Consistency**: Establishes a clear Noesis-specific API

## I/O Functions

| Short Name | Original Function | Description                                                    |
|------------|-------------------|---------------------------------------------------------------|
| out        | nlibc_printf      | Print formatted output to stdout                              |
| fout       | nlibc_fprintf     | Print formatted output to a file                              |
| sout       | nlibc_sprintf     | Print formatted output to a string                            |
| slen       | nlibc_snprintf    | Print formatted output to a string with size limit            |
| vout       | nlibc_vprintf     | Print formatted output using va_list                          |
| vfout      | nlibc_vfprintf    | Print formatted output to a file using va_list                |
| vsout      | nlibc_vsprintf    | Print formatted output to a string using va_list              |
| vslen      | nlibc_vsnprintf   | Print formatted output to a string with size limit using va_list |
| in         | nlibc_scanf       | Read formatted input from stdin                               |
| fin        | nlibc_fscanf      | Read formatted input from a file                              |
| scan       | nlibc_sscanf      | Read formatted input from a string                            |
| get        | nlibc_getchar     | Read a character from stdin                                   |
| fget       | nlibc_fgetc       | Read a character from a file                                  |
| put        | nlibc_putchar     | Write a character to stdout                                   |
| fput       | nlibc_fputc       | Write a character to a file                                   |
| gets       | nlibc_fgets       | Read a string from a file                                     |
| puts       | nlibc_fputs       | Write a string to a file                                      |
| write      | nlibc_puts        | Write a string to stdout                                      |
| unget      | nlibc_ungetc      | Push a character back to a stream                             |

## File Operations

| Short Name | Original Function | Description                                           |
|------------|-------------------|-------------------------------------------------------|
| load       | nlibc_fread       | Read data from a file                                 |
| save       | nlibc_fwrite      | Write data to a file                                  |
| jump       | nlibc_fseek       | Reposition the file position indicator                |
| pos        | nlibc_ftell       | Get the current file position                         |
| flush      | nlibc_fflush      | Flush a file stream                                   |
| eof        | nlibc_feof        | Check if end-of-file has been reached                 |
| err        | nlibc_ferror      | Check if a file error has occurred                    |
| clear      | nlibc_clearerr    | Clear file errors                                     |

## Memory Management

| Short Name | Original Function | Description                                           |
|------------|-------------------|-------------------------------------------------------|
| new        | nlibc_malloc      | Allocate memory                                       |
| zero       | nlibc_calloc      | Allocate and zero memory                              |
| grow       | nlibc_realloc     | Resize allocated memory                               |
| del        | nlibc_free        | Free allocated memory                                 |

## String Operations

| Short Name | Original Function | Description                                        |
|------------|-------------------|----------------------------------------------------|
| copy       | nlibc_strcpy      | Copy a string                                      |
| ncpy       | nlibc_strncpy     | Copy a string with size limit                      |
| cmp        | nlibc_strcmp      | Compare strings                                    |
| ncmp       | nlibc_strncmp     | Compare strings with size limit                    |
| len        | nlibc_strlen      | Get string length                                  |
| join       | nlibc_strcat      | Concatenate strings                                |
| njoin      | nlibc_strncat     | Concatenate strings with size limit                |
| find       | nlibc_strchr      | Find a character in a string                       |
| rfind      | nlibc_strrchr     | Find a character in a string, searching backwards  |
| seek       | nlibc_strstr      | Find a substring in a string                       |
| upper      | nlibc_toupper     | Convert a character to uppercase                   |
| lower      | nlibc_tolower     | Convert a character to lowercase                   |
| dup        | nlibc_strdup      | Duplicate a string                                 |
| trim       | nlibc_strtrim     | Remove whitespace from a string                    |

## Memory Operations

| Short Name | Original Function | Description                |
|------------|-------------------|----------------------------|
| mcpy       | nlibc_memcpy      | Copy memory                |
| move       | nlibc_memmove     | Move memory                |
| fill       | nlibc_memset      | Fill memory with a value   |
| mcmp       | nlibc_memcmp      | Compare memory             |

## Conversion Functions

| Short Name | Original Function | Description                 |
|------------|-------------------|-----------------------------|
| toint      | nlibc_atoi        | Convert string to integer   |
| tolong     | nlibc_atol        | Convert string to long      |
| tollong    | nlibc_atoll       | Convert string to long long |
| toflt      | nlibc_atof        | Convert string to double    |
| itostr     | nlibc_itoa        | Convert integer to string   |
| ltostr     | nlibc_ltoa        | Convert long to string      |
| lltostr    | nlibc_lltoa       | Convert long long to string |

## Math Operations

| Short Name | Original Function | Description                       |
|------------|-------------------|-----------------------------------|
| abs        | nlibc_abs         | Absolute value of an integer      |
| labs       | nlibc_labs        | Absolute value of a long          |
| llabs      | nlibc_llabs       | Absolute value of a long long     |
| div        | nlibc_div         | Integer division with remainder   |
| ldiv       | nlibc_ldiv        | Long division with remainder      |
| lldiv      | nlibc_lldiv       | Long long division with remainder |
| pow        | nlibc_pow         | Power function                    |
| sqrt       | nlibc_sqrt        | Square root                       |
| exp        | nlibc_exp         | Exponential function              |
| log        | nlibc_log         | Natural logarithm                 |
| log10      | nlibc_log10       | Base-10 logarithm                 |
| sin        | nlibc_sin         | Sine function                     |
| cos        | nlibc_cos         | Cosine function                   |
| tan        | nlibc_tan         | Tangent function                  |

## Misc Functions

| Short Name | Original Function      | Description                                   |
|------------|------------------------|-----------------------------------------------|
| rand       | nlibc_rand             | Generate a random number                      |
| srand      | nlibc_srand            | Seed the random number generator              |
| sort       | nlibc_qsort            | Sort an array                                 |
| search     | nlibc_bsearch          | Binary search an array                        |
| exit       | nlibc_exit             | Exit the program                              |
| halt       | nlibc_abort            | Abnormal program termination                  |
| onexit     | nlibc_atexit           | Register a function to be called at exit      |
| qexit      | nlibc_at_quick_exit    | Register a function to be called at quick_exit |
| getenv     | nlibc_getenv           | Get environment variable                      |
| setenv     | nlibc_setenv           | Set environment variable                      |
| unenv      | nlibc_unsetenv         | Unset environment variable                    |
| putenv     | nlibc_putenv           | Set environment variable from string          |
| sys        | nlibc_system           | Execute a shell command                       |
| now        | nlibc_time             | Get current time                              |
| clock      | nlibc_clock            | Get processor time                            |
| diff       | nlibc_difftime         | Calculate time difference                     |
| sleep      | nlibc_sleep            | Suspend execution for a time                  |

## Standard Streams

| Short Name | Original Function | Description            |
|------------|-------------------|------------------------|
| instr      | nlibc_stdin       | Standard input stream  |
| outstr     | nlibc_stdout      | Standard output stream |
| errstr     | nlibc_stderr      | Standard error stream  |

## Usage Example

Instead of:
```c
FILE* file = fopen("example.txt", "r");
if (!file) {
    fprintf(stderr, "Error opening file\n");
    return;
}
char buffer[100];
fread(buffer, 1, sizeof(buffer), file);
printf("Content: %s\n", buffer);
fclose(file);
```

Use this:
```c
FILE* file = open("example.txt", "r");
if (!file) {
    fout(errstr, "Error opening file\n");
    return;
}
char buffer[100];
load(buffer, 1, sizeof(buffer), file);
out("Content: %s\n", buffer);
close(file);
```
