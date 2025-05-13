# Legacy Fish Shell Scripts

This directory contains the original Fish shell scripts that were used in the Noesis project before the migration to Bash scripts.

## Migration Context

As documented in `/BASH_MIGRATION.md`, these scripts have been converted to Bash equivalents (`.sh` files) in the main project directory. The conversion was done to eliminate the dependency on the Fish shell and make the project more portable across different Unix-like environments.

## Script Mapping

Each `.fish` script in this directory has a corresponding `.sh` script in the main project directory:

| Fish Script | Bash Equivalent |
|-------------|----------------|
| `build_all.fish` | `../build_all.sh` |
| `cleanup_extensions.fish` | `../cleanup_extensions.sh` |
| `cleanup_folders.fish` | `../cleanup_folders.sh` |
| `cleanup_repo.fish` | `../cleanup_repo.sh` |
| `install.fish` | `../install.sh` |
| `launch_noesis_env.fish` | `../launch_noesis_env.sh` |
| `link_libraries.fish` | `../link_libraries.sh` |
| `migrate.fish` | `../migrate.sh` |
| `run_all_tests.fish` | `../run_all_tests.sh` |
| `run_core.fish` | `../run_core.sh` |
| `run_noesis.fish` | `../run_noesis.sh` |
| `validate_split.fish` | `../validate_split.sh` |

## Note

These scripts are kept for reference purposes only and are no longer actively used in the project. All users should use the Bash scripts in the main project directory instead.

**Last Updated:** May 12, 2025
