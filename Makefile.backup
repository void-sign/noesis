# Noesis Project Makefile

# Compiler
CC = gcc

# Directories
CORE_DIR = source/core
UTILS_DIR = source/utils
API_DIR = source/api
QUANTUM_DIR = source/quantum
FIELD_DIR = source/quantum/field
TOOLS_DIR = source/tools
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
       $(UTILS_DIR)/noesis_lib.c \
       $(UTILS_DIR)/io_helper.c \
       $(API_DIR)/noesis_api.c \
       $(QUANTUM_DIR)/backend_ibm.c \
       $(QUANTUM_DIR)/backend_stub.c \
       $(QUANTUM_DIR)/compiler.c \
       $(QUANTUM_DIR)/export_json.c \
       $(QUANTUM_DIR)/export_qasm.c \
       $(QUANTUM_DIR)/quantum.c \
       $(FIELD_DIR)/quantum_field.c

TESTS = $(TEST_DIR)/core_tests.c \
        $(TEST_DIR)/main_tests.c \
        $(TEST_DIR)/utils_tests.c \
        $(TEST_DIR)/qlogic_tests.c

ALL_C_FILES = $(SRCS)

# Object file names (flattened to obj/)
OBJS = $(patsubst $(CORE_DIR)/%.c, $(OBJ_DIR)/core/%.o, $(filter $(CORE_DIR)/%, $(SRCS))) \
       $(patsubst $(UTILS_DIR)/%.c, $(OBJ_DIR)/utils/%.o, $(filter $(UTILS_DIR)/%, $(SRCS))) \
       $(patsubst $(API_DIR)/%.c, $(OBJ_DIR)/api/%.o, $(filter $(API_DIR)/%, $(SRCS))) \
       $(patsubst $(QUANTUM_DIR)/%.c, $(OBJ_DIR)/quantum/%.o, $(filter $(QUANTUM_DIR)/%, $(SRCS))) \
       $(patsubst $(FIELD_DIR)/%.c, $(OBJ_DIR)/quantum/field/%.o, $(filter $(FIELD_DIR)/%, $(SRCS))) \
       $(OBJ_DIR)/asm/repeat_input.o $(OBJ_DIR)/asm/mcopy.o $(OBJ_DIR)/asm/scomp.o $(OBJ_DIR)/asm/slen.o $(OBJ_DIR)/asm/write.o $(OBJ_DIR)/asm/io.o

# Tools
TOOLS = $(TOOLS_DIR)/qbuild.c \
        $(TOOLS_DIR)/qrun.c

# Executable
TARGET = noesis
TEST_TARGET = noesis_tests
QBUILD_TARGET = qbuild
QRUN_TARGET = qrun

# Flags
CFLAGS = -Wall -Wextra -std=c99
ASFLAGS = -g

# Add include directories to the compiler's include path
CFLAGS += -Iinclude -I. -I/Users/plugio/Documents/GitHub/noesis -I/Users/plugio/Documents/GitHub/noesis/noesis_libc/include

# Default target
all: $(TARGET) quantum_tools

quantum_tools: $(QBUILD_TARGET) $(QRUN_TARGET)

# Link main target
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) -L./lib -lnlibc_stubs
	
# Build quantum tools
$(QBUILD_TARGET): $(OBJ_DIR)/tools/qbuild.o $(filter $(OBJ_DIR)/quantum/%.o, $(OBJS))
	@mkdir -p bin
	$(CC) $^ -o bin/$(QBUILD_TARGET) -L./lib -lnlibc_stubs
	
$(QRUN_TARGET): $(OBJ_DIR)/tools/qrun.o $(filter $(OBJ_DIR)/quantum/%.o, $(OBJS))
	@mkdir -p bin
	$(CC) $^ -o bin/$(QRUN_TARGET) -L./lib -lnlibc_stubs
	
$(OBJ_DIR)/tools/%.o: $(TOOLS_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to create object files in the object directory
$(OBJ_DIR)/core/%.o: $(CORE_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/utils/%.o: $(UTILS_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/api/%.o: $(API_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -DNOESIS_BUILDING_LIB -c $< -o $@

$(OBJ_DIR)/quantum/%.o: $(QUANTUM_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/quantum/field/%.o: $(FIELD_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/asm/%.o: $(UTILS_DIR)/asm/%.s
	@mkdir -p $(dir $@)
	as -o $@ $<

# Build test executable
test: $(OBJS)
	$(CC) $(CFLAGS) $(TESTS) -o $(TEST_TARGET) $(OBJS) -L./lib -lnlibc_stubs

# Clean
clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET) $(TEST_TARGET) bin/$(QBUILD_TARGET) bin/$(QRUN_TARGET)
	rm -rf $(OBJ_DIR)

.PHONY: all clean test quantum_tools
