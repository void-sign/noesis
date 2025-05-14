/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * noesis_api.c - Implementation of the Noesis API functions
 */

#include "../../include/api/noesis_api.h"
#include "../../include/core/emotion.h"
#include "../../include/core/intent.h"
#include "../../include/core/logic.h"
#include "../../include/core/memory.h"
#include "../../include/core/perception.h"
#include "../../include/utils/noesis_lib.h"

/* Define version constants for the API */
#define NOESIS_API_VERSION_MAJOR 1
#define NOESIS_API_VERSION_MINOR 2
#define NOESIS_API_VERSION_PATCH 0

/* Internal structure representing a Noesis system instance */
typedef struct {
    void* memory_module;
    void* perception_module;
    void* logic_module;
    void* emotion_module;
    void* intent_module;
    noesis_callback_t callback;
    void* callback_user_data;
    unsigned int callback_event_mask;
    int initialized;
} noesis_system_t;

/* Internal callback to route messages from the system to the registered callback 
 * This may be used in future versions for event handling
 */
#if defined(__GNUC__) || defined(__clang__)
__attribute__((unused))
#endif
static void internal_callback(void* system, const char* message) {
    noesis_system_t* sys = (noesis_system_t*)system;
    if (sys && sys->callback) {
        sys->callback(sys->callback_user_data, message);
    }
}

void noesis_get_version(int* major, int* minor, int* patch) {
    if (major) *major = NOESIS_API_VERSION_MAJOR;
    if (minor) *minor = NOESIS_API_VERSION_MINOR;
    if (patch) *patch = NOESIS_API_VERSION_PATCH;
}

noesis_handle_t noesis_initialize(void) {
    /* Allocate and initialize the system structure */
    noesis_system_t* system = (noesis_system_t*)noesis_malloc(sizeof(noesis_system_t));
    if (!system) {
        return NULL;
    }

    /* Initialize all modules */
    system->memory_module = memory_init();
    system->perception_module = perception_init();
    system->logic_module = logic_init();
    system->emotion_module = emotion_init();
    
    /* Initialize callback fields */
    system->callback = NULL;
    system->callback_user_data = NULL;
    system->callback_event_mask = 0;

    /* Mark as initialized if all modules loaded successfully */
    system->initialized = (system->memory_module && system->perception_module && 
                           system->logic_module && system->emotion_module && 
                           system->intent_module) ? 1 : 0;

    /* Return NULL if initialization failed */
    if (!system->initialized) {
        noesis_free(system);
        return NULL;
    }

    return (noesis_handle_t)system;
}

void noesis_shutdown(noesis_handle_t handle) {
    noesis_system_t* system = (noesis_system_t*)handle;
    if (!system) return;

    /* Clean up all modules */
    if (system->intent_module) intent_cleanup(system->intent_module);
    if (system->emotion_module) emotion_cleanup(system->emotion_module);
    if (system->logic_module) logic_cleanup(system->logic_module);
    if (system->perception_module) perception_cleanup(system->perception_module);
    if (system->memory_module) memory_cleanup(system->memory_module);

    /* Free the system structure */
    noesis_free(system);
}

noesis_status_t noesis_process_input(
    noesis_handle_t handle,
    const char* input,
    noesis_size_t input_length,
    char* output,
    noesis_size_t output_buffer_size,
    noesis_size_t* output_length
) {
    noesis_system_t* system = (noesis_system_t*)handle;
    
    /* Validate parameters */
    if (!system || !input || !output || !output_length) {
        return NOESIS_ERROR_INVALID_PARAMETER;
    }

    /* Ensure system is initialized */
    if (!system->initialized) {
        return NOESIS_ERROR_INITIALIZATION_FAILED;
    }

    /* Process through each module in the chain */
    void* perception_result = perception_process(
        system->perception_module, 
        input, 
        input_length
    );

    if (!perception_result) {
        return NOESIS_ERROR_PROCESSING_FAILED;
    }

    void* memory_result = memory_process(
        system->memory_module, 
        perception_result
    );

    if (!memory_result) {
        return NOESIS_ERROR_PROCESSING_FAILED;
    }

    void* logic_result = logic_process(
        system->logic_module, 
        memory_result
    );

    if (!logic_result) {
        return NOESIS_ERROR_PROCESSING_FAILED;
    }

    void* emotion_result = emotion_process(
        system->emotion_module, 
        logic_result
    );

    if (!emotion_result) {
        return NOESIS_ERROR_PROCESSING_FAILED;
    }

    void* intent_result = intent_process(
        system->intent_module, 
        emotion_result
    );

    if (!intent_result) {
        return NOESIS_ERROR_PROCESSING_FAILED;
    }

    /* Copy the result to the output buffer */
    const char* result_str = (const char*)intent_result;
    noesis_size_t result_len = noesis_strlen(result_str);
    
    /* Check if the output buffer is large enough */
    if (result_len >= output_buffer_size) {
        result_len = output_buffer_size - 1;
    }
    
    /* Copy the result to the output buffer */
    noesis_memcpy(output, result_str, result_len);
    output[result_len] = '\0';
    *output_length = result_len;

    return NOESIS_SUCCESS;
}

noesis_status_t noesis_register_callback(
    noesis_handle_t handle,
    unsigned int event_mask,
    noesis_callback_t callback,
    void* user_data
) {
    noesis_system_t* system = (noesis_system_t*)handle;
    
    /* Validate parameters */
    if (!system || !callback) {
        return NOESIS_ERROR_INVALID_PARAMETER;
    }

    /* Ensure system is initialized */
    if (!system->initialized) {
        return NOESIS_ERROR_INITIALIZATION_FAILED;
    }

    /* Register the callback */
    system->callback = callback;
    system->callback_user_data = user_data;
    system->callback_event_mask = event_mask;

    return NOESIS_SUCCESS;
}

noesis_status_t noesis_set_config(
    noesis_handle_t handle,
    const char* key,
    const char* value
) {
    noesis_system_t* system = (noesis_system_t*)handle;
    
    /* Validate parameters */
    if (!system || !key || !value) {
        return NOESIS_ERROR_INVALID_PARAMETER;
    }

    /* Ensure system is initialized */
    if (!system->initialized) {
        return NOESIS_ERROR_INITIALIZATION_FAILED;
    }

    /* Configuration is not implemented yet */
    return NOESIS_ERROR_NOT_IMPLEMENTED;
}

noesis_status_t noesis_get_config(
    noesis_handle_t handle,
    const char* key,
    char* value,
    noesis_size_t value_size
) {
    noesis_system_t* system = (noesis_system_t*)handle;
    
    /* Validate parameters */
    if (!system || !key || !value || value_size == 0) {
        return NOESIS_ERROR_INVALID_PARAMETER;
    }

    /* Ensure system is initialized */
    if (!system->initialized) {
        return NOESIS_ERROR_INITIALIZATION_FAILED;
    }

    /* Configuration is not implemented yet */
    return NOESIS_ERROR_NOT_IMPLEMENTED;
}