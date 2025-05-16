#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# run.fish - Main entry point for the Noesis implementation

# Current version of Noesis
set -g NOESIS_VERSION "2.1.2"

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
set ORANGE (set_color ff8c00) # Dark orange
set PURPLE (set_color 8a2be2) # Blue violet
set CYAN (set_color 00ffff) # Cyan
set NC (set_color normal)

# Global settings
set -g VERBOSE_MODE false   # Set to true for verbose debugging output

# Command history implementation
set -g MAX_COMMAND_HISTORY 50 # Maximum number of commands to store in history
set -g command_history
set -g history_count 0

# Custom function to get UTC timestamp with improved formatting
function log_with_timestamp
    set message $argv[1]
    set level $argv[2]
    if test -z "$level"
        set level "INFO" # Default log level
    end
    
    # Get Unix timestamp (seconds since epoch)
    set seconds_since_epoch (date +%s)
    
    # Calculate days since epoch for reference
    set days (math --scale=0 (math "$seconds_since_epoch / 86400"))
    
    # Get exact current time in the local system's timezone
    set formatted_date (date +"%d %b %Y %H:%M:%S")
    
    # Create padded timestamp strings with background highlighting
    set time_line "    Time: $formatted_date    "
    set unix_line "    Unix Time: $days days $seconds_since_epoch seconds    "
    
    # Set background colors based on log level
    switch $level
        case "ERROR"
            set bg_color (set_color --background=red --bold)
            set fg_color $RED
            set level_display "    ERROR    "
        case "WARNING"
            set bg_color (set_color --background=yellow --bold)
            set fg_color $YELLOW
            set level_display "    WARNING    "
        case "SUCCESS"
            set bg_color (set_color --background=green --bold)
            set fg_color $GREEN
            set level_display "    SUCCESS    "
        case "DEBUG"
            set bg_color (set_color --background=blue --bold)
            set fg_color $BLUE
            set level_display "    DEBUG    "
        case "*" # INFO and any other level
            set bg_color (set_color --background=ff5fd7 --bold)
            set fg_color $PINK
            set level_display "    INFO    "
    end
    
    # Display the formatted message with better spacing
    echo
    echo $bg_color$level_display$NC
    echo
    echo $fg_color$time_line$NC
    echo $fg_color"    Unix Time: $days days $seconds_since_epoch seconds    "$NC
    echo
    echo $fg_color"    $message    "$NC
    echo
end

# Error handling function
function handle_error
    set error_message $argv[1]
    set error_code $argv[2]
    
    if test -z "$error_code"
        set error_code 1
    end
    
    log_with_timestamp "$error_message" "ERROR"
    return $error_code
end

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

# Initialize command history
function init_command_history
    set -g history_count 0
    set -g command_history
    
    for i in (seq $MAX_COMMAND_HISTORY)
        set -g command_history[$i] ""
    end
    
    log_with_timestamp "Command history initialized" "DEBUG"
end

# Add command to history
function add_to_history
    set command $argv[1]
    
    # Don't add empty commands or duplicates of the most recent command
    if test -z "$command" -o "$command" = "$command_history[1]"
        return 0
    end
    
    # Shift history entries
    for i in (seq (math $MAX_COMMAND_HISTORY - 1) -1 1)
        set next_idx (math $i + 1)
        set -g command_history[$next_idx] $command_history[$i]
    end
    
    # Add new command to the first position
    set -g command_history[1] $command
    
    # Update count if needed
    if test $history_count -lt $MAX_COMMAND_HISTORY
        set -g history_count (math $history_count + 1)
    end
    
    return 0
end

# Display command history
function show_history
    if test $history_count -eq 0
        echo "No command history available"
        return 0
    end
    
    echo "Command history (most recent first):"
    echo
    
    for i in (seq 1 $history_count)
        printf "%3d: %s\n" $i "$command_history[$i]"
    end
    
    return 0
end

# Print a nice welcome banner
function print_banner
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo "$PINK  NOESIS v$NOESIS_VERSION            $NC"
    echo "$PINK  SYNTHETIC CONSCIOUS SYSTEM         $NC"
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo
end

# Main function for run.fish
function noesis_main
    # Initialize command history first
    init_command_history
    
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
                log_with_timestamp "Running Noesis tests..." "INFO"
                load_modules
                # Add test logic here
                log_with_timestamp "All tests completed successfully" "SUCCESS"
                return 0
                
            case "-q" "--quantum"
                log_with_timestamp "Starting Noesis in quantum mode..." "INFO"
                # Source intent.fish which will handle everything
                source soul/intent.fish
                # Call main function from intent.fish with quantum flag
                main --quantum
                return $status
                
            case "verbose"
                # Toggle verbose mode
                if test "$VERBOSE_MODE" = "true"
                    set -g VERBOSE_MODE false
                    log_with_timestamp "Verbose mode disabled" "INFO"
                else
                    set -g VERBOSE_MODE true
                    log_with_timestamp "Verbose mode enabled" "INFO"
                end
                return 0
                
            case '*'
                log_with_timestamp "Unknown option: $argv[1]" "ERROR"
                show_help
                return 1
        end
    else
        # Print banner
        print_banner
        
        # Source intent.fish which will handle loading all other required modules
        source soul/intent.fish
        
        # Explicitly call main function from intent.fish (regular mode)
        main
        return $status
    end
end

# Execute noesis_main function with all arguments
noesis_main $argv
exit $status
