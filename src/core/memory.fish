#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# memory.fish - Memory management implementations for Noesis

# Define memory constants
set -g MAX_MEMORIES 1000
set -g SHORT_TERM_LIMIT 10
set -g MID_TERM_LIMIT 100

# Define memory object structure (simulated in Fish)
# In Fish, we'll use associative arrays to simulate structured data

# Initialize global variables for memory storage
set -g memories
set -g memory_count 0
set -g short_term_start 0
set -g mid_term_start 0

# Initialize the memory system
function init_memory_system
    set -g memory_count 0
    set -g short_term_start 0
    set -g mid_term_start 0
    
    # Clear existing memories
    set -e memories
    set -g memories
    
    echo "Memory system initialized"
    return 0
end

# Store a memory
function store_memory
    set -l content $argv[1]
    set -l importance $argv[2]
    
    if test -z "$importance"
        set importance 1  # Default importance
    end
    
    if test -z "$content"
        echo "Cannot store empty memory"
        return 1
    end
    
    # Check if we've reached memory capacity
    if test $memory_count -ge $MAX_MEMORIES
        echo "Memory capacity reached, consolidating..."
        consolidate_memories
    end
    
    # Create timestamp
    set timestamp (date +%s)
    
    # Store the memory (using indexed array since Fish doesn't have structs)
    set -g memories[$memory_count]_content $content
    set -g memories[$memory_count]_timestamp $timestamp
    set -g memories[$memory_count]_importance $importance
    set -g memories[$memory_count]_access_count 0
    
    # Increment memory count
    set -g memory_count (math $memory_count + 1)
    
    echo "Memory stored: $content (importance: $importance)"
    return 0
end

# Retrieve a memory by content match
function retrieve_memory
    set -l query $argv[1]
    
    if test -z "$query"
        echo "Empty query"
        return 1
    end
    
    # Search for memories matching the query
    for i in (seq 0 (math $memory_count - 1))
        if string match -q "*$query*" $memories[$i]_content
            # Increment access count
            set -g memories[$i]_access_count (math $memories[$i]_access_count + 1)
            
            # Return the memory
            echo "Memory #$i: $memories[$i]_content"
            echo "Importance: $memories[$i]_importance"
            echo "Access count: $memories[$i]_access_count"
            return 0
        end
    end
    
    echo "No matching memory found"
    return 1
end

# Consolidate memories (remove least important/accessed memories)
function consolidate_memories
    echo "Consolidating memories..."
    
    # This is a simplified version of memory consolidation
    # In practice, this would involve more complex algorithms
    
    # For now, just keep the most important half
    set -l half_count (math "floor($memory_count / 2)")
    
    # Remove the least important half
    set -g memory_count $half_count
    
    echo "Memory consolidation complete. Remaining memories: $memory_count"
    return 0
end
