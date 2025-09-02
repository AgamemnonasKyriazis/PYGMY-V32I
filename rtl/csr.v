module csr #(
    parameter MXLEN = 32
) (
    input wire        i_CLK,
    input wire        i_RSTn,
    
    input wire [7:0]  i_CORE_STATE,

    input wire        i_CSR_FUNCT_EN,
    input wire [2:0]  i_CSR_FUNCT3,

    input wire [11:0] i_CSR_RD_PTR,
    input wire [31:0] i_CSR_RD,

    input wire [31:0] i_PC,
    input wire [31:0] i_INSTR,

    input wire i_MEI_0,
    input wire i_MEI_1,
    input wire i_MEI_2,
    input wire i_MEI_3,
    input wire i_MEI_4,
    input wire i_MEI_5,

    output wire [31:0] o_CSR_RD,

    output wire        o_IRQ,
    output wire [31:0] o_MTVEC,
    output wire [31:0] o_MEPC
);

`include "core.vh"
`include "control_status_registers.vh"

localparam [2:0] CSR_WRITE = 3'b001;
localparam [2:0] CSR_SET   = 3'b010;
localparam [2:0] CSR_CLEAR = 3'b011;

wire csrEn   = (i_CORE_STATE == CORE_STATE_EXEC || i_CORE_STATE == CORE_STATE_HALT); 

wire isWrite = (i_CSR_FUNCT3 == CSR_WRITE) & (i_CSR_FUNCT_EN);
wire isSet   = (i_CSR_FUNCT3 == CSR_SET)   & (i_CSR_FUNCT_EN);
wire isClear = (i_CSR_FUNCT3 == CSR_CLEAR) & (i_CSR_FUNCT_EN);

reg [MXLEN-1:0] mvendorid_0xf11;     /* vendor id */
reg [MXLEN-1:0] marchid_0xf12;       /* architecture id */
reg [MXLEN-1:0] mimpid_0xf13;        /* implementation id */
reg [MXLEN-1:0] mhartid_0xf14;       /* hardware thread id */

reg [MXLEN-1:0] mstatus_0x300;       /* machine status */
reg [MXLEN-1:0] misa_0x301;          /* ISA and extensions */
reg [MXLEN-1:0] mie_0x304;           /* interrupt-enable */
reg [MXLEN-1:0] mtvec_0x305;         /* trap-handler base address */

reg [MXLEN-1:0] mscratch_0x340;      /* scratch memory */
reg [MXLEN-1:0] mepc_0x341;          /* exception program counter */
reg [MXLEN-1:0] mcause_0x342;        /* trap cause */
reg [MXLEN-1:0] mtval_0x343;         /* trap value */
reg [MXLEN-1:0] mip_0x344;           /* interrupt pending */

reg [MXLEN-1:0] mcycle_0xB00;        /* cycles low 32-bit */
reg [MXLEN-1:0] mcycleh_0xB80;       /* cycles high 32-bit */


reg [31:0] csrRd;

reg [7:0] core_state;
reg [7:0] core_state_p;

always @(*) core_state = i_CORE_STATE;
always @(posedge i_CLK) core_state_p <= core_state;

wire [5:0] irq_vec = {
    i_MEI_5 & mie_0x304[5], 
    i_MEI_4 & mie_0x304[4], 
    i_MEI_3 & mie_0x304[3], 
    i_MEI_2 & mie_0x304[2], 
    i_MEI_1 & mie_0x304[1], 
    i_MEI_0 & mie_0x304[0]};

wire any_irq = |irq_vec;

wire irq = (~mcause_0x342[31] & any_irq);

integer i;
always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        mie_0x304       <= 32'd0;
        mtvec_0x305     <= 32'd0;
        mscratch_0x340  <= 32'd0;
    end
    else begin
        case (1'b1)
        isWrite : begin
            case (i_CSR_RD_PTR)
            MIE       : mie_0x304         <=  i_CSR_RD;
            MTVEC     : mtvec_0x305       <=  {i_CSR_RD[31:2], 2'b00};
            MSCRATCH  : mscratch_0x340    <=  i_CSR_RD;
            default   : ;
            endcase
        end
        isSet   : begin
            case (i_CSR_RD_PTR)
            MIE       : mie_0x304         <=  i_CSR_RD | mie_0x304;
            MTVEC     : mtvec_0x305       <=  i_CSR_RD | mtvec_0x305;
            MSCRATCH  : mscratch_0x340    <=  i_CSR_RD | mscratch_0x340;
            default   : ;
            endcase
        end
        isClear : begin
            case (i_CSR_RD_PTR)
            MIE       : mie_0x304         <=  ~i_CSR_RD & mie_0x304;
            MTVEC     : mtvec_0x305       <=  ~i_CSR_RD & mtvec_0x305;
            MSCRATCH  : mscratch_0x340    <=  ~i_CSR_RD & mscratch_0x340;
            default   : ;
            endcase
        end
        default : begin
            ;
        end
        endcase
    end
end    

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        mcycle_0xB00    <= 32'd0;
        mcycleh_0xB80   <= 32'd0;
    end
    else begin
        {mcycleh_0xB80, mcycle_0xB00} <= ({mcycleh_0xB80, mcycle_0xB00} + 64'd1);
    end
end

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        mcause_0x342  <= 32'd0;
    end
    else if (csrEn) begin
        mcause_0x342[5:0] <= irq_vec;
        mcause_0x342[31]  <= any_irq;
    end
end

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        mepc_0x341  <= 32'd0;
        mtval_0x343 <= 32'd0;
    end
    else if ( irq & csrEn ) begin
        mepc_0x341  <= {i_PC[31:2], 2'b00};
        mtval_0x343 <= i_INSTR;
    end
end

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        mstatus_0x300 <= 32'b00001000;
    end
    else begin
        if (core_state_p != CORE_STATE_TRAP && core_state == CORE_STATE_TRAP) begin
            mstatus_0x300[3] <= 1'b0;
            mstatus_0x300[7] <= mstatus_0x300[3];
        end
        else if (core_state_p == CORE_STATE_TRAP && core_state == CORE_STATE_EXEC) begin
            mstatus_0x300[3] <= mstatus_0x300[7];
            mstatus_0x300[7] <= 1'b0;
        end
    end
end

always @(*) begin
    case (i_CSR_RD_PTR)
    MVENDORID   : csrRd  <= mvendorid_0xf11;
    MARCHID     : csrRd  <= marchid_0xf12;
    MIMPID      : csrRd  <= mimpid_0xf13;
    MHARTID     : csrRd  <= mhartid_0xf14;

    MSTATUS     : csrRd  <= mstatus_0x300;
    MISA        : csrRd  <= misa_0x301;
    MIE         : csrRd  <= mie_0x304;
    MTVEC       : csrRd  <= mtvec_0x305;

    MSCRATCH    : csrRd  <= mscratch_0x340;
    MEPC        : csrRd  <= mepc_0x341;
    MCAUSE      : csrRd  <= mcause_0x342;
    MTVAL       : csrRd  <= mtval_0x343;
    MIP         : csrRd  <= mip_0x344;

    MCYCLE      : csrRd  <= mcycle_0xB00;
    MCYCLEH     : csrRd  <= mcycleh_0xB80;
    default     : csrRd  <= 32'b0;
    endcase
end

assign o_CSR_RD = csrRd;
assign o_IRQ = any_irq & mstatus_0x300[3];
assign o_MTVEC = mtvec_0x305;
assign o_MEPC = mepc_0x341;

endmodule