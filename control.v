/* control.v
* Control module which fetches instructions and drives all of the other
* modules.
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

`include "constants.v"

module control (
input clock,
input reset,
input[15:0] instruction, // Value from the instruction register
output reg[4:0] state // Current control state
);

	always @(posedge clock) begin
		// Moving into reset is handled by an if statement at the end
		case(state)
			`S_RESET:
				// Everything is zero
				if(reset != 1'b0) begin // If reset is no longer asserted, it's time
					to start!
					state <= `S_FETCH_1;
				end
			`S_FETCH_1:
				// Always to go to fetch 2, since every opcode is two bytes
				state <= `S_FETCH_2;
			`S_FETCH_2:
				// Figure out what to do next based on the first half of the opcode
				// We won't have the second half until the end of the clock
				if(instruction[15:11] == `NOP) begin
					state <= `S_FETCH_1;
				end
				else if(instruction[15:11] == `JUMP) begin
					state <= `S_LOAD_JUMP_1;
				end
				// If the opcode begins with a zero, then it's an ALU operation, except if it's
				// 01101 or 01110, which are not used (JUMP and NOP are already handled)
				else if(instruction[15] == 1'b0 
				&& instruction[15:11] != 5'b01101 
				&& instruction != 5'b01110) begin
					if(instruction[10:9] == `SOURCE_REGISTER) begin
						state <= `S_ALU_OPERATION;
					end
					else begin // TODO: Crash gracefully if it's invalid
						state <= `S_ALU_IMMEDIATE;
					end
				end
				else if(instruction[15:11] == `LOAD) begin
					if(instruction[10:9] == `SOURCE_REGISTER) begin
						state <= `S_COPY_REGISTER;
					end
					else if(instruction[10:9] == `SOURCE_IMMEDIATE) begin
						state <= `S_FETCH_IMMEDIATE;
					end
					else if(instruction[10:9] == `SOURCE_MEMORY) begin
						state <= `S_FETCH_ADDRESS_1;
					end
				end
				else if(instruction[15:11] == `STORE 
					|| instruction[15:11] == `MOVE) begin
					state <= `S_FETCH_ADDRESS_1;
				end
				else if(instruction[15:11] == `S_HALT) begin
					state <= `S_HALT;
				end
				else begin
					state <= `S_HALT;
				end

			`S_ALU_OPERATION:
			state <= `S_STORE_RESULT_1;

			`S_ALU_IMMEDIATE:
			state <= `S_STORE_RESULT_1;

			`S_STORE_RESULT_1:
			// If the operation was a multiply, we have to do 2 stores
			if(instruction[15:11] == `MULTIPLY) begin
				state <= `S_STORE_RESULT_2;
			end
			// Otherwise, we're ready for the next operation
			else begin
				state <= `S_FETCH_1;
			end
			`S_STORE_RESULT_2:
				state <= `S_FETCH_1;
			`S_FETCH_IMMEDIATE:
			// Because this state is used both for storing immediates into the  registers
			// and for grabbing immediate values for the ALU, this state loads the immediate
			// value into the register. It will be overwritten by the ALU result if there is one.
			// This could be fixed by creating a separate state for loading immediates.
				if(instruction[15:11] == `LOAD) begin
					state <= `S_FETCH_1;
				end
				else begin
					state <= `S_ALU_OPERATION;
				end
			`S_COPY_REGISTER:
				state <= `S_FETCH_1;
			`S_FETCH_ADDRESS_1:
				state <= `S_FETCH_ADDRESS_2;
			`S_FETCH_ADDRESS_2:
				if(instruction[15:11] == `LOAD) begin
					state <= `S_FETCH_MEMORY;
				end
				else if(instruction[15:11] == `STORE) begin
					state <= `S_STORE_MEMORY;
				end
				else if(instruction[15:11] == `MOVE) begin
					state <= `S_TEMP_FETCH;
				end
			`S_FETCH_MEMORY:
				state <= `S_FETCH_1;
			`S_STORE_MEMORY:
				state <= `S_FETCH_1;
			`S_TEMP_FETCH:
				state <= `S_FETCH_ADDRESS_3;
			`S_FETCH_ADDRESS_3:
				state <= `S_FETCH_ADDRESS_4;
			`S_FETCH_ADDRESS_4:
				state <= `S_TEMP_STORE;
			`S_TEMP_STORE:
				state <= `S_FETCH_1;
			`S_LOAD_JUMP_1:
				state <= `S_LOAD_JUMP_2;
			`S_LOAD_JUMP_2:
				state <= `S_EXECUTE_JUMP;
			`S_EXECUTE_JUMP:
				state <= `S_FETCH_1;
			`S_HALT:
				state <= `S_HALT; // Just stay put!
		endcase
		if(reset == 0) begin
		state <= `S_RESET;
		end

	end
endmodule


