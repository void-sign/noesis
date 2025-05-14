# Noesis v2.0.0

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
│   ├── fish-only/                                 # Fish shell specific implementation
│   │   ├── fish-only-run.fish                     # Fish-specific run script
│   │   ├── run.fish                               # Main run script for fish shell
│   │   └── src/                                   # Fish source code
│   │       ├── api/                               # API implementation in Fish
│   │       │   └── noesis_api.fish                # Noesis API Fish implementation
│   │       ├── core/                              # Core system implementation in Fish
│   │       │   ├── emotion.fish                   # Emotion processing in Fish
│   │       │   ├── intent.fish                    # Intent processing in Fish
│   │       │   ├── logic.fish                     # Logic processing in Fish
│   │       │   ├── main.fish                      # Main program in Fish
│   │       │   ├── memory.fish                    # Memory management in Fish
│   │       │   └── perception.fish                # Perception processing in Fish
│   │       ├── quantum/                           # Quantum computation in Fish
│   │       │   ├── backend_ibm.fish               # IBM Quantum backend in Fish
│   │       │   ├── backend_stub.fish              # Stub backend in Fish
│   │       │   ├── compiler.fish                  # Quantum compiler in Fish
│   │       │   ├── export_qasm.fish               # QASM export in Fish
│   │       │   ├── quantum.fish                   # Main quantum implementation in Fish
│   │       │   └── field/                         # Quantum field implementation
│   │       │       └── quantum_field.fish         # Quantum field in Fish
│   │       └── utils/                             # Utility functions in Fish
│   │           ├── data.fish                      # Data utility in Fish
│   │           └── noesis_lib.fish                # Noesis library in Fish
│   ├── lib/                                       # Compiled libraries
│   │   ├── libnlibc_stubs.a                       # Noesis C library stubs archive
│   │   └── libnlibc_stubs.a.bak                   # Backup of library stubs
│   └── obj/                                       # Object files
│       ├── api/                                   # API object files
│       │   └── noesis_api.o                       # API implementation object file
│       ├── core/                                  # Core system object files
│       │   ├── emotion.o                          # Emotion processing object file
│       │   ├── intent.o                           # Intent processing object file
│       │   ├── logic.o                            # Logic processing object file
│       │   ├── main.o                             # Main program object file
│       │   ├── memory.o                           # Memory management object file
│       │   └── perception.o                       # Perception processing object file
│       ├── quantum/                               # Quantum computation object files
│       │   ├── backend_ibm.o                      # IBM Quantum backend object file
│       │   ├── backend_stub.o                     # Stub backend object file
│       │   ├── compiler.o                         # Quantum compiler object file
│       │   ├── export_qasm.o                      # QASM export object file
│       │   ├── quantum.o                          # Main quantum implementation object file
│       │   └── field/                             # Quantum field object files
│       │       └── quantum_field.o                # Quantum field object file
│       └── utils/                                 # Utility object files
│           ├── data.o                             # Data utility object file
│           ├── helper.o                           # Helper functions object file
│           ├── io_functions.o                     # I/O functions object file
│           ├── io_helper.o                        # I/O helper functions object file
│           ├── noesis_lib.o                       # Noesis library object file
│           ├── noesis_libc_stubs.o                # Noesis C library stubs object file
│           ├── string_functions.o                 # String functions object file
│           └── timer.o                            # Timer functions object file
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
│       ├── CHANGELOG_v1.1.0.md
│       └── CHANGELOG_v1.2.0.md
├── src/                                           # Source code files
│   ├── api/                                       # API interface implementation
│   │   ├── noesis_api.c                           # Noesis API C implementation
│   │   └── noesis_api.fish                        # Noesis API Fish implementation
│   ├── core/                                      # Core system implementation
│   │   ├── emotion.c                              # Emotion processing in C
│   │   ├── emotion.fish                           # Emotion processing in Fish
│   │   ├── intent.c                               # Intent processing in C
│   │   ├── intent.fish                            # Intent processing in Fish
│   │   ├── intent_shell.c                         # Intent shell in C
│   │   ├── intent_shell.fish                      # Intent shell in Fish
│   │   ├── logic.c                                # Logic processing in C
│   │   ├── logic.fish                             # Logic processing in Fish
│   │   ├── main.c                                 # Main program in C
│   │   ├── main.fish                              # Main program in Fish
│   │   ├── memory.c                               # Memory management in C
│   │   ├── memory.fish                            # Memory management in Fish
│   │   ├── perception.c                           # Perception processing in C
│   │   └── perception.fish                        # Perception processing in Fish
│   └── quantum/                                   # Quantum computation implementation
│       ├── backend_ibm.fish                       # IBM Quantum backend in Fish
│       ├── backend_stub.fish                      # Stub backend in Fish
│       ├── compiler.fish                          # Quantum compiler in Fish
│       ├── export_qasm.fish                       # QASM export in Fish
│       ├── quantum.fish                           # Main quantum implementation in Fish
│       └── field/                                 # Quantum field implementation
│           └── quantum_field.fish                 # Quantum field in Fish
├── build.fish                                     # Main build script for Fish shell
└── run.fish                                       # Main run script for Fish shell
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
  - [CHANGELOG_v2.0.0.md](docs/changelogs/CHANGELOG_v2.0.0.md) (Latest)
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
