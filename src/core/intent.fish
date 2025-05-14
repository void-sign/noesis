#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# intent.fish - Implementation of intent handling in the Noesis project

# Source dependent modules
source src/core/memory.fish
source src/utils/data.fish

# Define global variables for storing intentions
set -g MAX_INTENTIONS 100
set -g intention_memory
set -g intention_count 0

# Initialize the array
for i in (seq $MAX_INTENTIONS)
    set -g intention_memory[$i] ""
end

# Custom function to get UTC timestamp
function log_with_timestamp
    set message $argv[1]
    set description $argv[2]
    
    set seconds_since_epoch (date +%s)
    set days (math "$seconds_since_epoch / 86400")
    set seconds_in_day (math "$seconds_since_epoch % 86400")
    set hours (math "$seconds_in_day / 3600")
    set minutes (math "($seconds_in_day % 3600) / 60")
    set seconds (math "$seconds_in_day % 60")
    
    # Format timestamp: Day HH:MM:SS
    printf "Day %d %02d:%02d:%02d" $days $hours $minutes $seconds
end

# Initialize the Intent system
function init_intent_system
    # Initialize intention memory
    for i in (seq $MAX_INTENTIONS)
        set -g intention_memory[$i] ""
    end
    set -g intention_count 0
end

# Process an intention
function process_intention
    set intention $argv[1]
    if test -z "$intention"
        return 1
    end
    
    # Log the intention
    echo "Processing intention: $intention"
    
    # Here we would have logic to handle various intentions
    # In the Fish version, we'll use pattern matching
    
    switch $intention
        case "*help*"
            echo "Available commands:"
            echo "  - help: Show this help message"
            echo "  - exit: Exit the system"
            echo "  - status: Show system status"
            echo "  - clear: Clear the screen"
        case "*exit*"
            echo "Exiting..."
            return 1
        case "*status*"
            echo "System is running"
            echo "Intentions processed: $intention_count"
        case "*clear*"
            clear
        case "*"
            echo "Unknown intention: $intention"
    end
    
    # Increment intention count
    set -g intention_count (math "$intention_count + 1")
    return 0
end

# Handle IO - main interaction loop
function handle_io
    echo "Welcome to NOESIS intent system"
    echo "Type 'help' for available commands"
    echo "Type 'exit' to exit"
    
    while true
        echo

        echo -n "read > "
        read -l intention
        
        echo
        
        if test -z "$intention"
            continue
        end
        
        if not process_intention $intention
            break
        end
    end
end
