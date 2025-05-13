#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 7
# This script moves source files - API
#

echo "Step 7: Moving API source files..."

# Move API source files
if test -d "source/api"
    # Set up source and destination directories
    set SRC_DIR "source/api"
    set DEST_DIR "src/api"
    
    # Get list of all .c and .h files in the source directory
    set API_FILES (find $SRC_DIR -maxdepth 1 -type f \( -name "*.c" -o -name "*.h" \))
    
    # Copy each file individually
    for file in $API_FILES
        set filename (basename $file)
        cp $file $DEST_DIR/$filename 2>/dev/null
        echo "Copied $file to $DEST_DIR/$filename"
    end
end

echo "API source files moved successfully!"
echo "Now run restructure_step8.fish"
