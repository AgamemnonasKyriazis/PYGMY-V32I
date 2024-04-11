`timescale 1ns / 1ps

`define TEST
`ifdef TEST
module ramio (
    input wire ce_ni,
    input wire we_ni,
    input wire oe_ni,

    input wire [31:0] addr_i,
    inout wire [7:0] data_io
);

reg [7:0] sram [0:1024];

 always@(posedge we_ni)
    if (~ce_ni)  
        sram[addr_i] <= data_io;

assign data_io = (~ce_ni & ~oe_ni)? sram[addr_i] : 8'hzz;

endmodule
`endif

module ram_controller(
    input wire clk_i,
    input wire rst_ni,
    input wire core_state_i,

    input wire ce_i,
    input wire we_i,

    /* data bus */
    input wire [7:0] wdata_i,
    output reg [7:0] rdata_o,
    /* address bus */
    input wire [31:0] addr_i,

    output ce_no,
    output we_no,
    output oe_no,
    inout [7:0] data_io,
    output [31:0] addr_o,

    output reg stall_o
);

localparam BOOT   =   1'b0;
localparam RUN    =   1'b1;

localparam [1:0] IDLE = 2'b00;
localparam [1:0] RESET = 2'b10;

reg [1:0] state;
reg [1:0] state_next;

reg ce_no;
reg we_no;
reg oe_no;

wire [7:0] data_io = (~oe_no)? 8'hzz : data;

wire [31:0] addr_o = addr;

reg [7:0] data;
reg [31:0] addr;

always @(posedge clk_i) begin
    state <= (core_state_i == BOOT)? IDLE : state_next;
    case (state)
    IDLE : begin
        addr <= addr_i;
        data <= wdata_i;
        ce_no <= ~ce_i;
        oe_no <= we_i;
        we_no <= ~we_i;
    end
    RESET : begin
        we_no <= 1'b1;
    end
    endcase
end

always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni)
        stall_o <= 1'b0;
    else
        case (state)
        IDLE : stall_o <= 1'b0;
        RESET : stall_o <= 1'b1;
        endcase
end

always @(*) begin
    case (state)
    IDLE : begin
        state_next <= (ce_i)? RESET : IDLE;
    end
    RESET : begin
        state_next <= IDLE;
    end
    endcase
end

always @(*)
    rdata_o <= data_io;


`ifdef TEST
ramio r0 (
    .ce_ni(ce_no),
    .we_ni(we_no),
    .oe_ni(oe_no),

    .addr_i(addr_o),
    .data_io(data_io)
);
`endif

endmodule