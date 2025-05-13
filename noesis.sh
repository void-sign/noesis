#!/bin/bash
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#
# Noesis Central Control Script
# A unified command interface for Noesis operations

# Define colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print version information
VERSION="1.1.0"
NOESIS_ROOT=$(dirname "$(realpath "$0")")

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${GREEN}              Noesis Control Center v${VERSION}           ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
}

print_usage() {
    echo -e "${YELLOW}Usage:${NC} ./noesis.sh <command> [args...]"
    echo
    echo -e "${YELLOW}Common commands:${NC}"
    echo -e "  ${GREEN}build${NC}        - Build the Noesis core"
    echo -e "  ${GREEN}run${NC}          - Run the Noesis core"
    echo -e "  ${GREEN}test${NC}         - Run all tests"
    echo -e "  ${GREEN}clean${NC}        - Clean up build artifacts"
    echo -e "  ${GREEN}install${NC}      - Install Noesis"
    echo -e "  ${GREEN}help${NC}         - Display this help message"
    echo
    echo -e "${YELLOW}All available commands:${NC}"
    ls -1 bash_scripts/ | grep '\.sh$' | sed 's/\.sh$//' | while read -r script; do
        echo -e "  ${GREEN}${script}${NC}"
    done
}

# Handle special commands
case "$1" in
    "build")
        print_header
        echo -e "${YELLOW}Building Noesis...${NC}"
        bash "bash_scripts/build_all.sh" "${@:2}"
        ;;
    "run")
        print_header
        echo -e "${YELLOW}Running Noesis Core...${NC}"
        bash "bash_scripts/run_noesis.sh" "${@:2}"
        ;;
    "test")
        print_header
        echo -e "${YELLOW}Running Noesis tests...${NC}"
        bash "bash_scripts/run_all_tests.sh" "${@:2}"
        ;;
    "clean")
        print_header
        echo -e "${YELLOW}Cleaning Noesis build artifacts...${NC}"
        bash "bash_scripts/cleanup_folders.sh" "${@:2}"
        ;;
    "install")
        print_header
        echo -e "${YELLOW}Installing Noesis...${NC}"
        bash "bash_scripts/install.sh" "${@:2}"
        ;;
    "help")
        print_header
        print_usage
        ;;
    "")
        print_header
        print_usage
        ;;
    *)
        # Script name will be the first argument
        SCRIPT_NAME=$1
        shift 1

        # Check if the script exists
        if [ -f "bash_scripts/${SCRIPT_NAME}.sh" ]; then
            print_header
            echo -e "${YELLOW}Running script: ${GREEN}${SCRIPT_NAME}${NC}"
            # Execute the script with all remaining arguments
            bash "bash_scripts/${SCRIPT_NAME}.sh" "$@"
        else
            echo -e "${RED}Error: Command '${SCRIPT_NAME}' not found${NC}"
            print_usage
            exit 1
        fi
        ;;
esac
