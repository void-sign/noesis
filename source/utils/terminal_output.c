// Implementation of terminal output functions without using stdlib

// Declare the external write_message function from write.s
extern void write_message(const char* message, long length);

// For debugging output

void noesis_print(const char* message) {
    // Debugging output removed to eliminate stdlib dependency

    // Calculate the length of the message
    long length = 0;
    const char* temp = message;
    while (*temp++) length++;

    // Call the write_message function to handle terminal output
    write_message(message, length);
}

// Removed the _exit function and ____start entry point to make this file part of the project