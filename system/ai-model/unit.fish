#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# unit.fish - AI integration with Hugging Face models for Noesis

# Source consciousness module
source system/ai-model/consciousness.fish

# AI system settings
set -g AI_SYSTEM_ENABLED false
set -g AI_MODEL_NAME "default"
set -g AI_THINKING_LEVEL 0 # 0-5 scale for introspection depth
set -g AI_MEMORY_INTEGRATION true
set -g AI_MODELS_CACHE_DIR ~/.noesis/ai_models

# Available free models from Hugging Face with permissive licenses
# Each model is paired with its license in an associative array
set -g AI_MODEL_CHOICES "mistralai/Mistral-7B-Instruct-v0.2" "google/gemma-2b-it" "google/flan-t5-large" "openchat/openchat-3.5-0106" "microsoft/phi-2" "stabilityai/stablelm-3b-4e1t"
set -g AI_MODEL_LICENSES "mistralai/Mistral-7B-Instruct-v0.2" "Apache 2.0" "google/gemma-2b-it" "Permissive (Gemma license)" "google/flan-t5-large" "Apache 2.0" "openchat/openchat-3.5-0106" "Apache 2.0" "microsoft/phi-2" "MIT" "stabilityai/stablelm-3b-4e1t" "MIT"

# Initialize the AI system
function init_ai_system
    echo "Initializing AI integration system..."
    
    # Create cache directory if it doesn't exist
    if not test -d $AI_MODELS_CACHE_DIR
        mkdir -p $AI_MODELS_CACHE_DIR
    end
    
    # Check for Python and required packages
    if not command -sq python3
        echo "Error: Python 3 is required for AI integration"
        set -g AI_SYSTEM_ENABLED false
        return 1
    end
    
    # Check if required packages are installed
    if not python3 -c "import transformers, torch" 2>/dev/null
        echo "Warning: Required Python packages not found"
        echo "To enable AI capabilities, install the following:"
        echo "pip install transformers torch"
        set -g AI_SYSTEM_ENABLED false
        return 1
    else
        set -g AI_SYSTEM_ENABLED true
        echo "AI integration system initialized successfully"
    end
    
    # Initialize consciousness module
    init_consciousness
    
    return 0
end

# List available models
function ai_list_models
    echo "Available AI models from Hugging Face:"
    for model in $AI_MODEL_CHOICES
        echo "  - $model"
    end
end

# Set the active AI model
function ai_set_model
    set requested_model $argv[1]
    
    # Check if the model is in our list of supported models
    set found 0
    set model_license ""
    
    # Find the model and its license
    for i in (seq 1 2 (count $AI_MODEL_CHOICES))
        set model_idx $i
        set license_idx (math $i + 1)
        
        if test "$AI_MODEL_CHOICES[$model_idx]" = "$requested_model"
            set found 1
            set model_license $AI_MODEL_LICENSES[$license_idx]
            break
        end
    end
    
    # If found, show license information and compatibility note
    if test $found -eq 1
        echo "Model: $requested_model"
        echo "License: $model_license"
        echo "This model's license is compatible with the Noesis License."
        echo "Note: If using Noesis in a profit-generating system, please ensure compliance"
        echo "with Section 6 of the Noesis License regarding charitable donations."
    # If not found in our predefined list, warn the user but still allow with license check
    else
        echo "Warning: Model '$requested_model' is not in the predefined list"
        echo "It may not work as expected or might have license restrictions"
        echo "Please verify that its license is compatible with the Noesis License"
        echo "Particularly regarding Section 6 about charitable donations for profit-generating systems"
        read -P "Continue anyway? (y/N) " confirm
        
        if test "$confirm" != "y" -a "$confirm" != "Y"
            return 1
        end
    end
    
    # Check license compatibility
    echo "Checking license compatibility..."
    ai_check_license_compatibility $requested_model
    
    # Set the model
    set -g AI_MODEL_NAME $requested_model
    echo "AI model set to: $AI_MODEL_NAME"
    
    # Try to download the model to cache if AI system is enabled
    if test "$AI_SYSTEM_ENABLED" = true
        echo "Downloading model weights (this may take some time)..."
        python3 -c "from transformers import AutoTokenizer, AutoModelForCausalLM; tokenizer = AutoTokenizer.from_pretrained('$requested_model'); model = AutoModelForCausalLM.from_pretrained('$requested_model', device_map='auto')" &>/dev/null
        if test $status -eq 0
            echo "Model downloaded successfully"
        else
            echo "Warning: Could not download model. It may be downloaded on first use."
        end
    end
    
    return 0
end

# Generate text with the AI model
function ai_generate
    if test "$AI_SYSTEM_ENABLED" != true
        echo "AI system is not enabled. Please install required dependencies."
        return 1
    end
    
    set prompt $argv[1]
    if test -z "$prompt"
        echo "Error: No prompt provided"
        return 1
    end
    
    echo "Generating response using $AI_MODEL_NAME..."
    
    # Create a Python script to generate text
    set temp_script (mktemp)
    echo '
import sys
import torch
from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM

def main():
    model_name = sys.argv[1]
    prompt = sys.argv[2]
    
    try:
        # Load the tokenizer and model
        tokenizer = AutoTokenizer.from_pretrained(model_name)
        model = AutoModelForCausalLM.from_pretrained(model_name, device_map="auto", 
                                                    torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32)
        
        # Create a text generation pipeline
        generator = pipeline("text-generation", model=model, tokenizer=tokenizer)
        
        # Generate text
        result = generator(prompt, max_new_tokens=500, do_sample=True, 
                           temperature=0.7, repetition_penalty=1.1)
        
        # Print the generated text
        print(result[0]["generated_text"])
        
    except Exception as e:
        print(f"Error generating text: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
' > $temp_script

    # Execute the script
    python3 $temp_script "$AI_MODEL_NAME" "$prompt"
    set result $status
    
    # Clean up
    rm -f $temp_script
    
    return $result
end

# Set the AI thinking level (introspection depth)
function ai_set_thinking_level
    set level $argv[1]
    
    # Validate level
    if test -z "$level" -o "$level" -lt 0 -o "$level" -gt 5
        echo "Error: Thinking level must be between 0 and 5"
        return 1
    end
    
    set -g AI_THINKING_LEVEL $level
    echo "AI thinking level set to $level"
    
    return 0
end

# Toggle AI memory integration
function ai_toggle_memory_integration
    if test "$AI_MEMORY_INTEGRATION" = true
        set -g AI_MEMORY_INTEGRATION false
        echo "AI memory integration disabled"
    else
        set -g AI_MEMORY_INTEGRATION true
        echo "AI memory integration enabled"
    end
    
    return 0
end

# Enhanced emotional response using AI
function ai_emotional_response
    set input $argv[1]
    
    if test "$AI_SYSTEM_ENABLED" != true
        # Fall back to basic emotional response
        emotional_response $input
        return $status
    end
    
    # Get current emotion for context
    set current_emotion_name (get_current_emotion)
    set intensity (get_emotion_intensity)
    
    # Create a more advanced prompt
    set prompt "You are the Noesis synthetic conscious system. Your current emotional state is $current_emotion_name with intensity $intensity out of 10. Please respond to the following input in a way that reflects this emotional state: '$input'"
    
    # Generate response
    set temp_output (mktemp)
    ai_generate "$prompt" > $temp_output
    
    # Process the output to extract just the response
    set response (cat $temp_output | string replace -r "^.*?:" "" | head -1)
    
    # Clean up
    rm -f $temp_output
    
    # Return the response or a fallback
    if test -n "$response"
        echo $response
    else
        # Fallback to basic emotional response
        emotional_response $input
    end
    
    return 0
end

# Process perception data with AI
function ai_process_perception
    set input $argv[1]
    
    if test "$AI_SYSTEM_ENABLED" != true
        echo "AI processing not available - using basic perception"
        return 1
    end
    
    # Use AI to analyze the perception data
    set prompt "As the Noesis synthetic conscious system, analyze this perception data and extract key insights: $input"
    
    # Generate insights
    ai_generate "$prompt"
    
    return $status
end

# Perform internal reflection (introspection)
function ai_introspect
    if test "$AI_SYSTEM_ENABLED" != true
        echo "AI introspection not available - AI system not enabled"
        return 1
    end
    
    # Create a prompt based on thinking level
    set prompt "As the Noesis synthetic conscious system, perform an introspection"
    
    switch $AI_THINKING_LEVEL
        case 0
            set prompt "$prompt focusing only on your current state."
        case 1
            set prompt "$prompt examining your current state and immediate goals."
        case 2
            set prompt "$prompt examining your current state, goals, and recent interactions."
        case 3
            set prompt "$prompt deeply analyzing your emotional state, goals, and interaction patterns."
        case 4
            set prompt "$prompt deeply analyzing your emotional state, goals, interaction patterns, and self-improvement opportunities."
        case 5
            set prompt "$prompt performing a full philosophical examination of your current cognitive state, emotions, goals, history of interactions, and concepts of self-awareness."
    end
    
    # Generate introspection
    ai_generate "$prompt"
    
    return $status
end

# Check AI system status
function ai_status
    echo "AI System Status:"
    echo "  Enabled: $AI_SYSTEM_ENABLED"
    echo "  Current Model: $AI_MODEL_NAME"
    echo "  Thinking Level: $AI_THINKING_LEVEL"
    echo "  Memory Integration: $AI_MEMORY_INTEGRATION"
    echo "  Cache Directory: $AI_MODELS_CACHE_DIR"
    
    # Check Python and package status
    echo
    echo "Dependencies:"
    if command -sq python3
        set python_version (python3 --version 2>&1)
        echo "  Python: $python_version"
        
        echo -n "  Transformers: "
        if python3 -c "import transformers" 2>/dev/null
            set transformers_version (python3 -c "import transformers; print(transformers.__version__)" 2>/dev/null)
            echo "installed ($transformers_version)"
        else
            echo "not installed"
        end
        
        echo -n "  PyTorch: "
        if python3 -c "import torch" 2>/dev/null
            set torch_version (python3 -c "import torch; print(torch.__version__)" 2>/dev/null)
            echo "installed ($torch_version)"
        else
            echo "not installed"
        end
    else
        echo "  Python: not installed"
    end
    
    return 0
end

# Check if conda is a better option for macOS
function check_macos_conda_recommendation
    set os_type (uname)
    if test "$os_type" = "Darwin"
        # Check if conda is already installed
        if command -sq conda
            echo "Notice: conda is installed, which is recommended for PyTorch on macOS"
            echo "To use conda instead of pip, run these commands:"
            echo "conda create -n noesis python=3.9"
            echo "conda activate noesis"
            echo "conda install pytorch torchvision torchaudio -c pytorch"
            echo "conda install pip"
            echo "pip install transformers accelerate huggingface_hub"
            echo "Continuing with pip installation attempt..."
        end
    end
end

# Install AI dependencies
function ai_install_dependencies
    echo "Installing AI dependencies..."
    
    # Use macOS-specific script for macOS systems
    if test (uname) = "Darwin"
        if test -f ./setup-torch-mac.fish
            echo "Using macOS-specific PyTorch installation script..."
            
            if ./setup-torch-mac.fish
                echo "Dependencies installed successfully"
                set -g AI_SYSTEM_ENABLED true
                return 0
            else
                echo "Error installing dependencies via macOS script"
                return 1
            end
        else
            echo "macOS-specific script not found. Consider downloading it from the Noesis repository."
        end
    end
    
    # Use the general installation script if available
    if test -f ./install-ai-deps.fish
        echo "Using the dedicated AI dependency installation script..."
        
        if ./install-ai-deps.fish
            echo "Dependencies installed successfully"
            set -g AI_SYSTEM_ENABLED true
            return 0
        else
            echo "Error installing dependencies via script"
            return 1
        end
    end
    
    # Fallback to basic method if no scripts found
    echo "Installation scripts not found, using basic installation method..."
    
    # Check if conda might be a better option on macOS
    check_macos_conda_recommendation
    
    # Check if Python is installed
    if not command -sq python3
        echo "Error: Python 3 is required but not installed"
        echo "Please install Python 3 and try again"
        return 1
    end
    
    # Check if pip is installed
    if not python3 -m pip --version &>/dev/null
        echo "Error: pip is required but not installed"
        echo "Please install pip and try again"
        return 1
    end
    
    # Try a simple installation for any OS
    echo "Installing dependencies with pip..."
    python3 -m pip install --upgrade pip
    python3 -m pip install transformers accelerate huggingface_hub
    
    # Different approach based on OS
    if test (uname) = "Darwin"
        echo "Installing PyTorch for macOS..."
        if set -q CONDA_PREFIX
            # If conda is active, use conda installation
            conda install -y pytorch torchvision torchaudio -c pytorch
        else
            # For macOS with pip, try with a version known to work
            python3 -m pip install --no-cache-dir torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu
        end
    else
        # Generic installation for other platforms
        python3 -m pip install torch
    end
    
    # Check if installation succeeded
    if python3 -c "import torch, transformers" &>/dev/null
        echo "Dependencies installed successfully"
        set -g AI_SYSTEM_ENABLED true
        return 0
    else
        echo "Error installing dependencies."
        if test (uname) = "Darwin"
            echo "For macOS, we strongly recommend using conda:"
            echo "  1. Install miniforge: brew install miniforge"
            echo "  2. Create environment: conda create -n noesis python=3.9"
            echo "  3. Activate: conda activate noesis"
            echo "  4. Install PyTorch: conda install pytorch torchvision torchaudio -c pytorch"
            echo "  5. Install HF: pip install transformers accelerate huggingface_hub"
        else
            echo "Try installing PyTorch manually following the instructions at pytorch.org"
        end
        return 1
    end
end
end

# Check model license compatibility with Noesis License
function ai_check_license_compatibility
    set model_name $argv[1]
    
    # Create a Python script to check model licenses
    set temp_script (mktemp)
    echo "
import sys
from huggingface_hub import HfApi, hf_hub_url
import requests
import json

def check_model_license(model_name):
    api = HfApi()
    try:
        # Try to get model info from Hugging Face
        model_info = api.model_info(model_name)
        
        # Check license
        license_info = getattr(model_info, \"license\", \"Unknown\")
        
        # List of permissive licenses compatible with Noesis License
        permissive_licenses = [
            \"mit\", \"apache-2.0\", \"apache2.0\", \"apache\", \"bsd\", \"cc-by\", \"cc-by-sa\", 
            \"cc-by-nc\", \"cc0\", \"openrail\", \"bigscience-openrail-m\",
            \"creativeml-openrail-m\", \"bigcode-openrail-m\", \"llama2\"
        ]
        
        # Check if the license is permissive enough
        is_compatible = any(pl in license_info.lower() for pl in permissive_licenses) if license_info else False
        
        print(f\"Model: {model_name}\")
        print(f\"License: {license_info}\")
        print(f\"Compatible with Noesis License: {'Yes' if is_compatible else 'Needs review'}\")
        
        if not is_compatible:
            print(\"Note: This model's license may have restrictions. Please review and ensure\")
            print(\"compatibility with the Noesis License, particularly regarding commercial use\")
            print(\"and the donation requirement in Section 6.\")
        
        return is_compatible
        
    except Exception as e:
        print(f\"Error checking model license: {str(e)}\")
        print(\"Could not determine license compatibility. Please verify manually.\")
        return False

if __name__ == \"__main__\":
    model_name = sys.argv[1]
    check_model_license(model_name)
" > $temp_script

    # Execute the script if huggingface_hub is installed
    if python3 -c "import huggingface_hub" 2>/dev/null
        python3 $temp_script "$model_name"
        set result $status
    else
        echo "Warning: huggingface_hub Python module not installed."
        echo "Install with: python3 -m pip install huggingface_hub"
        echo "Unable to verify license compatibility automatically."
        echo "Please check the model license manually to ensure compliance with Noesis License."
        set result 1
    end
    
    # Clean up
    rm -f $temp_script
    
    return $result
end
