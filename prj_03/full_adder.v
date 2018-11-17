// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S, CO, A, B, CI);
output S, CO;
input A, B, CI;
wire H1_Y, H1_C, H2_C;

HALF_ADDER h1_inst(.Y(H1_Y), .C(H1_C), .A(A), .B(B));

HALF_ADDER h2_inst(.Y(S), .C(H2_C), .A(H1_Y), .B(CI));

or or_inst(CO, H1_C, H2_C);

endmodule
