`timescale 1ns / 1ps

module decode(  
    input wire          i_CLK,
    input wire          i_RSTn,

    input wire          i_EN,

    input  wire         i_IRQ,
    output wire [7:0]   o_CORE_STATE,

    input wire          i_INSTRUCTION_VALID,
    input wire  [31:0]  i_INSTRUCTION,
    input wire  [31:0]  i_MTVEC,
    input wire  [31:0]  i_MEPC,
    
    input wire  [31:0]  i_RD,
    input wire  [4:0]   i_RD_PTR,
    input wire          i_REG_WE,

    output reg  [2:0]   o_FUNCT3,
    output reg  [6:0]   o_FUNCT7,
    output reg  [4:0]   o_RD_PTR,

    output reg  [31:0]  o_RS1,
    output reg  [31:0]  o_RS2,
    output reg  [31:0]  o_IMM_VAL,

    output reg  [1:0]   o_ALU_OP,
    output reg          o_REG_WE,
    output reg          o_MEM_WE,
    output reg          o_MEM_RE,
    output reg          o_ECALL,
    output reg          o_IMM,
    output reg          o_JAL,
    output reg          o_LUI,
    output reg          o_AUIPC,

    output wire [31:0]  o_PC,
    output reg  [31:0]  o_PC_PIPELINE,
    output reg  [31:0]  o_INSTRUCTION
    /*-----------------------------------*/
);

parameter RESET_VECTOR = 32'h80000000;

`include "Core.vh"

`include "Instruction_Set.vh"

`include "control_status_registers.vh"

wire stall = ~i_EN;

wire [31:0] instruction = (enterTrap)? NOOP : i_INSTRUCTION;
wire [6:0]  opcode      = instruction[6:0];

wire isAluReg       = (opcode == ALU_R);
wire isAluImm       = (opcode == ALU_I);
wire isLoad         = (opcode == LOAD);
wire isStore        = (opcode == STORE);
wire isBranch       = (opcode == BRANCH);
wire isJal          = (opcode == JAL);
wire isLui          = (opcode == LUI);
wire isAuipc        = (opcode == AUIPC);
wire isEcall        = (opcode == ECALL);
wire isJalr         = (opcode == JALR);
wire isMret         = (isEcall && (IMM_R == MRET));

wire isNoop         = (instruction == NOOP);
wire isWfi          = (instruction == WFI);

wire [2:0] funct3   = instruction[14:12];
wire [6:0] funct7   = instruction[31:25];
wire [7:0] funct3I  = 8'b00000001 << funct3;

wire signed [31:0] rs1;
wire signed [31:0] rs2;

wire [4:0] rd_ptr   = instruction[11:7];
wire [4:0] rs1_ptr  = instruction[19:15];
wire [4:0] rs2_ptr  = instruction[24:20];

wire [4:0]  rd_ptr_i = i_RD_PTR;
wire [31:0] rd_i     = i_RD;
wire        reg_we_i = i_REG_WE;

/* REGISTER FILE */
regfile registers (
    .i_CLK(i_CLK),
    .i_WE(i_REG_WE),
    .i_RD_PTR(i_RD_PTR),
    .i_RD(i_RD),
    .i_RS1_PTR(rs1_ptr),
    .o_RS1(rs1),
    .i_RS2_PTR(rs2_ptr),
    .o_RS2(rs2)
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
/* Branch is Followed */
wire isFollowed = 
    (isBranch & 
    ((funct3I[0] & EQ) |
     (funct3I[1] & NE) |
     (funct3I[4] & LT) |
     (funct3I[5] & GT) |
     (funct3I[6] & LTU)|
     (funct3I[7] & GTU)));

wire [31:0] IMM_J   = { {11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
wire [31:0] IMM_B   = { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
wire [31:0] IMM_R   = { {20{instruction[31]}}, instruction[31:20] };
wire [31:0] IMM_U   = { instruction[31:12], 12'b0 };
wire [31:0] IMM_S   = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
wire [31:0] IMM_SFT = { 25'b0, instruction[24:20] };
wire [31:0] IMM_CSR = { 20'b0, instruction[31:20] };

/* CORE STATE CONTROL */
reg  [7:0]  coreState;
reg  [7:0]  coreStateNext;
wire        enterTrap = (i_IRQ == 1'b1) && (coreState == USER);
wire        leaveTrap = (isMret == 1'b1) && (coreState == MACHINE);
wire        halt      = (isWfi == 1'b1);

always @(*) begin
    case (coreState)
    USER : begin
        coreStateNext <= (enterTrap)? MACHINE : USER;
    end
    MACHINE : begin
        coreStateNext <= (leaveTrap)? USER : MACHINE;
    end
    default : begin
        coreStateNext <= USER;
    end
    endcase
end

always @(posedge i_CLK) begin
    if (~i_RSTn)
        coreState <= USER;
    else if (i_EN & i_INSTRUCTION_VALID)
        coreState <= coreStateNext;
end
assign o_CORE_STATE = coreState;


/* PROGRAM COUNTER CONTROL */
reg  [31:0] pc;
reg  [31:0] pc_op1;
reg  [31:0] pc_op2;
reg  [31:0] pc_next;

always @(*) begin
    pc_op1 <= (isJalr)? rs1 : pc;
end

always @(*) begin : programCounterIncrement
    if (isJal)
        pc_op2 <= IMM_J;
    else if (isJalr)
        pc_op2 <= IMM_R;
    else if (isFollowed & isBranch)
        pc_op2 <= IMM_B;
    else
        pc_op2 <= 32'd4;
end

always @(*) begin : prograCounterNext
    if (enterTrap)
        pc_next <= i_MTVEC;
    else if (leaveTrap)
        pc_next <= i_MEPC;
    else
        pc_next <= pc_op1 + pc_op2;
end

always @(posedge i_CLK) begin : ProgramPointer
    if (~i_RSTn)
        pc  <= RESET_VECTOR;
    else if (i_EN && i_INSTRUCTION_VALID && (coreState != HALT))
        pc  <= pc_next;
end

assign o_PC = pc;


/* SIGNAL DECODE CONTROL */

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        o_ALU_OP  <= 2'b0;
        o_REG_WE  <= 1'b0;
        o_MEM_WE  <= 1'b0;
        o_MEM_RE  <= 1'b0;
        o_ECALL   <= 1'b0;
        o_IMM     <= 1'b0;
        o_JAL     <= 1'b0;
        o_LUI     <= 1'b0;
        o_AUIPC   <= 1'b0;
    end
    else if (i_EN) begin
        o_ALU_OP  <= {1'b0, isAluReg | isAluImm};
        o_REG_WE  <= isAluReg | isAluImm | isLoad | isJal | isJalr | isLui | isAuipc | isEcall;
        o_MEM_WE  <= isStore;
        o_MEM_RE  <= isLoad;
        o_ECALL   <= isEcall;
        o_IMM     <= isAluImm | isLoad | isStore | isJal | isJalr | isLui | isAuipc | isEcall;
        o_JAL     <= isJal | isJalr;
        o_LUI     <= isLui;
        o_AUIPC   <= isAuipc;
    end
end

always @(posedge i_CLK) begin
    if (i_EN) begin
        o_FUNCT3 <= funct3;
        o_FUNCT7 <= funct7;
    end
end

always @(posedge i_CLK) begin : OutRegs
    if (i_EN) begin
        o_PC_PIPELINE <= pc;
        o_INSTRUCTION <= instruction;
        o_RS1         <= rs1;
        o_RS2         <= rs2;
        o_RD_PTR      <= rd_ptr;
    end
end

always @(posedge i_CLK) begin
    if (i_EN) begin
        case (1'b1)
        isLui, isAuipc : 
            o_IMM_VAL <= IMM_U;
        isStore : 
            o_IMM_VAL <= IMM_S;
        isJal, isJalr :
            o_IMM_VAL <= 32'd4;
        isEcall :
            o_IMM_VAL <= IMM_CSR;
        default : 
            o_IMM_VAL <= ( (funct3 == 3'h5) || (funct3 == 3'h1) )? IMM_SFT : IMM_R;
        endcase
    end
end

endmodule