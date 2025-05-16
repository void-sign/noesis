#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# backend_stub.fish - Stub implementation of a quantum backend
# This provides a simple simulator for testing

# Source the quantum core
# The quantum functionality is now in system/memory/quantum/unit.fish
# No need to source it here as it's already sourced in soul/intent.fish

# Initialize the stub backend
function stub_init
    echo "Initializing stub quantum backend"
    q_init
    return 0
end

# Run a circuit on the stub simulator
function stub_run_circuit
    # Check if circuit is empty
    if test $circuit_num_gates -eq 0
        echo "No circuit to run"
        return 1
    end
    
    echo "Running circuit with $circuit_num_gates gates on stub simulator"
    
    # This is a very simplified simulation
    # In a real implementation, we would:
    # 1. Initialize a quantum state vector
    # 2. Apply each gate to the state vector
    # 3. Perform measurement and return results
    
    # For now, just print some information and return simulated results
    echo "Circuit execution:"
    
    # Show initialization
    echo "Initializing $circuit_num_qubits qubits to |0>"
    
    # Show gates being applied
    for i in (seq 1 $circuit_num_gates)
        set gate_type $gates_type[$i]
        set gate_targets $gates_targets[$i]
        
        # Find gate name from type
        for j in (seq 1 $GATE_TABLE_LEN)
            if test $gate_type -eq $GATE_TYPES[$j]
                set gate_name $GATE_NAMES[$j]
                break
            end
        end
        
        echo "Applying $gate_name gate to qubits: $gate_targets"
    end
    
    # Show measurement results (simulated)
    echo "Measurement results:"
    
    # Generate some random results
    set -l total_shots 100
    set -l state_count (math "2 ^ $circuit_num_qubits")
    
    # For a small number of qubits, we can enumerate all possible states
    if test $circuit_num_qubits -le 4
        for i in (seq 0 (math $state_count - 1))
            # Convert to binary representation
            set -l binary_state (printf "%0*b" $circuit_num_qubits $i)
            
            # Random count for this state
            set -l count (random 0 $total_shots)
            set total_shots (math "$total_shots - $count")
            
            if test $count -gt 0
                echo "  |$binary_state>: $count shots"
            end
        end
    else
        # For larger circuits, just show a few states
        for i in (seq 1 5)
            # Generate a random state
            set -l state ""
            for j in (seq 1 $circuit_num_qubits)
                set state $state(random 0 1)
            end
            
            # Random count
            set -l count (random 1 (math "floor($total_shots / 5)"))
            set total_shots (math "$total_shots - $count")
            
            echo "  |$state>: $count shots"
        end
    end
    
    return 0
end

# Get the current quantum state (simulated)
function stub_get_state
    # In a real simulator, we would return the actual quantum state vector
    # For now, just print a simulated state
    
    echo "Simulated quantum state:"
    
    # For a small number of qubits, we can show the full state vector
    if test $circuit_num_qubits -le 3
        set -l state_count (math "2 ^ $circuit_num_qubits")
        
        for i in (seq 0 (math $state_count - 1))
            # Convert to binary representation
            set -l binary_state (printf "%0*b" $circuit_num_qubits $i)
            
            # Generate random amplitude (simplified)
            set -l amplitude_real (math "scale=4; rand() / 32767.0")
            set -l amplitude_imag (math "scale=4; rand() / 32767.0")
            
            echo "  |$binary_state>: $amplitude_real + $amplitude_imag"i""
        end
    else
        # For larger circuits, just show that it's too large to display
        echo "  State vector too large to display ($circuit_num_qubits qubits)"
        echo "  State space has 2^$circuit_num_qubits = "(math "2 ^ $circuit_num_qubits")" dimensions"
    end
    
    return 0
end

# Reset the simulator to initial state
function stub_reset
    echo "Resetting stub quantum simulator"
    q_init
    return 0
end
