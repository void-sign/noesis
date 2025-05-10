.section __TEXT,__text
.global ___start
.global _write_message

___start:
    # Call write_message to print "Hello, World!\n"
    lea message(%rip), %rdi # pointer to message
    movq $14, %rsi         # message length
    call _write_message

    # Exit the program with status code 0
    movq $0x2000001, %rax  # syscall: exit on macOS
    xorq %rdi, %rdi        # exit code 0
    syscall

_write_message:
    # Use the arguments passed in registers
    movq $0x2000004, %rax  # syscall: write on macOS
    movq $1, %rdi          # file descriptor: stdout
    syscall
    ret

.section __TEXT,__cstring
message:
    .asciz "Hello, World!\n"
debug_message:
    .asciz "write_message called\n"
