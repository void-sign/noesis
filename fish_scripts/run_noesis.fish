#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#



# Updated runner script for Noesis Core
# Note: Noesis-Extend is now in a separate repository

# Check if we're running in the legacy structure
if test -d "./noesis-core" -a -d "./noesis-extensions"
    # Legacy structure detected
    echo "Legacy directory structure detected."
    echo "Note: Noesis-Extend is now in a separate repository."
    echo
    
    if test (count $argv) -eq 0
        echo "Noesis Runner"
        echo "============"
        echo "Usage: ./run_noesis.fish [core|ext|all]"
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
    end

    switch $argv[1]
        case "core"
            echo "Running Noesis Core..."
            ./run_core.fish $argv[2..-1]
        case "ext" "extension" "extensions"
            echo "Running Noesis Extensions..."
            ./run_extensions.fish $argv[2..-1]
        case "all"
            echo "Running Noesis Core..."
            ./run_core.fish
            echo -e "\nRunning Noesis Extensions..."
            ./run_extensions.fish
        case '*'
            echo "Unknown option: $argv[1]"
            echo "Usage: ./run_noesis.fish [core|ext|all]"
            exit 1
    end
else
    # Legacy structure
    # Make sure the program is built
    if not test -f "./noesis"
        echo "Building Noesis (legacy mode)..."
        make
    end

    # Run the program with improved filter to remove unwanted characters
    # stdbuf ensures output isn't buffered
    # sed removes non-printable characters
    # second sed replaces any remaining garbage at the beginning
    stdbuf -o0 ./noesis | 
        sed 's/[^[:print:]]//g' | 
        sed '1s/^[^A-Za-z0-9 ]*NOESIS/NOESIS/'
end
