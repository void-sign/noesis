# Noesis LibC Include Directory

This directory contains the header files for the Noesis LibC implementation.

## Naming Convention

Noesis LibC supports two different naming conventions:

1. **Noesis Native Names** - All functions are prefixed with `nlibc_` (e.g., `nlibc_printf`, `nlibc_malloc`). These are always available.

2. **Short Names** - Brief, concise function names like `out` (for printf), `new` (for malloc). These are the recommended approach for all new code.
   - Enable with: `#define NOESIS_USE_SHORT_NAMES` before including the headers.

## Header Files

- **noesis_names.h** - Header file for short name mappings to native function names.
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
