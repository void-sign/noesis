/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
// Ultra simplified io_fixed.s
.global _noesis_read
_noesis_read:
    // Setup frame
    pushq %rbp
    movq %rsp, %rbp

    // Print debug message
    leaq debug_msg(%rip), %rdi   // First arg: format string
    xorq %rax, %rax             // No vector args
    call _puts                  // Call puts instead of printf

    // Write test to buffer
    movb $'t', (%rsi)
    movb $'e', 1(%rsi)
    movb $'s', 2(%rsi)
    movb $'t', 3(%rsi)
    movb $0, 4(%rsi)

    // Return value
    movq $4, %rax

    // Cleanup
    leave
    ret

.data
debug_msg:
    .ascii "[DEBUG] Reading input"
    .byte 0                     // Null terminator for C strings
