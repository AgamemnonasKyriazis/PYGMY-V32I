`timescale 1ns / 1ps

module decode(
    
    input  wire  [31:0]  i_MEPC,
    input  wire          i_IRQ,
    input  wire  [31:0]  i_HANDLER_BASE,

    /*-----------------------------------*/
    input wire          i_CLK,
    input wire          i_RSTn,

    input wire  [31:0]  i_INSTRUCTION,
    input wire          i_EN,
    
    input wire  [31:0]  i_RD,
    input wire  [4:0]   i_RD_PTR,
    input wire          i_REG_WE,

    output reg  [7:0]   o_FUNC3I,
    output reg  [6:0]   o_FUNCT7,
    output reg  [3:0]   o_ALU_OP1_SEL,
    output reg  [3:0]   o_ALU_OP2_SEL,
    output reg  [4:0]   o_RD_PTR,

    output reg  [31:0]  o_RS1,
    output reg  [31:0]  o_RS2,
    output reg  [31:0]  o_IMM,

    output wire         o_REG_WE,
    output wire         o_MEM_WE,
    output wire         o_MEM_RE,
    output wire [1:0]   o_HB,
    output wire         o_ULOAD,
    output wire         o_CSR,

    output wire [31:0]  o_PC,
    output reg  [31:0]  o_PC_PIPELINE,
    output reg  [31:0]  o_INSTRUCTION,

    output wire         o_MODE
    /*-----------------------------------*/
);

`include "Core.vh"
`include "Instruction_Set.vh"

wire [31:0] instruction = (enter_trap)? NOOP : i_INSTRUCTION;
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
wire isMret         = isEcall & (IMM_R == 32'h302);
wire isNoop         = (instruction == NOOP);

wire [2:0] funct3   = instruction[14:12];
wire [6:0] funct7   = instruction[31:25];
wire [7:0] funct3I  = 8'b00000001 << funct3;

wire signed [31:0] rs1;
wire signed [31:0] rs2;

wire [4:0] rd_ptr   = instruction[11:7];
wire [4:0] rs1_ptr  = instruction[19:15];
wire [4:0] rs2_ptr  = instruction[24:20];

regfile registers (
    .clk_i(i_CLK),
    .reg_write_en_i(i_REG_WE),
    .rs1_ptr_i(rs1_ptr),
    .rs2_ptr_i(rs2_ptr),
    .rd_ptr_i(i_RD_PTR),
    .rd_i(i_RD),
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
/* Branch is Followed */
wire isFollowed = 
    (isBranch & 
    (funct3I[0] & EQ) |
    (funct3I[1] & NE) |
    (funct3I[4] & LT) |
    (funct3I[5] & GT) |
    (funct3I[6] & LTU)|
    (funct3I[7] & GTU));

wire [31:0] IMM_J   = { {11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
wire [31:0] IMM_B   = { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
wire [31:0] IMM_U   = { instruction[31:12], 12'b0 };
wire [31:0] IMM_R   = { {20{instruction[31]}}, instruction[31:20] };
wire [31:0] IMM_S   = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
wire [31:0] SHAMT   = { 25'b0, instruction[24:20] };
wire [31:0] CSR     = { 20'b0, instruction[31:20] };

reg  [31:0] pc;
wire [31:0] pc_incr = (isJal)? IMM_J : (isFollowed & isBranch)? IMM_B : 32'd4;

assign o_PC = pc;

localparam USER     = 1'b0;
localparam MACHINE  = 1'b1;
reg mode;

assign o_MODE = mode;

wire enter_trap = i_IRQ && (mode == USER);
wire leave_trap = isEcall && (IMM_R == 32'h302) && (mode == MACHINE);
wire stall_here = ~i_EN;

always @(posedge i_CLK) begin : Mode
    if (~i_RSTn)
        mode <= USER;
    else if (stall_here)
        mode <= mode;
    else if (enter_trap)
        mode <= MACHINE;
    else if (leave_trap)
        mode <= USER;
    else
        mode <= mode;
end

always @(posedge i_CLK) begin : ProgramPointer
    if (~i_RSTn)
        pc  <= 32'd0;
    else if (stall_here)
        pc  <= pc;
    else if (enter_trap)
        pc  <= i_HANDLER_BASE;
    else if (leave_trap)
        pc  <= i_MEPC;
    else if (isJalr)
        pc  <= rs1 + IMM_R;
    else
        pc  <= pc + pc_incr;
end

reg         reg_we;
reg         mem_we;
reg         mem_re;
reg [1:0]   hb;
reg         uload;
reg         csr;

assign o_REG_WE = reg_we;
assign o_MEM_WE = mem_we;
assign o_MEM_RE = mem_re;
assign o_HB     = hb;
assign o_ULOAD  = uload;
assign o_CSR    = csr;

always @(posedge i_CLK) begin : SignalControl
    if (~i_RSTn) begin
        reg_we  <= 1'b0;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= 2'b00;
        uload   <= 1'b0;
        csr     <= 1'b0;
    end    
    else if (stall_here) begin
        reg_we  <= reg_we;
        mem_we  <= mem_we;
        mem_re  <= mem_re;
        hb      <= hb;
        uload   <= uload;
        csr     <= csr;
    end
    else if (enter_trap) begin
        reg_we  <= 1'b0;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= 2'b00;
        uload   <= 1'b0;
        csr     <= 1'b0;
    end
    else begin
    case (1'b1)
    isAluReg   : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isAluImm    : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isLoad      : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b1;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isStore     : begin
        reg_we  <= 1'b0;
        mem_we  <= 1'b1;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isBranch    : begin
        reg_we  <= 1'b0;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isJal       : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isJalr      : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isLui       : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isAuipc     : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b0;
    end
    isEcall     : begin
        reg_we  <= 1'b1;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= funct3[1:0];
        uload   <= funct3[2];
        csr     <= 1'b1;
    end
    default : begin
        reg_we  <= 1'b0;
        mem_we  <= 1'b0;
        mem_re  <= 1'b0;
        hb      <= 2'b00;
        uload   <= 1'b0;
        csr     <= 1'b0;
    end
    endcase
    end
end

always @(posedge i_CLK) begin : FunctALU
    if (~i_RSTn) begin
        o_FUNC3I            <= 8'b00000001;
        o_FUNCT7            <= 7'b0000000;
        o_ALU_OP1_SEL       <= 4'b0000;
        o_ALU_OP2_SEL       <= 4'b0000;
    end
    else if (stall_here) begin
        o_FUNC3I        <= o_FUNC3I; 
        o_FUNCT7        <= o_FUNCT7;
        o_ALU_OP1_SEL   <= o_ALU_OP1_SEL;
        o_ALU_OP2_SEL   <= o_ALU_OP2_SEL;
    end
    else if (enter_trap) begin
        o_FUNC3I            <= 8'b00000001;
        o_FUNCT7            <= 7'b0000000;
        o_ALU_OP1_SEL       <= 4'b0000;
        o_ALU_OP2_SEL       <= 4'b0000;
    end
    else begin
        o_FUNC3I        <= (isAluReg | isAluImm | isEcall)? funct3I : 8'b00000001;
        o_FUNCT7        <= (isAluReg)? funct7 : 7'b0000000;
        o_ALU_OP1_SEL   <= {1'b0, isLui, isJal|isJalr|isAuipc, ~(isLui|isJal|isJalr|isAuipc)};
        o_ALU_OP2_SEL   <= {1'b0, 1'b0, isAluImm|isLoad|isStore|isJal|isJalr|isLui|isAuipc, isAluReg};
    end
end

always @(posedge i_CLK) begin : OutRegs
    if (~i_RSTn) begin
        o_RS1           <= 32'd0;
        o_RS2           <= 32'd0;
        o_IMM           <= 32'd0;
        o_RD_PTR        <= 5'd0;
        o_PC_PIPELINE   <= 32'd0;
        o_INSTRUCTION   <= 32'd0;
    end
    else if (stall_here) begin
        o_PC_PIPELINE   <= o_PC_PIPELINE;
        o_INSTRUCTION   <= o_INSTRUCTION;
        o_RS1           <= o_RS1;
        o_RS2           <= o_RS2;
        o_RD_PTR        <= o_RD_PTR;
        o_IMM           <= o_IMM;
    end
    else if (enter_trap) begin
        o_PC_PIPELINE   <= o_PC_PIPELINE;
        o_INSTRUCTION   <= o_INSTRUCTION;
        o_RS1           <= 32'd0;
        o_RS2           <= 32'd0;
        o_RD_PTR        <= 5'd0;
        o_IMM           <= 32'd0;
    end
    else begin
        o_PC_PIPELINE   <= pc;
        o_INSTRUCTION   <= instruction;
        o_RS1 <= rs1;
        o_RS2 <= rs2;
        o_RD_PTR <= rd_ptr;
        case (1'b1)
        isLoad   : o_IMM <= IMM_R;
        isStore  : o_IMM <= IMM_S;
        isJal    : o_IMM <= 32'd4;
        isJalr   : o_IMM <= 32'd4;
        isLui    : o_IMM <= IMM_U;
        isAuipc  : o_IMM <= IMM_U;
        isEcall  : o_IMM <= CSR;
        default  : o_IMM <= IMM_R; 
        endcase
    end
end

endmodule