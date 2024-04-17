`timescale 1ns / 1ps

module rom (
    input wire [31:0] addr_prt1_i,
    input wire [31:0] addr_prt2_i,
    input wire [1:0] hb_i,
    output reg [31:0] rdata_prt1_o,
    output reg [31:0] rdata_prt2_o
);

wire [31:0] addr_1, addr_2;

reg [31:0] rom [0:255];

initial begin
    $readmemh("../sw/image.hex", rom);
end

always @(*) begin
    case (hb_i)
    2'b00 : begin
        case (addr_prt1_i[1:0])
        2'b00 : rdata_prt1_o = {24'b0, rom[addr_1][7:0]};
        2'b01 : rdata_prt1_o = {24'b0, rom[addr_1][15:8]};
        2'b10 : rdata_prt1_o = {24'b0, rom[addr_1][23:16]};
        2'b11 : rdata_prt1_o = {24'b0, rom[addr_1][31:24]};
        endcase
    end
    2'b01 : begin
        case (addr_prt1_i[1:0])
        2'b10 : rdata_prt1_o = {16'b0, rom[addr_1][31:16]};
        default : rdata_prt1_o = {16'b0, rom[addr_1][15:0]};
        endcase
    end
    default : begin
        rdata_prt1_o = rom[addr_1];
    end
    endcase
end

always @(*) begin
    rdata_prt2_o = rom[addr_2];
end

assign addr_1 = addr_prt1_i >> 2;
assign addr_2 = addr_prt2_i >> 2;

endmodule