#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# check_library.sh - Script to check for required Noesis libraries
# This script verifies the presence and basic functionality of the noesis_libc library

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Checking for Noesis libraries...${NC}"
echo "========================================="

# Define paths to look for libraries
LIB_PATHS=(
    "./libs/lib"
    "./build/lib"
    "/usr/local/lib/noesis"
    "/usr/local/lib"
    "/usr/lib/noesis"
    "/usr/lib"
    "$HOME/.local/lib/noesis"
    "$HOME/.local/lib"
)

# Define library names to look for
LIB_NAMES=(
    "libnlibc.a"
    "libnlibc.so"
    "libnlibc.dylib"  # For macOS
    "libnlibc_stubs.a"
)

# Track if we found any libraries
FOUND_LIBRARIES=false

# Function to check if a file exists and is readable
check_file() {
    if [ -r "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check symbols in a library
check_symbols() {
    local lib_file="$1"
    local lib_name="$(basename "$lib_file")"
    local result=0
    
    echo -e "  Checking symbols in ${YELLOW}$lib_name${NC}:"
    
    # Check if nm command is available
    if ! command -v nm &> /dev/null; then
        echo -e "  ${RED}Warning: 'nm' command not available, skipping symbol check${NC}"
        return 0
    fi
    
    # Important symbols that should be in the library
    local symbols=(
        "nlibc_malloc"
        "nlibc_free"
        "nlibc_printf"
        "nlibc_fprintf"
        "nlibc_stderr"
        "nlibc_strcmp"
        "nlibc_strlen"
    )
    
    # Check each symbol
    for symbol in "${symbols[@]}"; do
        if nm "$lib_file" | grep -q "$symbol"; then
            echo -e "    ${GREEN}✓${NC} Symbol $symbol found"
        else
            echo -e "    ${RED}✗${NC} Symbol $symbol NOT found"
            result=1
        fi
    done
    
    return $result
}

# Look for libraries in all paths
for path in "${LIB_PATHS[@]}"; do
    echo -e "\nChecking ${YELLOW}$path${NC}..."
    
    if [ ! -d "$path" ]; then
        echo -e "  ${RED}Directory does not exist${NC}"
        continue
    fi
    
    # Check each library name in this path
    for lib in "${LIB_NAMES[@]}"; do
        lib_file="$path/$lib"
        if check_file "$lib_file"; then
            echo -e "  ${GREEN}✓ Found:${NC} $lib_file"
            
            # Get file details
            file_info=$(ls -lh "$lib_file")
            echo "  File details: $file_info"
            
            # Check the library symbols
            check_symbols "$lib_file"
            if [ $? -eq 0 ]; then
                FOUND_LIBRARIES=true
            fi
            
            echo ""
        fi
    done
done

# Check if we need to build the libraries
if [ "$FOUND_LIBRARIES" = false ]; then
    echo -e "${RED}No Noesis libraries found!${NC}"
    echo "You may need to build the libraries first with:"
    echo -e "  ${YELLOW}./scripts/bash/build_library.sh${NC}"
    exit 1
else
    echo -e "${GREEN}Noesis libraries check completed successfully.${NC}"
    exit 0
fi