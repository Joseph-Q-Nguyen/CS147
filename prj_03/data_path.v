// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
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
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

	// output list
	output [`ADDRESS_INDEX_LIMIT:0] ADDR;
	output ZERO;
	output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;
	
	// input list
	input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
	input CLK, RST;
	input [`DATA_INDEX_LIMIT:0] DATA_IN;
	
	wire x1, x2; // don't care
	wire [5:0] x3;
	wire [31:0] ADD1, ADD2;
	
//	wire [31:0] ADD1, ADD2, B_16_BIT_SIGN_EXT, PC_LOAD, PC_SEL_3, PC_SEL_1, 
//				R1_DATA, PC_SEL_2, B_6_BIT_ZERO_EXT, IR_LOAD, R1_SEL_1, RS,
//				R2_DATA, RT, WA_SEL_3, WD_SEL
	
	wire [31:0] PC_LOAD, PC_SEL_1, PC_SEL_2, PC_SEL_3,
				IR_LOAD, MEM_R, MEM_W, R1_SEL_1, REG_R,
				REG_W, WA_SEL_1, WA_SEL_2, WA_SEL_3,
				WD_SEL_1, WD_SEL_2, WD_SEL_3, SP_LOAD,
				OP1_SEL_1, OP2_SEL_1, OP2_SEL_2, OP2_SEL_3,
				OP2_SEL_4, ALU_OPRN, MA_SEL_1, MA_SEL_2, MD_SEL_1,	
				R1_DATA, R2_DATA;
	
	wire [31:0] BIT_6_ZERO_EXT, BIT_27_ZERO_EXT, BIT_16_SIGN_EXT,
				BIT_16_ZERO_EXT, BIT_16_LSB_ZERO_EXT;
				
	wire [5:0] OPCODE;
	wire [4:0] RS;
	wire [4:0] RT;
	wire [4:0] RD;
	wire [4:0] SHAMT;
	wire [5:0] FUNCT;
	wire [15:0] IMM;
	wire [25:0] ADDRESS;
	
	
	wire [31:0] ALU;
	
	
	REG32_PRE pc(PC_LOAD, PC_SEL_3, CTRL[0], CLK, RST, 32'h00001000);
	
	RC_ADD_SUB_32 r1(ADD1, x1, PC_LOAD, 32'b1, 1'b0);
	RC_ADD_SUB_32 r2(ADD2, x2, ADD1, BIT_16_SIGN_EXT, 1'b0);
	
	MUX32_2x1 m2(PC_SEL_1, R1_DATA, ADD1, CTRL[1]);
	MUX32_2x1 m3(PC_SEL_2, PC_SEL_1, ADD2, CTRL[2]);
	MUX32_2x1 m4(PC_SEL_3, BIT_6_ZERO_EXT, PC_SEL_2, CTRL[3]);
	
	REG32 ir(IR_LOAD, DATA_IN, CTRL[4], CLK, RST);
	BUF32 inst(INSTRUCTION, IR_LOAD);
	
	BUF32 b1({OPCODE, RS, RT, RD, SHAMT, FUNCT}, INSTRUCTION);

	BUF32 b2({OPCODE, RS, RT, IMM}, INSTRUCTION);

	BUF32 b3({OPCODE, ADDRESS}, INSTRUCTION);

	BUF32 buf4(BIT_6_ZERO_EXT, {6'b0, ADDRESS});
	BUF32 buf5(BIT_27_ZERO_EXT,{27'b0, SHAMT});
	BUF32 buf6(BIT_16_SIGN_EXT, {{16{IMM[15]}}, IMM});
	BUF32 buf7(BIT_16_ZERO_EXT, {16'b0, IMM});
	BUF32 buf8(BIT_16_LSB_ZERO_EXT, {IMM, 16'b0});
	
	MUX32_2x1 m6(R1_SEL_1, {27'b0, RS}, 32'b0, CTRL[7]);
	REGISTER_FILE_32x32 rf(R1_DATA, R2_DATA, R1_SEL_1[4:0], RT[4:0], 
                            WD_SEL_3, WA_SEL_3[4:0], CTRL[8], CTRL[9], CLK, RST);
	MUX32_2x1 m7(WA_SEL_1, {27'b0, RD}, {27'b0, RT}, CTRL[10]);
	MUX32_2x1 m8(WA_SEL_2, 0, 31, CTRL[11]);
	MUX32_2x1 m9(WA_SEL_3, WA_SEL_2, WA_SEL_1, CTRL[12]);
	MUX32_2x1 m10(WD_SEL_1, ALU, DATA_IN, CTRL[13]);
	MUX32_2x1 m11(WD_SEL_2, WD_SEL_1, BIT_16_LSB_ZERO_EXT, CTRL[14]);
	MUX32_2x1 m12(WD_SEL_3, ADD1, WD_SEL_2, CTRL[15]);
	REG32_PRE sp(SP_LOAD, ALU, CTRL[16], CLK, RST, 32'h03ffffff);
	MUX32_2x1 m14(OP1_SEL_1, R1_DATA, SP_LOAD, CTRL[17]);
	MUX32_2x1 m15(OP2_SEL_1, 1, BIT_27_ZERO_EXT, CTRL[18]);
	MUX32_2x1 m16(OP2_SEL_2, BIT_16_ZERO_EXT, BIT_16_SIGN_EXT, CTRL[19]);
	MUX32_2x1 m17(OP2_SEL_3, OP2_SEL_2, OP2_SEL_1, CTRL[20]);
	MUX32_2x1 m18(OP2_SEL_4, OP2_SEL_3, R2_DATA, CTRL[21]);
	ALU alu(ALU, ZERO, OP2_SEL_4, OP1_SEL_1, {2'b0, CTRL[25:22]});
	MUX32_2x1 m19(MA_SEL_1, ALU, SP_LOAD, CTRL[26]);
	MUX32_2x1 m20({x3, ADDR}, MA_SEL_1, PC_LOAD, CTRL[27]);
	MUX32_2x1 m21(DATA_OUT, R2_DATA, R1_DATA, CTRL[28]);
	

	
	

endmodule
