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
    input wire [31:0] urom_data_i,
    input wire [31:0] sram_data_i,
    input wire [31:0] uart_data_i,
    input wire [31:0] eram_data_i,
    /* bus data from core */
    output wire [31:0] bus_rdata_o, 
    /* bus address */
    output wire [31:0] bus_addr_o,
    /* bus write enable */
    output wire bus_we_o,
    /* bus mode half-word-byte */
    output wire [1:0] bus_hb_o,
    /* bus chip select */
    output wire [7:0] bus_ce_o,
    /* bus request */
    output wire bus_req_o,
    /* bus granted */
    input wire bus_gnt_i
);

`include "Core.vh"

always @(*) begin
    case (1'b1)
    bus_ce_o[0] : core_rdata_o <= urom_data_i;
    bus_ce_o[1] : core_rdata_o <= sram_data_i;
    bus_ce_o[2] : core_rdata_o <= uart_data_i;
    bus_ce_o[3] : core_rdata_o <= eram_data_i;
    default     : core_rdata_o <= 32'hzzzzzzzz;
    endcase
end

assign bus_ce_o[0] = (UROM_BASE[31:24]  ==  core_addr_i[31:24]);
assign bus_ce_o[1] = (SRAM_BASE[31:24]  ==  core_addr_i[31:24]);
assign bus_ce_o[2] = (UART_BASE[31:24] ==  core_addr_i[31:24]);
assign bus_ce_o[3] = (ERAM_BASE[31:24] ==  core_addr_i[31:24]);
assign bus_ce_o[4] = 1'b0;
assign bus_ce_o[5] = 1'b0;
assign bus_ce_o[6] = 1'b0;
assign bus_ce_o[7] = 1'b0;

assign bus_we_o = core_we_i;
assign bus_hb_o = core_hb_i;

assign bus_rdata_o = core_wdata_i;
assign bus_addr_o = {8'h00, core_addr_i[23:0]};

assign bus_req_o = (bus_ce_o[1] | bus_ce_o[2] | bus_ce_o[3]);

endmodule