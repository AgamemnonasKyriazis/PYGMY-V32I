`timescale 1ns / 1ps

//`define TEST
`ifdef TEST
module ramio (
    input wire ce_ni,
    input wire we_ni,
    input wire oe_ni,

    input wire [31:0] addr_i,
    inout wire [7:0] data_io
);

reg [7:0] sram [0:1023];

integer i;
initial begin
    for (i = 0; i < 1024; i=i+1)
        sram[i] = 'hdc;
end

always@(posedge we_ni)
    if (~ce_ni)  
        sram[addr_i] <= data_io;

assign data_io = (~ce_ni & ~oe_ni)? sram[addr_i] : 8'hzz;

endmodule
`endif

module ram_controller(
    input wire clk_i,
    input wire rst_ni,
    input wire ce_i,
    input wire we_i,
    input wire req_i,
    input wire [7:0] wdata_i,
    input wire [31:0] addr_i,
    output wire [31:0] rdata_o,
    output wire gnt_o,
    output wire ce_no,
    output wire we_no,
    output wire oe_no,
    inout wire [7:0] data_io
);

localparam [1:0] IDLE = 2'b00;
localparam [1:0] SETD = 2'b01;
localparam [1:0] SETS = 2'b10;

reg [1:0] state;
reg [1:0] state_next;

assign ce_no = ~ce_i;
assign we_no = (state == SETD)? ~we_i : 1'b1;
assign oe_no = (state == SETD)?  we_i : 1'b0;

always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni)
        state <= IDLE;
    else
        state <= state_next;
end

always @(*) begin
    case (state)
    IDLE : state_next <= (ce_i & req_i)? SETD : IDLE;
    SETD : state_next <= SETS;
    SETS : state_next <= IDLE;
    endcase
end

assign data_io = (we_no)? 8'hzz : wdata_i;

assign gnt_o = (state == SETS) & ce_i & req_i;
assign rdata_o = data_io;

`ifdef TEST
ramio r0 (
    .ce_ni(ce_no),
    .we_ni(we_no),
    .oe_ni(oe_no),
    .addr_i(addr_i),
    .data_io(data_io)
);
`endif

endmodule