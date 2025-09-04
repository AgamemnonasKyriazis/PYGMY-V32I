module wb_interconnect_wrapper #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter N_MASTERS  = 2,
    parameter N_SLAVES   = 3
) (

    input  i_RST,
    input  i_CLK,

    input  [ADDR_WIDTH-1:0] i_s_ADDR_0,
    input  [DATA_WIDTH-1:0] i_s_DATA_0,
    output logic [DATA_WIDTH-1:0] o_s_DATA_0,
    input  [0:0] i_s_WE_0,
    input  [3:0] i_s_SEL_0,
    input  [0:0] i_s_STB_0,
    output logic [0:0] o_s_ACK_0,
    input  [0:0] i_s_CYC_0,
    input  [0:0] i_s_TAGN_0,
    output [0:0] o_s_TAGN_0,

    input  [ADDR_WIDTH-1:0] i_s_ADDR_1,
    input  [DATA_WIDTH-1:0] i_s_DATA_1,
    output logic [DATA_WIDTH-1:0] o_s_DATA_1,
    input  [0:0] i_s_WE_1,
    input  [3:0] i_s_SEL_1,
    input  [0:0] i_s_STB_1,
    output logic [0:0] o_s_ACK_1,
    input  [0:0] i_s_CYC_1,
    input  [0:0] i_s_TAGN_1,
    output [0:0] o_s_TAGN_1,

    output logic [ADDR_WIDTH-1:0] o_m_ADDR_0,
    output logic [DATA_WIDTH-1:0] o_m_DATA_0,
    input  [DATA_WIDTH-1:0] i_m_DATA_0,
    output logic [0:0] o_m_WE_0,
    output logic [3:0] o_m_SEL_0,
    output logic [0:0] o_m_STB_0,
    input  [0:0] i_m_ACK_0,
    output logic [0:0] o_m_CYC_0,
    output logic [0:0] o_m_TAGN_0,
    input  [0:0] i_m_TAGN_0,

    output logic [ADDR_WIDTH-1:0] o_m_ADDR_1,
    output logic [DATA_WIDTH-1:0] o_m_DATA_1,
    input  [DATA_WIDTH-1:0] i_m_DATA_1,
    output logic [0:0] o_m_WE_1,
    output logic [3:0] o_m_SEL_1,
    output logic [0:0] o_m_STB_1,
    input  [0:0] i_m_ACK_1,
    output logic [0:0] o_m_CYC_1,
    output logic [0:0] o_m_TAGN_1,
    input  [0:0] i_m_TAGN_1,


    output logic [ADDR_WIDTH-1:0] o_m_ADDR_2,
    output logic [DATA_WIDTH-1:0] o_m_DATA_2,
    input  [DATA_WIDTH-1:0] i_m_DATA_2,
    output logic [0:0] o_m_WE_2,
    output logic [3:0] o_m_SEL_2,
    output logic [0:0] o_m_STB_2,
    input  [0:0] i_m_ACK_2,
    output logic [0:0] o_m_CYC_2,
    output logic [0:0] o_m_TAGN_2,
    input  [0:0] i_m_TAGN_2
);

wb_interconnect #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .N_MASTERS(N_MASTERS),
    .N_SLAVES(N_SLAVES)
) wb_ic (
    .i_RST(i_RST),
    .i_CLK(i_CLK),

    .i_s_ADDR({i_s_ADDR_1, i_s_ADDR_0}),
    .i_s_DATA({i_s_DATA_1, i_s_DATA_0}),
    .o_s_DATA({o_s_DATA_1, o_s_DATA_0}),
    .i_s_WE({i_s_WE_1, i_s_WE_0}),
    .i_s_SEL({i_s_SEL_1, i_s_SEL_0}),
    .i_s_STB({i_s_STB_1, i_s_STB_0}),
    .o_s_ACK({o_s_ACK_1, o_s_ACK_0}),
    .i_s_CYC({i_s_CYC_1, i_s_CYC_0}),
    .i_s_TAGN({i_s_TAGN_1, i_s_TAGN_0}),
    .o_s_TAGN({o_s_TAGN_1, o_s_TAGN_0}),

    .o_m_ADDR({o_m_ADDR_2, o_m_ADDR_1, o_m_ADDR_0}),
    .o_m_DATA({o_m_DATA_2, o_m_DATA_1, o_m_DATA_0}),
    .i_m_DATA({i_m_DATA_2, i_m_DATA_1, i_m_DATA_0}),
    .o_m_WE({o_m_WE_2, o_m_WE_1, o_m_WE_0}),
    .o_m_SEL({o_m_SEL_2, o_m_SEL_1, o_m_SEL_0}),
    .o_m_STB({o_m_STB_2, o_m_STB_1, o_m_STB_0}),
    .i_m_ACK({i_m_ACK_2, i_m_ACK_1, i_m_ACK_0}),
    .o_m_CYC({o_m_CYC_2, o_m_CYC_1, o_m_CYC_0}),
    .o_m_TAGN({o_m_TAGN_2, o_m_TAGN_1, o_m_TAGN_0}),
    .i_m_TAGN({i_m_TAGN_2, i_m_TAGN_1, i_m_TAGN_0})
);

endmodule