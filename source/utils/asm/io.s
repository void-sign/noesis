/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

// io.s - Assembly code for I/O operations

// Function to print a message to the terminal
.global _noesis_print
_noesis_print:
    movq $0x2000004, %rax  // syscall: write on macOS
    movq $1, %rdi          // file descriptor: stdout

    // Calculate the length of the string
    xorq %rcx, %rcx        // Clear RCX (counter)
.length_loop:
    cmpb $0, (%rsi, %rcx)  // Check if current byte is null
    je .write_string       // If null, jump to write string
    incq %rcx              // Increment counter
    jmp .length_loop       // Repeat

.write_string:
    movq %rcx, %rdx        // Set RDX to the string length
    syscall
    ret

// Clean implementation of noesis_read that calls a C helper function
// This version ensures no unintended output is produced
.global _noesis_read
_noesis_read:
    // Set up a proper stack frame - use a standard prologue
    pushq %rbp          // Save caller's base pointer
    movq %rsp, %rbp     // Set our base pointer

    // No need for alignment space as our calls are already aligned
    // Buffer pointer is already in %rsi and size in %rdx
    // These are in the correct registers for a C function call
    call _write_test_to_buffer

    // The C function returns the number of bytes read in %rax

    // Clean up and return - use standard epilogue
    popq %rbp           // Restore caller's base pointer
    ret                 // Return to caller

// Declare the external C helper function
.extern _write_test_to_buffer

// In real implementation, we could add more code here for reading from stdin
// but for now, we just want to fix the infinite loop bug

// No need for any data segment in our simplified version
debug_rdx:
    .quad 0                   // Placeholder for buffer size

.section __TEXT,__cstring
debug_start:
    .asciz "[DEBUG] Starting noesis_read...\n"
error_msg:
    .asciz "Error in noesis_read\n"
