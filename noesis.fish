#!/usr/bin/env fish

# Noesis Central Control Script (Fish Shell)
# A unified command interface for Noesis operations

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set NC (set_color normal)

# Print version information
set VERSION "1.1.0"
set NOESIS_ROOT (dirname (realpath (status filename)))

function print_header
    echo $BLUE"╔════════════════════════════════════════════════════╗"$NC
    echo $BLUE"║"$GREEN"              Noesis Control Center v$VERSION           "$BLUE"║"$NC
    echo $BLUE"╚════════════════════════════════════════════════════╝"$NC
end

function print_usage
    echo $YELLOW"Usage:"$NC" ./noesis.fish <command> [args...]"
    echo
    echo $YELLOW"Common commands:"$NC
    echo "  "$GREEN"build"$NC"        - Build the Noesis core"
    echo "  "$GREEN"run"$NC"          - Run the Noesis core"
    echo "  "$GREEN"test"$NC"         - Run all tests"
    echo "  "$GREEN"clean"$NC"        - Clean up build artifacts"
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
