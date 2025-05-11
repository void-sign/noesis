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

.global _noesis_read
_noesis_read:
    // Clear the buffer before reading input
    xorq %rcx, %rcx        // Clear RCX (counter)
.clear_loop:
    cmpq %rdx, %rcx        // Check if counter >= buffer size
    jae .read_input        // If yes, jump to read input
    movb $0, (%rsi, %rcx)  // Write null to buffer
    incq %rcx              // Increment counter
    jmp .clear_loop        // Repeat
.read_input:
    movq $0x2000003, %rax  // syscall: read on macOS
    movq $0, %rdi          // file descriptor: stdin
    syscall

    // Check if no bytes were read
    testq %rax, %rax       // Check if %rax (bytes read) is 0
    jz .null_terminate     // If 0 bytes read, jump to null termination

    // Null-terminate at the end of the valid input
    leaq (%rsi, %rax), %rcx // Calculate address for null terminator
    movb $0, (%rcx)        // Write null terminator
    ret

.null_terminate:
    testq %rsi, %rsi        // Check if %rsi is NULL
    jz .error               // Jump to error handling if NULL
    cmpq $0x1000, %rsi      // Ensure %rsi is above a safe threshold
    jb .error               // Jump to error if below threshold
    movb $0, (%rsi)         // Null-terminate at the start of the buffer
    ret
.error:
    movq $1, %rdi           // File descriptor: stderr
    movq $0x2000004, %rax   // syscall: write
    syscall
    ret

// Ensure null-termination within bounds
.truncate:
    leaq -1(%rsi, %rdx), %rcx // Calculate address for buffer size - 1
    movb $0, (%rcx)        // Write null terminator
    ret

.section __DATA,__data
.align 8
debug_rsi:
    .quad 0                   // Placeholder for buffer address
debug_rdx:
    .quad 0                   // Placeholder for buffer size
