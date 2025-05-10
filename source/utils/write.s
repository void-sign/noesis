.section __TEXT,__text
.global ___start

___start:
    # Write "Hello, World!\n" directly to stdout (file descriptor 1)
    movq $0x2000004, %rax  # syscall: write on macOS
    movq $1, %rdi          # file descriptor: stdout
    lea message(%rip), %rsi # pointer to message
    movq $14, %rdx         # message length
    syscall

    # Exit the program with status code 0
    movq $0x2000001, %rax  # syscall: exit on macOS
    xorq %rdi, %rdi        # exit code 0
    syscall

.section __TEXT,__cstring
message:
    .asciz "Hello, World!\n"
