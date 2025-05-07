# Noesis Project Makefile

# Compiler
CC = gcc

# Directories
SRC_DIR = .
CORE_DIR = core
TEST_DIR = tests

# Source Files
SRCS = $(SRC_DIR)/main.c \
       $(CORE_DIR)/emotion.c \
       $(CORE_DIR)/logic.c \
       $(CORE_DIR)/memory.c \
       $(CORE_DIR)/perception.c \
       $(CORE_DIR)/data.c \
       $(CORE_DIR)/helper.c \
       $(CORE_DIR)/timer.c

TESTS = $(TEST_DIR)/core_tests.c \
        $(TEST_DIR)/main_tests.c \
        $(TEST_DIR)/utils_tests.c

# Object Files
OBJS = $(SRCS:.c=.o)

# Executable
TARGET = noesis
TEST_TARGET = noesis_tests

# Flags
CFLAGS = -Wall -Wextra -std=c99

# Default target
all: $(TARGET)

# Link
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

# Compile source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Build test executable
test: $(TARGET)
	$(CC) $(CFLAGS) $(SRCS) $(TESTS) -o $(TEST_TARGET)

# Clean build files
clean:
	rm -f $(CORE_DIR)/*.o $(SRC_DIR)/*.o $(TARGET) $(TEST_TARGET)

.PHONY: all clean test
