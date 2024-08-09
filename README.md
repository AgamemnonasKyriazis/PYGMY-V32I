# Pygmy

Pygmy is a tiny 2-stage pipelined RISC-V programmable **microcontroller** for embedded/FPGA applications designed entirely in Verilog HDL. Its initial use case is to replace complex state machines and to perform house-keeping operations in large systems that need a flexible master controller.

* Go to [sw] directory and hit make clean/make all.
* Got to [main] directory and hit make clean/make build.
* Load the bitstream generated using make flash.

Available Features:
* Fully programmable in C.
* UART debug using PUTTY.
* 1kB - ROM/RAM (expandable).
* Byte/Half-Word/Word addressable memory.
* Up to 8 peripheral slots
    1. ROM
    2. RAM
    3. UART
    4. EXT_TIMER 
* Basic interrupt controller.
* Up to 6 external interrupts.
* UART on-receive interrupt (MEI0).
* External configurable Timer.
* Timer on-trigger interrupt (MEI5).

The project has be developed/verified for the artix-735t FPGA but it should be able to run in other platforms too.
This is an early version of what the final project is envisioned to be. Any incoming feature request is welcome.

TODO:
* GPIO interface.
* Further reduce size in LUTs and FF.
  
<img src="./PYGMY.svg">

### Utilization Table:
|          Site Type         | Used | Fixed | Prohibited | Available | Util% |
|----------------------------|------|-------|------------|-----------|-------|
| Slice LUTs                 | 1367 |     0 |          0 |     20800 |  6.57 |
|   LUT as Logic             | 1311 |     0 |          0 |     20800 |  6.30 |
|   LUT as Memory            |   56 |     0 |          0 |      9600 |  0.58 |
|     LUT as Distributed RAM |   56 |     0 |            |           |       |
|     LUT as Shift Register  |    0 |     0 |            |           |       |
| Slice Registers            |  760 |     0 |          0 |     41600 |  1.83 |
|   Register as Flip Flop    |  728 |     0 |          0 |     41600 |  1.75 |
|   Register as Latch        |   32 |     0 |          0 |     41600 |  0.08 |
| F7 Muxes                   |   62 |     0 |          0 |     16300 |  0.38 |
| F8 Muxes                   |    0 |     0 |          0 |      8150 |  0.00 |