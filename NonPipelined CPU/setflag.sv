//Used to transfer value into a flip-flop to be stored, specifically flags
//call this for each flag to give them their own ffs

module setflag(clk, reset, SetFlags, aluflag, flag);

	
	output logic flag; //old flag
	input logic aluflag, SetFlags, clk, reset; //new flag
	logic choice;
	
	//if e=0, flag <= old flag. If e=1,  flag <= new flag.
	mux2_1 flagmux (choice, flag, aluflag, SetFlags);
	
	always_ff @(posedge clk) begin
		if (reset)
			flag <= 0;
		else
			flag <= choice;
	end

endmodule 