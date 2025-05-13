#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 8
# This script moves source files - Core
#

echo "Step 8: Moving Core source files..."

# Move Core source files
if test -d "source/core"
    # Set up source and destination directories
    set SRC_DIR "source/core"
    set DEST_DIR "src/core"
    
    # Get list of all .c and .h files in the source directory
    set CORE_FILES (find $SRC_DIR -maxdepth 1 -type f \( -name "*.c" -o -name "*.h" \))
    
    # Copy each file individually
    for file in $CORE_FILES
        set filename (basename $file)
        cp $file $DEST_DIR/$filename 2>/dev/null
        echo "Copied $file to $DEST_DIR/$filename"
    end
end

echo "Core source files moved successfully!"
echo "Now run restructure_step9.fish"
