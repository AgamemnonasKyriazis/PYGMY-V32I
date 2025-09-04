`timescale 1ns / 1ps

module regfile #(
    parameter [31:0] HART_ID = 32'h00000000
) (
    input  logic i_CLK,

    input  logic i_WE,
    input  logic [4:0] i_RD_PTR,
    input  logic [31:0] i_RD,

    input  logic [4:0] i_RS1_PTR,
    output logic [31:0] o_RS1,

    input  logic [4:0] i_RS2_PTR,
    output logic [31:0] o_RS2
);

reg [31:0] registerArray [0:31];

logic we;
logic [31:0] rs1;
logic [31:0] rs2;
assign we = (i_WE) & (|i_RD_PTR); 

integer i;
initial begin
    for (i = 0; i < 32; i=i+1)
        registerArray[i] <= 32'd0;
end

always_ff @(posedge i_CLK) begin
    if ( we == 1'b1 ) begin
        registerArray[i_RD_PTR] <= i_RD;
    end
end

always_comb begin
    rs1 = 32'b0;
    rs2 = 32'b0;

    if ( |i_RS1_PTR ) begin
      rs1 = registerArray[i_RS1_PTR];
    end

    if ( |i_RS2_PTR ) begin
      rs2 = registerArray[i_RS2_PTR];
    end
    
    if ( (we == 1'b1) && (i_RD_PTR == i_RS1_PTR) ) begin
        rs1 = i_RD;
    end

    if ( (we == 1'b1) && (i_RD_PTR == i_RS2_PTR) ) begin
        rs2 = i_RD;
    end
end

assign o_RS1 = rs1;
assign o_RS2 = rs2;

always @(registerArray[2]) begin
    $strobe("[%0t] [HART::%0d] [StackPointer] sp=0x%0h", $time, HART_ID, registerArray[2]);
end

endmodule