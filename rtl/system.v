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

wire [31:0] pc_0;
wire [31:0] instruction_0;

wire [31:0] pc_1;
wire [31:0] instruction_1;

/* Wishbone Interface */

wire [31:0] wb_m_addr_0;
wire [31:0] wb_m_wdata_0;
wire [31:0] wb_m_rdata_0;
wire wb_m_stb_0;
wire wb_m_we_0;
wire [3:0] wb_m_sel_0;
wire wb_m_cyc_0;
wire wb_m_ack_0;
wire wb_m_otagn_0;
wire wb_m_itagn_0;

wire [31:0] wb_m_addr_1;
wire [31:0] wb_m_wdata_1;
wire [31:0] wb_m_rdata_1;
wire wb_m_stb_1;
wire wb_m_we_1;
wire [3:0] wb_m_sel_1;
wire wb_m_cyc_1;
wire wb_m_ack_1;
wire wb_m_otagn_1;
wire wb_m_itagn_1;

wire [31:0] wb_s_addr_0;
wire [31:0] wb_s_wdata_0;
wire [31:0] wb_s_rdata_0;
wire wb_s_stb_0;
wire wb_s_we_0;
wire [3:0] wb_s_sel_0;
wire wb_s_cyc_0;
wire wb_s_ack_0;
wire wb_s_otagn_0;
wire wb_s_itagn_0;

wire [31:0] wb_s_addr_1;
wire [31:0] wb_s_wdata_1;
wire [31:0] wb_s_rdata_1;
wire wb_s_stb_1;
wire wb_s_we_1;
wire [3:0] wb_s_sel_1;
wire wb_s_cyc_1;
wire wb_s_ack_1;
wire wb_s_otagn_1;
wire wb_s_itagn_1;

wire [31:0] wb_s_addr_2;
wire [31:0] wb_s_wdata_2;
wire [31:0] wb_s_rdata_2;
wire wb_s_stb_2;
wire wb_s_we_2;
wire [3:0] wb_s_sel_2;
wire wb_s_cyc_2;
wire wb_s_ack_2;
wire wb_s_otagn_2;
wire wb_s_itagn_2;

core #(.HART_ID(32'd0)) core0 (
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    
    .i_INSTRUCTION(instruction_0),
    .o_PC(pc_0),

    .i_MEI_0(uart_irq[0]),
    .i_MEI_1(1'b0),
    .i_MEI_2(1'b0),
    .i_MEI_3(1'b0),
    .i_MEI_4(1'b0),
    .i_MEI_5(1'b0),

    .o_WB_ADDR(wb_m_addr_0),
    .o_WB_DATA(wb_m_wdata_0),
    .i_WB_DATA(wb_m_rdata_0),
    .o_WB_WE(wb_m_we_0),
    .o_WB_SEL(wb_m_sel_0),
    .o_WB_STB(wb_m_stb_0),
    .i_WB_ACK(wb_m_ack_0),
    .o_WB_CYC(wb_m_cyc_0),
    .o_WB_TAGN(wb_m_otagn_0),
    .i_WB_TAGN(wb_m_itagn_0)
);

core #(.HART_ID(32'd1)) core1 (
    .i_CLK(CLK),
    .i_RSTn(RSTn),
    
    .i_INSTRUCTION(instruction_1),
    .o_PC(pc_1),

    .i_MEI_0(1'b0),
    .i_MEI_1(1'b0),
    .i_MEI_2(1'b0),
    .i_MEI_3(1'b0),
    .i_MEI_4(1'b0),
    .i_MEI_5(1'b0),

    .o_WB_ADDR(wb_m_addr_1),
    .o_WB_DATA(wb_m_wdata_1),
    .i_WB_DATA(wb_m_rdata_1),
    .o_WB_WE(wb_m_we_1),
    .o_WB_SEL(wb_m_sel_1),
    .o_WB_STB(wb_m_stb_1),
    .i_WB_ACK(wb_m_ack_1),
    .o_WB_CYC(wb_m_cyc_1),
    .o_WB_TAGN(wb_m_otagn_1),
    .i_WB_TAGN(wb_m_itagn_1)
);

wb_interconnect_wrapper #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32),
    .N_MASTERS(2),
    .N_SLAVES(3)
) wb_ic_wrapper (

    .i_RST(~RSTn),
    .i_CLK(CLK),

    .i_s_ADDR_0(wb_m_addr_0),
    .i_s_DATA_0(wb_m_wdata_0),
    .o_s_DATA_0(wb_m_rdata_0),
    .i_s_WE_0(wb_m_we_0),
    .i_s_SEL_0(wb_m_sel_0),
    .i_s_STB_0(wb_m_stb_0),
    .o_s_ACK_0(wb_m_ack_0),
    .i_s_CYC_0(wb_m_cyc_0),
    .i_s_TAGN_0(wb_m_otagn_0),
    .o_s_TAGN_0(wb_m_itagn_0),

    .i_s_ADDR_1(wb_m_addr_1),
    .i_s_DATA_1(wb_m_wdata_1),
    .o_s_DATA_1(wb_m_rdata_1),
    .i_s_WE_1(wb_m_we_1),
    .i_s_SEL_1(wb_m_sel_1),
    .i_s_STB_1(wb_m_stb_1),
    .o_s_ACK_1(wb_m_ack_1),
    .i_s_CYC_1(wb_m_cyc_1),
    .i_s_TAGN_1(wb_m_otagn_1),
    .o_s_TAGN_1(wb_m_itagn_1),

    .o_m_ADDR_0(wb_s_addr_0),
    .o_m_DATA_0(wb_s_wdata_0),
    .i_m_DATA_0(wb_s_rdata_0),
    .o_m_WE_0(wb_s_we_0),
    .o_m_SEL_0(wb_s_sel_0),
    .o_m_STB_0(wb_s_stb_0),
    .i_m_ACK_0(wb_s_ack_0),
    .o_m_CYC_0(wb_s_cyc_0),
    .o_m_TAGN_0(wb_s_otagn_0),
    .i_m_TAGN_0(wb_s_itagn_0),

    .o_m_ADDR_1(wb_s_addr_1),
    .o_m_DATA_1(wb_s_wdata_1),
    .i_m_DATA_1(wb_s_rdata_1),
    .o_m_WE_1(wb_s_we_1),
    .o_m_SEL_1(wb_s_sel_1),
    .o_m_STB_1(wb_s_stb_1),
    .i_m_ACK_1(wb_s_ack_1),
    .o_m_CYC_1(wb_s_cyc_1),
    .o_m_TAGN_1(wb_s_otagn_1),
    .i_m_TAGN_1(wb_s_itagn_1),

    .o_m_ADDR_2(wb_s_addr_2),
    .o_m_DATA_2(wb_s_wdata_2),
    .i_m_DATA_2(wb_s_rdata_2),
    .o_m_WE_2(wb_s_we_2),
    .o_m_SEL_2(wb_s_sel_2),
    .o_m_STB_2(wb_s_stb_2),
    .i_m_ACK_2(wb_s_ack_2),
    .o_m_CYC_2(wb_s_cyc_2),
    .o_m_TAGN_2(wb_s_otagn_2),
    .i_m_TAGN_2(wb_s_itagn_2)
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

    .i_PC_0({4'h0, pc_0[27:0]} >> 2),
    .o_INSTRUCTION_0(instruction_0),

    .i_PC_1({4'h0, pc_1[27:0]} >> 2),
    .o_INSTRUCTION_1(instruction_1),

    .i_ADDR(wb_s_addr_0),
    .o_DATA(wb_s_rdata_0),
    .i_SEL(wb_s_sel_0),
    .i_STB(wb_s_stb_0),
    .o_ACK(wb_s_ack_0),
    .i_CYC(wb_s_cyc_0),
    .i_TAGN(wb_s_otagn_0),
    .o_TAGN(wb_s_itagn_0)
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
    
    .i_ADDR(wb_s_addr_1),
    .i_DATA(wb_s_wdata_1),
    .o_DATA(wb_s_rdata_1),
    .i_WE(wb_s_we_1),
    .i_SEL(wb_s_sel_1),
    .i_STB(wb_s_stb_1),
    .o_ACK(wb_s_ack_1),
    .i_CYC(wb_s_cyc_1),
    .i_TAGN(wb_s_otagn_1),
    .o_TAGN(wb_s_itagn_1)
);

/* UART */
wire [31:0] wishbone_s2_data;
wire wishbone_s2_ack;
reg wishbone_s2_stb;
wire [1:0] uart_irq;
uart uart0 (
    .i_RST(~RSTn),
    .i_CLK(CLK),

    .i_RX(i_UART_TXD),
    .o_TX(o_UART_RXD),
    .o_IRQ(uart_irq),

    .i_ADDR(wb_s_addr_2),
    .i_DATA(wb_s_wdata_2),
    .o_DATA(wb_s_rdata_2),
    .i_WE(wb_s_we_2),
    .i_SEL(wb_s_sel_2),
    .i_STB(wb_s_stb_2),
    .o_ACK(wb_s_ack_2),
    .i_CYC(wb_s_cyc_2),
    .i_TAGN(wb_s_otagn_2),
    .o_TAGN(wb_s_itagn_2)
);


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