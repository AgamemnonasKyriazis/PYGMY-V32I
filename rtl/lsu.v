`timescale 1ns / 1ps

module lsu (
    /* CORE */
    input   wire [31:0] i_WDATA,
    input   wire [31:0] i_ADDR,
    input   wire        i_WE,
    input   wire        i_RE,
    input   wire [1:0]  i_HB,
    input   wire        i_ULOAD,
    output  reg  [31:0] o_RDATA,

    /* BUS */
    input   wire [31:0] i_LSU_RDATA,
    output  wire [31:0] o_LSU_WDATA, 
    output  wire [31:0] o_LSU_ADDR,
    output  wire        o_LSU_WE,
    output  wire [1:0]  o_LSU_HB,
    output  wire        o_LSU_REQ,
    input   wire        i_LSU_GNT
);

`include "core.vh"

assign o_LSU_WDATA  = i_WDATA;
assign o_LSU_ADDR   = i_ADDR;
assign o_LSU_WE     = i_WE;
assign o_LSU_HB     = i_HB;
assign o_LSU_REQ    = i_WE | i_RE;

wire byteEn = i_HB == 2'b00;
wire halfEn = i_HB == 2'b01;
wire wordEn = i_HB == 2'b10;

always @(*) begin
    case(1'b1)
    byteEn : begin
        o_RDATA <= (i_ULOAD)? { 24'b0, i_LSU_RDATA[7:0] } : i_LSU_RDATA;
    end
    halfEn : begin
        o_RDATA <= (i_ULOAD)? { 16'b0, i_LSU_RDATA[15:0] } : i_LSU_RDATA;
    end
    wordEn : begin
        o_RDATA <= i_LSU_RDATA;
    end
    endcase
end


endmodule