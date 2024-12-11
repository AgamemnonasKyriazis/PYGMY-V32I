module ram #(
    parameter BYTE_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter SRAM_DEPTH = 1024,
    
    localparam N_COLS = DATA_WIDTH / BYTE_WIDTH
) (
    input i_CE,
    input i_CLK,
    input [DATA_WIDTH-1:0] i_WDATA,
    input [ADDR_WIDTH-1:0] i_ADDR,
    input [N_COLS-1:0] i_WE,
    
    output reg [DATA_WIDTH-1:0] o_RDATA,
    output reg o_VALID
);

(*ram_style = "block"*) reg [DATA_WIDTH-1:0] memory [0:SRAM_DEPTH-1];

initial begin
    integer i;
    for (i = 0; i < SRAM_DEPTH; i=i+1) begin
        memory[i] <= 0;
    end
end

generate
    genvar i;
    for (i = 0; i < N_COLS; i=i+1) begin
        always_ff @(posedge i_CLK) begin : MEMORY_WRITE
            if (i_CE & i_WE[i]) begin
                memory[i_ADDR][i*BYTE_WIDTH +: BYTE_WIDTH] <= i_WDATA[i*BYTE_WIDTH +: BYTE_WIDTH];
            end
        end
    end
endgenerate

always_ff @(posedge i_CLK) begin : MEMORY_READ
    o_RDATA <= 0;
    if (i_CE)
        o_RDATA <= memory[i_ADDR];
end

always_ff @(posedge i_CLK) begin
    o_VALID <= 1'b0;
    if (i_CE)
        o_VALID <= 1'b1;
end

endmodule