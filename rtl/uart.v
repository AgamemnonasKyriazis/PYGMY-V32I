`timescale 1ns / 1ps

module uart(
    input wire clk_i,
    input wire rst_ni,
    input wire uart_rx_i,
    input wire uart_we_i,
    input wire uart_re_i,
    input wire [31:0] uart_tx_wdata_i,
    output wire [31:0] uart_rx_rdata_o,
    output wire uart_tx_o,
    output wire [1:0] uart_irq_o,

    input wire uart_ce_i,
    input wire uart_req_i,
    output wire uart_gnt_o
);

localparam RX_FRAME_LEN = 'd9;
localparam TX_FRAME_LEN = 'd10;
localparam BAUD_4800    = 2500;
localparam BAUD_9600    = 1250;
localparam BAUD_115200  = 104;

localparam RX_IDLE = 0;
localparam RX_READ = 1;
localparam RX_DONE = 2;

localparam TX_IDLE = 0;
localparam TX_WRITE = 1;

reg [2:0] rx_sft_reg;

reg [7:0] rx_frame_buf;
reg [15:0] rx_frame_count;
reg [8:0] tx_frame_buf;
reg [15:0] tx_frame_count;

reg [15:0] rx_tick_count;
reg [15:0] tx_tick_count;
reg rx_clk;
reg tx_clk;

reg [1:0] rx_state;
reg [1:0] rx_state_next;
reg [1:0] tx_state;
reg [1:0] tx_state_next;

wire rx_start;
reg tx_start;
wire [15:0] rx_frame_count_next;
wire [15:0] tx_frame_count_next;

wire rx;
reg tx;

wire rx_fifo_we;
wire rx_fifo_re;
reg  [7:0] rx_fifo_data_i;
wire [7:0] rx_fifo_data_o;
wire rx_fifo_full;
wire rx_fifo_empty;

wire tx_fifo_we;
wire tx_fifo_re;
wire [7:0] tx_fifo_data_i;
wire [7:0] tx_fifo_data_o;
wire tx_fifo_full;
wire tx_fifo_empty;

// Synchronous FIFO queue for rx module
sync_fifo #(
    .WIDTH(8),                    // width of data bus
    .DEPTH(32)                    // depth of FIFO buffer
) rx_sync_fifo (
    .clk_i(clk_i),                // input clock    
    .rst_ni(rst_ni),              // reset signal
    .wdata_i(rx_fifo_data_i),     // input data
    .we_i(rx_fifo_we),            // write enable signal
    .re_i(rx_fifo_re),            // read enable signal
    .rdata_o(rx_fifo_data_o),     // output data
    .full_o(rx_fifo_full),        // full flag
    .empty_o(rx_fifo_empty)       // empty flag
);

// Synchronous FIFO queue for tx module
sync_fifo #(
    .WIDTH(8),                      // width of data bus
    .DEPTH(32)                      // depth of FIFO buffer
) tx_sync_fifo (
    .clk_i(clk_i),                  // input clock
    .rst_ni(rst_ni),                // reset signal
    .wdata_i(tx_fifo_data_i),       // input data
    .we_i(tx_fifo_we),              // write enable signal
    .re_i(tx_fifo_re),              // read enable signal
    .rdata_o(tx_fifo_data_o),       // output data
    .full_o(tx_fifo_full),          // full flag
    .empty_o(tx_fifo_empty)         // empty flag
);

always @(posedge clk_i) begin: ShiftRegister
    if (~rst_ni) begin
        rx_sft_reg <= 3'b111;
    end
    else begin
        rx_sft_reg <= {rx_sft_reg[1:0], uart_rx_i};
    end
end

always @(posedge clk_i) begin: RxClk
    if (~rst_ni) begin
        rx_tick_count <= 'b0;
        rx_clk <= 'b0;
    end
    else begin
        rx_tick_count <= (rx_clk)? 'b0 : (rx_start)? BAUD_9600 >> 1 : rx_tick_count + 'b1;
        rx_clk <= rx_tick_count == (BAUD_9600 - 'b1);
    end
end

always @(posedge clk_i) begin: TxClk
    if (~rst_ni) begin
        tx_tick_count <= 'b0;
        tx_clk <= 'b0;
    end
    else begin
        tx_tick_count <= (tx_clk)? 'b0 : tx_tick_count + 'b1;
        tx_clk <= tx_tick_count == (BAUD_9600 - 'b1);
    end
end

always @(posedge clk_i) begin: RxSyncStateMachine
    if (~rst_ni) begin
        rx_state <= RX_IDLE;
        rx_frame_count <= 'b0;
    end
    else if (rx_clk) begin
        rx_state = rx_state_next;
        case(rx_state)
        RX_IDLE : begin
            rx_frame_count <= 'b0;
        end
        RX_READ : begin
            rx_frame_count <= rx_frame_count_next;
            rx_frame_buf <= {rx, rx_frame_buf[7:1]};
        end
        RX_DONE : begin
            rx_fifo_data_i <= rx_frame_buf;
        end
        endcase
    end
end

always @(posedge clk_i) begin: TxSyncStateMachine
    if (~rst_ni) begin
        tx_state <= TX_IDLE;
        tx_frame_buf <= ~'b0;
        tx_frame_count <= 'b0;
        tx <= 1'b1;
    end
    else if (tx_clk) begin
        tx_state <= tx_state_next;
        case(tx_state)
        TX_IDLE : begin
            tx_frame_count <= 'b0;
            tx_frame_buf <= {tx_fifo_data_o, 1'b0};
            tx <= 'b1;
        end
        TX_WRITE : begin
            tx_frame_count <= tx_frame_count_next;
            tx <= tx_frame_buf[0];
            tx_frame_buf <= {1'b1, tx_frame_buf[8:1]};
        end
        endcase
    end
end

always @(*) begin: RxAsyncStateMachine
    case (rx_state)
    RX_IDLE : begin
        rx_state_next = (~rx)? RX_READ : RX_IDLE;
    end
    RX_READ : begin
        rx_state_next = (rx_frame_count < RX_FRAME_LEN)? RX_READ : RX_DONE;
    end
    RX_DONE : begin
        rx_state_next = RX_IDLE;
    end
    default : begin
        rx_state_next = RX_IDLE;
    end
    endcase
end

always @(*) begin: TxAsyncStateMachine
    case (tx_state)
    TX_IDLE : begin
        tx_state_next = (tx_start)? TX_WRITE : TX_IDLE;
    end
    TX_WRITE : begin
        tx_state_next = (tx_frame_count < TX_FRAME_LEN)? TX_WRITE : TX_IDLE;
    end
    default : begin
        tx_state_next = TX_IDLE;
    end
    endcase
end

always @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni)
        tx_start = 1'b0;
    else
        tx_start = ~tx_fifo_empty;
end

assign tx_fifo_data_i = uart_tx_wdata_i[7:0];
assign uart_rx_rdata_o = {24'b0, rx_fifo_data_o};

assign rx_fifo_we = (rx_state == RX_DONE) & rx_clk;
assign rx_fifo_re = uart_re_i;

assign tx_fifo_we = uart_we_i;
assign tx_fifo_re = (tx_state == TX_IDLE) & tx_clk;

assign rx_start = rx_sft_reg[2] & ~rx_sft_reg[1] & ~rx_sft_reg[0] & (rx_state == RX_IDLE);

assign rx_frame_count_next = rx_frame_count + 1'b1;
assign tx_frame_count_next = tx_frame_count + 1'b1;

assign uart_tx_o = tx;
assign rx = rx_sft_reg[0];

assign uart_irq_o = {tx_fifo_full, ~rx_fifo_empty};

assign uart_gnt_o = uart_req_i & uart_ce_i;

always @(posedge tx_clk) begin
    if (~tx_fifo_empty & tx_state == TX_IDLE)
        $display("%x \t %c", tx_fifo_data_o, tx_fifo_data_o);
end

endmodule