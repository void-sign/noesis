/**
 * noesis_api.h - Public API for the Noesis core functionality
 * 
 * This header defines the standard interface for communicating with the Noesis core.
 * Any external project that wants to use Noesis functionality should include this file
 * and link against the libnoesis.so shared library.
 * 
 * Version: 1.0.0
 */

#ifndef NOESIS_API_H
#define NOESIS_API_H

#ifdef __cplusplus
extern "C" {
#endif

/* Define export macros for different platforms */
#if defined(_WIN32) || defined(__CYGWIN__)
  #ifdef NOESIS_BUILDING_LIB
    #define NOESIS_API __declspec(dllexport)
  #else
    #define NOESIS_API __declspec(dllimport)
  #endif
#else
  #ifdef NOESIS_BUILDING_LIB
    #define NOESIS_API __attribute__((visibility("default")))
  #else
    #define NOESIS_API
  #endif
#endif

/* Type definitions */
typedef unsigned long noesis_size_t;
typedef void* noesis_handle_t;
typedef int noesis_status_t;

/* Status codes */
#define NOESIS_SUCCESS       0
#define NOESIS_ERROR        -1
#define NOESIS_INVALID_ARG  -2
#define NOESIS_OUT_OF_MEMORY -3

/**
 * Initialize the Noesis system
 * 
 * @return A handle to the Noesis instance or NULL on failure
 */
NOESIS_API noesis_handle_t noesis_initialize(void);

/**
 * Shutdown and cleanup the Noesis system
 * 
 * @param handle The Noesis instance handle
 * @return Status code
 */
NOESIS_API noesis_status_t noesis_shutdown(noesis_handle_t handle);

/**
 * Process input through the Noesis system
 * 
 * @param handle The Noesis instance handle
 * @param input The input string to process
 * @param input_length Length of the input string
 * @param output Buffer to store the output
 * @param output_size Size of the output buffer
 * @param output_length Actual length of output written
 * @return Status code
 */
NOESIS_API noesis_status_t noesis_process_input(
    noesis_handle_t handle,
    const char* input,
    noesis_size_t input_length,
    char* output,
    noesis_size_t output_size,
    noesis_size_t* output_length
);

/**
 * Get the version of the Noesis API
 * 
 * @param major Pointer to store major version number
 * @param minor Pointer to store minor version number
 * @param patch Pointer to store patch version number
 */
NOESIS_API void noesis_get_version(int* major, int* minor, int* patch);

/**
 * Register a callback function to receive notifications from Noesis
 * 
 * @param handle The Noesis instance handle
 * @param callback_type The type of callback to register
 * @param callback The callback function pointer
 * @param user_data User data to pass to the callback
 * @return Status code
 */
NOESIS_API noesis_status_t noesis_register_callback(
    noesis_handle_t handle,
    int callback_type,
    void (*callback)(void* user_data, const char* message),
    void* user_data
);

#ifdef __cplusplus
}
#endif

#endif /* NOESIS_API_H */
