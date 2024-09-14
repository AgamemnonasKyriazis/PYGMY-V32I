module core (
    input   wire        i_CLK,
    input   wire        i_RSTn,
    input   wire [31:0] i_INSTRUCTION,
    input   wire [31:0] i_BUS_RDATA,
    input   wire        i_BUS_GNT,
    output  wire [31:0] o_PC,
    output  wire [31:0] o_BUS_WDATA,
    output  wire [31:0] o_BUS_ADDR,
    output  wire        o_BUS_WE,
    output  wire        o_BUS_RE,
    output  wire [1:0]  o_BUS_HB,
    output  wire        o_BUS_REQ,
    output  wire [7:0]  o_BUS_CE,

    input   wire        i_MEI_0,
    input   wire        i_MEI_1,
    input   wire        i_MEI_2,
    input   wire        i_MEI_3,
    input   wire        i_MEI_4,
    input   wire        i_MEI_5,

    input   wire        i_INSTR_GNT,
    output  reg         o_INSTR_REQ
);

`include "Core.vh"
`include "Instruction_Set.vh"

/*------------------------------------ CONTROL UNIT ---------------------------------------*/
wire [7:0]  coreState;

/*---------------------------------- INSTRUCTION FETCH ------------------------------------*/
wire [31:0] instruction = i_INSTRUCTION;
wire [31:0] pc;

/*------------------------------ DECODE - EXECUTE STAGE -----------------------------------*/
wire [31:0] decode_execute_pc;
wire [31:0] decode_execute_instruction;

wire [31:0] decode_execute_rs1;
wire [31:0] decode_execute_rs2;
wire [31:0] decode_execute_imm_val;
wire [4:0]  decode_execute_rd_ptr;

wire [2:0]  decode_execute_funct3;
wire [6:0]  decode_execute_funct7;

wire        decode_execute_reg_we;
wire        decode_execute_mem_we;
wire        decode_execute_mem_re;
wire        decode_execute_ecall;
wire        decode_execute_imm;
wire        decode_execute_jal;
wire        decode_execute_lui;
wire        decode_execute_auipc;

/*------------------------ EXECUTE - WRITEBACK - DECODE STAGE -----------------------------*/
wire [31:0] rd;
wire [4:0]  rd_ptr;
wire        reg_we;

/*---------------------------- CONTROL STATUS REGISTERS -----------------------------------*/
wire        csr_irq;
wire [31:0] csr_mtvec;
wire [31:0] csr_mepc;

/*------------------------------------ DECODE ---------------------------------------------*/
wire en_decode = ~( (|o_BUS_CE[3:0]) & (o_BUS_REQ) & (~i_BUS_GNT) );
wire en_execute;

always @(posedge i_CLK) begin
    if (~i_RSTn)
        o_INSTR_REQ <= 1'b1;
    else begin
        if (instruction_is_valid)
            o_INSTR_REQ <= 1'b0;
        else
            o_INSTR_REQ <= 1'b1;
    end
end
wire instruction_is_valid = i_INSTR_GNT & o_INSTR_REQ;

decode decodeUnit (
    .i_CLK(i_CLK),
    .i_RSTn(i_RSTn),

    .i_EN(en_decode),

    .i_IRQ(csr_irq),
    .o_CORE_STATE(coreState),

    .i_INSTRUCTION_VALID(instruction_is_valid),
    .i_INSTRUCTION(instruction),
    .i_MTVEC(csr_mtvec),
    .i_MEPC(csr_mepc),

    .i_RD(rd),
    .i_RD_PTR(rd_ptr),
    .i_REG_WE(reg_we),
    
    .o_FUNCT3(decode_execute_funct3),
    .o_FUNCT7(decode_execute_funct7),
    .o_RD_PTR(decode_execute_rd_ptr),
    
    .o_RS1(decode_execute_rs1),
    .o_RS2(decode_execute_rs2),
    .o_IMM_VAL(decode_execute_imm_val),

    .o_REG_WE(decode_execute_reg_we),
    .o_MEM_WE(decode_execute_mem_we),
    .o_MEM_RE(decode_execute_mem_re),
    .o_ECALL(decode_execute_ecall),
    .o_IMM(decode_execute_imm),
    .o_JAL(decode_execute_jal),
    .o_LUI(decode_execute_lui),
    .o_AUIPC(decode_execute_auipc),
        
    .o_PC(pc),
    .o_PC_PIPELINE(decode_execute_pc),
    .o_INSTRUCTION(decode_execute_instruction)
);

/*-----------------------------------------------------------------------------------------*/

/*------------------------------------ EXECUTE --------------------------------------------*/

execute executeUnit (
    .i_CLK(i_CLK),
    .i_RSTn(i_RSTn),

    .i_EN(~stall_execute),

    .i_CORE_STATE(coreState),

    .i_PC(decode_execute_pc),
    .i_INSTRUCTION(decode_execute_instruction),

    .i_FUNCT3(decode_execute_funct3),
    .i_FUNCT7(decode_execute_funct7),
    
    .i_RD_PTR(decode_execute_rd_ptr),
    .i_RS1(decode_execute_rs1),
    .i_RS2(decode_execute_rs2),
    .i_IMM_VAL(decode_execute_imm_val),
    
    /* CTRL */
    .i_REG_WE(decode_execute_reg_we),
    .i_MEM_WE(decode_execute_mem_we),
    .i_MEM_RE(decode_execute_mem_re),
    .i_ECALL(decode_execute_ecall),
    .i_IMM(decode_execute_imm),
    .i_JAL(decode_execute_jal),
    .i_LUI(decode_execute_lui),
    .i_AUIPC(decode_execute_auipc),

    /* WRITEBACK */
    .o_RD(rd),
    .o_RD_PTR(rd_ptr),
    .o_REG_WE(reg_we),

    /* BUS */
    .i_BUS_RDATA(i_BUS_RDATA),
    .o_BUS_WDATA(o_BUS_WDATA), 
    .o_BUS_ADDR(o_BUS_ADDR),
    .o_BUS_WE(o_BUS_WE),
    .o_BUS_RE(o_BUS_RE),
    .o_BUS_HB(o_BUS_HB),
    .o_BUS_CE(o_BUS_CE),
    .o_BUS_REQ(o_BUS_REQ),
    .i_BUS_GNT(i_BUS_GNT),

    /* EXTERNAL INTERRUPTS */
    .i_MEI_0(i_MEI_0),
    .i_MEI_1(i_MEI_1),
    .i_MEI_2(i_MEI_2),
    .i_MEI_3(i_MEI_3),
    .i_MEI_4(i_MEI_4),
    .i_MEI_5(i_MEI_5),

    /* IRQ */
    .o_CSR_IRQ(csr_irq),
    /* TRAP HANDLER BASE ADDRESS */
    .o_CSR_MTVEC(csr_mtvec),
    /* TRAP RETURN ADDRESS */
    .o_CSR_MEPC(csr_mepc)
);

/*-----------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------*/
assign o_PC = pc;

endmodule