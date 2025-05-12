# Noesis Custom libc (nlibc)

This is a custom C standard library implementation for the Noesis project. It provides a lightweight, platform-specific implementation of the standard C library functions without relying on Apple's libc.

## Features

- Namespace-isolated with `nlibc_` prefix on all functions
- Implements core functionality from:
  - `<stdlib.h>`: Memory allocation, conversions, etc.
  - `<stdio.h>`: I/O operations
  - `<string.h>`: String manipulation
  - `<math.h>`: Mathematical functions
  - `<unistd.h>`: POSIX system calls
  - `<sys/*>`: System-specific operations

## Directory Structure

```
noesis_libc/
  ├── include/        # Header files
  │   ├── noesis_types.h
  │   ├── noesis_libc.h  # Main include file
  │   ├── stdlib/
  │   ├── stdio/
  │   ├── string/
  │   ├── math/
  │   ├── unistd/
  │   └── sys/
  ├── src/            # Implementation files
  │   ├── stdlib/
  │   ├── stdio/
  │   ├── string/
  │   ├── math/
  │   ├── unistd/
  │   └── sys/
  ├── lib/            # Built libraries
  │   ├── libnlibc.a  # Static library
  │   └── libnlibc.so # Shared library
  └── obj/            # Object files
```

## Building

To build the library:

```bash
make
```

This will create both static and shared libraries in the `lib/` directory.

## Usage

### Including Headers

You can include individual headers:

```c
#include <noesis_libc/stdio/stdio.h>
#include <noesis_libc/stdlib/stdlib.h>
```

Or include the main header for all functionality:

```c
#include <noesis_libc/noesis_libc.h>
```

### Using Functions

All functions are prefixed with `nlibc_` to avoid conflicts with the system libc:

```c
void* ptr = nlibc_malloc(100);
nlibc_printf("Hello, %s!\n", "world");
```

### Standard Names

If you prefer to use standard function names, define `NOESIS_LIBC_USE_STD_NAMES` before including the headers:

```c
#define NOESIS_LIBC_USE_STD_NAMES
#include <noesis_libc/noesis_libc.h>

// Now you can use standard names
void* ptr = malloc(100);
printf("Hello, %s!\n", "world");
```

## Linking

To link with the static library:

```bash
gcc -I/path/to/noesis_libc/include -L/path/to/noesis_libc/lib -o myprogram myprogram.c -lnlibc
```

To link with the shared library:

```bash
gcc -I/path/to/noesis_libc/include -L/path/to/noesis_libc/lib -o myprogram myprogram.c -lnlibc
export LD_LIBRARY_PATH=/path/to/noesis_libc/lib:$LD_LIBRARY_PATH
```

## Limitations

This is a lightweight implementation intended for the Noesis project:
- Not every C standard library function is implemented
- Some functions have simplified implementations
- Platform-specific: Currently only supports macOS on x86_64
- No locale support
- Limited error handling

## License

Licensed under the Noesis License.

Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
