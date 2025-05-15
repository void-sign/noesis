#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# main.fish - Entry point for the Noesis project (Fish implementation)

# Source required dependency scripts
source src/core/memory.fish
source src/core/perception.fish
source src/core/emotion.fish
source src/utils/noesis_lib.fish
source src/core/intent.fish  # logic.fish functionality is now merged into intent.fish

# Source quantum modules
source src/quantum/quantum.fish
source src/quantum/compiler.fish
source src/quantum/backend_stub.fish
source src/quantum/backend_ibm.fish
source src/quantum/export_qasm.fish
source src/quantum/field/quantum_field.fish

# Function: Main entry point
function main
    # Initialize the synthetic consciousness system
    init_intent_system

    # Version info only
    echo -e "\n\nNOESIS v2.0.0 - Synthetic Conscious\n\n"

    # Call the central control function from intent.fish
    # This will handle input/output as the "consciousness" center
    echo "Starting cognitive IO interface..."
    handle_io  # Process user interactions
    
    echo -e "\n\nNOESIS sleep\n\n"
    
    return 0
end

# Execute main function
main
