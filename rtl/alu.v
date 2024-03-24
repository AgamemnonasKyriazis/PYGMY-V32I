module alu (
    input wire signed [31:0] op1_i,
    
    input wire signed [31:0] op2_i,

    input wire [3:0] opcode_i,

    output reg [31:0] res_o
);

localparam [3:0] ADD  = 0;
localparam [3:0] SUB  = 1;
localparam [3:0] XOR  = 2;
localparam [3:0] OR   = 3;
localparam [3:0] AND  = 4;
localparam [3:0] SLL  = 5;
localparam [3:0] SRL  = 6;
localparam [3:0] SRA  = 7;
localparam [3:0] SLT  = 8;
localparam [3:0] SLTU = 9;

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