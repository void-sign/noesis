
/**
 * Reads a line of input from stdin into a buffer
 * 
 * @param buffer The buffer to store the input
 * @param size   Maximum size of the buffer
 * @return       Number of bytes read
 */
int noesis_getline(char* buffer, unsigned long size);

/**
 * Reads a single character from stdin
 * 
 * @return The character read, or -1 on error or EOF
 */
int noesis_getchar(void);

/**
 * Prints a message to stdout
 * 
 * @param message The message to print
 */
void noesis_print(const char* message);

/**
 * Reads input from stdin into a buffer
 * 
 * @param buffer The buffer to read into
 * @param size   Maximum size of the buffer
 * @return       Number of bytes read
 */
int noesis_read(char* buffer, unsigned long size);

/**
 * Writes test content to a buffer
 * 
 * @param buffer The buffer to write to
 * @param size   Maximum size of the buffer
 * @return       Number of bytes written
 */
int write_test_to_buffer(char *buffer, noesis_size_t size);