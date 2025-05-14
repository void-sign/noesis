#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# fish-only-run.fish - Main entry point for the Noesis fish-only implementation

# Source all required modules
source src/core/main.fish
source src/core/memory.fish
source src/core/perception.fish
source src/core/logic.fish
source src/core/emotion.fish
source src/core/intent.fish
source src/quantum/quantum.fish
source src/quantum/compiler.fish
source src/quantum/backend_stub.fish
source src/quantum/backend_ibm.fish
source src/quantum/export_qasm.fish
source src/quantum/field/quantum_field.fish

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)

# Print a nice welcome banner
function print_banner
    echo "$BLUE┌────────────────────────────────────────────────┐$NC"
    echo "$BLUE│$NC                                                $BLUE│$NC"
    echo "$BLUE│$PINK        NOESIS v1.2.0 - FISH ONLY EDITION       $BLUE│$NC"
    echo "$BLUE│$NC                                                $BLUE│$NC"
    echo "$BLUE│$GREEN  Synthetic Conscious System                    $BLUE│$NC"
    echo "$BLUE│$GREEN  Copyright (c) 2025 Napol Thanarangkaun       $BLUE│$NC"
    echo "$BLUE│$NC                                                $BLUE│$NC"
    echo "$BLUE└────────────────────────────────────────────────┘$NC"
    echo
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

# Main function
function main
    print_banner
    initialize_systems
    
    echo "$BLUE"Starting cognitive IO interface..."$NC"
    handle_io
    
    echo -e "\n\n$YELLOW"NOESIS sleep"$NC\n\n"
    return 0
end

# Execute main function
main
