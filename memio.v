/* memio.v Memory IO module which performs memory mapping and holds the
* digital IO banks.
*
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/

module memio(
	input read_memory,
	input write_memory,
	inout[7:0] internal_data_path,
	inout[7:0] external_data_path,

	input[15:0] address_in, // Full 16-bit address input
	output[15:0] address_out, // Output address; not all 16 bits may be used
	// TODO: digital inputs/outputs
	output ram_enable, // Active low signal which turns the RAM on
	//output rom_enable, // Active low signal which turns the ROM on
	output write, // Active high signal which tells the bidirectional buffers we're writing
	output write_bar // Opposite of write; active low signal which tells the RAM we're writing
);
// TODO: use this to make sure we don't crash and burn if both read and write are asserted
wire enabled;
assign enabled = read_memory ^ write_memory;

assign internal_data_path = read_memory ? external_data_path : 8'hzz;
assign external_data_path = write_memory ? internal_data_path : 8'hzz;

// Map the ROM to 0000 - 1FFF
// Output is active low
//assign rom_enable = !(address_in[15:13] === 3'b000);

// Map the RAM to 2000 - 3FFF
// Output is active low
assign ram_enable = !(address_in[15:13] === 3'b001);

assign address_out = address_in; // Passthrough for now
assign write = write_memory;
assign write_bar = !write_memory;

endmodule