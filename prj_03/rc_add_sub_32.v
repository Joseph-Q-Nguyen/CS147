// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

// TBD

endmodule

module RC_ADD_SUB_32(S, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] S;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

wire [`DATA_INDEX_LIMIT:0] S;
reg CO;

wire [`DATA_INDEX_LIMIT:0] CO_TEMP, B_SnA;

always @ (CO_TEMP[31])
begin
	CO = CO_TEMP[31];
end

genvar i;
generate
	for (i = 0; i < 32; i = i + 1)
	begin
		xor xor_inst(B_SnA[i], B[i], SnA);
		if (i === 0)
			FULL_ADDER fa_inst(.S(S[i]), .CO(CO_TEMP[i]), .A(A[i]), .B(B_SnA[i]), .CI(SnA));
		else
			FULL_ADDER fa_inst(.S(S[i]), .CO(CO_TEMP[i]), .A(A[i]), .B(B_SnA[i]), .CI(CO_TEMP[i - 1]));
	end
endgenerate


	




endmodule

