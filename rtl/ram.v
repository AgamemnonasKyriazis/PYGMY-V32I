`timescale 1ns / 1ps

module ram #(
    parameter SIZE = 4*1024
) (
    /* system clock */
    input wire clk_i,
    input wire rst_ni,

    input wire ce_i,
    input wire req_i,
    output reg gnt_o,

    /* data bus in */
    input wire [31:0] wdata_i,
    /* address bus in */
    input wire [31:0] addr_i,
    /* write enable */
    input wire we_i,
    /* half-word/byte */
    input wire [1:0] hb_i,
    /* data bus out */
    output reg [31:0] rdata_o
);

wire wordEn =  hb_i[1] & ~hb_i[0];
wire halfEn = ~hb_i[1] &  hb_i[0];
wire byteEn = ~hb_i[1] & ~hb_i[0];

wire alignErr = (( wordEn & (addr_i[1] | addr_i[0]) ) |
                ( halfEn & (addr_i[0]) )) & ce_i;

wire [31:0] addr = addr_i >> 2;

reg [31:0] outBuf;

(* ram_style = "block" *) reg [31:0] sram [0:SIZE-1];

always @(posedge clk_i) begin
    if (req_i & ce_i & (~alignErr)) begin
        if (we_i) begin
        case (1'b1)
        byteEn : begin
            case (addr_i[1:0])
            2'b00 : sram[addr][7:0]   <= wdata_i[7:0];
            2'b01 : sram[addr][15:8]  <= wdata_i[7:0];
            2'b10 : sram[addr][23:16] <= wdata_i[7:0];
            2'b11 : sram[addr][31:24] <= wdata_i[7:0];
            endcase
        end
        halfEn : begin
            case (addr_i[1])
            1'b0 : sram[addr][15:0]  <= wdata_i[15:0];
            1'b1 : sram[addr][31:16] <= wdata_i[15:0];
            endcase
        end
        wordEn : begin
            sram[addr] <= wdata_i;
        end
        endcase
        end
        else begin
            outBuf <= sram[addr];
        end
    end
end

always @(*) begin
    case (1'b1)
    byteEn : begin
        case (addr_i[1:0])
        2'b00 : rdata_o <= { {24{outBuf[7]}}, outBuf[7:0]   };
        2'b01 : rdata_o <= { {24{outBuf[15]}}, outBuf[15:8]  };
        2'b10 : rdata_o <= { {24{outBuf[23]}}, outBuf[23:16] };
        2'b11 : rdata_o <= { {24{outBuf[31]}}, outBuf[31:24] };
        endcase 
    end
    halfEn : begin
        case (addr_i[1])
        1'b0 : rdata_o <= { {16{outBuf[15]}}, outBuf[15:0]  };
        1'b1 : rdata_o <= { {16{outBuf[31]}}, outBuf[31:16] };
        endcase
    end
    wordEn : begin
        rdata_o <= outBuf;
    end
    endcase
end

always @(posedge clk_i) begin
    if (~rst_ni)
        gnt_o <= 1'b0;
    else
        gnt_o <= req_i & ce_i & ~gnt_o;
end

endmodule
