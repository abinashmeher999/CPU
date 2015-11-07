/* gp_registers.v
* 8x8 bit general purpose register set.
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

module gp_registers (
        input clock,
        input reset, // Active-high synchronous reset
        input reg_write, // Flag telling us whether or not to load a register value from the data bus (active high) 
        input reg_read, 
        // Flag telling us whether or not to write a register to the data bus (active high)
        // We’ll just leave the ALU output always enabled, since it can’t mess things up and we
        // don’t care about the slight increase in power consumption due to flipping unnecessary gates.
        
        input[2:0] input_select, // Register to put the input value into
        input[2:0] output_select, // Index of the register we want to put on the data bus output
        input[2:0] alu_output_select, // Index of the register we want to put on the  ALU output
        
        inout[15:0] data_bus, // Contains the input value to store, or the ouput we write
        output[15:0] alu_output_value // Output bus to the ALU
        );

    reg[15:0] register_data[7:0]; // Data array, 16bits x 8 registers
    wire[15:0] output_value; // Temporary latch, because the data_bus is a wire and not a reg

    integer i; // Used for iterating through the registers when resetting them

    always@(posedge clock) begin
        if(reset == 1'b1) begin
            // Remember that this code produces hardware, and all of the registers
            // will be reset simultaneously
            for(i = 0; i < 8; i = i+1) begin
                register_data[i] <= 16'd0;
            end
        end
            
        if(reg_write == 1'b1) begin
            register_data[input_select] <= data_bus;
        end
    end // always

    // Combinational logic to interface with the data bus
    
    assign output_value = register_data[output_select];
    assign data_bus = reg_read ? output_value : 16'hzz;
    assign alu_output_value = register_data[alu_output_select];

endmodule