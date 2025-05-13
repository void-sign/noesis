/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */


// Fixed parameter handling
.global _noesis_read
_noesis_read:
    // On macOS, parameters are passed in:
    // - %rdi = 1st parameter (not used in this function)
    // - %rsi = 2nd parameter (buffer pointer)
    // - %rdx = 3rd parameter (buffer size)
    
    // Setup stack frame
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp          // Allocate stack space
    
    // Save all registers that we'll use
    pushq %rdi              // Save rdi
    pushq %rsi              // Save buffer pointer
    pushq %rdx              // Save buffer size
    
    // Debug print buffer address and size
    movq %rsi, %r12         // Copy buffer pointer to r12 for safekeeping
    movq %rdx, %r13         // Copy buffer size to r13 for safekeeping
    
    // Call printf to show parameters
    leaq debug_fmt(%rip), %rdi  // Format string (1st param)
    movq %r12, %rsi             // Buffer address (2nd param)
    movq %r13, %rdx             // Buffer size (3rd param)
    xorq %rax, %rax             // No floating point args
    call _printf
    
    // Restore registers from stack
    popq %rdx               // Restore buffer size
    popq %rsi               // Restore buffer pointer
    popq %rdi               // Restore rdi
    
    // Check if buffer is NULL
    testq %r12, %r12        // Use r12 (buffer pointer)
    jz .return_zero
    
    // Check if buffer size is sufficient
    cmpq $5, %r13           // Use r13 (buffer size)
    jl .return_zero
    
    // Write "test" string to buffer
    movb $'t', (%r12)       // Write to buffer using r12
    movb $'e', 1(%r12)
    movb $'s', 2(%r12)
    movb $'t', 3(%r12)
    movb $0, 4(%r12)        // null terminator
    
    // Print success message
    leaq success_msg(%rip), %rdi
    xorq %rax, %rax
    call _printf
    
    // Return 4 bytes read
    movq $4, %rax
    jmp .exit

.return_zero:
    leaq error_msg(%rip), %rdi
    xorq %rax, %rax
    call _printf
    
    xorq %rax, %rax        // Return 0 (error)

.exit:
    // Clean up stack and registers
    movq %rbp, %rsp        // Restore stack pointer
    popq %rbp              // Restore base pointer
    ret

.data
debug_fmt:
    .asciz "[ASM DEBUG] Buffer addr: %p, size: %lld\n"
success_msg:
    .asciz "[ASM DEBUG] Successfully wrote 'test' to buffer\n"
error_msg:
    .asciz "[ASM DEBUG] Error: Invalid buffer\n"
