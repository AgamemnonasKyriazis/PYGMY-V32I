`timescale 1ns / 1ps

module top_tb();

reg clk, rst;

reg [9:0] uart_tx_buf;

localparam BAUD_9600    = 1250;

wire [7:0] data = 8'h61;

integer i;
integer fout_pointer;
initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);
    rst <= 1;
    clk <= 0;
    uart_tx_buf <= {data, 1'b0, 1'b1};
    #83
    rst <= 0;

   #100000000
    
    fout_pointer = $fopen("memdump","w");
    for (i = 0; i < sys0.sram_slave_0.block_ram.SRAM_DEPTH; i+=1)
        $fwrite(fout_pointer, "%x\t%x\t%c%c%c%c\n", i<<2, sys0.sram_slave_0.block_ram.memory[i], sys0.sram_slave_0.block_ram.memory[i][7:0], sys0.sram_slave_0.block_ram.memory[i][15:8], sys0.sram_slave_0.block_ram.memory[i][23:16], sys0.sram_slave_0.block_ram.memory[i][31:24]);
    $fclose(fout_pointer);
    
    fout_pointer = $fopen("romdump","w");
    for (i = 0; i < sys0.urom_slave_0.block_rom.UROM_DEPTH; i+=1)
        $fwrite(fout_pointer, "%x\t%x\t%c%c%c%c\n", i<<2, sys0.urom_slave_0.block_rom.memory[i], sys0.urom_slave_0.block_rom.memory[i][7:0], sys0.urom_slave_0.block_rom.memory[i][15:8], sys0.urom_slave_0.block_rom.memory[i][23:16], sys0.urom_slave_0.block_rom.memory[i][31:24]);
    $fclose(fout_pointer);

    $finish;
end

always #83 clk = ~clk;

reg [31:0] tx_tick_count;
reg tx_clk;

always @(posedge clk, posedge rst) begin
    if (rst == 1) begin
        tx_tick_count <= 'b0;
        tx_clk <= 'b0;
    end
    else begin
        tx_tick_count <= (tx_clk)? 'b0 : tx_tick_count + 'b1;
        tx_clk <= tx_tick_count == (BAUD_9600 - 'b1);
    end
end

always @(posedge clk)
if (tx_clk)
    if (uart_tx_buf == 10'h3ff)
        uart_tx_buf <= uart_tx_buf;//{data, 1'b0, 1'b1};
    else
        uart_tx_buf <= {1'b1, uart_tx_buf[9:1]};


system sys0 (
    .i_CLK(clk),
    .i_RST(rst),
    .i_UART_TXD(uart_tx_buf[0]),
    .o_UART_RXD(),
    .o_GPIO_0(),
    .o_GPIO_1()
);

endmodule
