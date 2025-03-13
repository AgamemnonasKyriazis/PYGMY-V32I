module fetch (

    input   wire        i_CLK,
    input   wire        i_RSTn,
    input   wire        i_EN,

    input   wire [7:0]  i_CORE_STATE,

    input   wire        i_INSTRUCTION_GNT,
    input   wire [31:0] i_INSTRUCTION,
    
    input   wire        i_INSTRUCTION_FETCH_NEXT,
    output  wire        o_INSTRUCTION_REQ,
    output  wire [31:0] o_INSTRUCTION,
    output  wire        o_INSTRUCTION_VALID
);

localparam [31:0] NOOP  =  32'h00000013;

wire valid = o_INSTRUCTION_REQ & i_INSTRUCTION_GNT;

assign o_INSTRUCTION_REQ   = i_INSTRUCTION_FETCH_NEXT;
assign o_INSTRUCTION_VALID = valid;
assign o_INSTRUCTION       = valid? i_INSTRUCTION : NOOP;


endmodule