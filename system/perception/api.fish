#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# noesis_api.fish - API implementation for Noesis

# Source all required modules
source src/core/memory.fish
source src/core/perception.fish
source src/core/logic.fish
source src/core/emotion.fish
source src/core/intent.fish
source src/utils/data.fish
source src/utils/noesis_lib.fish

# API version
set -g API_VERSION "2.1.0"

# Initialize the API
function api_init
    echo "Initializing Noesis API v$API_VERSION"
    
    # Initialize core systems
    init_memory_system
    init_perception
    init_logic_system
    init_emotion_system
    init_intent_system
    init_data_storage
    
    echo "API initialized successfully"
    return 0
end

# Process a request
function api_process
    set request $argv[1]
    
    if test -z "$request"
        echo "Error: Empty request"
        return 1
    end
    
    echo "Processing API request: $request"
    
    # Parse the request
    # Format: ACTION:PARAMETERS
    set parts (string split ":" "$request")
    
    if test (count $parts) -lt 1
        echo "Error: Invalid request format"
        return 1
    end
    
    set action $parts[1]
    set params $parts[2..-1]
    
    # Process different actions
    switch $action
        case "VERSION"
            echo "NOESIS:API:$API_VERSION"
            return 0
            
        case "STORE"
            if test (count $parts) -lt 3
                echo "Error: STORE requires key and value"
                return 1
            end
            
            set key $parts[2]
            set value $parts[3..-1]
            
            store_data $key $value
            echo "OK:STORED:$key"
            return 0
            
        case "RETRIEVE"
            if test (count $parts) -lt 2
                echo "Error: RETRIEVE requires key"
                return 1
            end
            
            set key $parts[2]
            set value (retrieve_data $key)
            
            if test $status -eq 0
                echo "OK:VALUE:$value"
            else
                echo "ERROR:KEY_NOT_FOUND:$key"
            end
            return 0
            
        case "PROCESS"
            if test (count $parts) -lt 2
                echo "Error: PROCESS requires input"
                return 1
            end
            
            set input $parts[2]
            process_text_input $input
            
            echo "OK:PROCESSED"
            return 0
            
        case "EMOTION"
            if test (count $parts) -lt 2
                echo "Error: EMOTION requires emotion type"
                return 1
            end
            
            set emotion $parts[2]
            set intensity 5
            
            if test (count $parts) -ge 3
                set intensity $parts[3]
            end
            
            set_emotion $emotion $intensity
            echo "OK:EMOTION:$emotion:$intensity"
            return 0
            
        case "*"
            echo "Error: Unknown action: $action"
            return 1
    end
end

# Clean up API resources
function api_cleanup
    echo "Cleaning up Noesis API resources"
    return 0
end

# Get API version
function api_version
    echo $API_VERSION
end

# Handle JSON requests (modern API format)
function api_handle_json
    set json $argv[1]
    
    # This is a simplified JSON parser
    # In a real implementation, we would use a proper JSON parser
    
    echo "Processing JSON request: $json"
    
    # Extract action from JSON
    set action (echo $json | grep -o "\"action\":\"[^\"]*\"" | cut -d'"' -f4)
    
    if test -z "$action"
        echo "{\"status\":\"error\",\"message\":\"Missing action\"}"
        return 1
    end
    
    # Process different actions
    switch $action
        case "getVersion"
            echo "{\"status\":\"ok\",\"version\":\"$API_VERSION\"}"
            return 0
            
        case "process"
            # Extract input from JSON
            set input (echo $json | grep -o "\"input\":\"[^\"]*\"" | cut -d'"' -f4)
            
            if test -z "$input"
                echo "{\"status\":\"error\",\"message\":\"Missing input parameter\"}"
                return 1
            end
            
            # Process the input
            set result (process_text_input $input)
            
            echo "{\"status\":\"ok\",\"result\":\"$result\"}"
            return 0
            
        case "*"
            echo "{\"status\":\"error\",\"message\":\"Unknown action: $action\"}"
            return 1
    end
end
