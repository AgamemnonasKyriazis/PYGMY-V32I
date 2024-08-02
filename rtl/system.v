module system(
    input  wire i_CLK,
    input  wire i_RST,
    input  wire i_UART_TXD,
    output wire o_UART_RXD
);

wire CLK = i_CLK;
wire RSTn = ~i_RST;

wire [31:0] BUS_WDATA;
wire [31:0] BUS_ADDR;
reg  [31:0] BUS_RDATA;
wire        BUS_WE;
wire        BUS_RE;
wire [1:0]  BUS_HB;
wire        BUS_GNT;
wire        BUS_REQ;
wire [7:0]  BUS_CE;

core core0 (
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    .i_INSTRUCTION(UROM_RDATA_INSTR),
    .i_BUS_RDATA(BUS_RDATA),
    .i_BUS_GNT(BUS_GNT),
    .o_PC(UROM_ADDR_INSTR),
    .o_BUS_WDATA(BUS_WDATA),
    .o_BUS_ADDR(BUS_ADDR),
    .o_BUS_WE(BUS_WE),
    .o_BUS_RE(BUS_RE),
    .o_BUS_HB(BUS_HB),
    .o_BUS_REQ(BUS_REQ),
    .o_BUS_CE(BUS_CE),

    .i_MEI_0(UART_IRQ[0]),
    .i_MEI_1(1'b0),
    .i_MEI_2(1'b0),
    .i_MEI_3(1'b0),
    .i_MEI_4(1'b0),
    .i_MEI_5(1'b0)
);

/* UROM */
wire [31:0] UROM_ADDR_DATA;
wire [31:0] UROM_RDATA_DATA;
wire [31:0] UROM_ADDR_INSTR;
wire [31:0] UROM_RDATA_INSTR;
wire        UROM_RE;
wire [1:0]  UROM_HB;
wire        UROM_CE;
wire        UROM_REQ;
wire        UROM_GNT;

rom rom0 (
    .addr_prt1_i(UROM_ADDR_DATA),
    .addr_prt2_i(UROM_ADDR_INSTR),
    .hb_i(UROM_HB),
    .rdata_prt1_o(UROM_RDATA_DATA),
    .rdata_prt2_o(UROM_RDATA_INSTR),
    .urom_ce_i(UROM_CE),
    .urom_req_i(UROM_REQ),
    .urom_gnt_o(UROM_GNT)
);

assign UROM_ADDR_DATA   = BUS_ADDR;
assign UROM_HB          = BUS_HB;
assign UROM_CE          = BUS_CE[0];
assign UROM_REQ         = BUS_REQ;

/* SRAM */
wire        SRAM_CE;
wire        SRAM_WE;
wire        SRAM_RE;
wire        SRAM_REQ;
wire        SRAM_GNT;
wire [31:0] SRAM_WDATA;
wire [31:0] SRAM_ADDR;
wire [31:0] SRAM_RDATA;
wire [1:0]  SRAM_HB;
wire        SRAM_UL;

ram ram0 (
    .clk_i(CLK),
    .rst_ni(RSTn),
    .ce_i(SRAM_CE),
    .req_i(SRAM_REQ),
    .gnt_o(SRAM_GNT),
    .wdata_i(SRAM_WDATA),
    .addr_i(SRAM_ADDR),
    .we_i(SRAM_WE),
    .hb_i(SRAM_HB),
    .uload_i(SRAM_UL),
    .rdata_o(SRAM_RDATA)
);

assign SRAM_WDATA   = BUS_WDATA;
assign SRAM_ADDR    = BUS_ADDR;
assign SRAM_WE      = BUS_WE;
assign SRAM_RE      = BUS_RE;
assign SRAM_HB      = BUS_HB;
assign SRAM_UL      = 1'b0;
assign SRAM_CE      = BUS_CE[1];
assign SRAM_REQ     = BUS_REQ;

/* UART */
wire        UART_WE;
wire        UART_RE;
wire [31:0] UART_WDATA;
wire [31:0] UART_RDATA;
wire [1:0]  UART_IRQ;
wire        UART_CE;
wire        UART_REQ;
wire        UART_GNT;
wire        UART_TX;
wire        UART_RX;

uart uart0 (
    .clk_i(CLK),
    .rst_ni(RSTn),
    .uart_rx_i(UART_RX),
    .uart_we_i(UART_WE),
    .uart_re_i(UART_RE),
    .uart_tx_wdata_i(UART_WDATA),
    .uart_rx_rdata_o(UART_RDATA),
    .uart_tx_o(UART_TX),
    .uart_irq_o(UART_IRQ),
    .uart_ce_i(UART_CE),
    .uart_req_i(UART_REQ),
    .uart_gnt_o(UART_GNT)
);

assign o_UART_RXD   = UART_TX;
assign UART_RX      = i_UART_TXD;

assign UART_WDATA   = BUS_WDATA;
assign UART_WE      = BUS_WE & UART_CE;
assign UART_RE      = ~BUS_WE & UART_CE;
assign UART_CE      = BUS_CE[2];
assign UART_REQ     = BUS_REQ; 

/* BUS */
assign BUS_GNT = UROM_GNT | SRAM_GNT | UART_GNT;

always @(*) begin
    case (1'b1)
    UROM_CE : BUS_RDATA <= UROM_RDATA_DATA;
    SRAM_CE : BUS_RDATA <= SRAM_RDATA;
    UART_CE : BUS_RDATA <= UART_RDATA;
    default : BUS_RDATA <= 32'd0;
    endcase
end

endmodule