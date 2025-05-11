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
    movq %rsi, %rsi        // pointer to message
    movq $1, %rdx          // write 1 byte
    syscall
    ret

// Add debugging to log %rsi and %rdx values
.global _noesis_read
_noesis_read:
    // Store %rsi and %rdx in fixed memory locations for debugging
    movq %rsi, debug_rsi(%rip) // Store buffer address in debug_rsi
    movq %rdx, debug_rdx(%rip) // Store buffer size in debug_rdx

    // Log the values of debug_rsi and debug_rdx for runtime debugging
    leaq debug_rsi(%rip), %rdi // Load address of debug_rsi into %rdi
    leaq debug_rdx(%rip), %rsi // Load address of debug_rdx into %rsi
    call _noesis_log_debug     // Call a logging function to print the values

    // Validate %rsi (buffer address)
    testq %rsi, %rsi       // Check if %rsi is null
    jz .error              // Jump to error if null    register read rsi rdx    register read rsi rdx    register read rsi rdx

    // Validate %rsi alignment (ensure 8-byte alignment)
    testq $0x7, %rsi       // Check if %rsi is aligned to 8 bytes
    jnz .error             // Jump to error if not aligned

    // Validate %rdx (buffer size)
    cmpq $256, %rdx        // Ensure size is within a reasonable range (e.g., 256 bytes)
    ja .error              // Jump to error if size is too large

    // Add additional validation to ensure %rsi and %rdx are valid before proceeding
    testq %rsi, %rsi       // Check if %rsi is null
    jz .error              // Jump to error if null
    cmpq $0x1000, %rsi     // Ensure %rsi is within a valid range
    jb .error              // Jump to error if below range

    cmpq $0x1000, %rdx     // Ensure %rdx is within a valid range
    jb .error              // Jump to error if below range

    movq $0x2000003, %rax  // syscall: read on macOS
    movq $0, %rdi          // file descriptor: stdin
    syscall

    // Check if no bytes were read
    testq %rax, %rax       // Check if %rax (bytes read) is 0
    jz .null_terminate     // If 0 bytes read, jump to null termination

    // Ensure null-termination within bounds
    cmpq %rdx, %rax        // Compare bytes read (%rax) with buffer size (%rdx)
    jae .truncate          // If bytes read >= buffer size, truncate

    // Null-terminate at the end of the valid input
    leaq (%rsi, %rax), %rcx // Calculate address for null terminator
    movb $0, (%rcx)        // Write null terminator
    ret

.error:
    movq $0x2000001, %rax  // syscall: exit on macOS
    movq $1, %rdi          // Exit code 1
    syscall

.truncate:
    // Null-terminate at the last valid position in the buffer
    leaq -1(%rsi, %rdx), %rcx // Calculate address for buffer size - 1
    movb $0, (%rcx)        // Write null terminator
    ret

.null_terminate:
    movb $0, (%rsi)        // Null-terminate at the start of the buffer
    ret

.section __DATA,__data
.align 8
debug_rsi:
    .quad 0                   // Placeholder for buffer address
debug_rdx:
    .quad 0                   // Placeholder for buffer size
