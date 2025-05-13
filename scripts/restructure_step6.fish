#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 6
# This script moves bash scripts
#

echo "Step 6: Moving bash scripts..."

# Move bash scripts one by one
if test -d "bash_scripts"
    # Copy specific files
    if test -f "bash_scripts/build_all.sh"
        cp bash_scripts/build_all.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/build_all.sh"
    end
    
    if test -f "bash_scripts/cleanup_extensions.sh"
        cp bash_scripts/cleanup_extensions.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/cleanup_extensions.sh"
    end
    
    if test -f "bash_scripts/cleanup_folders.sh"
        cp bash_scripts/cleanup_folders.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/cleanup_folders.sh"
    end
    
    if test -f "bash_scripts/cleanup_repo.sh"
        cp bash_scripts/cleanup_repo.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/cleanup_repo.sh"
    end
    
    if test -f "bash_scripts/fix_headers.sh"
        cp bash_scripts/fix_headers.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/fix_headers.sh"
    end
    
    if test -f "bash_scripts/install.sh"
        cp bash_scripts/install.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/install.sh"
    end
    
    if test -f "bash_scripts/launch_noesis_env.sh"
        cp bash_scripts/launch_noesis_env.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/launch_noesis_env.sh"
    end
    
    if test -f "bash_scripts/link_libraries.sh"
        cp bash_scripts/link_libraries.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/link_libraries.sh"
    end
    
    if test -f "bash_scripts/migrate.sh"
        cp bash_scripts/migrate.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/migrate.sh"
    end
    
    if test -f "bash_scripts/run_all_tests.sh"
        cp bash_scripts/run_all_tests.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/run_all_tests.sh"
    end
    
    if test -f "bash_scripts/run_core.sh"
        cp bash_scripts/run_core.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/run_core.sh"
    end
    
    if test -f "bash_scripts/run_noesis.sh"
        cp bash_scripts/run_noesis.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/run_noesis.sh"
    end
    
    if test -f "bash_scripts/run_tests.sh"
        cp bash_scripts/run_tests.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/run_tests.sh"
    end
    
    if test -f "bash_scripts/update_headers.sh"
        cp bash_scripts/update_headers.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/update_headers.sh"
    end
    
    if test -f "bash_scripts/update_repo_references.sh"
        cp bash_scripts/update_repo_references.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/update_repo_references.sh"
    end
    
    if test -f "bash_scripts/validate_split.sh"
        cp bash_scripts/validate_split.sh scripts/bash/ 2>/dev/null
        echo "Moved bash_scripts/validate_split.sh"
    end
end

echo "Bash scripts moved successfully!"
echo "Now run restructure_step7.fish"
