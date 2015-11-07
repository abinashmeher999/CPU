/* program_counter.v
* Implements the 16-bit loadable program counter.
* Author: Steven Bell <steven.bell@student.oc.edu>
* Date: 11 September 2010
* $LastChangedDate: 2010-11-23 09:34:58 -0600 (Tue, 23 Nov 2010) $
*/

/* Program counter which is used to index memory to load instructions.
* It can be set to new values to implement a jump. We have to do the set
* in one shot, because otherwise we jump partway and can’t get the next byte.
*/
module program_counter(clock, reset, increment, set, new_count, count);
    input clock;
    input reset; // Synchronous reset; active low
    input increment; // Only increment the counter when this signal is high
    input set; // When this signal is high, the counter loads new_count into the
    counter
    input [15:0] new_count; // New value to set the counter to
    output reg [15:0] count; // Output address of the program counter

    // Clocked operation
    always @(posedge clock) begin
        if(~reset) begin // If the reset line is low, then zero the counter
            count <= 0;
        end else if(set) begin // If set is high, then load a new value into the
            counter
            count <= new_count;
        end else if(increment) begin // Otherwise, if increment is high, add one to
            the counter
            count <= count + 1;
        end
    end // END always
endmodule