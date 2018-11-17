`timescale 1ns/1ps

module RC_ADD_SUB_32_TB;
reg [31:0] A, B;
reg SnA;
wire [31:0] S; 
wire CO;

RC_ADD_SUB_32 rc_inst(.S(S), .CO(CO), .A(A), .B(B), .SnA(SnA));

initial 
begin
	A = 0; B = 0; SnA = 0;
	#5 A = 5; B = 5; SnA = 0;
	#5 A = -5; B = 5; SnA = 0;
	#5 A = 5; B = -5; SnA = 0;
	#5 A = -5; B = -5; SnA = 0;
	#5 A = 5; B = 5; SnA = 1;
	#5 A = -5; B = 5; SnA = 1;
	#5 A = 5; B = -5; SnA = 1;	
	#5 A = -5; B = -5; SnA = 1;	
	#5 A = 123; B = 95; SnA = 1;	
	#5 A = 0; B = 0; SnA = 0;
end

endmodule


