module gpio (
    input  wire         i_CLK,
    input  wire         i_RSTn,
    input  wire         i_CE, 
    input  wire         i_WE,
    input  wire [31:0]  i_WDATA,
    input  wire         i_REQ,
    output wire         o_GNT,
    output wire [31:0]  o_RDATA,

    inout  wire [7:0]   o_GPIO
);

reg [7:0] io_val;
reg [7:0] io_dir;

always @(posedge i_CLK) begin
    if (~i_RSTn) begin
        io_val <= 8'd0;
        io_dir <= 8'd0;
    end
    else begin
        if (i_WE & i_CE & i_REQ) begin
            io_val <= i_WDATA[7:0];
            $display("%x", i_WDATA[7:0]);
        end
    end
end

assign o_GPIO = io_val;

assign o_GNT = i_REQ & i_CE;
assign o_RDATA = {24'd0, io_val};

endmodule