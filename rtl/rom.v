`timescale 1ns / 1ps

module rom #(
    parameter SIZE = 2*1024
) (
    input  wire         i_CLK,
    input  wire         i_RSTn,
    input  wire         i_CE,
    input  wire [1:0]   i_HB,
    input  wire         i_REQ,
    input  wire [31:0]  i_ADDR_DATA,
    input  wire [31:0]  i_ADDR_INSTR,
    output wire [31:0]  o_RDATA_DATA,
    output wire [31:0]  o_RDATA_INSTR,
    output wire         o_GNT,

    input  wire         i_INSTR_REQ,
    output reg          o_INSTR_GNT
);

(* rom_style = "block" *) reg [31:0] rom [0:SIZE-1];

initial begin
    $readmemh("../sw/image.hex", rom);
end

wire [31:0] addr_1 = i_ADDR_DATA >> 2;
wire [31:0] addr_2 = i_ADDR_INSTR >> 2;

wire [31:0] data  = rom[addr_1];
wire [31:0] instr = rom[addr_2];

reg  [31:0] instr_d;
reg  [31:0] instr_q;

reg  [31:0] rdata_d;
reg  [31:0] rdata_q;
reg         data_gnt;

always @(*) begin
    case (i_HB)
    2'b00 : begin
    case (i_ADDR_DATA[1:0])
    2'b01   : rdata_d <= { {24{data[15]}}, data[15:8] };
    2'b10   : rdata_d <= { {24{data[23]}}, data[23:16] };
    2'b11   : rdata_d <= { {24{data[31]}}, data[31:24] };
    default : rdata_d <= { {24{data[7]}}, data[7:0] };
    endcase
    end
    2'b01 : begin
    case (i_ADDR_DATA[1:0])
    2'b10   : rdata_d <= { {16{data[31]}}, data[31:16] };
    default : rdata_d <= { {16{data[15]}}, data[15:0]};
    endcase
    end
    default : rdata_d <= data;
    endcase
end

always @(posedge i_CLK) begin
    if (i_CE)
        rdata_q <= rdata_d;
    else
        rdata_q <= 32'd0;
end

always @(posedge i_CLK) begin
    if (~i_RSTn)
        data_gnt <= 1'b0;
    else
        data_gnt <= i_REQ & i_CE & ~data_gnt;
end

always @(*) begin
    instr_d <= instr;
end

always @(*) begin
    instr_q <= instr_d;
end

always @(*) begin
    o_INSTR_GNT <= 1;//i_INSTR_REQ & ~o_INSTR_GNT;
end


assign o_GNT = data_gnt;
assign o_RDATA_DATA  = rdata_q;
assign o_RDATA_INSTR = instr_q;

endmodule