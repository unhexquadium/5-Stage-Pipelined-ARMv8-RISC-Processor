module setflag(clk, reset, SetFlags, aluflag, flag);

	//call this three times. For carry out, overflow, and negative.
	
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