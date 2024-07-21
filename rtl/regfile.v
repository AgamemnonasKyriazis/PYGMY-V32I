`timescale 1ns / 1ps

module regfile (
    input wire clk_i,

    input wire reg_write_en_i,
    
    input wire [4:0] rd_ptr_i,
    input wire [31:0] rd_i,

    input wire [4:0] rs1_ptr_i,
    output wire [31:0] rs1_o,

    input wire [4:0] rs2_ptr_i,
    output wire [31:0] rs2_o
);

reg [31:0] register_arr [0:31];

integer i;
initial begin
    for (i = 0; i < 32; i=i+1)
        register_arr[i] <= 32'd0;
end

always @(negedge clk_i) begin
    if ( (reg_write_en_i) & (|rd_ptr_i) )
        register_arr[rd_ptr_i] <= rd_i;
end

assign rs1_o = register_arr[rs1_ptr_i];
assign rs2_o = register_arr[rs2_ptr_i];

endmodule