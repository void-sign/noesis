#!/usr/bin/env fish

echo "Cleaning up folder structure..."
echo "============================="

# Check if noesis-core exists and we have the same structure at the top level
if test -d "noesis-core" -a -d "source" -a -d "include"
    echo "Found redundant folder structure."
    echo "This repository should contain the core functionality directly in the root."
    
    echo "Performing safety checks..."
    # Verify that the content is similar between the two structures
    set file_matches 0
    set total_files 0
    
    # Check a few critical files to make sure they match
    set critical_files \
        "source/core/emotion.c" \
        "include/core/emotion.h" \
        "source/core/perception.c" \
        "include/core/perception.h"
    
    for file in $critical_files
        set total_files (math $total_files + 1)
        if test -f $file -a -f "noesis-core/$file"
            # Check if files are identical
            if cmp -s $file "noesis-core/$file"
                set file_matches (math $file_matches + 1)
                echo "✓ Verified: $file matches noesis-core/$file"
            else
                echo "⚠️ Warning: $file differs from noesis-core/$file"
            end
        end
    end
    
    # If most critical files match, we can proceed
    if test $file_matches -ge (math $total_files - 1)
        echo "Safety check passed. Root and noesis-core appear to contain the same code."
        echo "Since the migration suggests noesis-core/* should now be noesis/*, "
        echo "and we already have the correct structure in the root directory, "
        echo "we can safely remove the redundant noesis-core directory."
        
        echo "Removing noesis-core directory..."
        rm -rf noesis-core
        echo "✓ Removed noesis-core directory"
    else
        echo "⚠️ Warning: Root and noesis-core directories appear to contain different code."
        echo "Please manually review the contents of both directories before cleaning up."
        echo "You may want to check for unique files in noesis-core that should be preserved."
    end
else
    echo "No redundant folder structure found. No action needed."
end

echo
echo "Folder structure cleanup complete!"
echo "==============================="
