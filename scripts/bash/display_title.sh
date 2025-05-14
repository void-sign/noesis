#!/bin/bash

# Display NOESIS title with table borders and bright pink color in Bash shell
PINK='\033[38;5;206m'  # Bright pink
NC='\033[0m'          # No Color

# Add spaces at the top
echo -e "\n\n"

# Print the bordered title with color
echo -e "${PINK}┌────────────────────────────────────────────────────┐${NC}"
echo -e "${PINK}│                                                    │${NC}"
echo -e "${PINK}│               NOESIS: SYNTHETIC CONSCIOUS          │${NC}"
echo -e "${PINK}│                                                    │${NC}"
echo -e "${PINK}└────────────────────────────────────────────────────┘${NC}"

# Add spaces at the bottom
echo -e "\n\n"
