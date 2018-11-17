// Name: processor.v
// Module: PROC_CS147_SEC05
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//          READ : Read signal
//          WRITE: Write signal
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Fixed the RF connection
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module PROC_CS147_SEC05(DATA_OUT, ADDR, DATA_IN, READ, WRITE, CLK, RST);
// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output [`DATA_INDEX_LIMIT:0] DATA_OUT;
output READ, WRITE;
// input list
input  CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

// net section
wire zero;
wire [`CTRL_WIDTH_INDEX_LIMIT:0] ctrl;
wire [`DATA_INDEX_LIMIT:0] INSTRUCTION;

// instantiation section
// Control unit
CONTROL_UNIT cu_inst (.CTRL(ctrl), .READ(READ), .WRITE(WRITE), 
                      .ZERO(zero), .INSTRUCTION(INSTRUCTION),
                      .CLK(CLK),   .RST(RST));

// data path
DATA_PATH    data_path_inst (.DATA_OUT(DATA_OUT),  .INSTRUCTION(INSTRUCTION), .DATA_IN(DATA_IN), .ADDR(ADDR), .ZERO(zero),
                             .CTRL(ctrl),  .CLK(CLK),   .RST(RST));

endmodule;