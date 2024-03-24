module lsu (
    /* TO CORE */
    /* core data to bus */
    input wire [31:0] core_wdata_i,
    /* core address */
    input wire [31:0] core_addr_i,
    /* core write enable */
    input wire core_we_i,
    /* core mode half-word-byte */
    input wire [1:0] core_hb_i,
    /* core data data from bus */
    output reg [31:0] core_rdata_o,

    /* TO BUS */
    /* bus data to core */
    input wire [31:0] rom_data_i,
    input wire [31:0] ram_data_i,
    input wire [31:0] uart_data_i,
    /* bus data from core */
    output reg [31:0] bus_rdata_o, 
    /* bus address */
    output reg [31:0] bus_addr_o,
    /* bus write enable */
    output reg bus_we_o,
    /* bus mode half-word-byte */
    output reg [1:0] bus_hb_o,

    output reg [2:0] bus_cs_o
);

localparam ROM_BASE = 32'h00000000;
localparam ROM_SIZE = 256;

localparam RAM_BASE = 32'h00000100;
localparam RAM_SIZE = 256;

always @(*) begin
    
    bus_rdata_o <= core_wdata_i;
    bus_we_o <= core_we_i;
    bus_hb_o <= core_hb_i;

    if ( (ROM_BASE <= core_addr_i) && (core_addr_i <= (ROM_BASE + ROM_SIZE - 1)) ) begin
        bus_addr_o <= (core_addr_i - ROM_BASE);
    end
    else if ( (RAM_BASE <= core_addr_i) && (core_addr_i <= (RAM_BASE + RAM_SIZE - 1)) ) begin
        bus_addr_o <= (core_addr_i - RAM_BASE);
    end
    else begin
        bus_addr_o <= core_addr_i;
    end
end

always @(*) begin
    if ( (ROM_BASE <= core_addr_i) && (core_addr_i <= (ROM_BASE + ROM_SIZE - 1)) ) begin
        core_rdata_o <= rom_data_i;
    end
    else if ( (RAM_BASE <= core_addr_i) && (core_addr_i <= (RAM_BASE + RAM_SIZE - 1)) ) begin
        core_rdata_o <= ram_data_i;
    end
    else begin
        core_rdata_o <= rom_data_i;
    end
end

always @(*) begin
    if ( (ROM_BASE <= core_addr_i) && (core_addr_i <= (ROM_BASE + ROM_SIZE - 1)) ) begin
        bus_cs_o <= 3'b001;
    end
    else if ( (RAM_BASE <= core_addr_i) && (core_addr_i <= (RAM_BASE + RAM_SIZE - 1)) ) begin
        bus_cs_o <= 3'b010;
    end
    else begin
        bus_cs_o <= 3'b100;
    end
end

endmodule