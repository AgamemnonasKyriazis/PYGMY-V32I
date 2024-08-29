# Variables
CC = riscv32-unknown-elf-gcc
CFLAGS = -march=rv32i_zicsr -mabi=ilp32 -O0
LDFLAGS = -nostartfiles -nostdlib -mno-strict-align -mcmodel=medany -fno-builtin -T link.ld
OBJCOPY = riscv32-unknown-elf-objcopy
TARGET = main

# Define the source and object files
SRCS = start.s hal.c main.c
OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.s=.o)

# Default rule
all: $(TARGET).bin
	@hexdump -v -e '"@%04_ax " 1/1 "%02x\n"' main.bin > readmemfmt.hex
	@python3 main.py > image.hex
	@echo "DONE"

# Rule to build the .bin file
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Rule to build the .elf file
$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

# Rule to link the object files into the final executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(TARGET) $(OBJS)

# Rule to compile C source files into object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to build the start.o file
start.o: start.s
	$(CC) $(CFLAGS) -c -o $@ $<

# Clean up generated files
clean:
	rm -f $(OBJS) $(TARGET).elf $(TARGET).hex $(TARGET).bin image.hex readmemfmt.hex
