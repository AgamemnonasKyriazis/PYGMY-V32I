`timescale 1ns / 1ps

module regfile (
    input  logic i_CLK,

    input  logic i_WE,
    input  logic [4:0] i_RD_PTR,
    input  logic [31:0] i_RD,

    input  logic [4:0] i_RS1_PTR,
    output logic [31:0] o_RS1,

    input  logic [4:0] i_RS2_PTR,
    output logic [31:0] o_RS2
);

typedef enum {
    zero = 0,
    ra   = 1,
    sp   = 2,
    gp   = 3,
    tp   = 4,
    t0   = 5,
    t1   = 6,
    t2   = 7,
    s0   = 8,
    s1   = 9,
    a0   = 10,
    a1   = 11,
    a2   = 12,
    a3   = 13,
    a4   = 14,
    a5   = 15,
    a6   = 16,
    a7   = 17,
    s2   = 18,
    s3   = 19,
    s4   = 20,
    s5   = 21,
    s6   = 22,
    s7   = 23,
    s8   = 24,
    s9   = 25,
    s10  = 26,
    s11  = 27,
    t3   = 28,
    t4   = 29,
    t5   = 30,
    t6   = 31
} register_t;

reg [31:0] registerArray [0:31];

register_t rd_ptr;
register_t rs1_ptr;
register_t rs2_ptr;

assign rd_ptr = register_t'(i_RD_PTR);

integer i;
initial begin
    for (i = 0; i < 32; i=i+1)
        registerArray[i] <= 32'd0;
end

always_ff @(negedge i_CLK) begin
    if ( (i_WE) & (|i_RD_PTR) ) begin
        registerArray[i_RD_PTR] <= i_RD;
    end
end

assign o_RS1 = registerArray[i_RS1_PTR];
assign o_RS2 = registerArray[i_RS2_PTR];

endmodule