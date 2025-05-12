# Noesis Development Guide

This guide explains the development workflow for the restructured Noesis project.

## Project Structure Overview

The Noesis project is now organized into two separate repositories:

1. **Noesis Core** (this repository)
   - Contains the essential consciousness simulation functionality
   - Uses the Noesis License with profit-sharing requirements
   - No external dependencies beyond standard C libraries

2. **Noesis-Extend** (separate repository: https://github.com/void-sign/noesis-extend)
   - Contains quantum computing and specialized tools
   - Uses the MIT License
   - May have external dependencies
   - Depends on Noesis Core

## Development Workflow

### Setting Up Your Development Environment

1. Clone the Noesis Core repository:
   ```
   git clone https://github.com/void-sign/noesis.git
   cd noesis
   ```

2. Run the installation script:
   ```
   ./install.fish
   ```

3. If you need the extensions, clone the Noesis-Extend repository as well:
   ```
   git clone https://github.com/void-sign/noesis-extend.git
   cd noesis-extend
   ./scripts/install_dependency.fish
   ./install.fish
   ```

### Building the Project

For Noesis Core development, use:

```bash
# In Noesis Core repository
make
```

For Noesis-Extend development (in the separate repository):

```bash
# In Noesis-Extend repository
make
```

### Running Tests

```bash
# Run all tests
./run_all_tests.fish

# Run core tests (in root directory)
make test
```

For extension tests, use the separate repository:

```bash
# In the Noesis-Extend repository
make test
```

## Making Changes

### Core Changes

When modifying core functionality:

1. Edit files in `source/core/` or `include/core/`
2. Build and test the core: `make && make test`
3. If the changes affect the API, make corresponding updates in extensions repository

### Extension Changes

When modifying extensions (in the separate Noesis-Extend repository):

1. Edit files in the separate Noesis-Extend repository
2. Build and test: `cd /path/to/noesis-extend && make && make test`

### Adding New Files

#### Adding to Core:

1. Create your new `.c` file in `source/core/` or `source/utils/`
2. Create any necessary headers in `include/core/` or `include/utils/`
3. Update `Makefile` if necessary to include the new file

#### Adding to Extensions:

Extensions development now happens in the separate Noesis-Extend repository:
https://github.com/void-sign/noesis-extend

## Shared Library Interface

The core functionality is exposed to extensions through a shared library (`libnoesis_core.so`). When making API changes to the core:

1. Update the relevant header files in `include/`
2. Rebuild the shared library: `./link_libraries.fish`
3. Test that extensions still work correctly by updating the Noesis-Extend repository

## Release Process

1. Update version numbers in both repositories
2. Create a new changelog entry in both repositories
3. Build and test everything
4. Tag the release with git
5. Update Docker image if needed

## Common Issues and Solutions

### Extensions Can't Find Core Library

If the Noesis-Extend repository reports missing symbols or libraries:

```bash
# Rebuild the shared library in Noesis Core
./link_libraries.fish

# Copy the shared library to the Noesis-Extend repository
cp lib/libnoesis_core.so /path/to/noesis-extend/

# Or manually set the library path
export LD_LIBRARY_PATH=/path/to/noesis/lib:$LD_LIBRARY_PATH
```

### Build Errors

If you encounter build errors:

1. Make sure header paths are correct
2. Check that all required files are in their expected locations
3. Try a clean build: `make clean && make`

### Testing Failures

If tests are failing:

1. Check that both repositories are built with compatible versions
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
