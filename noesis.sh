#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#
# Noesis Central Control Script
# A unified command interface for Noesis operations

# Define colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PINK='\033[38;5;206m' # Bright pink
NC='\033[0m' # No Color
TITLE='Noesis Control Center v.'

# Print version information
VERSION="1.1.0"

# Fallback for realpath if it doesn't exist
realpath_fallback() {
    local path="$1"
    if command -v realpath >/dev/null 2>&1; then
        realpath "$path"
    else
        # Fallback implementation
        [[ $path = /* ]] || path="$PWD/$path"
        echo "$path"
    fi
}

NOESIS_ROOT=$(dirname "$(realpath_fallback "$0")")

print_header() {
    echo -e "${PINK}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${PINK}║ ${TITLE}${VERSION}                        ║${NC}"
    echo -e "${PINK}╚══════════════════════════════════════════════════════╝${NC}"
}

print_usage() {
    echo -e "${YELLOW}Usage:${NC} ./noesis.sh <command> [args...]"
    echo
    echo -e "${YELLOW}Common commands:${NC}"
    echo -e "  ${GREEN}build${NC}        - Build the Noesis core"
    echo -e "  ${GREEN}run${NC}          - Run the Noesis core"
    echo -e "  ${GREEN}test${NC}         - Run all tests"
    echo -e "  ${GREEN}clean${NC}        - Clean up build artifacts"
    echo -e "  ${GREEN}clean_all${NC}    - Perform a complete repository cleanup"
    echo -e "  ${GREEN}install${NC}      - Install Noesis"
    echo -e "  ${GREEN}help${NC}         - Display this help message"
    echo
    echo -e "${YELLOW}All available commands:${NC}"
    ls -1 scripts/bash/ | grep '\.sh$' | sed 's/\.sh$//' | while read -r script; do
        echo -e "  ${GREEN}${script}${NC}"
    done
}

# Handle special commands
case "$1" in
    "build")
        print_header
        echo -e "${YELLOW}Building Noesis...${NC}"
        bash "scripts/bash/build_all.sh" "${@:2}"
        ;;
    "run")
        print_header
        echo -e "${YELLOW}Running Noesis Core...${NC}"
        bash "scripts/bash/run_core.sh" "${@:2}"
        ;;
    "test")
        print_header
        echo -e "${YELLOW}Running Noesis tests...${NC}"
        bash "scripts/bash/run_all_tests.sh" "${@:2}"
        ;;
    "clean")
        print_header
        echo -e "${YELLOW}Cleaning Noesis build artifacts...${NC}"
        bash "scripts/bash/cleanup_folders.sh" "${@:2}"
        ;;
    "clean_all")
        print_header
        echo -e "${YELLOW}Performing complete repository cleanup...${NC}"
        
        # First clean build artifacts with make
        echo -e "${PINK}Step 1: Cleaning build artifacts with make...${NC}"
        make clean
        
        # Clean up folder structure
        echo -e "${PINK}Step 2: Cleaning up folder structure...${NC}"
        bash "scripts/bash/cleanup_folders.sh" "${@:2}"
        
        # Clean up repo
        echo -e "${PINK}Step 3: Cleaning up repository...${NC}"
        bash "scripts/bash/cleanup_repo.sh" "${@:2}"
        
        # Skip extension cleanup if the extension repo doesn't exist
        echo -e "${PINK}Step 4: Checking for extensions...${NC}"
        if [ -d "/Users/plugio/Documents/GitHub/noesis-extend" ]; then
            echo -e "${PINK}  Extensions repository found. Cleaning up extensions...${NC}"
            bash "scripts/bash/cleanup_extensions.sh" "${@:2}"
        else
            echo -e "${YELLOW}  Extensions repository not found. Skipping extension cleanup.${NC}"
        fi
        
        # Remove object files and binaries
        echo -e "${PINK}Step 5: Removing object files and binaries...${NC}"
        # Remove binaries first
        rm -f noesis noesis_tests
        
        # Remove directories if they exist
        for dir in "object" "out" "out_basm" "lib" "obj"; do
            if [ -d "$dir" ]; then
                echo "  Removing directory: $dir/"
                rm -rf "$dir/"
            fi
        done
        
        # Find and remove object files
        echo "  Removing object files..."
        find . -name "*.o" -delete 2>/dev/null || true
        echo "  Removing shared libraries..."
        find . -name "*.so" -delete 2>/dev/null || true
        echo "  Removing static libraries..."
        find . -name "*.a" -delete 2>/dev/null || true
        
        # Remove executable files from debug directory
        if [ -d "debug" ]; then
            echo "  Removing executable files from debug directory..."
            find debug/ -type f -executable -delete 2>/dev/null || true
        fi
        
        echo -e "${GREEN}✓ Complete repository cleanup finished successfully${NC}"
        ;;
    "install")
        print_header
        echo -e "${YELLOW}Installing Noesis...${NC}"
        bash "scripts/bash/install.sh" "${@:2}"
        ;;

    "help")
        print_header
        print_usage
        ;;
    "")
        print_header
        print_usage
        ;;
    *)
        # Script name will be the first argument
        SCRIPT_NAME=$1
        shift 1

        # Check if the script exists
        if [ -f "scripts/bash/${SCRIPT_NAME}.sh" ]; then
            print_header
            echo -e "${YELLOW}Running script: ${GREEN}${SCRIPT_NAME}${NC}"
            # Execute the script with all remaining arguments
            bash "scripts/bash/${SCRIPT_NAME}.sh" "$@"
        else
            echo -e "${RED}Error: Command '${SCRIPT_NAME}' not found${NC}"
            print_usage
            exit 1
        fi
        ;;
esac
