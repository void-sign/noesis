#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# quantum_field.fish - Quantum field theory simulation (simplified)

# Source the quantum core
source system/memory/quantum/unit.fish

# Constants for field simulation
set -g FIELD_SIZE 10
set -g FIELD_DIMENSIONS 2
set -g FIELD_POINTS (math "$FIELD_SIZE ^ $FIELD_DIMENSIONS")

# Initialize arrays for field values
set -g field_values
set -g field_momentum
set -g field_energy

# Initialize the quantum field
function init_quantum_field
    echo "Initializing quantum field simulation ($FIELD_DIMENSIONS dimensions, $FIELD_SIZE points per dimension)"
    
    # Initialize field values to zero
    for i in (seq 1 $FIELD_POINTS)
        set -g field_values[$i] 0.0
        set -g field_momentum[$i] 0.0
        set -g field_energy[$i] 0.0
    end
    
    echo "Quantum field initialized with $FIELD_POINTS points"
    return 0
end

# Apply a perturbation to the field at a specific point
function apply_field_perturbation
    set point_x $argv[1]
    set point_y $argv[2]
    set amplitude $argv[3]
    
    if test (count $argv) -lt 3
        echo "Usage: apply_field_perturbation x y amplitude"
        return 1
    end
    
    # Validate coordinates
    if test $point_x -lt 0 -o $point_x -ge $FIELD_SIZE -o $point_y -lt 0 -o $point_y -ge $FIELD_SIZE
        echo "Error: Coordinates out of bounds"
        return 1
    end
    
    # Calculate index in 1D array
    set index (math "$point_y * $FIELD_SIZE + $point_x + 1")
    
    # Apply perturbation
    set -g field_values[$index] $amplitude
    
    echo "Applied perturbation of amplitude $amplitude at point ($point_x, $point_y)"
    return 0
end

# Simulate field evolution for a number of time steps
function evolve_field
    set time_steps $argv[1]
    
    if test -z "$time_steps"
        set time_steps 1
    end
    
    echo "Evolving quantum field for $time_steps time steps"
    
    # Add debugging to track progress
    echo "DEBUG: Starting evolution with field size $FIELD_SIZE, dimensions $FIELD_DIMENSIONS, total points $FIELD_POINTS"
    
    # Time step size
    set dt 0.1
    
    # Simple field evolution using a basic differential equation
    for step in (seq 1 $time_steps)
        # First update momentum based on the Laplacian of the field
        # Only show step number to avoid console flood
        echo -n "."
        
        # Simplified calculation logic to reduce CPU usage
        for y in (seq 0 (math $FIELD_SIZE - 1))
            for x in (seq 0 (math $FIELD_SIZE - 1))
                set idx (math "$y * $FIELD_SIZE + $x + 1")
                
                # Get neighboring points with periodic boundary conditions
                set y_up (math "($y - 1 + $FIELD_SIZE) % $FIELD_SIZE")
                set y_down (math "($y + 1) % $FIELD_SIZE")
                set x_left (math "($x - 1 + $FIELD_SIZE) % $FIELD_SIZE")
                set x_right (math "($x + 1) % $FIELD_SIZE")
                
                set idx_up (math "$y_up * $FIELD_SIZE + $x + 1")
                set idx_down (math "$y_down * $FIELD_SIZE + $x + 1")
                set idx_left (math "$y * $FIELD_SIZE + $x_left + 1")
                set idx_right (math "$y * $FIELD_SIZE + $x_right + 1")
                
                # Calculate Laplacian (sum of neighbors minus 4 * center)
                set laplacian (math "$field_values[$idx_up] + $field_values[$idx_down] + \
                                $field_values[$idx_left] + $field_values[$idx_right] - \
                                4 * $field_values[$idx]")
                
                # Update momentum
                set -g field_momentum[$idx] (math "$field_momentum[$idx] + $laplacian * $dt")
            end
        end
        
        # Then update field values based on momentum
        for i in (seq 1 $FIELD_POINTS)
            set -g field_values[$i] (math "$field_values[$i] + $field_momentum[$i] * $dt")
        end
        
        # Update field energy (kinetic + potential)
        for i in (seq 1 $FIELD_POINTS)
            set kinetic (math "0.5 * $field_momentum[$i] * $field_momentum[$i]")
            set potential (math "0.5 * $field_values[$i] * $field_values[$i]")
            set -g field_energy[$i] (math "$kinetic + $potential")
        end
    end
    
    echo "Field evolution complete"
    return 0
end

# Calculate the total energy in the field
function calculate_total_energy
    set -l total 0
    
    for i in (seq 1 $FIELD_POINTS)
        set total (math "$total + $field_energy[$i]")
    end
    
    echo "Total field energy: $total"
    return 0
end

# Visualize the field (text-based)
function visualize_field
    echo "Quantum field visualization:"
    
    # Simple ASCII visualization
    for y in (seq 0 (math $FIELD_SIZE - 1))
        set -l line ""
        
        for x in (seq 0 (math $FIELD_SIZE - 1))
            set idx (math "$y * $FIELD_SIZE + $x + 1")
            
            # Convert field value to character
            set val $field_values[$idx]
            
            # Get color based on field value
            set color ""
            if test (math "abs($val)") -lt 0.1
                set color (set_color white)
                set line "$line$color "
            else if test (math "abs($val)") -lt 0.3
                set color (set_color cyan)
                set line "$line$color."
            else if test (math "abs($val)") -lt 0.5
                set color (set_color blue)
                set line "$line$color-"
            else if test (math "abs($val)") -lt 0.7
                set color (set_color green)
                set line "$line$color+"
            else if test (math "abs($val)") -lt 0.9
                set color (set_color yellow)
                set line "$line$color*"
            else
                set color (set_color red)
                set line "$line$color#"
            end
        end
        
        echo "$line"(set_color normal)
    end
    
    return 0
end

# Run an interactive demo of the quantum field
function demo_quantum_field
    echo "Starting quantum field interactive demo..."
    
    # Initialize the quantum field
    init_quantum_field
    
    # Add an initial perturbation at the center
    set center (math "floor($FIELD_SIZE/2)")
    apply_field_perturbation $center $center 1.0
    
    # Show the initial field
    echo "Initial field state:"
    visualize_field
    
    # Evolve the field for several time steps
    for step in (seq 1 20)
        # Clear the screen between updates
        clear
        
        echo "Quantum Field Evolution - Step $step/20"
        # Evolve for a single step
        evolve_field 1
        
        # Show the updated field
        visualize_field
        
        # Show energy
        calculate_total_energy
        
        # Sleep briefly to make the animation visible
        sleep 0.2
    end
    
    echo
    echo "Demo complete! Final field state:"
    visualize_field
    
    return 0
end

# Run a quantum wave interference demo
function demo_wave_interference
    echo "Starting quantum wave interference demo..."
    
    # Initialize the quantum field
    init_quantum_field
    
    # Add two initial perturbations
    set quarter (math "floor($FIELD_SIZE/4)")
    set three_quarter (math "floor($FIELD_SIZE*3/4)")
    set center (math "floor($FIELD_SIZE/2)")
    
    apply_field_perturbation $quarter $center 1.0
    apply_field_perturbation $three_quarter $center 1.0
    
    # Show the initial field
    echo "Initial field state (two wave sources):"
    visualize_field
    
    # Evolve the field for several time steps
    for step in (seq 1 30)
        # Clear the screen between updates
        clear
        
        echo "Quantum Wave Interference - Step $step/30"
        # Evolve for a single step
        evolve_field 1
        
        # Show the updated field
        visualize_field
        
        # Show energy
        calculate_total_energy
        
        # Sleep briefly to make the animation visible
        sleep 0.2
    end
    
    echo
    echo "Demo complete! Final interference pattern:"
    visualize_field
    
    return 0
end

# Run a quantum vs classical computing demonstration
function demo_quantum_vs_classical
    echo "Starting Quantum vs Classical Computing Demo..."
    echo "This demo illustrates the difference between quantum and classical approaches"
    echo
    
    # Initialize the quantum field for superposition demonstration
    init_quantum_field
    
    # Set up initial state - superposition in the center
    set center (math "floor($FIELD_SIZE/2)")
    
    echo "Setting up a quantum system in superposition..."
    apply_field_perturbation $center $center 0.5
    
    # Show the superposition state
    echo "Quantum state (representing superposition):"
    visualize_field
    echo
    
    echo "In quantum computing, a qubit can exist in superposition"
    echo "representing both 0 and 1 states simultaneously."
    echo "Press enter to continue..." 
    read
    
    clear
    
    # Show classical nodes
    echo "Classical Computing: Two nodes with binary states"
    echo
    echo "Node A: Can be either 0 or 1"
    echo "Node B: Can be either 0 or 1"
    echo
    echo "Possible states: (0,0), (0,1), (1,0), or (1,1)"
    echo "Each node must be in exactly ONE state at any time."
    echo
    
    # Simulate a classical evolution
    echo "Classical simulation requires handling each state separately."
    echo "Press enter to see the quantum difference..." 
    read
    
    clear
    
    # Quantum wave collapse demo
    echo "Quantum Measurement: Collapsing the superposition"
    
    # Create a perturbation that will evolve
    apply_field_perturbation $center $center 1.0
    echo "Initial quantum state:"
    visualize_field
    
    echo
    echo "When we evolve the quantum field, it maintains superpositions..."
    echo "Press enter to see evolution..." 
    read
    
    # Evolve for several steps showing wave-like behavior
    for step in (seq 1 10)
        clear
        echo "Quantum Evolution - Step $step/10"
        evolve_field 1
        visualize_field
        sleep 0.3
    end
    
    echo
    echo "This demo shows why quantum systems require exponentially more"
    echo "resources to simulate on classical computers as they get larger."
    echo "A system with N qubits requires 2^N classical values to represent."
    echo
    echo "Demo complete!"
    
    return 0
end
