#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# export_qasm.fish - Functions for exporting quantum circuits to OpenQASM 2.0 format

# Source the quantum core
source src/quantum/quantum.fish

# Export a circuit to OpenQASM 2.0 format
function export_qasm
    set output_file $argv[1]
    
    if test -z "$output_file"
        set output_file "circuit.qasm"
    end
    
    # Start with QASM header
    echo "OPENQASM 2.0;" > $output_file
    echo "include \"qelib1.inc\";" >> $output_file
    
    # Declare quantum register
    echo "qreg q[$circuit_num_qubits];" >> $output_file
    echo "creg c[$circuit_num_qubits];" >> $output_file
    
    # Add gates
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
        
        # Format depends on gate type
        switch $gate_name
            case "H"
                echo "h q[$gate_targets];" >> $output_file
            case "X"
                echo "x q[$gate_targets];" >> $output_file
            case "Y"
                echo "y q[$gate_targets];" >> $output_file
            case "Z"
                echo "z q[$gate_targets];" >> $output_file
            case "CNOT"
                echo "cx q[$gate_targets[1]], q[$gate_targets[2]];" >> $output_file
            case "SWAP"
                echo "swap q[$gate_targets[1]], q[$gate_targets[2]];" >> $output_file
            case "*"
                echo "# Unsupported gate: $gate_name" >> $output_file
        end
    end
    
    # Add measurement
    echo "measure q -> c;" >> $output_file
    
    echo "Circuit exported to $output_file"
    return 0
end

# Generate QASM string (without writing to file)
function generate_qasm_string
    set qasm_string ""
    
    # QASM header
    set qasm_string "$qasm_string\nOPENQASM 2.0;"
    set qasm_string "$qasm_string\ninclude \"qelib1.inc\";"
    
    # Declare quantum register
    set qasm_string "$qasm_string\nqreg q[$circuit_num_qubits];"
    set qasm_string "$qasm_string\ncreg c[$circuit_num_qubits];"
    
    # Add gates
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
        
        # Format depends on gate type
        switch $gate_name
            case "H"
                set qasm_string "$qasm_string\nh q[$gate_targets];"
            case "X"
                set qasm_string "$qasm_string\nx q[$gate_targets];"
            case "Y"
                set qasm_string "$qasm_string\ny q[$gate_targets];"
            case "Z"
                set qasm_string "$qasm_string\nz q[$gate_targets];"
            case "CNOT"
                set qasm_string "$qasm_string\ncx q[$gate_targets[1]], q[$gate_targets[2]];"
            case "SWAP"
                set qasm_string "$qasm_string\nswap q[$gate_targets[1]], q[$gate_targets[2]];"
            case "*"
                set qasm_string "$qasm_string\n# Unsupported gate: $gate_name"
        end
    end
    
    # Add measurement
    set qasm_string "$qasm_string\nmeasure q -> c;"
    
    echo $qasm_string
    return 0
end

# Validate QASM syntax
function validate_qasm
    set qasm_file $argv[1]
    
    if test -z "$qasm_file"
        echo "Error: No QASM file specified"
        return 1
    end
    
    if not test -f "$qasm_file"
        echo "Error: QASM file $qasm_file does not exist"
        return 1
    end
    
    # In a real implementation, we would check for syntax errors
    # For now, just check for basic required elements
    
    set has_header (grep "OPENQASM 2.0;" "$qasm_file" | wc -l)
    set has_include (grep "include \"qelib1.inc\";" "$qasm_file" | wc -l)
    set has_qreg (grep "qreg" "$qasm_file" | wc -l)
    
    if test $has_header -eq 0
        echo "Error: Missing OPENQASM 2.0 header"
        return 1
    end
    
    if test $has_include -eq 0
        echo "Error: Missing qelib1.inc include"
        return 1
    end
    
    if test $has_qreg -eq 0
        echo "Error: No quantum register defined"
        return 1
    end
    
    echo "QASM syntax validation passed"
    return 0
end
