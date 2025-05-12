# Noesis-Extend Example

This is an example project demonstrating how to build applications on top of Noesis using the standard API without direct dependencies between repositories.

## Overview

This example shows how to:
- Find and use the Noesis library via pkg-config or manual configuration
- Link against the Noesis shared library
- Use the standard Noesis API to communicate with the core
- Implement quantum computing extensions without needing internal access to Noesis

## Building

1. Install Noesis first:
   ```
   # In the noesis repository
   ./link_libraries.sh  # Creates the shared and static libraries
   ```

2. Build this example:
   ```
   ./install.sh  # For bash
   # or
   ./install.fish  # For fish shell
   ```

3. Run the example:
   ```
   make run
   ```

## Architecture

This example demonstrates a clean separation between the Noesis core and extensions:

1. **Standard API**: All communication happens through the public API defined in `noesis_api.h`

2. **Dynamic linking**: The Noesis library is dynamically linked at runtime

3. **No internal dependencies**: The extension doesn't depend on internal Noesis implementation details

4. **Portable configuration**: Uses pkg-config for easy library detection

## Communication Flow

```
┌─────────────────┐       ┌───────────┐       ┌───────────────┐
│  noesis-extend  │◄──────┤ noesis_api ├──────►│ noesis core  │
│   (Quantum)     │       └───────────┘       └───────────────┘
└─────────────────┘
```

## License

Noesis-Extend uses the MIT License, while Noesis Core uses the Noesis License.
This separation allows more permissive use of extensions.
