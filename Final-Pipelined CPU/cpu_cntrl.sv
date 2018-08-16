`timescale 1ns/10ps
module cpu_cntrl (inst, RegWrite, Reg2Loc, ALUcntrl, ALUsrc, SetFlags, MemWrite,
						MemRead, MemtoReg, UnCondBr, BrZero, BrLessThan);
						
	output logic RegWrite, Reg2Loc, ALUsrc, SetFlags, MemWrite, MemRead, 
						MemtoReg, UnCondBr = 0, BrZero = 0, BrLessThan = 0;
	output logic [2:0] ALUcntrl;
	input logic [10:0] inst;

//b, cbz, and b.lt
//my solution: add two control bits: one is UnCondBr and one is CondBr
 
	always_comb begin
	
		casez (inst)
			11'b1001000100Z: begin
				RegWrite = 1'b1;
				Reg2Loc = 1'bZ;
				ALUcntrl = 3'b010;
				ALUsrc = 1'b1;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'b0;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end //ADDI
			
			11'b10101011000:begin 
				RegWrite = 1'b1;
				Reg2Loc = 1'b0;
				ALUcntrl = 3'b010;
				ALUsrc = 1'b0;
				SetFlags = 1'b1;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'b0;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end//ADDS
			
			11'b11101011000: begin 
				RegWrite = 1'b1;
				Reg2Loc = 1'b0;
				ALUcntrl = 3'b011;
				ALUsrc = 1'b0;
				SetFlags = 1'b1;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'b0;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end //SUBS 
			
			11'b10011011000: begin
				RegWrite = 1'b1;
				Reg2Loc = 1'b0;
				ALUcntrl = 3'b100;
				ALUsrc = 1'b0;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'b0;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end//MUL
			
			11'b11010011011: begin 
				RegWrite = 1'b1;
				Reg2Loc = 1'b0;
				ALUcntrl = 3'b101;
				ALUsrc = 1'b1;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'b0;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end //LSL
			
			11'b11010011010: begin
				RegWrite = 1'b1;
				Reg2Loc = 1'b0;
				ALUcntrl = 3'b110;
				ALUsrc = 1'b1;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'b0;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end //LSR
			
			11'b000101ZZZZZ: begin
				RegWrite = 1'b0;
				Reg2Loc = 1'bZ;
				ALUcntrl = 3'bZZZ;
				ALUsrc = 1'bZ;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'bZ;
				UnCondBr = 1'b1;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end//B
			
			11'b10110100ZZZ: begin
				RegWrite = 1'b0;
				Reg2Loc = 1'b1;
				ALUcntrl = 3'b000;
				ALUsrc = 1'b0;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'bZ;
				UnCondBr = 1'b0;
				BrZero = 1'b1;
				BrLessThan = 1'b0;
			end//CBZ
			
			11'b01010100ZZZ: begin
				RegWrite = 1'b0;
				Reg2Loc = 1'bZ;
				ALUcntrl = 3'bZZZ;
				ALUsrc = 1'bZ;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b0;
				MemtoReg = 1'bZ;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b1;
//				BrTaken = (N != V);
			end //B.LT
			
			11'b11111000010: begin
				RegWrite = 1'b1;
				Reg2Loc = 1'b1;
				ALUcntrl = 3'b010;
				ALUsrc = 1'b1;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'b1;
				MemtoReg = 1'b1;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end //LDUR
			
			11'b11111000000: begin
				RegWrite = 1'b0;
				Reg2Loc = 1'b1;
				ALUcntrl = 3'b010;
				ALUsrc = 1'b1;
				SetFlags = 1'b0;
				MemWrite = 1'b1;
				MemRead = 1'b0;
				MemtoReg = 1'bZ;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end//STUR
			
			default: begin
				RegWrite = 1'b0;
				Reg2Loc = 1'bZ;
				ALUcntrl = 3'bZZZ;
				ALUsrc = 1'bZ;
				SetFlags = 1'b0;
				MemWrite = 1'b0;
				MemRead = 1'bZ;
				MemtoReg = 1'bZ;
				UnCondBr = 1'b0;
				BrZero = 1'b0;
				BrLessThan = 1'b0;
			end
			
		endcase
	end
	
	
endmodule 