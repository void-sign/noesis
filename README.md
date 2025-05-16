# Noesis v2.2.0

![Noesis Logo](noesis-logo.jpg)

> Synthetic Conscious

## Overview

Noesis is a synthetic consciousness simulation engine designed to explore the principles of artificial consciousness and cognition. The project is now structured as two separate repositories with different licenses to facilitate wider adoption and integration.

## Terminal Preview

![Noesis Terminal](noesis-terminal.jpg)

### Directory Structure
```
noesis/
├── soul/                                  # Consciousness core implementation
│   └── intent.fish                        # Intent processing system
├── system/                                # System components
│   ├── ai-model/                          # AI integration with Hugging Face models
│   │   ├── consciousness.fish             # Consciousness theories implementation
│   │   ├── test-ai.fish                   # AI testing framework
│   │   └── unit.fish                      # AI core module
│   ├── control/                           # Control subsystems
│   │   ├── intent-shell.fish              # Shell command processor
│   │   ├── limbric/                       # Limbric system
│   │   └── ...
│   ├── emotion/                           # Emotion processing
│   │   └── unit.fish                      # Emotion core module
│   ├── memory/                            # Memory subsystems
│   │   ├── long.fish                      # Long-term memory functions
│   │   ├── short.fish                     # Short-term memory functions
│   │   ├── unit.fish                      # Memory core module
│   │   ├── quantum/                       # Quantum memory implementation
│   │   │   ├── backend-ibm.fish           # IBM quantum backend integration
│   │   │   ├── backend-stub.fish          # Stub backend for testing
│   │   │   ├── compiler.fish              # Quantum compiler
│   │   │   ├── export-qasm.fish           # QASM exporter
│   │   │   ├── unit.fish                  # Quantum core module
│   │   │   └── field/                     # Quantum field implementation
│   │   │       └── quantum-field.fish     # Quantum field module
│   │   └── ...
│   └── perception/                        # Perception processing
│       ├── api.fish                       # Perception API
│       └── unit.fish                      # Perception core module
├── docs/                                  # Documentation files
│   ├── SECURITY.md                        # Security policy
│   └── changelogs/                        # Version history and release notes
│       └── CHANGELOG_v2.2.0.md            # Latest version changelog
├── build.fish                             # Main build script for Fish shell
├── run.fish                               # Main run script for Fish shell
├── run-simplified.fish                    # Simplified run script
├── test.fish                              # Test execution script
├── install.fish                           # Installation script
├── Dockerfile                             # Docker configuration file
├── LICENSE                                # License file
└── noesis-logo.jpg                        # Project logo image
```

## License Information

This repository is licensed under the custom [Noesis License](LICENSE) which includes
requirements for attribution and profit-sharing for commercial use.

## Documentation

Documentation for Noesis is organized into several key resources:

## AI and Consciousness Integration

Noesis v2.2.0 includes AI integration with free models from Hugging Face to enhance synthetic consciousness capabilities. Located in the `system/ai-model` directory, the system implements various consciousness theories:

> **Note**: The legacy `system/ai` directory is deprecated and will be removed in future versions. Please use the `system/ai-model` components instead.

- **Integrated Information Theory (IIT)**: Focuses on integration and differentiation of information
- **Global Workspace Theory (GWT)**: Models consciousness as global broadcasting of information
- **Higher Order Thought (HOT)**: Implements metacognitive awareness of mental states
- **Attention Schema Theory (AST)**: Models consciousness as an internal representation of attention
- **Global Neuronal Workspace (GNW)**: Detailed implementation of workspace broadcasting
- **Predictive Processing Theory (PPT)**: Incorporates prediction and error correction mechanisms

### AI Features

- Integration with free Hugging Face models (MIT, Apache 2.0 licensed)
- License compatibility checking with Noesis License
- Enhanced perception and emotion processing
- Introspection capabilities
- Self-reflection based on consciousness theories

### Using AI Features

```bash
# Install AI dependencies
noesis
> ai install

# Set up a model
> ai set-model google/flan-t5-large

# Set consciousness model
> ai consciousness model IIT

# Perform self-reflection
> ai consciousness reflect

# Run the AI test suite
> ./system/ai-model/test-ai.fish
```

Note: AI features require Python 3 with the `transformers` and `torch` packages installed.