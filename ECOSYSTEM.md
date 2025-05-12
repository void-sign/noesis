# Noesis Project Ecosystem

This document provides an overview of the Noesis project ecosystem, which is now split into separate repositories.

## Repositories

### 1. Noesis Core
**Repository:** https://github.com/void-sign/noesis

The core of the Noesis synthetic consciousness engine, featuring:
- Emotion processing
- Logic processing
- Memory management
- Perception processing
- Intent processing

**License:** Custom Noesis License (requires attribution and profit-sharing for commercial use)

### 2. Noesis-Extend
**Repository:** https://github.com/void-sign/noesis-extend

Extensions and tools for the Noesis core, featuring:
- Quantum computing modules
- Field theory implementations
- Specialized tools (qbuild, qrun)

**License:** MIT License (permissive use)

## Integration

The two repositories are designed to work together, with Noesis-Extend depending on Noesis Core. The relationship is managed through:

1. **Environment Variables:**
   - `NOESIS_CORE_PATH` - Points to the location of Noesis Core
   - `LD_LIBRARY_PATH` - Includes the path to Noesis Core's lib directory

2. **Installation Scripts:**
   - The `install_dependency.fish` script in Noesis-Extend can automatically download and build Noesis Core
   - The `link_libraries.fish` script creates the necessary library links

3. **Helper Utilities:**
   - `launch_noesis_env.fish` scripts in both repositories set up the environment and open both projects in VS Code

## Choosing the Right Repository

- If you only need the core consciousness simulation functionality, use **Noesis Core**
- If you need advanced quantum features or tools, use **Noesis-Extend** (which depends on Core)
- For contributors, select the appropriate repository based on what functionality you're enhancing

## Migration from Previous Versions

If you were using the previous single-repository version of Noesis, please see the [MIGRATION.md](MIGRATION.md) guide for detailed migration instructions.
