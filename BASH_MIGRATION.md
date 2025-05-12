# Fish to Bash Script Migration

This document summarizes the changes made to convert the Fish shell scripts to Bash shell scripts.

## Scripts Converted

The following scripts were converted from Fish to Bash:

1. `build_all.fish` → `build_all.sh`
2. `cleanup_extensions.fish` → `cleanup_extensions.sh` 
3. `cleanup_folders.fish` → `cleanup_folders.sh`
4. `cleanup_repo.fish` → `cleanup_repo.sh`
5. `install.fish` → `install.sh`
6. `launch_noesis_env.fish` → `launch_noesis_env.sh`
7. `link_libraries.fish` → `link_libraries.sh`
8. `migrate.fish` → `migrate.sh`
9. `run_all_tests.fish` → `run_all_tests.sh`
10. `run_core.fish` → `run_core.sh`
11. `run_noesis.fish` → `run_noesis.sh`
12. `validate_split.fish` → `validate_split.sh`

## Major Syntax Changes

Here are the main syntax changes that were made during the conversion:

1. **Shebang Line**:
   - Fish: `#!/usr/bin/env fish` or `#!/bin/fish`
   - Bash: `#!/bin/bash`

2. **Conditionals**:
   - Fish: `if test -d "dir"; then` or `if test (count $argv) -eq 0`
   - Bash: `if [ -d "dir" ]; then` or `if [ $# -eq 0 ]; then`

3. **Variable Assignment**:
   - Fish: `set variable value`
   - Bash: `variable=value`

4. **Arrays**:
   - Fish: `set -l array_name value1 value2 value3`
   - Bash: `array_name=("value1" "value2" "value3")`

5. **Array Access**:
   - Fish: `$array[1]`, `$argv[2..-1]`
   - Bash: `${array[0]}`, `"${@:2}"`

6. **Command Substitution**:
   - Fish: `set result (command)`
   - Bash: `result=$(command)`

7. **Path Expansion**:
   - Fish: `(pwd)`
   - Bash: `$(pwd)`

8. **Error Checking**:
   - Fish: `if test $status -ne 0`
   - Bash: `if [ $? -ne 0 ]`

9. **Math Operations**:
   - Fish: `set result (math $var + 1)`
   - Bash: `result=$((var + 1))`

10. **Boolean Variables**:
    - Fish: `set -q ERROR`
    - Bash: `[ "$ERROR" = false ]`

## Configuration Updates

Additionally, the following configuration files were updated to use the new Bash scripts:

1. `.vscode/tasks.json` was updated to reference the `.sh` files instead of `.fish` files for build and run tasks.

## Next Steps

All scripts have been verified to work correctly with Bash. The original `.fish` scripts have been moved to the `fish_scripts` directory for reference. Once you've confirmed that everything works as expected, you might want to consider:

1. Removing the `fish_scripts` directory if the scripts are no longer needed
2. Updating any documentation that references the Fish scripts
3. Ensuring any CI/CD pipelines are updated to use the new Bash scripts

## Note

This migration was performed to eliminate the dependency on the Fish shell, making the project more portable and accessible to users who may not have Fish installed on their systems. Bash is available on virtually all Unix-like systems by default.
