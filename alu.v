/* alu.v
* Arithmetic logic unit.
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

`include "constants.v"

module alu(clock, reset, primaryOperand, secondaryOperand, operation, result,
flags);
	parameter SIZE = 16;
		
	input clock; // TODO: remove the clock from the port list, since we're not	using it anymore
	input reset; // Asynchronous reset; active low
	input[SIZE-1:0] primaryOperand; // Used for all operations except passthrough
	input[SIZE-1:0] secondaryOperand; // Used for two-operand operations
	input[3:0] operation; // Up to 16 operations
	output[SIZE-1:0] result;
	reg[SIZE-1:0] result;
	reg last_bit_c_in;
	reg last_bit_c_out;
	output[3:0] flags;
	reg[3:0] flags; //Overflow, Zero, carry, negative

	always @(*) begin
		result[SIZE-1:0] = 16'd0; // Reset all of the bits so we don't infer any latches
		// But does the assignment (= rather than <=) cause extra logic?
		// Do the requested operation
		case(operation)
			`ALU_ADD: begin
				{last_bit_c_in, result[SIZE-2:0]} = primaryOperand[SIZE-2:0] + secondaryOperand[SIZE-2:0];
				{last_bit_c_out, result[SIZE-1]} = primaryOperand[SIZE-1] + secondaryOperand[SIZE-1] + last_bit_c_in;
				flags[`OVERFLOWFLAG] = last_bit_c_out^last_bit_c_in;
				flags[`CARRYFLAG] = last_bit_c_out; // See if a bit was carried
				flags[`NEGFLAG] = result[SIZE-1];
			end
			`ALU_SUBTRACT: begin
				{last_bit_c_in, result[SIZE-1:0]} = primaryOperand - secondaryOperand;
				flags[`CARRYFLAG] = extra; // If the bit is a 1, then we had to borrow
				flags[`NEGFLAG] = result[SIZE-1];
			end
			
			`ALU_AND: begin
				result[SIZE-1:0] = primaryOperand & secondaryOperand;
				flags[`CARRYFLAG] = 1'b0;
				flags[`NEGFLAG] = result[SIZE-1;
			end
			`ALU_OR: begin
				result[SIZE-1:0] = primaryOperand | secondaryOperand;
				flags[`CARRYFLAG] = 1'b0;
				flags[`NEGFLAG] = result[SIZE-1];
			end
			
			`ALU_COMPLEMENT: begin
				result = ~primaryOperand;
				flags[`CARRYFLAG] = 1'b0;
				flags[`NEGFLAG] = result[SIZE-1];
				end
			default: begin
				result[SIZE-1:0] = SIZE-1'd0;
				flags[`CARRYFLAG] = 1'b0;
				flags[`NEGFLAG] = 1'b0;
			end
		endcase

		

		else begin
			flags[`ZEROFLAG] = (result[SIZE-1:0] == 16'h0) ? 1'b1 : 1'b0;
		end // if(operation == `MULTIPLY)
	end //always @(posedge clock)

endmodule