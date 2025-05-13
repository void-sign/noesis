#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 11
# This script moves source files - Tools
#

echo "Step 11: Moving Tools source files..."

# Move Tools source files
if test -d "source/tools"
    # Set up source and destination directories
    set SRC_DIR "source/tools"
    set DEST_DIR "src/tools"
    
    # Get list of all .c and .h files in the source directory
    set TOOLS_FILES (find $SRC_DIR -maxdepth 1 -type f \( -name "*.c" -o -name "*.h" \))
    
    # Copy each file individually
    for file in $TOOLS_FILES
        set filename (basename $file)
        cp $file $DEST_DIR/$filename 2>/dev/null
        echo "Copied $file to $DEST_DIR/$filename"
    end
end

echo "Tools source files moved successfully!"
echo "Now run restructure_step12.fish"
