#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# quantum.fish – core gate & circuit logic for Noesis quantum computing

# Constants
set -g MAX_QUBITS 16
set -g MAX_GATES 256

# Define data structures as arrays
# In Fish we'll use indexed arrays with naming conventions to simulate structures

# Global variables for circuit state
set -g qubits_id
set -g qubits_allocated
set -g gates_type
set -g gates_ntargets
set -g gates_targets
set -g circuit_num_qubits 0
set -g circuit_num_gates 0
set -g circuit_gates

# Initialize arrays
for i in (seq 1 $MAX_QUBITS)
    set -g qubits_id[$i] (math $i - 1)
    set -g qubits_allocated[$i] 0
end

for i in (seq 1 $MAX_GATES)
    set -g gates_type[$i] 0
    set -g gates_ntargets[$i] 0
    set -g gates_targets[$i] ""
    set -g circuit_gates[$i] 0
end

# Load gate definitions from data file
# This would normally load from gate_defs.h
# For now we'll define some basic gates
set -g GATE_H 1      # Hadamard
set -g GATE_X 2      # Pauli-X
set -g GATE_Y 3      # Pauli-Y
set -g GATE_Z 4      # Pauli-Z
set -g GATE_CNOT 5   # Controlled NOT
set -g GATE_SWAP 6   # SWAP

set -g GATE_NAMES "H" "X" "Y" "Z" "CNOT" "SWAP"
set -g GATE_TYPES $GATE_H $GATE_X $GATE_Y $GATE_Z $GATE_CNOT $GATE_SWAP
set -g GATE_TABLE_LEN 6

# Initialization function
function q_init
    for i in (seq 1 $MAX_QUBITS)
        set -g qubits_id[$i] (math $i - 1)
        set -g qubits_allocated[$i] 0
    end
    
    set -g circuit_num_qubits 0
    set -g circuit_num_gates 0
    
    echo "Quantum system initialized with $MAX_QUBITS qubits capacity"
end

# Allocate a qubit
function q_alloc
    for i in (seq 1 $MAX_QUBITS)
        if test $qubits_allocated[$i] -eq 0
            set -g qubits_allocated[$i] 1
            
            if test (math $i) -gt $circuit_num_qubits
                set -g circuit_num_qubits $i
            end
            
            echo "Allocated qubit #"(math $i - 1)
            return (math $i - 1)  # Return the qubit ID
        end
    end
    
    echo "Error: Out of qubits" >&2
    return -1  # Error: out of qubits
end

# Add a gate to the circuit
function q_add_gate
    set name $argv[1]
    set targets $argv[2..-1]
    set ntargets (count $targets)
    
    if test $circuit_num_gates -ge $MAX_GATES
        echo "Error: Circuit at maximum gate capacity" >&2
        return -1
    end
    
    # Find gate type from name
    set gate_index -1
    for i in (seq 1 $GATE_TABLE_LEN)
        if test "$name" = "$GATE_NAMES[$i]"
            set gate_index $i
            break
        end
    end
    
    if test $gate_index -eq -1
        echo "Error: Unknown gate '$name'" >&2
        return -2
    end
    
    # Add gate to circuit
    set gate_pos (math $circuit_num_gates + 1)
    set -g gates_type[$gate_pos] $GATE_TYPES[$gate_index]
    set -g gates_ntargets[$gate_pos] $ntargets
    set -g gates_targets[$gate_pos] $targets
    
    # Update circuit
    set -g circuit_gates[$gate_pos] $gate_pos
    set -g circuit_num_gates (math $circuit_num_gates + 1)
    
    echo "Added $name gate to circuit (position $circuit_num_gates)"
    return 0
end

# Get the current circuit
function q_get_circuit
    echo "Circuit state:"
    echo "  Qubits: $circuit_num_qubits"
    echo "  Gates: $circuit_num_gates"
    
    # Output the circuit gates
    for i in (seq 1 $circuit_num_gates)
        set gate_type $gates_type[$i]
        set gate_name ""
        
        # Find gate name from type
        for j in (seq 1 $GATE_TABLE_LEN)
            if test $gate_type -eq $GATE_TYPES[$j]
                set gate_name $GATE_NAMES[$j]
                break
            end
        end
        
        echo "  Gate $i: $gate_name targets: $gates_targets[$i]"
    end
end

# String equality helper
function str_eq
    set a $argv[1]
    set b $argv[2]
    
    if test "$a" = "$b"
        return 0
    else
        return 1
    end
end

# Process with Noesis core
function q_process_with_noesis
    set input $argv[1]
    
    echo "Running in standalone mode. Noesis Core not available."
    echo "Input: $input"
end
