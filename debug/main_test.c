/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
// Minimal implementation for testing
#include <stdio.h>
#include <stdlib.h>

// Declaration for the assembly function
extern int noesis_read(char *buffer, int size);

int main() {
    printf("NOESIS Read Test\n");
    printf("===============\n\n");

    // Allocate buffer
    char buffer[50] = {0};

    printf("Calling noesis_read()...\n");
    int bytes = noesis_read(buffer, 50);

    printf("noesis_read returned: %d bytes\n", bytes);
    printf("Buffer contents: '%s'\n", buffer);

    // Print each character to debug
    printf("Character dump: ");
    for (int i = 0; i < 5; i++) {
        printf("[%c](%d) ", buffer[i] ? buffer[i] : ' ', buffer[i]);
    }
    printf("\n");

    printf("Test completed successfully.\n");
    return 0;
}
