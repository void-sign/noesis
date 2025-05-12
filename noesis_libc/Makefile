# Makefile for Noesis Custom libc

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -fPIC -O2
AR = ar
RANLIB = ranlib

# Directories
SRC_DIR = src
INCLUDE_DIR = include
OBJ_DIR = obj
LIB_DIR = lib

# Source files by category
STDLIB_SRCS = $(wildcard $(SRC_DIR)/stdlib/*.c)
STRING_SRCS = $(wildcard $(SRC_DIR)/string/*.c)
STDIO_SRCS = $(wildcard $(SRC_DIR)/stdio/*.c)
MATH_SRCS = $(wildcard $(SRC_DIR)/math/*.c)
UNISTD_SRCS = $(wildcard $(SRC_DIR)/unistd/*.c)
SYS_SRCS = $(wildcard $(SRC_DIR)/sys/*.c)

# Combine all source files
ALL_SRCS = $(STDLIB_SRCS) $(STRING_SRCS) $(STDIO_SRCS) $(MATH_SRCS) $(UNISTD_SRCS) $(SYS_SRCS)

# Object files
STDLIB_OBJS = $(patsubst $(SRC_DIR)/stdlib/%.c, $(OBJ_DIR)/stdlib/%.o, $(STDLIB_SRCS))
STRING_OBJS = $(patsubst $(SRC_DIR)/string/%.c, $(OBJ_DIR)/string/%.o, $(STRING_SRCS))
STDIO_OBJS = $(patsubst $(SRC_DIR)/stdio/%.c, $(OBJ_DIR)/stdio/%.o, $(STDIO_SRCS))
MATH_OBJS = $(patsubst $(SRC_DIR)/math/%.c, $(OBJ_DIR)/math/%.o, $(MATH_SRCS))
UNISTD_OBJS = $(patsubst $(SRC_DIR)/unistd/%.c, $(OBJ_DIR)/unistd/%.o, $(UNISTD_SRCS))
SYS_OBJS = $(patsubst $(SRC_DIR)/sys/%.c, $(OBJ_DIR)/sys/%.o, $(SYS_SRCS))

# Combine all object files
ALL_OBJS = $(STDLIB_OBJS) $(STRING_OBJS) $(STDIO_OBJS) $(MATH_OBJS) $(UNISTD_OBJS) $(SYS_OBJS)

# Libraries
STATIC_LIB = $(LIB_DIR)/libnlibc.a
SHARED_LIB = $(LIB_DIR)/libnlibc.so

# Default target
all: dirs $(STATIC_LIB) $(SHARED_LIB)

# Create necessary directories
dirs:
	@mkdir -p $(OBJ_DIR)/stdlib
	@mkdir -p $(OBJ_DIR)/string
	@mkdir -p $(OBJ_DIR)/stdio
	@mkdir -p $(OBJ_DIR)/math
	@mkdir -p $(OBJ_DIR)/unistd
	@mkdir -p $(OBJ_DIR)/sys
	@mkdir -p $(LIB_DIR)

# Static library
$(STATIC_LIB): $(ALL_OBJS)
	$(AR) rcs $@ $^
	$(RANLIB) $@

# Shared library
$(SHARED_LIB): $(ALL_OBJS)
	$(CC) -shared -o $@ $^

# Compile C files
$(OBJ_DIR)/stdlib/%.o: $(SRC_DIR)/stdlib/%.c
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(OBJ_DIR)/string/%.o: $(SRC_DIR)/string/%.c
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(OBJ_DIR)/stdio/%.o: $(SRC_DIR)/stdio/%.c
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(OBJ_DIR)/math/%.o: $(SRC_DIR)/math/%.c
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(OBJ_DIR)/unistd/%.o: $(SRC_DIR)/unistd/%.c
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

$(OBJ_DIR)/sys/%.o: $(SRC_DIR)/sys/%.c
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

# Install target
install: all
	@mkdir -p $(DESTDIR)/lib
	@mkdir -p $(DESTDIR)/include/nlibc
	cp $(STATIC_LIB) $(DESTDIR)/lib/
	cp $(SHARED_LIB) $(DESTDIR)/lib/
	cp -r $(INCLUDE_DIR)/* $(DESTDIR)/include/nlibc/

# Clean target
clean:
	rm -rf $(OBJ_DIR)
	rm -rf $(LIB_DIR)

# Helper target to show source and object files
info:
	@echo "Source files:"
	@echo "  stdlib: $(STDLIB_SRCS)"
	@echo "  string: $(STRING_SRCS)"
	@echo "  stdio: $(STDIO_SRCS)"
	@echo "  math: $(MATH_SRCS)"
	@echo "  unistd: $(UNISTD_SRCS)"
	@echo "  sys: $(SYS_SRCS)"
	@echo
	@echo "Object files:"
	@echo "  stdlib: $(STDLIB_OBJS)"
	@echo "  string: $(STRING_OBJS)"
	@echo "  stdio: $(STDIO_OBJS)"
	@echo "  math: $(MATH_OBJS)"
	@echo "  unistd: $(UNISTD_OBJS)"
	@echo "  sys: $(SYS_OBJS)"

# Declare phony targets
.PHONY: all dirs clean install info
