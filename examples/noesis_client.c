/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * noesis_client.c - Example client application for the Noesis API
 *
 * This example demonstrates how to use the Noesis API to interact
 * with the Noesis synthetic consciousness system.
 */

#include <noesis/noesis_api.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Maximum input/output buffer sizes */
#define MAX_INPUT_SIZE 1024
#define MAX_OUTPUT_SIZE 4096

/* Message callback function */
void message_callback(void* user_data, const char* message) {
    printf("NOESIS: %s\n", message);
    (void)user_data; /* Avoid unused parameter warning */
}

/* Helper function to read user input */
void read_input(char* buffer, size_t buffer_size) {
    printf("Enter input: ");
    fflush(stdout);
    
    if (fgets(buffer, buffer_size, stdin) == NULL) {
        buffer[0] = '\0';
        return;
    }
    
    /* Remove trailing newline if present */
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n') {
        buffer[len - 1] = '\0';
    }
}

int main(int argc, char* argv[]) {
    int major, minor, patch;
    noesis_handle_t handle;
    noesis_status_t status;
    char input_buffer[MAX_INPUT_SIZE];
    char output_buffer[MAX_OUTPUT_SIZE];
    noesis_size_t output_length;
    int interactive_mode = 1;
    
    /* Display welcome message */
    printf("=== Noesis Client Application ===\n\n");
    
    /* Get API version */
    noesis_get_version(&major, &minor, &patch);
    printf("Noesis API version: %d.%d.%d\n", major, minor, patch);
    
    /* Initialize Noesis */
    printf("Initializing Noesis...\n");
    handle = noesis_initialize();
    if (!handle) {
        fprintf(stderr, "Failed to initialize Noesis!\n");
        return 1;
    }
    printf("Noesis initialized successfully.\n\n");
    
    /* Register callback for messages */
    status = noesis_register_callback(handle, 0, message_callback, NULL);
    if (status != NOESIS_SUCCESS) {
        fprintf(stderr, "Failed to register callback: %d\n", status);
        noesis_shutdown(handle);
        return 1;
    }
    
    /* Check if input was provided via command line */
    if (argc > 1) {
        interactive_mode = 0;
        
        /* Process command-line input */
        strncpy(input_buffer, argv[1], MAX_INPUT_SIZE - 1);
        input_buffer[MAX_INPUT_SIZE - 1] = '\0';
        
        printf("Processing input: %s\n", input_buffer);
        status = noesis_process_input(
            handle,
            input_buffer,
            strlen(input_buffer),
            output_buffer,
            MAX_OUTPUT_SIZE,
            &output_length
        );
        
        if (status == NOESIS_SUCCESS) {
            printf("Noesis response: %s\n", output_buffer);
        } else {
            fprintf(stderr, "Error processing input: %d\n", status);
        }
    } else {
        /* Interactive mode */
        printf("Starting interactive mode. Type 'exit' to quit.\n");
        
        while (1) {
            /* Read user input */
            read_input(input_buffer, MAX_INPUT_SIZE);
            
            /* Check for exit command */
            if (strcmp(input_buffer, "exit") == 0 || 
                strcmp(input_buffer, "quit") == 0) {
                printf("Exiting...\n");
                break;
            }
            
            /* Process the input */
            status = noesis_process_input(
                handle,
                input_buffer,
                strlen(input_buffer),
                output_buffer,
                MAX_OUTPUT_SIZE,
                &output_length
            );
            
            /* Display the result */
            if (status == NOESIS_SUCCESS) {
                printf("Noesis: %s\n\n", output_buffer);
            } else {
                fprintf(stderr, "Error processing input: %d\n\n", status);
            }
        }
    }
    
    /* Clean up */
    printf("Shutting down Noesis...\n");
    noesis_shutdown(handle);
    printf("Noesis shut down successfully.\n");
    
    return 0;
}