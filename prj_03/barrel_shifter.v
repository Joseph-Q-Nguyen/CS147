// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [31:0] S;
	input LnR;
	
	wire [31:0] OUT, Y;
	wire OR;
	
	BARREL_SHIFTER32 bs(OUT,D,S[4:0], LnR);
	
	or or_inst(OR, S[31:5]);
	
	MUX32_2x1 mux(Y, OUT, 32'b0, OR); 
endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [4:0] S;
	input LnR;
	
	wire [31:0] L, R, Y;
	
	SHIFT32_L left_shift(L,D,S);
	SHIFT32_R right_shift(R,D,S);
	MUX32_2x1 mux(Y, R, L, LnR); 
endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [4:0] S;
	// output wire
	wire [31:0] Y;
	// Shift stage outputs
	wire [31:0] S0_OUT, S1_OUT, S2_OUT, S3_OUT;

	MUX32_2x1 S0_mux(S0_OUT, D, {1'b0, D[31:1]}, S[0]); 
	MUX32_2x1 s1_mux(S1_OUT, S0_OUT, {2'b0, S0_OUT[31:2]}, S[1]);
	MUX32_2x1 s2_mux(S2_OUT, S1_OUT, {4'b0, S1_OUT[31:4]}, S[2]);
	MUX32_2x1 s3_mux(S3_OUT, S2_OUT, {8'b0, S2_OUT[31:8]}, S[3]);
	MUX32_2x1 s4_mux(Y, S3_OUT, {16'b0, S3_OUT[31:16]}, S[4]);
endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [4:0] S;
	// output wire
	wire [31:0] Y;
	// Shift stage outputs
	wire [31:0] S0_OUT, S1_OUT, S2_OUT, S3_OUT;

	MUX32_2x1 S0_mux(S0_OUT, D, {D[30:0], 1'b0}, S[0]); 
	MUX32_2x1 s1_mux(S1_OUT, S0_OUT, {S0_OUT[29:0] , 2'b0}, S[1]);
	MUX32_2x1 s2_mux(S2_OUT, S1_OUT, {S1_OUT[27:0] , 4'b0}, S[2]);
	MUX32_2x1 s3_mux(S3_OUT, S2_OUT, {S2_OUT[23:0] , 8'b0}, S[3]);
	MUX32_2x1 s4_mux(Y, S3_OUT, {S3_OUT[15:0] , 16'b0}, S[4]);
endmodule

