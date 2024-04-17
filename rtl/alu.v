`timescale 1ns / 1ps

module alu (
    input wire signed [31:0] op1_i,
    
    input wire signed [31:0] op2_i,

    input wire [7:0] opcode_i,
    input wire alu_op_i,

    output reg [31:0] res_o
);

`include "ALU_Instructions.vh"

always @(*) begin
    case (opcode_i)
    ADD, SUB : res_o = (alu_op_i)? op1_i - op2_i : op1_i + op2_i; 
    XOR : res_o = op1_i ^ op2_i;
    OR  : res_o = op1_i | op2_i;
    AND : res_o = op1_i & op2_i;
    SLL : res_o = op1_i << op2_i;
    SRL : res_o = op1_i >> op2_i;
    SRA, SLT : res_o = (alu_op_i)? (op1_i >>> op2_i) : op1_i < op2_i;
    SLTU: res_o = $unsigned(op1_i) < $unsigned(op2_i);
    default: res_o = 0;
    endcase
end

endmodule