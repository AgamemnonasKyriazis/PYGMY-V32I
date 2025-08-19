localparam [31:0] CORE_RESET_VECTOR = 32'h80000000;

localparam [7:0] CORE_STATE_EXEC = (8'b1 << 0);
localparam [7:0] CORE_STATE_TRAP = (8'b1 << 1);
localparam [7:0] CORE_STATE_HALT = (8'b1 << 2);