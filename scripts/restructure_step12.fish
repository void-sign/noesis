#!/usr/bin/env fish
#
# Noesis Project Structure Reorganization Script - Step 12
# This script moves noesis_libc to libs directory and updates Makefile
#

echo "Step 12: Moving noesis_libc to libs directory..."

# Move noesis_libc to libs directory
if test -d "noesis_libc" -a ! -d "libs/noesis_libc"
    cp -r noesis_libc/ libs/ 2>/dev/null
    echo "Copied noesis_libc to libs directory"
end

echo "Step 12a: Updating Makefile for new directory structure..."
# Backup original Makefile
cp Makefile Makefile.original
echo "Created Makefile backup: Makefile.original"

# Update paths in Makefile
sed -i '' 's|SRC_DIR = source|SRC_DIR = src|g' Makefile
sed -i '' 's|OBJ_DIR = object|OBJ_DIR = build/obj|g' Makefile
sed -i '' 's|BIN_DIR = bin|BIN_DIR = build/bin|g' Makefile 
sed -i '' 's|ASM_DIR = source/utils/asm|ASM_DIR = src/utils/asm|g' Makefile
sed -i '' 's|-Inoesis_libc/include|-Ilibs/noesis_libc/include|g' Makefile
sed -i '' 's|LIBPATH = -L/Users/plugio/Documents/GitHub/noesis/lib|LIBPATH = -L/Users/plugio/Documents/GitHub/noesis/build/lib|g' Makefile

echo "Makefile updated successfully!"
echo "Restructuring completed! Please check the new structure."
echo 
echo "To verify the new structure, run:"
echo "make clean"
echo "make"
echo "./noesis"
