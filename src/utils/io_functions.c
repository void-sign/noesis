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
    
    // Check for available shells
    int use_fish = syscall(SYS_access, "/usr/bin/fish", F_OK) == 0;
    int use_bash = syscall(SYS_access, "/bin/bash", F_OK) == 0;
    
    // Default shell path
    const char* shell_path = "/bin/sh";
    char* shell_args[] = {"/bin/sh", "-c", cmd, 0};
    
    // Use fish if available (macOS or Linux)
    if (use_fish) {
        shell_path = "/usr/bin/fish";
        shell_args[0] = "/usr/bin/fish";
        shell_args[1] = "-c";
    } 
    // Otherwise use bash if available
    else if (use_bash) {
        shell_path = "/bin/bash";
        shell_args[0] = "/bin/bash";
        shell_args[1] = "-c";
    }
    
    // Fork a child process
    int pid = syscall(SYS_fork);
    if (pid == 0) {
        // Child process - execute the command with the detected shell
        syscall(SYS_execve, shell_path, shell_args, 0);
        
        // If we get here, execve failed - try fallback to /bin/sh
        if (shell_path != "/bin/sh") {
            syscall(SYS_execve, "/bin/sh", (char*[]) {"/bin/sh", "-c", cmd, 0}, 0);
        }
        
        // If we still get here, both attempts failed
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

// Execute a shell script and capture its output with shell detection
static int execute_shell_script(const char* script_path, const char* operation, 
                               const char* arg, char* output_buffer, 
                               unsigned long output_buffer_size) __attribute__((unused));

// Execute a shell script and capture its output with shell detection
static int execute_shell_script(const char* script_path, const char* operation, 
                               const char* arg, char* output_buffer, 
                               unsigned long output_buffer_size) {
    // Check for available shells first
    int use_fish = syscall(SYS_access, "/usr/bin/fish", F_OK) == 0;
    int use_bash = syscall(SYS_access, "/bin/bash", F_OK) == 0;
    
    // Log which shell we're using
    if (use_fish) {
        noesis_print("Debug: Using fish shell for command execution\n");
    } else if (use_bash) {
        noesis_print("Debug: Using bash shell for command execution\n");
    } else {
        noesis_print("Debug: Using default /bin/sh shell for command execution\n");
    }
    
    // Use the direct execution with shell detection
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
    // Try to use shell for input handling (better readline capabilities)
    int use_shell_input = 0;
    
    // Check for available shells
    int use_fish = syscall(SYS_access, "/usr/bin/fish", F_OK) == 0;
    int use_bash = syscall(SYS_access, "/bin/bash", F_OK) == 0;
    
    // Print a debug message before reading
    noesis_print("Debug: Waiting for input...\n");
    
    int bytes_read = 0;
    
    // First try to get input through a shell script if possible
    if (use_fish || use_bash) {
        // Create a temporary file for the script
        const char* script_file = "/tmp/noesis_input.sh";
        const char* input_file = "/tmp/noesis_input_result.txt";
        
        // Create file descriptor
        int fd = syscall(SYS_open, script_file, 0x0601, 0777); // O_WRONLY | O_CREAT | O_TRUNC
        if (fd >= 0) {
            // Prepare script content based on available shell
            const char* script_content;
            if (use_fish) {
                script_content = "#!/usr/bin/fish\nread -P \"\" input\necho $input > /tmp/noesis_input_result.txt\n";
            } else {
                script_content = "#!/bin/bash\nread -p \"\" input\necho \"$input\" > /tmp/noesis_input_result.txt\n";
            }
            
            // Write script content
            syscall(SYS_write, fd, script_content, noesis_strlen(script_content));
            syscall(SYS_close, fd);
            
            // Execute script
            char* shell_path = use_fish ? "/usr/bin/fish" : "/bin/bash";
            int pid = syscall(SYS_fork);
            if (pid == 0) {
                // Child process - execute the script
                syscall(SYS_execve, shell_path, (char*[]){shell_path, script_file, 0}, 0);
                
                // If execve fails, try with sh
                syscall(SYS_execve, "/bin/sh", (char*[]){"/bin/sh", script_file, 0}, 0);
                syscall(SYS_exit, 1);
            } else if (pid > 0) {
                // Parent process - wait for child to complete
                int status;
                syscall(SYS_wait4, pid, &status, 0, 0);
                
                // Read the result
                fd = syscall(SYS_open, input_file, O_RDONLY, 0);
                if (fd >= 0) {
                    bytes_read = syscall(SYS_read, fd, buffer, size - 1);
                    syscall(SYS_close, fd);
                    use_shell_input = 1;
                }
            }
        }
    }
    
    // If shell input failed or wasn't attempted, fall back to direct syscall
    if (!use_shell_input) {
        // Use direct read syscall on stdin - block until user provides input
        bytes_read = syscall(SYS_read, STDIN_FILENO, buffer, size - 1);
    }
    
    // Debug - print what we received
    noesis_print("Debug: Raw read complete, bytes: ");
    char bytes_str[20];
    int i = 0;
    int temp = bytes_read;
    if (temp == 0) {
        bytes_str[i++] = '0';
    } else {
        do {
            bytes_str[i++] = '0' + (temp % 10);
            temp /= 10;
        } while (temp > 0);
    }
    bytes_str[i] = '\0';
    
    // Reverse the string
    for (int j = 0; j < i/2; j++) {
        char tmp = bytes_str[j];
        bytes_str[j] = bytes_str[i-j-1];
        bytes_str[i-j-1] = tmp;
    }
    noesis_print(bytes_str);
    noesis_print("\n");
    
    if (bytes_read > 0) {
        // Filter out control characters (except newline)
        int valid_bytes = 0;
        for (int i = 0; i < bytes_read; i++) {
            unsigned char c = (unsigned char)buffer[i];
            // Accept only printable ASCII, space, tab, newline
            if (c >= 32 || c == '\n' || c == '\t') {
                buffer[valid_bytes++] = c;
            }
        }
        
        // Update bytes_read to valid count
        bytes_read = valid_bytes;
        
        // Handle newlines - replace with null terminator if it's the last character
        if (bytes_read > 0 && buffer[bytes_read - 1] == '\n') {
            buffer[bytes_read - 1] = '\0';
            bytes_read--;
        } else {
            buffer[bytes_read] = '\0'; // Null-terminate
        }
        
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
    
    unsigned long index = 0;
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