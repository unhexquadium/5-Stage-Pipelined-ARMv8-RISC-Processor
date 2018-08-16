//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

`timescale 1ns/10ps

//this is the default D_FF module we were given to use from the lab description, it is to remain unmodified
module D_FF (q, d, reset, clk);

  output logic q;
  input logic d, reset, clk;

  always_ff @(posedge clk)
  if (reset)
    q <= 0;  // On reset, set to 0.
  else
    q <= d; // Otherwise out = d
	 
endmodule

//This takes the D_FF module and adds an enable line to it so that the q value can be updated
module D_FF_Enabler (q, d, e, reset, clk);

  output logic q;
  input logic d, reset, clk,e;
  logic			out;
  
  //it does this by muxing the currently stored q value and the input d value with the enable as the switch
  mux2_1 m1 (out,q,d,e);
  D_FF d1 (q, out, reset, clk);

	

endmodule


//This generates 64 enabled DFFs using a generate statement
module D_FF64(q,d,reset,clk,e);

	output logic  [63:0]  q;
	input  logic  [63:0]  d;
	input  logic          e;
	input  logic          clk,reset;
  
	genvar i;
	
	generate
		for(i=0; i<64; i++) begin : eachDff
			D_FF_Enabler dflipflop (q[i],d[i],e,reset,clk);
		end
	endgenerate
endmodule


module D_FF64_testbench();

	logic [63:0] q;
	logic [63:0] d;
	logic e;
	logic clk, reset;
	
	D_FF64 dut(q, d, reset, clk, e);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 5000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	
	reset <= 0;
	d <= 64'd8675309;
	e <= 0;
	@(posedge clk);
	@(posedge clk);
	
	e <= 1;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	d <= 64'd1;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);


		$stop;
	end

endmodule 

module D_FF_Enabler_testbench();

	logic  q;
	logic  d;
	logic e;
	logic clk, reset;
	
	D_FF_Enabler dut(q, d, e, reset, clk);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	

	reset <= 0;
	d <= 1;
	e <= 0;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	e<=1;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	d <= 0;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	e <= 0;
	d <= 1;
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);


		$stop;
	end

endmodule 