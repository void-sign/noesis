#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# intent.fish - Central implementation and main entry point for the Noesis system
# This file combines functionality from main.fish and fish-only-run.fish making intent.fish
# the central component of the Noesis system

# Current version of Noesis
set -g NOESIS_VERSION "2.2.0"

# Make sure color variables are available
# These are defined in run.fish but we need to ensure they're accessible here
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red) 
set PINK (set_color ff5fd7)
set ORANGE (set_color ff8c00)
set PURPLE (set_color 8a2be2)
set CYAN (set_color 00ffff)
set NC (set_color normal)

# Source dependent modules - absolute minimum needed here since intent.fish is now central
# Using the new system directory structure - no need to load utils files anymore
source system/memory/unit.fish
source system/perception/unit.fish
source system/emotion/unit.fish
source system/ai-model/unit.fish

# Source quantum modules directly from the system directory
source system/memory/quantum/unit.fish
source system/memory/quantum/compiler.fish
source system/memory/quantum/backend-stub.fish
source system/memory/quantum/backend-ibm.fish
source system/memory/quantum/export-qasm.fish
source system/memory/quantum/field/quantum-field.fish

# Note: All color definitions, print_banner, log_with_timestamp, and handle_error functions
# are now defined in run.fish

# Initialize all systems
function initialize_systems
    echo "$YELLOW"Initializing Noesis systems..."$NC"
    echo
    
    # Initialize core systems
    init_memory_system
    init_perception
    # init_logic_system - Now handled inside intent_system
    init_emotion_system
    init_intent_system
    
    # Initialize AI integration system
    init_ai_system
    
    # Initialize quantum systems - using the new unit.fish functions
    stub_init
    echo
    echo "$GREEN"All systems initialized successfully"$NC"
    echo
    return 0
end

# Define constants for types of logical operations
set -g LOGIC_AND 0
set -g LOGIC_OR 1
set -g LOGIC_NOT 2
set -g LOGIC_XOR 3
set -g LOGIC_IMPLIES 4

# Define constants for truth values
set -g TRUE 1
set -g FALSE 0
set -g UNKNOWN -1

# Define global variables for storing intentions
set -g MAX_INTENTIONS 100
set -g intention_memory
set -g intention_count 0

# Initialize the array
for i in (seq $MAX_INTENTIONS)
    set -g intention_memory[$i] ""
end

# Note: Command history functions are now defined in run.fish

# Note: log_with_timestamp and handle_error functions are now defined in run.fish

# Initialize the logic system
function init_logic_system
    echo "Logic system initialized"
end

# Basic boolean evaluation
function evaluate_boolean
    set -l a $argv[1]
    set -l operator $argv[2]
    set -l b $argv[3]
    
    # Handle different operators
    switch $operator
        case $LOGIC_AND
            test $a -eq $TRUE -a $b -eq $TRUE
            return $status
        case $LOGIC_OR
            test $a -eq $TRUE -o $b -eq $TRUE
            return $status
        case $LOGIC_NOT
            test $a -ne $TRUE
            return $status
        case $LOGIC_XOR
            test \( $a -eq $TRUE -a $b -ne $TRUE \) -o \( $a -ne $TRUE -a $b -eq $TRUE \)
            return $status
        case $LOGIC_IMPLIES
            test $a -ne $TRUE -o $b -eq $TRUE
            return $status
        case "*"
            echo "Unknown logical operator: $operator"
            return $UNKNOWN
    end
end

# Parse a logical expression (simple version)
function parse_logical_expression
    set -l expression $argv[1]
    
    # This is a simplified parser for demonstration
    # In practice, a more robust parser would be used
    
    if string match -q "*AND*" $expression
        echo "AND operation detected"
        return $LOGIC_AND
    else if string match -q "*OR*" $expression
        echo "OR operation detected"
        return $LOGIC_OR
    else if string match -q "*NOT*" $expression
        echo "NOT operation detected"
        return $LOGIC_NOT
    else if string match -q "*XOR*" $expression
        echo "XOR operation detected"
        return $LOGIC_XOR
    else if string match -q "*IMPLIES*" $expression
        echo "IMPLIES operation detected"
        return $LOGIC_IMPLIES
    else
        echo "Unknown logical expression"
        return -1
    end
end

# Function to reason about a problem
function reason_about
    set -l problem $argv[1]
    
    echo "Reasoning about: $problem"
    
    # This would involve complex logical operations in a real system
    # For now, we just simulate basic reasoning
    
    echo "Analyzing problem components..."
    echo "Checking knowledge base..."
    echo "Applying logical rules..."
    echo "Conclusion: More data needed for definitive answer"
    
    return 0
end

# Initialize the Intent system
function init_intent_system
    # Initialize intention memory
    for i in (seq $MAX_INTENTIONS)
        set -g intention_memory[$i] ""
    end
    set -g intention_count 0
    
    # Initialize command history - now defined in run.fish
    # This function might already be called by run.fish, but call again to be safe
    if functions -q init_command_history
        init_command_history
    end
    
    # Initialize the logic system as well
    init_logic_system
    
    if functions -q log_with_timestamp
        log_with_timestamp "Intent system initialized" "SUCCESS"
    else
        echo "$GREEN"Intent system initialized"$NC"
    end
end

# Process an intention
function process_intention
    set intention $argv[1]
    if test -z "$intention"
        return 1
    end
    
    # Log the intention
    log_with_timestamp "Processing intention: $intention" "DEBUG"
    
    # Here we would have logic to handle various intentions
    # In the Fish version, we'll use pattern matching
    
    switch $intention
        case "help"
            echo "$PURPLE== Cognitive Commands ==$NC"
            echo "  $GREEN- help:$NC                View this help message"
            echo "  $GREEN- status:$NC              Show system status"
            echo "  $GREEN- history:$NC             View command history"
            echo "  $GREEN- clear:$NC               Clear the screen"
            echo "  $GREEN- verbose:$NC             Toggle verbose debug mode"
            echo "  $GREEN- exit:$NC                Exit the system"
            echo
            echo "$PURPLE== Reasoning & Logic ==$NC"
            echo "  $GREEN- reason about <topic>:$NC Reason about a given topic"
            echo "  $GREEN- logic <expression>:$NC   Process a logical expression (AND, OR, NOT, XOR, IMPLIES)"
            echo
            echo "$PURPLE== System Commands ==$NC"
            echo "  $GREEN- quantum:$NC             Enter quantum processing mode"
            
        case "exit" "e"
            # No log message here - we'll only use one at the end
            return 1
            
        case "status"
            echo "$CYAN"System Status"$NC"
            echo "  Intentions processed: $intention_count"
            echo "  Commands in history: $history_count"
            echo "  Verbose mode: $VERBOSE_MODE"
            
        case "history"
            show_history
            
        case "verbose"
            if test "$VERBOSE_MODE" = "true"
                set -g VERBOSE_MODE false
                log_with_timestamp "Verbose mode disabled" "INFO"
            else
                set -g VERBOSE_MODE true
                log_with_timestamp "Verbose mode enabled" "INFO"
            end
            
        case "clear"
            clear
            echo "$CYAN"NOESIS Cognitive Interface"$NC"
            
        case "quantum"
            log_with_timestamp "Switching to quantum mode" "INFO"
            handle_quantum_io
            log_with_timestamp "Returned from quantum mode" "INFO"
            
        case "reason about *"
            set problem (string replace "reason about " "" $intention)
            reason_about $problem
            
        case "logic *"
            set expression (string replace "logic " "" $intention)
            log_with_timestamp "Evaluating logical expression: $expression" "DEBUG"
            set operator (parse_logical_expression $expression)
            
            if test $operator -ge 0
                # For demonstration, we'll use TRUE and FALSE values
                if test $operator -eq $LOGIC_NOT
                    set result (evaluate_boolean $TRUE $operator "")
                else
                    set result (evaluate_boolean $TRUE $operator $FALSE)
                end
                
                if test $result -eq 0
                    log_with_timestamp "Expression evaluates to TRUE" "SUCCESS"
                else
                    log_with_timestamp "Expression evaluates to FALSE" "INFO"
                end
            else
                handle_error "Invalid logical expression: $expression" 1
            end
            
        case "*"
            handle_error "Unknown intention: $intention" 1
            echo "Type '$GREEN'help'$NC' for available commands"
    end
    
    # Increment intention count
    set -g intention_count (math "$intention_count + 1")
    return 0
end

# Handle IO - main interaction loop
function handle_io
    echo "$CYAN"Welcome to NOESIS intent system"$NC"
    echo
    echo "Type '$GREEN'help'$NC' for available commands"
    echo "Type '$GREEN'exit'$NC' to exit"
    
    while true
        echo
        read -P "$GREEN""noesis > ""$NC" intention
        echo
        
        if test -z "$intention"
            continue
        end
        
        # Add command to history (function now in run.fish)
        add_to_history $intention
        
        # Process the command
        if not process_intention $intention
            # No log message here - we'll only use one at the end
            break
        end
    end
end

# Quantum interaction loop
function handle_quantum_io
    echo
    echo "$CYAN"Welcome to NOESIS Quantum Interface"$NC"
    echo
    echo "Available quantum demos:"
    echo "  $GREEN- demo_quantum_field:$NC       Interactive quantum field demo"
    echo "  $GREEN- demo_wave_interference:$NC   Quantum wave interference demo"
    echo "  $GREEN- demo_quantum_vs_classical:$NC Compare quantum and classical computing"
    echo "  $GREEN- q_init:$NC                   Initialize quantum system" 
    echo "  $GREEN- history:$NC                  View command history"
    echo "  $GREEN- verbose:$NC                  Toggle verbose debug mode"
    echo "  $GREEN- help:$NC                     Show this help message"
    echo "  $GREEN- exit:$NC                     Return to main shell"
    echo
    
    while true
        read -P "$GREEN""quantum > ""$NC" command
        
        if test -z "$command"
            continue
        end
        
        # Add command to history
        add_to_history $command
        
        # Process command
        switch $command
            case "demo_quantum_field"
                if functions -q log_with_timestamp
                log_with_timestamp "Starting quantum field demo" "INFO"
            else
                echo "Starting quantum field demo"
            end
            
            if not demo_quantum_field
                if functions -q handle_error
                    handle_error "Quantum field demo failed" 1
                else
                    echo $RED"Error: Quantum field demo failed"$NC
                end
            end
            
            if functions -q log_with_timestamp
                log_with_timestamp "Quantum field demo completed" "SUCCESS"
            else
                echo $GREEN"Quantum field demo completed"$NC 
            end
                
            case "demo_wave_interference"
                if functions -q log_with_timestamp
                log_with_timestamp "Starting wave interference demo" "INFO"
            else
                echo "Starting wave interference demo"
            end
            
            if not demo_wave_interference
                if functions -q handle_error
                    handle_error "Wave interference demo failed" 1
                else
                    echo $RED"Error: Wave interference demo failed"$NC
                end
            end
            
            if functions -q log_with_timestamp
                log_with_timestamp "Wave interference demo completed" "SUCCESS"
            else
                echo $GREEN"Wave interference demo completed"$NC
            end
                
            case "demo_quantum_vs_classical"
                log_with_timestamp "Starting quantum vs classical demo" "INFO"
                if not demo_quantum_vs_classical
                    handle_error "Quantum vs classical demo failed" 1
                end
                log_with_timestamp "Quantum vs classical demo completed" "SUCCESS"
                
            case "q_init"
                log_with_timestamp "Initializing quantum system" "INFO"
                q_init
                log_with_timestamp "Quantum system initialized" "SUCCESS"
                
            case "history"
                show_history
                
            case "verbose"
                if test "$VERBOSE_MODE" = "true"
                    set -g VERBOSE_MODE false
                    log_with_timestamp "Verbose mode disabled" "INFO"
                else
                    set -g VERBOSE_MODE true
                    log_with_timestamp "Verbose mode enabled" "INFO"
                end
                
            case "clear"
                clear
                echo "$CYAN"NOESIS Quantum Interface"$NC"
                
            case "exit" "e"
                echo
                log_with_timestamp "Exiting quantum mode..." "INFO"
                echo
                return 0
                
            case "help"
                echo "Available quantum demos and commands:"
                echo
                echo "$PURPLE== Demo Programs ==$NC"
                echo "  $GREEN- demo_quantum_field:$NC       Interactive quantum field demo"
                echo "  $GREEN- demo_wave_interference:$NC   Quantum wave interference demo" 
                echo "  $GREEN- demo_quantum_vs_classical:$NC Compare quantum and classical computing"
                echo
                echo "$PURPLE== System Commands ==$NC"
                echo "  $GREEN- q_init:$NC                   Initialize quantum system"
                echo "  $GREEN- history:$NC                  View command history"
                echo "  $GREEN- verbose:$NC                  Toggle verbose debug mode"
                echo "  $GREEN- clear:$NC                    Clear the screen"
                echo "  $GREEN- help:$NC                     Show this help message"
                echo "  $GREEN- exit:$NC                     Return to main shell"
                
            case "*"
                handle_error "Unknown command: $command" 1
                echo "Type '$GREEN'help'$NC' for available commands"
        end
    end
end

# Main function - central entry point for the system
function main
    # Banner is now printed in run.fish
    initialize_systems
    
    # Check if we're in quantum mode by looking at the arguments
    for arg in $argv
        if test "$arg" = "--quantum" -o "$arg" = "-q"
            if functions -q log_with_timestamp
                log_with_timestamp "Starting quantum IO interface..." "INFO"
            else
                echo $BLUE"Starting quantum IO interface..."$NC
            end
            echo
            handle_quantum_io
            return 0
        end
    end
    
    # Regular mode
    if functions -q log_with_timestamp
        log_with_timestamp "Starting cognitive IO interface..." "INFO"
    else
        echo $BLUE"Starting cognitive IO interface..."$NC
    end
    echo
    handle_io
    echo
    if functions -q log_with_timestamp
        log_with_timestamp "NOESIS system exiting" "INFO"
    else
        echo $YELLOW"NOESIS system exiting"$NC
    end
    echo
    return 0
end

# When intent.fish is executed directly, check if it's being sourced
set -l is_sourced 0
if status --is-interactive
    if test (count $argv) -eq 0
        # Running interactively with no arguments
        set is_sourced 0
    end
else
    # Likely sourced by another script
    set is_sourced 1
end

if test $is_sourced -eq 0
    # When run directly, use the main function
    # Note: Generally, you should run via run.fish instead
    log_with_timestamp "Running intent.fish directly (prefer using run.fish)" "WARNING"
    
    # Execute main when run directly
    main
    
    # Make sure we exit cleanly
    exit $status
end

# If we're sourced, we'll just make the functions available
# without executing main automatically
