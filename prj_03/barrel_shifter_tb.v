`timescale 1ns/1ps

module SHIFT32_TB;

reg [31:0] A;
reg [31:0] S;
reg LnR;
wire [31:0] Y; 


SHIFT32 shifter(Y,A,S, LnR);

initial 
begin
	A = 0; S = 0; LnR = 0;
	#5 A = 1 << 31; S = 0; LnR = 0;
	#5 A = 1 << 31; S = 1; LnR = 0;
	#5 A = 1 << 31; S = 2; LnR = 0;
	#5 A = 1 << 31; S = 3; LnR = 0;
	#5 A = 1 << 31; S = 4; LnR = 0;
	#5 A = 1 << 31; S = 5; LnR = 0;
	#5 A = 1 << 31; S = 6; LnR = 0;
	#5 A = 1 << 31; S = 7; LnR = 0;
	#5 A = 1 << 31; S = 8; LnR = 0;
	#5 A = 1 << 31; S = 9; LnR = 0;
	#5 A = 1 << 31; S = 10; LnR = 0;
	#5 A = 1 << 31; S = 11; LnR = 0;
	#5 A = 1 << 31; S = 12; LnR = 0;
	#5 A = 1 << 31; S = 13; LnR = 0;
	#5 A = 1 << 31; S = 14; LnR = 0;
	#5 A = 1 << 31; S = 15; LnR = 0;
	#5 A = 1 << 31; S = 16; LnR = 0;
	#5 A = 1 << 31; S = 17; LnR = 0;
	#5 A = 1 << 31; S = 18; LnR = 0;
	#5 A = 1 << 31; S = 19; LnR = 0;
	#5 A = 1 << 31; S = 20; LnR = 0;
	#5 A = 1 << 31; S = 21; LnR = 0;
	#5 A = 1 << 31; S = 22; LnR = 0;
	#5 A = 1 << 31; S = 23; LnR = 0;
	#5 A = 1 << 31; S = 24; LnR = 0;
	#5 A = 1 << 31; S = 25; LnR = 0;
	#5 A = 1 << 31; S = 26; LnR = 0;
	#5 A = 1 << 31; S = 27; LnR = 0;
	#5 A = 1 << 31; S = 28; LnR = 0;
	#5 A = 1 << 31; S = 29; LnR = 0;
	#5 A = 1 << 31; S = 30; LnR = 0;
	#5 A = 1 << 31; S = 31; LnR = 0;
	#5 A = 1 << 31; S = 32; LnR = 0;
	#5 A = 1 << 31; S = 33; LnR = 0;
	#5 A = 8; S = 2; LnR = 0;
	
	#5 A = 1; S = 0; LnR = 1;
	#5 A = 1; S = 1; LnR = 1;
	#5 A = 1; S = 2; LnR = 1;
	#5 A = 1; S = 3; LnR = 1;
	#5 A = 1; S = 4; LnR = 1;
	#5 A = 1; S = 5; LnR = 1;
	#5 A = 1; S = 6; LnR = 1;
	#5 A = 1; S = 7; LnR = 1;
	#5 A = 1; S = 8; LnR = 1;
	#5 A = 1; S = 9; LnR = 1;
	#5 A = 1; S = 10; LnR = 1;
	#5 A = 1; S = 11; LnR = 1;
	#5 A = 1; S = 12; LnR = 1;
	#5 A = 1; S = 13; LnR = 1;
	#5 A = 1; S = 14; LnR = 1;
	#5 A = 1; S = 15; LnR = 1;
	#5 A = 1; S = 16; LnR = 1;
	#5 A = 1; S = 17; LnR = 1;
	#5 A = 1; S = 18; LnR = 1;
	#5 A = 1; S = 19; LnR = 1;
	#5 A = 1; S = 20; LnR = 1;
	#5 A = 1; S = 21; LnR = 1;
	#5 A = 1; S = 22; LnR = 1;
	#5 A = 1; S = 23; LnR = 1;
	#5 A = 1; S = 24; LnR = 1;
	#5 A = 1; S = 25; LnR = 1;
	#5 A = 1; S = 26; LnR = 1;
	#5 A = 1; S = 27; LnR = 1;
	#5 A = 1; S = 28; LnR = 1;
	#5 A = 1; S = 29; LnR = 1;
	#5 A = 1; S = 30; LnR = 1;
	#5 A = 1; S = 31; LnR = 1;
	#5 A = 1; S = 32; LnR = 1;
	#5 A = 1; S = 33; LnR = 1;
	
	A = 0; S = 0; LnR = 0;
end

endmodule




