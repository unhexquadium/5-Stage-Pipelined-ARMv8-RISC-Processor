`timescale 1ns/10ps
module pipelined_cpu(clk, reset);
	
	input logic clk, reset;
	logic carry_out, negative, overflow, zero, C, V, N, Z, N_1, V_1, zero_1;
	logic RegWrite, Reg2Loc, ALUsrc, SetFlags, MemWrite, MemRead, 
						MemtoReg, UnCondBr, BrZero, BrLessThan,
						RegWrite_1, RegWrite_2, RegWrite_3, ALUsrc_1, SetFlags_1, MemWrite_1, MemWrite_2, MemRead_1, MemRead_2, MemtoReg_1, MemtoReg_2, MemtoReg_3, UnCondBr_1, UnCondBr_2,
						BrZero_1, BrZero_2, BrLessThan_1, BrLessThan_2;
	logic [63:0] pcTaken, pcTaken_1; //address if branch
	logic [2:0] ALUcntrl, ALUcntrl_1;
	logic [63:0] counter, Imm64, Imm64_1, Imm64x8, ReadData1, ReadData1_1, ReadData2, ReadData2_1, aluB, ALUresult, ALUresult_1, ALUresult_2, MemOut, MemOut_1, WriteData, PreWriteData, counter_1, counter_2;
	logic [31:0] inst, inst_1;
	logic [4:0] destreg, destreg_1, ReadRegister1, ReadRegister2, ReadRegister2_1, WriteRegister;
	logic branch;
	logic [1:0] no, ForwardA, ForwardB;
	logic [63:0] ReadData_A, ReadData_B, actualALU_B_1;
	
	
	//-----------------------------INSTRUCTION FETCH STAGE-------------------------------------------------------
	PC ProgramCounter (clk, reset, pcTaken_1, branch, counter); 

	instructmem NextInst (counter, inst, clk);
	
	IFDE pipeline1 (clk, reset, counter, counter_1, inst, inst_1); //counter1 and inst1 are outputs
	//------------------------------------------------------------------------------------------------------------
	
	//-----------------------------INSTRUCTION DECODE STAGE----------------------------------------------------------------------------------------------------

	
	//UnCondBr, BrZero, BrLessThan;
	cpu_cntrl ControlBits(inst_1[31:21], RegWrite, Reg2Loc, ALUcntrl, ALUsrc, SetFlags,
								MemWrite, MemRead, MemtoReg, UnCondBr, BrZero, BrLessThan);
	 
	signextend extension (Imm64, inst_1);
	
	mux2x5_1 Reg2Location(ReadRegister2, inst_1[20:16], inst_1[4:0], Reg2Loc);
	regfile registersyo(ReadData1, ReadData2, WriteData, inst_1[9:5], ReadRegister2, WriteRegister, RegWrite_3, clk); //this must be REGWRITE FROM WRITEBACK STAGE
	
	forwarding ForwardUnit (RegWrite_1, RegWrite_2, inst_1[9:5], ReadRegister2, destreg, destreg_1, ForwardA, ForwardB);
	
	//0 is register file output, 1 is forward from MEM/WB stage, and 2 is forward from EX/MEM stage
	mux4x64_1 ForwardedInput1 (ReadData_A, ReadData1, PreWriteData, ALUresult, 64'bX, ForwardA);
	mux4x64_1 ForwardedInput2 (ReadData_B, ReadData2, PreWriteData, ALUresult, 64'bX, ForwardB);
	
	IDEX pipeline2 (clk, reset, ReadData_A, ReadData_B, inst_1[4:0], inst_1[9:5], ReadRegister2, RegWrite, ALUcntrl, ALUsrc, SetFlags, MemWrite, 		 //inputs
											MemRead, MemtoReg, UnCondBr, BrZero, BrLessThan, counter_1, Imm64, 																//inputs
											Imm64_1, counter_2, ReadData1_1, ReadData2_1, destreg, ReadRegister1, ReadRegister2_1, RegWrite_1, 					//outputs
											ALUcntrl_1, ALUsrc_1, SetFlags_1, MemWrite_1, MemRead_1, MemtoReg_1, UnCondBr_1, BrZero_1, BrLessThan_1);			//outputs
											
											
	//-------------------------------------------------------------------------------------------------------------------------------------------
	
	
	//-----------------------------EXECUTION STAGE------------------------------------------------------------
	
	shifter ImmShift (Imm64_1, 1'b0, 6'd2, Imm64x8);
	adder_64bit plusBrTaken (counter_2, Imm64x8, 1'b0, pcTaken, no[1], no[0]);
	
	mux2x64_1 ALUin2 (aluB, ReadData2_1, Imm64_1, ALUsrc_1);
	
//	forwarding ForwardUnit (RegWrite_2, RegWrite_3, ReadRegister1, ReadRegister2_1, destreg_1, WriteRegister, ForwardA, ForwardB);
//	
//	//0 is register file output, 1 is forward from MEM/WB stage, and 2 is forward from EX/MEM stage
//	mux4x64_1 ForwardedInput1 (actualALU_A, ReadData1_1, WriteData, ALUresult_1, 64'bX, ForwardA);
//	mux4x64_1 ForwardedInput2 (actualALU_B, aluB, WriteData, ALUresult_1, 64'bX, ForwardB);
	
	alu DoStuff (ReadData1_1, aluB, ALUcntrl_1, ALUresult, negative, zero, overflow, carry_out);
	
	setflag NegativeFlag (clk, reset, SetFlags_1, negative, N); //N = negative
	setflag OverflowFlag (clk, reset, SetFlags_1, overflow, V); //V = overflow
	setflag CarryOutFlag (clk, reset, SetFlags_1, carry_out, C); //C = carry
	setflag ZeroFlag (clk, reset, SetFlags_1, zero, Z); //Z = zero
	
	//do we only decide the branching in the mem stage???
	EXMEM pipeline3 (clk, reset, ALUresult, actualALU_B, destreg, N, V, zero, RegWrite_1, MemWrite_1, MemRead_1, MemtoReg_1, UnCondBr_1, BrZero_1, BrLessThan_1, pcTaken,
							ALUresult_1, actualALU_B_1, destreg_1, N_1, V_1, zero_1, RegWrite_2, MemWrite_2, MemRead_2, MemtoReg_2, UnCondBr_2, BrZero_2, BrLessThan_2, pcTaken_1);
							
	//---------------------------------------------------------------------------------------------------------------------------
	
	//---------------------------MEMORY STAGE------------------------------------------------------------------------
	
	assign branch = ((N != V)&BrLessThan_2) | (BrZero_2&zero) | UnCondBr_2;
	
	datamem Memory (ALUresult_1, MemWrite_2, MemRead_2, actualALU_B_1, clk, 4'd8, MemOut);
	
	mux2x64_1 WriteBack (PreWriteData, ALUresult_1, MemOut, MemtoReg_2);
	
	MEMWB pipeline4 (clk, reset, RegWrite_2, PreWriteData, destreg_1, RegWrite_3, WriteData, WriteRegister); //destreg_1 turns into WriteRegister
	
	//--------------------------------------------------------------------------------------------------------------
	
	//-------------------------WRITEBACK STAGE----------------------------------------------------------------------
	//mux2x64_1 WriteBack (WriteData, ALUresult_2, MemOut_1, MemtoReg_3);
	//-------------------------------------------------------------------------------------------------------------


endmodule 



module pipelined_cpustim();

	logic clk, reset;
	
	pipelined_cpu dut(clk, reset);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 500;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);
	
	integer i;
	
	initial begin
	
		reset <= 0;
		for (i=0; i<2**5; i++) begin
			@(posedge clk);
		end
		
		$stop;
	end
	
endmodule 