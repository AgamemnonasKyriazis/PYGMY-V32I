`timescale 1ns / 1ps

module alu (
    input  wire [31:0] i_OP1,
    input  wire [31:0] i_OP2,
    input  wire [3:0]  i_OPCODE,
    output wire [31:0] o_RES
);

localparam [3:0] ADD  = 4'b0000;
localparam [3:0] SUB  = 4'b1000;
localparam [3:0] XOR  = 4'b0100;
localparam [3:0] OR   = 4'b0110;
localparam [3:0] AND  = 4'b0111;
localparam [3:0] SLL  = 4'b0001;
localparam [3:0] SRL  = 4'b0101;
localparam [3:0] SRA  = 4'b1010;
localparam [3:0] SLT  = 4'b0010;
localparam [3:0] SLTU = 4'b0011;

wire [3:0] opcode = i_OPCODE;
wire subtract = opcode == SUB; 

wire signed [31:0] op1 = i_OP1;
wire signed [31:0] op2 = (subtract)? ~i_OP2 : i_OP2;
wire [4:0] shamt = i_OP2[4:0];

reg [31:0] res;

wire shift = (opcode == SRL) || (opcode == SRA);

always @(*) begin
    case (opcode)
    default : begin
        res <= op1 + op2 + subtract;
    end
    OR  : begin
        res <= op1 | op2;
    end
    AND : begin
        res <= op1 & op2;
    end
    XOR : begin
        res <= op1 ^ op2;
    end
    SLL : begin
        res <= op1 << shamt;
    end
    SRL : begin
        res <= op1 >> shamt;
    end
    SRA : begin
        res <= op1 >>> shamt;
    end
    SLT : begin
        res <= op1 < op2;
    end
    SLTU: begin
        res <= $unsigned(op1) < $unsigned(op2);
    end
    endcase
end

assign o_RES = res;

endmodule