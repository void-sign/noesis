# Noesis v0.2.0

## Release Date
May 12, 2025

## Overview
This major update restructures the Noesis project into two separate components with different licenses: Noesis Core and Noesis Extensions. This change aims to provide more flexibility for integrations while maintaining the core principles of the project.

## Key Changes

### Project Structure
- **Split Repository**: The project is now split into noesis-core and noesis-extensions
- **Licensing**: Core uses the original Noesis License, Extensions use MIT License
- **Build System**: Updated Makefiles for each component and linking between them
- **Installation**: New installation and migration scripts

### Core Features
- **Clean Separation**: Core now contains only essential functionality with no external dependencies
- **Shared Library**: Core can be built as a shared library for external projects
- **API Stability**: Core API stabilized for external consumption

### Extension Features
- **MIT License**: More permissive license for extensions to enable wider adoption
- **Dependency Support**: Better support for integrating with external libraries
- **Quantum Components**: All quantum computation now in the extensions repository
- **Tools**: Specialized tools (qbuild, qrun) moved to extensions

## Documentation
- Updated READMEs for each component
- New installation and usage guides
- Migration guide for existing users

## Compatibility
- Full backward compatibility with existing code
- Migration script provided for easy transition

## Scripts and Tools
- build_all.fish - Build both core and extensions
- link_libraries.fish - Create and link shared libraries
- run_core.fish / run_extensions.fish - Run applications
- run_all_tests.fish - Run tests for both components
- install.fish - Installation script
- migrate.fish - Migration script for existing users
