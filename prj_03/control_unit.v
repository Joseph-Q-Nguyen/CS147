// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Output signals
// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;
// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Outputs for memory
output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
output MEM_READ, MEM_WRITE;

// Input signals
input [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
input ZERO, CLK, RST;

// Inout signal
inout [`DATA_INDEX_LIMIT:0] MEM_DATA;

// State nets
wire [2:0] proc_state;

PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

// Output register

// Registers for register file 
reg [`DATA_INDEX_LIMIT:0] RF_DATA_W;
reg [`ADDRESS_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
reg RF_READ, RF_WRITE;
// Registers for ALU
reg [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
reg  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Registers for memory
reg [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR; 
reg MEM_READ, MEM_WRITE;
// Register for inout
reg [`DATA_INDEX_LIMIT:0] MEM_DATA;

reg [`DATA_INDEX_LIMIT:0] write_data;

assign MEM_DATA = ((MEM_READ===1'b1)&&(MEM_WRITE===1'b0))?{`DATA_WIDTH{1'bz} }:write_data;

reg [`DATA_INDEX_LIMIT:0] PC_REG, INST_REG, SP_REG; // internal registers

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

initial
begin
	PC_REG = `INST_START_ADDR;
	SP_REG = `INIT_STACK_POINTER;
end


always @ (proc_state)
begin
	case(proc_state)
		`PROC_FETCH :  
		begin
			MEM_ADDR = PC_REG;
			MEM_READ = 1'b1;
			MEM_WRITE = 1'b0;
			RF_READ = 1'b1;
			RF_WRITE = 1'b1;
		end
		`PROC_DECODE : 
		begin
			INST_REG = MEM_DATA;
			// parse the instruction
			// R-type
			{opcode, rs, rt, rd, shamt, funct} = INST_REG;
			// I-type
			{opcode, rs, rt, immediate } = INST_REG;
			// J-type
			{opcode, address} = INST_REG;
				
			SIGN_EXT = {{16{immediate[15]}}, immediate};
			ZERO_EXT = {16'b0, immediate};
			LUI = {immediate, 16'b0};
			JUMP_ADDR = {6'b0, address};
		
			RF_ADDR_R1 = rs;
			RF_ADDR_R2 = rt;
			RF_READ = 1'b1;
			RF_WRITE = 1'b0;
			print_instruction(INST_REG);
		end
		`PROC_EXE :
		begin
			case(opcode)
				6'b0 : // R-TYPE
				begin
					case(funct)
						6'h20:  ALU_OPRN = `ALU_OPRN_WIDTH'h01;
						6'h22:	ALU_OPRN = `ALU_OPRN_WIDTH'h02;
						6'h2c:	ALU_OPRN = `ALU_OPRN_WIDTH'h03;
						6'h24:	ALU_OPRN = `ALU_OPRN_WIDTH'h06;
						6'h25:	ALU_OPRN = `ALU_OPRN_WIDTH'h07;
						6'h27:	ALU_OPRN = `ALU_OPRN_WIDTH'h08;
						6'h2a:	ALU_OPRN = `ALU_OPRN_WIDTH'h09;
						6'h01:	ALU_OPRN = `ALU_OPRN_WIDTH'h04;
						6'h02:	ALU_OPRN = `ALU_OPRN_WIDTH'h05;
					endcase
					ALU_OP1 = RF_DATA_R1;
					ALU_OP2 = (funct === 6'h01 || funct === 6'h02) ? shamt : RF_DATA_R2;
				end
				// I-TYPE
				6'h08:	// addi
				begin	
					ALU_OPRN = `ALU_OPRN_WIDTH'h01;
					ALU_OP1 = RF_DATA_R1;
					ALU_OP2 = SIGN_EXT;
				end
				6'h1d: 	// muli
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h03;
					ALU_OP1 = RF_DATA_R1;
					ALU_OP2 = SIGN_EXT;
				end
				6'h0c: 	// andi
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h06;
					ALU_OP1 = RF_DATA_R1;
					ALU_OP2 = ZERO_EXT;
				end
				6'h0d: 	//ori
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h07;
					ALU_OP1 = RF_DATA_R1;
					ALU_OP2 = ZERO_EXT;
				end
				6'h0a: 	// slti
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h09;
					ALU_OP1 = RF_DATA_R1;
					ALU_OP2 = SIGN_EXT;
				end
				6'h04, 6'h05 : // beq and bne
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h01;
					ALU_OP1 = PC_REG + 1;
					ALU_OP2 = SIGN_EXT;
				end
				6'h23, 6'h2b:  // lw and sw
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h01;
					ALU_OP1 = RF_DATA_R1;
					ALU_OP2 = SIGN_EXT;
				end
				// j-type
				6'h1b: 	// push
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h02;
					ALU_OP1 = SP_REG;
					ALU_OP2 = 1;
					RF_ADDR_R1 = 0;
					RF_READ = 1'b1;
					RF_WRITE = 1'b0;
				end
				6'h1c: 	// pop
				begin
					ALU_OPRN = `ALU_OPRN_WIDTH'h01;
					ALU_OP1 = SP_REG;
					ALU_OP2 = 1;
				end
			endcase
		end
		`PROC_MEM :
		begin
			case(opcode)
				6'h23:  //lw
				begin
					MEM_ADDR = ALU_RESULT;
					MEM_READ = 1'b1;
					MEM_WRITE = 1'b0;
				end
				6'h2b:	//sw 
				begin
					MEM_ADDR = ALU_RESULT;
					write_data = RF_DATA_R2;
					MEM_READ = 1'b0;
					MEM_WRITE = 1'b1;
				end
				6'h1b: 	// push
				begin
					MEM_ADDR = SP_REG;
					write_data = RF_DATA_R1;
					MEM_READ = 1'b0;
					MEM_WRITE = 1'b1;
					SP_REG = ALU_RESULT;
				end
				6'h1c: 	// pop
				begin
					SP_REG = ALU_RESULT;
					MEM_ADDR = SP_REG;
					MEM_READ = 1'b1;
					MEM_WRITE = 1'b0;
				end
				default:
				begin
					MEM_READ = 1'b1;
					MEM_WRITE = 1'b1;
				end
			endcase
		end
		`PROC_WB :
		begin
			PC_REG = PC_REG + 1;
			MEM_READ = 1'b0;
			MEM_WRITE = 1'b0;
			case(opcode)
				6'b0 : // R-TYPE
				begin
					case(funct)
						6'h20, 6'h22, 6'h2c, 6'h24, 6'h25, 6'h27, 6'h2a, 6'h01, 6'h02 :  
						begin	
							RF_ADDR_W = rd;
							RF_DATA_W = ALU_RESULT;
							RF_READ = 1'b0;
							RF_WRITE = 1'b1;
						end
						6'h08:	PC_REG = RF_DATA_R1; // if jump register, set pc to r1
					endcase
				end	
				// I-TYPE
				6'h08, 6'h1d, 6'h0c, 6'h0d, 6'h0a :	
				begin	
					RF_ADDR_W = rt;
					RF_DATA_W = ALU_RESULT;
					RF_READ = 1'b0;
					RF_WRITE = 1'b1;
				end
				6'h0f:
				begin
					RF_ADDR_W = rt;
					RF_DATA_W = LUI;
					RF_READ = 1'b0;
					RF_WRITE = 1'b1;
				end 
				6'h04: 
				begin
					if (RF_DATA_R1 === RF_DATA_R2)
						PC_REG = ALU_RESULT;
				end
				6'h05: 
				begin
					if (RF_DATA_R1 !== RF_DATA_R2)
						PC_REG = ALU_RESULT;
				end
				6'h23:  //lw
				begin
					RF_ADDR_W = rt;
					RF_DATA_W = MEM_DATA;
					RF_READ = 1'b0;
					RF_WRITE = 1'b1;
				end
				// J-TYPE
				6'h02: 	PC_REG = JUMP_ADDR; // jmp
				6'h03: //jal
				begin
					RF_ADDR_W = 31;
					RF_DATA_W = PC_REG;
					RF_READ = 1'b0;
					RF_WRITE = 1'b1;
					PC_REG = JUMP_ADDR;
				end
				6'h1c: 	// pop
				begin
					RF_ADDR_W = 0;
					RF_DATA_W = MEM_DATA;
					RF_READ = 1'b0;
					RF_WRITE = 1'b1;
				end
			endcase
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
// Module: CONTROL_UNIT
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


