//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

//This creates 64 32:1 muxes so that each datapoint from each register can be selected between
//depending on the 5bit select input, only 64 bits from 1 register will be passed
`timescale 1ns/10ps
module giantMux(out, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, 
							 reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, 
							 reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, 
							 reg30, reg31,s, reset, clk);

							 
	output logic  [63:0]  out;
	input logic [63:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, 
							 reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, 
							 reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
	input logic   [4:0] s;
	input  logic          clk,reset;
  
	genvar i;
  
	generate
		for(i=0; i<64; i++) begin : muxing
			mux32_1 mmmm(out[i],{reg31[i], reg30[i], reg29[i], reg28[i], reg27[i], reg26[i], reg25[i], 
										reg24[i], reg23[i], reg22[i], reg21[i], reg20[i], reg19[i], reg18[i], 
										reg17[i], reg16[i], reg15[i], reg14[i], reg13[i], reg12[i], reg11[i], 
										reg10[i], reg9[i], reg8[i], reg7[i], reg6[i], reg5[i], reg4[i], 
										reg3[i], reg2[i], reg1[i], reg0[i]},s[4:0]);
		end
	endgenerate

endmodule
	
module giantMux_testbench();

	logic [63:0] out;
	logic [63:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, 
							 reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, 
							 reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
	logic [4:0] s;
	logic clk, reset;
	
	giantMux dut(out, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, 
							 reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, 
							 reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, 
							 reg30, reg31, s, reset, clk);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	

	reset <= 0;					
	reg0 <= 64'h0000010204080001;	reg1 <= 64'h0000000000000000;	reg2 <= 64'h0000010204080001;
	reg3 <= 64'h0000010204080001;	reg4 <= 64'h0000010204080001;	reg5 <= 64'h0000000000000000;
	reg6 <= 64'h0000010204080001;	reg7 <= 64'h0000010204080001;	reg8 <= 64'h0000010204080001;
	reg9 <= 64'h0000000000000000;	reg10 <= 64'h0000010204080001;	reg11 <= 64'h0000010204080001;
	reg12 <= 64'h0000010204080001;	reg13 <= 64'h0000010204080001;	reg14 <= 64'h0000010204080001;
	reg15 <= 64'h0000010204080001;	reg16 <= 64'h0000010204080001;	reg17 <= 64'h0000010204080001;
	reg18 <= 64'h1111111111111111;	reg19 <= 64'h1111111111111111;	reg20 <= 64'h1111111111111111;
	reg21 <= 64'h1111111111111111;	reg22 <= 64'h0000010204080001;	reg23 <= 64'h0000000000000000;
	reg24 <= 64'h0000010204080001;	reg25 <= 64'h1111111111111111;	reg26 <= 64'h0000010204080001;
	reg27 <= 64'h0000010204080001;	reg28 <= 64'h0000010204080001;	reg29 <= 64'h0000000000000000;
	reg30 <= 64'h0000010204080001;	reg31 <= 64'h0000010204080001;	@(posedge clk);
	
	
		s<=5'b0;		@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
		s<=5'd20;	@(posedge clk);
		@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
		@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
//		s<=5'd19;	@(posedge clk);
//		@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//		@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//		s<=5'd21;	@(posedge clk);
//		@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//		@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
//						@(posedge clk);
		s<=5'd29;	@(posedge clk);
		@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
		$stop;
	end

endmodule 