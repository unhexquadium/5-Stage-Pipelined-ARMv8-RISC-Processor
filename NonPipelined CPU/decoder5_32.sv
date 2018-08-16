//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

`timescale 1ns/10ps
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

//This builds a 3:8 decoder out of two 2:4 decoders
module decoder3_8 (e, addr, out);

		output logic [7:0] out;
	input logic [2:0] addr;
	input logic e;
	logic [2:0] invaddr;
	
	not #50 n2(invaddr[2], addr[2]);
	not #50 n1(invaddr[1], addr[1]);
	not #50 n0(invaddr[0], addr[0]);
	
	and #50 a(out[0], invaddr[2], invaddr[1], invaddr[0], e);
	and #50 b(out[1], invaddr[2], invaddr[1], addr[0], e);
	and #50 c(out[2], invaddr[2], addr[1], invaddr[0], e);
	and #50 d(out[3], invaddr[2], addr[1], addr[0], e);
	and #50 i(out[4], addr[2], invaddr[1], invaddr[0], e);
	and #50 f(out[5], addr[2], invaddr[1], addr[0], e);
	and #50 g(out[6], addr[2], addr[1], invaddr[0], e);
	and #50 h(out[7], addr[2], addr[1], addr[0], e);
	
//	output logic [7:0] out;
//	input logic [2:0] addr;
//	input logic e;
//	logic inv;
//	logic [2:0] eaddr;
//	
//	and #50 d(eaddr[0], e, addr[0]);
//	and #50 c(eaddr[1], e, addr[1]);
//	and #50 f(eaddr[2], e, addr[2]);
//	
//	not #50 n(inv, eaddr[2]);
//	
//	decoder2_4 a (inv, eaddr[1:0], out[3:0]);
//	decoder2_4 b (eaddr[2], eaddr[1:0], out[7:4]);
	
	
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


module decoder5_32_testbench();

	logic [31:0] out;
	logic [4:0] addr;
	logic e;
	logic clk;
	
	decoder5_32 dut(e, addr, out);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values as well as reset input
	initial begin	
	e<=1; addr<= 5'b00100;	@(posedge clk);
									@(posedge clk);
	e<=0;							@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	e<=1; addr<= 5'b11111;	@(posedge clk);
									@(posedge clk);
									@(posedge clk);
			addr<= 5'b00001;	@(posedge clk);
									@(posedge clk);
									@(posedge clk);
		$stop;
	end

endmodule 

module decoder2_4_testbench();

	logic [3:0] out;
	logic [1:0] addr;
	logic e;
	logic clk;
	
	decoder2_4 dut(e, addr, out);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values as well as reset input
	initial begin	
	e<=1; addr<= 2'b00;	@(posedge clk);
									@(posedge clk);
	e<=0;							@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	e<=1; addr<= 2'b01;	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
			addr<= 2'b10;	@(posedge clk);
								@(posedge clk);
								@(posedge clk);
			addr<= 2'b11;	@(posedge clk);
			@(posedge clk);
									@(posedge clk);
		$stop;
	end

endmodule 