# Noesis and Noesis-Extend Independence Guide

This document explains the new architecture where Noesis and Noesis-Extend are completely independent repositories with standardized communication.

## Overview

Noesis and Noesis-Extend are now organized as fully independent repositories:

1. **Noesis (Core)**: The core consciousness simulation engine with a standard public API
2. **Noesis-Extend**: Extensions and tools that build on Noesis via the standard API

## Key Changes

### 1. Standard API

The communication between Noesis and Noesis-Extend is now done exclusively through the standard API defined in `noesis_api.h`. This API:

- Provides a stable interface for all external projects
- Hides internal implementation details
- Ensures compatibility between versions
- Makes testing and development easier

### 2. Library-Based Integration

Instead of direct code dependencies, Noesis is now packaged as both static and shared libraries:

- `libnoesis.a` - Static library for compilation into applications
- `libnoesis.so` - Shared library for dynamic linking

### 3. Build System Improvements

- **pkg-config Support**: Added `noesis.pc` for easy dependency detection
- **Standardized Headers**: Headers are installed in a specific include directory
- **Installation Scripts**: Updated to properly install the API components

### 4. No Direct Dependencies

- Noesis-Extend no longer needs direct access to Noesis source code
- No cross-compilation needed
- Each repository can evolve independently
- Different licensing is cleanly separated

## Diagram of the New Architecture

```
┌───────────────────┐            ┌───────────────────┐
│   Noesis Core     │            │   Noesis-Extend   │
│ (Noesis License)  │            │   (MIT License)   │
└─────────┬─────────┘            └─────────┬─────────┘
          │                                │
          │ Builds                         │ Builds
          ▼                                ▼
┌───────────────────┐            ┌───────────────────┐
│  libnoesis.so     │◄───────────┤  Applications     │
│  Public API       │ Links to   │                   │
└───────────────────┘            └───────────────────┘
```

## How to Use the Independent Repositories

### Setting Up Noesis Core

```bash
# Clone and build Noesis
git clone https://github.com/void-sign/noesis.git
cd noesis
./install.sh   # or ./fish_scripts/install.fish for fish shell
```

### Using Noesis from Noesis-Extend

```bash
# Clone Noesis-Extend
git clone https://github.com/void-sign/noesis-extend.git
cd noesis-extend

# Run the installation script (finds Noesis automatically)
./install.sh   # or ./install.fish for fish shell

# Run Noesis-Extend tools
./bin/noesis-extend
```

## Technical Details

### API Usage Example

```c
#include <noesis/noesis_api.h>

int main() {
    // Initialize Noesis
    noesis_handle_t handle = noesis_initialize();
    
    // Process input through Noesis
    char output[1024];
    noesis_size_t output_length;
    noesis_process_input(handle, "input", 5, output, sizeof(output), &output_length);
    
    // Cleanup
    noesis_shutdown(handle);
    return 0;
}
```

### Compilation Example

```bash
# Compile your application against Noesis
gcc -I/path/to/noesis/lib/include -L/path/to/noesis/lib -o myapp myapp.c -lnoesis
```

## Benefits of the New Architecture

1. **Cleaner Separation**: Each repository has a clear responsibility
2. **Better Maintenance**: Changes in one repository don't affect the other
3. **Licensing Clarity**: No mixing of code with different licenses
4. **Standard Communication**: Well-defined API for all interactions
5. **Versioning**: API versioning for compatibility tracking
