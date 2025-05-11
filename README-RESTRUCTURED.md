# Noesis Project

This is the main repository for the Noesis synthetic consciousness system. The project has been restructured into two separate components with different licenses:

## Project Structure

### 1. Noesis Core
The core functionality with no external dependencies, licensed under the custom Noesis License.

- Directory: `noesis-core/`
- Components: Core simulation engine, utility functions, memory management
- License: Custom Noesis License with profit-sharing requirements

### 2. Noesis Extensions
Extensions and tools that may use external libraries, licensed under the MIT License.

- Directory: `noesis-extensions/`
- Components: Quantum computing modules, field theory, specialized tools
- License: MIT License

## Building the Project

To build both components:

```bash
./build_all.fish
```

Or build each component separately:

```bash
# Build core
cd noesis-core
make

# Build extensions
cd noesis-extensions
make
```

## License Information

- The Noesis Core is licensed under the custom Noesis License, which includes requirements for attribution and profit-sharing for commercial use.
- The Noesis Extensions are licensed under the MIT License, which allows for more permissive use, modification, and redistribution.

For detailed license information, see the LICENSE file in each respective directory.

## Running the Project

To run the restructured project:

```bash
# Run the core component
./run_core.fish

# Run the extensions component
./run_extensions.fish

# Run with the unified interface
./run_noesis.fish core   # Run core only
./run_noesis.fish ext    # Run extensions only
./run_noesis.fish all    # Run both
```

## Testing

To run tests for both components:

```bash
./run_all_tests.fish
```

Or test each component separately:

```bash
# Test core
cd noesis-core
make test

# Test extensions
cd noesis-extensions
make test
```

## Migration

If you're migrating from the original structure, we provide a migration script:

```bash
./migrate.fish
```

This script will:
1. Create a backup of your existing files
2. Set up the new structure
3. Copy relevant files to their new locations
4. Update configuration files

## Docker Support

We've updated the Dockerfile to support both the old and new structures. To build and run with Docker:

```bash
docker build -t noesis .
docker run -it noesis
```

## Original Project

The original, combined project is maintained for historical purposes. The restructured repositories are the recommended way to use the project going forward.
