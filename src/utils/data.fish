#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# data.fish - Data storage and retrieval implementation for Noesis

# Source required dependencies
source src/utils/noesis_lib.fish

# Constants
set -g MAX_DATA_ENTRIES 1000

# Global variables
set -g data_keys
set -g data_values
set -g data_count 0

# Initialize the data storage
function init_data_storage
    set -g data_count 0
    for i in (seq 1 $MAX_DATA_ENTRIES)
        set -g data_keys[$i] ""
        set -g data_values[$i] ""
    end
    echo "Data storage system initialized"
end

# Store data with a key
function store_data
    set key $argv[1]
    set value $argv[2..-1]
    
    if test -z "$key" -o -z "$value"
        echo "Error: Key or value empty"
        return 1
    end
    
    # Check if key already exists
    for i in (seq 1 $data_count)
        if test "$data_keys[$i]" = "$key"
            # Update existing key
            set -g data_values[$i] "$value"
            echo "Updated data for key: $key"
            return 0
        end
    end
    
    # Key doesn't exist, check if we have space
    if test $data_count -ge $MAX_DATA_ENTRIES
        echo "Error: Data storage full"
        return 1
    end
    
    # Add new key-value pair
    set -g data_count (math $data_count + 1)
    set -g data_keys[$data_count] "$key"
    set -g data_values[$data_count] "$value"
    
    echo "Stored data with key: $key"
    return 0
end

# Retrieve data by key
function retrieve_data
    set key $argv[1]
    
    if test -z "$key"
        echo "Error: Empty key"
        return 1
    end
    
    for i in (seq 1 $data_count)
        if test "$data_keys[$i]" = "$key"
            echo $data_values[$i]
            return 0
        end
    end
    
    echo "Error: Key not found: $key"
    return 1
end

# Delete data by key
function delete_data
    set key $argv[1]
    
    if test -z "$key"
        echo "Error: Empty key"
        return 1
    end
    
    for i in (seq 1 $data_count)
        if test "$data_keys[$i]" = "$key"
            # Delete by shifting all entries after this one
            for j in (seq $i (math $data_count - 1))
                set -g data_keys[$j] $data_keys[(math $j + 1)]
                set -g data_values[$j] $data_values[(math $j + 1)]
            end
            
            # Clear the last entry
            set -g data_keys[$data_count] ""
            set -g data_values[$data_count] ""
            set -g data_count (math $data_count - 1)
            
            echo "Deleted data with key: $key"
            return 0
        end
    end
    
    echo "Error: Key not found: $key"
    return 1
end

# List all keys
function list_data_keys
    if test $data_count -eq 0
        echo "No data stored"
        return 1
    end
    
    echo "Stored data keys:"
    for i in (seq 1 $data_count)
        echo "  $data_keys[$i]"
    end
    
    return 0
end

# Clear all data
function clear_data_storage
    init_data_storage
    echo "Data storage cleared"
    return 0
end
