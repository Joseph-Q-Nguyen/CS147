// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: CTRL  : Control signal for data path
//         READ  : Memory read signal
//         WRITE : Memory Write signal
//
// Input:  ZERO : Zero status from ALU
//         CLK  : Clock signal
//         RST  : Reset Signal
//
// Notes: - Control unit synchronize operations of a processor
//          Assign each bit of control signal to control one part of data path
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
// Output signals
output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
output READ, WRITE;

reg [`CTRL_WIDTH_INDEX_LIMIT:0] CTRL;
reg READ, WRITE;

// input signals
input ZERO, CLK, RST;
input [`DATA_INDEX_LIMIT:0] INSTRUCTION;

// State nets
wire [2:0] proc_state;		
PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));
	

// register for instruction
reg [5:0] opcode;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [4:0] shamt;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;

// register for i-type
reg [`DATA_INDEX_LIMIT:0] SIGN_EXT, ZERO_EXT, LUI, JUMP_ADDR;


always @ (posedge CLK)
begin
	case(proc_state)
		`PROC_FETCH :  
		begin
			CTRL = 32'h08000020;
			READ = 1'b1;
			WRITE = 1'b0;
		end
		`PROC_DECODE : 
		begin
			CTRL = 32'h00000110;
			READ = 1'b0;
			WRITE = 1'b0;
			print_instruction(INSTRUCTION);
		end
		`PROC_EXE :
		begin
			CTRL = 32'h00600000;
			READ = 1'b0;
			WRITE = 1'b0;
		end
		`PROC_MEM :
		begin
			CTRL = 32'h00600000;
			READ = 1'b0;
			WRITE = 1'b0;
		end
		`PROC_WB :
		begin
			CTRL = 32'h0060920B;
			READ = 1'b0;
			WRITE = 1'b0;
		end	
	endcase
end

task print_instruction;
input [`DATA_INDEX_LIMIT:0] inst;
reg [5:0] opcode;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [4:0] shamt;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;
begin
// parse the instruction
// R-type
{opcode, rs, rt, rd, shamt, funct} = inst;
// I-type
{opcode, rs, rt, immediate } = inst;
// J-type
{opcode, address} = inst;
$write("@ %6dns -> [0X%08h] ", $time, inst);

case(opcode)
// R-Type
6'h00 : begin
 case(funct)
 6'h20: $write("add r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h22: $write("sub r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h2c: $write("mul r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h24: $write("and r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h25: $write("or r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h27: $write("nor r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h2a: $write("slt r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h00: $write("sll r[%02d], %2d, r[%02d];", rs, shamt, rd);
 6'h02: $write("srl r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
 6'h08: $write("jr r[%02d];", rs);
 default: $write("");
endcase
 end
// I-type
6'h08 : $write("addi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h1d : $write("muli r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0c : $write("andi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0d : $write("ori r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h0f : $write("lui r[%02d], 0X%04h;", rt, immediate);
6'h0a : $write("slti r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h04 : $write("beq r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h05 : $write("bne r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h23 : $write("lw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h2b : $write("sw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
// J-Type
6'h02 : $write("jmp 0X%07h;", address);
6'h03 : $write("jal 0X%07h;", address);
6'h1b : $write("push;");
6'h1c : $write("pop;");
default: $write("");
endcase
$write("\n");
end
endtask

endmodule


//------------------------------------------------------------------------------------------
// Module: PROC_SM
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
	// list of inputs
	input CLK, RST;
	// list of outputs
	output [2:0] STATE;
	
	reg [2:0] STATE;
	reg [2:0] next_state;
	
	initial
	begin	
		STATE = 2'bxx;
		next_state = `PROC_FETCH;
	end
	
	// reset on negative edge of RST
	always @ (negedge RST)
	begin
		STATE = 2'bxx;
		next_state = `PROC_FETCH;
	end
	
	always @ (posedge CLK)	
	begin
		case(STATE)
			`PROC_FETCH : next_state = `PROC_DECODE;
			`PROC_DECODE : next_state = `PROC_EXE;
			`PROC_EXE : next_state = `PROC_MEM;
			`PROC_MEM : next_state = `PROC_WB;
			`PROC_WB : next_state = `PROC_FETCH;
		endcase	
		STATE = next_state;
	end

endmodule