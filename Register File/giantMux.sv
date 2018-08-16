//Kalvin Hallesy 1750416
//Irina Golub 177542orte4
//EE 469
//17 January 2018

//This creates 64 32:1 muxes so that each datapoint from each register can be selected between
//depending on the 5bit select input, only 64 bits from 1 register will be passed
module giantMux(out, in, s, reset, clk);

	output logic  [63:0]  out;
	input  logic  [63:0][31:0] in;
	input logic   [4:0] s;
	input  logic          clk,reset;
  
	genvar i;
  
	generate
		for(i=0; i<64; i++) begin : muxing
			mux32_1 mmmm(out[i],in[i],s[4:0]);
		end
	endgenerate

endmodule
	