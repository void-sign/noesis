#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# data.fish - Data handling functions for Noesis

# Data storage - using fish variables for persistence
set -g data_keys
set -g data_values
set -g data_count 0

# Initialize data storage
function init_data_storage
    set -g data_count 0
    set -e data_keys
    set -e data_values
    set -g data_keys
    set -g data_values
    
    echo "Data storage initialized"
    return 0
end

# Store a value
function store_data
    set key $argv[1]
    set value $argv[2..-1]
    
    if test -z "$key"
        echo "Error: Empty key"
        return 1
    end
    
    # Check if key already exists
    for i in (seq 1 $data_count)
        if test "$data_keys[$i]" = "$key"
            # Update existing key
            set -g data_values[$i] $value
            echo "Updated key: $key"
            return 0
        end
    end
    
    # Add new key-value pair
    set -g data_count (math $data_count + 1)
    set -g data_keys[$data_count] $key
    set -g data_values[$data_count] $value
    
    echo "Stored key: $key"
    return 0
end

# Retrieve a value
function retrieve_data
    set key $argv[1]
    
    if test -z "$key"
        echo "Error: Empty key"
        return 1
    end
    
    # Search for the key
    for i in (seq 1 $data_count)
        if test "$data_keys[$i]" = "$key"
            echo $data_values[$i]
            return 0
        end
    end
    
    echo "Key not found: $key"
    return 1
end

# Delete a key-value pair
function delete_data
    set key $argv[1]
    
    if test -z "$key"
        echo "Error: Empty key"
        return 1
    end
    
    # Search for the key
    for i in (seq 1 $data_count)
        if test "$data_keys[$i]" = "$key"
            # Remove the key-value pair
            set -e data_keys[$i]
            set -e data_values[$i]
            
            # Rebuild the arrays to remove the gap
            set -g data_keys $data_keys
            set -g data_values $data_values
            set -g data_count (math $data_count - 1)
            
            echo "Deleted key: $key"
            return 0
        end
    end
    
    echo "Key not found: $key"
    return 1
end

# List all keys
function list_keys
    if test $data_count -eq 0
        echo "No keys in storage"
        return 0
    end
    
    echo "Keys in storage ($data_count total):"
    for i in (seq 1 $data_count)
        echo "  $data_keys[$i]"
    end
    
    return 0
end

# Save data to a file
function save_data_to_file
    set filename $argv[1]
    
    if test -z "$filename"
        echo "Error: No filename provided"
        return 1
    end
    
    # Clear the file
    echo "# Noesis data storage" > $filename
    echo "# Saved on "(date) >> $filename
    echo "" >> $filename
    
    # Write each key-value pair
    for i in (seq 1 $data_count)
        echo "$data_keys[$i]=$data_values[$i]" >> $filename
    end
    
    echo "Data saved to $filename"
    return 0
end

# Load data from a file
function load_data_from_file
    set filename $argv[1]
    
    if test -z "$filename"
        echo "Error: No filename provided"
        return 1
    end
    
    if not test -f "$filename"
        echo "Error: File not found: $filename"
        return 1
    end
    
    # Initialize data storage
    init_data_storage
    
    # Read the file line by line
    for line in (cat $filename)
        # Skip comments and empty lines
        if test -z "$line" -o (string sub -l 1 "$line") = "#"
            continue
        end
        
        # Parse key-value pairs
        set parts (string split "=" "$line")
        
        if test (count $parts) -ge 2
            set key $parts[1]
            set value $parts[2..-1]
            
            # Store the data
            store_data $key $value
        end
    end
    
    echo "Data loaded from $filename"
    return 0
end
