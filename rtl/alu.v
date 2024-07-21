`timescale 1ns / 1ps

module alu (
    input wire signed [31:0] i_OP1,
    input wire signed [31:0] i_OP2,
    input wire [8:0] i_OPCODE,
    output reg [31:0] o_RES
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
    case (i_OPCODE[7:0])
    ADD, SUB :  o_RES = (i_OPCODE[8])? i_OP1 - i_OP2 : i_OP1 + i_OP2; 
    XOR :       o_RES = i_OP1 ^ i_OP2;
    OR  :       o_RES = i_OP1 | i_OP2;
    AND :       o_RES = i_OP1 & i_OP2;
    SLL :       o_RES = i_OP1 << i_OP2;
    SRL :       o_RES = i_OP1 >> i_OP2;
    SRA, SLT :  o_RES = (i_OPCODE[8])? (i_OP1 >>> i_OP2) : i_OP1 < i_OP2;
    SLTU:       o_RES = $unsigned(i_OP1) < $unsigned(i_OP2);
    default:    o_RES = 0;
    endcase
end

endmodule