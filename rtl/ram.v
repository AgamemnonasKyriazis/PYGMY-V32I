`timescale 1ns / 1ps

module ram(
    /* system clock */
    input wire clk_i,

    input wire ce_i,
    input wire req_i,
    output reg gnt_o,

    /* data bus in */
    input wire [31:0] wdata_i,
    /* address bus in */
    input wire [31:0] addr_i,
    /* write enable */
    input wire we_i,
    /* half-word/byte */
    input wire [1:0] hb_i,
    /* load unsigned */
    input wire uload_i,
    /* data bus out */
    output reg [31:0] rdata_o
);

reg [31:0] addr;
reg [3:0] en_vec;

reg [7:0] mem0 [0:255];
reg [7:0] mem1 [0:255];
reg [7:0] mem2 [0:255];
reg [7:0] mem3 [0:255];

initial begin
    gnt_o <= 1'b0;
end

always @(posedge clk_i) begin
    gnt_o <= req_i & ce_i;
end

always @(posedge clk_i) begin
    if (req_i & ce_i & we_i) begin
        case (en_vec)
        4'b0001 : mem0[addr] <= wdata_i[7:0];
        4'b0010 : mem1[addr] <= wdata_i[7:0];
        4'b0100 : mem2[addr] <= wdata_i[7:0];
        4'b1000 : mem3[addr] <= wdata_i[7:0];
        4'b0011 : {mem1[addr], mem0[addr]} <= wdata_i[15:0];
        4'b1100 : {mem3[addr], mem2[addr]} <= wdata_i[15:0];
        4'b1111 : {mem3[addr], mem2[addr], mem1[addr], mem0[addr]} <= wdata_i;
        default : {mem3[addr], mem2[addr], mem1[addr], mem0[addr]} <= wdata_i;
        endcase
    end
end

always @(*) begin
    if (req_i & ce_i & (~we_i)) begin
        case (en_vec)
        4'b0001 : rdata_o <= (uload_i)? { 24'b0, mem0[addr] } : { {24{mem0[addr][7]}}, mem0[addr] };
        4'b0010 : rdata_o <= (uload_i)? { 24'b0, mem1[addr] } : { {24{mem1[addr][7]}}, mem1[addr] };
        4'b0100 : rdata_o <= (uload_i)? { 24'b0, mem2[addr] } : { {24{mem2[addr][7]}}, mem2[addr] };
        4'b1000 : rdata_o <= (uload_i)? { 24'b0, mem3[addr] } : { {24{mem3[addr][7]}}, mem3[addr] };
        4'b0011 : rdata_o <= (uload_i)? { 16'b0, mem1[addr], mem0[addr] } : { {16{mem1[addr][7]}}, mem1[addr], mem0[addr] };
        4'b1100 : rdata_o <= (uload_i)? { 16'b0, mem3[addr], mem2[addr] } : { {16{mem3[addr][7]}}, mem3[addr], mem2[addr] };
        4'b1111 : rdata_o <= {mem3[addr], mem2[addr], mem1[addr], mem0[addr]};
        default : rdata_o <= {mem3[addr], mem2[addr], mem1[addr], mem0[addr]};
        endcase
    end
    else begin
        rdata_o <= 32'hxxxxxxxx;
    end
end

always @(*) begin
    case (hb_i)
    2'b10 : en_vec <= 4'b1111;
    2'b00 :
        case (addr_i[1:0])
        2'b00 : en_vec <= 4'b0001;
        2'b01 : en_vec <= 4'b0010;
        2'b10 : en_vec <= 4'b0100;
        2'b11 : en_vec <= 4'b1000;
        endcase
    2'b01 :
        case (addr_i[1])
        1'b0 : en_vec <= 4'b0011;
        1'b1 : en_vec <= 4'b1100;
        endcase
    2'b11 : en_vec <= 4'b0000; 
    endcase
end

always @(*) addr <= addr_i >> 2;

endmodule
