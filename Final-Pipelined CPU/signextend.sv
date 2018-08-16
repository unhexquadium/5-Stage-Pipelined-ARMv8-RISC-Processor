`timescale 1ns/10ps
module signextend (Imm64, inst);

	output logic [63:0] Imm64;
	input logic [31:0]inst;

	always_comb begin
		casez (inst[31:21]) 
			11'b000101ZZZZZ: Imm64 = {{38{inst[25]}},inst[25:0]}; //26 bits = Branch
			11'b01010100ZZZ: Imm64 = {{45{inst[23]}},inst[23:5]};  //19 bits = B.cond
			11'b10110100ZZZ: Imm64 = {{45{inst[23]}},inst[23:5]};//19 bits = CBZ
			11'b111110000Z0: Imm64 = {{55{inst[20]}},inst[20:12]};//9 bits = load or store
			11'b1001000100Z: Imm64 = {52'b0,inst[21:10]};//12 bits = ADDI
			11'b1101001101Z: Imm64 = {57'b0,inst[15:10]}; //6 bits shift amount for LSL/LSR
			default: Imm64 = 64'bx;
		endcase
	end

endmodule 


module signextend_testbench();

	logic [63:0] Imm64;
	logic [31:0] inst;
	logic clk;
	
	signextend dut(Imm64, inst);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 5000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin							
	
		$display("%t testing immediate value", $time);
		inst <= 32'b10010001000000000000100000100011; //ADDI X3,X1,#2
		@(posedge clk);
		assert (Imm64 == 64'd2);
		
		$display("%t testing B +12", $time);
		inst <= 32'b00010100000000000000000000001100; // B, +12
		@(posedge clk);
		assert (Imm64 == 64'd12);
		
		$display("%t testing B -7", $time);
		inst <= 32'b00010111111111111111111111111001; 
		@(posedge clk);
		assert (Imm64 == -64'd7);
		
		$display("%t testing CBZ +6", $time);
		inst <= 32'b10110100000000000000000011000000; 
		@(posedge clk);
		assert (Imm64 == 64'd6);
		
		$display("%t testing STUR -3", $time);
		inst <= 32'b11111000000111111101000010000001; //stur x1, [x4, #-3]
		@(posedge clk);
		assert (Imm64 == -64'd3);
		
		$display("%t testing LDUR 5", $time);
		inst <= 32'b11111000010000000101000001000110; // ldur x5, [x2, #5]
		@(posedge clk);
		assert (Imm64 == 64'd5);


		$stop;
	end
	
endmodule 