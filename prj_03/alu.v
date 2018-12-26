`include "prj_definition.v"
module ALU(OUT, ZERO, A, B, OPRN);
	// input list
	input [`DATA_INDEX_LIMIT:0] A; // operand 1
	input [`DATA_INDEX_LIMIT:0] B; // operand 2
	input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code
	
	// output list
	output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
	output ZERO;
	
	// output wires
	wire [`DATA_INDEX_LIMIT:0] OUT; 
	wire ZERO;
	
	// gate wires
	wire [31:0] MUL, SHFT, ADD_SUB, AND, OR, NOR; 
	
	// don't-cares wires
	wire [31:0] X;
	wire XX;
	
	wire SnA, T1, T2;
		
	MULT32 mul(X, MUL, A, B);
	
	SHIFT32 shift(SHFT, A, B, OPRN[0]); // LnR = OPRN[0]
	
	// SnA
	not not_inst(T1, OPRN[0]);
	and and_inst(T2, OPRN[3], OPRN[0]);
	or or_inst(SnA, T1, T2);
	
	RC_ADD_SUB_32 add_sub(ADD_SUB, XX, A, B, SnA);
	
	AND32_2x1 and_inst2(AND, A, B);
	OR32_2x1 or_inst2(OR, A, B);
	NOR32_2x1 nor_inst(NOR, A, B);
	
	MUX32_16x1 mux(OUT, X, ADD_SUB, ADD_SUB, MUL, SHFT, SHFT, AND, OR, NOR, {{31{1'b0}}, ADD_SUB[31]}, X, X, X, X, X, X, OPRN[3:0]);
	
	// zero flag
	nor nor_inst2(ZERO, 
		OUT[0], OUT[1], OUT[2], OUT[3], OUT[4], OUT[5], OUT[6], OUT[7], 
		OUT[8], OUT[9], OUT[10], OUT[11], OUT[12], OUT[13], OUT[14], OUT[15], 
		OUT[16], OUT[17], OUT[18], OUT[19], OUT[20], OUT[21], OUT[22], OUT[23], 
		OUT[24], OUT[25], OUT[26], OUT[27], OUT[28], OUT[29], OUT[30], OUT[31]);
endmodule
