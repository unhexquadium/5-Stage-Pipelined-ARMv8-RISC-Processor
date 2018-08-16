//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

`timescale 1ns/10ps
//a 2:1 mux made from basic gates
module mux2_1(out, i0, i1, sel);	

	output logic out; 	
	input  logic i0, i1, sel; 	
	logic out1,out2, notsel;
		
	//the gates form the equation out = i0*sel + i1*(~sel)
	and #50 firstand (out1, i1, sel); 
	not #50 notgate (notsel, sel); 
	and #50 secondand (out2, i0, notsel); 
	
	or #50 outmux (out, out1, out2);  
	
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

module mux16_1(out,i,s);
	output logic	out;
	input logic	[15:0] i;
	input logic [3:0] s;
	logic 				mux1,mux2;
	
	mux8_1 m1 (mux1,i[7:0],s[2:0]);
	mux8_1 m2 (mux2,i[15:8],s[2:0]);
	mux2_1 m3 (out, mux1,mux2,s[3]);
endmodule

//the final product is a 32:1 mux with a 5 bit select 
module mux32_1(out,i,s);
	output logic	out;
	input logic	[31:0] i;
	input logic [4:0] s;
	logic 				mux1,mux2;
	
	mux16_1 m1 (mux1,i[15:0],s[3:0]);
	mux16_1 m2 (mux2,i[31:16],s[3:0]);
	mux2_1 m3 (out, mux1,mux2,s[4]);
endmodule
