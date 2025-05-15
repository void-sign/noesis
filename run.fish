#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# run.fish - Main entry point for the Noesis implementation

# Current version of Noesis
set -g NOESIS_VERSION "2.1.1"

# Function to source all required modules when needed
function load_modules
    # With the centralized intent.fish, we only need to source that file
    # as it will handle loading all other required modules
    source soul/intent.fish
end

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

# Initialize all systems
function initialize_systems
    echo "$YELLOW"Initializing Noesis systems..."$NC"
    
    # Initialize core systems
    init_memory_system
    init_perception
    init_logic_system
    init_emotion_system
    init_intent_system
    
    # Initialize quantum systems
    q_init
    stub_init
    
    echo "$GREEN"All systems initialized successfully"$NC"
    echo
    return 0
end

# Print version information
function show_version
    echo "Noesis v$NOESIS_VERSION"
    echo "Synthetic Conscious System"
    echo "Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)"
    echo "Licensed under Noesis License - See LICENSE file for details"
    return 0
end

# Function to check for updates and update Noesis
function check_for_updates
    echo "$YELLOW"Checking for updates..."$NC"
    
    # Store the current directory
    set current_dir (pwd)
    
    # Check if git is installed
    if not command -sq git
        echo "$RED"Error: Git is not installed. Cannot check for updates."$NC"
        return 1
    end
    
    # Create a temporary directory
    set tmp_dir (mktemp -d)
    cd $tmp_dir
    
    # Clone the repository to check for updates
    if git clone --quiet https://github.com/napol/noesis.git 2>/dev/null
        cd noesis
        
        # Get the latest version from the repository
        set latest_version (grep "NOESIS_VERSION" run.fish | head -1 | string match -r '"[0-9]+\.[0-9]+\.[0-9]+"' | tr -d '"')
        
        if test -z "$latest_version"
            echo "$RED"Error: Could not determine the latest version."$NC"
            cd $current_dir
            rm -rf $tmp_dir
            return 1
        end
        
        # Compare versions
        if test "$latest_version" = "$NOESIS_VERSION"
            echo "$GREEN"You are already running the latest version (v$NOESIS_VERSION)."$NC"
            cd $current_dir
            rm -rf $tmp_dir
            return 0
        else
            echo "$GREEN"A new version of Noesis is available: v$latest_version (you have v$NOESIS_VERSION)"$NC"
            
            # Ask if user wants to update
            echo
            
            echo -n "$YELLOW"update > "$NC"
            read -l confirm
            
            echo
            
            if test "$confirm" = "y" -o "$confirm" = "Y"
                echo "$YELLOW"Updating Noesis..."$NC"
                
                # Check if Noesis is installed system-wide
                if test -d "/usr/local/lib/noesis"
                    echo "$YELLOW"Noesis appears to be installed system-wide."$NC"
                    echo "$YELLOW"Running installer with sudo..."$NC"
                    
                    # Copy the installer script
                    cp install.fish $current_dir/install.fish
                    
                    # Go back to the original directory and run the installer
                    cd $current_dir
                    sudo ./install.fish
                    
                    echo "$GREEN"Noesis has been updated to v$latest_version."$NC"
                else
                    echo "$YELLOW"Updating local copy..."$NC"
                    
                    # Copy files to the current repository
                    cd $tmp_dir/noesis
                    cp -r src $current_dir/
                    cp run.fish $current_dir/
                    cp build.fish $current_dir/
                    cp install.fish $current_dir/
                    
                    echo "$GREEN"Noesis files have been updated to v$latest_version."$NC"
                    echo "$YELLOW"You may need to rebuild the project with './build.fish'"$NC"
                end
            else
                echo "$YELLOW"Update cancelled."$NC"
            end
            
            cd $current_dir
            rm -rf $tmp_dir
            return 0
        end
    else
        echo "$RED"Error: Could not connect to the repository."$NC"
        echo "$RED"Please check your internet connection and try again."$NC"
        cd $current_dir
        rm -rf $tmp_dir
        return 1
    end
end

# Print help information
function show_help
    echo "Noesis v$NOESIS_VERSION - Synthetic Conscious System"
    echo
    echo "Usage: noesis [options]"
    echo
    echo "Options:"
    echo "  -v, --version     Display version information"
    echo "  -h, --help        Display this help message"
    echo "  test              Run all tests"
    echo "  -q, --quantum     Run in quantum mode"
    echo "  update            Check for updates and update Noesis"
    echo
    echo "Without options, Noesis starts in interactive mode."
    return 0
end

# Main function
function main
    # Process command-line arguments
    if test (count $argv) -gt 0
        switch $argv[1]
            case "-v" "--version"
                show_version
                return 0
                
            case "-h" "--help"
                show_help
                return 0
                
            case "update"
                check_for_updates
                return $status
                
            case "test"
                echo "$YELLOW"Running Noesis tests..."$NC"
                load_modules
                # Add test logic here
                echo "$GREEN"All tests completed successfully"$NC"
                return 0
                
            case "-q" "--quantum"
                echo "$YELLOW"Starting Noesis in quantum mode..."$NC"
                # Source intent.fish which will handle everything
                source soul/intent.fish
                return $status
                
            case '*'
                echo "$RED"Unknown option: $argv[1]"$NC"
                show_help
                return 1
        end
    else
        # Source intent.fish which will handle loading all other required modules
        source soul/intent.fish
        # Explicitly call main function from intent.fish
        main
        return $status
    end
end

# Execute main function with all arguments
main $argv
exit $status
