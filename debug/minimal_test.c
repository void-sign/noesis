/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
asm (
    ".global _start\n"
    "_start:\n"
    "    mov $1, %rax\n" // syscall: write
    "    mov $1, %rdi\n" // file descriptor: stdout
    "    lea message(%rip), %rsi\n" // message address
    "    mov $20, %rdx\n" // message length
    "    syscall\n"

    "    mov $60, %rax\n" // syscall: exit
    "    xor %rdi, %rdi\n" // exit code: 0
    "    syscall\n"

    "message: .asciz \"[DEBUG] Program started\\n\"\n"
);
