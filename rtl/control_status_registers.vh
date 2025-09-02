/* Machine Information */
localparam  [31:0]  MVENDORID   = 32'hf11;  /* Vendor Id */
localparam  [31:0]  MARCHID     = 32'hf12;  /* Architecture Id */
localparam  [31:0]  MIMPID      = 32'hf13;  /* Implementation Id */
localparam  [31:0]  MHARTID     = 32'hf14;  /* Hardware Thread Id */

/* Machine Trap Setup */
localparam  [31:0]  MSTATUS     = 32'h300;  /* Machine Status */
localparam  [31:0]  MISA        = 32'h301;  /* ISA and Extensions */
localparam  [31:0]  MIE         = 32'h304;  /* Interrupt-enable */
localparam  [31:0]  MTVEC       = 32'h305;  /* Trap-handler Base Address */

/* Machine Trap Handling */
localparam  [31:0]  MSCRATCH    = 32'h340;  /* Srcatchpad */
localparam  [31:0]  MEPC        = 32'h341;  /* Exception Program-counter */
localparam  [31:0]  MCAUSE      = 32'h342;  /* Trap Cause */
localparam  [31:0]  MTVAL       = 32'h343;  /* Trap Value */
localparam  [31:0]  MIP         = 32'h344;  /* Interrupt Pending */

/* Machine Counter/Timers */
localparam  [31:0]  MCYCLE      = 32'hB00;  /* Cycles Low 32-bit */
localparam  [31:0]  MCYCLEH     = 32'hB80;  /* Cycles High 32-bit */