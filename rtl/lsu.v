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
    /* bus chip select */
    output reg [3:0] bus_cs_o,
    /* bus request */
    output reg bus_req_o,
    /* bus granted */
    input wire bus_gnt_i
);

`include "Core.vh"

always @(*)
    if (bus_cs_o[1])
        bus_req_o <= 1'b1;
    else
        bus_req_o <= 1'b0;

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
    ROM_BASE : bus_cs_o <= {1'b0, 1'b0, 1'b0, 1'b1};
    RAM_BASE : bus_cs_o <= {1'b0, 1'b0, 1'b1, 1'b0};
    UART_BASE : bus_cs_o <= {1'b0, 1'b1, 1'b0, 1'b0};
    default  : bus_cs_o <= {1'b0, 1'b0, 1'b0, 1'b1};
    endcase
end

endmodule