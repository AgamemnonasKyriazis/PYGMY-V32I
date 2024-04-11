`timescale 1ns / 1ps

module top_tb();

reg clk, rst_n;

integer i;
initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);
    rst_n <= 1;
    clk <= 0;
    #1
    rst_n <= 0;
    #10000000
    $finish;
end

always #20 clk = ~clk;

top u0 (
    .sysclk(clk),
    .rst(rst_n)
);

endmodule