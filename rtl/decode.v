`timescale 1ns / 1ps

module decode(
    input wire clk_i,
    input wire rst_ni,

    input wire [7:0] core_state_i,
    input wire [31:0] instruction_i,
    input wire stall_i,
    output reg [31:0] program_pointer_o,

    /* WB */
    input wire [31:0] rd_i,
    input wire [4:0] rd_ptr_i,
    input wire reg_we_i, 
    
    /* EXE operands */
    output reg [31:0] rs1_o,
    output reg [31:0] rs2_o,
    output reg [31:0] imm_o,
    output reg [4:0] rd_ptr_o,
    
    /* ALU control */
    output reg [7:0] funct3I_o,
    output reg [6:0] funct7_o,
    output reg alu_src_o,

    /* WE/RE control */
    output reg reg_we_o,
    output reg mem_we_o,
    output reg mem_re_o,
    output reg [1:0] hb_o,
    output reg ul_o
);

`include "Core.vh"
`include "Instruction_Set.vh"
`include "ALU_Instructions.vh"

wire [6:0] opcode = instruction_i[6:0];
wire isAluReg   = (opcode == ALU_R);
wire isAluImm   = (opcode == ALU_I);
wire isLoad     = (opcode == LOAD);
wire isStore    = (opcode == STORE);
wire isBranch   = (opcode == BRANCH);
wire isJal      = (opcode == JAL);
wire isLui      = (opcode == LUI);
wire isAuipc    = (opcode == AUIPC);     

wire [2:0] funct3 = instruction_i[14:12];
wire [6:0] funct7 = instruction_i[31:25];
wire [7:0] funct3I = 8'b00000001 << funct3;
wire [7:0] aluOp = (isAluReg | isAluImm)? funct3I : ADD;

wire signed [31:0] rs1;
wire signed [31:0] rs2;

wire [4:0] rd_ptr = instruction_i[11:7];
wire [4:0] rs1_ptr = instruction_i[19:15];
wire [4:0] rs2_ptr = instruction_i[24:20];

regfile registers (
    .clk_i(clk_i),
    .reg_write_en_i(reg_we_i),
    .rs1_ptr_i(rs1_ptr),
    .rs2_ptr_i(rs2_ptr),
    .rd_ptr_i(rd_ptr_i),
    .rd_i(rd_i),
    .rs1_o(rs1),
    .rs2_o(rs2)
);

/* Equal */
wire EQ  = rs1 == rs2;
/* Not Equal */
wire NE  = ~EQ;
/* Less */
wire LT  = rs1 < rs2;
/* Greater or Equal */
wire GT  = ~LT;
/* Less (unsigned) */
wire LTU = $unsigned(rs1) < $unsigned(rs2);
/* Greater or Equal (unsigned) */
wire GTU = ~LTU;

wire isFollowed = 
    (isBranch & 
    (funct3I[0] & EQ) |
    (funct3I[1] & NE) |
    (funct3I[4] & LT) |
    (funct3I[5] & GT) |
    (funct3I[6] & LTU)|
    (funct3I[7] & GTU));

wire [31:0] IMM_J = { {11{instruction_i[31]}}, instruction_i[31], instruction_i[19:12], instruction_i[20], instruction_i[30:21], 1'b0 };
wire [31:0] IMM_B = { {19{instruction_i[31]}}, instruction_i[31], instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0 };
wire [31:0] IMM_U = { instruction_i[31:12], 12'b0 };
wire [31:0] IMM_R = { {20{instruction_i[31]}}, instruction_i[31:20] };
wire [31:0] IMM_S = { {20{instruction_i[31]}}, instruction_i[31:25], instruction_i[11:7] };
wire [31:0] SHAMT = { 25'b0, instruction_i[24:20] };

wire [31:0] program_pointer_incr = (isJal)? IMM_J : (isFollowed & isBranch)? IMM_B : 32'd4;

always @(posedge clk_i) begin : ProgramPointer
    if (~stall_i) begin
        case (core_state_i)
        BOOT : program_pointer_o <= 32'd0;
        RUN  : program_pointer_o <= program_pointer_o + program_pointer_incr;
        endcase
    end
end

always @(posedge clk_i) begin : SignalControl
    if (~stall_i) begin
    case (1'b1)
    isAluReg   : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b0;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    isAluImm    : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b1;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    isLoad      : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b1;
        alu_src_o <= 1'b1;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    isStore     : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b1;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b1;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    isBranch    : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b0;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    isJal       : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b1;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    isLui       : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b1;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    isAuipc     : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b1;
        hb_o <= funct3[1:0];
        ul_o <= funct3[2];
    end
    default : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        alu_src_o <= 1'b0;
        hb_o <= 2'b00;
        ul_o <= 1'b0;
    end
    endcase
    end
end

always @(posedge clk_i) begin
    if (~stall_i) begin
    funct3I_o <= aluOp;
    funct7_o <= (isAluReg)? funct7 : 7'd0;
    end
end

always @(posedge clk_i) begin : ImmSelector
    if (~stall_i) begin
    case (1'b1)
    isLoad   : imm_o <= IMM_R;
    isStore  : imm_o <= IMM_S;
    isJal    : imm_o <= 32'd4;
    isLui    : imm_o <= IMM_U;
    isAuipc  : imm_o <= IMM_U;
    default  : imm_o <= IMM_R; 
    endcase
    end
end

always @(posedge clk_i) begin : Op1Selector
    if (~stall_i) begin
    case (1'b1)
    isJal   :   rs1_o <= program_pointer_o;
    isAuipc :   rs1_o <= program_pointer_o;
    isLui   :   rs1_o <= 32'd0;
    default :   rs1_o <= rs1;
    endcase
    end
end

always @(posedge clk_i) begin : Op2Selector
    if (~stall_i) begin
    rs2_o <= rs2;
    end
end

always @(posedge clk_i) begin
    if (~stall_i) begin
    rd_ptr_o <= rd_ptr;
    end
end

initial begin
    reg_we_o  <= 1'b0;
    mem_we_o  <= 1'b0;
    mem_re_o  <= 1'b0;
    hb_o      <= 2'b00;
    ul_o      <= 1'b0;
    alu_src_o <= 1'b0;

    rs1_o <= 32'd0;
    rs2_o <= 32'd0;
    rd_ptr_o <= 5'd0;

    program_pointer_o <= 32'd0;
end

endmodule