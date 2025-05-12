# CHANGELOG for Noesis v0.1.2

## Overview
This version fixes a critical bug in the `noesis_read` function that was causing infinite loops and error messages.

## Bug Fixes
- Fixed an infinite loop in the `_noesis_read` assembly function in `io.s`
- Fixed error handling in I/O operations
- Added proper buffer validation in the reader function
- Fixed return value handling for the `noesis_read` function
- Implemented actual input reading from stdin rather than using hardcoded values

## Improvements
- Added a C helper function to simplify the assembly implementation
- Organized test and debug code in a dedicated directory
- Added scripts for easier running of the program and tests
- Updated function signatures to return proper status codes
- Improved error handling throughout the codebase

## New Features
- Added a simple command processing system
- Implemented a "help" command

## Internal Changes
- Improved code organization with test and debug code separated
- Added detailed documentation for the test and debug code
- Simplified assembly code by offloading complex logic to C helper functions
