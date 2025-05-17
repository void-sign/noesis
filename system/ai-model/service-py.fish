#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# ai-model-service-py13.fish - Service wrapper for AI models in Python 3.13+
# This script handles communication with Python AI processes using compatibility mechanisms

# Define color settings
set -l GREEN (set_color green)
set -l BLUE (set_color blue)
set -l YELLOW (set_color yellow)
set -l RED (set_color red)
set -l PINK (set_color ff5fd7)
set -l NC (set_color normal)

# Create directories if needed
mkdir -p ~/.noesis/ai_models
mkdir -p ~/.noesis/temp

# Function to check Python environment
function check_python_env
    # Check if Python is available
    if command -sq python3
        echo "$GREEN""Python 3 found""$NC"
        python3 --version
        return 0
    else
        echo "$RED""Error: Python 3 not found""$NC"
        return 1
    end
end

# Function to check if PyTorch is available (real or compatibility layer)
function check_pytorch
    # Try importing torch
    if python3 -c "import torch; print(f'PyTorch {torch.__version__} found')" 2>/dev/null
        return 0
    else
        # Try using the compatibility layer
        if test -f ~/.noesis/torch_compat.py
            if python3 -c "import sys; sys.path.insert(0, '$HOME/.noesis'); import torch_compat; print('PyTorch compatibility layer works')" 2>/dev/null
                return 0
            end
        end
        return 1
    end
end

# Function to run a simple AI task
function run_ai_task
    set -l task $argv[1]
    set -l input $argv[2]
    
    # Create a temporary Python script
    cat > ~/.noesis/temp/ai_task.py <<EOL
import sys
sys.path.insert(0, '$HOME/.noesis')

# Try importing torch - fall back to compatibility layer if needed
try:
    import torch
    print(f"Using PyTorch: {torch.__version__}")
except ImportError:
    try:
        import torch_compat
        print("Using PyTorch compatibility layer")
    except ImportError:
        print("ERROR: No PyTorch or compatibility layer available")
        sys.exit(1)

# Try importing transformers
try:
    import transformers
    print(f"Using Transformers: {transformers.__version__}")
except ImportError:
    print("ERROR: Transformers not available")
    sys.exit(1)

# Simple task handler
def handle_task(task_name, task_input):
    print(f"Processing task: {task_name}")
    
    if task_name == "echo":
        return f"Echo: {task_input}"
    
    if task_name == "sentiment":
        return f"Simulated sentiment analysis for: '{task_input}' - POSITIVE"
    
    if task_name == "summarize":
        return f"Simulated summary: '{task_input[:30]}...'"
    
    return f"Unknown task: {task_name}"

# Execute the task
result = handle_task("$task", "$input")
print(result)
EOL

    # Run the Python script
    python3 ~/.noesis/temp/ai_task.py
    return $status
end

# Main function
function main
    echo "$PINK""NOESIS AI Service Wrapper for Python 3.13+""$NC"
    echo
    
    # Check the environment
    if not check_python_env
        echo "$RED""Failed: Python environment check""$NC"
        return 1
    end
    
    # Check PyTorch availability
    if not check_pytorch
        echo "$YELLOW""Warning: PyTorch not available, attempting to install compatibility layer""$NC"
        ./tools/fast-ai-install-py13.fish
        
        # Check again
        if not check_pytorch
            echo "$RED""Failed: PyTorch or compatibility layer not available""$NC"
            return 1
        end
    end
    
    # Process command arguments
    if test (count $argv) -lt 1
        echo "Usage: $0 <task> [input]"
        echo "Available tasks: echo, sentiment, summarize"
        return 1
    end
    
    set -l task $argv[1]
    set -l input ""
    
    if test (count $argv) -gt 1
        set input $argv[2]
    end
    
    # Run the AI task
    run_ai_task $task $input
    return $status
end

# Execute main function with all arguments
main $argv
exit $status
