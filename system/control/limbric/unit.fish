#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# filepath: /Users/plugio/Documents/GitHub/noesis/system/control/limbric/unit.fish
# unit.fish - Limbic system implementation for Noesis
# Simulates the human limbic system's role in emotional processing, memory formation,
# and behavioral regulation. Integrates with memory and emotion subsystems.

# Current version of Noesis
set -g NOESIS_VERSION "2.2.2"

# Define global variables for the limbic system
set -g LIMBIC_AROUSAL 0.5      # Baseline arousal level (0-1)
set -g LIMBIC_VALENCE 0.5      # Baseline emotional valence (0-1)
set -g LIMBIC_THRESHOLD 0.7    # Activation threshold
set -g LIMBIC_DECAY 0.05       # Emotion decay rate per cycle
set -g LIMBIC_MAX_MEMORY 1000  # Maximum limbic memories

# Define limbic structures and their functions
set -g AMYGDALA_STATE 0        # Emotional salience detector
set -g HIPPOCAMPUS_STATE 0     # Memory indexer
set -g HYPOTHALAMUS_STATE 0    # Homeostatic regulation
set -g THALAMUS_STATE 0        # Sensory relay
set -g CINGULATE_STATE 0       # Conflict resolution

# Define colors for better readability
set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set PURPLE (set_color purple)
set NC (set_color normal)

# Memory buffer for limbic system (emotional memory)
set -g limbic_memory
for i in (seq $LIMBIC_MAX_MEMORY)
    set -g limbic_memory[$i] ""
end

# Initialize the limbic system
function init_limbic_system
    echo "$BLUE"Initializing limbic system..."$NC"
    
    # Reset emotional states to baseline
    set -g LIMBIC_AROUSAL 0.5
    set -g LIMBIC_VALENCE 0.5
    
    # Reset limbic structures to inactive state
    set -g AMYGDALA_STATE 0
    set -g HIPPOCAMPUS_STATE 0
    set -g HYPOTHALAMUS_STATE 0
    set -g THALAMUS_STATE 0
    set -g CINGULATE_STATE 0
    
    # Link to emotion system
    if type -q init_emotion_system
        # If emotion system is available, set up bidirectional connection
        echo "Linking limbic system to emotion system..."
    end
    
    # Link to memory system
    if type -q init_memory_system
        # If memory system is available, set up bidirectional connection
        echo "Linking limbic system to memory system..."
    end
    
    echo "$GREEN"Limbic system initialized successfully"$NC"
    return 0
end

# Amygdala function - Processes emotional salience and fear conditioning
function amygdala_process
    set -l stimulus $argv[1]
    set -l intensity $argv[2]
    set -l context $argv[3]
    
    echo "Amygdala processing stimulus: $stimulus"
    
    # Simple threat detection algorithm
    set -l threat_keywords "danger" "threat" "fear" "attack" "harmful"
    set -l threat_detected 0
    
    for keyword in $threat_keywords
        if string match -q "*$keyword*" $stimulus
            set threat_detected 1
            break
        end
    end
    
    if test $threat_detected -eq 1
        echo "$RED"Threat detected! Activating fear response"$NC"
        set -g AMYGDALA_STATE 1
        set -g LIMBIC_AROUSAL (math "min(1.0, $LIMBIC_AROUSAL + $intensity * 0.5)")
        set -g LIMBIC_VALENCE (math "max(0.0, $LIMBIC_VALENCE - $intensity * 0.3)")
        
        # Create fear memory with high emotional salience
        limbic_create_memory "$stimulus" "$context" (math "$intensity * 0.8") "fear"
    else
        echo "No threat detected in stimulus"
        set -g AMYGDALA_STATE 0
    end
    
    return $threat_detected
end

# Hippocampus function - Manages memory formation and context
function hippocampus_process
    set -l experience $argv[1]
    set -l context $argv[2]
    set -l emotional_strength $argv[3]
    
    echo "Hippocampus indexing experience with context: $context"
    
    # Stronger emotions create stronger memories
    set -l memory_strength (math "$emotional_strength * (0.5 + $LIMBIC_AROUSAL * 0.5)")
    
    # Create episodic memory with context
    set -g HIPPOCAMPUS_STATE 1
    limbic_create_memory "$experience" "$context" $memory_strength "episodic"
    
    # Link with long-term memory systems if available
    if type -q create_long_term_memory
        echo "Creating long-term memory record..."
        create_long_term_memory "$experience" "$context" $memory_strength
    end
    
    # Memory consolidation decreases over time
    set -g HIPPOCAMPUS_STATE (math "max(0.0, $HIPPOCAMPUS_STATE - 0.1)")
    
    return 0
end

# Hypothalamus function - Regulates homeostasis and drives
function hypothalamus_regulate
    set -l current_state $argv[1]
    set -l target_state $argv[2]
    
    set -l regulation_needed (math "abs($current_state - $target_state)")
    
    if test (echo "$regulation_needed > 0.2" | bc -l) -eq 1
        echo "$YELLOW"Homeostatic imbalance detected: $regulation_needed"$NC"
        set -g HYPOTHALAMUS_STATE 1
        
        # Generate drive based on imbalance
        set -l drive_strength (math "$regulation_needed * 5")
        echo "Generated homeostatic drive with strength: $drive_strength"
        
        # Trigger regulatory behaviors
        if type -q regulate_emotion_state
            echo "Engaging emotional regulation..."
            regulate_emotion_state (math "$target_state - $current_state")
        end
    else
        echo "Homeostasis within normal parameters"
        set -g HYPOTHALAMUS_STATE 0
    end
    
    return 0
end

# Thalamus function - Processes and relays sensory information
function thalamus_relay
    set -l sensory_input $argv[1]
    
    echo "Thalamus relaying sensory information..."
    set -g THALAMUS_STATE 1
    
    # Parse sensory input and determine its importance
    set -l input_priority 0.5 # Default medium priority
    
    # Check if input matches any emotional triggers
    if string match -q "*pain*" $sensory_input
        set input_priority 0.9 # High priority
    else if string match -q "*pleasure*" $sensory_input
        set input_priority 0.8 # High priority
    end
    
    echo "Sensory input priority: $input_priority"
    
    # Relay to appropriate systems based on priority
    if test (echo "$input_priority > $LIMBIC_THRESHOLD" | bc -l) -eq 1
        # High priority - route to amygdala first
        echo "Routing high priority input to amygdala..."
        amygdala_process $sensory_input $input_priority "sensory"
    else
        # Lower priority - standard processing
        echo "Normal priority sensory processing..."
    end
    
    # Gradually decrease activation after relay
    set -g THALAMUS_STATE (math "max(0.0, $THALAMUS_STATE - 0.2)")
    
    return 0
end

# Cingulate function - Conflict monitoring and resolution
function cingulate_resolve
    set -l option_a $argv[1]
    set -l option_b $argv[2]
    set -l context $argv[3]
    
    echo "$PURPLE"Cingulate cortex resolving conflict..."$NC"
    set -g CINGULATE_STATE 1
    
    # Extract valence and importance from options
    set -l valence_a (limbic_evaluate_option $option_a)
    set -l valence_b (limbic_evaluate_option $option_b)
    
    echo "Option A valence: $valence_a"
    echo "Option B valence: $valence_b"
    
    # Modify response based on current emotional state
    set valence_a (math "$valence_a * (1.0 + $LIMBIC_VALENCE - 0.5)")
    set valence_b (math "$valence_b * (1.0 + $LIMBIC_VALENCE - 0.5)")
    
    # Decision algorithm with slight randomness for exploration
    set -l random_factor (math "0.9 + (random 1 20) / 100") # 0.9-1.1
    set valence_a (math "$valence_a * $random_factor")
    
    if test (echo "$valence_a > $valence_b" | bc -l) -eq 1
        echo "Resolution: Selected Option A ($valence_a > $valence_b)"
        set -g CINGULATE_STATE 0.7
        return 1
    else
        echo "Resolution: Selected Option B ($valence_b > $valence_a)"
        set -g CINGULATE_STATE 0.7
        return 2
    end
end

# Evaluate emotional significance of an option
function limbic_evaluate_option
    set -l option $argv[1]
    
    # Default valence starts neutral
    set -l valence 0.5
    
    # Check for positive keywords
    set -l positive_keywords "good" "happy" "pleasure" "reward" "safe"
    for keyword in $positive_keywords
        if string match -q "*$keyword*" $option
            set valence (math "$valence + 0.1")
        end
    end
    
    # Check for negative keywords
    set -l negative_keywords "bad" "sad" "pain" "danger" "risk"
    for keyword in $negative_keywords
        if string match -q "*$keyword*" $option
            set valence (math "$valence - 0.1")
        end
    end
    
    # Bound between 0 and 1
    set valence (math "min(1.0, max(0.0, $valence))")
    
    return $valence
end

# Create an emotional memory in the limbic system
function limbic_create_memory
    set -l experience $argv[1]
    set -l context $argv[2]
    set -l strength $argv[3]
    set -l emotion_type $argv[4]
    
    # Find an empty slot or replace the weakest memory
    set -l weakest_strength 1.0
    set -l weakest_index 1
    
    for i in (seq $LIMBIC_MAX_MEMORY)
        if test -z "$limbic_memory[$i]"
            # Empty slot found
            set weakest_index $i
            break
        else
            # Extract strength from the memory
            set -l current_strength (echo $limbic_memory[$i] | awk -F"|" '{print $3}')
            if test (echo "$current_strength < $weakest_strength" | bc -l) -eq 1
                set weakest_strength $current_strength
                set weakest_index $i
            end
        end
    end
    
    # Create time stamp
    set -l timestamp (date "+%Y-%m-%d %H:%M:%S")
    
    # Store the memory
    set -g limbic_memory[$weakest_index] "$experience|$context|$strength|$emotion_type|$timestamp"
    
    echo "Created limbic memory #$weakest_index with strength $strength"
    return $weakest_index
end

# Retrieve memories based on emotional content or context
function limbic_retrieve_memories
    set -l query $argv[1]
    set -l emotion_type $argv[2] # Optional
    set -l min_strength $argv[3] # Optional
    
    if test -z "$min_strength"
        set min_strength 0.0
    end
    
    echo "Retrieving limbic memories matching: $query"
    set -l found_count 0
    
    for i in (seq $LIMBIC_MAX_MEMORY)
        if test -n "$limbic_memory[$i]"
            set -l memory $limbic_memory[$i]
            
            # Extract components
            set -l experience (echo $memory | awk -F"|" '{print $1}')
            set -l context (echo $memory | awk -F"|" '{print $2}')
            set -l strength (echo $memory | awk -F"|" '{print $3}')
            set -l mem_emotion_type (echo $memory | awk -F"|" '{print $4}')
            set -l timestamp (echo $memory | awk -F"|" '{print $5}')
            
            # Skip if strength is too low
            if test (echo "$strength < $min_strength" | bc -l) -eq 1
                continue
            end
            
            # Skip if emotion type doesn't match (if specified)
            if test -n "$emotion_type" -a "$mem_emotion_type" != "$emotion_type"
                continue
            end
            
            # Check if memory matches the query
            if string match -q "*$query*" "$experience" || string match -q "*$query*" "$context"
                echo "Memory #$i ($mem_emotion_type, strength $strength):"
                echo "  Experience: $experience"
                echo "  Context: $context"
                echo "  Created: $timestamp"
                set found_count (math "$found_count + 1")
            end
        end
    end
    
    echo "Found $found_count matching memories"
    return $found_count
end

# Process the emotional impact of an experience
function limbic_process_experience
    set -l experience $argv[1]
    set -l context $argv[2]
    set -l intensity $argv[3] # Optional intensity override
    
    if test -z "$intensity"
        set intensity 0.5 # Default moderate intensity
    end
    
    echo "$BLUE"Processing limbic experience: $experience"$NC"
    
    # First, let the thalamus relay the sensory information
    thalamus_relay "$experience"
    
    # Then, let the amygdala evaluate the emotional significance
    amygdala_process "$experience" $intensity "$context"
    
    # Finally, let the hippocampus form a memory of the experience
    hippocampus_process "$experience" "$context" $intensity
    
    # Adjust overall limbic state based on the experience
    set -g LIMBIC_AROUSAL (math "min(1.0, max(0.0, $LIMBIC_AROUSAL + ($intensity - 0.5) * 0.2))")
    
    # Show current limbic state
    echo "Current Limbic State:"
    echo "  Arousal: $LIMBIC_AROUSAL"
    echo "  Valence: $LIMBIC_VALENCE"
    echo "  Amygdala: $AMYGDALA_STATE"
    echo "  Hippocampus: $HIPPOCAMPUS_STATE"
    
    return 0
end

# Gradually decay emotional responses over time
function limbic_process_decay
    if test (echo "$LIMBIC_AROUSAL > 0.5" | bc -l) -eq 1
        set -g LIMBIC_AROUSAL (math "max(0.5, $LIMBIC_AROUSAL - $LIMBIC_DECAY)")
    else if test (echo "$LIMBIC_AROUSAL < 0.5" | bc -l) -eq 1
        set -g LIMBIC_AROUSAL (math "min(0.5, $LIMBIC_AROUSAL + $LIMBIC_DECAY)")
    end
    
    if test (echo "$LIMBIC_VALENCE > 0.5" | bc -l) -eq 1
        set -g LIMBIC_VALENCE (math "max(0.5, $LIMBIC_VALENCE - $LIMBIC_DECAY)")
    else if test (echo "$LIMBIC_VALENCE < 0.5" | bc -l) -eq 1
        set -g LIMBIC_VALENCE (math "min(0.5, $LIMBIC_VALENCE + $LIMBIC_DECAY)")
    end
    
    # Also decay the limbic structures
    set -g AMYGDALA_STATE (math "max(0.0, $AMYGDALA_STATE - $LIMBIC_DECAY)")
    set -g HIPPOCAMPUS_STATE (math "max(0.0, $HIPPOCAMPUS_STATE - $LIMBIC_DECAY)")
    set -g HYPOTHALAMUS_STATE (math "max(0.0, $HYPOTHALAMUS_STATE - $LIMBIC_DECAY)")
    set -g THALAMUS_STATE (math "max(0.0, $THALAMUS_STATE - $LIMBIC_DECAY)")
    set -g CINGULATE_STATE (math "max(0.0, $CINGULATE_STATE - $LIMBIC_DECAY)")
    
    return 0
end

# Process a fear response - fight, flight, or freeze
function limbic_fear_response
    set -l threat $argv[1]
    set -l context $argv[2]
    set -l intensity $argv[3]
    
    echo "$RED"Processing fear response to threat: $threat"$NC"
    
    # Increase arousal dramatically
    set -g LIMBIC_AROUSAL (math "min(1.0, $LIMBIC_AROUSAL + $intensity * 0.5)")
    
    # Decrease valence (fear is negative emotion)
    set -g LIMBIC_VALENCE (math "max(0.0, $LIMBIC_VALENCE - $intensity * 0.6)")
    
    # Choose response based on context and intensity
    set -l response_type
    
    if test (echo "$intensity > 0.8" | bc -l) -eq 1
        # High intensity - flight response
        echo "$RED"Flight response activated - emergency retreat"$NC"
        set response_type "flight"
    else if test (echo "$intensity > 0.5" | bc -l) -eq 1
        # Medium intensity - fight response
        echo "$RED"Fight response activated - defensive posture"$NC"
        set response_type "fight"
    else
        # Low intensity - freeze response
        echo "$YELLOW"Freeze response activated - assessing situation"$NC"
        set response_type "freeze"
    end
    
    # Create memory of the fear response with high salience
    limbic_create_memory "Fear response: $response_type" "$threat in $context" (math "$intensity + 0.3") "fear"
    
    return 0
end

# Process a reward response - pleasure and reinforcement
function limbic_reward_response
    set -l reward $argv[1]
    set -l context $argv[2]
    set -l intensity $argv[3]
    
    echo "$GREEN"Processing reward response: $reward"$NC"
    
    # Increase arousal moderately
    set -g LIMBIC_AROUSAL (math "min(1.0, $LIMBIC_AROUSAL + $intensity * 0.3)")
    
    # Increase valence (reward is positive emotion)
    set -g LIMBIC_VALENCE (math "min(1.0, $LIMBIC_VALENCE + $intensity * 0.7)")
    
    # Create memory of the reward with positive salience
    limbic_create_memory "Reward: $reward" "$context" $intensity "reward"
    
    # Reinforce behavior based on context
    if type -q reinforce_behavior
        echo "Reinforcing behavior pattern in $context..."
        reinforce_behavior $context $intensity
    end
    
    return 0
end

# Function to link to other systems
function limbic_link_to_systems
    # No-op if already linked
    if set -q limbic_linked
        return 0
    end
    
    # Link to the emotion system
    if type -q link_emotion_system
        echo "Linking limbic system to emotion processors..."
        link_emotion_system limbic_process_experience
    end
    
    # Link to the memory system
    if type -q link_memory_system
        echo "Linking limbic system to memory processors..."
        link_memory_system limbic_create_memory
    end
    
    set -g limbic_linked 1
    return 0
end

# Main function that runs the limbic system update cycle
function limbic_update_cycle
    # Process natural decay
    limbic_process_decay
    
    # Check for homeostatic regulation needs
    hypothalamus_regulate $LIMBIC_AROUSAL 0.5
    
    # Process any pending conflict resolution
    if test $CINGULATE_STATE -gt 0
        echo "Continuing conflict resolution process..."
    end
    
    return 0
end

# Register the limbic system with the main system
function register_limbic_system
    echo "Registering limbic system with core..."
    return 0
end

# Initialize when sourced
echo "Limbic system module loaded"