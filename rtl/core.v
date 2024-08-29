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
    input   wire        i_MEI_5
);

localparam USER     = 1'b0;
localparam MACHINE  = 1'b1;

wire clk = i_CLK;
wire rstn = i_RSTn;

/* DECODE - EXECUTE STAGE */
wire [31:0] decode_program_pointer;
wire [31:0] decode_execute_program_pointer;
wire [31:0] decode_execute_imm;
wire [31:0] decode_execute_rs1;
wire [31:0] decode_execute_rs2;
wire [4:0]  decode_execute_rd_ptr;
wire [7:0]  decode_execute_funct3I;
wire [6:0]  decode_execute_funct7;
wire [3:0]  decode_execute_ALU_src1_ctrl;
wire [3:0]  decode_execute_ALU_src2_ctrl;
wire        decode_execute_reg_we;
wire        decode_execute_mem_we;
wire        decode_execute_mem_re;
wire [1:0]  decode_execute_mem_hb;
wire        decode_execute_mem_unsigned;
wire [31:0] decode_execute_instruction;
wire        decode_execute_csr;
wire        decode_core_mode;

/* EXECUTE - DECODE STAGE */
wire [31:0] execute_decode_rd;
wire [4:0]  execute_decode_rd_ptr;
wire        execute_decode_reg_we;

/* LOAD/STORE Unit - BUS */
wire [31:0] execute_lsu_addr;
wire [31:0] lsu_execute_rdata;

/*------------------------------------ DECODE --------------------------------------------*/

decode decodeUnit (
    .i_MEPC(csr_mepc),
    .i_IRQ(csr_irq),
    .i_HANDLER_BASE(csr_handle_base),

    .i_CLK(clk),
    .i_RSTn(rstn),
    .i_INSTRUCTION(i_INSTRUCTION),
    .i_EN(~stall),
    .i_RD(execute_decode_rd),
    .i_RD_PTR(execute_decode_rd_ptr),
    .i_REG_WE(execute_decode_reg_we),
    .o_FUNC3I(decode_execute_funct3I),
    .o_FUNCT7(decode_execute_funct7),
    .o_ALU_OP1_SEL(decode_execute_ALU_src1_ctrl),
    .o_ALU_OP2_SEL(decode_execute_ALU_src2_ctrl),
    .o_RD_PTR(decode_execute_rd_ptr),
    .o_RS1(decode_execute_rs1),
    .o_RS2(decode_execute_rs2),
    .o_IMM(decode_execute_imm),
    .o_REG_WE(decode_execute_reg_we),
    .o_MEM_WE(decode_execute_mem_we),
    .o_MEM_RE(decode_execute_mem_re),
    .o_HB(decode_execute_mem_hb),
    .o_ULOAD(decode_execute_mem_unsigned),
    .o_CSR(decode_execute_csr),
    .o_PC(decode_program_pointer),
    .o_PC_PIPELINE(decode_execute_program_pointer),
    .o_INSTRUCTION(decode_execute_instruction),
    .o_MODE(decode_core_mode)
);

/*-----------------------------------------------------------------------------------------*/

/*------------------------------------ EXECUTE --------------------------------------------*/

execute executeUnit (
    .i_CLK(clk),
    .i_RSTn(rstn),
    .i_EN(~stall),
    .i_FUNC3I(decode_execute_funct3I),
    .i_FUNCT7(decode_execute_funct7),
    .i_ALU_OP1_SEL(decode_execute_ALU_src1_ctrl),
    .i_ALU_OP2_SEL(decode_execute_ALU_src2_ctrl),
    .i_RD_PTR(decode_execute_rd_ptr),
    .i_RS1(decode_execute_rs1),
    .i_RS2(decode_execute_rs2),
    .i_IMM(decode_execute_imm),
    .i_REG_WE(decode_execute_reg_we),
    .i_MEM_WE(decode_execute_mem_we),
    .i_MEM_RE(decode_execute_mem_re),
    .i_HB(decode_execute_mem_hb),
    .i_ULOAD(decode_execute_mem_unsigned),
    .i_PC(decode_execute_program_pointer),
    .o_RD(execute_decode_rd),
    .o_RD_PTR(execute_decode_rd_ptr),
    .o_REG_WE(execute_decode_reg_we),
    .o_MEM_ADDR(execute_lsu_addr),
    .i_MEM_RDATA(lsu_execute_rdata),
    .i_CSR(decode_execute_csr),
    .i_CSR_RD(csr_rdata)
);

/*-----------------------------------------------------------------------------------------*/

/*-------------------------------- LOAD-STORE UNIT ----------------------------------------*/

lsu loadStoreUnit (
    /* CORE */
    .i_WDATA(decode_execute_rs2),
    .i_ADDR(execute_lsu_addr),
    .i_WE(decode_execute_mem_we),
    .i_RE(decode_execute_mem_re),
    .i_HB(decode_execute_mem_hb),
    .o_RDATA(lsu_execute_rdata),

    /* BUS */
    .i_BUS_RDATA(i_BUS_RDATA),
    .o_BUS_WDATA(o_BUS_WDATA), 
    .o_BUS_ADDR(o_BUS_ADDR),
    .o_BUS_WE(o_BUS_WE),
    .o_BUS_RE(o_BUS_RE),
    .o_BUS_HB(o_BUS_HB),
    .o_BUS_CE(o_BUS_CE),
    .o_BUS_REQ(o_BUS_REQ),
    .i_BUS_GNT(i_BUS_GNT)
);

wire stall = ( (|o_BUS_CE[3:0]) & (o_BUS_REQ) & (~i_BUS_GNT) );

assign o_PC = decode_program_pointer;

/*-----------------------------------------------------------------------------------------*/

/*---------------------------- CONTROL-STATUS REGISTERS -----------------------------------*/
wire [31:0] csr_rdata;
wire        csr_irq;
wire [31:0] csr_handle_base;
wire [31:0] csr_mepc;

reg  [63:0] cycles;

csr controlStatusRegs (
    .i_CLK(i_CLK),
    .i_RSTn(i_RSTn),
    
    .i_CSR_EN( (decode_core_mode == USER) ),
    
    .i_CSR_FUNCT_EN(decode_execute_csr),
    .i_CSR_FUNCT(decode_execute_funct3I),
    .i_CSR_OP1(decode_execute_imm),
    .i_CSR_OP2(decode_execute_rs1),
    .i_PC(decode_execute_program_pointer),
    .i_INSTR(decode_execute_instruction),
    .i_MCYCLE(cycles),

    .i_MEI_0(i_MEI_0),
    .i_MEI_1(i_MEI_1),
    .i_MEI_2(i_MEI_2),
    .i_MEI_3(i_MEI_3),
    .i_MEI_4(i_MEI_4),
    .i_MEI_5(i_MEI_5),

    .o_CSR_RD(csr_rdata),
    .o_IRQ(csr_irq),
    .o_IRQ_HANDLE_BASE(csr_handle_base),
    .o_IRQ_EPC(csr_mepc)
);

always @(posedge i_CLK) 
    if (~i_RSTn)
        cycles <= 64'd0;
    else
        cycles <= cycles + 1'b1;
/*-----------------------------------------------------------------------------------------*/

endmodule