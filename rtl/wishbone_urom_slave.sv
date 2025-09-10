module wishbone_urom_slave #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
) (
    input  i_RST,
    input  i_CLK,

    input  [ADDR_WIDTH-1:0] i_PC_0,
    output logic [DATA_WIDTH-1:0] o_INSTRUCTION_0,

    input  [ADDR_WIDTH-1:0] i_PC_1,
    output logic [DATA_WIDTH-1:0] o_INSTRUCTION_1,

    input  [ADDR_WIDTH-1:0] i_ADDR,
    output logic [DATA_WIDTH-1:0] o_DATA,
    input  [3:0] i_SEL,
    input  i_STB,
    output logic o_ACK,
    input  i_CYC,
    input  i_TAGN,
    output o_TAGN
);

logic valid_cycle;
logic valid_req;
logic ack;

logic rom_ce;
logic [ADDR_WIDTH-1:0] rom_addr;
wire [DATA_WIDTH-1:0] rom_rdata;
wire rom_valid;

always_comb begin
    valid_cycle = i_CYC;
    valid_req = valid_cycle & i_STB;
    ack = 0;
    if (valid_req)
        ack = rom_valid;
end


always_comb begin
    o_ACK = ack;
    o_DATA = {DATA_WIDTH{1'b0}};
    if (rom_valid)
        o_DATA = rom_rdata;
end


always_comb begin
    rom_ce = valid_req & ~ack;
    rom_addr = i_ADDR >> 2;
end

urom #(
    .UROM_DEPTH(4096)
) block_rom (
    .i_CE(rom_ce),
    .i_CLK(i_CLK),
    .i_PC_0(i_PC_0),
    .o_INSTRUCTION_0(o_INSTRUCTION_0),
    .i_PC_1(i_PC_1),
    .o_INSTRUCTION_1(o_INSTRUCTION_1), 
    .i_ADDR(rom_addr),
    .o_RDATA(rom_rdata),
    .o_VALID(rom_valid)
);
endmodule