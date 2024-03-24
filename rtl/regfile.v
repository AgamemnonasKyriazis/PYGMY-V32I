module regfile (
    input wire clk_i,
    input wire rst_ni,

    input wire reg_write_en_i,

    input wire [4:0] rs1_ptr_i,
    input wire [4:0] rs2_ptr_i,
    input wire [4:0] rd_ptr_i,

    input wire [31:0] rd_i,

    output wire [31:0] rs1_o,
    output wire [31:0] rs2_o
);

reg is_reg_zero;

reg [31:0] register_arr [0:31];

reg [31:0] rs1_nd;
reg [31:0] rs2_nd;

integer i;
always @(negedge clk_i, negedge rst_ni) begin
    if (~rst_ni)
        for (i = 0; i < 32; i=i+1)
            register_arr[i] = 32'b0;
    else if ( (reg_write_en_i == 1'b1) && (is_reg_zero == 1'b0) )
        register_arr[rd_ptr_i] <= rd_i;
end

always @(*) is_reg_zero = rd_ptr_i == 'b0;

assign rs1_o = register_arr[rs1_ptr_i];
assign rs2_o = register_arr[rs2_ptr_i];

endmodule