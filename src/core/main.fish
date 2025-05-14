#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# main.fish - Entry point for the Noesis project (Fish implementation)

# Source required dependency scripts
source src/core/memory.fish
source src/core/perception.fish
source src/core/logic.fish
source src/core/emotion.fish
source src/utils/noesis_lib.fish
source src/core/intent.fish

# Function: Main entry point
function main
    # Initialize the synthetic consciousness system
    init_intent_system

    # Version info only
    echo -e "\n\nNOESIS v1.2.0 - Synthetic Conscious\n\n"

    # Call the central control function from intent.fish
    # This will handle input/output as the "consciousness" center
    echo "Starting cognitive IO interface..."
    handle_io  # Process user interactions
    
    echo -e "\n\nNOESIS sleep\n\n"
    
    return 0
end

# Execute main function
main
