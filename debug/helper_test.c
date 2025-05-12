#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Function that will be called from assembly
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

// This will be our test program that directly calls the helper
int main() {
    printf("NOESIS Read Test\n");
    printf("===============\n\n");

    // Allocate buffer and initialize
    char buffer[50];
    for(int i = 0; i < 49; i++) {
        buffer[i] = 'X';
    }
    buffer[49] = '\0';
    
    printf("Buffer before: '%s'\n", buffer);
    printf("Buffer address: %p\n", (void*)buffer);
    
    // Call the helper function directly
    write_test_to_buffer(buffer, sizeof(buffer));
    
    printf("Buffer after: '%s'\n", buffer);
    
    // Display character by character
    printf("Character dump: ");
    for (int i = 0; i < 10; i++) {
        printf("[%c](%d) ", buffer[i], buffer[i]);
    }
    printf("\n");
    
    printf("Test completed successfully.\n");
    return 0;
}
