module csr (
    input wire i_CLK,
    input wire i_RSTn,
    
    input wire        i_CSR_EN,
    input wire        i_CSR_FUNCT_EN,
    input wire [7:0]  i_CSR_FUNCT,
    input wire [31:0] i_CSR_OP1,
    input wire [31:0] i_CSR_OP2,

    input wire [31:0] i_PC,
    input wire [31:0] i_INSTR,
    input wire [63:0] i_MCYCLE,

    input wire i_MEI_0,
    input wire i_MEI_1,
    input wire i_MEI_2,
    input wire i_MEI_3,
    input wire i_MEI_4,
    input wire i_MEI_5,

    output reg [31:0] o_CSR_RD,
    output wire o_IRQ,
    output wire [31:0] o_IRQ_HANDLE_BASE,
    output wire [31:0] o_IRQ_EPC
);

localparam WRITE = 8'b00000001 << 3'b001;
localparam SET   = 8'b00000001 << 3'b010;
localparam CLEAR = 8'b00000001 << 3'b011;

wire isWrite = (i_CSR_FUNCT == WRITE);
wire isSet   = (i_CSR_FUNCT == SET);
wire isClear = (i_CSR_FUNCT == CLEAR);

reg [31:0] mie_0x304;                   // enable vector
reg [31:0] mtvec_0x305;                 // trap base address
reg [31:0] mscratch_0x340;              // scratch memory
reg [31:0] mepc_0x341;                  // pc that caused exception
reg [31:0] mcause_0x342;                // cause of trap
reg [31:0] mtval_0x343;                 // instruction that caused exception
reg [31:0] mcycleh_0xB80, mcycle_0xB00; // {cycles high 32-bit, cycles low 32-bit}

initial begin
    mie_0x304       = 32'd0;
    mtvec_0x305     = 32'd0;
    mscratch_0x340  = 32'd0;
    mepc_0x341      = 32'd0;
    mcause_0x342    = 32'd0;
    mtval_0x343     = 32'd0;
    mcycle_0xB00    = 32'd0;
    mcycleh_0xB80   = 32'd0;
end

wire [5:0] irq_vec = {
    i_MEI_5 & mie_0x304[5], 
    i_MEI_4 & mie_0x304[4], 
    i_MEI_3 & mie_0x304[3], 
    i_MEI_2 & mie_0x304[2], 
    i_MEI_1 & mie_0x304[1], 
    i_MEI_0 & mie_0x304[0]};

wire irq = |irq_vec;

integer i;
always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        mie_0x304       <= 32'd0;
        mtvec_0x305     <= 32'd0;
        mscratch_0x340  <= 32'd0;
        mepc_0x341      <= 32'd0;
        mcause_0x342    <= 32'd0;
        mtval_0x343     <= 32'd0;
        mcycle_0xB00    <= 32'd0;
        mcycleh_0xB80   <= 32'd0;
    end
    else if (i_CSR_FUNCT_EN) begin
        case (1'b1)
        isWrite : begin
            case (i_CSR_OP1)
            32'h304 : mie_0x304         <=  i_CSR_OP2;
            32'h305 : mtvec_0x305       <=  i_CSR_OP2;
            32'h340 : mscratch_0x340    <=  i_CSR_OP2;
            default : ;
            endcase
        end
        isSet   : begin
            case (i_CSR_OP1)
            32'h304 : mie_0x304         <=  i_CSR_OP2 | mie_0x304;
            32'h305 : mtvec_0x305       <=  i_CSR_OP2 | mtvec_0x305;
            32'h340 : mscratch_0x340    <=  i_CSR_OP2 | mscratch_0x340;
            default : ;
            endcase
        end
        isClear : begin
            case (i_CSR_OP1)
            32'h304 : mie_0x304         <=  ~i_CSR_OP2 & mie_0x304;
            32'h305 : mtvec_0x305       <=  ~i_CSR_OP2 & mtvec_0x305;
            32'h340 : mscratch_0x340    <=  ~i_CSR_OP2 & mscratch_0x340;
            default : ;
            endcase
        end
        default : begin

        end
        endcase
    end

    {mcycleh_0xB80, mcycle_0xB00} <= i_MCYCLE;

    if (i_CSR_EN) begin
        mcause_0x342[5:0] <= {i_MEI_5, i_MEI_4, i_MEI_3, i_MEI_2, i_MEI_1, i_MEI_0};
        mcause_0x342[31]  <= irq;
    end

    if ( ~mcause_0x342[31] & irq & i_CSR_EN ) begin
        mepc_0x341  <= i_PC;
        mtval_0x343 <= i_INSTR;
    end

end    

always @(*) begin
    case (i_CSR_OP1)
    32'h304 : o_CSR_RD  <= mie_0x304;
    32'h305 : o_CSR_RD  <= mtvec_0x305;
    32'h340 : o_CSR_RD  <= mscratch_0x340;
    32'h341 : o_CSR_RD  <= mepc_0x341;
    32'h342 : o_CSR_RD  <= mcause_0x342;
    32'h343 : o_CSR_RD  <= mtval_0x343;
    32'hB00 : o_CSR_RD  <= mcycle_0xB00;
    32'hB80 : o_CSR_RD  <= mcycleh_0xB80;
    default : o_CSR_RD  <= 32'b0;
    endcase
end

assign o_IRQ = irq;
assign o_IRQ_HANDLE_BASE = mtvec_0x305;
assign o_IRQ_EPC = mepc_0x341;

endmodule