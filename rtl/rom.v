`timescale 1ns / 1ps

module rom (
    input wire [31:0] addr_i,
    input wire [1:0] hb_i,
    output reg [31:0] rdata_o
);

wire [31:0] addr;

reg [31:0] rom [0:255];

initial begin
    $readmemh("../sw/image.hex", rom);
end

always @(*) begin
    case (hb_i)
    2'b01 : begin
        case (addr_i[1:0])
        2'b00 : rdata_o = {24'b0, rom[addr][7:0]};
        2'b01 : rdata_o = {24'b0, rom[addr][15:8]};
        2'b10 : rdata_o = {24'b0, rom[addr][23:16]};
        2'b11 : rdata_o = {24'b0, rom[addr][31:24]};
        endcase
    end
    2'b10 : begin
        case (addr_i[1:0])
        2'b10 : rdata_o = {16'b0, rom[addr][31:16]};
        default : rdata_o = {16'b0, rom[addr][15:0]};
        endcase
    end
    default : begin
        rdata_o = rom[addr];
    end
    endcase
end

assign addr = addr_i >> 2;

always @(rdata_o) begin
    //$display("ROM : %x %b %x", addr_i, hb_i, rdata_o);
end

endmodule