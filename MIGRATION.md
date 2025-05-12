# Noesis Migration to Separate Repositories

This document provides guidance on the migration of Noesis to separate repositories.

## Overview

Noesis has been split into two separate repositories:

1. **Noesis** (this repository): Contains the core functionalities with the Noesis License
2. **Noesis-Extend**: Contains extensions, quantum computing modules, and tools with MIT License

## Why Separate Repositories?

1. **Clear License Boundaries**: Each repository has its own distinct license
2. **Independent Development**: Each component can evolve at its own pace
3. **Simplified Dependency Management**: Users can choose to use just the core or add extensions
4. **Better Organization**: Cleaner separation of concerns

## For Users of Noesis-Extensions Directory

If you were using the `noesis-extensions` directory in this repository, you should now switch to the separate Noesis-Extend repository:

```bash
git clone https://github.com/void-sign/noesis-extend.git
cd noesis-extend
./scripts/install_dependency.fish  # Install Noesis Core as a dependency
./install.fish                     # Build and install Noesis-Extend
```

## Directory Mapping

| Old Path | New Repository Path |
|----------|---------------------|
| noesis-extensions/* | noesis-extend/* |
| noesis-core/* | noesis/* |

## Build Process Changes

The build process has changed:

1. **Old approach**: 
   ```bash
   ./build_all.fish  # Build both components
   ```

2. **New approach**:
   ```bash
   # In noesis repository
   make

   # In noesis-extend repository
   ./install.fish
   ```

## Script Changes

- `build_all.fish` is no longer needed
- `run_extensions.fish` has been moved to the Noesis-Extend repository as `run.fish`
- `link_libraries.fish` has been updated in the Noesis-Extend repository to find Noesis Core

## Getting Help

If you encounter any issues with the migration, please open an issue on the appropriate repository:

- Core functionality: https://github.com/void-sign/noesis
- Extensions: https://github.com/void-sign/noesis-extend
