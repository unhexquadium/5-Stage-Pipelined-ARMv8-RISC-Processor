`timescale 1ns/10ps
module CPU1(clk, reset);
	
	input logic clk, reset;
	logic carry_out_c, negative_c, overflow_c, zero_c, C, V, N, Z;
	logic RegWrite, Reg2Loc, ALUsrc, SetFlags, MemWrite, MemRead, 
						MemtoReg, BrTaken;
	logic [2:0] ALUcntrl;
	logic [63:0] counter, Imm64, Imm64x8, ReadData1, ReadData2, aluB, ALUresult, MemOut, WriteData;
	logic [31:0] inst;
	logic [4:0] ReadRegister2;
	
	//PC takes input of UnCondBr and BrTaken. Brtaken module takes flags, inst, and 
		//outputs Brtaken
	//PC has both adders and mux. outputs program counter
	PC ProgramCounter (clk, reset, Imm64x8, BrTaken, counter);

	instructmem NextInst (counter, inst, clk);
	
	//Don't need UncondBr?
	cpu_cntrl ControlBits(inst[31:21], N, V, zero_c, RegWrite, Reg2Loc, ALUcntrl, ALUsrc, SetFlags,
								MemWrite, MemRead, MemtoReg, BrTaken);
	
	signextend extension (Imm64, inst);
	
	shifter ImmShift (Imm64, 1'b0, 6'd2, Imm64x8);
	
	//readRegister2 comes from a 2x5_1 mux
	mux2x5_1 Reg2Location(ReadRegister2, inst[20:16], inst[4:0], Reg2Loc);
	
	regfile registersyo(ReadData1, ReadData2, WriteData, inst[9:5], ReadRegister2, inst[4:0], RegWrite, clk);
	
	//ALU input B comes from a 2x64_1 mux
	mux2x64_1 ALUin2 (aluB, ReadData2, Imm64, ALUsrc);
	
	alu DoStuff (ReadData1, aluB, ALUcntrl, ALUresult, negative_c, zero_c, overflow_c, carry_out_c);
	
	setflag NegativeFlag (clk, reset, SetFlags, negative_c, N); //N = negative
	setflag OverflowFlag (clk, reset, SetFlags, overflow_c, V); //V = overflow
	setflag CarryOutFlag (clk, reset, SetFlags, carry_out_c, C); //C = carry
	setflag ZeroFlag (clk, reset, SetFlags, zero_c, Z); //Z = zero
	
	datamem Memory (ALUresult, MemWrite, MemRead, ReadData2, clk, 4'd8, MemOut);
	
	mux2x64_1 WriteBack (WriteData, ALUresult, MemOut, MemtoReg);


endmodule 

module CPU1stim();

	logic clk, reset;
	
	CPU1 dut(clk, reset);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 10000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);
	
	integer i;
	
	initial begin
	
		reset <= 0;
		for (i=0; i<2**9; i++) begin
			@(posedge clk);
		end
		
		$stop;
	end
	
endmodule 