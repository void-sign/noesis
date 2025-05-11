.global _start

.data
message: .asciz "Enter some text: "
response: .asciz "You entered: "
buffer: .space 256

.text
_start:
    # Debug: Indicate start of program
    lea debug_start(%rip), %rsi
    mov $1, %rax            # syscall: write
    mov $1, %rdi            # file descriptor: stdout
    mov $20, %rdx           # length of debug message
    syscall

    # Exit the program
    mov $60, %rax           # syscall: exit
    xor %rdi, %rdi          # exit code: 0
    syscall

# Debug messages
debug_start: .asciz "[DEBUG] Program started\n"
