#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#
# Noesis Central Control Script (Fish Shell)
# A unified command interface for Noesis operations

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

# Print version information
set VERSION "1.1.0"
set NOESIS_ROOT (dirname (realpath (status filename)))

function print_header
    set header_border "╔══════════════════════════════════════════════════════╗"
    set footer_border "╚══════════════════════════════════════════════════════╝"
    set title_text "           Noesis Control Center v$VERSION               "
    
    echo $PINK"$header_border"$NC
    echo $PINK"║$title_text║"$NC
    echo $PINK"$footer_border"$NC
end

function print_usage
    echo $YELLOW"Usage:"$NC" ./noesis.fish <command> [args...]"
    echo
    echo $YELLOW"Common commands:"$NC
    echo "  "$GREEN"build"$NC"        - Build the Noesis core"
    echo "  "$GREEN"run"$NC"          - Run the Noesis core"
    echo "  "$GREEN"test"$NC"         - Run all tests"
    echo "  "$GREEN"clean"$NC"        - Clean up build artifacts"
    echo "  "$GREEN"clean_all"$NC"    - Perform a complete repository cleanup"
    echo "  "$GREEN"install"$NC"      - Install Noesis"
    echo "  "$GREEN"help"$NC"         - Display this help message"
    echo
    echo $YELLOW"All available commands:"$NC
    for script in (ls -1 fish_scripts/ | grep '\.fish$' | sed 's/\.fish$//')
        echo "  "$GREEN"$script"$NC
    end
end

# Handle special commands
switch "$argv[1]"
    case "build"
        print_header
        echo $YELLOW"Building Noesis..."$NC
        fish "fish_scripts/build_all.fish" $argv[2..-1]
        
    case "run"
        print_header
        echo $YELLOW"Running Noesis Core..."$NC
        fish "fish_scripts/run_noesis.fish" $argv[2..-1]
        
    case "test"
        print_header
        echo $YELLOW"Running Noesis tests..."$NC
        fish "fish_scripts/run_all_tests.fish" $argv[2..-1]
        
    case "clean"
        print_header
        echo $YELLOW"Cleaning Noesis build artifacts..."$NC
        fish "fish_scripts/cleanup_folders.fish" $argv[2..-1]
        
    case "clean_all"
        print_header
        echo $YELLOW"Performing complete repository cleanup..."$NC
        
        # First clean build artifacts with make
        echo $PINK"Step 1: Cleaning build artifacts with make..."$NC
        make clean
        
        # Clean up folder structure
        echo $PINK"Step 2: Cleaning up folder structure..."$NC
        fish "fish_scripts/cleanup_folders.fish" $argv[2..-1]
        
        # Clean up repo
        echo $PINK"Step 3: Cleaning up repository..."$NC
        fish "fish_scripts/cleanup_repo.fish" $argv[2..-1]
        
        # Skip extension cleanup if the extension repo doesn't exist
        echo $PINK"Step 4: Checking for extensions..."$NC
        if test -d "/Users/plugio/Documents/GitHub/noesis-extend"
            echo $PINK"  Extensions repository found. Cleaning up extensions..."$NC
            fish "fish_scripts/cleanup_extensions.fish" $argv[2..-1]
        else
            echo $YELLOW"  Extensions repository not found. Skipping extension cleanup."$NC
        end
        
        # Remove object files and binaries
        echo $PINK"Step 5: Removing object files and binaries..."$NC
        # Remove binaries first
        rm -f noesis noesis_tests
        
        # Remove directories if they exist
        for dir in "object" "out" "out_basm" "lib" "obj"
            if test -d $dir
                echo "  Removing directory: $dir/"
                rm -rf $dir/
            end
        end
        
        # Find and remove object files
        echo "  Removing object files..."
        find . -name "*.o" -delete 2>/dev/null || true
        echo "  Removing shared libraries..."
        find . -name "*.so" -delete 2>/dev/null || true
        echo "  Removing static libraries..."
        find . -name "*.a" -delete 2>/dev/null || true
        
        # Remove executable files from debug directory
        if test -d "debug"
            echo "  Removing executable files from debug directory..."
            find debug/ -type f -executable -delete 2>/dev/null || true
        end
        
        echo $GREEN"✓ Complete repository cleanup finished successfully"$NC
    
    case "install"
        print_header
        echo $YELLOW"Installing Noesis..."$NC
        fish "fish_scripts/install.fish" $argv[2..-1]
        
    case "help"
        print_header
        print_usage
        
    case ""
        print_header
        print_usage
        
    case "*"
        # Script name will be the first argument
        set SCRIPT_NAME $argv[1]
        
        # Shift arguments
        set NEW_ARGS $argv[2..-1]
        
        # Check if the script exists
        if test -f "fish_scripts/$SCRIPT_NAME.fish"
            print_header
            echo $YELLOW"Running script: "$GREEN"$SCRIPT_NAME"$NC
            # Execute the script with all remaining arguments
            fish "fish_scripts/$SCRIPT_NAME.fish" $NEW_ARGS
        else
            echo $RED"Error: Command '$SCRIPT_NAME' not found"$NC
            print_usage
            exit 1
        end
end
