# Noesis

![logo](./noesis-logo.jpg)

Noesis is a C project that simulates a synthetic conscious system without using any external libraries, focusing solely on low-level logic and memory structures.

## Concept

The core idea behind Noesis is to explore how minimal cognitive components such as **perception**, **memory**, **emotion**, and **logic** can interact in a self-contained system. It doesn't aim to recreate human consciousness, but rather to represent a foundational cognitive engine with simple behavior cycles.

## Structure

```
noesis/
├── src/                            # Main code base
│   ├── core/                       # Core system functions for synthetic consciousness
│   │   ├── memory.c                # Memory management
│   │   ├── perception.c            # Perception logic
│   │   ├── logic.c                 # Logical processing
│   │   └── emotion.c               # Emotion processing
│   ├── quantum/                    # Module from libc_quantum_middleware
│   │   ├── quantum.c               # Core quantum circuit & gate operations
│   │   ├── compiler.c              # Logic parsing and translation to quantum format
│   │   ├── export_qasm.c           # Export circuit to QASM format
│   │   ├── export_json.c           # Export to JSON (for Braket)
│   │   ├── backend_ibm.c           # Connect to IBM Q API
│   │   └── backend_stub.c          # Dummy simulator (for offline test)
│   ├── tools/                      # CLI tools from quantum middleware
│   │   ├── qbuild.c                # Compile logic to QASM format
│   │   └── qrun.c                  # Send QASM to quantum backend
│   ├── utils/                      # Utility functions
│   │   ├── timer.c                 # Timer utilities
│   │   ├── data.c                  # Data management utilities
│   │   └── helper.c                # Helper functions
│   └── main.c                      # Entry point of the system
│
├── include/
│   ├── core/                       # Core system headers
│   │   ├── memory.h                # Memory management header
│   │   ├── perception.h            # Perception header
│   │   ├── logic.h                 # Logic processing header
│   │   └── emotion.h               # Emotion processing header
│   ├── quantum/                    # Quantum middleware headers
│   │   ├── quantum.h               # Header for quantum operations
│   │   ├── compiler.h              # Compiler header for logic to quantum
│   │   ├── export.h                # Export functions header (QASM/JSON)
│   │   └── backend.h               # Quantum hardware backend interface
│   ├── utils/                      # Utility headers
│   │   ├── timer.h                 # Timer utilities header
│   │   ├── data.h                  # Data management header
│   │   └── helper.h                # Helper functions header
│
├── data/                           # Quantum gate constants
│   └── gate_defs.h                 # Gate definitions
│
├── logic_input/                    # Input logic files for the compiler
│   └── example.logic               # Example logic file
│
├── out_qasm/                       # Output directory for compiled QASM files
│   └── circuit.qasm                # Output QASM file
│
├── build/                          # Compiled files directory
│
├── docs/                           # Documentation for the system
│
├── tests/                          # Unit tests
│   ├── core_tests.c                # Core system tests
│   ├── utils_tests.c               # Utility function tests
│   ├── main_tests.c                # Main system tests
│   └── test_circuit.c              # Quantum circuit tests (from quantum middleware)
│
├── Makefile                        # Build script for the entire system
├── README.md                       # Project documentation
└── LICENSE                         # License file for the project
```

## Build

To build the project:

```bash
make
```

To run basic tests:

```bash
make test
```

To clean up compiled files:

```bash
make clean
```

## License

This project is licensed under the [Noesis License](LICENSE), a permissive open license designed specifically for this project.
