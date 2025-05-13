#!/usr/bin/env bash

# Noesis Command (ncom) - Short command interface for Noesis project
# Created: May 13, 2025

# Define colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_usage() {
    echo "Noesis Command (ncom) - Short interface for Noesis operations"
    echo
    echo "Usage: ./ncom.sh [command] [options]"
    echo
    echo -e "Structure Management:"
    echo -e "  ${GREEN}save, -s${NC}        Save current project structure state"
    echo -e "  ${GREEN}continue, -c${NC}    Restore latest saved structure state"
    echo
    echo -e "Build Commands:"
    echo -e "  ${GREEN}build, -b${NC}       Build the Noesis core"
    echo -e "  ${GREEN}run, -r${NC}         Run the Noesis core"
    echo -e "  ${GREEN}test, -t${NC}        Run all tests"
    echo
    echo -e "Maintenance:"
    echo -e "  ${GREEN}clean${NC}           Clean up build artifacts"
    echo -e "  ${GREEN}help, -h${NC}        Display this help message"
    echo
}

# Process command
case "$1" in
    "save"|"-s")
        echo -e "${YELLOW}Saving current project structure state...${NC}"
        bash "./scripts/save_structure_state.sh"
        ;;
        
    "continue"|"-c")
        echo -e "${YELLOW}Restoring latest saved project structure state...${NC}"
        
        # Find the latest timestamp in the docs directory
        LATEST_TIMESTAMP=""
        if [ -d "docs" ]; then
            # Get only the timestamp part from the filename (after the last underscore)
            LATEST_TIMESTAMP=$(ls -1 docs/directory_structure_*.txt 2>/dev/null | sort -r | head -1 | sed -n 's/.*structure_\([0-9]*\)\.txt$/\1/p')
        fi
        
        if [ -z "$LATEST_TIMESTAMP" ]; then
            echo -e "${RED}Error: No saved structure states found in docs directory${NC}"
            exit 1
        fi
        
        echo -e "${YELLOW}Found latest structure state: ${GREEN}${LATEST_TIMESTAMP}${NC}"
        bash "./scripts/restore_structure_state.sh" "$LATEST_TIMESTAMP"
        ;;
        
    "build"|"-b")
        echo -e "${YELLOW}Building Noesis...${NC}"
        if [ -f "./scripts/bash/build_all.sh" ]; then
            bash "./scripts/bash/build_all.sh"
        else
            echo -e "${RED}Error: build script not found${NC}"
            exit 1
        fi
        ;;
        
    "run"|"-r")
        echo -e "${YELLOW}Running Noesis...${NC}"
        if [ -f "./scripts/bash/run_core.sh" ]; then
            bash "./scripts/bash/run_core.sh"
        else
            echo -e "${RED}Error: run script not found${NC}"
            exit 1
        fi
        ;;
        
    "test"|"-t")
        echo -e "${YELLOW}Running tests...${NC}"
        if [ -f "./scripts/bash/run_all_tests.sh" ]; then
            bash "./scripts/bash/run_all_tests.sh"
        else
            echo -e "${RED}Error: test script not found${NC}"
            exit 1
        fi
        ;;
        
    "clean")
        echo -e "${YELLOW}Cleaning build artifacts...${NC}"
        make clean
        ;;
        
    "help"|"-h"|"")
        print_usage
        ;;
        
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        print_usage
        exit 1
        ;;
esac