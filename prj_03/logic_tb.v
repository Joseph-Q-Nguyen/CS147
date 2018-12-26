`timescale 1ns/1ps

module LOGIC_TB;
reg LOAD, C, RST;
wire [31:0] PC, ADD1;
wire x;

REG32_PRE pc(PC, ADD1, LOAD, C, RST, 32'h00001000);
RC_ADD_SUB_32 rc(ADD1, x, PC, 32'b1, 1'b0);


initial 
begin
	C = 0; LOAD = 0; RST = 0;
	# 10 LOAD = 1; RST = 1;
	# 10 LOAD = 0;
	# 10 LOAD = 1;
	# 10 LOAD = 0;
	# 10 LOAD = 1;
	
	#20 $stop;
end

always 
begin
	#10 C = ~C;	
end

endmodule


