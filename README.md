# Pygmy

Pygmy is a tiny RISC-V programmable **microcontroller** for embedded/FPGA applications designed entirely in Verilog HDL. Its initial use case is to replace complex state machines and to perform house-keeping operations in large systems that need a flexible master controller.

* Go to [sw] directory and hit make clean/make all.
* Copy the image.hex into the [rtl] directory.
* Create a Vivado project and import the .v and .hex files.

Available Features:
* Fully programmable in C.
* UART Debug using PUTTY.
* 256 Byte - ROM/RAM (expandable).
* Byte/Half-Word/Word addressable memory.

The project has be developed/verified for the artix-735t FPGA but it should be able to run in other platforms too.
This is an early version of what the final project is envisioned to be. Any incoming feature request is welcome.

TODO:
* Interrupt controller.
* TCL scipts for bitstream generation through cmd.
* Expandability (ability to include multiple peripherals).
* GPIO interface.
