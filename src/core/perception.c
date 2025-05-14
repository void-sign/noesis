/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/********************************************************************
 *                                                                  *
 *                 NOESIS: SYNTHETIC CONSCIOUS                      *
 *                                                                  *
 ********************************************************************/


#include "../../include/core/perception.h"
#include "../../include/utils/noesis_lib.h" // For custom system calls and NOESIS_NULL
#include "../../libs/noesis_libc/include/sys/syscall.h" // For syscall numbers

// Function prototype for syscall implementation
static long syscall(long nr, ...);

// Simple system call implementation based on io_functions.c
static long syscall(long nr, ...) {
    long ret;
    long arg1 = *(&nr + 1);
    long arg2 = *(&nr + 2);
    long arg3 = *(&nr + 3);
    long arg4 = *(&nr + 4);
    long arg5 = *(&nr + 5);
    long arg6 = *(&nr + 6);

    #ifdef __APPLE__
    // macOS x86_64 syscall - using memory constraints to avoid register pressure
    __asm__ volatile(
        "movq %1, %%rax\n\t"
        "movq %2, %%rdi\n\t"
        "movq %3, %%rsi\n\t"
        "movq %4, %%rdx\n\t"
        "movq %5, %%r10\n\t"
        "movq %6, %%r8\n\t"
        "movq %7, %%r9\n\t"
        "syscall\n\t"
        "movq %%rax, %0\n\t"
        : "=m" (ret)
        : "m" (nr), "m" (arg1), "m" (arg2), "m" (arg3), "m" (arg4), "m" (arg5), "m" (arg6)
        : "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9", "rcx", "r11", "memory"
    );
    #else
    // Linux x86_64 syscall - using memory constraints to avoid register pressure
    __asm__ volatile(
        "movq %1, %%rax\n\t"
        "movq %2, %%rdi\n\t"
        "movq %3, %%rsi\n\t"
        "movq %4, %%rdx\n\t"
        "movq %5, %%r10\n\t"
        "movq %6, %%r8\n\t"
        "movq %7, %%r9\n\t"
        "syscall\n\t"
        "movq %%rax, %0\n\t"
        : "=m" (ret)
        : "m" (nr), "m" (arg1), "m" (arg2), "m" (arg3), "m" (arg4), "m" (arg5), "m" (arg6)
        : "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9", "rcx", "r11", "memory"
    );
    #endif
    
    return ret;
}

typedef unsigned long size_t;

#define STDOUT_FILENO 1

// Function to execute a system command using direct syscalls
// Returns 0 on success, non-zero on failure
static int noesis_execute_command(const char* command) {
    // Fork a child process - use syscall numbers from header
    #ifdef __APPLE__
    // macOS syscall numbers
    long fork_syscall = 0x2000002;  // SYS_fork on macOS
    long execve_syscall = 0x200003b;  // SYS_execve on macOS
    long wait4_syscall = 0x2000007;  // SYS_wait4 on macOS 
    #else
    long fork_syscall = 57;  // Linux fork syscall
    long execve_syscall = 59;  // Linux execve syscall
    long wait4_syscall = 61;  // Linux wait4 syscall
    #endif
    
    // Fork a child process
    int pid = syscall(fork_syscall);
    
    if (pid == 0) {
        // Child process
        // Execute command with /bin/sh
        char *const args[] = {"/bin/sh", "-c", (char*)command, 0};
        syscall(execve_syscall, "/bin/sh", args, 0);
        
        // If we get here, execve failed
        return -1;
    } else if (pid > 0) {
        // Parent process
        int status;
        // Wait for child to complete
        syscall(wait4_syscall, pid, &status, 0, 0);
        return status;
    } else {
        // Fork failed
        return -1;
    }
}

// Function to detect the shell environment and get the right script path
static const char* get_display_script_path() {
    // Check if fish shell exists
    #ifdef __APPLE__
    long access_syscall = SYS_access;  // Use the macOS access syscall number from header
    #else
    long access_syscall = 21;  // Linux access syscall
    #endif
    #define F_OK 0
    
    // Try to access the fish shell - if it exists, use the fish script
    if (syscall(access_syscall, "/usr/local/bin/fish", F_OK) == 0 || 
        syscall(access_syscall, "/usr/bin/fish", F_OK) == 0) {
        return "./scripts/fish/display_title.fish";
    }
    
    // Default to bash script
    return "./scripts/bash/display_title.sh";
    
    #undef F_OK
}

// Function to display the Noesis title with a table-style border and pink color
void display_noesis_title() {
    // Get the appropriate script path based on the user's shell
    const char* script_path = get_display_script_path();
    
    // Create the command to execute the script - no hardcoded user paths
    char command[256] = {0};
    const char* script = script_path;
    int i = 0;
    
    // Copy script path to command buffer
    while (*script && i < 250) {
        command[i++] = *script++;
    }
    
    // Execute the script
    noesis_execute_command(command);
}

// Variable to store the current perception data
static int perception_data = 0;

// Structure for perception module
typedef struct {
    int initialized;
    int data;
} perception_module_t;

// Function to initialize the perception system
void initialize_perception() {
    // Display the Noesis title with a border
    display_noesis_title();
    
    // Set the initial perception data to a default state (e.g., neutral or zero)
    perception_data = 0;

    const char msg[] = "Perception initialized\n";
    noesis_print(msg);
}

// Function to process sensory input and convert it into usable data
void process_perception() {
    // Placeholder for processing sensory input
    // In this function, the system would gather sensory data and convert it into usable information
    if (perception_data == 0) {
        // Neutral perception, no new data
        perception_data = 1;
    } else {
        // Process sensory input
    }

    const char msg[] = "Processing perception\n";
    noesis_print(msg);
}

// Function to handle sensory data and update the internal state
void update_perception() {
    // Example of updating perception based on new sensory data
    if (perception_data > 0) {
        // Positive perception, adjust system state
    } else if (perception_data < 0) {
        // Negative perception, adjust system state
    }

    const char msg[] = "Updating perception\n";
    noesis_print(msg);
}

// Function to reset the perception system to its initial state
void reset_perception() {
    perception_data = 0; // Reset perception to neutral or initial state

    const char msg[] = "Perception reset\n";
    noesis_print(msg);
}

/* API functions used by noesis_api.c */

// Initialize perception module
void* perception_init() {
    perception_module_t* module = (perception_module_t*)noesis_malloc(sizeof(perception_module_t));
    if (!module) {
        return NOESIS_NULL;
    }
    
    module->initialized = 1;
    module->data = 0;
    
    // Call the internal initialization function
    initialize_perception();
    
    const char msg[] = "Perception module initialized\n";
    noesis_print(msg);
    
    return module;
}

// Clean up perception module
void perception_cleanup(void* module) {
    if (!module) {
        return;
    }
    
    perception_module_t* perception_module = (perception_module_t*)module;
    perception_module->initialized = 0;
    
    // Reset perception before cleanup
    reset_perception();
    
    const char msg[] = "Perception module cleaned up\n";
    noesis_print(msg);
    
    noesis_free(module);
}

// Process input through perception module
void* perception_process(void* module, const char* input, unsigned long input_length) {
    // Suppress unused parameter warning
    (void)input_length;
    
    if (!module || !input) {
        return NOESIS_NULL;
    }
    
    perception_module_t* perception_module = (perception_module_t*)module;
    if (!perception_module->initialized) {
        return NOESIS_NULL;
    }
    
    // Process the input
    process_perception();
    update_perception();
    
    const char msg[] = "Perception module processed input\n";
    noesis_print(msg);
    
    // Return the module as the result for now (could be enhanced to return actual processed data)
    return module;
}

