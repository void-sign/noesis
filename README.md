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
├── build_all.sh             # Script to build all components
├── changelogs/              # Version history
├── cleanup_extensions.sh    # Clean extensions
├── cleanup_folders.sh       # Clean temporary folders
├── cleanup_repo.sh          # Clean repository
├── data/                    # Core data files
├── debug/                   # Debugging utilities
├── examples/                # Example implementations
├── extend-example/          # Example extension
├── fish_scripts/            # Fish shell scripts
├── include/                 # Header files
│   ├── api/                 # API headers
│   ├── core/                # Core system headers
│   └── utils/               # Utility headers
├── logic_input/             # Logic processing inputs
├── logs/                    # Log files
├── noesis_libc/             # Custom C library
├── object/                  # Object files
├── out_basm/                # Output files
├── run_all_tests.sh         # Test execution script
├── run_core.sh              # Core execution script
├── run_noesis.sh            # Main execution script
├── source/                  # Source code
│   ├── api/                 # API implementation
│   ├── core/                # Core system implementation
│   └── utils/               # Utility implementation
└── tests/                   # Test suite
```

## Project Documentation

- CONTRIBUTING.md - Contribution guidelines
- SECURITY.md - Security policy and vulnerability reporting

## Building the Project

### Prerequisites
- GCC compiler
- Make
- Fish shell (recommended)

### Build Commands

To build the core components:

```bash
make
```

Or use the installation script for a more complete setup:

```bash
./install.fish
```

This script will:
1. Build the core components
2. Create necessary directories
3. Run tests
4. Set up environment

## Running

To run the Noesis core:

```bash
./run_noesis.fish
```

Or you can use the simpler script that targets just the core:

```bash
./run_core.fish
```

## Noesis-Extend Repository

For the extensions, quantum computing modules, and tools, please check the separate repository:

**Repository URL:** https://github.com/void-sign/noesis-extend



## License Information

This repository is licensed under the custom [Noesis License](LICENSE) which includes
requirements for attribution and profit-sharing for commercial use.

## Documentation

- See the `changelogs` directory for version history

## Contributing

Contributions are welcome! Please note which component you are contributing to and adhere to the respective license.

## Security

Please review our [Security Policy](SECURITY.md) for reporting vulnerabilities.
