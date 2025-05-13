# Noesis Project Restructuring: Restart Guide

This document outlines how to restart the restructuring process from the last saved state.

## Method 1: Using Simple Commands (Recommended)

Use the following simple commands to save or restore the project structure:

```bash
# Using the short ncom command (recommended)
./ncom save       # For fish shell
./ncom.sh save    # For bash shell

# To restore the latest saved structure state
./ncom continue      # For fish shell
./ncom.sh continue   # For bash shell

# Using short aliases
./ncom -s     # Save structure state
./ncom -c     # Continue from latest state

# Using the longer noesis command
./noesis.fish save      # For fish shell
./noesis.sh save        # For bash shell
./noesis.fish continue  # For fish shell
./noesis.sh continue    # For bash shell
```

For more information about the `ncom` command, see [NCOM.md](NCOM.md).

## Method 2: Using Git Tag

If you're working with the Git repository, you can use the saved Git tag to return to a specific state:

```bash
# Check available restructure state tags
git tag | grep restructure-state

# Go back to a specific state (replace TIMESTAMP with the actual timestamp)
git checkout restructure-state-20250513212544
```

## Method 3: Using Saved Structure Files Directly

If you need to restore a specific saved state manually:

```bash
# For bash users
./scripts/restore_structure_state.sh 20250513212544

# For fish users
fish ./scripts/restore_structure_state.fish 20250513212544
```

For more detailed information about structure management, see [STRUCTURE_MANAGEMENT.md](STRUCTURE_MANAGEMENT.md).

## Current Status of Restructuring

As of the saved state (May 13, 2025), the following tasks have been completed:

1. Created directory structure according to the plan in `docs/RESTRUCTURE_PLAN.md`
2. Moved source code from `source/` to `src/`
3. Moved documentation files to `docs/`
4. Moved `noesis_libc` to `libs/noesis_libc`
5. Updated Makefile to use new directory paths
6. Created script directories in `scripts/bash/` and `scripts/fish/`

Pending tasks:

1. Move test files from `tests/` root into appropriate `tests/unit/` subdirectories
2. Update build scripts to use the new directory structure
3. Create new run scripts or update existing ones
4. Test if the build system works with the new structure
5. Remove the backup directory once everything is verified

## Directory Structure

The current directory structure is saved in `docs/directory_structure_20250513212544.txt`.

## Configuration Files

- Makefile: Saved as `docs/Makefile_20250513212544`
- VS Code tasks: Saved as `docs/tasks.json_20250513212544`
- .gitignore: Saved as `docs/gitignore_20250513212544`

## Next Steps

After restoring the state:

1. Test building the project with `make clean && make`
2. Update remaining scripts to use the new directory structure
3. Verify all functionality works correctly
4. Complete any remaining tasks from the restructuring plan

For the complete restructuring plan, see `docs/RESTRUCTURE_PLAN.md`.
