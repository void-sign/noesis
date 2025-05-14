#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# build_library.sh - Script to build the Noesis libraries
# This script compiles and packages the noesis_libc library

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Building Noesis libraries...${NC}"
echo "=============================="

# Define paths
LIBS_DIR="$(pwd)/libs"
NOESIS_LIBC_DIR="$LIBS_DIR/noesis_libc"
BUILD_DIR="$LIBS_DIR/build"
OBJ_DIR="$BUILD_DIR/obj"
LIB_DIR="$BUILD_DIR/lib"
INCLUDE_DIR="$LIBS_DIR/include"

# Create build directories if they don't exist
mkdir -p "$BUILD_DIR"
mkdir -p "$OBJ_DIR"
mkdir -p "$OBJ_DIR/stdlib"
mkdir -p "$OBJ_DIR/stdio"
mkdir -p "$OBJ_DIR/string"
mkdir -p "$OBJ_DIR/math"
mkdir -p "$OBJ_DIR/unistd"
mkdir -p "$OBJ_DIR/sys"
mkdir -p "$LIB_DIR"

# Define compiler and flags
CC=${CC:-gcc}
CFLAGS="-Wall -Wextra -std=c99 -fPIC -I$INCLUDE_DIR"

echo -e "${YELLOW}Compiling noesis_libc...${NC}"

# Compile noesis_libc source files
compile_source_files() {
    local src_dir="$1"
    local obj_dir="$2"
    local src_files=("$src_dir"/*.c)
    
    for src_file in "${src_files[@]}"; do
        if [ -f "$src_file" ]; then
            filename=$(basename "$src_file")
            obj_file="$obj_dir/${filename%.c}.o"
            echo "  Compiling $filename"
            $CC $CFLAGS -c "$src_file" -o "$obj_file"
            if [ $? -ne 0 ]; then
                echo -e "${RED}Failed to compile $filename${NC}"
                return 1
            fi
        fi
    done
    
    return 0
}

# Compile all source files for each directory
directories=(
    "stdlib"
    "stdio"
    "string"
    "math"
    "unistd"
    "sys"
)

for dir in "${directories[@]}"; do
    echo -e "${YELLOW}Compiling $dir module...${NC}"
    compile_source_files "$LIBS_DIR/src/$dir" "$OBJ_DIR/$dir"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Build failed at $dir module.${NC}"
        exit 1
    fi
done

# Compile main library file
echo -e "${YELLOW}Compiling main library file...${NC}"
$CC $CFLAGS -c "$LIBS_DIR/src/noesis_libc.c" -o "$OBJ_DIR/noesis_libc.o"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to compile main library file.${NC}"
    exit 1
fi

# Collect all object files
echo -e "${YELLOW}Creating libraries...${NC}"
OBJ_FILES=("$OBJ_DIR"/*/*.o "$OBJ_DIR/noesis_libc.o")

# Create static library
echo "  Creating static library libnlibc.a"
ar rcs "$LIB_DIR/libnlibc.a" "${OBJ_FILES[@]}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to create static library.${NC}"
    exit 1
fi

# Create shared library
echo "  Creating shared library libnlibc.so"
$CC -shared -o "$LIB_DIR/libnlibc.so" "${OBJ_FILES[@]}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to create shared library.${NC}"
    exit 1
fi

# Create macOS dynamic library if on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "  Creating macOS dynamic library libnlibc.dylib"
    $CC -dynamiclib -o "$LIB_DIR/libnlibc.dylib" "${OBJ_FILES[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create macOS dynamic library.${NC}"
        exit 1
    fi
fi

# Copy header files to the build directory
echo -e "${YELLOW}Copying header files to build directory...${NC}"
mkdir -p "$BUILD_DIR/include/noesis_libc"
cp -r "$INCLUDE_DIR"/* "$BUILD_DIR/include/noesis_libc/"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to copy header files.${NC}"
    exit 1
fi

# Create pkg-config file
echo -e "${YELLOW}Creating pkg-config file...${NC}"
mkdir -p "$BUILD_DIR/pkgconfig"
cat > "$BUILD_DIR/pkgconfig/noesis_libc.pc" << EOF
prefix=$(dirname "$(pwd)")
exec_prefix=\${prefix}
includedir=\${prefix}/libs/build/include
libdir=\${prefix}/libs/build/lib

Name: Noesis LibC
Description: Custom C standard library for Noesis
Version: 1.0.0
Cflags: -I\${includedir}
Libs: -L\${libdir} -lnlibc
EOF

echo -e "${GREEN}Noesis libraries built successfully!${NC}"
echo ""
echo "Libraries created:"
echo " - Static library: $LIB_DIR/libnlibc.a"
echo " - Shared library: $LIB_DIR/libnlibc.so"
if [[ "$(uname)" == "Darwin" ]]; then
    echo " - macOS dynamic library: $LIB_DIR/libnlibc.dylib"
fi
echo "Header files: $BUILD_DIR/include/noesis_libc/"
echo "Package configuration: $BUILD_DIR/pkgconfig/noesis_libc.pc"
echo ""
echo "To use in other projects, add the following to your compilation flags:"
echo "  CFLAGS=\"-I$BUILD_DIR/include\""
echo "  LDFLAGS=\"-L$LIB_DIR -lnlibc\""
echo ""
echo "Or set PKG_CONFIG_PATH:"
echo "  export PKG_CONFIG_PATH=\"$BUILD_DIR/pkgconfig:\$PKG_CONFIG_PATH\""
echo "  pkg-config --cflags --libs noesis_libc"
echo ""

exit 0