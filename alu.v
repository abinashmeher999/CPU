/* alu.v
* Arithmetic logic unit.
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

`include "constants.v"

module alu(
	clock, 
	reset, 
	primaryOperand, 
	secondaryOperand, 
	operation, 
	result,
	flags
	);
		
	input clock; // TODO: remove the clock from the port list, since we're not	using it anymore
	input reset; // Asynchronous reset; active low
	input[15:0] primaryOperand; // Used for all operations except passthrough
	input[15:0] secondaryOperand; // Used for two-operand operations
	input[2:0] operation; // Up to 16 operations
	output [15:0] result;
	reg[15:0] result;
	reg last_bit_c_in;
	reg last_bit_c_out;
	output[3:0] flags;
	reg[3:0] flags; //Overflow, Zero, carry, negative

	always @(*) begin
		result[15:0] = 16'd0; // Reset all of the bits so we don't infer any latches
		// But does the assignment (= rather than <=) cause extra logic?
		// Do the requested operation
		case(operation)
			`ALU_ADD: begin
				{last_bit_c_in, result[14:0]} = primaryOperand[14:0] + secondaryOperand[14:0];
				{last_bit_c_out, result[15]} = primaryOperand[15] + secondaryOperand[15] + last_bit_c_in;
				flags[`OVERFLOWFLAG] = last_bit_c_out^last_bit_c_in;
				flags[`CARRYFLAG] = last_bit_c_out; // See if a bit was carried
				flags[`NEGFLAG] = result[15];
			end

			`ALU_SUBTRACT: begin
				secondaryOperand = ~secondaryOperand;
				secondaryOperand = secondaryOperand + 16'd1;
				{last_bit_c_in, result[14:0]} = primaryOperand[14:0] + secondaryOperand[14:0];
				{last_bit_c_out, result[15]} = primaryOperand[15] + secondaryOperand[15] + last_bit_c_in;
				flags[`OVERFLOWFLAG] = last_bit_c_out^last_bit_c_in;
				flags[`CARRYFLAG] = last_bit_c_out; // See if a bit was carried
				flags[`NEGFLAG] = result[15];
			end
			
			`ALU_AND: begin
				result[15:0] = primaryOperand & secondaryOperand;
				flags[`CARRYFLAG] = 1'b0;
				flags[`OVERFLOWFLAG] = 1'b0;
				flags[`NEGFLAG] = result[15];
			end
			`ALU_OR: begin
				result[15:0] = primaryOperand | secondaryOperand;
				flags[`CARRYFLAG] = 1'b0;
				flags[`OVERFLOWFLAG] = 1'b0;	
				flags[`NEGFLAG] = result[15];
			end
			
			`ALU_COMPLEMENT: begin
				result = ~primaryOperand;
				flags[`CARRYFLAG] = 1'b0;
				flags[`OVERFLOWFLAG] = 1'b0;
				flags[`NEGFLAG] = result[15];
				end
			default: begin
				result[15:0] = 16'd0;
				flags[`OVERFLOWFLAG] = 1'b0;
				flags[`CARRYFLAG] = 1'b0;
				flags[`NEGFLAG] = 1'b0;
			end
		endcase

		

		else begin
			flags[`ZEROFLAG] = (result[15:0] == 16'h0000) ? 1'b1 : 1'b0;
		end // if(operation == `MULTIPLY)
	end //always @(posedge clock)

endmodule