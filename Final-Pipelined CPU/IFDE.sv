//Module for each individual pipeline stage, each one is essentially just a bunch of flip-flops for the wires that need to go in between pipeline stages

`timescale 1ns/10ps
module IFDE (clk, reset, pcin, pcout, instin, instout);

	output logic [31:0] instout;
	output logic [63:0] pcout;
	input logic [63:0] pcin;
	input logic [31:0] instin;
	input logic clk, reset;

	always_ff @(posedge clk) begin
		if (reset) begin
			instout <= 0;
			pcout <= 0;
		end else begin
			instout <= instin;
			pcout <= pcin;
		end
	end

endmodule 


module IDEX(clk, reset, regout1, regout2, destreg, Rm, Rn, RegWrite, ALUcntrl, ALUsrc, SetFlags, MemWrite, MemRead, MemtoReg, UnCondBr, BrZero, BrLessThan, pcin, Immin, 
				Immout, pcout, out1, out2, destregout, Rm_1, Rn_1, RegWrite_1, ALUcntrl_1, ALUsrc_1, SetFlags_1, MemWrite_1, MemRead_1, MemtoReg_1, UnCondBr_1, BrZero_1, BrLessThan_1);


	output logic [63:0] out1, out2, Immout, pcout;
	output logic [4:0] destregout, Rm_1, Rn_1;
	output logic [2:0] ALUcntrl_1;
	output logic RegWrite_1, ALUsrc_1, SetFlags_1, MemWrite_1, MemRead_1, MemtoReg_1, UnCondBr_1 = 0, BrZero_1 = 0, BrLessThan_1 = 0;
	input logic [63:0] pcin, Immin, regout1, regout2;
	input logic [4:0] destreg, Rm, Rn;
	input logic clk, reset, RegWrite, ALUsrc, SetFlags, MemWrite, MemRead, MemtoReg, UnCondBr, BrZero, BrLessThan;
	input logic [2:0] ALUcntrl;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			out1 <= 0;
			out2 <= 0;
			pcout <= 0;
			Immout <= 0;
			destregout <= 0;
			RegWrite_1 <= 0;
			ALUcntrl_1<= 0;
			ALUsrc_1<= 0;
			SetFlags_1<= 0;
			MemWrite_1 <= 0;
			MemRead_1 <= 0;
			MemtoReg_1 <= 0;
			UnCondBr_1 <= 0;
			BrZero_1 <= 0;
			BrLessThan_1 <= 0;
			Rm_1 <= 0;
			Rn_1 <= 0;
		end
		else begin
			out1 <= regout1;
			out2 <= regout2;
			pcout <= pcin;
			Immout <= Immin;
			destregout <= destreg;
			RegWrite_1 <= RegWrite;
			ALUcntrl_1<= ALUcntrl;
			ALUsrc_1<= ALUsrc;
			SetFlags_1<= SetFlags;
			MemWrite_1 <= MemWrite;
			MemRead_1 <= MemRead;
			MemtoReg_1 <= MemtoReg;
			UnCondBr_1 <= UnCondBr;
			BrZero_1 <= BrZero;
			BrLessThan_1 <= BrLessThan;
			Rm_1 <= Rm;
			Rn_1 <= Rn;
		end
	end

//two 64-bit register file outputs
//two 5-bit register names?
//all control logic
//EX uses ALUOp and ALUsrc (4 bits)

endmodule 


module EXMEM(clk, reset, aluout, data2in, destregin, N, V, zero, RegWrite, MemWrite, MemRead, MemtoReg, UnCondBr, BrZero, BrLessThan, AddedBranchIn, 
				ao,data2out, destregout, Nout, Vout, zeroout, RegWrite_1, MemWrite_1, MemRead_1, MemtoReg_1, UnCondBr_1, BrZero_1, BrLessThan_1, abo);

							
	input logic N, V, zero;
	input logic [63:0]  AddedBranchIn, data2in, aluout;
	input logic [4:0] destregin;
	input logic clk, reset;
	input logic RegWrite, MemWrite, MemRead, MemtoReg, UnCondBr, BrZero, BrLessThan;
	output logic [4:0] destregout;
	output logic [63:0] abo, data2out, ao;
	output logic Nout, Vout, zeroout;
	output logic RegWrite_1, MemWrite_1, MemRead_1, MemtoReg_1, UnCondBr_1 = 0, BrZero_1 = 0, BrLessThan_1 = 0;
	
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ao <= 0;
			zeroout <= 0;
			Vout <= 0;
			Nout <= 0;
			abo <= 0; //added branch out
			data2out <= 0;
			destregout <= 0;
			RegWrite_1 <= 0;
			MemWrite_1 <= 0;
			MemRead_1 <= 0;
			MemtoReg_1 <= 0;
			UnCondBr_1 <= 0;
			BrZero_1 <= 0;
			BrLessThan_1 <= 0;
		end
		else begin
			ao <= aluout;
			zeroout <= zero;
			Vout <= V;
			Nout <= N;
			RegWrite_1 <= RegWrite;
			MemWrite_1 <= MemWrite;
			MemRead_1 <= MemRead;
			MemtoReg_1 <= MemtoReg;
			UnCondBr_1 <= UnCondBr;
			BrZero_1 <= BrZero;
			BrLessThan_1 <= BrLessThan;
			abo <= AddedBranchIn;
			data2out <= data2in;
			destregout <= destregin;
			
		end
	end

endmodule 


module MEMWB (clk, reset, memout, aluResultIn, RegWrite, MemtoReg, destregin, prevWB, prevdestreg, prevWE, mo, aro, RegWrite_1, MemtoReg_1, destregout, prevWB_1, prevdestreg_1, prevWE_1);

	input logic [63:0] memout, aluResultIn, prevWB;
	input logic [4:0] destregin, prevdestreg;
	input logic RegWrite, MemtoReg, prevWE;
	input logic clk, reset;
	output logic [63:0] mo, aro, prevWB_1;
	output logic RegWrite_1, MemtoReg_1, prevWE_1;
	output logic [4:0] destregout, prevdestreg_1;

	always_ff @(posedge clk) begin
		if (reset) begin
			mo <= 0;
			aro <= 0;
			destregout <= 0;
			RegWrite_1 <= 0;
			MemtoReg_1 <= 0;
			prevdestreg_1 <= 0;
			prevWB_1 <= 0;
			prevWE_1 <= 0;
		end
		else begin
			mo <= memout;
			aro <= aluResultIn;
			destregout <= destregin;
			RegWrite_1 <= RegWrite;
			MemtoReg_1 <= MemtoReg;
			prevWB_1 <= prevWB;
			prevdestreg_1 <= prevdestreg;
			prevWE_1 <= prevWE;
		end
	end

endmodule 