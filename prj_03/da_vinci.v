// Name: da_vinci.v
// Module: DA_VINCI
// 
// Outputs are for testbench observations only
//
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//          READ : Read signal
//          WRITE: Write signal
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit bareminimum computer system DA_VINCI_v1.0 implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module DA_VINCI (MEM_DATA_OUT, MEM_DATA_IN, ADDR, READ, WRITE, CLK, RST);
// Parameter for the memory initialization file name
parameter mem_init_file = "mem_content_01.dat";
// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output [`DATA_INDEX_LIMIT:0] MEM_DATA_OUT, MEM_DATA_IN;
output READ, WRITE;
// input list
input  CLK, RST;

// Instance section
// Processor instanceIN
PROC_CS147_SEC05 processor_inst(.DATA_IN(MEM_DATA_OUT),   .DATA_OUT(MEM_DATA_IN),
                                .ADDR(ADDR), .READ(READ), 
                                .WRITE(WRITE), .CLK(CLK),   .RST(RST));
// memory instance
defparam memory_inst.mem_init_file = mem_init_file;
MEMORY_WRAPPER memory_inst(.DATA_OUT(MEM_DATA_OUT), .DATA_IN(MEM_DATA_IN), 
                           .READ(READ), .WRITE(WRITE), 
                           .ADDR(ADDR), .CLK(CLK),   .RST(RST));
endmodule;