#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# run_simplified.fish - A simplified version of run.fish for debugging

echo
echo "Starting simplified run.fish..."

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
set -g VERBOSE_MODE true   # Set to true for verbose debugging output

# Simple timestamp function with improved formatting
function log_message
    set message $argv[1]
    set level $argv[2]
    
    if test -z "$level"
        set level "INFO"
    end
    
    # Get timestamp information
    set seconds_since_epoch (date +%s)
    set days (math --scale=0 (math "$seconds_since_epoch / 86400"))
    set formatted_date (date +"%d %b %Y %H:%M:%S")
    
    # Create padded timestamp strings with background highlighting
    set time_line "    [Time[$formatted_date]]    "
    set unix_line "    [Unix Time[$days days, $seconds_since_epoch seconds]]    "
    
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
        case "INFO"
            set bg_color (set_color --background=ff5fd7 --bold)
            set fg_color $PINK
            set level_display "    INFO    "
    end
    
    # Display the formatted message
    echo
    echo $bg_color$level_display$NC
    echo
    echo $fg_color$time_line$NC
    echo $fg_color$unix_line$NC
    echo
    echo $fg_color"    $message    "$NC
    echo
end

# Print a banner
function print_banner
    echo
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo "$PINK  NOESIS v2.1.2 - SIMPLIFIED         $NC"
    echo "$PINK━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo
end

# Main function
function main
    print_banner
    
    log_message "Loading modules..." "INFO"
    
    # Source intent.fish to get access to its functions
    if test -f soul/intent.fish
        # Combine the find and load messages into a single success message
        source soul/intent.fish
        log_message "Found and loaded intent.fish" "SUCCESS"
        
        # Try running the main function from intent.fish
        if functions -q initialize_systems
            log_message "Found initialize_systems function, running it" "INFO"
            initialize_systems
        else
            log_message "initialize_systems function not found" "ERROR"
        end
    else
        log_message "Cannot find soul/intent.fish" "ERROR"
        return 1
    end
    
    log_message "Simplified run.fish completed" "SUCCESS"
    return 0
end

# Run the main function
main
exit $status
