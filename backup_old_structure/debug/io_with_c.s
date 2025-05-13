/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
// Simple version that calls a C helper function
.global _noesis_read
_noesis_read:
    // Preserve frame
    pushq %rbp
    movq %rsp, %rbp

    // We receive buffer pointer in %rsi and size in %rdx
    // These are the same registers used for the C function call,
    // so no register manipulation needed

    // Call the C helper function
    call _write_test_to_buffer

    // Return 4 bytes (length of "test")
    movq $4, %rax

    // Clean up and return
    popq %rbp
    ret

// External C function that will do the actual work
.extern _write_test_to_buffer
