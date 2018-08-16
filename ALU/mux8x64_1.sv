`timescale 1ns/10ps
//a 2:1 mux made from basic gates
module mux2_1(out, i0, i1, sel);	

	output logic out; 	
	input  logic i0, i1, sel; 	
	logic out1,out2, notsel;
		
	//the basic 2-1 mux out of basic gates
	assign out = (i1&sel) | (i0&~sel);
	
endmodule


//the following is a hierarchy of 2:1 muxes to create a 32:1 mux, each uses a pattern of calling the previous size mux twice to grow the inputs and 
//choosing between the now two outputs with another 2:1 mux
module mux4_1(out,i,s);
	output logic	out;
	input logic	[3:0]	i;
	input logic	[1:0] s;
	logic 				mux1,mux2;
	
	mux2_1 m1 (mux1,i[0],i[1],s[0]);
	mux2_1 m2 (mux2,i[2],i[3],s[0]);
	mux2_1 m3 (out,mux1,mux2,s[1]);
	
endmodule 

module mux8_1(out,i,s);
	output logic	out;
	input logic	[7:0] i;
	input logic [2:0] s;
	logic 				mux1,mux2;
	
	mux4_1 m1 (mux1,i[3:0],s[1:0]);
	mux4_1 m2 (mux2,i[7:4],s[1:0]);
	mux2_1 m3 (out, mux1,mux2,s[2]);
endmodule


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


module mux8_1_testbench();
//module mux8_1(out,i,s);
	logic	out;
	logic	[7:0] i;
	logic [2:0] s;
	logic clk;
	
	mux8_1 dut(out,i,s);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	i<=8'b10101101;
							s <= 3'b0; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 3'b010; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							s <= 3'b011; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							s <= 3'b100; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							s <= 3'b101; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 3'b110; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
			i<=8'b11111111;
							s <= 3'b0; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 3'b010; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							s <= 3'b011; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							s <= 3'b100; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
							s <= 3'b101; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 3'b110; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);
													@(posedge clk);


		$stop;
	end
	
endmodule 

module mux2_1_testbench();
//mux2_1(out, i0, i1, sel);	

	 logic out; 	
	 logic i0, i1, sel; 	
	logic clk;
	
	mux2_1 dut(out,i0,i1,sel);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	i0<=1'b0; i1<=1'b1;
							sel <= 1'b0; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							sel <= 1'b1; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													
	i0<=1'b0; i1<=1'b0;
							sel <= 1'b0; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							sel <= 1'b1; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													
	i0<=1'b1; i1<=1'b0;
							sel <= 1'b0; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							sel <= 1'b1; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													
	i0<=1'b1; i1<=1'b1;
							sel <= 1'b0; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							sel <= 1'b1; @(posedge clk);
													@(posedge clk);
													@(posedge clk);
													
													
		$stop;
	end
	
endmodule 

module mux4_1_testbench();
//mux4_1(out,i,s);
	 logic	out;
	 logic	[3:0]	i;
	 logic	[1:0] s;	
	logic clk;
	
	mux4_1 dut(out,i,s);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	i<=4'b1010;
							s <= 2'b00; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 2'b01; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 2'b10; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
						s <= 2'b11; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
											@(posedge clk); 	@(posedge clk);	@(posedge clk);	@(posedge clk);	@(posedge clk);		
	i<=4'b1111;
							s <= 2'b00; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 2'b01; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 2'b10; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
						s<= 2'b11; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
						@(posedge clk); 	@(posedge clk);	@(posedge clk);	@(posedge clk);	@(posedge clk);	
	i<=4'b0000;
							s <= 2'b00; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 2'b01; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
							s <= 2'b10; @(posedge clk);
												@(posedge clk);
												@(posedge clk);
						s <= 2'b11; @(posedge clk);
												@(posedge clk);
												@(posedge clk);	
							@(posedge clk); 	@(posedge clk);	@(posedge clk);	@(posedge clk);	@(posedge clk);						
																		
													
		$stop;
	end
	
endmodule 
