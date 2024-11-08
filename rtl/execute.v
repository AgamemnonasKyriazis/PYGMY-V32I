`timescale 1ns / 1ps

module execute (
    input  wire         i_CLK,
    input  wire         i_RSTn,
    
    input  wire         i_EN,

    input  wire [7:0]   i_CORE_STATE,

    input  wire [31:0]  i_PC,
    input  wire [31:0]  i_INSTRUCTION,

    input  wire [2:0]   i_FUNCT3,
    input  wire [6:0]   i_FUNCT7,
    
    input  wire [4:0]   i_RD_PTR,
    input  wire [31:0]  i_RS1,
    input  wire [31:0]  i_RS2,
    input  wire [31:0]  i_IMM_VAL,

    input  wire         i_REG_WE,
    input  wire         i_MEM_WE,
    input  wire         i_MEM_RE,
    input  wire         i_ECALL,
    input  wire         i_IMM,
    input  wire         i_JAL,
    input  wire         i_LUI,
    input  wire         i_AUIPC,

    /* WRITEBACK */
    output wire [31:0]  o_RD,
    output wire [4:0]   o_RD_PTR,
    output wire         o_REG_WE,

    /* BUS */
    input   wire [31:0] i_BUS_RDATA,
    output  wire [31:0] o_BUS_WDATA, 
    output  wire [31:0] o_BUS_ADDR,
    output  wire        o_BUS_WE,
    output  wire        o_BUS_RE,
    output  wire [1:0]  o_BUS_HB,
    output  wire        o_BUS_REQ,
    input   wire        i_BUS_GNT,

    /* EXTERNAL INTERRUPTS */
    input   wire i_MEI_0,
    input   wire i_MEI_1,
    input   wire i_MEI_2,
    input   wire i_MEI_3,
    input   wire i_MEI_4,
    input   wire i_MEI_5,

    /* IRQ */
    output wire        o_CSR_IRQ,
    /* TRAP HANDLER BASE ADDRESS */
    output wire [31:0] o_CSR_MTVEC,
    /* TRAP RETURN ADDRESS */
    output wire [31:0] o_CSR_MEPC
);

/*----------------------------------------- ALU -------------------------------------------*/
reg  [31:0] ALU_op1;
reg  [31:0] ALU_op2;
wire [31:0] ALU_res;
wire [3:0]  ALU_opcode = {i_FUNCT7[6], (i_MEM_RE | i_MEM_WE)? 3'b000 : i_FUNCT3};

always @(*) begin : Op1Selector
    case (1'b1)
    i_AUIPC, i_JAL : 
        ALU_op1 <= i_PC;
    i_LUI : 
        ALU_op1 <= 32'd0;
    default : 
        ALU_op1 <= i_RS1;
    endcase
end

always @(*) begin : Op2Selector
    case (1'b1)
    i_IMM   : ALU_op2 <= i_IMM_VAL;
    default : ALU_op2 <= i_RS2;
    endcase
end

alu ALU (
    .i_OP1(ALU_op1),
    .i_OP2(ALU_op2),
    .i_OPCODE(ALU_opcode),
    .o_RES(ALU_res)
);

/*----------------------------------- LOAD STORE UNIT -------------------------------------*/

wire [31:0] LSU_address = ALU_res;
wire [31:0] LSU_rdata;
wire [1:0]  hb = i_FUNCT3[1:0];
wire uload = i_FUNCT3[2];

lsu loadStoreUnit (
    /* CORE */
    .i_WDATA(i_RS2),
    .i_ADDR(LSU_address),
    .i_WE(i_MEM_WE),
    .i_RE(i_MEM_RE),
    .i_HB(hb),
    .i_ULOAD(uload),
    .o_RDATA(LSU_rdata),

    /* BUS */
    .i_BUS_RDATA(i_BUS_RDATA),
    .o_BUS_WDATA(o_BUS_WDATA), 
    .o_BUS_ADDR(o_BUS_ADDR),
    .o_BUS_WE(o_BUS_WE),
    .o_BUS_RE(o_BUS_RE),
    .o_BUS_HB(o_BUS_HB),
    .o_BUS_REQ(o_BUS_REQ),
    .i_BUS_GNT(i_BUS_GNT)
);

/*---------------------------- CONTROL STATUS REGISTERS -----------------------------------*/
wire [31:0] CSR_rd;
wire [11:0] CSR_rd_ptr = i_IMM_VAL[11:0];

csr controlStatusRegs (
    .i_CLK(i_CLK),
    .i_RSTn(i_RSTn),
    
    .i_CORE_STATE(i_CORE_STATE),
    
    .i_CSR_FUNCT_EN(i_ECALL),
    .i_CSR_FUNCT3(i_FUNCT3),
    .i_CSR_RD_PTR(CSR_rd_ptr),
    .i_CSR_RD(i_RS1),
    .i_PC(i_PC),
    .i_INSTR(i_INSTRUCTION),

    .i_MEI_0(i_MEI_0),
    .i_MEI_1(i_MEI_1),
    .i_MEI_2(i_MEI_2),
    .i_MEI_3(i_MEI_3),
    .i_MEI_4(i_MEI_4),
    .i_MEI_5(i_MEI_5),

    .o_CSR_RD(CSR_rd),
    .o_IRQ(o_CSR_IRQ),
    .o_MTVEC(o_CSR_MTVEC),
    .o_MEPC(o_CSR_MEPC)
);


reg [31:0] rd;
always @(*) begin
    case (1'b1)
    i_MEM_RE : rd <= LSU_rdata;
    i_ECALL  : rd <= CSR_rd;
    default  : rd <= ALU_res;
    endcase
end

assign o_RD = rd;
assign o_RD_PTR = i_RD_PTR;
assign o_REG_WE = i_REG_WE;

endmodule