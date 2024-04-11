`timescale 1ns / 1ps

module alu (
    input wire signed [31:0] op1_i,
    
    input wire signed [31:0] op2_i,

    input wire [7:0] opcode_i,

    output reg [31:0] res_o
);

localparam [7:0] ADD    =   8'b00000001 << 3'b000;
localparam [7:0] SUB    =   8'b00000001 << 3'b000;
localparam [7:0] XOR    =   8'b00000001 << 3'b100;
localparam [7:0] OR     =   8'b00000001 << 3'b110;
localparam [7:0] AND    =   8'b00000001 << 3'b111;
localparam [7:0] SLL    =   8'b00000001 << 3'b001;
localparam [7:0] SRL    =   8'b00000001 << 3'b101;
localparam [7:0] SRA    =   8'b00000001 << 3'b010;
localparam [7:0] SLT    =   8'b00000001 << 3'b010;
localparam [7:0] SLTU   =   8'b00000001 << 3'b011;

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