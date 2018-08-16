//This module is responsible for determining whether a value from later in the pipeline needs to be forwarded back

`timescale 1ns/10ps
module forwarding (EXMEMregwrite, MEMWBregwrite, IDEXrm, IDEXrn, EXMEMrd, MEMWBrd, prevdestreg_1, prevWE_1, ForwardB, ForwardA);

	output logic [1:0] ForwardA, ForwardB;
	input logic [4:0] IDEXrm, IDEXrn, EXMEMrd, MEMWBrd, prevdestreg_1;
	input logic MEMWBregwrite, EXMEMregwrite, prevWE_1;
	
	
	//this uses if-else statements so that more recent register updates have a higher priority
	always_comb begin
		//compare EX/MEM pipeline Rd with ID/EX pipeline Rn first
		if (EXMEMregwrite && (EXMEMrd != 5'd31) && (EXMEMrd == IDEXrn)) begin
			ForwardA = 2'b10; //prior ALU result from MEM stage is input 2 into muxes
		end
		
		//otherwise, compare MEM/WB pipeline Rd with ID/EX pipeline Rn first
		else if (MEMWBregwrite && (MEMWBrd != 5'd31) && (MEMWBrd == IDEXrn)) begin
			ForwardA = 2'b01; //writeBack result is input 1 into muxes
		end
		
		else if (prevWE_1 && (prevdestreg_1 != 5'd31) && (prevdestreg_1 == IDEXrn)) begin
			ForwardA = 2'b11; //writeBack result is input 3 into muxes
		end
		
		else begin
			ForwardA = 2'b00;
		end
		
		//Same as above logic but for other input
		if (EXMEMregwrite && (EXMEMrd != 5'd31) && (EXMEMrd == IDEXrm)) begin
			ForwardB = 2'b10;
		end
		
		else if (MEMWBregwrite && (MEMWBrd != 5'd31) && (MEMWBrd == IDEXrm)) begin
			ForwardB = 2'b01;
		end
		
		else if (prevWE_1 && (prevdestreg_1 != 5'd31) && (prevdestreg_1 == IDEXrm)) begin
			ForwardB = 2'b11;
		end
		
		else begin
			ForwardB = 2'b00;
		end
		
		
	end

endmodule 


module forwarding_testbench();

	logic [1:0] ForwardA, ForwardB;
	logic [4:0] IDEXrm, IDEXrn, EXMEMrd, MEMWBrd, prevdestreg_1;
	logic MEMWBregwrite, EXMEMregwrite, prevWE_1, clk;
	
	forwarding dut (EXMEMregwrite, MEMWBregwrite, IDEXrm, IDEXrn, EXMEMrd, MEMWBrd, prevdestreg_1, prevWE_1, ForwardB, ForwardA);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	initial begin

		EXMEMregwrite <= 0;
		MEMWBregwrite <= 1;
		prevWE_1 <= 1;
		IDEXrm <= 5'd3;
		IDEXrn <= 5'd23;
		EXMEMrd <= 5'd4;
		MEMWBrd <= 5'd7;
		prevdestreg_1 <= 5'd1; //ForwardA = 0
					//ForwardB = 0
		@(posedge clk);

		prevdestreg_1 <= 5'd23; //ForwardA = 11
		@(posedge clk);	//ForwardB = 0

		MEMWBrd <= 5'd23; 	//ForwardA = 01
		@(posedge clk)	;	//ForwardB = 0
		
		EXMEMrd<= 5'd23; 	//ForwardA = 01
		@(posedge clk);	//ForwardB = 0

		EXMEMregwrite <= 1; @(posedge clk); //ForwardA = 10
						   //ForwardB = 0;
		
		prevdestreg_1 <= 5'd3;
		MEMWBrd <= 5'd3;	//ForwardA = 10
		@(posedge clk);		//ForwardB = 0
		
		IDEXrm <= 5'd31;
		MEMWBrd <= 5'd31;	//ForwardA = 10
		@(posedge clk);		//ForwardB = 00

		EXMEMregwrite <= 0;
		MEMWBregwrite <= 0;
		prevWE_1 <= 0;		//ForwardA = 00
		@(posedge clk);		//ForwardB = 00
		
		
	end
endmodule 