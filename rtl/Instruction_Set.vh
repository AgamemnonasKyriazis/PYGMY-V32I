localparam [31:0] NOOP      =   32'h00000013;
localparam [31:0] WFI       =   32'h10500073;

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