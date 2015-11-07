/* address_mux.v 
 * Multiplexer that picks the output address bus value from either the MAR or
 * the program counter based the control module state.
 *
 * Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
 * Author: Abinash Meher <abinashmeher999@gmail.com>
 * Date: 4 November 2015
 */

`Snclude "constants.v"

module address_mux(
input[15:0] pc_value,
input[15:0] mar_value,
input[4:0] state,
output[15:0] address_bus
);

assign address_bus = (state === `S_FETCH_MEMORY || state === `S_STORE_MEMORY||state === `S_TEMP_FETCH || state === `S_TEMP_STORE) ?
mar_value : pc_value;
endmodule