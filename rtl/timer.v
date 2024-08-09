module timer (
    input  wire         i_CLK,
    input  wire         i_RSTn,
    input  wire         i_CE, 
    input  wire         i_WE,
    input  wire         i_RE,
    input  wire [31:0]  i_ADDR,
    input  wire [31:0]  i_WDATA,
    input  wire         i_REQ,
    output wire [31:0]  o_RDATA,
    output wire         o_GNT,
    output wire         o_IRQ
);

reg         en;
reg [31:0]  cycles;
reg [31:0]  interval;
reg         irq;
reg         gnt;
reg [31:0]  rdata;

wire trigger = (cycles == (interval-1'd1));

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        cycles      <= 32'd0;
        irq         <= 1'b0;
    end
    else begin
        if (en) begin
            cycles  <= (trigger)? 32'd0 : cycles + 32'd1;
            irq     <= (trigger);
        end
    end
end

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        interval    <= 32'd0;
        en          <= 1'b0;
    end
    else if (i_WE & i_REQ & i_CE) begin
        case (i_ADDR)
        32'h00  : ;
        32'h04  : ;
        32'h08  : interval  <=  i_WDATA>>1;
        32'h0c  : ;
        32'h10  : en        <=  i_WDATA[0];
        default : ;
        endcase
    end
end

always @(posedge i_CLK) begin
    if (i_RE & i_REQ & i_CE) begin
        case (i_ADDR)
        32'h00  : rdata   <= cycles[31:0];
        32'h04  : rdata   <= 32'd0;
        32'h08  : rdata   <= interval;
        32'h0c  : rdata   <= 32'd0;
        32'h10  : rdata   <= {31'd0, en};
        default : rdata   <= 32'd0;
        endcase   
    end
    else begin
        rdata <= 32'd0;
    end
end

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        gnt <= 1'b0;
    end
    else begin
        if (i_REQ & i_CE) begin
            gnt <= 1'b1;
        end
        else begin
            gnt <= 1'b0;
        end
    end
end

assign o_IRQ    = irq & en;
assign o_GNT    = gnt;
assign o_RDATA  = rdata;

endmodule