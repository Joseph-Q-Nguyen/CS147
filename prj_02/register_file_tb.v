// Modified version of memery test bench that will test register file
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module RESISTER_FILE_TB;
// Storage list
reg [`ADDRESS_INDEX_LIMIT:0] ADDR_R1;
reg [`ADDRESS_INDEX_LIMIT:0] ADDR_R2;
reg [`ADDRESS_INDEX_LIMIT:0] ADDR_W;
// reset
reg READ, WRITE, RST;
// data register
reg [`DATA_INDEX_LIMIT:0] DATA_R1_REG;
reg [`DATA_INDEX_LIMIT:0] DATA_R2_REG;
reg [`DATA_INDEX_LIMIT:0] DATA_W_REG;
integer i; // index for memory operation
integer no_of_test, no_of_pass;
integer load_data;

// wire lists
wire  CLK;
wire [`DATA_INDEX_LIMIT:0] DATA_R1;
wire [`DATA_INDEX_LIMIT:0] DATA_R2;
wire [`DATA_INDEX_LIMIT:0] DATA_W;

assign DATA_W = ((READ===1'b0)&&(WRITE===1'b1))?DATA_W_REG:{`DATA_WIDTH{1'bz} };

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// register instance
REGISTER_FILE_32x32 register_inst(.DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1(ADDR_R1), 
			.ADDR_R2(ADDR_R2), .DATA_W(DATA_W), .ADDR_W(ADDR_W), .READ(READ), 
			.WRITE(WRITE), .CLK(CLK), .RST(RST));

initial
begin
RST=1'b1;
READ=1'b0;
WRITE=1'b0;
DATA_W_REG = {`DATA_WIDTH{1'b0} };
no_of_test = 0;
no_of_pass = 0;
load_data = 'h00414020;

// Start the operation
#10    RST=1'b0;
#10    RST=1'b1;
// Write cycle
for(i=0;i<=31; i = i + 1)
begin
#10     DATA_W_REG=i; READ=1'b0; WRITE=1'b1; ADDR_W = i;
end

// Read Cycle
#10   READ=1'b0; WRITE=1'b0;
#5    no_of_test = no_of_test + 1;
      if (DATA_R1!== {`DATA_WIDTH{1'bz}} || DATA_R2!== {`DATA_WIDTH{1'bz}})
        $write("[TEST] Read %1b, Write %1b, expecting 32'hzzzzzzzz, 32'hzzzzzzzz, got %8h, %8h [FAILED]\n", READ, WRITE, DATA_R1, DATA_R2);
      else 
	no_of_pass  = no_of_pass + 1;

// test of write data
for(i=0;i<=30; i = i + 2)
begin
#5      READ=1'b1; WRITE=1'b0; ADDR_R1 = i; ADDR_R2 = i + 1;
#5      no_of_test = no_of_test + 1;
        if (DATA_R1 !== i || DATA_R2 !== i + 1)
	    $write("[TEST] Read %1b, Write %1b, expecting %8h, %8h, got %8h, %8h [FAILED]\n", READ, WRITE, i, i + 1, DATA_R1, DATA_R2);
        else 
	    no_of_pass  = no_of_pass + 1;

end

#10    READ=1'b0; WRITE=1'b0; // No op

#10 $write("\n");
    $write("\tTotal number of tests %d\n", no_of_test);

    $write("\tTotal number of pass  %d\n", no_of_pass);
    $write("\n");
//    $writememh("mem_dump_01.dat", mem_inst.sram_32x64m, 'h0000000, 'h000000f);
//    $writememh("mem_dump_02.dat", mem_inst.sram_32x64m, 'h0001000, 'h000100f);
    $stop;

end
endmodule

