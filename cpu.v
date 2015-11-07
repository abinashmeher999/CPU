/* cpu.v Top level module for IC design project
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

module cpu(
input clock,
input reset,
inout[7:0] external_data_bus,
output[15:0] address_bus,
output ram_enable,
output rom_enable,
output write,
output write_bar,
output[4:0] state
);

// Signals from control module to datapath
wire pc_increment;
wire pc_set;
wire gp_read;
wire gp_write;
wire[2:0] gp_input_select;
wire[2:0] gp_output_select;
wire[2:0] gp_alu_output_select;
wire[3:0] alu_operation;
wire latch_alu;
wire alu_store_high;
wire alu_store_low;
wire mar_set_high;
wire mar_set_low;
wire ir_set_high;
wire ir_set_low;
wire jr_set_high;
wire jr_set_low;

// Signals from datapath to control module
wire[15:0] ir_value; // Instruction register
wire[2:0] alu_flags;

// Other signals from datapath
wire[15:0] pc_count;
wire[15:0] mar_value;

wire[7:0] data_bus; // Internal data bus

//wire[4:0] state;
wire[15:0] address_mux_out;
datapath dp(.clock(clock),
.reset(reset),
.pc_increment(pc_increment),
.pc_set(pc_set),
.gp_read(gp_read),
.gp_write(gp_write),
.gp_input_select(gp_input_select),
.gp_output_select(gp_output_select),
.gp_alu_output_select(gp_alu_output_select),
.alu_operation(alu_operation),
.latch_alu(latch_alu),
.alu_store_high(alu_store_high),
.alu_store_low(alu_store_low),
.mar_set_high(mar_set_high),
.mar_set_low(mar_set_low),
.ir_set_high(ir_set_high),
.ir_set_low(ir_set_low),
.jr_set_high(jr_set_high),
.jr_set_low(jr_set_low),
.pc_count(pc_count),
.mar_value(mar_value),
.ir_value(ir_value),
.flags(alu_flags),
.data_bus(data_bus));

control cm(.clock(clock),
.reset(reset),
.instruction(ir_value),
.state(state));

control_signals cs(.state(state),
.opcode(ir_value),
.alu_flags(alu_flags),
.ir_load_high(ir_set_high),
.ir_load_low(ir_set_low),
.gp_read(gp_read),
.gp_write(gp_write),
.pc_set(pc_set),
.pc_increment(pc_increment),
.mem_read(mem_read),
.mem_write(mem_write),
.latch_alu(latch_alu),
.alu_store_high(alu_store_high),
.alu_store_low(alu_store_low),
.jr_load_high(jr_set_high),
.jr_load_low(jr_set_low),
.mar_load_high(mar_set_high),
.mar_load_low(mar_set_low),
.alu_operation(alu_operation),

.gp_input_select(gp_input_select),
.gp_output_select(gp_output_select),
.gp_alu_output_select(gp_alu_output_select));

address_mux am(.pc_value(pc_count),
.mar_value(mar_value),
.state(state),
.address_bus(address_mux_out));

memio mem(.read_memory(mem_read),
.write_memory(mem_write),
.internal_data_path(data_bus),
.external_data_path(external_data_bus),
.address_in(address_mux_out),
.address_out(address_bus),
.ram_enable(ram_enable),
.rom_enable(rom_enable),
.write(write),
.write_bar(write_bar));

endmodule