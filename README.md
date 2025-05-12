# Noesis Project v1.0.0

![Noesis Logo](noesis-logo.jpg)

> Synthetic consciousness simulation engine

## Overview

Noesis is a synthetic consciousness simulation engine designed to explore the principles of artificial consciousness and cognition. The project is now structured as two separate repositories with different licenses to facilitate wider adoption and integration.

## Project Structure

### 1. Noesis (this repository)
The core functionality with no external dependencies beyond standard C libraries.

**Components:**
- Emotion processing
- Logic processing
- Memory management
- Perception processing
- Intent processing
- Core utilities
- Standard API for external projects

**License:** Custom Noesis License, which includes requirements for attribution and profit-sharing for commercial use.

### 2. Noesis-Extend (separate repository)
Extensions and tools that may use external libraries.

**Repository:** https://github.com/void-sign/noesis-extend

**Components:**
- Quantum computing modules
- Field theory implementations
- Specialized tools (qbuild, qrun)

**License:** MIT License for more permissive use, modification, and redistribution.

The two repositories are now completely independent and communicate via the standard Noesis API.

### Directory Structure
```
noesis/
├── build_all.sh             # Build script for all components
├── changelogs/              # Version history and release notes
├── cleanup_extensions.sh    # Script to clean extension artifacts
├── cleanup_folders.sh       # Script to clean temporary folders
├── cleanup_repo.sh          # Script to clean repository state
├── data/                    # Core data files for simulations
├── debug/                   # Debug and testing utilities
├── examples/                # Example usage and implementation
├── extend-example/          # Template for extension creation
├── fish_scripts/            # Alternative Fish shell scripts
├── include/                 # Header files
│   ├── api/                 # API interface headers
│   ├── core/                # Core system headers
│   └── utils/               # Utility function headers
├── logic_input/             # Logic processing input files
├── logs/                    # Log output files
├── noesis_libc/             # Custom C library implementation
├── object/                  # Compiled object files
│   ├── api/                 # API object files
│   ├── asm/                 # Assembly object files
│   ├── core/                # Core system object files
│   └── utils/               # Utility object files
├── out_basm/                # Output binary assembly files
├── run_all_tests.sh         # Script to execute all test suites
├── run_core.sh              # Script to run core functionality
├── run_noesis.sh            # Main execution script
├── source/                  # Source code files
│   ├── api/                 # API interface implementation
│   ├── core/                # Core system implementation
│   └── utils/               # Utility function implementation
└── tests/                   # Test suites and unit tests
```

## Project Documentation

- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [SECURITY.md](SECURITY.md) - Security policy and vulnerability reporting
- [CHECKLIST.md](CHECKLIST.md) - Repository split checklist

## Building the Project

### Prerequisites

- **GCC compiler** (version 9.0+)
  - Required for building C source files and assembly components
  - Must support C11 standard features
  - Optimization flags required for quantum processing modules

- **Make** (version 4.0+)
  - Used for managing build rules and dependencies
  - Core Makefile supports parallel builds with `-j` option
  - Custom rules for assembly and object file generation

- **Bash shell** (default) or **Fish shell** (optional)
  - Required for running installation and build scripts
  - Fish shell alternatives provided in the `fish_scripts/` directory

### Build Commands

To build the core components:

```bash
make
```

For a complete setup that includes creating libraries and setting up the environment:

```bash
./build_all.sh   # Basic build with clean
# or
./install.sh     # Full installation
```

The installation script will:
1. Create necessary directories (bin, lib, include)
2. Build the core components with proper flags (`-Wall -Wextra -std=c99 -fPIC`)
3. Create static library (`lib/libnoesis.a`)
4. Create shared library (`lib/libnoesis.so`)
5. Install API headers for external use
6. Run tests (if available)
7. Set up environment variables and create symbolic links

## Running

To run the Noesis core:

```bash
./run_noesis.sh
```

Or you can use the simpler script that targets just the core:

```bash
./run_core.sh
```

## Noesis-Extend Repository

For the extensions, quantum computing modules, and tools, please check the separate repository:

**Repository URL:** https://github.com/void-sign/noesis-extend

## License Information

This repository is licensed under the custom [Noesis License](LICENSE) which includes
requirements for attribution and profit-sharing for commercial use.

## Documentation

- See the [changelogs](changelogs/) directory for version history:
  - [CHANGELOG_v1.0.0.md](changelogs/CHANGELOG_v1.0.0.md)
  - [CHANGELOG_v0.2.0.md](changelogs/CHANGELOG_v0.2.0.md)
  - [CHANGELOG_v0.1.2.md](changelogs/CHANGELOG_v0.1.2.md)
  - [CHANGELOG_v0.1.1.md](changelogs/CHANGELOG_v0.1.1.md)

## Contributing

Contributions are welcome! Please note which component you are contributing to and adhere to the respective license.

## Security

Please review our [Security Policy](SECURITY.md) for reporting vulnerabilities.
