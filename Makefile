# Noesis Project Makefile

# Compiler and flags
CC = gcc
AS = as
CFLAGS = -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include
LDFLAGS = -Lbuild/lib
LIBS = -lnlibc_stubs

# Source directories
SRC_CORE = src/core
SRC_UTILS = src/utils
SRC_API = src/api
SRC_QUANTUM = src/quantum
SRC_FIELD = $(SRC_QUANTUM)/field
SRC_ASM = $(SRC_UTILS)/asm

# Object directories
OBJ_DIR = build/obj
OBJ_CORE = $(OBJ_DIR)/core
OBJ_UTILS = $(OBJ_DIR)/utils
OBJ_API = $(OBJ_DIR)/api
OBJ_QUANTUM = $(OBJ_DIR)/quantum
OBJ_FIELD = $(OBJ_DIR)/quantum/field
OBJ_ASM = $(OBJ_DIR)/asm
BIN_DIR = build/bin

# Core objects
CORE_OBJS = $(OBJ_CORE)/emotion.o $(OBJ_CORE)/intent.o $(OBJ_CORE)/logic.o \
            $(OBJ_CORE)/main.o $(OBJ_CORE)/memory.o $(OBJ_CORE)/perception.o

# Utils objects
UTILS_OBJS = $(OBJ_UTILS)/data.o $(OBJ_UTILS)/helper.o $(OBJ_UTILS)/io_helper.o \
             $(OBJ_UTILS)/noesis_lib.o $(OBJ_UTILS)/noesis_libc_stubs.o $(OBJ_UTILS)/timer.o

# API objects
API_OBJS = $(OBJ_API)/noesis_api.o

# Quantum objects
QUANTUM_OBJS = $(OBJ_QUANTUM)/backend_ibm.o $(OBJ_QUANTUM)/backend_stub.o \
               $(OBJ_QUANTUM)/compiler.o $(OBJ_QUANTUM)/export_qasm.o $(OBJ_QUANTUM)/quantum.o

# Field objects
FIELD_OBJS = $(OBJ_FIELD)/quantum_field.o

# Assembly objects
ASM_OBJS = $(OBJ_ASM)/io.o $(OBJ_ASM)/mcopy.o $(OBJ_ASM)/repeat_input.o \
           $(OBJ_ASM)/scomp.o $(OBJ_ASM)/slen.o

# All objects
ALL_OBJS = $(CORE_OBJS) $(UTILS_OBJS) $(API_OBJS) $(QUANTUM_OBJS) $(FIELD_OBJS) $(ASM_OBJS)

# Output binary
TARGET = noesis
TEST_TARGET = noesis_tests
QBUILD = $(BIN_DIR)/qbuild
QRUN = $(BIN_DIR)/qrun

# Default target
all: directories noesis

# Create necessary directories
directories:
	mkdir -p $(OBJ_CORE) $(OBJ_UTILS) $(OBJ_API) $(OBJ_QUANTUM) $(OBJ_FIELD) $(OBJ_ASM) $(BIN_DIR)

# Core files
$(OBJ_CORE)/%.o: $(SRC_CORE)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Utils files
$(OBJ_UTILS)/%.o: $(SRC_UTILS)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# API files
$(OBJ_API)/%.o: $(SRC_API)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Quantum files
$(OBJ_QUANTUM)/%.o: $(SRC_QUANTUM)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Field files
$(OBJ_FIELD)/%.o: $(SRC_FIELD)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Assembly files
$(OBJ_ASM)/%.o: $(SRC_ASM)/%.s
	$(AS) $< -o $@

# Link the main program
noesis: $(ALL_OBJS)
	$(CC) $^ $(LDFLAGS) $(LIBS) -o $@

# Build tests
noesis_tests: $(ALL_OBJS)
	$(CC) $^ $(LDFLAGS) $(LIBS) -o $@

# Build qbuild and qrun tools
$(BIN_DIR)/qbuild:
	$(CC) src/tools/qbuild.c $(CFLAGS) -o $@

$(BIN_DIR)/qrun:
	$(CC) src/tools/qrun.c $(CFLAGS) -o $@

# Tests
test: $(TEST_TARGET)
	./$(TEST_TARGET)

# Clean up
clean:
	rm -rf $(OBJ_DIR)
	rm -f noesis noesis_tests $(BIN_DIR)/qbuild $(BIN_DIR)/qrun

.PHONY: all clean directories test
