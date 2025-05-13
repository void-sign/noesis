/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
/*
/* 
.section __TEXT,__text
.global _scomp
_scomp:
    movq %rdi, %rax        # Copy first string pointer to RAX
    movq %rsi, %rbx        # Copy second string pointer to RBX
strcmp_loop:
    movb (%rax), %cl       # Load byte from first string
    movb (%rbx), %dl       # Load byte from second string
    cmpb %cl, %dl          # Compare bytes
    jne strcmp_done        # If not equal, jump to done
    testb %cl, %cl         # Check if null terminator
    je strcmp_equal        # If null, strings are equal
    incq %rax              # Move to next byte in first string
    incq %rbx              # Move to next byte in second string
    jmp strcmp_loop        # Repeat loop
strcmp_done:
    subb %dl, %cl          # Return difference of bytes
    movb %cl, %al
    ret
strcmp_equal:
    xorq %rax, %rax        # Return 0 for equal strings
    ret
