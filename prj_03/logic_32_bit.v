// 32-bit BUF
module BUF32(Y, A);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : buf_loop
			buf buf1(Y[i], A[i]);
		end
	endgenerate

endmodule

// 32-bit NOR
module NOR32_2x1(Y,A,B);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	input [31:0] B;

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : nor_loop
			nor nor_inst(Y[i], A[i], B[i]);
		end
	endgenerate

endmodule

// 32-bit AND
module AND32_2x1(Y,A,B);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	input [31:0] B;

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : and_loop
			and and_inst(Y[i], A[i], B[i]);
		end
	endgenerate

endmodule

// 32-bit inverter
module INV32_1x1(Y,A);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : inv_loop
			not inv_inst(Y[i], A[i]);
		end
	endgenerate

endmodule

// 32-bit OR
module OR32_2x1(Y,A,B);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	input [31:0] B;

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : or_loop
			or or_inst(Y[i], A[i], B[i]);
		end
	endgenerate

endmodule
