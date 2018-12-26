// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y,A);
	//output list
	output [63:0] Y;
	//input list
	input [63:0] A;

	wire [63:0] Y;
	wire [63:0] A_INV;
	wire CO;

	INV32_1x1 inv1(A_INV[63:32], A[63:32]);
	INV32_1x1 inv2(A_INV[31:0], A[31:0]);
	RC_ADD_SUB_64 adder(Y, CO, A_INV, 64'b1, 1'b0);

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
	//output list
	output [31:0] Y;
	//input list
	input [31:0] A;

	wire [31:0] Y;
	wire [31:0] A_INV;
	wire CO;

	INV32_1x1 inv(A_INV, A);
	RC_ADD_SUB_32 adder(Y, CO, A_INV, 32'b1, 1'b0);

endmodule

// 32-bit register with preset value
module REG32_PRE(Q, D, LOAD, CLK, RESET, VALUE);
	output [31:0] Q;

	input CLK, LOAD;
	input [31:0] D, VALUE;
	input RESET;
	
	wire [31:0] Q, X1, X2;
	wire [31:0] B0, B1;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : reg_loop
			REG1 r0(B0[i], X1[i], D[i], LOAD, CLK, 1'b1, RESET);
			REG1 r1(B1[i], X2[i], D[i], LOAD, CLK, RESET, 1'b1);
			MUX1_2x1 m(Q[i], B0[i], B1[i], VALUE[i]);
		end
	endgenerate
endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
	output [31:0] Q;
	
	input CLK, LOAD;
	input [31:0] D;
	input RESET;
	
	wire [31:0] Q, X;

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : reg_loop
			REG1 r(Q[i], X[i], D[i], LOAD, CLK, 1'b1, RESET);
		end
	endgenerate

endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
	input D, C, L;
	input nP, nR;
	output Q,Qbar;
	
	wire Q, Qbar;
	
	wire MUX;
	MUX1_2x1 mux (MUX, Q, D, L);
	
	D_FF df(Q, Qbar, MUX, C, nP, nR);

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
	input D, C;
	input nP, nR;
	output Q,Qbar;
	
	wire Q, Qbar;
	wire Y, Ybar;
	
	wire C_INV;
	not not1(C_INV, C);
	
	D_LATCH d(Y, Ybar, D, C, nP, nR);
	SR_LATCH s(Q, Qbar, Y, Ybar, C_INV, nP, nR);

endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
	input D, C;
	input nP, nR;
	output Q,Qbar;
	
	wire Q, Qbar;
	
	wire D_INV;
	not not1(D_INV, D);
	
	SR_LATCH sr(Q, Qbar, D, D_INV, C, nP, nR);
	
endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
	input S, R, C;
	input nP, nR;
	output Q,Qbar;
	
	wire Q,Qbar;
	wire N1, N2, N3, N4;
	
	nand nand1(N1, S, C);
	nand nand2(N2, R, C);
	nand nand3(Q, N1, Qbar, nP);
	nand nand4(Qbar, N2, Q, nR);
	
endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
	// output
	output [31:0] D;
	// input
	input [4:0] I;

	wire [31:0] D;
	
	wire [15:0] LD;
	wire INV;
	
	DECODER_4x16 ld(LD, I[3:0]);
	not n1(INV, I[4]);
	
	genvar i; 
	generate
		for (i = 0; i < 16; i = i + 1)
		begin : loop1
			and a1(D[i], LD[i], INV);
		end
	endgenerate
	
	generate
		for (i = 16; i < 32; i = i + 1)
		begin : loop2
			and a2(D[i], LD[i - 16], I[4]);
		end
	endgenerate
endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
	// output
	output [15:0] D;
	// input
	input [3:0] I;
	
	wire [15:0] D;
	
	wire [7:0] LD;
	wire INV;
	
	DECODER_3x8 ld(LD, I[2:0]);
	not n1(INV, I[3]);
	
	genvar i; 
	generate
		for (i = 0; i < 8; i = i + 1)
		begin : loop1
			and a1(D[i], LD[i], INV);
		end
	endgenerate
	
	generate
		for (i = 8; i < 16; i = i + 1)
		begin : loop2
			and a2(D[i], LD[i - 8], I[3]);
		end
	endgenerate
endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
	// output
	output [7:0] D;
	// input
	input [2:0] I;
	
	wire [7:0] D;
	
	wire [3:0] LD; //2x4 line decoder output
	wire INV;
	
	DECODER_2x4 ld(LD, I[1:0]);
	not n1(INV, I[2]);
	
	genvar i; 
	generate
		for (i = 0; i < 4; i = i + 1)
		begin : loop1
			and a1(D[i], LD[i], INV);
		end
	endgenerate
	
	generate
		for (i = 4; i < 8; i = i + 1)
		begin : loop2
			and a2(D[i], LD[i - 4], I[2]);
		end
	endgenerate
	
endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
	// output
	output [3:0] D;
	// input
	input [1:0] I;
	
	wire [3:0] D;
	wire INV1, INV2;
		
	not n1(INV1, I[1]);
	not n2(INV2, I[0]);
	
	and a1(D[0], INV1, INV2);
	and a2(D[1], INV1, I[0]);
	and a3(D[2], I[1], INV2);
	and a4(D[3], I[1], I[0]);

endmodule