module wishbone_master #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
) (
    input  i_RST,
    input  i_CLK,
    output logic [ADDR_WIDTH-1:0] o_ADDR,
    output logic [DATA_WIDTH-1:0] o_DATA,
    input  [DATA_WIDTH-1:0] i_DATA,
    output logic o_WE,
    output logic [3:0] o_SEL,
    output logic o_STB,
    input  i_ACK,
    output logic o_CYC,
    output o_TAGN,
    input  i_TAGN,

    input  i_LSU_REQ,
    input  [ADDR_WIDTH-1:0] i_LSU_ADDR,
    input  [DATA_WIDTH-1:0] i_LSU_DATA,
    input  i_LSU_WE,
    input  [1:0] i_LSU_HB,
    output [DATA_WIDTH-1:0] o_LSU_DATA,
    output logic o_LSU_GNT
);

typedef enum {
    IDLE,
    TRANS,
    WAIT_ACK
} state_t;

state_t state;

wire valid_request = i_LSU_REQ;

always_ff @(posedge i_CLK) begin
    if (i_RST) begin
        o_CYC  <= 1'b0;
        o_STB  <= 1'b0;
        o_SEL  <= 4'b0000;
        o_WE   <= 1'b0;
        o_ADDR <= 0;
        o_DATA <= 0;
    end
    else begin
        case (state)
        IDLE : begin
            o_CYC  <= 1'b0;
            o_STB  <= 1'b0;
            o_SEL  <= 4'b0000;
            o_WE   <= 1'b0;
            o_ADDR <= 0;
            o_DATA <= 0;
            if (valid_request) begin
                o_CYC  <= 1'b1;
                o_STB  <= 1'b1;
                o_SEL  <= 4'b1111;
                o_WE   <= i_LSU_WE;
                o_ADDR <= i_LSU_ADDR;
                o_DATA <= i_LSU_DATA;
            end
        end
        TRANS, WAIT_ACK : begin
            if (i_ACK) begin
                o_CYC  <= 1'b0;
                o_STB  <= 1'b0;
                o_SEL  <= 4'b0000;
                o_WE   <= 1'b0;
                o_ADDR <= 0;
                o_DATA <= 0; 
            end
        end
        default : begin
            o_CYC  <= 1'b0;
            o_STB  <= 1'b0;
            o_SEL  <= 4'b0000;
            o_WE   <= 1'b0;
            o_ADDR <= 0;
            o_DATA <= 0;
        end
        endcase
    end
end

always_ff @(posedge i_CLK) begin
    if (i_RST) begin
        state <= IDLE;
    end
    else begin       
        case (state)
        IDLE : begin
            state <= (valid_request)? TRANS : IDLE;
        end
        TRANS, WAIT_ACK : begin
            state <= (i_ACK)? IDLE : WAIT_ACK;
        end
        default : begin
            state <= IDLE;
        end
        endcase
    end
end

assign o_LSU_GNT = i_ACK;
assign o_LSU_DATA = i_DATA;

endmodule