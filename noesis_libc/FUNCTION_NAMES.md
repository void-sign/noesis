# Noesis Short Function Names

This document outlines the short function name convention used in the Noesis project. Instead of using standard C library functions directly or prefixed functions like `nlibc_printf()`, we use short, intuitive function names.

## Why Short Names?

1. **Clarity**: Avoids confusion with standard C library functions
2. **Brevity**: Makes code more concise and readable
3. **Consistency**: Establishes a clear Noesis-specific API

## Function Name Mapping

### I/O Functions
| Standard C | Noesis Short |
|------------|--------------|
| printf     | out          |
| fprintf    | fout         |
| sprintf    | sout         |
| snprintf   | slen         |
| scanf      | in           |
| fscanf     | fin          |
| sscanf     | scan         |
| getchar    | get          |
| putchar    | put          |

### File Operations
| Standard C | Noesis Short |
|------------|--------------|
| fopen      | open         |
| fclose     | close        |
| fread      | load         |
| fwrite     | save         |
| fseek      | jump         |
| ftell      | pos          |

### Memory Management
| Standard C | Noesis Short |
|------------|--------------|
| malloc     | new          |
| calloc     | zero         |
| realloc    | grow         |
| free       | del          |

### String Operations
| Standard C | Noesis Short |
|------------|--------------|
| strcpy     | copy         |
| strncpy    | ncpy         |
| strcmp     | cmp          |
| strlen     | len          |
| strcat     | join         |
| strchr     | find         |
| strstr     | seek         |

### Memory Operations
| Standard C | Noesis Short |
|------------|--------------|
| memcpy     | mcpy         |
| memmove    | move         |
| memset     | fill         |
| memcmp     | mcmp         |

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
    fout(stderr, "Error opening file\n");
    return;
}
char buffer[100];
load(buffer, 1, sizeof(buffer), file);
out("Content: %s\n", buffer);
close(file);
```
