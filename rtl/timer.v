module timer #(
    parameter SYS_FREQ = 32'd12_000_000
)(
    input  wire         i_CLK,
    input  wire         i_RSTn,
    input  wire         i_CE, 
    input  wire         i_WE,
    input  wire [31:0]  i_WDATA,
    input  wire         i_REQ,
    output wire         o_GNT,
    output wire         o_IRQ
);

reg [31:0]  cycles;
reg [31:0]  interval;
reg         irq;
reg         gnt;

wire trigger    = ( (cycles == interval) && (interval != 0) );

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        cycles  <= 32'd0;
        irq     <= 1'b0;
    end
    else begin
        irq     <= ( trigger );
        cycles  <= ( (trigger) || (interval == 0) )? 32'd0 : cycles + 32'd1;
    end
end

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        interval    <= 32'd0;
    end
    else if (i_WE & i_REQ & i_CE) begin
        interval  <=  i_WDATA;
    end
end

assign o_IRQ    = irq;
assign o_GNT    = i_REQ & i_CE;

endmodule