module urom #(
    parameter BYTE_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter UROM_DEPTH = 1024,
    
    localparam N_COLS = DATA_WIDTH / BYTE_WIDTH
) (
    input i_CE,
    input i_CLK,

    input [ADDR_WIDTH-1:0] i_PC,
    output logic [DATA_WIDTH-1:0] o_INSTRUCTION,

    input [ADDR_WIDTH-1:0] i_ADDR,
    output reg [DATA_WIDTH-1:0] o_RDATA,
    output reg o_VALID
);

(*rom_style = "block"*) reg [DATA_WIDTH-1:0] memory [0:UROM_DEPTH-1];

initial begin
    $readmemh("../sw/image.hex", memory);
end

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

always_comb begin
    o_INSTRUCTION = memory[i_PC];
end

endmodule