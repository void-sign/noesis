/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */


#include <stdio.h>
#include <stdlib.h>

// Declaration for noesis_read function
extern int noesis_read(char *buffer, int size);

int main() {
    printf("NOESIS Read Test\n");
    printf("===============\n\n");

    // Allocate buffer and initialize to known values
    char buffer[50];
    for(int i = 0; i < 50; i++) {
        buffer[i] = 'X';  // Fill with 'X' to see if it changes
    }
    buffer[49] = '\0';  // Make sure it's null-terminated
    
    printf("Buffer before: '%s'\n", buffer);
    printf("Buffer address: %p\n", buffer);
    printf("Buffer size: %lu\n", sizeof(buffer));
    
    printf("Calling noesis_read()...\n");
    int bytes = noesis_read(buffer, 50);
    
    printf("noesis_read returned: %d bytes\n", bytes);
    printf("Buffer after: '%s'\n", buffer);
    
    // Print each character to debug
    printf("Character dump: ");
    for (int i = 0; i < 10; i++) {
        printf("[%c](%d) ", buffer[i], buffer[i]);
    }
    printf("\n");
    
    printf("Test completed successfully.\n");
    return 0;
}
