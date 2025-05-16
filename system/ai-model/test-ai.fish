#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# test_ai.fish - Test script for AI and consciousness integration

# Source necessary modules
# Need to change to the project root directory first
set SCRIPT_DIR (dirname (status filename))
cd $SCRIPT_DIR/../../
source soul/intent.fish

# Print a nice header
function print_header
    set title $argv[1]
    echo
    echo "======================================================"
    echo "  $title"
    echo "======================================================"
    echo
end

# Test AI initialization
function test_ai_init
    print_header "Testing AI Initialization"
    init_ai_system
    ai_status
    return 0
end

# Test consciousness models
function test_consciousness_models
    print_header "Testing Consciousness Models"
    
    # Try each consciousness model
    for model in $CONSCIOUSNESS_MODELS
        echo "Setting model to $model..."
        set_consciousness_model $model
        echo
    end
    
    return 0
end

# Test consciousness levels
function test_consciousness_levels
    print_header "Testing Consciousness Levels"
    
    # Try each level
    for level in (seq 0 5)
        echo "Setting level to $level..."
        set_consciousness_level $level
        echo
    end
    
    return 0
end

# Test self-reflection
function test_reflection
    print_header "Testing Self-Reflection"
    
    # Test reflection with each model
    for model in $CONSCIOUSNESS_MODELS
        echo "Testing reflection with $model model..."
        set_consciousness_model $model
        
        # Override reflection interval for testing
        set -g SELF_REFLECTION_INTERVAL 0
        set -g LAST_REFLECTION_TIME 0
        
        perform_self_reflection
        echo
    end
    
    return 0
end

# Test emotion-consciousness integration
function test_emotion_integration
    print_header "Testing Emotion-Consciousness Integration"
    
    # Test with different emotions
    for emotion in $EMOTION_NEUTRAL $EMOTION_HAPPY $EMOTION_SAD $EMOTION_ANGRY $EMOTION_CURIOUS $EMOTION_AFRAID
        set intensity (math "$emotion * 2")
        if test $intensity -gt 10
            set intensity 10
        end
        
        set_emotion $emotion $intensity
        echo
        echo "Testing emotional response with " (emotion_to_string $emotion) " emotion:"
        emotional_response "This is a test input"
        echo
    end
    
    return 0
end

# Main test function
function run_ai_tests
    print_header "AI and Consciousness Integration Tests"
    
    echo "Starting tests at "(date)
    echo
    
    # Run each test
    test_ai_init
    test_consciousness_models
    test_consciousness_levels
    test_reflection
    test_emotion_integration
    
    print_header "Tests Completed"
    echo "All tests finished at "(date)
    echo
    
    return 0
end

# Run the tests if this script is executed directly
echo "Starting AI test script..."
echo "Script path: "(status -f)
echo "Current directory: "(pwd)

# Check if sources are available
if test -e soul/intent.fish
    echo "Found intent.fish"
else
    echo "ERROR: soul/intent.fish not found"
    ls -la soul/
end

if test -e system/ai-model/unit.fish
    echo "Found unit.fish"
else
    echo "ERROR: system/ai-model/unit.fish not found" 
end

# Run tests regardless of interactive status
echo "Running AI and consciousness tests..."
run_ai_tests
