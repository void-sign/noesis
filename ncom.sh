#!/usr/bin/env bash

# ncom - Noesis Command
# A simplified command wrapper for common Noesis operations
# Usage: ./ncom <command> or ./ncom -<flag>

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PINK='\033[38;5;206m'
NC='\033[0m' # No Color

# Parse single-letter flags
if [[ $# -gt 0 && "$1" =~ ^- ]]; then
    flag="${1:1}"
    
    case "$flag" in
        s)
            # Save structure state
            bash "$SCRIPT_DIR/noesis.sh" save
            exit 0
            ;;
        c)
            # Continue/restore structure state
            bash "$SCRIPT_DIR/noesis.sh" continue
            exit 0
            ;;
        b)
            # Build
            bash "$SCRIPT_DIR/noesis.sh" build
            exit 0
            ;;
        r)
            # Run
            bash "$SCRIPT_DIR/noesis.sh" run
            exit 0
            ;;
        t)
            # Test
            bash "$SCRIPT_DIR/noesis.sh" test
            exit 0
            ;;
        h)
            # Show help
            echo -e "${YELLOW}ncom${NC} - Noesis Command Shortcut"
            echo
            echo -e "${YELLOW}Usage:${NC}"
            echo "  ./ncom <command>"
            echo "  ./ncom -<flag>"
            echo
            echo -e "${YELLOW}Commands:${NC}"
            echo -e "  ${GREEN}save${NC}         - Save current project structure state"
            echo -e "  ${GREEN}continue${NC}     - Restore latest saved structure state"
            echo -e "  ${GREEN}build${NC}        - Build the Noesis core"
            echo -e "  ${GREEN}run${NC}          - Run the Noesis core"
            echo -e "  ${GREEN}test${NC}         - Run all tests"
            echo
            echo -e "${YELLOW}Flags:${NC}"
            echo -e "  ${GREEN}-s${NC}           - Save structure state (shorthand)"
            echo -e "  ${GREEN}-c${NC}           - Continue/restore structure (shorthand)"
            echo -e "  ${GREEN}-b${NC}           - Build (shorthand)"
            echo -e "  ${GREEN}-r${NC}           - Run (shorthand)"
            echo -e "  ${GREEN}-t${NC}           - Test (shorthand)"
            echo -e "  ${GREEN}-h${NC}           - Show this help"
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown flag '-$flag'${NC}"
            echo -e "Use '${GREEN}-h${NC}' for help"
            exit 1
            ;;
    esac
fi

# Parse commands
if [[ $# -gt 0 ]]; then
    command="$1"
    
    case "$command" in
        save)
            bash "$SCRIPT_DIR/noesis.sh" save
            ;;
        continue)
            bash "$SCRIPT_DIR/noesis.sh" continue
            ;;
        build)
            bash "$SCRIPT_DIR/noesis.sh" build
            ;;
        run)
            bash "$SCRIPT_DIR/noesis.sh" run
            ;;
        test)
            bash "$SCRIPT_DIR/noesis.sh" test
            ;;
        help)
            # Show help (same as -h)
            echo -e "${YELLOW}ncom${NC} - Noesis Command Shortcut"
            echo
            echo -e "${YELLOW}Usage:${NC}"
            echo "  ./ncom <command>"
            echo "  ./ncom -<flag>"
            echo
            echo -e "${YELLOW}Commands:${NC}"
            echo -e "  ${GREEN}save${NC}         - Save current project structure state"
            echo -e "  ${GREEN}continue${NC}     - Restore latest saved structure state"
            echo -e "  ${GREEN}build${NC}        - Build the Noesis core"
            echo -e "  ${GREEN}run${NC}          - Run the Noesis core"
            echo -e "  ${GREEN}test${NC}         - Run all tests"
            echo
            echo -e "${YELLOW}Flags:${NC}"
            echo -e "  ${GREEN}-s${NC}           - Save structure state (shorthand)"
            echo -e "  ${GREEN}-c${NC}           - Continue/restore structure (shorthand)"
            echo -e "  ${GREEN}-b${NC}           - Build (shorthand)"
            echo -e "  ${GREEN}-r${NC}           - Run (shorthand)"
            echo -e "  ${GREEN}-t${NC}           - Test (shorthand)"
            echo -e "  ${GREEN}-h${NC}           - Show this help"
            ;;
        *)
            echo -e "${RED}Error: Unknown command '$command'${NC}"
            echo -e "Use 'ncom help' or 'ncom -h' for help"
            exit 1
            ;;
    esac
else
    # No arguments, show help
    echo -e "${YELLOW}ncom${NC} - Noesis Command Shortcut"
    echo
    echo -e "${YELLOW}Usage:${NC}"
    echo "  ./ncom <command>"
    echo "  ./ncom -<flag>"
    echo
    echo -e "${YELLOW}Commands:${NC}"
    echo -e "  ${GREEN}save${NC}         - Save current project structure state"
    echo -e "  ${GREEN}continue${NC}     - Restore latest saved structure state"
    echo -e "  ${GREEN}build${NC}        - Build the Noesis core"
    echo -e "  ${GREEN}run${NC}          - Run the Noesis core"
    echo -e "  ${GREEN}test${NC}         - Run all tests"
    echo
    echo -e "${YELLOW}Flags:${NC}"
    echo -e "  ${GREEN}-s${NC}           - Save structure state (shorthand)"
    echo -e "  ${GREEN}-c${NC}           - Continue/restore structure (shorthand)"
    echo -e "  ${GREEN}-b${NC}           - Build (shorthand)"
    echo -e "  ${GREEN}-r${NC}           - Run (shorthand)"
    echo -e "  ${GREEN}-t${NC}           - Test (shorthand)"
    echo -e "  ${GREEN}-h${NC}           - Show this help"
fi
