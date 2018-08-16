//main module, uses adder and mux8x64_1 to make whole alu

`timescale 1ns/10ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
 //new control choices: 
 // 000: Pass B
 //010: A+B
 //011: A-B
 //100: A * B
 //101: shift left A by B
 //110: shift right A by B
	output logic [63:0] result;
	output logic negative,zero,overflow,carry_out;
	input logic [2:0] cntrl;
	input logic [63:0] A, B;
	logic [63:0] result0, result2, result3, result4, result5, result6;
	logic [1:0] carry_out1, overflow1;
	logic sel;
	logic [20:0] orout;
	
	//sets each of the individual results for each operation the ALU does
	assign result0 = B;
	
	adder_64bit addme (A,B,1'b0,result2,carry_out1[0],overflow1[0]); //send carry_out and overflow through a 2_1 mux
	subtracter_64bit subme (A,B,result3,carry_out1[1],overflow1[1]);
	
	mult multiplyme (A, B, result4);
	shifter shiftleft (A, 1'b0, B[5:0], result5);
	shifter shiftright (A, 1'b1, B[5:0], result6);

	
	//chooses which operation (result number) based on the cntrl input
	mux8x64_1 resulting (result0, result2, result3, result4, result5, result6, cntrl, result);
	
	//uses consecutive or gates to set zero flag since logical operators aren't logical for this lab
	or #50 or1 (orout[0],result[0],result[1],result[2],result[3]);
	genvar i;
	generate
		for (i = 1; i<21; i++) begin: oring
			or #50 or2 (orout[i],orout[i-1],result[3*i+1],result[3*i+2],result[3*i+3]);
		end
	endgenerate
	not #50 not1 (zero,orout[20]);

	//sets negative flag by looking at result top most bit
	assign negative = 1'b1&result[63];
	
	assign sel = ~cntrl[2]&cntrl[1]&cntrl[0];
	//If the signal is subtract send a-b carryout and overflow. In all other cases, carry out and overflow correspond to a+b

	mux2_1 c (carry_out, carry_out1[0], carry_out1[1], sel);
	mux2_1 o (overflow, overflow1[0], overflow1[1], sel);
	
	//module mux2_1(out, i0, i1, sel);

	
endmodule



module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_B operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<5; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end //Pass B has been verified to work properly
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = -64'h0000000000000001; B = -64'h0000000000000001;
		#(delay);
		assert(result == -64'h0000000000000002 && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000001; B = -64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		$display("%t testing AND gate", $time);
		cntrl = ALU_AND;
		A = 64'h0000000000001000; B = 64'h0001001001001000;
		#(delay);
		assert(result == 64'h0000000000001000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		$display("%t testing OR gate", $time);
		cntrl = ALU_OR;
		A = 64'h0000000000001000; B = 64'h0001001001001000;
		#(delay);
		assert(result == 64'h0001001001001000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		$display("%t testing XOR gate", $time);
		cntrl = ALU_XOR;
		A = 64'h0000000000001000; B = 64'h0001001001001000;
		#(delay);
		assert(result == 64'h0001001001000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		
		
				$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h7FFFFFFFFFFFFFFF;
		#(delay);
		assert(result == -2 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h8000000000000000; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h7FFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
				$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h8000000000000001;
		#(delay);
		assert(result == 0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
	end
endmodule 