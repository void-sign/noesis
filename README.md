# Noesis

![logo](./noesis-logo.jpg)

Noesis is a C project that simulates a synthetic conscious system without using any external libraries, focusing solely on low-level logic and memory structures.

## Concept

The core idea behind Noesis is to explore how minimal cognitive components such as **perception**, **memory**, **emotion**, and **logic** can interact in a self-contained system. It doesn't aim to recreate human consciousness, but rather to represent a foundational cognitive engine with simple behavior cycles.

## Structure

```
.
├── main.c
├── core
│   ├── emotion.c / emotion.h
│   ├── logic.c / logic.h
│   ├── memory.c / memory.h
│   ├── perception.c / perception.h
│   ├── data.c / data.h
│   ├── helper.c / helper.h
│   └── timer.c / timer.h
├── tests
│   ├── core_tests.c
│   ├── main_tests.c
│   └── utils_tests.c
├── Makefile
├── .gitignore
└── LICENSE
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
