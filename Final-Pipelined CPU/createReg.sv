//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

`timescale 1ns/10ps
//This creates the 32 registers of 64 DFF and passes the necessary enable values from the decoder
module createReg (register, d,e, reset, clk);

	output logic [63:0] register [31:0];
	input logic [63:0] d;
	input logic [31:0] e;
	input logic reset, clk;
	
	genvar i;
	
	generate
		for(i=0; i<31; i++) begin : eachreg
			D_FF64 oneregister (register[i],d[63:0],reset,clk,e[i]);
		end
	endgenerate
	
	//this is to ensure that the zero register will always contain all zeroes
	D_FF64 zeroes (register[31],64'b0,1'b1,clk,e[31]);
endmodule 

module createReg_testbench();
//mux2_1(out, i0, i1, sel);	

	 logic [63:0] register [31:0];
	 logic [63:0] d;
	 logic [31:0] e;
	 logic reset, clk;
	 
	createReg dut(register, d, e, reset, clk);
	
	integer i;
	
	//Set up the clock
	parameter CLOCK_PERIOD = 500;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	reset <= 0;
	d <= 64'd8675309;
	e <= 32'b00000000000010000000000000000000;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	e <= 32'b00000000000000000000000000000000;
	@(posedge clk);
	@(posedge clk);
	
	e <= 32'b00000000000000000000001000000000;
	@(posedge clk);
	@(posedge clk);
	
	e <= 32'b00001000000000000000000000000000;
	@(posedge clk);
	@(posedge clk);
	
	e <= 32'b00000000000000001000000000000000;
	@(posedge clk);
	@(posedge clk);
	
	e <= 32'b00000000000000000000000000000001;
	@(posedge clk);	
	@(posedge clk);
	@(posedge clk);
	
	e <= 32'b10000000000000000000000000000000;
	@(posedge clk);	
	@(posedge clk);
	@(posedge clk);

	
	reset <= 1;
	@(posedge clk);	
	@(posedge clk);
	@(posedge clk);

		$stop;
	end
	
endmodule 