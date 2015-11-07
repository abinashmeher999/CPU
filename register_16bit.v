/* register_16bit.v
* Implements a generic 16-bit register which is loaded in two
* sequential 8-byte actions.
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

module register_16bit(clock, reset, setHigh, setLow, halfValueIn, valueOut);
    input clock;
    input reset; // Synchronous reset; active low
    input setHigh; // When this signal is high, the top half of the value is
    loaded from the input line (data bus)
    input setLow;
    input [7:0] halfValueIn;
    output reg [15:0] valueOut; // Output value containing both bytes
    
    always @(posedge clock) begin
        if(~reset) begin // If the reset line is low, then zero the register
        valueOut = 0;
        end else if(setHigh) begin
            valueOut[15:8] = halfValueIn; // Load the top half
            // Leave the bottom half the same
        end else if(setLow) begin
            // Leave the top half the same
            valueOut[7:0] = halfValueIn; // Load the bottom half
        end
    end // END always

endmodule