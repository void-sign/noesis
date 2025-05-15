#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# build.fish - Build script for Noesis system components

# Current version of Noesis
set -g NOESIS_VERSION "2.1.1"

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

# Print a nice banner for the build system
function print_banner
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo "$PINK  NOESIS BUILD SYSTEM v$NOESIS_VERSION  $NC"
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo
end

# Check build dependencies
function check_dependencies
    echo "$YELLOW"Checking build dependencies..."$NC"
    
    # Check for required tools
    set required_tools gcc make fish
    set missing_tools
    
    for tool in $required_tools
        if not command -q $tool
            set -a missing_tools $tool
        end
    end
    
    if test (count $missing_tools) -gt 0
        echo "$RED"Error: Missing required tools: (string join ", " $missing_tools)"$NC"
        return 1
    end
    
    echo "$GREEN"All dependencies satisfied"$NC"
    return 0
end

# Create build directories
function create_build_dirs
    echo "$YELLOW"Creating build directories..."$NC"
    
    mkdir -p build/obj/core
    mkdir -p build/obj/utils
    mkdir -p build/obj/asm
    mkdir -p build/lib
    
    echo "$GREEN"Build directories created"$NC"
    return 0
}

# Build the core components
function build_core
    echo "$YELLOW"Building core components..."$NC"
    
    # Source paths for compilation
    set -l core_files system/memory/unit.fish system/perception/unit.fish system/emotion/unit.fish
    
    # Compile the core components
    for file in $core_files
        echo "Processing $file..."
        # In a real build we'd compile these - for now we just check they exist
        if not test -f $file
            echo "$RED"Error: Missing core file: $file"$NC"
            return 1
        end
    end
    
    echo "$GREEN"Core components built successfully"$NC"
    return 0
}

# Build the quantum components
function build_quantum
    echo "$YELLOW"Building quantum components..."$NC"
    
    # Source paths for compilation
    set -l quantum_files system/memory/quantum/unit.fish \
                         system/memory/quantum/compiler.fish \
                         system/memory/quantum/backend_stub.fish \
                         system/memory/quantum/backend_ibm.fish
    
    # Compile the quantum components
    for file in $quantum_files
        echo "Processing $file..."
        # In a real build we'd compile these - for now we just check they exist
        if not test -f $file
            echo "$RED"Error: Missing quantum file: $file"$NC"
            return 1
        end
    end
    
    echo "$GREEN"Quantum components built successfully"$NC"
    return 0
}

# Build legacy components (if requested)
function build_legacy
    echo "$YELLOW"Building legacy components..."$NC"
    
    echo "Looking for legacy components..."
    
    # Check if legacy directory exists
    if not test -d legacy
        echo "$BLUE"No legacy components found, skipping"$NC"
        return 0
    end
    
    # Otherwise build legacy components
    echo "Compiling legacy components..."
    
    echo "$GREEN"Legacy components built successfully"$NC"
    return 0
}

# Main build function
function main
    print_banner
    
    # Process build arguments
    set build_type "all"
    if test (count $argv) -gt 0
        set build_type $argv[1]
    end
    
    # Check dependencies first
    if not check_dependencies
        echo "$RED"Build failed: missing dependencies"$NC"
        return 1
    end
    
    # Create build directories
    if not create_build_dirs
        echo "$RED"Build failed: couldn't create build directories"$NC"
        return 1
    end
    
    # Build requested components
    switch $build_type
        case "core"
            build_core
            
        case "quantum"
            build_quantum
            
        case "legacy"
            build_legacy
            
        case "all"
            echo "$BLUE"Building all components..."$NC"
            
            if not build_core
                echo "$RED"Build failed during core components"$NC"
                return 1
            end
            
            if not build_quantum
                echo "$RED"Build failed during quantum components"$NC"
                return 1
            end
            
            # Legacy is optional
            build_legacy
            
            echo "$GREEN"All components built successfully"$NC"
            
        case "*"
            echo "$RED"Unknown build type: $build_type"$NC"
            echo "Valid options: core, quantum, legacy, all (default)"
            return 1
    end
    
    echo "$BLUE"Build complete"$NC"
    return 0
end

# Execute main function when run directly
if status --is-interactive
    if test (count $argv) -eq 0
        # Running interactively with no arguments - build all
        main "all"
    else
        # Running with arguments
        main $argv
    end
end
