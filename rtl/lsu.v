`timescale 1ns / 1ps

module lsu (
    /* CORE */
    input   wire [31:0] i_WDATA,
    input   wire [31:0] i_ADDR,
    input   wire        i_WE,
    input   wire        i_RE,
    input   wire [1:0]  i_HB,
    input   wire        i_ULOAD,
    output  wire [31:0] o_RDATA,

    /* BUS */
    input   wire [31:0] i_BUS_RDATA,
    output  wire [31:0] o_BUS_WDATA, 
    output  wire [31:0] o_BUS_ADDR,
    output  wire        o_BUS_WE,
    output  wire        o_BUS_RE,
    output  wire [1:0]  o_BUS_HB,
    output  wire        o_BUS_REQ,
    input   wire        i_BUS_GNT
);

`include "Core.vh"

assign o_BUS_WDATA  = i_WDATA;
assign o_BUS_ADDR   = i_ADDR;
assign o_BUS_WE     = i_WE;
assign o_BUS_RE     = i_RE;
assign o_BUS_HB     = i_HB;
assign o_BUS_REQ    = i_WE | i_RE;
assign o_RDATA      = i_BUS_RDATA;

endmodule