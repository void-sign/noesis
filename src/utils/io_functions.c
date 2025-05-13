/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// io_functions.c - Pure C implementation of I/O operations using shell scripts
// No external libc headers used

#include "../../include/utils/noesis_lib.h"

// Define syscall numbers for Linux x86-64
#define SYS_write 1
#define SYS_execve 59
#define SYS_access 21
#define SYS_pipe 22
#define SYS_fork 57
#define SYS_read 0
#define SYS_close 3
#define SYS_wait4 61
#define SYS_dup2 33
#define SYS_exit 60
#define STDOUT_FILENO 1
#define STDIN_FILENO 0
#define O_RDONLY 00

// Define access mode macros
#define F_OK 0

// Simple system call implementation without libc
static long syscall(long nr, ...) {
    long ret;
    long arg1 = *(&nr + 1);
    long arg2 = *(&nr + 2);
    long arg3 = *(&nr + 3);
    long arg4 = *(&nr + 4);
    long arg5 = *(&nr + 5);
    long arg6 = *(&nr + 6);
    
    #ifdef __x86_64__
    asm volatile (
        "movq %1, %%rax\n"
        "movq %2, %%rdi\n"
        "movq %3, %%rsi\n"
        "movq %4, %%rdx\n"
        "movq %5, %%r10\n"
        "movq %6, %%r8\n"
        "movq %7, %%r9\n"
        "syscall\n"
        : "=a" (ret)
        : "r" (nr), "r" (arg1), "r" (arg2), "r" (arg3), "r" (arg4), "r" (arg5), "r" (arg6)
        : "rcx", "r11", "memory"
    );
    #elif defined(__aarch64__)
    // ARM64 implementation would go here if needed
    #else
    // Default non-assembly fallback (will not work, but prevents compilation errors)
    ret = -1;
    #endif
    
    return ret;
}

// Check if a file exists
static int file_exists(const char* path) {
    return syscall(SYS_access, path, F_OK) == 0;
}

// Helper function to determine which shell script to use (fish or bash)
static const char* get_io_script_path() {
    // Check if fish shell is available by testing if the file exists
    if (file_exists("/usr/bin/fish") || file_exists("/bin/fish") || file_exists("/usr/local/bin/fish")) {
        return "./scripts/fish/io_handler.fish";
    } else {
        return "./scripts/bash/io_handler.sh";
    }
}

// Execute a shell script and capture its output
static int execute_shell_script(const char* script_path, const char* operation, 
                               const char* arg, char* output_buffer, 
                               unsigned long output_buffer_size) {
    char* argv[4];
    argv[0] = (char*)script_path;
    argv[1] = (char*)operation;
    argv[2] = (char*)arg;
    argv[3] = 0; // Null terminator
    
    int pipe_fds[2];
    if (syscall(SYS_pipe, pipe_fds) < 0) {
        return -1;
    }
    
    int pid = syscall(SYS_fork);
    if (pid == 0) {
        // Child process
        syscall(SYS_close, pipe_fds[0]); // Close read end
        syscall(SYS_dup2, pipe_fds[1], 1); // Redirect stdout to pipe
        syscall(SYS_execve, script_path, argv, 0);
        syscall(1, 2, "Error executing script\n", 23); // Write to stderr
        syscall(60, 1); // Exit with error
    } else if (pid > 0) {
        // Parent process
        syscall(SYS_close, pipe_fds[1]); // Close write end
        
        int bytes_read = 0;
        if (output_buffer && output_buffer_size > 0) {
            bytes_read = syscall(SYS_read, pipe_fds[0], output_buffer, output_buffer_size - 1);
            if (bytes_read > 0) {
                output_buffer[bytes_read] = '\0'; // Null-terminate
            } else {
                output_buffer[0] = '\0';
            }
        }
        
        syscall(SYS_close, pipe_fds[0]); // Close read end
        
        int status;
        syscall(SYS_wait4, pid, &status, 0, 0);
        
        return bytes_read;
    } else {
        // Fork failed
        syscall(SYS_close, pipe_fds[0]);
        syscall(SYS_close, pipe_fds[1]);
        return -1;
    }
    
    return -1; // Should not reach here
}

// Function to print a message to the terminal
// Replaces _noesis_print in io.s
void noesis_print(const char* message) {
    if (!message) return;
    
    // Calculate string length for direct syscall
    noesis_size_t length = 0;
    while (message[length] != '\0') {
        length++;
    }
    
    // Use direct syscall to write to stdout
    syscall(SYS_write, STDOUT_FILENO, message, length);
    
    // Alternative: Use our shell script
    // const char* script_path = get_io_script_path();
    // execute_shell_script(script_path, "print", message, 0, 0);
}

// Function to read input into a buffer
// Replaces _noesis_read in io.s
int noesis_read(char* buffer, unsigned long size) {
    if (!buffer || size <= 1) {
        return 0; // Error - can't read into a buffer of size 0 or 1
    }
    
    // Get the appropriate shell script path
    const char* script_path = get_io_script_path();
    
    // Execute the read operation using the shell script
    return execute_shell_script(script_path, "read", "", buffer, size);
}

// Make sure the helper function prototype is available
extern int write_test_to_buffer(char* buffer, int size);
