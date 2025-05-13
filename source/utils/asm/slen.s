/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
/*
/* 
.section __TEXT,__text
.global _slen
_slen:
    movq %rdi, %rax        # Copy string pointer to RAX
    xorq %rcx, %rcx        # Clear RCX (counter)
strlen_loop:
    cmpb $0, (%rax)        # Check if current byte is null
    je strlen_done         # If null, jump to done
    incq %rax              # Move to next byte
    incq %rcx              # Increment counter
    jmp strlen_loop        # Repeat loop
strlen_done:
    movq %rcx, %rax        # Return counter as length
    ret
