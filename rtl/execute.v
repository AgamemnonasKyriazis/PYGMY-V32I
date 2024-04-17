`timescale 1ns / 1ps

module execute (
    input wire clk_i,
    input wire rst_ni,

    input wire [7:0] core_state_i,
    input wire [31:0] instruction_i,
    input wire [31:0] program_pointer_i,
    input wire stall_i,
    output wire [31:0] program_pointer_o,
    output reg [31:0] instruction_o,

    /* EXE operands */
    input wire [4:0] rd_ptr_i,
    input wire [31:0] rs1_i,
    input wire [31:0] rs2_i,
    input wire [31:0] imm_i,

    /* ALU control */
    input wire [7:0] funct3I_i,
    input wire [6:0] funct7_i,
    input wire alu_src_i,
    
    /* WB control (IN) */
    input wire reg_we_i,
    input wire mem_we_i,
    input wire mem_re_i,
    input wire [1:0] mem_hb_i,
    input wire mem_ul_i,

    /* WB control (OUT) */
    output wire [31:0] rd_o,
    output wire [4:0] rd_ptr_o,
    output wire reg_we_o,

    /* LSU (OUT) */
    input wire [31:0] rom_data_i,
    input wire [31:0] ram_data_i,
    input wire [31:0] uart_data_i,

    output wire [31:0] bus_data_o,
    output wire [31:0] bus_addr_o,
    output wire bus_we_o,
    output wire [1:0] bus_hb_o,
    output wire [3:0] bus_cs_o,

    output wire bus_req_o,
    input wire bus_gnt_i,
    output wire stall_o
);

wire [31:0] alu_op1, alu_op2, alu_res;

wire [31:0] mem_addr, mem_wdata, mem_rdata;

wire load_instruction;

alu a0 (
    /* ALU OP1 */
    .op1_i(alu_op1),
    /* ALU OP2 */
    .op2_i(alu_op2),
    /* ALU OPCODE */
    .opcode_i(funct3I_i),
    .alu_op_i(funct7_i[6]),
    /* ALU RES */
    .res_o(alu_res)
);

lsu l0 (
    /* TO CORE */
    /* core data to bus */
    .core_wdata_i(mem_wdata),
    /* core address */
    .core_addr_i(mem_addr),
    /* core write enable */
    .core_we_i(mem_we_i),
    /* core mode half-word-byte */
    .core_hb_i(mem_hb_i),
    /* core data data from bus */
    .core_rdata_o(mem_rdata),

    /* TO BUS */
    /* bus data to core */
    .rom_data_i(rom_data_i),
    .ram_data_i(ram_data_i),
    .uart_data_i(uart_data_i),
    /* bus data from core */
    .bus_rdata_o(bus_data_o),
    /* bus address */
    .bus_addr_o(bus_addr_o),
    /* bus write enable */
    .bus_we_o(bus_we_o),
    /* bus mode half-word-byte */
    .bus_hb_o(bus_hb_o),
    /* bus chip select */
    .bus_cs_o(bus_cs_o),
    /* bus request */
    .bus_req_o(bus_req_o),
    /* bus granted */
    .bus_gnt_i(bus_gnt_i)
);

assign alu_op1 = rs1_i;
assign alu_op2 = (alu_src_i)? imm_i : rs2_i;

assign mem_wdata = rs2_i;
assign mem_addr = ((~mem_re_i) & (~mem_we_i))? program_pointer_i : alu_res;

assign rd_o = (mem_re_i)? mem_rdata : alu_res;
assign rd_ptr_o = rd_ptr_i;
assign reg_we_o = reg_we_i;

assign stall_o = (bus_cs_o[1] & bus_req_o & ~bus_gnt_i);

always @(negedge clk_i)
    if (~stall_i)
        instruction_o <= instruction_i;
    else
        instruction_o <= 32'd0;

assign program_pointer_o = program_pointer_i;

endmodule