`timescale 1ns / 1ps

module regfile (
    input wire i_CLK,

    input wire i_WE,
    input wire [4:0] i_RD_PTR,
    input wire [31:0] i_RD,

    input wire [4:0] i_RS1_PTR,
    output wire [31:0] o_RS1,

    input wire [4:0] i_RS2_PTR,
    output wire [31:0] o_RS2
);

reg [31:0] registerArray [0:31];

integer i;
initial begin
    for (i = 0; i < 32; i=i+1)
        registerArray[i] <= 32'd0;
end

always @(negedge i_CLK) begin
    if ( (i_WE) & (|i_RD_PTR) )
        registerArray[i_RD_PTR] <= i_RD;
end

assign o_RS1 = registerArray[i_RS1_PTR];
assign o_RS2 = registerArray[i_RS2_PTR];

endmodule