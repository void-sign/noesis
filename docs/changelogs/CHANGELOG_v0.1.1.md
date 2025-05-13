# Noesis v0.1.1

## Release Date
May 10, 2025

## Overview
This version builds upon the foundation of Noesis, a synthetic consciousness simulation engine, with a focus on improving compatibility and resolving platform-specific issues. The primary changes address macOS compatibility, ensuring the program runs seamlessly on this platform.

## Key Features

### Compatibility Enhancements
- **Resolved `invalid system call` error**: Replaced the custom `syscall` function with the standard `write` function to ensure compatibility with macOS.
- **Header Updates**: Included `<unistd.h>` to resolve implicit declaration errors for system calls.

### Core Improvements
- **Perception Module**: Refined the `perception.c` implementation to use portable system calls for output.
- **Code Cleanup**: Removed redundant and conflicting declarations, such as the custom `syscall` declaration in `perception.h`.

## Documentation
- Updated project documentation to reflect changes in system call handling and compatibility improvements.

## Testing
- Verified functionality on macOS by running the `noesis` executable and confirming expected outputs.

## Build Instructions
- Build the project with `make`.
- Clean compiled files with `make clean`.

## Comparison with v0.1.1-beta

### Improvements
- **Platform Compatibility**: While v0.1.1-beta focused on foundational components, this version ensures compatibility with macOS by addressing system call issues.
- **Error Resolution**: Fixed the `invalid system call` error that was present in v0.1.1-beta.

### Retained Features
- Core components for perception, memory, emotion, and logic remain consistent with v0.1.1-beta.
- Quantum middleware and utility enhancements introduced in v0.1.1-beta are preserved.
