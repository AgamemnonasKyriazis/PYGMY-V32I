module fetch (

    input   wire        i_CLK,
    input   wire        i_RSTn,
    input   wire        i_EN,

    input   wire [7:0]  i_CORE_STATE,

    input   wire        i_INSTRUCTION_GNT,
    input   wire [31:0] i_INSTRUCTION,
    
    input   wire        i_INSTRUCTION_FETCH_NEXT,
    output  reg         o_INSTRUCTION_REQ,
    output  wire [31:0] o_INSTRUCTION,
    output  wire        o_INSTRUCTION_VALID
);

localparam [31:0] NOOP  =  32'h00000013;

wire valid  =  o_INSTRUCTION_REQ & i_INSTRUCTION_GNT;

/* While instruction is not valid - request */
always @(posedge i_CLK) begin
    if (~i_RSTn)
        o_INSTRUCTION_REQ <= 1'b1;
    else
        o_INSTRUCTION_REQ <= ~valid; // & ~fifo_full;
end

/*----------------------------- INSTRUCTION PREFETCH -----------------------------*/
/*
wire [31:0] fifo_out;
wire fifo_full;
wire fifo_empty;

sync_fifo #(
    .WIDTH(32),
    .DEPTH(16)
) instruction_fifo (
    .clk_i(i_CLK),
    .rst_ni(i_RSTn),
    .wdata_i(i_INSTRUCTION),
    .we_i(valid),
    .re_i(i_INSTRUCTION_FETCH_NEXT),
    .rdata_o(fifo_out),
    .full_o(fifo_full),
    .empty_o(fifo_empty)
);
*/
assign o_INSTRUCTION_VALID = valid; //~fifo_empty;
assign o_INSTRUCTION       = valid? i_INSTRUCTION : NOOP; // fifo_out
/*--------------------------------------------------------------------------------*/

endmodule