`timescale 1ns / 1ps

module decode(

    input wire clk_i,
    input wire rst_ni,

    /* program */
    input wire [31:0] program_instr_i,
    output reg [31:0] program_pointer_o,
    output reg core_state_o,

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

localparam INSTRUCTION_FETCH = 0;
localparam INSTRUCTION_EXECUTE = 1;

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

localparam [2:0] BEQ  = 3'h0;
localparam [2:0] BNE  = 3'h1;
localparam [2:0] BLT  = 3'h4;
localparam [2:0] BGE  = 3'h5;
localparam [2:0] BLTU = 3'h6;
localparam [2:0] BGEU = 3'h7;

localparam [6:0] ALU_REG    =   7'b0110011;
localparam [6:0] ALU_IMM    =   7'b0010011;
localparam [6:0] LOAD       =   7'b0000011;
localparam [6:0] STORE      =   7'b0100011;
localparam [6:0] BRANCH     =   7'b1100011;
localparam [6:0] JUMP       =   7'b1101111;
localparam [6:0] LUI        =   7'b0110111;
localparam [6:0] AUIPC      =   7'b0010111;

localparam [2:0] R_TYPE = 0;
localparam [2:0] I_TYPE = 1;
localparam [2:0] S_TYPE = 2;
localparam [2:0] B_TYPE = 3;
localparam [2:0] J_TYPE = 4;
localparam [2:0] U_TYPE = 5;

wire [31:0] instr;
reg [2:0] instr_type;
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

always @(*) begin : InstructionType
    case (instr_opcode)
    7'b0110011 : begin
        instr_type = R_TYPE;
    end
    7'b0010011, 7'b0000011, 7'b1100111 : begin
        instr_type = I_TYPE;
    end
    7'b0100011 : begin
        instr_type = S_TYPE;
    end
    7'b1100011 : begin
        instr_type = B_TYPE;
    end
    7'b1101111 : begin
        instr_type = J_TYPE;
    end
    7'b0110111, 7'b0010111 : begin
        instr_type = U_TYPE;
    end
    default : begin
        instr_type = R_TYPE;
    end
    endcase
end

always @(*) begin : AluControl
    case (instr_type)
    R_TYPE : begin
        case ({1'b0, funct3, 1'b0 ,funct7})
        12'h000 : alu_opcode = ADD;
        12'h020 : alu_opcode = SUB;
        12'h400 : alu_opcode = XOR;
        12'h600 : alu_opcode = OR;
        12'h700 : alu_opcode = AND;
        12'h100 : alu_opcode = SLL;
        12'h500 : alu_opcode = SRL;
        12'h520 : alu_opcode = SRA;
        12'h200 : alu_opcode = SLT;
        12'h300 : alu_opcode = SLTU;
        default : alu_opcode = ADD;
        endcase
    end
    I_TYPE : begin
        case (instr_opcode)
        7'b0010011 :
            case (funct3)
            'h0 : alu_opcode = ADD;
            'h4 : alu_opcode = XOR;
            'h6 : alu_opcode = OR;
            'h7 : alu_opcode = AND;
            'h1 : alu_opcode = SLL;
            'h5 : alu_opcode = (funct7 == 'h00)? SRL : (funct7 == 'h20)? SRA : 0;
            'h2 : alu_opcode = SLT;
            'h3 : alu_opcode = SLTU;
            default : alu_opcode = ADD;
            endcase
        default :
            alu_opcode = ADD;
        endcase
    end
    default : begin
        alu_opcode = ADD;
    end
    endcase
end

always @(*) begin : EvaluateBranch
    case ({instr_type})
    J_TYPE : branch_is_followed = 1'b1;
    B_TYPE :
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

assign instr = program_instr_i;
assign instr_opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

assign rs1_ptr = (instr_opcode == 7'b0110111)? 5'b0 : instr[19:15];
assign rs2_ptr = instr[24:20];

assign IMM_J = { {11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0 };
assign IMM_B = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };
assign IMM_U = { instr[31:12], 12'b0 };
assign IMM_R = { {20{instr[31]}}, instr[31:20] };
assign IMM_S = { {20{instr[31]}}, instr[31:25], instr[11:7] };
assign SHAMT = { 25'b0, instr[24:20] };

always @(posedge clk_i, negedge rst_ni) begin : ProgramPointer
    if (~rst_ni)
        program_pointer_o = 32'b0;
    else if (core_state_o == INSTRUCTION_EXECUTE)
        case (instr_type)
        J_TYPE : begin
            program_pointer_o = program_pointer_o + IMM_J;
        end
        B_TYPE : begin
            program_pointer_o = (branch_is_followed)? program_pointer_o + IMM_B : program_pointer_o + 32'd4;
        end
        default : begin
            program_pointer_o = program_pointer_o + 32'd4;
        end
        endcase
    else
        case (instr_type)
        J_TYPE : begin
            program_pointer_o = program_pointer_o + IMM_J;
        end
        B_TYPE : begin
            program_pointer_o = (branch_is_followed)? program_pointer_o + IMM_B : program_pointer_o + 32'd4;
        end
        default : begin
            program_pointer_o = program_pointer_o;
        end
        endcase
end

always @(posedge clk_i) begin : OperandSelector
    case (instr_type)
    R_TYPE : begin
        {imm_o, rs2_o, rs1_o} = {IMM_R, rs2, rs1};
    end
    I_TYPE : begin
        if ( (alu_opcode == SLL) || (alu_opcode == SRL) || (alu_opcode == SRA) )
            {imm_o, rs2_o, rs1_o} = {SHAMT, rs2, rs1};
        else
            {imm_o, rs2_o, rs1_o} = {IMM_R, rs2, rs1};
    end
    S_TYPE : begin
        {imm_o, rs2_o, rs1_o} = {IMM_S, rs2, rs1};
    end
    B_TYPE : begin
        {imm_o, rs2_o, rs1_o} = {IMM_B, rs2, rs1};
    end
    J_TYPE : begin
        {imm_o, rs2_o, rs1_o} = {program_pointer_o, rs2, 32'd4};
    end
    U_TYPE : begin
        if (instr_opcode == 7'b0110111)
            {imm_o, rs2_o, rs1_o} = {IMM_U, rs2, rs1};
        else
            {imm_o, rs2_o, rs1_o} = {IMM_U, rs2, program_pointer_o};
    end
    default : begin
        {imm_o, rs2_o, rs1_o} = {IMM_R, rs2, rs1};
    end
    endcase
end

always @(posedge clk_i, negedge rst_ni) begin : SignalControl
    if (~rst_ni) begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b00;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    else
    case (instr_type)
    R_TYPE : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b00;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    I_TYPE : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= ( instr_opcode == 7'b0000011 );
        
        if ( (funct3 == 3'h0) || (funct3 == 3'h4))
            hb_o  <= 2'b01;
        else if ( (funct3 == 3'h1) || (funct3 == 3'h5) )
            hb_o  <= 2'b10;
        else if (funct3 == 3'h2)
            hb_o  <= 2'b00;
        else
            hb_o  <= 2'bxx;
        
        ul_o      <= ( (funct3 == 3'h4) || (funct3 == 3'h5) );
        alu_src_o <= 1'b1;
    end
    S_TYPE : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b1;
        mem_re_o  <= 1'b0;

        if (funct3 == 3'h0)
            hb_o  <= 2'b01;
        else if (funct3 == 3'h1)
            hb_o  <= 2'b10;
        else if (funct3 == 3'h2)
            hb_o  <= 2'b00;
        else
            hb_o  <= 2'bxx;

        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    B_TYPE : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b00;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    J_TYPE : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b00;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    U_TYPE : begin
        reg_we_o  <= 1'b1;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b00;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b1;
    end
    default : begin
        reg_we_o  <= 1'b0;
        mem_we_o  <= 1'b0;
        mem_re_o  <= 1'b0;
        hb_o      <= 2'b00;
        ul_o      <= 1'b0;
        alu_src_o <= 1'b0;
    end
    endcase
end

always @(posedge clk_i) begin
    rd_ptr_o <= instr[11:7];
end

always @(posedge clk_i) begin
    alu_opcode_o <= alu_opcode;
end

always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni)
        core_state_o <= INSTRUCTION_FETCH;
    else if (core_state_o == INSTRUCTION_EXECUTE)
        core_state_o <= INSTRUCTION_FETCH;
    else
        case (instr_type)
        J_TYPE : begin
            core_state_o <= INSTRUCTION_FETCH;
        end
        B_TYPE : begin
            core_state_o <= INSTRUCTION_FETCH;
        end
        default : begin
            core_state_o <= INSTRUCTION_EXECUTE;
        end
        endcase
end

endmodule