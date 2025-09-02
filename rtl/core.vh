parameter [31:0] VENDOR_ID  = 32'h00000000;
parameter [31:0] ARCH_ID    = 32'h00000000;
parameter [31:0] IMPL_ID    = 32'h00000000;    
parameter [31:0] HART_ID    = 32'h00000000;
parameter [31:0] ISA        = 32'h00000000;

localparam [31:0] RESET_VECTOR  = 32'h80000000;

localparam [7:0] CORE_STATE_EXEC = (8'b1 << 0);
localparam [7:0] CORE_STATE_TRAP = (8'b1 << 1);
localparam [7:0] CORE_STATE_HALT = (8'b1 << 2);

/* Instructions */
localparam [31:0] NOOP      =   32'h00000013;
localparam [31:0] WFI       =   32'h10500073;
localparam [31:0] MRET      =   32'h30200073;

localparam [6:0] ALU_R      =   7'b0110011;
localparam [6:0] ALU_I      =   7'b0010011;
localparam [6:0] LOAD       =   7'b0000011;
localparam [6:0] STORE      =   7'b0100011;
localparam [6:0] BRANCH     =   7'b1100011;
localparam [6:0] JAL        =   7'b1101111;
localparam [6:0] JALR       =   7'b1100111;
localparam [6:0] LUI        =   7'b0110111;
localparam [6:0] AUIPC      =   7'b0010111;
localparam [6:0] ECALL      =   7'b1110011;
localparam [6:0] SYSTEM     =   7'b1110011;