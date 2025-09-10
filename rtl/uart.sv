`timescale 1ns / 1ps

module uart #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input  i_RST,
    input  i_CLK,

    input  [ADDR_WIDTH-1:0] i_ADDR,
    input  [DATA_WIDTH-1:0] i_DATA,
    output logic [DATA_WIDTH-1:0] o_DATA,
    input  i_WE,
    
    input  [3:0] i_SEL,
    input  i_STB,
    output logic o_ACK,
    input  i_CYC,
    input  i_TAGN,
    output o_TAGN,

    input  i_RX,
    output o_TX,
    output [1:0] o_IRQ
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

logic rx_fifo_we;
logic rx_fifo_re;
reg  [7:0] rx_fifo_data_i;
wire [7:0] rx_fifo_data_o;
wire rx_fifo_full;
wire rx_fifo_empty;

logic tx_fifo_we;
logic tx_fifo_re;
wire [7:0] tx_fifo_data_i;
wire [7:0] tx_fifo_data_o;
wire tx_fifo_full;
wire tx_fifo_empty;

// Synchronous FIFO queue for rx module
sync_fifo #(
    .WIDTH(8),                    // width of data bus
    .DEPTH(64)                    // depth of FIFO buffer
) rx_sync_fifo (
    .clk_i(i_CLK),                // input clock    
    .rst_ni(~i_RST),              // reset signal
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
    .DEPTH(64)                      // depth of FIFO buffer
) tx_sync_fifo (
    .clk_i(i_CLK),                  // input clock
    .rst_ni(~i_RST),                // reset signal
    .wdata_i(tx_fifo_data_i),       // input data
    .we_i(tx_fifo_we),              // write enable signal
    .re_i(tx_fifo_re),              // read enable signal
    .rdata_o(tx_fifo_data_o),       // output data
    .full_o(tx_fifo_full),          // full flag
    .empty_o(tx_fifo_empty)         // empty flag
);

always_ff @(posedge i_CLK) begin: ShiftRegister
    if (i_RST) begin
        rx_sft_reg <= 3'b111;
    end
    else begin
        rx_sft_reg <= {rx_sft_reg[1:0], i_RX};
    end
end

always_ff @(posedge i_CLK) begin: RxClk
    if (i_RST) begin
        rx_tick_count <= 'b0;
        rx_clk <= 'b0;
    end
    else begin
        rx_tick_count <= (rx_clk)? 'b0 : (rx_start)? BAUD_9600 >> 1 : rx_tick_count + 'b1;
        rx_clk <= rx_tick_count == (BAUD_9600 - 'b1);
    end
end

always_ff @(posedge i_CLK) begin: TxClk
    if (i_RST) begin
        tx_tick_count <= 'b0;
        tx_clk <= 'b0;
    end
    else begin
        tx_tick_count <= (tx_clk)? 'b0 : tx_tick_count + 'b1;
        tx_clk <= tx_tick_count == (BAUD_9600 - 'b1);
    end
end

always_ff @(posedge i_CLK) begin: RxSyncStateMachine
    if (i_RST) begin
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

always_ff @(posedge i_CLK) begin: TxSyncStateMachine
    if (i_RST) begin
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

always_comb begin: RxAsyncStateMachine
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

always_comb begin: TxAsyncStateMachine
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

always_ff @(posedge i_CLK) begin
    if (i_RST)
        tx_start = 1'b0;
    else
        tx_start = ~tx_fifo_empty;
end

assign tx_fifo_data_i = i_DATA[7:0];

assign rx_start = rx_sft_reg[2] & ~rx_sft_reg[1] & ~rx_sft_reg[0] & (rx_state == RX_IDLE);

assign rx_frame_count_next = rx_frame_count + 1'b1;
assign tx_frame_count_next = tx_frame_count + 1'b1;

assign o_TX = tx;
assign rx = rx_sft_reg[0];

assign o_IRQ = {tx_fifo_full, ~rx_fifo_empty};

logic valid_cycle;
logic valid_req;

always_comb begin
    valid_cycle = i_CYC;
    valid_req = valid_cycle & i_STB & (~o_ACK);
end

always_comb begin
    rx_fifo_re = valid_req & (~i_WE) & (i_ADDR[3:2] == 2'b00);
    rx_fifo_we = (rx_state == RX_DONE) & rx_clk;

    tx_fifo_re = (tx_state == TX_IDLE) & tx_clk;
    tx_fifo_we = valid_req & i_WE; 
end

always_ff @(posedge i_CLK) begin
    o_ACK <= 1'b0;
    o_DATA <= 0;
    if (valid_req) begin
        case (i_ADDR[3:2])
        2'b00 : o_DATA <= {24'b0, rx_fifo_data_o};
        2'b01 : o_DATA <= {31'b0, ~rx_fifo_empty};
        2'b10 : o_DATA <= {31'b0, ~rx_fifo_empty};
        2'b11 : o_DATA <= {31'b0, ~rx_fifo_empty};
        endcase
        o_ACK <= valid_req;
    end
end 

always @(posedge tx_clk) begin
    if (tx_fifo_empty == 1'b0 && tx_state == TX_IDLE)
        $strobe("[%0t] [UART] %0x | %c", $time, tx_fifo_data_o, tx_fifo_data_o);
end

endmodule