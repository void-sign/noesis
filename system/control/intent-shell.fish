#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# intent_shell.fish - Shell command processor for intent system

# Source required dependencies
# Adjust path to look for noesis_lib.fish in the proper location
if test -f system/utils/noesis_lib.fish
    source system/utils/noesis_lib.fish
else if test -f ../utils/noesis_lib.fish
    source ../utils/noesis_lib.fish
else
    echo "Warning: noesis_lib.fish not found, some functions may be unavailable"
end

# Initialize the intent shell system
function init_intent_shell
    echo "Intent shell initialized"
    return 0
end

# Process a shell command
function process_shell_command
    set -l command $argv
    
    if test (count $argv) -eq 0
        return 1
    end
    
    echo "Processing shell command: $command"
    
    # Execute the command and capture output
    set -l output (eval $command 2>&1)
    set -l status_code $status
    
    echo "Command output:"
    echo $output
    
    return $status_code
end

# Parse command for special instructions
function parse_command_for_intent
    set -l command $argv[1]
    
    if string match -q "*load*" $command
        echo "LOAD_INTENT"
    else if string match -q "*save*" $command
        echo "SAVE_INTENT"
    else if string match -q "*execute*" $command
        echo "EXECUTE_INTENT"
    else if string match -q "*analyze*" $command
        echo "ANALYZE_INTENT"
    else if string match -q "*ai*" $command; or string match -q "*AI*" $command
        echo "AI_COMMAND"
    else
        echo "UNKNOWN_INTENT"
    end
end

# Handle special shell commands related to intent system
function handle_intent_command
    set -l intent $argv[1]
    set -l params $argv[2..-1]
    
    switch $intent
        case "LOAD_INTENT"
            echo "Loading intent from: $params"
            # Load intent logic would go here
        case "SAVE_INTENT"
            echo "Saving intent to: $params"
            # Save intent logic would go here
        case "EXECUTE_INTENT"
            echo "Executing intent: $params"
            # Execute intent logic would go here
        case "ANALYZE_INTENT"
            echo "Analyzing intent: $params"
            # Analyze intent logic would go here
        case "AI_COMMAND"
            handle_ai_command $params
        case "*"
            echo "Unknown intent command: $intent"
            return 1
    end
    
    return 0
end

# Handle AI-specific commands
function handle_ai_command
    set -l command $argv
    
    if test (count $command) -eq 0; or test "$command" = "ai"; or test "$command" = ""
        echo "AI system commands:"
        echo "  ai status              - Display AI system status"
        echo "  ai install             - Install AI dependencies"
        echo "  ai install-py13        - Install AI dependencies for Python 3.13+"
        echo "  ai list-models         - List available AI models"
        echo "  ai set-model MODEL     - Set active AI model"
        echo "  ai thinking LEVEL      - Set AI thinking level (0-5)"
        echo "  ai memory TOGGLE       - Toggle AI memory integration (on/off)"
        echo "  ai generate PROMPT     - Generate text using the active model"
        echo "  ai introspect          - Perform AI introspection"
        echo "  ai license MODEL       - Check license compatibility for a model"
        echo
        echo "Consciousness commands:"
        echo "  ai consciousness status           - Show consciousness status"
        echo "  ai consciousness model MODEL      - Set consciousness model"
        echo "  ai consciousness level LEVEL      - Set consciousness level (0-5)"
        echo "  ai consciousness reflect          - Perform self-reflection"
        echo "  ai consciousness research         - Get latest consciousness research"
        echo "  ai consciousness models           - List available consciousness models"
        return 0
    end
    
    switch $command[1]
        case "status"
            ai_status
        case "install"
            ai_install_dependencies
        case "install-py13"
            # Execute the specialized Python 3.13+ installer script directly
            if test -f ./fast-ai-install-py13.fish
                echo "Installing AI dependencies for Python 3.13+..."
                ./fast-ai-install-py13.fish
                if test $status -eq 0
                    set -g AI_SYSTEM_ENABLED true
                    echo "Python 3.13+ AI dependencies installed successfully."
                end
            else
                echo "Error: Could not find fast-ai-install-py13.fish"
                echo "Please download it from the Noesis repository."
                return 1
            end
        case "list-models"
            ai_list_models
        case "set-model"
            if test (count $command) -lt 2
                echo "Error: Missing model name"
                echo "Usage: ai set-model MODEL_NAME"
                return 1
            end
            ai_set_model $command[2]
        case "thinking"
            if test (count $command) -lt 2
                echo "Error: Missing thinking level"
                echo "Usage: ai thinking LEVEL (0-5)"
                return 1
            end
            ai_set_thinking_level $command[2]
        case "memory"
            ai_toggle_memory_integration
        case "generate"
            if test (count $command) -lt 2
                echo "Error: Missing prompt"
                echo "Usage: ai generate PROMPT"
                return 1
            end
            ai_generate (string join " " $command[2..-1])
        case "introspect"
            ai_introspect
        case "license"
            if test (count $command) -lt 2
                echo "Error: Missing model name"
                echo "Usage: ai license MODEL_NAME"
                return 1
            end
            ai_check_license_compatibility $command[2]
        case "consciousness"
            if test (count $command) -lt 2
                echo "Error: Missing consciousness subcommand"
                echo "Usage: ai consciousness [status|model|level|reflect|research|models]"
                return 1
            end
            handle_consciousness_command $command[2..-1]
        case "*"
            echo "Unknown AI command: $command[1]"
            echo "Type 'ai' for a list of available commands"
            return 1
    end
    
    return 0
end

# Handle consciousness-specific commands
function handle_consciousness_command
    set -l command $argv
    
    if test (count $command) -eq 0
        echo "Usage: ai consciousness [status|model|level|reflect|research|models]"
        return 1
    end
    
    switch $command[1]
        case "status"
            echo "Consciousness Status:"
            echo "  Current Model: $CONSCIOUSNESS_MODEL"
            echo "  Level: $CONSCIOUSNESS_LEVEL/5"
            echo "  Self-Reflection Interval: $SELF_REFLECTION_INTERVAL seconds"
            echo "  Last Reflection: "(date -d @$LAST_REFLECTION_TIME +"%H:%M:%S")
            
        case "model"
            if test (count $command) -lt 2
                echo "Error: Missing model name"
                echo "Usage: ai consciousness model MODEL_NAME"
                echo "Available models: $CONSCIOUSNESS_MODELS"
                return 1
            end
            set_consciousness_model $command[2]
            
        case "level"
            if test (count $command) -lt 2
                echo "Error: Missing level value"
                echo "Usage: ai consciousness level LEVEL (0-5)"
                return 1
            end
            set_consciousness_level $command[2]
            
        case "reflect"
            perform_self_reflection
            
        case "research"
            get_latest_consciousness_research
            
        case "models"
            echo "Available Consciousness Models:"
            for i in (seq (count $CONSCIOUSNESS_MODELS))
                echo "  $CONSCIOUSNESS_MODELS[$i] - $CONSCIOUSNESS_MODEL_NAMES[$i]"
            end
            
        case "*"
            echo "Unknown consciousness command: $command[1]"
            echo "Available commands: status, model, level, reflect, research, models"
            return 1
    end
    
    return 0
end
