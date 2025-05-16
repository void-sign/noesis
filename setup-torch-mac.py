#!/usr/bin/env python3
"""
PyTorch installation script for macOS that works around dependency issues.
This script will attempt to install a compatible version of PyTorch for macOS.
"""

import sys
import subprocess
import platform
import os

def run_command(command):
    """Run a shell command and return the output."""
    print(f"Running: {command}")
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error ({result.returncode}):")
        print(result.stderr)
    else:
        print("Success!")
        if result.stdout:
            print(result.stdout)
    return result.returncode == 0

def get_python_version():
    """Get the Python version as a tuple (major, minor)."""
    return (sys.version_info.major, sys.version_info.minor)

def is_apple_silicon():
    """Check if the system is running on Apple Silicon."""
    return platform.machine() == 'arm64' and platform.system() == 'Darwin'

def install_pytorch_macos():
    """Install PyTorch on macOS."""
    print("Installing PyTorch for macOS...")
    
    # Check if conda is active by looking for CONDA_PREFIX
    in_conda = 'CONDA_PREFIX' in os.environ
    
    if in_conda:
        print(f"Detected conda environment: {os.environ.get('CONDA_PREFIX')}")
        
        # For conda, use the pytorch channel
        if is_apple_silicon():
            print("Detected Apple Silicon (M1/M2/M3)")
            return run_command("conda install -y pytorch torchvision torchaudio -c pytorch")
        else:
            print("Detected Intel Mac")
            return run_command("conda install -y pytorch torchvision torchaudio -c pytorch")
    else:
        # For pip, use different approaches based on architecture
        if is_apple_silicon():
            print("Detected Apple Silicon (M1/M2/M3)")
            
            # Try the official PyTorch pip installation for Apple Silicon
            success = run_command("pip install --no-cache-dir torch torchvision torchaudio")
            if not success:
                print("Trying alternative installation for M1/M2/M3...")
                return run_command("pip install --no-cache-dir torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1")
            return success
        else:
            print("Detected Intel Mac")
            
            # For Intel Macs, try the CPU-only version first
            return run_command("pip install --no-cache-dir torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cpu")

def install_transformers():
    """Install Hugging Face Transformers and related packages."""
    print("Installing Hugging Face libraries...")
    return run_command("pip install transformers accelerate huggingface_hub")

def main():
    """Main function."""
    print(f"Python version: {sys.version}")
    print(f"System: {platform.system()} {platform.machine()}")
    
    # Install PyTorch
    if not install_pytorch_macos():
        print("Failed to install PyTorch. Please try manually.")
        return False
    
    # Install Transformers
    if not install_transformers():
        print("Failed to install Transformers. Please try manually.")
        return False
    
    # Verify installations
    try:
        import torch
        print(f"PyTorch installed successfully! Version: {torch.__version__}")
        print(f"CUDA available: {torch.cuda.is_available()}")
    except ImportError:
        print("PyTorch import failed. Installation may have been incomplete.")
        return False
        
    try:
        import transformers
        print(f"Transformers installed successfully! Version: {transformers.__version__}")
    except ImportError:
        print("Transformers import failed. Installation may have been incomplete.")
        return False
    
    print("\nAll dependencies installed successfully!")
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
