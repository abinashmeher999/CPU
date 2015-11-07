/* control_signals.v
* Module which translates the control module state into the set of control
signals
* for the rest of the chip.
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/


‘include "constants.v"

module control_signals(
input[4:0] state, // State from the control state machine
input[15:0] opcode, // Full 16-bit opcode from the instruction register
input[2:0] alu_flags, // Carry/Zero/Negative flags from ALU



output ir_load_high, // Load the high 8 bits of the instruction from the
data bus
output ir_load_low, // Load the low 8 bits of the instruction
output gp_read, // Read a value from the data bus into a register
output gp_write, // Write a value from the register onto the data bus
output pc_set, // Set the program counter from the jump register
output pc_increment, // Increment the program counter
output mem_read, // Read a value from memory onto the data bus
output mem_write, // Write a value from the data bus out to memory (RAM)
output latch_alu,
output alu_store_high, // Write the high 8 bits of the ALU result to the
data bus
output alu_store_low, // Write the low 8 bits of the ALU result to the data
bus
output jr_load_high, // Load the high 8 bits of the jump destination into
the jump register
output jr_load_low, // Load the low 8 bits of the jump destination
output mar_load_high, // Load the high 8 bits of the memory address into the
MAR
output mar_load_low, // Load the low 8 bits of the memory address

output[3:0]
output[2:0]
output[2:0]
bus
output[2:0]
directly
);
alu_operation,
gp_input_select,
gp_output_select, // Register select for GP registers to data
gp_alu_output_select // Register select for GP registers
to ALU

// Signals directly from the opcode
assign alu_operation = (opcode[15:11] === ‘MOVE) ? ‘ALU_PASSTHROUGH : opcode
[14:11];
// The assignments below assume that the ALU operand directly from the GP
registers
// is the "primary operand" used for unary operations.
assign gp_input_select[2:1] = opcode[4:3]; // GP registers from data bus

wire gp_address_force; // Bit used to force a particular address when using
a multiply
assign gp_address_force = (state === ‘S_STORE_RESULT_2) ? 1’b1 : 1’b0;
assign gp_input_select[0] = (opcode[15:11] === ‘MULTIPLY) ? gp_address_force
: opcode[2];
assign gp_output_select = opcode[7:5]; // GP registers to the data bus
assign gp_alu_output_select = opcode[4:2]; // GP registers to the ALU

// Signals from the state machine
assign ir_load_high = (state === ‘S_FETCH_1);
assign ir_load_low = (state === ‘S_FETCH_2);
// Read into the registers if we have a store, a copy, or are loading an
immediate into a register
assign gp_read = (state === ‘S_STORE_RESULT_1 || state === ‘S_STORE_RESULT_2
||
state === ‘S_COPY_REGISTER || state === ‘S_FETCH_MEMORY ||
(state === ‘S_FETCH_IMMEDIATE && opcode[15:11] === ‘LOAD))
;
// Write from the registers if we have a register ALU operation or a store
assign gp_write = ((state === ‘S_ALU_OPERATION && opcode[10:9] === 2’b00) ||
state === ‘S_STORE_MEMORY || state === ‘S_COPY_REGISTER);
// Jump only if the code from the ALU tells us to
assign pc_set = (state === ‘S_EXECUTE_JUMP &&
(opcode[1:0] === 2’b00 ||
(opcode[1:0] === 2’b01 && alu_flags[‘CARRYFLAG] == 1’b1) ||
(opcode[1:0] === 2’b10 && alu_flags[‘ZEROFLAG] == 1’b1) ||
(opcode[1:0] === 2’b11 && alu_flags[‘NEGFLAG] == 1’b1)));

assign pc_increment = (state === ‘S_FETCH_1 || state === ‘S_FETCH_2 ||
state === ‘S_FETCH_IMMEDIATE || state ===
‘S_ALU_IMMEDIATE ||
state === ‘S_FETCH_ADDRESS_1 || state ===
‘S_FETCH_ADDRESS_2 ||
state === ‘S_FETCH_ADDRESS_3 || state ===
‘S_FETCH_ADDRESS_4 ||
state === ‘S_LOAD_JUMP_1 || state === ‘S_LOAD_JUMP_2)
;
assign mem_read = (state === ‘S_FETCH_1 || state === ‘S_FETCH_2 ||
state === ‘S_FETCH_IMMEDIATE || state ===
‘S_ALU_IMMEDIATE ||
state === ‘S_FETCH_ADDRESS_1 || state ===
‘S_FETCH_ADDRESS_2 ||
state === ‘S_FETCH_MEMORY || state === ‘S_TEMP_FETCH ||
state === ‘S_FETCH_ADDRESS_3 || state ===
‘S_FETCH_ADDRESS_4 ||
state === ‘S_LOAD_JUMP_1 || state === ‘S_LOAD_JUMP_2);

assign mem_write = (state === ‘S_STORE_MEMORY || state === ‘S_TEMP_STORE);
assign latch_alu = (state === ‘S_ALU_OPERATION || state === ‘S_ALU_IMMEDIATE
||
state === ‘S_TEMP_FETCH);
// On store 1, store the lower half, unless there is a multiply.
assign alu_store_high = (state === ‘S_STORE_RESULT_1 && opcode[15:11] ===
‘MULTIPLY);
assign alu_store_low = ((state === ‘S_STORE_RESULT_1 && opcode[15:11] !==
‘MULTIPLY) ||
state === ‘S_STORE_RESULT_2 || state ===
‘S_TEMP_STORE);
assign jr_load_high = (state === ‘S_LOAD_JUMP_1);
assign jr_load_low = (state === ‘S_LOAD_JUMP_2);

assign mar_load_high = (state === ‘S_FETCH_ADDRESS_1 || state ===
‘S_FETCH_ADDRESS_3);
assign mar_load_low = (state === ‘S_FETCH_ADDRESS_2 || state ===
‘S_FETCH_ADDRESS_4);

endmodule