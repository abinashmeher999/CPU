/* datapath.v
* Datapath which includes the general purpose registers, special purpose
* registers, ALU, and the connections between them.

* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

module datapath(
input clock,
input reset,
input pc_increment,
input pc_set,
input gp_read,
input gp_write,
input[2:0] gp_input_select,
input[2:0] gp_output_select,
input[2:0] gp_alu_output_select,
input[3:0] alu_operation,
input latch_alu,
input alu_store_high,
input alu_store_low,
input mar_set_high,
input mar_set_low,
input ir_set_high,
input ir_set_low,
input jr_set_high,
input jr_set_low,

output
output
output
output
wire[15:0] pc_count, // Program counter output
wire[15:0] mar_value, // Memory address register output
wire[15:0] ir_value, // Instruction register output
wire[2:0] flags, // ALU flags

inout[7:0] data_bus
);

	// Shared connections
	wire[7:0] register_operand; // Bus from the general-purpose registers to the ALU

	wire[15:0] pc_jump_count; // Bus from the jump register to the program counter (value to jump to)
	wire[15:0] alu_result;
	wire[2:0] flags_temp;

	// Program counter (only reads from jump register, not data bus)
	program_counter m_program_counter(clock, reset, 
		pc_increment, 
		pc_set, 
		pc_jump_count, 
		pc_count);

	// Jump register which holds the value for the program counter to jump to
	register_16bit m_jump_register(clock, 
		reset, 
		jr_set_high, 
		jr_set_low,
		data_bus, 
		pc_jump_count);


	// General-purpose registers
	gp_registers m_gp_registers(clock, 
		reset, 
		gp_read, 
		gp_write, 
		gp_input_select, 
		gp_output_select, 
		gp_alu_output_select, 
		data_bus, 
		register_operand);

	// ALU and ALU latch
	alu m_alu(clock, 
		reset, 
		register_operand, 
		data_bus, 
		alu_operation, 
		alu_result, 
		flags_temp);

	alu_latch m_alu_latch(clock, 
		reset, 
		alu_result, 
		flags_temp, 
		latch_alu, 
		alu_store_high, 
		alu_store_low, 
		data_bus, 
		flags);

	// Memory address register
	register_16bit m_address_register(clock, 
		reset, 
		mar_set_high, 
		mar_set_low, 
		data_bus, 
		mar_value);

	// Instruction register
	register_16bit m_instruction_register(clock, 
		reset, 
		ir_set_high, 
		ir_set_low, 
		data_bus, 
		ir_value);

endmodule