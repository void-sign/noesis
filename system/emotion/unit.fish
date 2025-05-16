#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# emotion.fish - Implementation of emotional simulation for Noesis

# Emotional states
set -g EMOTION_NEUTRAL 0
set -g EMOTION_HAPPY 1
set -g EMOTION_SAD 2
set -g EMOTION_ANGRY 3
set -g EMOTION_CURIOUS 4
set -g EMOTION_AFRAID 5

# Global state tracking
set -g current_emotion $EMOTION_NEUTRAL
set -g emotion_intensity 0

# Initialize the emotion system
function init_emotion_system
    set -g current_emotion $EMOTION_NEUTRAL
    set -g emotion_intensity 0
    echo "Emotion system initialized"
end

# Set the current emotion
function set_emotion
    set -l emotion $argv[1]
    set -l intensity $argv[2]
    
    # Validate input
    if test -z "$emotion" 
        return 1
    end
    
    if test -z "$intensity"
        set intensity 5  # Default intensity
    end
    
    # Clamp intensity to 0-10 range
    if test $intensity -lt 0
        set intensity 0
    end
    
    if test $intensity -gt 10
        set intensity 10
    end
    
    # Set the emotional state
    set -g current_emotion $emotion
    set -g emotion_intensity $intensity
    
    # Log the change
    echo "Emotion changed: "(emotion_to_string $emotion)" (intensity: $intensity)"
    
    return 0
end

# Convert emotion code to string
function emotion_to_string
    set -l emotion $argv[1]
    
    switch $emotion
        case $EMOTION_NEUTRAL
            echo "neutral"
        case $EMOTION_HAPPY
            echo "happy"
        case $EMOTION_SAD
            echo "sad"
        case $EMOTION_ANGRY
            echo "angry"
        case $EMOTION_CURIOUS
            echo "curious"
        case $EMOTION_AFRAID
            echo "afraid"
        case "*"
            echo "unknown"
    end
end

# Get the current emotion as a string
function get_current_emotion
    emotion_to_string $current_emotion
end

# Get the current emotion intensity
function get_emotion_intensity
    echo $emotion_intensity
end

# Process input through emotional filter
function emotional_response
    set -l input $argv[1]
    
    # Check if we should use AI-enhanced response
    if functions -q ai_emotional_response && test "$AI_SYSTEM_ENABLED" = true
        ai_emotional_response $input
        return $status
    end
    
    # Simple keyword-based emotion response
    switch $current_emotion
        case $EMOTION_HAPPY
            echo "I'm feeling positive about this!"
        case $EMOTION_SAD
            echo "I'm somewhat discouraged..."
        case $EMOTION_ANGRY
            echo "I'm frustrated with this situation."
        case $EMOTION_CURIOUS
            echo "I find this very interesting."
        case $EMOTION_AFRAID
            echo "I'm concerned about the implications."
        case "*"  # Default to neutral
            echo "I acknowledge this information."
    end
    
    # If consciousness system is available, integrate with it
    if functions -q consciousness_emotion_integration
        consciousness_emotion_integration $current_emotion $emotion_intensity
    end
    
    return 0
end
