//Program counter, keeps track of current instruction address and handles updating itself per instruction including branches

`timescale 1ns/10ps
module PC (clk, reset, addvalue, BrTaken, counter);
	
	output logic [63:0] counter = 0;
	input logic clk, reset;
	input logic [63:0] addvalue;
	input logic BrTaken;
	logic [63:0] pc1, pc2, newcounter;
	logic [3:0] no;

	//determines possible next instruction addresses
	adder_64bit plusfour (counter, 64'd4, 1'b0, pc1, no[0], no[1]);
	adder_64bit plusBrTaken (counter, addvalue, 1'b0, pc2, no[2], no[3]);
	
	//chooses which instruction address to use depending on if branch or not
	mux2x64_1 whichPC (newcounter, pc1, pc2, BrTaken);

	
	always_ff @(posedge clk) begin
		if (reset)
			counter <= 0;
		else
			counter <= newcounter;
	end


endmodule 

module PC_testbench();

	logic [63:0] counter;
	logic clk, reset;
	logic [63:0] addvalue;
	logic BrTaken;
	
	PC dut(clk, reset, addvalue, BrTaken, counter);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 5000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin							
	
		$display("%t testing regular add 4 operation", $time);
		reset <= 0;	
		addvalue <= 64'd40;
		BrTaken <= 0;
		@(posedge clk); //counter = 4
		@(posedge clk); //counter = 8
		@(posedge clk); //counter = 12

		
		$display("%t branch five instructions forward", $time);
		BrTaken <= 1; 
		@(posedge clk); //counter = 52

		
		$display("%t next instruction", $time);
		BrTaken <= 0;
		@(posedge clk); //counter = 56

		
		$display("%t branch five instructions back", $time);
		addvalue <= -64'd40;
		BrTaken <= 1;

		@(posedge clk); //counter = 16

		
		$display("%t test reset", $time);
		reset <= 1;
		@(posedge clk); //counter = 0
		@(posedge clk)


		$stop;
	end
	
endmodule 