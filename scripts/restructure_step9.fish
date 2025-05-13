#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 9
# This script moves source files - Quantum
#

echo "Step 9: Moving Quantum source files..."

# Move Quantum source files
if test -d "source/quantum"
    # Set up source and destination directories
    set SRC_DIR "source/quantum"
    set DEST_DIR "src/quantum"
    
    # Get list of all .c and .h files in the source directory (not in subdirectories)
    set QUANTUM_FILES (find $SRC_DIR -maxdepth 1 -type f \( -name "*.c" -o -name "*.h" \))
    
    # Copy each file individually
    for file in $QUANTUM_FILES
        set filename (basename $file)
        cp $file $DEST_DIR/$filename 2>/dev/null
        echo "Copied $file to $DEST_DIR/$filename"
    end
end

# Move Quantum/Field source files
if test -d "source/quantum/field"
    # Set up source and destination directories
    set SRC_DIR "source/quantum/field"
    set DEST_DIR "src/quantum/field"
    
    # Get list of all .c and .h files in the source directory
    set FIELD_FILES (find $SRC_DIR -maxdepth 1 -type f \( -name "*.c" -o -name "*.h" \))
    
    # Copy each file individually
    for file in $FIELD_FILES
        set filename (basename $file)
        cp $file $DEST_DIR/$filename 2>/dev/null
        echo "Copied $file to $DEST_DIR/$filename"
    end
end

echo "Quantum source files moved successfully!"
echo "Now run restructure_step10.fish"
