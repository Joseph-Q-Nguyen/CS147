// Name: mux.v
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

// 64-bit 2x1 mux
module MUX64_2x1(Y, I0, I1, S);
	// output list
	output [63:0] Y;
	//input list
	input [63:0] I0, I1;
	input S;

	wire [63:0] Y;
	
	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1)
		begin : mux64_loop
			MUX1_2x1 mux(Y[i], I0[i], I1[i], S);
		end
	endgenerate
	
endmodule

// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
	// output list
	output [31:0] Y;
	//input list
	input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
	input [31:0] I8, I9, I10, I11, I12, I13, I14, I15;
	input [31:0] I16, I17, I18, I19, I20, I21, I22, I23;
	input [31:0] I24, I25, I26, I27, I28, I29, I30, I31;
	input [4:0] S;

	wire [31:0] MUX1;
	wire [31:0] MUX2;
	
	MUX32_16x1 M1(MUX1, I0, I1, I2, I3, 
						I4, I5, I6, I7, 
						I8, I9, I10, I11, 
						I12, I13, I14, I15, S[3:0]);
	MUX32_16x1 M2(MUX2, I16, I17, I18, I19, 
						I20, I21, I22, I23, 
						I24, I25, I26, I27, 
						I28, I29, I30, I31, S[3:0]);
	
	MUX32_2x1 M3(Y, MUX1, MUX2, S[4]);
	
endmodule

// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
	// output list
	output [31:0] Y;
	//input list
	input [31:0] I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15;
	input [3:0] S;

	wire [31:0] MUX1;
	wire [31:0] MUX2;
	
	MUX32_8x1 M1(MUX1, I0, I1, I2, I3, I4, I5, I6, I7, S[2:0]);
	MUX32_8x1 M2(MUX2, I8, I9, I10, I11, I12, I13, I14, I15, S[2:0]);
	
	MUX32_2x1 M3(Y, MUX1, MUX2, S[3]);

endmodule

// 32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
	// output list
	output [31:0] Y;
	//input list
	input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
	input [2:0] S;

	wire [31:0] MUX1;
	wire [31:0] MUX2;
	
	MUX32_4x1 M1(MUX1, I0, I1, I2, I3, S[1:0]);
	MUX32_4x1 M2(MUX2, I4, I5, I6, I7, S[1:0]);
	
	MUX32_2x1 M3(Y, MUX1, MUX2, S[2]);

endmodule

// 32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
	// output list
	output [31:0] Y;
	//input list
	input [31:0] I0;
	input [31:0] I1;
	input [31:0] I2;
	input [31:0] I3;
	input [1:0] S;

	wire [31:0] MUX1;
	wire [31:0] MUX2;
	
	MUX32_2x1 M1(MUX1, I0, I1, S[0]);
	MUX32_2x1 M2(MUX2, I2, I3, S[0]);
	
	MUX32_2x1 M3(Y, MUX1, MUX2, S[1]);

endmodule

// 32-bit mux
module MUX32_2x1(Y, I0, I1, S);
	// output list
	output [31:0] Y;
	//input list
	input [31:0] I0;
	input [31:0] I1;
	input S;
	
	wire [31:0] Y;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : mux_loop
			MUX1_2x1 mux(Y[i], I0[i], I1[i], S);
		end
	endgenerate

endmodule

// 1-bit mux
module MUX1_2x1(Y, I0, I1, S);
	//output list
	output Y;
	//input list
	input I0, I1, S;

	wire S_NOT_AND_I0, S_AND_I1, S_NOT;

	not (S_NOT, S);
	and (S_NOT_AND_I0, S_NOT, I0);
	and (S_AND_I1, S, I1);
	or (Y, S_NOT_AND_I0, S_AND_I1);
endmodule
