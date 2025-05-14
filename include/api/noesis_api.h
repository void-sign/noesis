/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * noesis_api.h - Standard API for Noesis core functionality
 *
 * This header defines the public interface for interacting with 
 * the Noesis synthetic consciousness system from external applications.
 */

#ifndef NOESIS_API_H
#define NOESIS_API_H

#ifdef __cplusplus
extern "C" {
#endif

/* Type definitions for the Noesis API */
typedef void* noesis_handle_t;
typedef unsigned long noesis_size_t;
typedef int noesis_status_t;

/* Status codes for Noesis API functions */
#define NOESIS_SUCCESS 0
#define NOESIS_ERROR_INVALID_PARAMETER 1
#define NOESIS_ERROR_INITIALIZATION_FAILED 2
#define NOESIS_ERROR_PROCESSING_FAILED 3
#define NOESIS_ERROR_MEMORY_ALLOCATION 4
#define NOESIS_ERROR_NOT_IMPLEMENTED 5

/* Callback function type for receiving messages from Noesis */
typedef void (*noesis_callback_t)(void* user_data, const char* message);

/* API Function Declarations */

/**
 * Get the version of the Noesis API
 *
 * @param major Pointer to store the major version number
 * @param minor Pointer to store the minor version number
 * @param patch Pointer to store the patch version number
 */
void noesis_get_version(int* major, int* minor, int* patch);

/**
 * Initialize the Noesis system and create a handle
 *
 * @return A handle to the initialized Noesis system, or NULL if initialization failed
 */
noesis_handle_t noesis_initialize(void);

/**
 * Shutdown the Noesis system and release all resources
 *
 * @param handle The Noesis system handle to shut down
 */
void noesis_shutdown(noesis_handle_t handle);

/**
 * Process an input string with the Noesis cognitive system
 *
 * @param handle The Noesis system handle
 * @param input The input string to process
 * @param input_length The length of the input string
 * @param output Buffer to store the output
 * @param output_buffer_size The size of the output buffer
 * @param output_length Pointer to store the actual length of the output
 * @return NOESIS_SUCCESS on success, error code otherwise
 */
noesis_status_t noesis_process_input(
    noesis_handle_t handle,
    const char* input,
    noesis_size_t input_length,
    char* output,
    noesis_size_t output_buffer_size,
    noesis_size_t* output_length
);

/**
 * Register a callback function to receive messages from Noesis
 *
 * @param handle The Noesis system handle
 * @param event_mask Bit mask of events to subscribe to (0 for all events)
 * @param callback The callback function
 * @param user_data User data pointer passed to the callback
 * @return NOESIS_SUCCESS on success, error code otherwise
 */
noesis_status_t noesis_register_callback(
    noesis_handle_t handle,
    unsigned int event_mask,
    noesis_callback_t callback,
    void* user_data
);

/**
 * Set a configuration option in the Noesis system
 *
 * @param handle The Noesis system handle
 * @param key The configuration key
 * @param value The configuration value
 * @return NOESIS_SUCCESS on success, error code otherwise
 */
noesis_status_t noesis_set_config(
    noesis_handle_t handle,
    const char* key,
    const char* value
);

/**
 * Get a configuration value from the Noesis system
 *
 * @param handle The Noesis system handle
 * @param key The configuration key
 * @param value Buffer to store the value
 * @param value_size Size of the value buffer
 * @return NOESIS_SUCCESS on success, error code otherwise
 */
noesis_status_t noesis_get_config(
    noesis_handle_t handle,
    const char* key,
    char* value,
    noesis_size_t value_size
);

#ifdef __cplusplus
}
#endif

#endif /* NOESIS_API_H */