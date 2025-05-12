/**
 * noesis_client.c - Example client for using the Noesis API
 * 
 * This file demonstrates how to use the Noesis API from an external project
 * like noesis-extend. It establishes a standard communication pattern through
 * the Noesis API instead of directly depending on the internal structures.
 */

#include <noesis/noesis_api.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Callback function to receive messages from Noesis */
void on_noesis_message(void* user_data, const char* message) {
    printf("Noesis message: %s\n", message);
}

int main(int argc, char* argv[]) {
    int major, minor, patch;
    
    /* Get API version */
    noesis_get_version(&major, &minor, &patch);
    printf("Noesis API version: %d.%d.%d\n", major, minor, patch);
    
    /* Initialize Noesis */
    noesis_handle_t handle = noesis_initialize();
    if (!handle) {
        fprintf(stderr, "Failed to initialize Noesis\n");
        return 1;
    }
    
    /* Register callback */
    noesis_status_t status = noesis_register_callback(handle, 0, on_noesis_message, NULL);
    if (status != NOESIS_SUCCESS) {
        fprintf(stderr, "Failed to register callback\n");
        noesis_shutdown(handle);
        return 1;
    }
    
    /* Process input */
    const char* input = argc > 1 ? argv[1] : "Hello, Noesis!";
    char output[1024];
    noesis_size_t output_length;
    
    status = noesis_process_input(
        handle,
        input,
        strlen(input),
        output,
        sizeof(output),
        &output_length
    );
    
    if (status != NOESIS_SUCCESS) {
        fprintf(stderr, "Failed to process input\n");
        noesis_shutdown(handle);
        return 1;
    }
    
    /* Print output */
    printf("Noesis output: %s\n", output);
    
    /* Clean up */
    noesis_shutdown(handle);
    
    return 0;
}
