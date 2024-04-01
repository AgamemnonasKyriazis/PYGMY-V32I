`timescale 1ns / 1ps

module alu (
    input wire signed [31:0] op1_i,
    
    input wire signed [31:0] op2_i,

    input wire [3:0] opcode_i,

    output reg [31:0] res_o
);

localparam [3:0] ADD    =   4'b0000;
localparam [3:0] SUB    =   4'b1000;
localparam [3:0] XOR    =   4'b0100;
localparam [3:0] OR     =   4'b0110;
localparam [3:0] AND    =   4'b0111;
localparam [3:0] SLL    =   4'b0001;
localparam [3:0] SRL    =   4'b0101;
localparam [3:0] SRA    =   4'b1010;
localparam [3:0] SLT    =   4'b0010;
localparam [3:0] SLTU   =   4'b0011;

always @(*) begin
    case (opcode_i)
    ADD : res_o = op1_i + op2_i;
    SUB : res_o = op1_i - op2_i;   
    XOR : res_o = op1_i ^ op2_i;
    OR  : res_o = op1_i | op2_i;
    AND : res_o = op1_i & op2_i;
    SLL : res_o = op1_i << op2_i;
    SRL : res_o = op1_i >> op2_i;
    SRA : res_o = op1_i >>> op2_i;
    SLT : res_o = op1_i < op2_i;
    SLTU: res_o = $unsigned(op1_i) < $unsigned(op2_i);
    default: res_o = 0;
    endcase
end

endmodule