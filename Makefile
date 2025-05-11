# Noesis Project Makefile

# Compiler
CC = gcc

# Directories
CORE_DIR = source/core
UTILS_DIR = source/utils
TEST_DIR = tests
OBJ_DIR = object

# Source Files
SRCS = $(CORE_DIR)/main.c \
       $(CORE_DIR)/emotion.c \
       $(CORE_DIR)/logic.c \
       $(CORE_DIR)/memory.c \
       $(CORE_DIR)/perception.c \
       $(UTILS_DIR)/data.c \
       $(UTILS_DIR)/helper.c \
       $(UTILS_DIR)/timer.c \
       $(UTILS_DIR)/noesis_lib.c

TESTS = $(TEST_DIR)/core_tests.c \
        $(TEST_DIR)/main_tests.c \
        $(TEST_DIR)/utils_tests.c

ALL_C_FILES = $(SRCS)

# Object file names (flattened to obj/)
OBJS = $(patsubst %.c, $(OBJ_DIR)/%.o, $(notdir $(SRCS)))
OBJS += $(OBJ_DIR)/write.o

# Executable
TARGET = noesis
TEST_TARGET = noesis_tests

# Flags
CFLAGS = -Wall -Wextra -std=c99

# Default target
all: $(TARGET)

# Link main target
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

# General rule: compile any .c to obj/*.o
$(OBJ_DIR)/%.o:
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $(shell find $(CORE_DIR) $(UTILS_DIR) -name $(notdir $*.c)) -o $@

# Rule to compile .s files
$(OBJ_DIR)/%.o: $(UTILS_DIR)/%.s
	$(CC) -c $< -o $@

$(OBJ_DIR)/write.o: $(UTILS_DIR)/asm/write.s
	$(CC) -c $< -o $@

# Build test executable
test: $(TARGET)
	$(CC) $(CFLAGS) $(SRCS) $(TESTS) -o $(TEST_TARGET)

# Clean
clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET) $(TEST_TARGET)
	rm -rf $(OBJ_DIR)

.PHONY: all clean test
