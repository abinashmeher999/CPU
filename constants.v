/* constants.vh Definition file for chip-wide opcodes and other parameters
* Author: Yash Shrivastava <yash.shrivastava@iitkgp.ac.in>
* Author: Abinash Meher <abinashmeher999@gmail.com>
* Date: 4 November 2015
*/
`ifndef _CONSTANTS_V_
`define _CONSTANTS_V_

`define OVERFLOWFLAG 3
`define ZEROFLAG 2
`define CARRYFLAG 1
`define NEGFLAG 0

// ALU Opcodes
// These are the four lower bits from the opcode (instruction bits 14-11)
`define ALU_ADD 4'b0001
`define ALU_SUBTRACT 4'b0010
`define ALU_AND 4'b0100
`define ALU_OR 4'b0101
`define ALU_COMPLEMENT 4'b1000
// Room for 2 more, 4'b1101 and 4'b1110
// 4'b0000 is taken for NOP 4'b1111 for JUMP - these will give a 0 result

// Control module opcodes
// These are the complete 5-bit opcodes used in the control module
`define NOP 5'b00000
`define ADD 5'b00001
`define SUBTRACT 5'b00010
`define MULTIPLY 5'b00011
`define AND 5'b00100
`define OR 5'b00101
`define LOGICAL_SHIFT_RIGHT 5'b00110
`define LOGICAL_SHIFT_LEFT 5'b00111
`define COMPLEMENT 5'b01000
`define ARITH_SHIFT_RIGHT 5'b01001
`define ARITH_SHIFT_LEFT 5'b01010
`define TWOS_COMPLEMENT 5'b01011
`define PASSTHROUGH 5'b01100
`define LOAD 5'b10000
`define STORE 5'b10001
`define MOVE 5'b10010
`define JUMP 5'b01111
`define HALT 5'b11111

`define SOURCE_REGISTER 2'b00
`define SOURCE_IMMEDIATE 2'b10
`define SOURCE_MEMORY 2'b01

// Control module states
// Used in the control module and the control_signals module
`define S_RESET 5'd0
`define S_FETCH_1 5'd1
`define S_FETCH_2 5'd2
`define S_ALU_OPERATION 5'd3
`define S_STORE_RESULT_1 5'd4
`define S_STORE_RESULT_2 5'd5
`define S_FETCH_IMMEDIATE 5'd6
`define S_COPY_REGISTER 5'd7
`define S_FETCH_ADDRESS_1 5'd8
`define S_FETCH_ADDRESS_2 5'd9
`define S_FETCH_MEMORY 5'd10
`define S_STORE_MEMORY 5'd11
`define S_TEMP_FETCH 5'd12
`define S_FETCH_ADDRESS_3 5'd13
`define S_FETCH_ADDRESS_4 5'd14
`define S_TEMP_STORE 5'd15
`define S_LOAD_JUMP_1 5'd16
`define S_LOAD_JUMP_2 5'd17
`define S_EXECUTE_JUMP 5'd18
`define S_HALT 5'd19
`define S_ALU_IMMEDIATE 5'd20

`endif