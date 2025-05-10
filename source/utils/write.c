// Manually declare the _exit system call
__attribute__((noreturn)) void _exit(int status);

void noesis_print(const char* message) {
    // Open /dev/tty for writing using a custom syscall
    long fd;
    const char* tty_path = "/dev/tty";
    asm volatile (
        "movq $2, %%rax\n"          // syscall: open
        "movq %1, %%rdi\n"          // filename pointer
        "movq $1, %%rsi\n"          // flags: O_WRONLY
        "movq $0, %%rdx\n"          // mode: 0 (not used for opening existing files)
        "syscall\n"
        "movq %%rax, %0\n"          // store file descriptor in fd
        : "=r"(fd)                  // output
        : "r"(tty_path)             // input
        : "rax", "rdi", "rsi", "rdx" // clobbered registers
    );

    // Fail silently if /dev/tty cannot be opened
    if (fd < 0) return;

    // Write each character to the file descriptor using a custom syscall
    while (*message) {
        long result;
        asm volatile (
            "movq $1, %%rax\n"       // syscall: write
            "movq %1, %%rdi\n"       // file descriptor
            "movq %2, %%rsi\n"       // message pointer
            "movq $1, %%rdx\n"       // message length (1 character)
            "syscall\n"
            "movq %%rax, %0\n"       // store result in result
            : "=r"(result)           // output
            : "r"(fd), "r"((long)*message) // inputs
            : "rax", "rdi", "rsi", "rdx"   // clobbered registers
        );
        if (result < 0) break; // Break if write fails
        message++;
    }

    // Close the file descriptor using a custom syscall
    asm volatile (
        "movq $3, %%rax\n"          // syscall: close
        "movq %0, %%rdi\n"          // file descriptor
        "syscall\n"
        :                           // no output
        : "r"(fd)                   // input
        : "rax", "rdi"              // clobbered registers
    );
}

// Add a function to write a message to stdout using a syscall
void write_message() {
    const char* message = "Hello, World!\n";
    asm volatile (
        "movq $0x2000004, %%rax\n"  // syscall: write on macOS
        "movq $1, %%rdi\n"          // file descriptor: stdout
        "movq %0, %%rsi\n"          // pointer to message
        "movq $14, %%rdx\n"         // message length
        "syscall\n"
        :                             // no output
        : "r"(message)               // input
        : "rax", "rdi", "rsi", "rdx" // clobbered registers
    );
}

// Ensure ____start is marked as a global symbol
__attribute__((used, visibility("default"))) void ____start() {
    write_message();

    // Exit the program with status code 0
    _exit(0);
}

// Update syscall numbers for macOS
void _exit(int status) {
    asm volatile (
        "movq $0x2000001, %%rax\n"  // syscall: exit on macOS
        "movq %0, %%rdi\n"          // exit code
        "syscall\n"
        :
        : "r"((long)status)         // input
        : "rax", "rdi"              // clobbered registers
    );
}