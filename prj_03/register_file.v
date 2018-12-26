// Name: register_file.v (GATE LEVEL)
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

	// input list
	input READ, WRITE, CLK, RST;
	input [`DATA_INDEX_LIMIT:0] DATA_W;
	input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;
	
	// output list
	output [`DATA_INDEX_LIMIT:0] DATA_R1;
	output [`DATA_INDEX_LIMIT:0] DATA_R2;
	
	wire [`DATA_INDEX_LIMIT:0] DATA_R1;
	wire [`DATA_INDEX_LIMIT:0] DATA_R2;
	
	wire [31:0] D, AND;
	wire [31:0] REG [31:0];
	wire [31:0] MUX32_1, MUX32_2;
	
	DECODER_5x32 dc(D, ADDR_W);
	AND32_2x1 a32(AND, D, {32{WRITE}});
	
	genvar i; 
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : reg_loop
			REG32 r32(REG[i], DATA_W, AND[i], CLK, RST);
		end
	endgenerate
	
	MUX32_32x1 mux1(MUX32_1,	REG[0], REG[1], REG[2], REG[3], REG[4], REG[5], REG[6], REG[7],
								REG[8], REG[9], REG[10], REG[11], REG[12], REG[13], REG[14], REG[15],
								REG[16], REG[17], REG[18], REG[19], REG[20], REG[21], REG[22], REG[23],
								REG[24], REG[25], REG[26], REG[27], REG[28], REG[29], REG[30], REG[31], ADDR_R1);
					 
	MUX32_32x1 mux2(MUX32_2, 	REG[0], REG[1], REG[2], REG[3], REG[4], REG[5], REG[6], REG[7],
								REG[8], REG[9], REG[10], REG[11], REG[12], REG[13], REG[14], REG[15],
								REG[16], REG[17], REG[18], REG[19], REG[20], REG[21], REG[22], REG[23],
								REG[24], REG[25], REG[26], REG[27], REG[28], REG[29], REG[30], REG[31], ADDR_R2);	

	MUX32_2x1 mux3(DATA_R1, 32'hzzzzzzzz, MUX32_1, READ);
	MUX32_2x1 mux4(DATA_R2, 32'hzzzzzzzz, MUX32_2, READ);	

endmodule
