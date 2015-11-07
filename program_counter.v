/* program_counter.v
* Implements the 16-bit loadable program counter.
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

/* Program counter which is used to index memory to load instructions.
* It can be set to new values to implement a jump. We have to do the set
* in one shot, because otherwise we jump partway and can’t get the next byte.
*/
module program_counter(
clock, 
reset, 
PC_in,
PC_out,
data_bus
);
    input clock;
    input reset; // Synchronous reset; active high
    input PC_in; // When this signal is high, the counter loads new_count into the  counter
    inout[15:0] data_bus; // New value to set the counter to
    input PC_out;
    
    reg[15:0] output_value;
    reg [15:0] count; // Output address of the program counter

    // Clocked operation
    always @(posedge clock) begin
        if(reset) begin // If the reset line is high, then zero the counter
            count <= 0;
        end else if(PC_in) begin // If PC_in is high, then load a new value into the counter
            count <= data_bus;
        end 
        // else if(increment) begin // Otherwise, if increment is high, add one to the counter
        //     count <= count + 1;
        // end
    end // END always

    assign output_value = count;
    assign data_bus = PC_out ? output_value : 16'hzz;

endmodule