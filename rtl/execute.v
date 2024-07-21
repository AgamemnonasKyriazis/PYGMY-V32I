`timescale 1ns / 1ps

module execute (
    input  wire [31:0]  i_CSR_RD,
    input  wire         i_CSR,
    /*-----------------------------------*/
    input  wire         i_CLK,
    input  wire         i_RSTn,
    input  wire         i_EN,
    
    input  wire [7:0]   i_FUNC3I,
    input  wire [6:0]   i_FUNCT7,
    input  wire [3:0]   i_ALU_OP1_SEL,
    input  wire [3:0]   i_ALU_OP2_SEL,
    input  wire [4:0]   i_RD_PTR,
    input  wire [31:0]  i_RS1,
    input  wire [31:0]  i_RS2,
    input  wire [31:0]  i_IMM,
    
    input  wire         i_REG_WE,
    input  wire         i_MEM_WE,
    input  wire         i_MEM_RE,
    input  wire [1:0]   i_HB,
    input  wire         i_ULOAD,
    input  wire [31:0]  i_PC,
    
    output wire [31:0]  o_RD,
    output wire [4:0]   o_RD_PTR,
    output wire         o_REG_WE,
    
    output wire [31:0]  o_MEM_ADDR,
    input  wire [31:0]  i_MEM_RDATA
    /*-----------------------------------*/
);

reg  [31:0] AluOp1;
reg  [31:0] AluOp2;
wire [31:0] AluRes;
wire [8:0]  AluOpcode   = {i_FUNCT7[6], i_FUNC3I};

assign o_MEM_ADDR   =   AluRes;

/*--------------------------------------------- ALU -----------------------------------------------*/

alu ALU (
    .i_OP1(AluOp1),
    .i_OP2(AluOp2),
    .i_OPCODE(AluOpcode),
    .o_RES(AluRes)
);

always @(*) begin : Op1Selector
    case (i_ALU_OP1_SEL)
    4'b0001 :   AluOp1 <= i_RS1;
    4'b0010 :   AluOp1 <= i_PC;
    4'b0100 :   AluOp1 <= 32'd0;
    4'b1000 :   AluOp1 <= 32'd0;
    default :   AluOp1 <= i_RS1;
    endcase
end

always @(*) begin : Op2Selector
    case (i_ALU_OP2_SEL)
    4'b0001 :   AluOp2 <= i_RS2;
    4'b0010 :   AluOp2 <= i_IMM;
    4'b0100 :   AluOp2 <= 32'd0;
    4'b1000 :   AluOp2 <= 32'd0;
    default :   AluOp2 <= i_RS2;
    endcase
end

assign o_RD     = (i_MEM_RE)? i_MEM_RDATA : (i_CSR)? i_CSR_RD : AluRes;
assign o_RD_PTR = i_RD_PTR;
assign o_REG_WE = i_REG_WE;

endmodule