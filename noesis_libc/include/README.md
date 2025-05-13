# Noesis LibC Include Directory

This directory contains the header files for the Noesis LibC implementation.

## Naming Convention

Noesis LibC supports three different naming conventions:

1. **Noesis Native Names** - All functions are prefixed with `nlibc_` (e.g., `nlibc_printf`, `nlibc_malloc`). These are always available.

2. **Short Names** - Brief, concise function names like `out` (for printf), `new` (for malloc). These are recommended for new code.
   - Enable with: `#define NOESIS_USE_SHORT_NAMES` before including the headers.

3. **Standard C Names** - Traditional C function names like `printf`, `malloc`. Provided for compatibility.
   - Enable with: `#define NOESIS_LIBC_USE_STD_NAMES` before including the headers.

## Header Files

- **noesis_names.h** - Combined header file for both short names and standard C names mappings.
- **noesis_libc.h** - Main header file that includes all the necessary headers for the library.
- **noesis_types.h** - Common type definitions used throughout the library.
- **noesis_config.h** - Configuration options for the library.

## Using Short Names (Recommended)

```c
#define NOESIS_USE_SHORT_NAMES
#include <noesis_libc.h>

int main() {
    // Use short names
    out("Hello, %s!\n", "world");  // Instead of printf
    
    int* data = new(sizeof(int) * 10);  // Instead of malloc
    if (!data) return 1;
    
    fill(data, 0, sizeof(int) * 10);  // Instead of memset
    
    del(data);  // Instead of free
    return 0;
}
```

## Directory Structure

- **/stdio/** - Headers for input/output functions
- **/stdlib/** - Headers for standard library functions
- **/string/** - Headers for string manipulation functions
- **/sys/** - Headers for system-related functions
- **/math/** - Headers for mathematical functions
