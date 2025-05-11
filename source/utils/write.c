/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software under the following conditions:
 *
 * 1. The Software may be used, copied, modified, merged, published, distributed,
 *    sublicensed, and sold under the terms specified in this license.
 *
 * 2. Redistribution of the Software or modifications thereof must include the
 *    original copyright notice and this license.
 *
 * 3. Any use of the Software in production or commercial environments must provide
 *    clear attribution to the original author(s) as defined in the copyright notice.
 *
 * 4. The Software may not be used for any unlawful purpose, or in a way that could
 *    harm other humans, animals, or living beings, either directly or indirectly.
 *
 * 5. Any modifications made to the Software must be clearly documented and made
 *    available under the same Noesis License or a compatible license.
 *
 * 6. If the Software is a core component of a profit-generating system, 
 *    the user must donate 10% of the net profit directly resulting from such
 *    use to a recognized non-profit or charitable foundation supporting humans 
 *    or other living beings.
 */

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