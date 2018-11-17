`timescale 1ns/10ps
// Name: alu_tb.v
// Module: ALU_tb
// Input: 
// Output: 
// 
// Modified version of proj_01_tb with the sole purpose of testing proj_02 alu
//	
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU_TB;

integer total_test;
integer pass_test;

reg [`ALU_OPRN_INDEX_LIMIT:0] oprn_reg;
reg [`DATA_INDEX_LIMIT:0] op1_reg;
reg [`DATA_INDEX_LIMIT:0] op2_reg;

wire [`DATA_INDEX_LIMIT:0] r_net;
wire r_zero;

// Instantiation of ALU
ALU ALU_INST_01(.OUT(r_net), .ZERO(r_zero), .OP1(op1_reg), 
                .OP2(op2_reg), .OPRN(oprn_reg));

// Drive the test patterns and test
initial
begin
op1_reg=0;
op2_reg=0;
oprn_reg=0;

total_test = 0;
pass_test = 0;

// test 15 + 3 = 18
#5  op1_reg=15;
    op2_reg=3;
    oprn_reg=`ALU_OPRN_WIDTH'h01;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));
// test 15 - 15 = 0
#5  op1_reg=15;
    op2_reg=15;
    oprn_reg=`ALU_OPRN_WIDTH'h02;   
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));
// test 15 * 0 = 0
#5  op1_reg=15;
    op2_reg=0;
    oprn_reg=`ALU_OPRN_WIDTH'h03;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));

// test 8 >> 2 = 2
#5  op1_reg=8;
    op2_reg=2;
    oprn_reg=`ALU_OPRN_WIDTH'h04;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));

// test 1 << 2 = 4
#5  op1_reg=1;
    op2_reg=2;
    oprn_reg=`ALU_OPRN_WIDTH'h05;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));

// test 10 & 7 = 2
#5  op1_reg=10;
    op2_reg=7;
    oprn_reg=`ALU_OPRN_WIDTH'h06;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));

// test 10 | 7 = 15
#5  op1_reg=10;
    op2_reg=7;
    oprn_reg=`ALU_OPRN_WIDTH'h07;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));

// test 10 ~| 7 = 4294967280
#5  op1_reg=10;
    op2_reg=7;
    oprn_reg=`ALU_OPRN_WIDTH'h08;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));

// test 100 slt 101 = 1
#5  op1_reg=100;
    op2_reg=101;
    oprn_reg=`ALU_OPRN_WIDTH'h09;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net, r_zero));


#5  $write("\n");
    $write("\tTotal number of tests %d\n", total_test);
    $write("\tTotal number of pass  %d\n", pass_test);
    $write("\n");
    $stop; // stop simulation here
end

//-----------------------------------------------------------------------------
// TASK: test_and_count
// 
// PARAMETERS: 
//     INOUT: total_test ; total test counter
//     INOUT: pass_test ; pass test counter
//     INPUT: test_status ; status of the current test 1 or 0
//
// NOTES: Keeps track of number of test and pass cases.
//
//-----------------------------------------------------------------------------
task test_and_count;
inout total_test;
inout pass_test;
input test_status;

integer total_test;
integer pass_test;
begin
    total_test = total_test + 1;
    if (test_status)
    begin
        pass_test = pass_test + 1;
    end
end
endtask

//-----------------------------------------------------------------------------
// FUNCTION: test_golden
// 
// PARAMETERS: op1, op2, oprn and result
// RETURN: 1 or 0 if the result matches golden 
//
// NOTES: Tests the result against the golden. Golden is generated inside.
//
//-----------------------------------------------------------------------------
function test_golden;
input [`DATA_INDEX_LIMIT:0] op1;
input [`DATA_INDEX_LIMIT:0] op2;
input [`ALU_OPRN_INDEX_LIMIT:0] oprn;
input [`DATA_INDEX_LIMIT:0] res;
input [`DATA_INDEX_LIMIT:0] res2;

reg [`DATA_INDEX_LIMIT:0] golden; // expected result
reg [`DATA_INDEX_LIMIT:0] golden2; // expected result for zero output
begin
	$write("[TEST] %0d ", op1);
	case(oprn)
        	`ALU_OPRN_WIDTH'h01 : begin $write("+ "); golden = op1 + op2; end
		`ALU_OPRN_WIDTH'h02 : begin $write("- "); golden = op1 - op2; end
		`ALU_OPRN_WIDTH'h03 : begin $write("* "); golden = op1 * op2; end
		`ALU_OPRN_WIDTH'h04 : begin $write(">> "); golden = op1 >> op2; end
		`ALU_OPRN_WIDTH'h05 : begin $write("<< "); golden = op1 << op2; end
		`ALU_OPRN_WIDTH'h06 : begin $write("& "); golden = op1 & op2; end
		`ALU_OPRN_WIDTH'h07 : begin $write("| "); golden = op1 | op2; end
		`ALU_OPRN_WIDTH'h08 : begin $write("~| "); golden = ~(op1 | op2); end
		`ALU_OPRN_WIDTH'h09 : begin $write("slt "); golden = op1 < op2 ? 1 : 0; end
        	default: begin $write("? "); golden = `DATA_WIDTH'hx; end
	endcase

	if (golden === 0)
		golden2 = 1'b1;
	else
		golden2 = 1'b0;

   	$write("%0d = %0d,%0d , got %0d,%0d ... ", op2, golden, golden2, res, res2);


	test_golden = (res === golden)?1'b1:1'b0 && (res2 === golden2)?1'b1:1'b0; // check that both cases are true
    	if (test_golden)
		$write("[PASSED]");
    	else 
    		$write("[FAILED]");
    	$write("\n");
end
endfunction

endmodule
