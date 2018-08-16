`timescale 1ns/10ps

module mux8x64_1(a,b,c,d,e,f,cntrl,out);
	
	output logic [63:0] out;
	input logic [63:0] a,b,c,d,e,f;
	input logic [2:0] cntrl;
	
	genvar i;
	
	generate
	
		for (i=0; i<64; i++) begin: choosing
			mux8_1 bestmux (out[i], {1'b0,f[i],e[i],d[i],c[i],b[i],1'b0,a[i]}, cntrl);
		end
	
	endgenerate

endmodule 

module mux2x64_1(out, a, b, sel);
	//if sel = 0 return a
	output logic [63:0] out;
	input logic [63:0] a,b;
	input logic sel;
	
	genvar i;
	
	generate
	
		for (i=0; i<64; i++) begin: choosing
			mux2_1 bestmux (out[i], a[i], b[i], sel);
		end
	
	endgenerate

endmodule 

module mux4x64_1(out, d, c, b, a, sel);
	//input in the order of 0, 1, 2, 3.
	output logic [63:0] out;
	input logic [63:0] a,b, c, d;
	input logic [1:0] sel;
	
	genvar i;
	
	generate
	
		for (i=0; i<64; i++) begin: choosing
			mux4_1 bestmux (out[i], {a[i], b[i], c[i], d[i]}, sel);
		end
	
	endgenerate

endmodule 

module mux2x5_1(out, a, b, sel);
	//if sel = 0 return a
	output logic [4:0] out;
	input logic [4:0] a,b;
	input logic sel;
	
	genvar i;
	
	generate
	
		for (i=0; i<5; i++) begin: choosing
			mux2_1 bestmux (out[i], a[i], b[i], sel);
		end
	
	endgenerate

endmodule 

module mux8x64_1_testbench();

	logic [63:0] out;
	logic [63:0] a,b,c,d,e,f;
	logic [2:0] cntrl;
	logic clk;
	
	mux8x64_1 dut(a,b,c,d,e,f,cntrl,out);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	a <= 64'd10;
	b <= 64'd100;
	c <= 64'd64;
	d <= -64'd2418;
	e <= 64'd10000;
	f <= 64'd1;			cntrl <= 3'b0; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
							cntrl <= 3'b010; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							cntrl <= 3'b011; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							cntrl <= 3'b100; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							cntrl <= 3'b101; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
							cntrl <= 3'b110; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);


		$stop;
	end
	
endmodule 


