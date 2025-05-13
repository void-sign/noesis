```c
/**
 * Writes test content to a buffer
 * 
 * @param buffer The buffer to write to
 * @param size   Maximum size of the buffer
 * @return       Number of bytes written
 */
int write_test_to_buffer(char *buffer, noesis_size_t size) {
    const char *test_data = "This is a test.";
    noesis_size_t data_len = 0;
    
    // Calculate length manually
    while (test_data[data_len] != '\0') {
        data_len++;
    }

    if (size < data_len) {
        // Buffer is too small, truncate the data
        for (noesis_size_t i = 0; i < size; i++) {
            buffer[i] = test_data[i];
        }
        return size;
    }

    // Copy the test data to the buffer
    for (noesis_size_t i = 0; i < data_len; i++) {
        buffer[i] = test_data[i];
    }
    return data_len;
}
```