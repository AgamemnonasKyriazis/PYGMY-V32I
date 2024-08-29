`timescale 1ns / 1ps

module lsu (
    /* CORE */
    input   wire [31:0] i_WDATA,
    input   wire [31:0] i_ADDR,
    input   wire        i_WE,
    input   wire        i_RE,
    input   wire [1:0]  i_HB,
    output  wire [31:0] o_RDATA,

    /* BUS */
    input   wire [31:0] i_BUS_RDATA,
    output  wire [31:0] o_BUS_WDATA, 
    output  wire [31:0] o_BUS_ADDR,
    output  wire        o_BUS_WE,
    output  wire        o_BUS_RE,
    output  wire [1:0]  o_BUS_HB,
    output  reg  [7:0]  o_BUS_CE,
    output  wire        o_BUS_REQ,
    input   wire        i_BUS_GNT
);

`include "Core.vh"

assign o_BUS_WDATA  = i_WDATA;
assign o_BUS_ADDR   = {4'h0, i_ADDR[27:0]};
assign o_BUS_WE     = i_WE;
assign o_BUS_RE     = i_RE;
assign o_BUS_HB     = i_HB;
assign o_BUS_REQ    = (|o_BUS_CE) & (i_WE | i_RE);
assign o_RDATA      = i_BUS_RDATA;

always @* begin
    if (i_WE | i_RE)
        case (i_ADDR[31:28])
        4'h0, 4'h1 : o_BUS_CE <= 8'b00000001;
        4'h2, 4'h3 : o_BUS_CE <= 8'b00000010;
        4'h4, 4'h5 : o_BUS_CE <= 8'b00000100;
        4'h6, 4'h7 : o_BUS_CE <= 8'b00001000;
        default    : o_BUS_CE <= 8'b00000000;
        endcase
    else
        o_BUS_CE <= 8'b00000000;
end

endmodule