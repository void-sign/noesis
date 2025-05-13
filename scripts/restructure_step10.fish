#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 10
# This script moves source files - Utils
#

echo "Step 10: Moving Utils source files..."

# Move Utils source files
if test -d "source/utils"
    # Set up source and destination directories
    set SRC_DIR "source/utils"
    set DEST_DIR "src/utils"
    
    # Get list of all .c and .h files in the source directory (not in subdirectories)
    set UTILS_FILES (find $SRC_DIR -maxdepth 1 -type f \( -name "*.c" -o -name "*.h" \))
    
    # Copy each file individually
    for file in $UTILS_FILES
        set filename (basename $file)
        cp $file $DEST_DIR/$filename 2>/dev/null
        echo "Copied $file to $DEST_DIR/$filename"
    end
end

# Move Utils/asm source files
if test -d "source/utils/asm"
    # Set up source and destination directories
    set SRC_DIR "source/utils/asm"
    set DEST_DIR "src/utils/asm"
    
    # Get list of all .s files in the source directory
    set ASM_FILES (find $SRC_DIR -maxdepth 1 -type f -name "*.s")
    
    # Copy each file individually
    for file in $ASM_FILES
        set filename (basename $file)
        cp $file $DEST_DIR/$filename 2>/dev/null
        echo "Copied $file to $DEST_DIR/$filename"
    end
end

echo "Utils source files moved successfully!"
echo "Now run restructure_step11.fish"
