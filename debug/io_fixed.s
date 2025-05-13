/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
// Fixed version of io.s with proper parameter handling
.global _noesis_read
_noesis_read:
    // Setup stack frame
    pushq %rbp
    movq %rsp, %rbp

    // Print debug message
    pushq %rsi                  // Save buffer pointer
    pushq %rdx                  // Save buffer size
    movq $0x2000004, %rax       // write syscall for macOS
    movq $1, %rdi               // stdout
    leaq debug_msg(%rip), %rsi  // debug message string
    movq $22, %rdx              // Length of message
    syscall
    popq %rdx                   // Restore buffer size
    popq %rsi                   // Restore buffer pointer

    // Print out the address of the buffer for debugging
    pushq %rsi                  // Save buffer pointer again
    pushq %rdx                  // Save buffer size again
    pushq %rsi                  // Push buffer pointer for printf
    leaq addr_fmt(%rip), %rdi   // Format string
    movq $0, %rax               // No vector registers
    call _printf                // Call C printf
    addq $8, %rsp               // Pop arg
    popq %rdx                   // Restore buffer size
    popq %rsi                   // Restore buffer pointer

    // Now write the test string directly into buffer
    movb $'t', (%rsi)
    movb $'e', 1(%rsi)
    movb $'s', 2(%rsi)
    movb $'t', 3(%rsi)
    movb $0, 4(%rsi)

    // Return 4 bytes read
    movq $4, %rax

    // Cleanup and return
    leave
    ret

.data
debug_msg:
    .ascii "[DEBUG] Reading input...\n"
addr_fmt:
    .ascii "[DEBUG] Buffer address: %p\n\0"
