# Noesis Project Structure Guide

This document outlines the standard directory structure for the Noesis project.

## Directory Structure

```
noesis/
├── build/                     # Build artifacts (generated)
│   ├── bin/                   # Binary executables
│   └── obj/                   # Object files
├── data/                      # Data files
├── docs/                      # Documentation
│   ├── changelogs/            # Release notes
│   ├── CHECKLIST.md
│   ├── CONTRIBUTING.md
│   └── SECURITY.md
├── examples/                  # Example code
│   └── hub_example/           # Noesis Hub example
├── include/                   # Public header files
│   ├── api/                   # API headers
│   ├── core/                  # Core headers
│   ├── quantum/               # Quantum headers
│   └── utils/                 # Utility headers
├── libs/                      # External libraries
│   └── noesis_libc/           # Custom libc implementation
├── logs/                      # Log files (generated)
├── scripts/                   # Build and utility scripts
│   ├── bash/                  # Bash scripts
│   └── fish/                  # Fish scripts
├── src/                       # Source code
│   ├── api/                   # API implementation
│   ├── core/                  # Core implementation
│   ├── quantum/               # Quantum implementation
│   ├── tools/                 # Tools implementation
│   └── utils/                 # Utility implementation
├── tests/                     # Test suite
│   ├── debug/                 # Debug tests
│   └── unit/                  # Unit tests
├── .gitignore                 # Git ignore file
├── Dockerfile                 # Docker build file
├── LICENSE                    # License file
├── Makefile                   # Main makefile
├── run.fish                   # Fish shell runner
├── run.sh                     # Bash shell runner
└── README.md                  # Project readme
```

## Key Directories

- **build/**: Contains all build artifacts. Build output is separated by type.
- **docs/**: All project documentation including changelogs.
- **include/**: Public header files that define the API.
- **libs/**: External libraries and dependencies.
- **scripts/**: Build and utility scripts organized by shell type.
- **src/**: Source code implementation files.
- **tests/**: Test suite organized by test type.

## Build System

The build system uses a Makefile-based approach:

- `make` - Build the main Noesis binary
- `make clean` - Clean build artifacts
- `make test` - Build and run tests

## Scripts

Common operations are available as scripts in both Bash and Fish shells:

- `scripts/[bash|fish]/build_all.[sh|fish]` - Build all components
- `scripts/[bash|fish]/run_core.[sh|fish]` - Run the Noesis core
- `scripts/[bash|fish]/run_tests.[sh|fish]` - Run the test suite
