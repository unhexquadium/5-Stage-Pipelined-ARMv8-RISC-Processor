//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

//This creates the 32 registers of 64 DFF and passes the necessary enable values from the decoder
module createReg (register, d,e, reset, clk);

	output logic [31:0][63:0] register;
	input logic [63:0] d;
	input logic [31:0] e;
	input logic reset, clk;
	
	genvar i;
	
	generate
		for(i=0; i<31; i++) begin : eachreg
			D_FF64 oneregister (register[i][63:0],d[63:0],reset,clk,e[i]);
		end
	endgenerate
	
	//this is to ensure that the zero register will always contain all zeroes
	D_FF64 zeroes (register[31][63:0],64'b0,1,clk,e[31]);
endmodule 