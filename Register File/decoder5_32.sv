//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

`timescale 1ns/10ps
//This builds a 3:8 decoder out of basic gates
module decoder3_8 (e, addr, out);

	output logic [7:0] out;
	input logic [2:0] addr;
	input logic e;
	logic [2:0] inv;
	
	not #50 n1(inv[0], addr[0]);
	not #50 n2(inv[1], addr[1]);
	not #50 n3(inv[2], addr[2]); 
	
	and #50 a1(out[0], inv[2], inv[1], inv[0], e);
	and #50 a2(out[1], inv[2], inv[1], addr[0], e);
	and #50 a3(out[2], inv[2], addr[1], inv[0], e);
	and #50 a4(out[3], inv[2], addr[1], addr[0], e);
	and #50 a5(out[4], addr[2], inv[1], inv[0], e);
	and #50 a6(out[5], addr[2], inv[1], addr[0], e);
	and #50 a7(out[6], addr[2], addr[1], inv[0], e);
	and #50 a8(out[7], addr[2], addr[1], addr[0], e);
	
endmodule

//this builds a 2:4 decoder out of basic gates
module decoder2_4 (e, addr, out);
	
	output logic [3:0] out;
	input logic [1:0] addr;
	input logic e;
	logic [1:0] inv;
	
	not #50 n1(inv[0], addr[0]);
	not #50 n2 (inv[1], addr[1]);
	
	and #50 a1(out[0], inv[1], inv[0],e);
	and #50 a2(out[1], inv[1], addr[0],e);
	and #50 a3(out[2], addr[1], inv[0],e);
	and #50 a4(out[3], addr[1], addr[0],e);
	

endmodule 

//This builds a 5_32 decoder out of the other two decoders
module decoder5_32 (e, addr, out);

	output logic [31:0] out;
	input logic [4:0] addr;
	input logic e;
	logic [3:0] outenable;
	
	//the structure of our 5:32 decoder is 4 3:8 decoders' sharing their 3-bit inputs along with having seperate enable lines controlled by a single 2:4 decoder that is controlled by the other 2 inputs
	decoder2_4 a (e, addr[4:3], outenable);
	decoder3_8 b (outenable[0], addr[2:0], out[7:0]); //outputs 0-7
	decoder3_8 c (outenable[1], addr[2:0], out[15:8]); //outputs 8-15
	decoder3_8 d (outenable[2], addr[2:0], out[23:16]); //outputs 16-23
	decoder3_8 elm (outenable[3], addr[2:0], out[31:24]); //outputs 24-31
	

endmodule 
