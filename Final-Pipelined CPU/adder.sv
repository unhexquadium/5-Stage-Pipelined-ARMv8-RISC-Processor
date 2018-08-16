//builds adder and subtracter from base gate-level adder

`timescale 1ns/10ps
module adder(x,y,cin,z,cout);

	output logic z, cout;
	input logic x,y,cin;
	
	//makes full adder out of gates
	assign z = (x^y^cin);
	assign cout = (x&(cin|y)) | (cin&y);

endmodule 


module adder_64bit (A,B,cin,Z,carry_out, overflow);

	output logic [63:0] Z;
	output logic carry_out, overflow;
	input logic [63:0] A, B;
	input logic cin;
	logic [63:0] cout;
	
	//doest addition of lsb and preps first carry
	adder a(A[0], B[0], cin, Z[0], cout[0]);
	
	//adds the rest of the bits
	genvar i;
	generate
		
		for (i = 1; i<64; i++) begin: adding
			adder b(A[i], B[i], cout[i-1], Z[i], cout[i]);
		end
		
	endgenerate
	
	assign carry_out = cout[63];
	assign overflow = cout[62] ^ cout[63];
	
endmodule 


module subtracter_64bit (A,B,Z,carry_out,overflow);
	
	output logic [63:0] Z;
	output logic carry_out, overflow;
	input logic [63:0] A, B;

	//to subtract A-B, Do A + (-B) by doing A+ ~B and setting Cin = 1	
	adder_64bit subtract (A, ~B, 1'b1, Z, carry_out, overflow);
	
	
endmodule 

module adder_64bit_testbench();

	logic [63:0] Z;
 logic carry_out, overflow;
	logic [63:0] A,B;
	logic cin;
	logic clk;
	
	adder_64bit dut(A,B,cin,Z,carry_out,overflow);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
	cin<=0;							@(posedge clk);
	A<=64'd0; 	B<=64'd0;		@(posedge clk); 
	A<=64'd1; 	B<=64'd1;		@(posedge clk);
										@(posedge clk);
	A<=64'd10; 	B<=64'd10;		@(posedge clk); 
										@(posedge clk);
	A<=64'd100; B<=64'd100;		@(posedge clk); 
										@(posedge clk);
	A<=64'd12; 	B<=-64'd3;		@(posedge clk);
										@(posedge clk);
	A<=64'd0; 	B<=-64'd49;		@(posedge clk); 
										@(posedge clk);
	A<=-64'd2; 	B<=-64'd3;		@(posedge clk); 
										@(posedge clk);
	A<=-64'd12; 	B<=64'd3;	@(posedge clk); 
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);

		$stop;
	end
	
endmodule 


module subtracter_64bit_testbench();

	logic [63:0] Z;
 logic carry_out, overflow;
	logic [63:0] A,B;
	logic clk;
	
	subtracter_64bit dut(A,B,Z,carry_out,overflow);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	//Test many cycles for a sample of output values
	initial begin	
										@(posedge clk);
	A<=64'd0; 	B<=64'd0;		@(posedge clk); 
	A<=64'd1; 	B<=64'd1;		@(posedge clk);
										@(posedge clk);
	A<=64'd10; 	B<=64'd10;		@(posedge clk); 
										@(posedge clk);
	A<=64'd100; B<=64'd100;		@(posedge clk); 
										@(posedge clk);
	A<=64'd12; 	B<=-64'd3;		@(posedge clk);
										@(posedge clk);
	A<=64'd0; 	B<=-64'd49;		@(posedge clk); 
										@(posedge clk);
	A<=-64'd2; 	B<=-64'd3;		@(posedge clk); 
										@(posedge clk);
	A<=-64'd12; 	B<=64'd3;	@(posedge clk); 
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);
	A <= $random(); B <= $random();	@(posedge clk);

		$stop;
	end
	
endmodule 
