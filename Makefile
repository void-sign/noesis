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
       $(CORE_DIR)/intent.c \
       $(UTILS_DIR)/data.c \
       $(UTILS_DIR)/helper.c \
       $(UTILS_DIR)/timer.c \
       $(UTILS_DIR)/noesis_lib.c

TESTS = $(TEST_DIR)/core_tests.c \
        $(TEST_DIR)/main_tests.c \
        $(TEST_DIR)/utils_tests.c

ALL_C_FILES = $(SRCS)

# Object file names (flattened to obj/)
OBJS = $(patsubst $(CORE_DIR)/%.c, $(OBJ_DIR)/core/%.o, $(filter $(CORE_DIR)/%, $(SRCS))) \
       $(patsubst $(UTILS_DIR)/%.c, $(OBJ_DIR)/utils/%.o, $(filter $(UTILS_DIR)/%, $(SRCS))) \
       $(OBJ_DIR)/asm/repeat_input.o $(OBJ_DIR)/asm/mcopy.o $(OBJ_DIR)/asm/scomp.o $(OBJ_DIR)/asm/slen.o $(OBJ_DIR)/asm/write.o $(OBJ_DIR)/asm/io.o

# Executable
TARGET = noesis
TEST_TARGET = noesis_tests

# Flags
CFLAGS = -Wall -Wextra -std=c99

# Add include directory to the compiler's include path
CFLAGS += -Iinclude

# Default target
all: $(TARGET)

# Link main target
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

# Rule to create object files in the object directory
$(OBJ_DIR)/core/%.o: $(CORE_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/utils/%.o: $(UTILS_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/asm/%.o: $(UTILS_DIR)/asm/%.s
	@mkdir -p $(dir $@)
	as -o $@ $<

# Build test executable
test: $(TARGET)
	$(CC) $(CFLAGS) $(SRCS) $(TESTS) -o $(TEST_TARGET)

# Clean
clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET) $(TEST_TARGET)
	rm -rf $(OBJ_DIR)

.PHONY: all clean test
