/* alu_latch.v
* Grabs the result from the ALU and puts it on the data bus
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

module alu_latch(
	input clock,
	input reset,
	input[15:0] alu_result, // Result from the ALU
	input[3:0] flags, // ALU flags which must also be latched
	input ALU_latch_in, // Active-high signal telling us whether or not to latch the value
	input ALU_latch_out,
	output reg[15:0] out,
	output reg[3:0] flags_out
);

	reg[15:0] value; // Stores the full-length output value

	always @(posedge clock) begin
		if(reset == 1'b1) begin
			value <= 16'b0;
		end
		if(ALU_latch_in == 1'b1) begin // Latch the ALU value when the ALU_latch_in signal is high
			value <= alu_result;
			flags_out <= flags;
		end
		/* This part will synthesize into combinational logic which puts	* the appropriate set of signals onto the data bus. */
		if(ALU_latch_out) begin 
			out <= value;
		end else begin
			out <= 16'hzz;
		end
	end // always

endmodule