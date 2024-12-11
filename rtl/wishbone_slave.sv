module wishbone_slave #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
) (
    input  i_RST,
    input  i_CLK,
    input  [ADDR_WIDTH-1:0] i_ADDR,
    input  [DATA_WIDTH-1:0] i_DATA,
    output logic [DATA_WIDTH-1:0] o_DATA,
    input  i_WE,
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

logic ram_ce;
logic [3:0] ram_we;
logic [ADDR_WIDTH-1:0] ram_addr;
logic [DATA_WIDTH-1:0] ram_wdata;
wire [DATA_WIDTH-1:0] ram_rdata;
wire ram_valid;

always_comb begin
    valid_cycle = i_CYC;
    valid_req = valid_cycle & i_STB;
    ack = 0;
    if (valid_cycle)
        ack = ram_valid;
end

always_comb begin
    o_ACK = ack;
    o_DATA = {DATA_WIDTH{1'b0}};
    if (ram_valid)
        o_DATA = ram_rdata;
end

always_comb begin
    ram_we = i_SEL & {4{i_WE}};
    ram_addr = i_ADDR;
    ram_wdata = i_DATA;
    ram_ce = valid_req & ~ack;
end

ram block_ram (
    .i_CE(ram_ce),
    .i_CLK(i_CLK),
    .i_WDATA(ram_wdata),
    .i_ADDR(ram_addr),
    .i_WE(ram_we),
    .o_RDATA(ram_rdata),
    .o_VALID(ram_valid)
);

endmodule