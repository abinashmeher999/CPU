/* alu_latch.v
* Grabs the result from the ALU and puts it on the data bus
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

module alu_latch(
input clock,
input reset,
input[15:0] alu_result, // Result from the ALU
input[2:0] flags, // ALU flags which must also be latched
input grab, // Active-high signal telling us whether or not to latch the
value
input store_high, // Put the top 8 bytes on the data bus (only used for
multiply)
input store_low, // Put the low 8 bytes on the data bus
output reg[7:0] out,
output reg[2:0] flags_out
);

reg[15:0] value; // Stores the full-length output value

always @(posedge clock) begin
if(reset == 1'b0) begin
value <= 16'b0;
end
if(grab == 1'b1) begin // Latch the ALU value when the grab signal is high
value <= alu_result;
flags_out <= flags;
end
end // always

/* This part will synthesize into combinational logic which puts
* the appropriate set of signals onto the data bus. */
always @(*) begin
if(store_low == 1'b1) begin
out <= value[7:0];
end
else if(store_high == 1'b1) begin
out <= value[15:8];
end
else begin
out <= 8'hzz;
end

end
endmodule