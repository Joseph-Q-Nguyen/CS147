`timescale 1ns/1ps

module HALF_ADDER_TB;
reg A, B;
wire Y, C;

HALF_ADDER hs_inst(.Y(Y), .C(C), .A(A), .B(B));

initial 
begin
	A = 0; B = 0;
	#5 A = 1; B = 0;
	#5 A = 0; B = 1;
	#5 A = 1; B = 1;
	#5 A = 0; B = 0;
end

endmodule

