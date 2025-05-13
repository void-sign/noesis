/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */


#include <stdio.h>
#include <string.h>

// C function that will be called from assembly
void write_test_to_buffer(char* buffer, int size) {
    if (buffer == NULL || size < 5) return;
    
    // Write "test" to the buffer
    buffer[0] = 't';
    buffer[1] = 'e';
    buffer[2] = 's';
    buffer[3] = 't';
    buffer[4] = '\0';
    
    printf("[C Helper] Wrote 'test' to buffer at %p\n", buffer);
}

// Forward declaration of the assembly function
extern int noesis_read(char *buffer, int size);

// Test program
int main() {
    printf("NOESIS Read Test\n");
    printf("===============\n\n");

    // Allocate buffer and initialize to X
    char buffer[50];
    memset(buffer, 'X', sizeof(buffer)-1);
    buffer[sizeof(buffer)-1] = '\0';
    
    printf("Buffer before: '%s'\n", buffer);
    printf("Buffer address: %p\n", (void*)buffer);
    
    // Call the assembly function that will call our C helper
    int bytes = noesis_read(buffer, sizeof(buffer));
    
    printf("noesis_read returned: %d bytes\n", bytes);
    printf("Buffer after: '%s'\n", buffer);
    
    // Print character by character
    printf("Character dump: ");
    for (int i = 0; i < 10; i++) {
        printf("[%c](%d) ", buffer[i], buffer[i]);
    }
    printf("\n");
    
    printf("Test completed successfully.\n");
    return 0;
}
