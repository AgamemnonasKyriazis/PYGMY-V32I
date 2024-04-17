# Pygmy

Pygmy is a tiny 2-stage pipelined RISC-V programmable **microcontroller** for embedded/FPGA applications designed entirely in Verilog HDL. Its initial use case is to replace complex state machines and to perform house-keeping operations in large systems that need a flexible master controller.

* Go to [sw] directory and hit make clean/make all.
* Got to [main] directory and hit make clean/make all.
* Load the bitstream generated using any program you prefer.

Available Features:
* Fully programmable in C.
* UART Debug using PUTTY.
* 256 Byte - ROM/RAM (expandable).
* Byte/Half-Word/Word addressable memory.

The project has be developed/verified for the artix-735t FPGA but it should be able to run in other platforms too.
This is an early version of what the final project is envisioned to be. Any incoming feature request is welcome.

TODO:
* Interrupt controller.
* Expandability (ability to include multiple peripherals).
* GPIO interface.
* Further reduce size in LUTs and FF.
  
<img src="./PYGMY.svg">

Utilization Table:
|          Site Type         | Used | Fixed | Prohibited | Available | Util% |
|----------------------------|------|-------|------------|-----------|-------|
| Slice LUTs*                | 1021 |     0 |          0 |     20800 |  4.91 |
|   LUT as Logic             |  925 |     0 |          0 |     20800 |  4.45 |
|   LUT as Memory            |   96 |     0 |          0 |      9600 |  1.00 |
|     LUT as Distributed RAM |   96 |     0 |            |           |       |
|     LUT as Shift Register  |    0 |     0 |            |           |       |
| Slice Registers            |  303 |     0 |          0 |     41600 |  0.73 |
|   Register as Flip Flop    |  303 |     0 |          0 |     41600 |  0.73 |
|   Register as Latch        |    0 |     0 |          0 |     41600 |  0.00 |
| F7 Muxes                   |    0 |     0 |          0 |     16300 |  0.00 |
| F8 Muxes                   |    0 |     0 |          0 |      8150 |  0.00 |
