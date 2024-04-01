`timescale 1ns / 1ps

module decode(

    input wire clk_i,
    input wire rst_ni,

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
    output reg [3:0] alu_opcode_o,
    output reg alu_src_o,

    /* WE/RE control */
    output reg reg_we_o,
    output reg mem_we_o,
    output reg mem_re_o,
    output reg [1:0] hb_o,
    output reg ul_o
);

localparam [1:0] FETCH      =   2'b01;
localparam [1:0] DEC        =   2'b10;
localparam [1:0] EXEC       =   2'b11;

localparam [6:0] ALU_R      =   7'b0110011;
localparam [6:0] ALU_I      =   7'b0010011;
localparam [6:0] LOAD       =   7'b0000011;
localparam [6:0] STORE      =   7'b0100011;
localparam [6:0] BRANCH     =   7'b1100011;
localparam [6:0] JUMP       =   7'b1101111;
localparam [6:0] LUI        =   7'b0110111;
localparam [6:0] AUIPC      =   7'b0010111;

localparam [3:0] ADD    =   4'b0000;
localparam [3:0] SUB    =   4'b1000;
localparam [3:0] XOR    =   4'b0100;
localparam [3:0] OR     =   4'b0110;
localparam [3:0] AND    =   4'b0111;
localparam [3:0] SLL    =   4'b0001;
localparam [3:0] SRL    =   4'b0101;
localparam [3:0] SRA    =   4'b1010;
localparam [3:0] SLT    =   4'b0010;
localparam [3:0] SLTU   =   4'b0011;

localparam [2:0] BEQ  = 3'b000;
localparam [2:0] BNE  = 3'b001;
localparam [2:0] BLT  = 3'b100;
localparam [2:0] BGE  = 3'b101;
localparam [2:0] BLTU = 3'b110;
localparam [2:0] BGEU = 3'b111;

reg [1:0] core_state;
reg [31:0] instr;
reg [31:0] program_pointer;
reg [31:0] program_pointer_incr;

wire [6:0] instr_opcode;
wire [2:0] funct3;
wire [6:0] funct7;
reg [3:0] alu_opcode;

wire [31:0] IMM_J;
wire [31:0] IMM_B;
wire [31:0] IMM_U;
wire [31:0] IMM_R;
wire [31:0] IMM_S;
wire [31:0] SHAMT;

reg branch_is_followed;

wire [4:0] rs1_ptr;
wire [4:0] rs2_ptr;

wire signed [31:0] rs1;
wire signed [31:0] rs2;

regfile registers (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .reg_write_en_i(reg_we_i),
    .rs1_ptr_i(rs1_ptr),
    .rs2_ptr_i(rs2_ptr),
    .rd_ptr_i(rd_ptr_i),
    .rd_i(rd_i),
    .rs1_o(rs1),
    .rs2_o(rs2)
);

always @(*) begin
    if (core_state == EXEC)
        instr = rd_i;
    else
        instr = 32'd0;
end

always @(*) begin : AluControl
    case (instr_opcode)
    ALU_R : begin
        alu_opcode = {funct7[5], funct3};
    end
    ALU_I : begin
        alu_opcode = (funct3 == 3'h5)? {funct7[5], funct3} : {1'b0, funct3};
    end
    default : begin
        alu_opcode = ADD;
    end
    endcase
end

always @(*) begin : EvaluateBranch
    case ({instr_opcode})
    JUMP : branch_is_followed = 1'b1;
    BRANCH :
        case (funct3)
        BEQ  : branch_is_followed = rs1 == rs2;
        BNE  : branch_is_followed = rs1 != rs2;
        BLT  : branch_is_followed = rs1 < rs2;
        BGE  : branch_is_followed = rs1 >= rs2;
        BLTU : branch_is_followed = $unsigned(rs1) < $unsigned(rs2);
        BGEU : branch_is_followed = $unsigned(rs1) >= $unsigned(rs2);
        default: branch_is_followed = 1'b0;
        endcase
    default : branch_is_followed = 1'b0;
    endcase
end

always @(*) begin
    case (instr_opcode)
    JUMP    :   program_pointer_incr = IMM_J;
    BRANCH  :   program_pointer_incr = (branch_is_followed)? IMM_B : 32'd4;
    default :   program_pointer_incr = 32'd4;
    endcase
end

assign instr_opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

assign rs1_ptr = instr[19:15];
assign rs2_ptr = instr[24:20];

assign IMM_J = { {11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0 };
assign IMM_B = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
assign IMM_U = { instr[31:12], 12'b0 };
assign IMM_R = { {20{instr[31]}}, instr[31:20] };
assign IMM_S = { {20{instr[31]}}, instr[31:25], instr[11:7] };
assign SHAMT = { 25'b0, instr[24:20] };

always @(posedge clk_i, negedge rst_ni) begin : ProgramPointer
    if (~rst_ni)
        program_pointer = 32'b0;
    else if (core_state == EXEC)
        program_pointer = program_pointer + program_pointer_incr;
    else
        program_pointer = program_pointer;
end

always @(posedge clk_i, negedge rst_ni) begin : SignalControl
    if (~rst_ni) begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b10;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    else if (core_state == FETCH) begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b1;
        hb_o      <= 2'b10;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    else begin
    case (instr_opcode)
    ALU_R : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= funct3[1:0];
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    ALU_I : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= funct3[1:0];
        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    LOAD : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b1;
        hb_o      <= funct3[1:0];
        ul_o      <= funct3[2];
        alu_src_o <= 1'b1;
    end
    STORE : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b1;
        mem_re_o  <= 1'b0;
        hb_o      <= funct3[1:0];
        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    BRANCH : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b10;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    JUMP : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b10;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    LUI : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= funct3[1:0];
        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    AUIPC : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= funct3[1:0];
        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    default : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b10;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    endcase
    end
end

always @(posedge clk_i) begin : ImmSelector
    if (core_state == FETCH)
        imm_o = 32'd0;
    else
        case (instr_opcode)
        ALU_I   :   
            case (alu_opcode)
            SLL, SRL, SRA : imm_o = SHAMT;
            default : imm_o = IMM_R;
            endcase
        LOAD    :   imm_o = IMM_R;
        STORE   :   imm_o = IMM_S;
        JUMP    :   imm_o = 32'd4;
        LUI     :   imm_o = IMM_U;
        AUIPC   :   imm_o = IMM_U;
        default :   imm_o = 32'd0;
        endcase
end

always @(posedge clk_i) begin : Op1Selector
    if (core_state == FETCH)
        rs1_o = program_pointer;
    else
        case (instr_opcode)
        JUMP    :   rs1_o = program_pointer;
        AUIPC   :   rs1_o = program_pointer;
        LUI     :   rs1_o = 32'd0;
        default :   rs1_o = rs1;
        endcase
end

always @(posedge clk_i) begin : Op2Selector
    rs2_o = rs2;
end

always @(posedge clk_i) begin
    rd_ptr_o <= instr[11:7];
end

always @(posedge clk_i) begin
    alu_opcode_o <= alu_opcode;
end

always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni)
        core_state = FETCH;
    else
        case (core_state)
        FETCH : core_state <= EXEC;
        EXEC  : core_state <= FETCH;
        default : core_state <= FETCH;
        endcase
end

endmodule