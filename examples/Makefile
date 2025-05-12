# Example Makefile for Noesis client applications

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGET = noesis_client

# Path to Noesis library (adjust as needed)
NOESIS_PATH = ..
CFLAGS += -I$(NOESIS_PATH)/lib/include
LDFLAGS = -L$(NOESIS_PATH)/lib -lnoesis

all: $(TARGET)

$(TARGET): noesis_client.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(TARGET)

run: $(TARGET)
	LD_LIBRARY_PATH=$(NOESIS_PATH)/lib ./$(TARGET)

.PHONY: all clean run
