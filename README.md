# Noesis V.0.1.1-beta

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

The [Noesis License](LICENSE) introduces unique terms and conditions that distinguish it from standard open-source licenses such as the MIT License. Below are the key differences:

1. Prohibition of Harmful Use: The license explicitly prohibits the use of the software for unlawful purposes or in ways that could harm humans, animals, or other living beings, either directly or indirectly.

2. Profit Sharing with Charities: If the software serves as a core component in a profit-generating system, the user is required to donate 10% of the net profits directly resulting from such use to a recognized non-profit or charitable organization.

These additional clauses aim to ensure ethical use, promote transparency, and support charitable causes while maintaining the flexibility of an open-source model.
