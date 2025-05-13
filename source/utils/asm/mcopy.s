/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
/*
/* 
.section __TEXT,__text
.global _mcopy
_mcopy:
    movq %rdi, %rax        # Copy destination pointer to RAX
    movq %rsi, %rbx        # Copy source pointer to RBX
    movq %rdx, %rcx        # Copy size to RCX
memcpy_loop:
    testq %rcx, %rcx       # Check if size is zero
    je memcpy_done         # If zero, jump to done
    movb (%rbx), %dl       # Load byte from source
    movb %dl, (%rax)       # Store byte to destination
    incq %rax              # Move to next byte in destination
    incq %rbx              # Move to next byte in source
    decq %rcx              # Decrement size
    jmp memcpy_loop        # Repeat loop
memcpy_done:
    ret
