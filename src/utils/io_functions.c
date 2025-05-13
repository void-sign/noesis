/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// io_functions.c - Pure C implementation of I/O operations using shell scripts
// No external libc headers used

#include "../../include/utils/noesis_lib.h"

// Define syscall numbers - these will be overridden in platform-specific sections
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

    #ifdef __APPLE__
    // macOS syscall numbers - redefine them here to override defaults
    #undef SYS_write
    #undef SYS_execve
    #undef SYS_access
    #undef SYS_pipe
    #undef SYS_fork
    #undef SYS_read
    #undef SYS_close
    #undef SYS_wait4
    #undef SYS_dup2
    #undef SYS_exit
    #undef SYS_open
    
    #define SYS_write 0x2000004
    #define SYS_execve 0x200003b
    #define SYS_access 0x2000021
    #define SYS_pipe 0x2000042
    #define SYS_fork 0x2000002
    #define SYS_read 0x2000003
    #define SYS_close 0x2000006
    #define SYS_wait4 0x2000007
    #define SYS_dup2 0x2000036
    #define SYS_exit 0x2000001
    #define SYS_open 0x2000005
    #endif
    
    #if defined(__APPLE__) && defined(__x86_64__)
    __asm__ volatile (
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
    #elif defined(__APPLE__) && defined(__aarch64__)
    __asm__ volatile (
        "mov x16, %1\n"  // Use x16 instead of x8 for M1/M2 Macs
        "mov x0, %2\n"
        "mov x1, %3\n"
        "mov x2, %4\n"
        "mov x3, %5\n"
        "mov x4, %6\n"
        "mov x5, %7\n"
        "svc #0x80\n"          // The syscall instruction for macOS is svc #0x80, not 0x0
        "mov %0, x0\n"
        : "=r" (ret)
        : "r" (nr), "r" (arg1), "r" (arg2), "r" (arg3), "r" (arg4), "r" (arg5), "r" (arg6)
        : "x16", "x0", "x1", "x2", "x3", "x4", "x5", "memory"
    );
    #elif defined(__linux__) && defined(__x86_64__)
    __asm__ volatile (
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

// Execute a shell script directly using the script's interpreter
static int execute_shell_script_direct(const char* script_path, const char* operation, 
                               const char* arg, char* output_buffer, 
                               unsigned long output_buffer_size) {
    // Prepare command buffer 
    char cmd[1024];
    noesis_size_t cmd_len = 0;
    
    // Copy script path to command
    const char* s = script_path;
    while (*s) {
        cmd[cmd_len++] = *s++;
        if (cmd_len >= 1020) break; // Safety check
    }
    
    // Add space and operation
    cmd[cmd_len++] = ' ';
    s = operation;
    while (*s) {
        cmd[cmd_len++] = *s++;
        if (cmd_len >= 1020) break; // Safety check
    }
    
    // Add space and argument if provided
    if (arg && *arg) {
        cmd[cmd_len++] = ' ';
        cmd[cmd_len++] = '"'; // Quote the argument
        s = arg;
        while (*s) {
            cmd[cmd_len++] = *s++;
            if (cmd_len >= 1020) break; // Safety check
        }
        cmd[cmd_len++] = '"'; 
    }
    
    cmd[cmd_len] = '\0'; // Null-terminate
    
    // Create temporary file for output
    const char* tmp_file = "/tmp/noesis_output.txt";
    
    // Append output redirection to the command
    const char* redirect = " > ";
    s = redirect;
    while (*s) {
        cmd[cmd_len++] = *s++;
    }
    
    s = tmp_file;
    while (*s) {
        cmd[cmd_len++] = *s++;
    }
    
    cmd[cmd_len] = '\0'; // Null-terminate again
    
    // Fork a child process
    int pid = syscall(SYS_fork);
    if (pid == 0) {
        // Child process - execute the command
        syscall(SYS_execve, "/bin/sh", (char*[]) {"/bin/sh", "-c", cmd, 0}, 0);
        
        // If we get here, execve failed
        syscall(SYS_exit, 1); // Exit with error
    } else if (pid < 0) {
        // Fork failed
        return -1;
    }
    
    // Parent process - wait for child to complete
    int status;
    syscall(SYS_wait4, pid, &status, 0, 0);
    
    // Read back the output from the temporary file
    int bytes_read = 0;
    int fd = syscall(SYS_open, tmp_file, O_RDONLY, 0);
    
    if (fd >= 0) {
        if (output_buffer && output_buffer_size > 0) {
            bytes_read = syscall(SYS_read, fd, output_buffer, output_buffer_size - 1);
            if (bytes_read > 0) {
                output_buffer[bytes_read] = '\0'; // Null-terminate
            } else {
                output_buffer[0] = '\0';
            }
        }
        
        syscall(SYS_close, fd);
    }
    
    return bytes_read;
}

// Execute a shell script and capture its output - safer approach for macOS
static int execute_shell_script(const char* script_path, const char* operation, 
                               const char* arg, char* output_buffer, 
                               unsigned long output_buffer_size) {
    // For macOS, we'll use a simpler approach that's less likely to trigger SIGSYS
    return execute_shell_script_direct(script_path, operation, arg, output_buffer, output_buffer_size);
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
    
    // Use direct syscall - simplest and most reliable
    syscall(SYS_write, STDOUT_FILENO, message, length);
}

// Function to read input into a buffer
// Replaces _noesis_read in io.s
int noesis_read(char* buffer, unsigned long size) {
    if (!buffer || size <= 1) {
        return 0; // Error - can't read into a buffer of size 0 or 1
    }

    // For testing/debugging - insert a test input
    #ifdef NOESIS_DEBUG_TEST_MODE
        const char* test_input = "test input\n";
        int len = 0;
        while (test_input[len] && len < size - 1) {
            buffer[len] = test_input[len];
            len++;
        }
        buffer[len] = '\0';
        return len;
    #else
        // Use direct read syscall on stdin
        int bytes_read = syscall(SYS_read, STDIN_FILENO, buffer, size - 1);
        
        if (bytes_read > 0) {
            buffer[bytes_read] = '\0'; // Null-terminate
            return bytes_read;
        } else {
            buffer[0] = '\0';
            return 0;
        }
    #endif
}

// Function to read a line of input from stdin
// Returns the number of characters read (excluding null terminator)
int noesis_getline(char* buffer, unsigned long size) {
    if (!buffer || size <= 1) {
        return 0; // Error - can't read into a buffer of size 0 or 1
    }
    
    int index = 0;
    int ch;
    
    // Read characters one by one
    while (index < size - 1) {
        // Use direct read syscall to read one character
        ch = 0;
        int result = syscall(SYS_read, STDIN_FILENO, &ch, 1);
        
        if (result <= 0) {
            // Error or EOF
            break;
        }
        
        // Store the character
        buffer[index++] = ch;
        
        // Break on newline
        if (ch == '\n') {
            break;
        }
    }
    
    // Null-terminate the string
    buffer[index] = '\0';
    
    return index;
}

// Function to get a single character from stdin
int noesis_getchar(void) {
    char ch = 0;
    int result = syscall(SYS_read, STDIN_FILENO, &ch, 1);
    if (result <= 0) {
        return -1; // Error or EOF
    }
    return ch;
}