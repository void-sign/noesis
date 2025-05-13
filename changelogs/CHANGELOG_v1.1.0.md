# Noesis v1.1.0

## Overview
This version introduces significant improvements to the core functionality, enhances the build system, and improves documentation.

## Major Changes
- Reorganized bash_scripts/ and fish_scripts/ directories for better maintainability
- Enhanced quantum computation modules with improved performance
- Updated the C library implementation for better compatibility
- Improved APIs for external integration
- Added central control scripts for simplified command execution
- Renamed "extend-example" to "hub_example" to align with Noesis Hub repository

## Directory Structure
- Restructured project directories for better organization
- Moved bash scripts from root directory to dedicated bash_scripts/ folder
- Improved organization of include/quantum/ directory with field/ subdirectory
- Renamed extension template folder from "extend-example" to "hub_example"

## Command Interface
- Enhanced noesis.sh and noesis.fish as central command interfaces
- Added colored output and better user guidance
- Implemented shorthand commands for common operations (build, run, test, clean, install)
- Standardized command execution between bash and fish shells

## Documentation
- Updated README.md with accurate directory structure
- Improved build and run instructions for both bash and fish shells
- Added more detailed API documentation
- Added instructions for the new central control scripts

## Build System
- Enhanced Makefile with better dependency tracking
- Added support for parallel builds with improved performance
- Simplified the build process for new contributors

## Bug Fixes
- Fixed memory leaks in the core memory management system
- Resolved issues with quantum field simulations
- Fixed header inclusion problems in various modules

## Date
May 13, 2025
