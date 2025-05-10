// Implementation of terminal output functions without using stdlib

// Function to write a message to the terminal using /dev/tty
void noesis_print(const char* message) {
    // Open /dev/tty for writing using a custom syscall
    long fd;
    const char* tty_path = "/dev/tty";
    asm volatile (
        "movq $2, %%rax\n"          // syscall: open
        "movq %1, %%rdi\n"         // filename pointer
        "movq $1, %%rsi\n"         // flags: O_WRONLY
        "movq $0, %%rdx\n"         // mode: 0 (not used for opening existing files)
        "syscall\n"
        "movq %%rax, %0\n"         // store file descriptor in fd
        : "=r"(fd)                 // output
        : "r"(tty_path)            // input
        : "rax", "rdi", "rsi", "rdx" // clobbered registers
    );

    // Fail silently if /dev/tty cannot be opened
    if (fd < 0) return;

    // Write each character to the file descriptor using a custom syscall
    while (*message) {
        long result;
        asm volatile (
            "movq $1, %%rax\n"      // syscall: write
            "movq %1, %%rdi\n"     // file descriptor
            "movq %2, %%rsi\n"     // message pointer
            "movq $1, %%rdx\n"     // message length (1 character)
            "syscall\n"
            "movq %%rax, %0\n"     // store result in result
            : "=r"(result)         // output
            : "r"(fd), "r"(message) // inputs
            : "rax", "rdi", "rsi", "rdx" // clobbered registers
        );
        if (result < 0) break; // Break if write fails
        message++;
    }

    // Close the file descriptor using a custom syscall
    asm volatile (
        "movq $3, %%rax\n"          // syscall: close
        "movq %0, %%rdi\n"         // file descriptor
        "syscall\n"
        :                          // no output
        : "r"(fd)                  // input
        : "rax", "rdi"             // clobbered registers
    );
}