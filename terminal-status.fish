#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#

# terminal-status.fish - Script to diagnose and fix terminal hang issues

set GREEN (set_color green)
set BLUE (set_color blue)
set YELLOW (set_color yellow)
set RED (set_color red)
set NC (set_color normal)

echo
echo "$BLUE╔════════════════════════════════════════════════╗$NC"
echo "$BLUE║     NOESIS TERMINAL STATUS DIAGNOSTICS         ║$NC"
echo "$BLUE╚════════════════════════════════════════════════╝$NC"
echo

# Check OS and Architecture
set os_type (uname)
set arch (uname -m)
echo "$YELLOW"System: $os_type ($arch)"$NC"

# Check Python version
if command -sq python3
    set py_version (python3 --version 2>&1)
    echo "$YELLOW"Python: $py_version"$NC"
    
    # Check if Python version is >= 3.13 which can cause compatibility issues
    set py_minor (python3 -c "import sys; print(sys.version_info.minor)" 2>/dev/null)
    if test "$py_minor" -ge "13"
        echo "$RED"WARNING: Python 3.13+ detected - may have compatibility issues with PyTorch"$NC"
        echo "Consider using the Python 3.13+ specific AI tools:"
        echo "  ./fast-ai-install-py13.fish"
        echo "  or 'ai install-py13' within the Noesis interface"
    end
else
    echo "$RED"WARNING: Python 3 not found. This may cause issues with Noesis AI features."$NC"
fi

# Check for running Python processes
echo
echo "$BLUE"Checking for hanging Python processes..."$NC"
set python_processes (ps aux | grep python | grep -v grep)
if test -n "$python_processes"
    echo "$YELLOW"Found running Python processes:"$NC"
    ps aux | grep python | grep -v grep
    echo
    echo "If you want to kill all Python processes (this may interrupt legitimate processes):"
    echo "$RED"pkill -9 python"$NC"
else
    echo "$GREEN"No hanging Python processes detected."$NC"
fi

# Check if any process is using excessive CPU
echo
echo "$BLUE"Checking for high CPU usage processes..."$NC"
set high_cpu_processes (ps aux | sort -nrk 3,3 | head -5)
echo "$YELLOW"Top CPU consuming processes:"$NC"
echo "$high_cpu_processes"

# Check for available disk space
echo
echo "$BLUE"Checking disk space..."$NC"
df -h | grep -E "^Filesystem|/$"

# Check memory usage
echo
echo "$BLUE"Checking memory usage..."$NC"
if command -sq vm_stat
    # macOS memory info
    vm_stat | grep "Pages"
else
    # Linux memory info
    free -h
end

# Check for hung Fish shell processes
echo
echo "$BLUE"Checking for hung Fish shell processes..."$NC"
set fish_procs (ps aux | grep fish | grep -v grep)
if test -n "$fish_procs"
    echo "$YELLOW"Found Fish processes:"$NC"
    ps aux | grep fish | grep -v grep
else
    echo "$GREEN"No additional Fish processes detected."$NC"
fi

# Display the terminal history (may show what was running before the hang)
echo
echo "$BLUE"Recent terminal commands:"$NC"
history | tail -10

# Check if we have any Noesis specific stuck processes
echo
echo "$BLUE"Checking for Noesis-specific processes..."$NC"
set noesis_procs (ps aux | grep -E "noesis|quantum" | grep -v grep)
if test -n "$noesis_procs" 
    echo "$YELLOW"Found Noesis processes:"$NC"
    ps aux | grep -E "noesis|quantum" | grep -v grep
else
    echo "$GREEN"No specific Noesis processes detected."$NC"
fi

# Provide recommendations
echo
echo "$BLUE╔════════════════════════════════════════════════╗$NC"
echo "$BLUE║     RECOMMENDATIONS TO FIX TERMINAL ISSUES     ║$NC"
echo "$BLUE╚════════════════════════════════════════════════╝$NC"
echo
echo "1. If using Python 3.13+, run the compatible AI installer:"
echo "   $GREEN""./fast-ai-install-py13.fish""$NC"
echo
echo "2. If terminal is hanging, try these commands:"
echo "   $GREEN""pkill -9 python   # Kill all Python processes""$NC"
echo "   $GREEN""pkill -9 fish     # Kill all Fish shell processes (not this one)""$NC"
echo
echo "3. Use the simplified run script to test:"
echo "   $GREEN""./run-simplified.fish""$NC"
echo
echo "4. To check for AI system status separately:"
echo "   $GREEN""./system/ai-model/service-py13.fish echo 'test'""$NC"
echo
echo "5. Clear Python package cache if needed:"
echo "   $GREEN""python3 -m pip cache purge""$NC"
echo

# Check if there are background jobs running in this shell
echo "$BLUE"Checking for background jobs in current shell..."$NC"
jobs
echo

echo "$GREEN""Diagnostics complete.""$NC"
