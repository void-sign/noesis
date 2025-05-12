#include "../../include/api/noesis_api.h"
#include "../../include/core/perception.h"
#include "../../include/core/logic.h"
#include "../../include/core/memory.h"
#include "../../include/core/emotion.h"
#include "../../include/core/intent.h"
#include "../../include/utils/noesis_lib.h"

#include <stdlib.h>
#include <string.h>

/* Define version numbers */
#define NOESIS_VERSION_MAJOR 1
#define NOESIS_VERSION_MINOR 0
#define NOESIS_VERSION_PATCH 0

/* Internal structure for the Noesis handle */
typedef struct {
    void* perception_module;
    void* logic_module;
    void* memory_module;
    void* emotion_module;
    void* intent_module;
    void (*callback)(void* user_data, const char* message);
    void* callback_user_data;
} noesis_instance_t;

/* Implementation of API functions */

NOESIS_API noesis_handle_t noesis_initialize(void) {
    noesis_instance_t* instance = (noesis_instance_t*)noesis_malloc(sizeof(noesis_instance_t));
    if (!instance) {
        return NULL;
    }
    
    /* Initialize all modules */
    instance->perception_module = perception_init();
    instance->logic_module = logic_init();
    instance->memory_module = memory_init();
    instance->emotion_module = emotion_init();
    instance->intent_module = intent_init();
    instance->callback = NULL;
    instance->callback_user_data = NULL;
    
    /* Check if all modules initialized properly */
    if (!instance->perception_module || !instance->logic_module || 
        !instance->memory_module || !instance->emotion_module || 
        !instance->intent_module) {
        
        /* Cleanup partially initialized modules */
        if (instance->perception_module) perception_cleanup(instance->perception_module);
        if (instance->logic_module) logic_cleanup(instance->logic_module);
        if (instance->memory_module) memory_cleanup(instance->memory_module);
        if (instance->emotion_module) emotion_cleanup(instance->emotion_module);
        if (instance->intent_module) intent_cleanup(instance->intent_module);
        
        noesis_free(instance);
        return NULL;
    }
    
    return (noesis_handle_t)instance;
}

NOESIS_API noesis_status_t noesis_shutdown(noesis_handle_t handle) {
    if (!handle) {
        return NOESIS_INVALID_ARG;
    }
    
    noesis_instance_t* instance = (noesis_instance_t*)handle;
    
    /* Cleanup all modules */
    perception_cleanup(instance->perception_module);
    logic_cleanup(instance->logic_module);
    memory_cleanup(instance->memory_module);
    emotion_cleanup(instance->emotion_module);
    intent_cleanup(instance->intent_module);
    
    noesis_free(instance);
    return NOESIS_SUCCESS;
}

NOESIS_API noesis_status_t noesis_process_input(
    noesis_handle_t handle,
    const char* input,
    noesis_size_t input_length,
    char* output,
    noesis_size_t output_size,
    noesis_size_t* output_length
) {
    if (!handle || !input || !output || !output_length) {
        return NOESIS_INVALID_ARG;
    }
    
    noesis_instance_t* instance = (noesis_instance_t*)handle;
    
    /* Process through perception */
    void* perception_result = perception_process(instance->perception_module, input, input_length);
    if (!perception_result) {
        return NOESIS_ERROR;
    }
    
    /* Process through logic */
    void* logic_result = logic_process(instance->logic_module, perception_result);
    if (!logic_result) {
        return NOESIS_ERROR;
    }
    
    /* Process through memory */
    void* memory_result = memory_process(instance->memory_module, logic_result);
    if (!memory_result) {
        return NOESIS_ERROR;
    }
    
    /* Process through emotion */
    void* emotion_result = emotion_process(instance->emotion_module, memory_result);
    if (!emotion_result) {
        return NOESIS_ERROR;
    }
    
    /* Process through intent */
    void* intent_result = intent_process(instance->intent_module, emotion_result);
    if (!intent_result) {
        return NOESIS_ERROR;
    }
    
    /* Convert result to string output */
    const char* result_str = intent_to_string(instance->intent_module, intent_result);
    if (!result_str) {
        return NOESIS_ERROR;
    }
    
    /* Copy result to output buffer */
    noesis_size_t result_len = strlen(result_str);
    if (result_len >= output_size) {
        *output_length = 0;
        return NOESIS_ERROR;
    }
    
    strncpy(output, result_str, output_size - 1);
    output[output_size - 1] = '\0';
    *output_length = result_len;
    
    /* Notify callback if registered */
    if (instance->callback) {
        instance->callback(instance->callback_user_data, "Input processed successfully");
    }
    
    return NOESIS_SUCCESS;
}

NOESIS_API void noesis_get_version(int* major, int* minor, int* patch) {
    if (major) *major = NOESIS_VERSION_MAJOR;
    if (minor) *minor = NOESIS_VERSION_MINOR;
    if (patch) *patch = NOESIS_VERSION_PATCH;
}

NOESIS_API noesis_status_t noesis_register_callback(
    noesis_handle_t handle,
    int callback_type,
    void (*callback)(void* user_data, const char* message),
    void* user_data
) {
    if (!handle || !callback) {
        return NOESIS_INVALID_ARG;
    }
    
    noesis_instance_t* instance = (noesis_instance_t*)handle;
    
    /* Store callback and user data */
    instance->callback = callback;
    instance->callback_user_data = user_data;
    
    return NOESIS_SUCCESS;
}
