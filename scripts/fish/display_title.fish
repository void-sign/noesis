#!/usr/bin/env fish

# Display NOESIS title with table borders and bright pink color in Fish shell
set PINK (set_color ff5fd7) # Bright pink
set NC (set_color normal)   # Normal color

# Add spaces at the top
echo -e "\n\n"

# Print the bordered title with color
echo -e "$PINK┌────────────────────────────────────────────────────┐$NC"
echo -e "$PINK│                                                    │$NC"
echo -e "$PINK│               NOESIS: SYNTHETIC CONSCIOUS          │$NC"
echo -e "$PINK│                                                    │$NC"
echo -e "$PINK└────────────────────────────────────────────────────┘$NC"

# Add spaces at the bottom
echo -e "\n\n"
