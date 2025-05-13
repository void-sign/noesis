/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
/*
/* 
.data
message: .asciz "[DEBUG] Program started\n"

.text
_start:
    # Write debug message
    mov $1, %rax            # syscall: write
    mov $1, %rdi            # file descriptor: stdout
    lea message(%rip), %rsi # message address
    mov $20, %rdx           # message length
    syscall

    # Exit the program
    mov $60, %rax           # syscall: exit
    xor %rdi, %rdi          # exit code: 0
    syscall
