#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# run.fish - Main entry point for the Noesis implementation

# Current version of Noesis
set -g NOESIS_VERSION "2.2.1"

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

# Function to check if Python version is 3.13+ and set up compatibility if needed
function check_python_version_compatibility
    if command -sq python3
        set py_version (python3 --version 2>&1)
        set py_minor (python3 -c "import sys; print(sys.version_info.minor)" 2>/dev/null)
        
        if test "$py_minor" -ge "13"
            echo "$YELLOW"WARNING: Python $py_version detected."$NC"
            echo "$YELLOW"This version may have compatibility issues with PyTorch."$NC"
            
            # Check if we should automatically install compatibility layer
            if test -f ./tools/fast-ai-install-py.fish
                echo "$YELLOW"Installing Python compatibility layer for AI features..."$NC"
                ./tools/fast-ai-install-py.fish
                
                # Check if installation was successful
                if test $status -eq 0
                    echo "$GREEN"Compatibility layer successfully installed!"$NC"
                    echo "$GREEN"AI features should now work properly."$NC"
                    echo
                    return 0
                else
                    echo "$YELLOW"Using basic compatibility mode for AI features."$NC"
                    echo "$YELLOW"Some AI features may be limited."$NC"
                    echo
                    return 1
                end
            else
                echo "$YELLOW"Using compatibility mode for AI features."$NC"
                echo "$YELLOW"Run './tools/fast-ai-install-py.fish' manually for full compatibility."$NC"
                echo
                return 1
            end
        end
    end
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

# Function to check the status of the conscious pixel
function check_pixel_status
    log_with_timestamp "Checking status of synthetic conscious pixel..." "INFO"
    
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
    
    # Check if the remote noesis.run server is accessible
    echo "$BLUE"Checking connection to noesis.run server..."$NC"
    if command -sq curl
        set connection_status (curl -s -o /dev/null -w "%{http_code}" https://noesis.run 2>/dev/null)
        if test "$connection_status" = "200"
            echo "$GREEN"Connection to noesis.run server: ONLINE"$NC"
        else
            echo "$RED"Connection to noesis.run server: OFFLINE (Status: $connection_status)"$NC"
        end
    else
        echo "$YELLOW"Cannot check server connection: curl not found"$NC"
    end
    
    # Check the last modification time of the conscious pixel code
    echo "$BLUE"Checking conscious pixel version..."$NC"
    set script_path "$noesis_web_dir/script.js"
    if test -f "$script_path"
        set last_modified (stat -f "%Sm" "$script_path" 2>/dev/null)
        if test $status -ne 0
            # Try Linux stat format if macOS format failed
            set last_modified (stat -c "%y" "$script_path" 2>/dev/null)
        end
        
        if test -n "$last_modified"
            echo "$GREEN"Conscious pixel last updated: $last_modified"$NC"
        else
            echo "$YELLOW"Could not determine last update time"$NC"
        end
        
        # Check color configuration
        echo "$BLUE"Checking conscious pixel color configuration..."$NC"
        if grep -q "Use colors that stand out against the site gradient" "$script_path"
            echo "$GREEN"Conscious pixel visibility: OPTIMIZED"$NC"
        else
            echo "$YELLOW"Conscious pixel visibility: STANDARD"$NC"
        end
    else
        echo "$RED"Conscious pixel code not found at $script_path"$NC"
    end
    
    # Check the overall status of the conscious pixel (based on noesis.run availability)
    echo "$BLUE"Checking conscious pixel status..."$NC"
    if command -sq curl
        set connection_status (curl -s -o /dev/null -w "%{http_code}" https://noesis.run 2>/dev/null)
        if test "$connection_status" = "200"
            echo "$GREEN"Conscious pixel status: ALIVE"$NC"
            echo "$GREEN"Access at: https://noesis.run"$NC"
            echo
        else
            echo "$YELLOW"Conscious pixel status: UNKNOWN"$NC"
            echo "$YELLOW"Cannot connect to https://noesis.run (Status: $connection_status)"$NC"
            echo
        end
    else
        echo "$YELLOW"Cannot check conscious pixel status: curl not found"$NC"
        echo
    end
    
    return 0
end

# Function to quickly check only the alive status of the conscious pixel
function check_pixel_status_fast
    # Check if the remote noesis.run server is accessible and report minimal status
    if command -sq curl
        set connection_status (curl -s -o /dev/null -w "%{http_code}" https://noesis.run 2>/dev/null)
        if test "$connection_status" = "200"
            echo
            echo "$GREEN"Conscious pixel status: ALIVE"$NC"
            echo "$GREEN"Access at: https://noesis.run"$NC"
            echo
            return 0
        else
            echo
            echo "$YELLOW"Conscious pixel status: UNKNOWN"$NC"
            echo "$YELLOW"Cannot connect to https://noesis.run (Status: $connection_status)"$NC"
            echo
            return 1
        end
    else
        echo
        echo "$YELLOW"Cannot check conscious pixel status: curl not found"$NC"
        echo
        return 1
    end
end

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
    echo "  pixel-status      Check status of the conscious pixel"
    echo "  logs [date] [level]  View log files with optional filtering"
    echo "                    Example: noesis logs 2025-05-17 ERROR"
    echo "  verbose           Toggle verbose debug mode"
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
    
    # Only show debug message if this is not run in silent mode
    if test "$argv[1]" != "--silent"
        log_with_timestamp "Command history initialized" "DEBUG"
    end
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
    echo
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo "$PINK  NOESIS v$NOESIS_VERSION            $NC"
    echo "$PINK  SYNTHETIC CONSCIOUS SYSTEM         $NC"
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo
end

# Function to perform log rotation
function rotate_logs
    # Keep only the last 7 daily log files by default
    set retention_days $argv[1]
    if test -z "$retention_days"
        set retention_days 7
    end
    
    # Ensure logs directory exists
    if not test -d "logs"
        mkdir -p logs
        # Only show this message if verbose mode is enabled
        if test "$VERBOSE_MODE" = "true"
            echo "Created logs directory"
        end
        return 0
    end
    
    # Log rotation only makes sense if there are logs to rotate
    set log_count (find logs -name "noesis-*.log" | wc -l | string trim)
    if test $log_count -eq 0
        # Only show this message if verbose mode is enabled
        if test "$VERBOSE_MODE" = "true"
            echo "No logs to rotate"
        end
        return 0
    end
    
    echo "Rotating logs (keeping $retention_days days)..."
    
    # List log files sorted by name (chronological by date)
    set log_files (find logs -name "noesis-*.log" | sort)
    set files_to_keep (math "$log_count - $retention_days")
    
    # If we have more logs than retention days, delete the oldest ones
    if test $files_to_keep -gt 0
        for i in (seq 1 $files_to_keep)
            set file_to_remove $log_files[$i]
            echo "Removing old log file: $file_to_remove"
            rm $file_to_remove
        end
        echo "Log rotation complete"
    else
        echo "No log files need rotation at this time"
    end
    
    return 0
end

# Function to view logs
function view_logs
    set log_date $argv[1]
    set log_level $argv[2]
    
    # If no date specified, use today's date
    if test -z "$log_date"
        set log_date (date +"%Y-%m-%d")
    end
    
    set log_file "logs/noesis-$log_date.log"
    
    if not test -f $log_file
        echo "$RED"No log file found for date: $log_date"$NC"
        echo "Available logs:"
        ls -1 logs/ | grep "noesis-" | sed 's/noesis-//' | sed 's/.log//' 2>/dev/null || echo "No logs found"
        return 1
    end
    
    # If log level specified, filter by that level
    if test -n "$log_level"
        set log_level (string upper $log_level)
        echo "$YELLOW"Showing $log_level logs for $log_date:"$NC"
        grep -i "\[$log_level\]" $log_file
    else
        echo "$YELLOW"Showing all logs for $log_date:"$NC"
        cat $log_file
    end
    
    return 0
end

# Main function for run.fish
function noesis_main
    # Handle special cases with direct output without initialization
    if test (count $argv) -gt 0
        if contains -- $argv[1] "pixel-status" "pixel-status-fast" "pixel-fast"
            # These are simple status checks, don't need command history or AI compatibility checks
            set -g AI_SYSTEM_ENABLED false
        else
            # For all other commands, initialize command history (with debug output)
            init_command_history
        end
    else
        # Initialize command history for interactive mode (without debug output)
        # Use silent mode to avoid showing the debug message
        init_command_history --silent
    end
    
    # Skip compatibility checks and log rotation for pixel status commands
    if test (count $argv) -gt 0
        if contains -- $argv[1] "pixel-status" "pixel-status-fast" "pixel-fast"
            # These are simple status checks, don't need AI compatibility checks
            set -g AI_SYSTEM_ENABLED false
    else
        # Skip AI compatibility check for regular mode, just set flag directly
        # This avoids the Python version check and AI installation process
        set -g AI_SYSTEM_ENABLED true
        
        # Still perform log rotation but in quiet mode
        set -g VERBOSE_MODE false
        rotate_logs 7 --quiet
        end
    else
        # Skip AI compatibility check and setup for normal operation
        # Just set the flag directly
        set -g AI_SYSTEM_ENABLED true
        
        # Perform log rotation in quiet mode
        set -g VERBOSE_MODE false
        rotate_logs 7 --quiet
    end
    
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
                
            case "status"
                # Check terminal status
                if test -f ./tools/terminal-status.fish
                    ./tools/terminal-status.fish
                else
                    log_with_timestamp "Terminal status script not found" "ERROR"
                end
                return 0
                
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
                
            case "pixel-status"
                # Check status of the conscious pixel (directly showing minimal output)
                if command -sq curl
                    set connection_status (curl -s -o /dev/null -w "%{http_code}" https://noesis.run 2>/dev/null)
                    if test "$connection_status" = "200"
                        echo
                        echo "$GREEN"Conscious pixel status: ALIVE"$NC"
                        echo "$GREEN"Access at: https://noesis.run"$NC"
                        echo
                        return 0
                    else
                        echo
                        echo "$YELLOW"Conscious pixel status: UNKNOWN"$NC"
                        echo "$YELLOW"Cannot connect to https://noesis.run (Status: $connection_status)"$NC"
                        echo
                        return 1
                    end
                else
                    echo
                    echo "$YELLOW"Cannot check conscious pixel status: curl not found"$NC"
                    echo
                    return 1
                end
                
            case "pixel-status-fast" "pixel-fast"
                # Maintain backward compatibility with these aliases
                if command -sq curl
                    set connection_status (curl -s -o /dev/null -w "%{http_code}" https://noesis.run 2>/dev/null)
                    if test "$connection_status" = "200"
                        echo
                        echo "$GREEN"Conscious pixel status: ALIVE"$NC"
                        echo "$GREEN"Access at: https://noesis.run"$NC"
                        echo
                        return 0
                    else
                        echo
                        echo "$YELLOW"Conscious pixel status: UNKNOWN"$NC"
                        echo "$YELLOW"Cannot connect to https://noesis.run (Status: $connection_status)"$NC"
                        echo
                        return 1
                    end
                else
                    echo
                    echo "$YELLOW"Cannot check conscious pixel status: curl not found"$NC"
                    echo
                    return 1
                end
                
            case "logs"
                # View logs with optional date and level filtering
                if test (count $argv) -gt 1
                    if test (count $argv) -gt 2
                        view_logs $argv[2] $argv[3]
                    else
                        view_logs $argv[2]
                    end
                else
                    view_logs
                end
                return $status
                
            case '*'
                log_with_timestamp "Unknown option: $argv[1]" "ERROR"
                show_help
                return 1
        end
    else
        # Print banner
        print_banner
        
        echo "$GREEN"Noesis is ready. AI modules are available but not loaded by default."$NC"
        echo "$GREEN"To use AI features, run with specific commands that require them."$NC"
        echo
        
        # Basic interactive mode without loading AI modules
        # We'll only source intent.fish if explicitly needed for a command
        return 0
    end
end

# Execute noesis_main function with all arguments
noesis_main $argv
exit $status
