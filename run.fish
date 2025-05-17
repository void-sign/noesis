#!/usr/bin/env fish

# Current version of Noesis
set -g NOESIS_VERSION "2.2.1"

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

# Function to source all required modules when needed
function load_modules
    source soul/intent.fish
end

# Custom function to get timestamp with improved formatting
function log_with_timestamp
    set message $argv[1]
    set level $argv[2]
    if test -z "$level"
        set level "INFO" # Default log level
    end
    
    # Get current time in the local system's timezone
    set formatted_date (date +"%d %b %Y %H:%M:%S")
    
    # Display the formatted message
    echo
    echo "    $level    "
    echo
    echo "    Time: $formatted_date    "
    echo
    echo "    $message    "
    echo
end

# Function to start a conscious pixel in noesis-web
function awake_conscious_pixel
    log_with_timestamp "Awakening synthetic conscious pixel in noesis-web..." "INFO"
    
    # Check if noesis-web directory exists in the expected location
    set noesis_web_dir "../noesis-web"
    if not test -d $noesis_web_dir
        # If not found in the expected location, try looking in the git folder
        set noesis_web_dir "../git/noesis-web"
        if not test -d $noesis_web_dir
            log_with_timestamp "Could not find noesis-web directory" "ERROR"
            return 1
        end
    end

    # Check if Python is available for the simple HTTP server
    if not command -sq python3
        log_with_timestamp "Python is required to run the HTTP server" "ERROR"
        return 1
    end
    
    # Log the server starting
    log_with_timestamp "Starting HTTP server for noesis-web" "INFO"
    
    # Get the IP address for the server
    set ip_address "localhost"
    if command -sq hostname
        set ip_address (hostname -I 2>/dev/null | string trim)
        if test -z "$ip_address"
            set ip_address "localhost"
        end
    end

    # Start an HTTP server in the noesis-web directory
    echo "$GREEN"Starting HTTP server in $noesis_web_dir"$NC"
    echo "$GREEN"Server URL: http://$ip_address:8000"$NC"
    
    # Open the browser to view the website
    if command -sq open
        echo "$GREEN"Opening browser at http://$ip_address:8000"$NC"
        open "http://$ip_address:8000"
    else
        echo "$YELLOW"Please open your browser and navigate to: http://$ip_address:8000"$NC"
    end
    
    # Change to the noesis-web directory and start a Python HTTP server
    cd $noesis_web_dir && python3 -m http.server 8000
    
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
    echo "  awake             Start a synthetic conscious pixel in noesis-web"
    echo "  logs [date] [level]  View log files with optional filtering"
    echo "  verbose           Toggle verbose debug mode"
    echo
    echo "Without options, Noesis starts in interactive mode."
    return 0
end

# Main function for run.fish
function noesis_main
    # Process command-line arguments
    if test (count $argv) -gt 0
        switch $argv[1]
            case "-v" "--version"
                show_version
                return 0
                
            case "-h" "--help"
                show_help
                return 0
                
            case "awake"
                # Start the conscious pixel in noesis-web
                awake_conscious_pixel
                return $status
                
            case '*'
                echo "$RED"Unknown option: $argv[1]"$NC"
                show_help
                return 1
        end
    else
        # Print banner
        echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
        echo "$PINK  NOESIS v$NOESIS_VERSION            $NC"
        echo "$PINK  SYNTHETIC CONSCIOUS SYSTEM         $NC"
        echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
        echo
        
        # Source intent.fish
        source soul/intent.fish
        
        return 0
    end
end

# Execute noesis_main function with all arguments
noesis_main $argv
exit $status
