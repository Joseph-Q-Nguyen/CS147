`timescale 1ns/1ps

module MULT32_TB;
reg [31:0] A, B;
wire [31:0] HI; 
wire [31:0] LO;

MULT32 mult32_inst(HI, LO, A, B);

initial 
begin
	A = 0; B = 0;
	#5 A = 0; B = 1;
	#5 A = 0; B = 5;
	#5 A = 1; B = 10;
	#5 A = 1; B = -2;
	#5 A = -2; B = 3;
	#5 A = 3; B = -4;
	#5 A = -4; B = 5;
	#5 A = -5; B = -6;
	#5 A = 0; B = 0;
end

endmodule



