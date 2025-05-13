#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#
# Updated runner script for Noesis Core
# Note: Noesis-Extend is now in a separate repository

# Check if we're running in the legacy structure
if [ -d "./noesis-core" ] && [ -d "./noesis-extensions" ]; then
    # Legacy structure detected
    echo "Legacy directory structure detected."
    echo "Note: Noesis-Extend is now in a separate repository."
    echo
    
    if [ $# -eq 0 ]; then
        echo "Noesis Runner"
        echo "============"
        echo "Usage: ./run_noesis.sh [core|ext|all]"
        echo
        echo "Options:"
        echo "  core - Run the Noesis Core component"
        echo "  ext  - Run the Noesis Extensions component (DEPRECATED)"
        echo "  all  - Run both components sequentially (DEPRECATED)"
        echo
        echo "Note: The 'ext' and 'all' options are deprecated."
        echo "For extensions, please use the separate Noesis-Extend repository."
        echo
        exit 0
    fi

    case "$1" in
        "core")
            echo "Running Noesis Core..."
            ./run_core.sh "${@:2}"
            ;;
        "ext"|"extension"|"extensions")
            echo "Running Noesis Extensions..."
            ./run_extensions.sh "${@:2}"
            ;;
        "all")
            echo "Running Noesis Core..."
            ./run_core.sh
            echo -e "\nRunning Noesis Extensions..."
            ./run_extensions.sh
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: ./run_noesis.sh [core|ext|all]"
            exit 1
            ;;
    esac
else
    # Legacy structure
    # Make sure the program is built
    if [ ! -f "./noesis" ]; then
        echo "Building Noesis (legacy mode)..."
        make
    fi

    # Run the program with improved filter to completely remove the unwanted characters
    # stdbuf ensures output isn't buffered
    # sed removes non-printable characters
    # second sed replaces any remaining garbage at the beginning
    stdbuf -o0 ./noesis | 
        sed 's/[^[:print:]]//g' | 
        sed '1s/^[^A-Za-z0-9 ]*NOESIS/NOESIS/'
fi
