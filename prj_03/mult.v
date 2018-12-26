// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, MCND, MPLR);
	// output list
	output [31:0] HI;
	output [31:0] LO;
	// input list
	input [31:0] MCND;
	input [31:0] MPLR;

	wire [31:0] HI;
	wire [31:0] LO;

	wire [31:0] T1, T2; 
	wire [31:0] M1, M2;
	wire [31:0] HI_U, LO_U;
	wire [31:0] HI_S, LO_S;
	wire X;

	TWOSCOMP32 t1(T1, MCND);
	MUX32_2x1 m1(M1, MCND, T1, MCND[31]);

	TWOSCOMP32 t2(T2, MPLR);
	MUX32_2x1 m2(M2, MPLR, T2, MPLR[31]);

	MULT32_U mul_u(HI_U, LO_U, M1, M2);
	TWOSCOMP64 t3({HI_S, LO_S}, {HI_U, LO_U});

	xor xor1(X, MCND[31], MPLR[31]);

	MUX64_2x1 mux64({HI, LO}, {HI_U, LO_U}, {HI_S, LO_S}, X);

endmodule

module MULT32_U(HI, LO, A, B);
	// output list
	output [31:0] HI;
	output [31:0] LO;
	// input list
	input [31:0] A;
	input [31:0] B;

	wire [31:0] HI;
	wire [31:0] LO;
	
	wire [31:0] AND [31:0];
	wire [31:0] ADDER [30:0];
	wire [30:0] CO;
	
	AND32_2x1 and1({AND[0][31:1], LO[0]}, A, {32{B[0]}});
	AND32_2x1 and2(AND[1], A, {32{B[1]}});
	RC_ADD_SUB_32 rc1({ADDER[0][31:1], LO[1]}, CO[0], AND[1], {1'b0, AND[0][31:1]}, 1'b0);
	genvar i;	
	generate
		for (i = 2; i < 32; i = i + 1)
		begin : mult_u_loop
			AND32_2x1 and3(AND[i], A, {32{B[i]}});	
			RC_ADD_SUB_32 rc2({ADDER[i - 1][31:1], LO[i]}, CO[i - 1], AND[i], {CO[i - 2], ADDER[i - 2][31:1]}, 1'b0); // ADDER instance will have offset of -1
		end
	endgenerate
		
	generate
		for (i = 0; i < 31; i = i + 1)
		begin : buf_loop
			buf buf_inst(HI[i], ADDER[30][i + 1]);
		end
	endgenerate
	buf buf_inst(HI[31], CO[30]);
	
	
endmodule
