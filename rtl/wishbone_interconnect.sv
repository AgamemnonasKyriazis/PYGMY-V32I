module wb_interconnect #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter N_MASTERS  = 2,
    parameter N_SLAVES   = 2
) (

    input  i_RST,
    input  i_CLK,

    input  [N_MASTERS-1:0] [ADDR_WIDTH-1:0] i_s_ADDR,
    input  [N_MASTERS-1:0] [DATA_WIDTH-1:0] i_s_DATA,
    output logic [N_MASTERS-1:0] [DATA_WIDTH-1:0] o_s_DATA,
    input  [N_MASTERS-1:0] i_s_WE,
    input  [N_MASTERS-1:0] [3:0] i_s_SEL,
    input  [N_MASTERS-1:0] i_s_STB,
    output logic [N_MASTERS-1:0] o_s_ACK,
    input  [N_MASTERS-1:0] i_s_CYC,
    input  [N_MASTERS-1:0] i_s_TAGN,
    output [N_MASTERS-1:0] o_s_TAGN,

    output logic [N_SLAVES-1:0] [ADDR_WIDTH-1:0] o_m_ADDR,
    output logic [N_SLAVES-1:0] [DATA_WIDTH-1:0] o_m_DATA,
    input  [N_SLAVES-1:0] [DATA_WIDTH-1:0] i_m_DATA,
    output logic [N_SLAVES-1:0] o_m_WE,
    output logic [N_SLAVES-1:0] [3:0] o_m_SEL,
    output logic [N_SLAVES-1:0] o_m_STB,
    input  [N_SLAVES-1:0] i_m_ACK,
    output logic [N_SLAVES-1:0] o_m_CYC,
    output logic [N_SLAVES-1:0] o_m_TAGN,
    input  [N_SLAVES-1:0] i_m_TAGN
);

typedef enum {
    IDLE,
    TRANS,
    WAIT_ACK
} state_t;

state_t m_state, s_state;

initial begin
    source = 0;
end

int source;
int target;
logic [ADDR_WIDTH-1:0] source_address;
logic [ADDR_WIDTH-1:0] target_address;
logic [3:0] target_index;

assign source_address = i_s_ADDR[source];
assign target_index = source_address[31:28];
assign target_address = source_address[27:0];

always_comb begin
    target = 0;
    case (target_index)
    4'h8 : begin
        target = 0;
    end
    4'h9 : begin
        target = 1;
    end
    4'hA : begin
        target = 2;
    end
    endcase
end

always_ff @(posedge i_CLK) begin
    if (i_RST) begin
        s_state <= IDLE;
    end
    else begin
        case (s_state)
        IDLE : begin
            if (i_s_CYC[0] & i_s_STB[0]) begin
                source  <= 0;
                s_state <= TRANS; 
            end
            else if (i_s_CYC[1] & i_s_STB[1]) begin
                source  <= 1;
                s_state <= TRANS;
            end
        end
        TRANS : begin
            s_state <= WAIT_ACK;
        end
        WAIT_ACK : begin
            if (i_m_ACK[target]) begin
                s_state <= IDLE;
            end
        end
        endcase
    end
end

always_ff @(posedge i_CLK) begin
    if (i_RST) begin
        m_state <= IDLE;
    end
    else begin
        case (m_state)
        IDLE : begin
            if ( (s_state == TRANS) && i_s_CYC[source] & i_s_STB[source]) begin
                m_state <= TRANS; 
            end 
        end
        TRANS : begin
            m_state <= WAIT_ACK;
        end
        WAIT_ACK : begin
            if (i_m_ACK[target]) begin
                m_state <= IDLE;
            end
        end
        endcase
    end
end

always_comb begin
    for (int t = 0; t < N_SLAVES; t += 1) begin
        if (t == target && (m_state == TRANS || m_state == WAIT_ACK)) begin
            o_m_ADDR[t] = target_address;
            o_m_DATA[t] = i_s_DATA[source];
            o_m_SEL[t]  = i_s_SEL[source];
            o_m_WE[t]   = i_s_WE[source];
            o_m_CYC[t]  = i_s_CYC[source];
            o_m_STB[t]  = i_s_STB[source];
        end
        else begin
            o_m_ADDR[t] = 32'd0;
            o_m_DATA[t] = 32'd0;
            o_m_SEL[t]  = 32'd0;
            o_m_WE[t]   = 32'd0;
            o_m_CYC[t]  = 32'd0;
            o_m_STB[t]  = 32'd0;
        end
    end
end

always_comb begin
    for (int s = 0; s < N_MASTERS; s += 1) begin
        if (s == source) begin
            o_s_DATA[s] = i_m_DATA[target];
            o_s_ACK[s]  = i_m_ACK[target];
        end
        else begin
            o_s_DATA[s] = 32'd0;
            o_s_ACK[s]  = 1'b0;
        end
    end
end

initial begin
    // $monitor("[%0t] [WB_IC] %0x%0x%0x", $time, o_m_ADDR[2],o_m_ADDR[1],o_m_ADDR[0]);
end

endmodule