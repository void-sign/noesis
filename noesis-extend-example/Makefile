# Makefile for noesis-extend

# Include configuration if available
-include config.mk

# Compiler and flags
CC = gcc
CFLAGS += -Wall -Wextra -std=c99
LDFLAGS += -lm

# Source files and objects
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

# Target executables
TARGET = $(BIN_DIR)/noesis-extend

# Default target
all: $(TARGET)

# Create target executable
$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

# Compile source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Run the application
run: $(TARGET)
	LD_LIBRARY_PATH=$(shell dirname $(LDFLAGS)) $(TARGET)

.PHONY: all clean run
