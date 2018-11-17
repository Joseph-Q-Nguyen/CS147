`timescale 1ns/1ps

module FULL_ADDER_TB;
reg A, B, CI;
wire S, CO;

FULL_ADDER hs_inst(.S(S), .CO(CO), .A(A), .B(B), .CI(CI));

initial 
begin
	CI = 0; A = 0; B = 0;
	#5 CI = 0; A = 0; B = 1;
	#5 CI = 0; A = 1; B = 0;
	#5 CI = 0; A = 1; B = 1;
	#5 CI = 1; A = 0; B = 0;
	#5 CI = 1; A = 0; B = 1;
	#5 CI = 1; A = 1; B = 0;
	#5 CI = 1; A = 1; B = 1;
	#5 CI = 0; A = 0; B = 0;
end

endmodule


