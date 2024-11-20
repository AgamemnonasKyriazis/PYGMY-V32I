module system(
    input  wire i_CLK,
    input  wire i_RST,
    input  wire i_UART_TXD,
    output wire o_UART_RXD,
    output wire o_GPIO_0,
    output wire o_GPIO_1
    //output wire o_GPIO_2,
    //output wire o_GPIO_3,
    //output wire o_GPIO_4,
    //output wire o_GPIO_5,
    //output wire o_GPIO_6,
    //output wire o_GPIO_7
);

wire CLK = i_CLK;
wire RSTn = ~i_RST;

wire [31:0] CORE_ADDR;

wire [31:0] BUS_WDATA;
wire [31:0] BUS_ADDR = {4'h0, CORE_ADDR[27:0]};
reg  [31:0] BUS_RDATA;
wire        BUS_WE;
wire        BUS_RE;
wire [1:0]  BUS_HB;
wire        BUS_GNT;
wire        BUS_REQ;
reg  [7:0]  BUS_CE;

/* BUS CE DECODE */
always @* begin
    if (BUS_RE | BUS_WE)
    case (CORE_ADDR[31:28])
    4'h8 : BUS_CE <= 8'b00000001;
    4'h9 : BUS_CE <= 8'b00000010;
    4'hA : BUS_CE <= 8'b00000100;
    4'hB : BUS_CE <= 8'b00001000;
    4'hC : BUS_CE <= 8'b00010000;
    default : 
        BUS_CE <= 8'b00000000;
    endcase
    else
    BUS_CE <= 8'b00000000;
end

core core0 (
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    .i_INSTRUCTION(UROM_RDATA_INSTR),
    .i_BUS_RDATA(BUS_RDATA),
    .i_BUS_GNT(BUS_GNT),
    .o_PC(UROM_ADDR_INSTR),
    .o_BUS_WDATA(BUS_WDATA),
    .o_BUS_ADDR(CORE_ADDR),
    .o_BUS_WE(BUS_WE),
    .o_BUS_RE(BUS_RE),
    .o_BUS_HB(BUS_HB),
    .o_BUS_REQ(BUS_REQ),

    .i_MEI_0(UART_IRQ[0]),
    .i_MEI_1(1'b0),
    .i_MEI_2(1'b0),
    .i_MEI_3(1'b0),
    .i_MEI_4(1'b0),
    .i_MEI_5(TIMER_IRQ),

    .i_INSTR_GNT(UROM_INSTR_GNT),
    .o_INSTR_REQ(CORE_INSTR_REQ)
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

wire        CORE_INSTR_REQ;
wire        UROM_INSTR_GNT;

rom rom0 (
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    .i_CE(UROM_CE),
    .i_HB(UROM_HB),
    .i_REQ(BUS_REQ),
    .i_ADDR_DATA(UROM_ADDR_DATA),
    .i_ADDR_INSTR({4'd0, UROM_ADDR_INSTR[27:0]}),
    .o_RDATA_DATA(UROM_RDATA_DATA),
    .o_RDATA_INSTR(UROM_RDATA_INSTR),
    .o_GNT(UROM_GNT),

    .i_INSTR_REQ(CORE_INSTR_REQ),
    .o_INSTR_GNT(UROM_INSTR_GNT)
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
    .rdata_o(SRAM_RDATA)
);

assign SRAM_WDATA   = BUS_WDATA;
assign SRAM_ADDR    = BUS_ADDR;
assign SRAM_WE      = BUS_WE;
assign SRAM_RE      = BUS_RE;
assign SRAM_HB      = BUS_HB;
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
assign UART_RE      = BUS_RE & UART_CE;
assign UART_CE      = BUS_CE[2];
assign UART_REQ     = BUS_REQ; 

/* EXT TIMER */
wire        TIMER_CE;
wire        TIMER_WE;
wire [31:0] TIMER_WDATA;
wire        TIMER_REQ;
wire        TIMER_GNT;
wire        TIMER_IRQ;

timer timer_ext
(
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    .i_CE(TIMER_CE),
    .i_WE(TIMER_WE),
    .i_WDATA(TIMER_WDATA),
    .i_REQ(TIMER_REQ),
    .o_GNT(TIMER_GNT),
    .o_IRQ(TIMER_IRQ)
);

assign TIMER_CE     = BUS_CE[3];
assign TIMER_WE     = BUS_WE;
assign TIMER_WDATA  = BUS_WDATA;
assign TIMER_REQ    = BUS_REQ;

/* GPIOs */
wire        GPIO_CE;
wire        GPIO_WE;
wire [31:0] GPIO_WDATA;
wire        GPIO_REQ;
wire        GPIO_GNT;
wire [31:0] GPIO_RDATA;
wire [0:7]  GPIO;
gpio gpio_0
(
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    .i_CE(GPIO_CE),
    .i_WE(GPIO_WE),
    .i_WDATA(GPIO_WDATA),
    .i_REQ(GPIO_REQ),
    .o_GNT(GPIO_GNT),
    .o_RDATA(GPIO_RDATA),
    .o_GPIO(GPIO)
);

assign GPIO_CE      = BUS_CE[4];
assign GPIO_WE      = BUS_WE;
assign GPIO_WDATA   = BUS_WDATA;
assign GPIO_REQ     = BUS_REQ;

/* BUS */
assign BUS_GNT = (UROM_CE&UROM_GNT) | (SRAM_CE&SRAM_GNT) | (UART_CE&UART_GNT) | (TIMER_CE*TIMER_GNT);

always @(*) begin
    case (1'b1)
    UROM_CE     : BUS_RDATA <= UROM_RDATA_DATA;
    SRAM_CE     : BUS_RDATA <= SRAM_RDATA;
    UART_CE     : BUS_RDATA <= UART_RDATA;
    default     : BUS_RDATA <= 32'dx;
    endcase
end

wire o_GPIO_7, o_GPIO_6, o_GPIO_5, o_GPIO_4, o_GPIO_3, o_GPIO_2; 

assign {o_GPIO_7,
        o_GPIO_6,
        o_GPIO_5,
        o_GPIO_4,
        o_GPIO_3,
        o_GPIO_2,
        o_GPIO_1,
        o_GPIO_0 
} = GPIO;

endmodule