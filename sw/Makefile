# Variables
CC = riscv32-unknown-elf-gcc
CFLAGS = -march=rv32i -mabi=ilp32 -O0
LDFLAGS = -nostartfiles -nostdlib -mno-strict-align -mcmodel=medany -fno-builtin -T link.ld
OBJCOPY = riscv32-unknown-elf-objcopy
TARGET = main

# Default rule
all:    $(TARGET).bin;
	@hexdump -v -e '"@%04_ax " 1/1 "%02x\n"' main.bin > readmemfmt.hex;
	@python3 main.py > image.hex;
	@rm readmemfmt.hex;
	echo "DONE"

# Rule to build the start.o file
start.o: start.s
	$(CC) $(CFLAGS) -c -o $@ $<

# Rule to build the .o file
$(TARGET).o: $(TARGET).c
	$(CC) $(CFLAGS) -c -o $@ $<

# Rule to build the .elf file
$(TARGET).elf: start.o $(TARGET).o
	$(CC) $(LDFLAGS) -o $@ $^

# Rule to build the .hex file
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex $< $@

# Rule to build the .bin file
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Rule to clean the build files
clean:
	rm -f $(TARGET).o start.o $(TARGET).elf $(TARGET).hex $(TARGET).bin

