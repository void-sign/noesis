#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 5
# This script moves shell scripts
#

echo "Step 5: Moving fish scripts..."

# Move fish scripts one by one
if test -d "fish_scripts"
    # Copy specific files
    if test -f "fish_scripts/build_all.fish"
        cp fish_scripts/build_all.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/build_all.fish"
    end
    
    if test -f "fish_scripts/cleanup_extensions.fish"
        cp fish_scripts/cleanup_extensions.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/cleanup_extensions.fish"
    end
    
    if test -f "fish_scripts/cleanup_folders.fish"
        cp fish_scripts/cleanup_folders.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/cleanup_folders.fish"
    end
    
    if test -f "fish_scripts/cleanup_repo.fish"
        cp fish_scripts/cleanup_repo.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/cleanup_repo.fish"
    end
    
    if test -f "fish_scripts/fix_comments.fish"
        cp fish_scripts/fix_comments.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/fix_comments.fish"
    end
    
    if test -f "fish_scripts/fix_headers.fish"
        cp fish_scripts/fix_headers.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/fix_headers.fish"
    end
    
    if test -f "fish_scripts/fix_quantum_headers.fish"
        cp fish_scripts/fix_quantum_headers.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/fix_quantum_headers.fish"
    end
    
    if test -f "fish_scripts/install.fish"
        cp fish_scripts/install.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/install.fish"
    end
    
    if test -f "fish_scripts/launch_noesis_env.fish"
        cp fish_scripts/launch_noesis_env.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/launch_noesis_env.fish"
    end
    
    if test -f "fish_scripts/link_libraries.fish"
        cp fish_scripts/link_libraries.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/link_libraries.fish"
    end
    
    if test -f "fish_scripts/migrate.fish"
        cp fish_scripts/migrate.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/migrate.fish"
    end
    
    if test -f "fish_scripts/README.md"
        cp fish_scripts/README.md scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/README.md"
    end
    
    if test -f "fish_scripts/run_all_tests.fish"
        cp fish_scripts/run_all_tests.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/run_all_tests.fish"
    end
    
    if test -f "fish_scripts/run_core.fish"
        cp fish_scripts/run_core.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/run_core.fish"
    end
    
    if test -f "fish_scripts/run_noesis.fish"
        cp fish_scripts/run_noesis.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/run_noesis.fish"
    end
    
    if test -f "fish_scripts/validate_split.fish"
        cp fish_scripts/validate_split.fish scripts/fish/ 2>/dev/null
        echo "Moved fish_scripts/validate_split.fish"
    end
end

echo "Fish scripts moved successfully!"
echo "Now run restructure_step6.fish"
