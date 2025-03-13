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
    output logic o_TAGN,
    input  i_TAGN,

    input  i_LSU_REQ,
    input  [ADDR_WIDTH-1:0] i_LSU_ADDR,
    input  [DATA_WIDTH-1:0] i_LSU_DATA,
    input  i_LSU_WE,
    input  [1:0] i_LSU_HB,
    output logic [DATA_WIDTH-1:0] o_LSU_DATA,
    output logic o_LSU_GNT
);

enum bit[1:0] {
    BYTE = 2'b00,
    HALF = 2'b01,
    WORD = 2'b10
} mode;

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
                case (i_LSU_HB)
                WORD : begin
                    o_DATA <= i_LSU_DATA;
                    o_SEL  <= 4'b1111;
                end
                HALF : begin
                    o_DATA <= {i_LSU_DATA[15:0], i_LSU_DATA[15:0]};
                    case (i_LSU_ADDR[1:0])
                    2'b00 : begin
                        o_SEL  <= 4'b0011;        
                    end
                    2'b10 : begin
                        o_SEL  <= 4'b1100;
                    end
                    default : begin
                        o_SEL  <= 4'b0000;
                    end
                    endcase
                end
                BYTE : begin
                    o_DATA <= {i_LSU_DATA[7:0], i_LSU_DATA[7:0], i_LSU_DATA[7:0], i_LSU_DATA[7:0]};
                    case (i_LSU_ADDR[1:0])
                    2'b00 : begin
                        o_SEL  <= 4'b0001;
                    end
                    2'b01 : begin
                        o_SEL  <= 4'b0010;
                    end
                    2'b10 : begin
                        o_SEL  <= 4'b0100;
                    end
                    2'b11 : begin
                        o_SEL  <= 4'b1000;
                    end
                    default : begin
                        o_SEL  <= 4'b0000;
                    end
                    endcase
                end
                default : begin
                    o_DATA <= 0;
                    o_SEL  <= 4'b0000;
                end
                endcase
                o_WE   <= i_LSU_WE;
                o_ADDR <= i_LSU_ADDR;
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

always_comb begin
    o_LSU_GNT = i_ACK;
    o_TAGN = 1'b0;
    case (i_LSU_HB)
    WORD : begin
        o_LSU_DATA = i_DATA;
    end
    HALF : begin
        case (i_LSU_ADDR[1:0])
        2'b00 : begin
            o_LSU_DATA = {{16{i_DATA[15]}}, i_DATA[15:0]};
        end
        2'b10 : begin
            o_LSU_DATA = {{16{i_DATA[31]}}, i_DATA[31:16]};
        end
        default : begin
            o_LSU_DATA = 0;
        end
        endcase
    end
    BYTE : begin
        case (i_LSU_ADDR[1:0])
        2'b00 : begin
            o_LSU_DATA = {{24{i_DATA[7]}}, i_DATA[7:0]};
        end
        2'b01 : begin
            o_LSU_DATA = {{24{i_DATA[15]}}, i_DATA[15:8]};
        end
        2'b10 : begin
            o_LSU_DATA = {{24{i_DATA[23]}}, i_DATA[23:16]};
        end
        2'b11 : begin
            o_LSU_DATA = {{24{i_DATA[31]}}, i_DATA[31:24]};
        end
        default : begin
            o_LSU_DATA = 0;
        end
        endcase
    end
    default : begin
        o_LSU_DATA = 0;
    end
    endcase
end

endmodule