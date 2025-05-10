# Noesis

![logo](./noesis-logo.jpg)

Noesis is a C project that simulates a synthetic conscious system without using any external libraries, focusing solely on low-level logic and memory structures.

## Concept

The core idea behind Noesis is to explore how minimal cognitive components such as **perception**, **memory**, **emotion**, and **logic** can interact in a self-contained system. It doesn't aim to recreate human consciousness, but rather to represent a foundational cognitive engine with simple behavior cycles.

## Structure

```
noesis/
├── LICENSE
├── Makefile
├── noesis-logo.jpg
├── README.md
├── SECURITY.md
├── data/
│   └── gate_defs.h
├── include/
│   ├── core/
│   │   ├── emotion.h
│   │   ├── logic.h
│   │   ├── memory.h
│   │   └── perception.h
│   ├── quantum/
│   │   ├── backend.h
│   │   ├── compiler.h
│   │   ├── export.h
│   │   ├── quantum.h
│   │   └── field/
│   │       └── quantum_field.h
│   └── utils/
│       ├── data.h
│       ├── helper.h
│       └── timer.h
├── logic_input/
│   └── example.logic
├── out_qasm/
│   └── circuit.qasm
├── source/
│   ├── core/
│   │   ├── emotion.c
│   │   ├── logic.c
│   │   ├── main.c
│   │   ├── memory.c
│   │   └── perception.c
│   ├── quantum/
│   │   ├── backend_ibm.c
│   │   ├── backend_stub.c
│   │   ├── compiler.c
│   │   ├── export_json.c
│   │   ├── export_qasm.c
│   │   ├── quantum.c
│   │   └── field/
│   │       └── quantum_field.c
│   ├── tools/
│   │   ├── qbuild.c
│   │   └── qrun.c
│   └── utils/
│       ├── data.c
│       ├── helper.c
│       └── timer.c
├── tests/
│   ├── core_tests.c
│   ├── main_tests.c
│   ├── qlogic_tests.c
│   └── utils_tests.c
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
