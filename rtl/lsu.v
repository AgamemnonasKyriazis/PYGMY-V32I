`timescale 1ns / 1ps

module lsu (
    /* TO CORE */
    /* core data to bus */
    input wire [31:0] core_wdata_i,
    /* core address */
    input wire [31:0] core_addr_i,
    /* core write enable */
    input wire core_we_i,
    /* core mode half-word-byte */
    input wire [1:0] core_hb_i,
    /* core data data from bus */
    output reg [31:0] core_rdata_o,

    /* TO BUS */
    /* bus data to core */
    input wire [31:0] rom_data_i,
    input wire [31:0] ram_data_i,
    input wire [31:0] uart_data_i,
    /* bus data from core */
    output reg [31:0] bus_rdata_o, 
    /* bus address */
    output reg [31:0] bus_addr_o,
    /* bus write enable */
    output reg bus_we_o,
    /* bus mode half-word-byte */
    output reg [1:0] bus_hb_o,

    output reg [2:0] bus_cs_o
);

localparam ROM_BASE  = 32'h000000zz;
localparam RAM_BASE  = 32'h000001zz;
localparam UART_BASE = 32'h000002zz; 

always @(*) begin
    bus_rdata_o <= core_wdata_i;
    bus_we_o <= core_we_i;
    bus_hb_o <= core_hb_i;
    bus_addr_o <= {24'b0, core_addr_i[7:0]};
end

always @(*) begin
    casez (core_addr_i)
    ROM_BASE : core_rdata_o <= rom_data_i;
    RAM_BASE : core_rdata_o <= ram_data_i;
    UART_BASE : core_rdata_o <= uart_data_i;
    default  : core_rdata_o <= rom_data_i;
    endcase
end

always @(*) begin
    casez (core_addr_i)
    ROM_BASE : bus_cs_o <= 3'b001;
    RAM_BASE : bus_cs_o <= 3'b010;
    UART_BASE : bus_cs_o <= 3'b100;
    default  : bus_cs_o <= 3'b001;
    endcase
end

endmodule