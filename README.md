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

**License:** Custom Noesis License, which includes requirements for attribution and profit-sharing for commercial use.

### 2. Noesis-Extend (separate repository)
Extensions and tools that may use external libraries.

**Repository:** https://github.com/void-sign/noesis-extend

**Components:**
- Quantum computing modules
- Field theory implementations
- Specialized tools (qbuild, qrun)

**License:** MIT License for more permissive use, modification, and redistribution.

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

## Migration Information

If you're migrating from the previous structure with both components in one repository,
please see the [MIGRATION.md](MIGRATION.md) guide for detailed instructions.

## License Information

This repository is licensed under the custom [Noesis License](LICENSE) which includes
requirements for attribution and profit-sharing for commercial use.

## Documentation

- See the `changelogs` directory for version history
- Check the [DEVELOPMENT.md](DEVELOPMENT.md) file for development guidelines

## Contributing

Contributions are welcome! Please note which component you are contributing to and adhere to the respective license.

## Security

Please review our [Security Policy](SECURITY.md) for reporting vulnerabilities.
