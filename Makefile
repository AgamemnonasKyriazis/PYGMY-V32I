# Variables
SHELL = /bin/bash

# Phony targets
.PHONY: all flash clean

# Default target
all: build

# Rule to create build directory
build:
	cd sw && make clean && make all && cd ..
	mkdir -p build/synth/reports build/bit
	vivado -mode batch -nolog -nojournal -source build.tcl

# Rule to flash
flash:
	vivado -mode batch -nolog -nojournal -source flash.tcl

# Rule to clean
clean:
	rm -rf build
