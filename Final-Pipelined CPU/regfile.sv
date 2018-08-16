//Kalvin Hallesy 1750416
//Irina Golub 1775424
//EE 469
//17 January 2018

module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	//creating all necessary i/o andlogics
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0] WriteData;
	input logic RegWrite, clk;
	output logic [63:0] ReadData1, ReadData2;
	logic	[31:0]			chosenRegister;
	logic [63:0] registers [31:0];
	logic reset = 0;
	
	//the following is modeled after the block diagram from the lab1 sheet
	
	//this creates a decoder with 5 WriteRegister inputs that decide which bit of a 32 bit chosenRegister should pass RegWrite
	decoder5_32 decodeme (RegWrite, WriteRegister, chosenRegister);
	
	//This contains the creation of 32 64-bit registers and takes the chosenRegister data from the decoder to determine if a register should have its write enabled
	createReg regs (registers,WriteData,chosenRegister,reset,clk);

	//Both of these are muxes that take a ReadRegister input to determine which register to read data from, it then outputs the 64-bit data from the selected register in ReadData
	giantMux mux1 (ReadData1,registers[0], registers[1],registers[2],registers[3],registers[4],
									registers[5],registers[6],registers[7],registers[8],registers[9],
									registers[10],registers[11],registers[12],registers[13],registers[14],
									registers[15],registers[16],registers[17],registers[18],registers[19],
									registers[20],registers[21],registers[22],registers[23],registers[24],
									registers[25],registers[26],registers[27],registers[28],registers[29],
									registers[30],64'b0,ReadRegister1,reset,clk);
									
	giantMux mux2 (ReadData2,registers[0], registers[1],registers[2],registers[3],registers[4],
									registers[5],registers[6],registers[7],registers[8],registers[9],
									registers[10],registers[11],registers[12],registers[13],registers[14],
									registers[15],registers[16],registers[17],registers[18],registers[19],
									registers[20],registers[21],registers[22],registers[23],registers[24],
									registers[25],registers[26],registers[27],registers[28],registers[29],
									registers[30],64'b0,ReadRegister2,reset,clk);
	
endmodule 

// Test bench for Register file
`timescale 1ns/10ps

module regstim(); 		

	parameter ClockDelay = 5000;

	logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	logic [63:0]	WriteData;
	logic 			RegWrite, clk;
	logic [63:0]	ReadData1, ReadData2;

	integer i;

	// Your register file MUST be named "regfile".
	// Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	regfile dut (.ReadData1, .ReadData2, .WriteData, 
					 .ReadRegister1, .ReadRegister2, .WriteRegister,
					 .RegWrite, .clk);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	initial begin
		
		for (i = 0; i<32; i++) begin
			RegWrite <= 0;
			WriteRegister <= i;
			WriteData <= i;
			@(posedge clk);
		
			RegWrite <= 1;
			@(posedge clk);
		end
		
		for (i = 0; i<31; i++) begin
			ReadRegister1 <= i;
			ReadRegister2 <= i+1;
			@(posedge clk);
		end
		
		
//		RegWrite <= 0;
//			ReadRegister1 <= 5'd3;
//			ReadRegister2 <= 5'd4;
//			WriteRegister <= 5'd3;
//			WriteData <= 64'h0000010204080001;
//			@(posedge clk);
//			
//			RegWrite <= 1;
//			@(posedge clk);
//			@(posedge clk);
//			
//			
//		// Write a value into each  register.
//		$display("%t Writing pattern to all registers.", $time);
//		for (i=0; i<31; i=i+1) begin
//			RegWrite <= 0;
//			ReadRegister1 <= i-1;
//			ReadRegister2 <= i;
//			WriteRegister <= i;
//			WriteData <= i*64'h0000010204080001;
//			@(posedge clk);
//			
//			RegWrite <= 1;
//			@(posedge clk);
//			@(posedge clk);
//		end
//		
//		RegWrite <= 1;
//		WriteRegister <= 5'd1;
//		ReadRegister1 <= 5'd2;
//		ReadRegister2 <= 5'd1;
//		@(posedge clk);
//		@(posedge clk);
//		@(posedge clk);


		$stop;
	end
endmodule