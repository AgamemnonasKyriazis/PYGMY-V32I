`timescale 1ns / 1ps

module top(
    input wire sysclk,
    input wire rst,
    input wire uart_txd_in,
    output wire uart_rxd_out,

    output wire [18:0] MemAdr,
    inout wire [7:0] MemDB,
    output wire RamOEn,
    output wire RamWEn,
    output wire RamCEn
);

`include "Core.vh"

wire rst_n;

wire [31:0] rs1;
wire [31:0] rs2;
wire [31:0] imm;
wire [4:0] rd_ptr;

wire [7:0] funct3I;
wire [6:0] funct7;
wire alu_src;

wire reg_we;
wire mem_we;
wire mem_re;
wire ul;
wire [1:0] hb;

wire [31:0] wb_rd;
wire [4:0] wb_rd_ptr;
wire wb_reg_we;

wire [31:0] bus_data;
wire [31:0] bus_addr;
wire bus_we;
wire [1:0] bus_hb;

wire [31:0] urom_data;
wire [31:0] sram_data;
wire [31:0] uart_data;
wire [31:0] eram_data;

wire bus_req;
wire bus_gnt;

wire urom_gnt;
wire sram_gnt;
wire uart_gnt;
wire eram_gnt;

wire urom_ce;
wire sram_ce;
wire uart_ce;
wire eram_ce;

wire [1:0] uart_irq;
wire [7:0] uart_rx_rdata;

reg [7:0] core_state;
wire [31:0] program_pointer, rom_ptr2_addr;
wire [31:0] instruction, rom_ptr2_data;

always @(posedge sysclk, negedge rst_n) begin
    if (~rst_n)
        core_state <= BOOT;
    else
        core_state <= RUN;
end

wire stall;

decode d0 (
    .clk_i(sysclk),
    .rst_ni(rst_n),

    .core_state_i(core_state),
    .instruction_i(instruction),
    .stall_i(stall),
    .program_pointer_o(program_pointer),

    /* WB */
    .rd_i(wb_rd),
    .rd_ptr_i(wb_rd_ptr),
    .reg_we_i(wb_reg_we),

    /* EXE operands */
    .imm_o(imm),
    .rs1_o(rs1),
    .rs2_o(rs2),
    .rd_ptr_o(rd_ptr),

    /* ALU control */
    .funct3I_o(funct3I),
    .funct7_o(funct7),
    .alu_src_o(alu_src),

    /* WE/RE control */
    .reg_we_o(reg_we),
    .mem_we_o(mem_we),
    .mem_re_o(mem_re),
    .hb_o(hb),
    .ul_o(ul)    
);

execute e0 (
    .clk_i(sysclk),
    .rst_ni(rst_n),

    .core_state_i(core_state),
    .instruction_i(rom_ptr2_data),
    .program_pointer_i(program_pointer),
    .stall_i(stall),
    .program_pointer_o(rom_ptr2_addr),
    .instruction_o(instruction),

    /* EXE operands */
    .rs1_i(rs1),
    .rs2_i(rs2),
    .imm_i(imm),
    .rd_ptr_i(rd_ptr),

    /* ALU control */
    .funct3I_i(funct3I),
    .funct7_i(funct7),
    .alu_src_i(alu_src),

    /* WE/RE control (IN) */
    .reg_we_i(reg_we),
    .mem_we_i(mem_we),
    .mem_re_i(mem_re),
    .mem_hb_i(hb),
    .mem_ul_i(ul),

    /* WB  control (OUT) */
    .rd_o(wb_rd),
    .rd_ptr_o(wb_rd_ptr),
    .reg_we_o(wb_reg_we),

    /* LSU (BUS) */
    .urom_data_i(urom_data),
    .sram_data_i(sram_data),
    .uart_data_i({24'b0, uart_rx_rdata}),
    .eram_data_i(eram_data),

    .bus_data_o(bus_data),
    .bus_addr_o(bus_addr),
    .bus_we_o(bus_we),
    .bus_hb_o(bus_hb),

    .bus_ce_o({eram_ce, uart_ce, sram_ce, urom_ce}),

    .bus_req_o(bus_req),
    .bus_gnt_i(bus_gnt),
    .stall_o(stall)
);

rom rom0 (
    /* address bus */
    .addr_prt1_i(bus_addr),
    .addr_prt2_i(rom_ptr2_addr),
    /* half-word/byte */
    .hb_i(bus_hb),
    /* data bus out */
    .rdata_prt1_o(urom_data),
    .rdata_prt2_o(rom_ptr2_data),

    .urom_ce_i(urom_ce),
    .urom_req_i(bus_req),
    .urom_gnt_o(urom_gnt)
);

ram ram0 (
    .clk_i(sysclk),
    .rst_ni(rst_n),

    .ce_i(sram_ce),
    .req_i(bus_req),
    .gnt_o(sram_gnt),

    /* data bus in */
    .wdata_i(bus_data),
    /* address bus in */
    .addr_i(bus_addr),
    /* write enable */
    .we_i(bus_we),
    /* half-word/byte */
    .hb_i(bus_hb),
    /* load unsigned */
    .uload_i(1'b0),
    /* data bus out */
    .rdata_o(sram_data)
);

uart uart0 (
    .clk_i(sysclk),
    .rst_ni(rst_n),
    /* serial rx in */
    .uart_rx_i(uart_txd_in),
    /* uart we */
    .uart_we_i(bus_we & uart_ce),
    /* uart re */
    .uart_re_i(~bus_we & uart_ce),
    /* uart tx parallel */
    .uart_tx_wdata_i(bus_data[7:0]),
    /* uart rx parallel */
    .uart_rx_rdata_o(uart_rx_rdata),
    /* serial tx out */
    .uart_tx_o(uart_rxd_out),
    /* interrupt request vector */
    .uart_irq_o(uart_irq),

    .uart_ce_i(uart_ce),
    .uart_req_i(bus_req),
    .uart_gnt_o(uart_gnt)
);


ram_controller eram (
    .clk_i(sysclk),
    .rst_ni(rst_n),
    .ce_i(eram_ce),
    .we_i(bus_we),
    .req_i(bus_req),
    .wdata_i(bus_data),
    .addr_i(bus_addr),
    .rdata_o(eram_data),
    .gnt_o(eram_gnt),
    
    .ce_no(RamCEn),
    .we_no(RamWEn),
    .oe_no(RamOEn),
    .data_io(MemDB)
);

assign rst_n = ~rst;

assign bus_gnt = urom_gnt | sram_gnt | uart_gnt | eram_gnt;

assign MemAdr = bus_addr;

endmodule
