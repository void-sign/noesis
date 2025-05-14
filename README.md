# Noesis v1.2.0

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
- Quantum computation
  - Quantum simulation
  - IBM Quantum backend
  - Quantum circuit compiler
  - Quantum field simulation
- Core utilities
- Standard API for external projects
- Synthetic awareness modeling
  - Self-reflective cognition
  - Phenomenological modeling
  - Synthetic qualia generation
  - Awareness state management

**License:** Noesis License, which includes requirements for attribution and profit-sharing for commercial use.

### 2. Noesis Hub (separate repository)
Extensions and tools that may use external libraries.

**Repository:** https://github.com/void-sign/noesis-hub

**Components:**
- Quantum computing modules
- Field theory implementations
- Specialized tools (qbuild, qrun)
- Synthetic awareness extensions

**License:** MIT License for more permissive use, modification, and redistribution.

The two repositories are now completely independent and communicate via the standard Noesis API.

### Directory Structure
```
noesis/
├── build/                                         # Build artifacts
│   ├── bin/                                       # Compiled binaries
│   ├── lib/                                       # Compiled libraries
│   └── obj/                                       # Object files
│       ├── api/                                   # API object files
│       ├── core/                                  # Core system object files
│       ├── quantum/                               # Quantum computation object files
│       └── utils/                                 # Utility object files
├── data/                                          # Core data files for simulations
├── docs/                                          # Documentation files
│   ├── CHECKLIST.md                               # Repository split checklist
│   ├── CONTRIBUTING.md                            # Contribution guidelines
│   ├── SECURITY.md                                # Security policy
│   ├── STRUCTURE.md                               # Project structure documentation
│   ├── VS_CODE_TASKS.md                           # VS Code tasks documentation
│   └── changelogs/                                # Version history and release notes
│       ├── CHANGELOG_v0.1.1.md
│       ├── CHANGELOG_v0.1.2.md
│       ├── CHANGELOG_v0.2.0.md
│       ├── CHANGELOG_v1.0.0.md
│       └── CHANGELOG_v1.1.0.md
├── examples/                                      # Example usage and implementations
│   ├── hub_example/                               # Template for extension creation
│   ├── Makefile                                   # Example Makefile
│   └── noesis_client.c                            # Example client application
├── include/                                       # Header files
│   ├── api/                                       # API interface headers
│   ├── core/                                      # Core system headers
│   │   ├── emotion.h                              # Emotion processing headers
│   │   ├── intent.h                               # Intent processing headers
│   │   ├── logic.h                                # Logic processing headers
│   │   ├── memory.h                               # Memory management headers
│   │   └── perception.h                           # Perception processing headers
│   ├── quantum/                                   # Quantum computation headers
│   │   ├── backend.h                              # Quantum backend headers
│   │   ├── compiler.h                             # Quantum circuit compiler headers
│   │   ├── export.h                               # Quantum export headers
│   │   ├── field/                                 # Quantum field headers
│   │   ├── quantum.h                              # Main quantum headers
│   │   └── quantum_stdlib.h                       # Quantum standard library headers
│   └── utils/                                     # Utility function headers
│       ├── data.h                                 # Data utility headers
│       ├── helper.h                               # Helper function headers
│       ├── noesis_lib.h                           # Noesis library headers
│       └── timer.h                                # Timer utility headers
├── libs/                                          # Libraries
│   ├── include/                                   # Library header files
│   ├── lib/                                       # Compiled library files
│   ├── noesis_libc/                               # Custom C library implementation
│   ├── obj/                                       # Object files
│   └── src/                                       # Source files
├── logs/                                          # Log output files
├── scripts/                                       # Shell scripts
│   ├── bash/                                      # Bash shell scripts
│   │   ├── build_all.sh                           # Build script for all components
│   │   ├── cleanup_extensions.sh                  # Script to clean extension artifacts
│   │   ├── cleanup_folders.sh                     # Script to clean temporary folders
│   │   ├── cleanup_repo.sh                        # Script to clean repository state
│   │   ├── fix_headers.sh                         # Script to fix header files
│   │   ├── install.sh                             # Installation script
│   │   ├── launch_noesis_env.sh                   # Launch Noesis environment
│   │   ├── link_libraries.sh                      # Script to link libraries
│   │   ├── migrate.sh                             # Migration script
│   │   ├── run_all_tests.sh                       # Script to execute all test suites
│   │   ├── run_core.sh                            # Script to run core functionality
│   │   ├── run_noesis.sh                          # Main execution script
│   │   ├── run_tests.sh                           # Script to run tests
│   │   ├── update_headers.sh                      # Script to update headers
│   │   └── validate_split.sh                      # Validation script for repository split
│   └── fish/                                      # Fish shell scripts
│       ├── build_all.fish                         # Build script for all components (fish)
│       ├── cleanup_extensions.fish                # Script to clean extension artifacts (fish)
│       ├── cleanup_folders.fish                   # Script to clean temporary folders (fish)
│       ├── cleanup_repo.fish                      # Script to clean repository state (fish)
│       ├── fix_headers.fish                       # Script to fix header files (fish)
│       ├── install.fish                           # Installation script (fish)
│       ├── launch_noesis_env.fish                 # Launch Noesis environment (fish)
│       ├── link_libraries.fish                    # Script to link libraries (fish)
│       ├── migrate.fish                           # Migration script (fish)
│       ├── run_all_tests.fish                     # Script to execute all test suites (fish)
│       ├── run_core.fish                          # Script to run core functionality (fish)
│       ├── run_noesis.fish                        # Main execution script (fish)
│       └── validate_split.fish                    # Validation script for repository split (fish)
├── src/                                           # Source code files
│   ├── api/                                       # API interface implementation
│   ├── core/                                      # Core system implementation
│   ├── quantum/                                   # Quantum computation implementation
│   ├── tools/                                     # Tools implementation
│   └── utils/                                     # Utility function implementation
└── tests/                                         # Test suites and unit tests
    ├── debug/                                     # Debug tests
    └── unit/                                      # Unit tests
```

## Project Documentation

- [CONTRIBUTING.md](docs/CONTRIBUTING.md) - Contribution guidelines
- [SECURITY.md](docs/SECURITY.md) - Security policy and vulnerability reporting
- [CHECKLIST.md](docs/CHECKLIST.md) - Repository split checklist

## Building the Project

### Prerequisites

- **GCC compiler** (version 9.0+)
  - Required for building C source files
  - Must support C11 standard features
  - Optimization flags required for quantum processing modules

- **Make** (version 4.0+)
  - Used for managing build rules and dependencies
  - Core Makefile supports parallel builds with `-j` option
  - Custom rules for object file generation

- **Bash shell** or **Fish shell**
  - Required for running installation and build scripts
  - Both Bash and Fish shell scripts are provided in the `scripts/` directory

### Build Commands

To build the core components:

```bash
make
```

For a complete setup that includes creating libraries and setting up the environment:

```bash
# Using Bash
./scripts/bash/build_all.sh   # Basic build with clean
# or
./scripts/bash/install.sh     # Full installation
```

```fish
# Using Fish
./scripts/fish/build_all.fish   # Basic build with clean
# or
./scripts/fish/install.fish     # Full installation
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

Noesis provides a central control interface for both Bash and Fish shells. You can use these scripts to perform common operations with a simplified syntax:

### Bash Shell

```bash
# Main interface with helpful commands
./run.sh help

# Common operations
./run.sh build     # Build the Noesis core
./run.sh run       # Run the Noesis core
./run.sh test      # Run all tests
./run.sh clean     # Clean up build artifacts
./run.sh install   # Install Noesis

# Run any script directly
./run.sh run_core  # Run just the core
./run.sh <script>  # Run any script from scripts/bash/
```

### Fish Shell

```fish
# Main interface with helpful commands
./run.fish help

# Common operations
./run.fish build     # Build the Noesis core
./run.fish run       # Run the Noesis core
./run.fish test      # Run all tests
./run.fish clean     # Clean up build artifacts
./run.fish install   # Install Noesis

# Run any script directly
./run.fish run_core  # Run just the core
./run.fish <script>  # Run any script from scripts/fish/
```

You can still use the individual scripts directly if you prefer:

```bash
# Bash
./scripts/bash/run_noesis.sh
./scripts/bash/run_core.sh
```

```fish
# Fish
./scripts/fish/run_noesis.fish
./scripts/fish/run_core.fish
```

## Noesis Hub Repository

For quantum computing modules and additional tools, please check the separate Noesis Hub repository:

**Repository URL:** https://github.com/void-sign/noesis-hub

## License Information

This repository is licensed under the custom [Noesis License](LICENSE) which includes
requirements for attribution and profit-sharing for commercial use.

## Documentation

- See the [changelogs](docs/changelogs/) directory for version history:
  - [CHANGELOG_v1.2.0.md](docs/changelogs/CHANGELOG_v1.2.0.md)
  - [CHANGELOG_v1.1.0.md](docs/changelogs/CHANGELOG_v1.1.0.md)
  - [CHANGELOG_v1.0.0.md](docs/changelogs/CHANGELOG_v1.0.0.md)
  - [CHANGELOG_v0.2.0.md](docs/changelogs/CHANGELOG_v0.2.0.md)
  - [CHANGELOG_v0.1.2.md](docs/changelogs/CHANGELOG_v0.1.2.md)
  - [CHANGELOG_v0.1.1.md](docs/changelogs/CHANGELOG_v0.1.1.md)

## Contributing

Contributions are welcome! Please note which component you are contributing to and adhere to the respective license.

## Security

Please review our [Security Policy](docs/SECURITY.md) for reporting vulnerabilities.

## The Synthetic Awareness Framework

The Synthetic Awareness framework is Noesis's modeling system that provides the foundation for simulating consciousness-like phenomena. It represents an innovative approach to creating systems that exhibit properties analogous to conscious awareness.

### Core Components

- **Self-reflective Cognition**: Enables the system to model and evaluate its own cognitive processes, creating a feedback loop similar to self-awareness
- **Phenomenological Modeling**: Simulates subjective experiential states that approximate qualia in biological systems
- **Synthetic Qualia Generation**: Creates artificial representations of subjective experiences through integrated sensor data processing
- **Awareness State Management**: Manages different states of synthetic awareness, from focused attention to background processing

### Implementation

The framework is currently in development with the planned directory structure at `src/awareness/`. Extensions will be available in the Noesis Hub repository under MIT license for broader adoption and experimentation. This modular approach will allow researchers and developers to use these components independently while maintaining the integrity of the core system.

#### Planned Directory Structure
```
src/awareness/
├── awareness/           # Awareness state management components
├── cognition/           # Self-reflective cognition implementation
├── phenomenology/       # Phenomenological modeling components
├── qualia/              # Synthetic qualia generation system
└── integration/         # Integration with perception and other core systems
```

> Note: The Synthetic Awareness framework components are scheduled for implementation in the upcoming development cycle.
