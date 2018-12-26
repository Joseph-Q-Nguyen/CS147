// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(S, CO, A, B, SnA);
	// output list
	output [63:0] S;
	output CO;
	// input list
	input [63:0] A;
	input [63:0] B;
	input SnA;
	
	wire [63:0] S;
	wire CO;
	
	wire [63:0] CO_STAGE, B_SnA;
	
	xor xor_inst(B_SnA[0], B[0], SnA);
	FULL_ADDER fa_inst(S[0], CO_STAGE[0], A[0], B_SnA[0], SnA);
	genvar i;
	generate
		for (i = 1; i < 64; i = i + 1)
		begin
				xor xor_inst(B_SnA[i], B[i], SnA);
				FULL_ADDER fa_inst2(S[i], CO_STAGE[i], A[i], B_SnA[i], CO_STAGE[i - 1]);
		end
	endgenerate
	buf buf_inst(CO, CO_STAGE[63]);
endmodule

module RC_ADD_SUB_32(S, CO, A, B, SnA);
	// output list
	output [`DATA_INDEX_LIMIT:0] S;
	output CO;
	// input list
	input [`DATA_INDEX_LIMIT:0] A;
	input [`DATA_INDEX_LIMIT:0] B;
	input SnA;
	
	wire [`DATA_INDEX_LIMIT:0] S;
	wire CO;
	
	wire [`DATA_INDEX_LIMIT:0] CO_STAGE, B_SnA;
	
	xor xor_inst(B_SnA[0], B[0], SnA);
	FULL_ADDER fa_inst(S[0], CO_STAGE[0], A[0], B_SnA[0], SnA);
	genvar i;
	generate
		for (i = 1; i < 32; i = i + 1)
		begin
				xor xor_inst(B_SnA[i], B[i], SnA);
				FULL_ADDER fa_inst2(S[i], CO_STAGE[i], A[i], B_SnA[i], CO_STAGE[i - 1]);
		end
	endgenerate
	buf buf_inst(CO, CO_STAGE[31]);
endmodule

