/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
/*
/* 
// Manually declare the _exit system call
__attribute__((noreturn)) void _exit(int status);

// Add a function to write a message to stdout using a syscall
void write_message() {
    const char* message = "Hello, World!\n";
    __asm__ volatile (
        "movq $0x2000004, %%rax\n"  // syscall: write on macOS
        "movq $1, %%rdi\n"          // file descriptor: stdout
        "movq %0, %%rsi\n"          // pointer to message
        "movq $14, %%rdx\n"         // message length
        "syscall\n"
        :                             // no output
        : "r"(message)               // input
        : "rax", "rdi", "rsi", "rdx" // clobbered registers
    );
}

// Ensure ____start is marked as a global symbol
__attribute__((used, visibility("default"))) void ____start() {
    write_message();

    // Exit the program with status code 0
    _exit(0);
}

// Update syscall numbers for macOS
void _exit(int status) {
    __asm__ volatile (
        "movq $0x2000001, %%rax\n"  // syscall: exit on macOS
        "movq %0, %%rdi\n"          // exit code
        "syscall\n"
        :                             // no output
        : "r"((long)status)         // input
        : "rax", "rdi"              // clobbered registers
    );
    __builtin_unreachable();          // Ensure the function does not return
}
