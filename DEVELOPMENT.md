# Noesis Development Guide

This guide explains the development workflow for the restructured Noesis project.

## Project Structure Overview

The Noesis project is now organized into two main repositories:

1. **Noesis Core** (`noesis-core/`)
   - Contains the essential consciousness simulation functionality
   - Uses the Noesis License with profit-sharing requirements
   - No external dependencies beyond standard C libraries

2. **Noesis Extensions** (`noesis-extensions/`)
   - Contains quantum computing and specialized tools
   - Uses the MIT License
   - May have external dependencies
   - Depends on Noesis Core

## Development Workflow

### Setting Up Your Development Environment

1. Clone the entire repository:
   ```
   git clone https://github.com/void-sign/noesis.git
   cd noesis
   ```

2. Run the installation script:
   ```
   ./install.fish
   ```

### Building the Project

For normal development, use:

```bash
./build_all.fish
```

For targeted development:

```bash
# Build only the core
cd noesis-core
make

# Build only extensions
cd noesis-extensions
make
```

### Running Tests

```bash
# Run all tests
./run_all_tests.fish

# Run core tests
cd noesis-core
make test

# Run extension tests
cd noesis-extensions
make test
```

## Making Changes

### Core Changes

When modifying core functionality:

1. Edit files in `noesis-core/source/` or `noesis-core/include/`
2. Build and test the core: `cd noesis-core && make && make test`
3. If the changes affect the API, make corresponding updates in extensions

### Extension Changes

When modifying extensions:

1. Edit files in `noesis-extensions/source/` or `noesis-extensions/include/`
2. Build and test: `cd noesis-extensions && make && make test`

### Adding New Files

#### Adding to Core:

1. Create your new `.c` file in `noesis-core/source/core/` or `noesis-core/source/utils/`
2. Create any necessary headers in `noesis-core/include/core/` or `noesis-core/include/utils/`
3. Update `noesis-core/Makefile` if necessary to include the new file

#### Adding to Extensions:

1. Create your new `.c` file in `noesis-extensions/source/quantum/` or `noesis-extensions/source/tools/`
2. Create any necessary headers in `noesis-extensions/include/quantum/`
3. Update `noesis-extensions/Makefile` if necessary

## Shared Library Interface

The core functionality is exposed to extensions through a shared library (`libnoesis_core.so`). When making API changes to the core:

1. Update the relevant header files in `noesis-core/include/`
2. Rebuild the shared library: `./link_libraries.fish`
3. Test that extensions still work correctly

## Release Process

1. Update version numbers in both components
2. Create a new changelog entry in both repositories
3. Build and test everything
4. Tag the release with git
5. Update Docker image if needed

## Common Issues and Solutions

### Extensions Can't Find Core Library

If extensions report missing symbols or libraries:

```bash
# Rebuild the shared library
./link_libraries.fish

# Or manually set the library path
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
```

### Build Errors

If you encounter build errors:

1. Make sure header paths are correct
2. Check that all required files are in their expected locations
3. Try a clean build: `make clean && make`

### Testing Failures

If tests are failing:

1. Check that both core and extensions are built with compatible versions
2. Ensure the shared library (`libnoesis_core.so`) is up to date
3. Look at test output for specific failure messages

## Contributing

When contributing to Noesis, please:

1. Clearly indicate which component(s) your changes affect
2. Respect the license boundaries between components
3. Provide tests for new functionality
4. Update documentation as needed
5. Follow the coding style of the existing codebase

## License Considerations

Remember that:
- Core contributions must comply with the Noesis License
- Extension contributions must comply with the MIT License
- Be careful not to inadvertently mix code between the components that would violate these license boundaries
