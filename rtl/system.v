module system(
    input  wire i_CLK,
    input  wire i_RST,
    input  wire i_UART_TXD,
    output wire o_UART_RXD,
    output wire o_GPIO_0,
    output wire o_GPIO_1
);

wire CLK = i_CLK;
wire RSTn = ~i_RST;

wire [31:0] pc;
wire [31:0] instruction;

/* Wishbone Interface */
wire [31:0] wishbone_addr;
wire [31:0] wishbone_m_data;
reg [31:0] wishbone_s_data;
wire wishbone_stb;
wire wishbone_we;
wire [3:0] wishbone_sel;
wire wishbone_cyc;
reg wishbone_ack;
wire wishbone_tagn_out;

core core0 (
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    
    .i_INSTRUCTION(instruction),
    .o_PC(pc),

    .i_MEI_0(uart_irq[0]),
    .i_MEI_1(1'b0),
    .i_MEI_2(1'b0),
    .i_MEI_3(1'b0),
    .i_MEI_4(1'b0),
    .i_MEI_5(1'b0),

    .o_WB_ADDR(wishbone_addr),
    .o_WB_DATA(wishbone_m_data),
    .i_WB_DATA(wishbone_s_data),
    .o_WB_WE(wishbone_we),
    .o_WB_SEL(wishbone_sel),
    .o_WB_STB(wishbone_stb),
    .i_WB_ACK(wishbone_ack),
    .o_WB_CYC(wishbone_cyc),
    .o_WB_TAGN(wishbone_tagn_out),
    .i_WB_TAGN()
);

/* Wishbone Interface UROM */
reg wishbone_s0_stb;
wire [31:0] wishbone_s0_data;
wire wishbone_s0_ack;

wishbone_urom_slave #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32)
) urom_slave_0 (
    .i_RST(~RSTn),
    .i_CLK(CLK),

    .i_PC({4'h0, pc[27:0]} >> 2),
    .o_INSTRUCTION(instruction),

    .i_ADDR({4'h0, wishbone_addr[27:0]}),
    .o_DATA(wishbone_s0_data),
    
    .i_SEL(wishbone_sel),
    .i_STB(wishbone_s0_stb),
    .o_ACK(wishbone_s0_ack),
    .i_CYC(wishbone_cyc),
    
    .i_TAGN(wishbone_tagn_out),
    .o_TAGN()
);

/* Wishbone Interface PRAM */
wire [31:0] wishbone_s1_data;
wire wishbone_s1_ack;
reg wishbone_s1_stb;

wishbone_sram_slave #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32)
) sram_slave_0 (
    .i_CLK(CLK),
    .i_RST(~RSTn),
    
    .i_ADDR({4'h0, wishbone_addr[27:0]}),
    .i_DATA(wishbone_m_data),
    .o_DATA(wishbone_s1_data),
    
    .i_WE(wishbone_we),
    .i_SEL(wishbone_sel),
    .i_STB(wishbone_s1_stb),
    .o_ACK(wishbone_s1_ack),
    .i_CYC(wishbone_cyc),
    
    .i_TAGN(wishbone_tagn_out),
    .o_TAGN()
);

/* UART */
wire [31:0] wishbone_s2_data;
wire wishbone_s2_ack;
reg wishbone_s2_stb;
wire [1:0] uart_irq;
uart uart0 (
    .i_RST(~RSTn),
    .i_CLK(CLK),

    .i_ADDR({4'h0, wishbone_addr[27:0]}),
    .i_DATA(wishbone_m_data),
    .o_DATA(wishbone_s2_data),
    
    .i_WE(wishbone_we),
    .i_SEL(wishbone_sel),
    .i_STB(wishbone_s2_stb),
    .o_ACK(wishbone_s2_ack),
    .i_CYC(wishbone_cyc),
    .i_TAGN(wishbone_tagn_out),
    .o_TAGN(),

    .i_RX(i_UART_TXD),
    .o_TX(o_UART_RXD),
    .o_IRQ(uart_irq)
);

/* Wishbone Interconnect */
wire [3:0] port = wishbone_addr[31:28];
always @(*) begin
    if (wishbone_stb) begin
        case (port)
        4'h8 : begin
            wishbone_ack = wishbone_s0_ack;
            wishbone_s_data = wishbone_s0_data;
            wishbone_s0_stb = wishbone_stb;
            wishbone_s1_stb = 1'b0;
            wishbone_s2_stb = 1'b0;
        end
        4'h9 : begin
            wishbone_ack = wishbone_s1_ack;
            wishbone_s_data = wishbone_s1_data;
            wishbone_s0_stb = 1'b0;
            wishbone_s1_stb = wishbone_stb;
            wishbone_s2_stb = 1'b0;
        end
        4'hA : begin
            wishbone_ack = wishbone_s2_ack;
            wishbone_s_data = wishbone_s2_data;
            wishbone_s0_stb = 1'b0;
            wishbone_s1_stb = 1'b0;
            wishbone_s2_stb = wishbone_stb;
        end
        default : begin
            wishbone_ack = 1'b0;
            wishbone_s_data = 32'b0;
            wishbone_s0_stb = 1'b0;
            wishbone_s1_stb = 1'b0;
            wishbone_s2_stb = 1'b0;
        end
        endcase
    end
    else begin
        wishbone_ack = 1'b0;
        wishbone_s_data = 32'b0;
        wishbone_s0_stb = 1'b0;
        wishbone_s1_stb = 1'b0;
        wishbone_s2_stb = 1'b0;
    end
end

/* EXT TIMER 
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
*/

/* GPIOs 
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
*/

/* BUS 
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
*/

endmodule