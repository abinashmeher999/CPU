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

// ALU Opcodes  for control signal
`define ALU_ADD 3'd0
`define ALU_SUBTRACT 3'd1
`define ALU_AND 3'd2
`define ALU_OR 3'd3
`define ALU_COMPLEMENT 3'd4
// Room for 2 more, 4'b1101 and 4'b1110
// 4'b0000 is taken for NOP 4'b1111 for JUMP - these will give a 0 result

// Control module opcodes
// These are the complete 4-bit opcodes used in the control module
`define ADD 4'b0100
`define SUBTRACT 4'b0101
`define AND 4'b0110
`define OR 4'b0111
`define COMPLEMENT 4'b0010
`define LOAD 4'b0000
`define STORE 4'b0001
`define UNCOND_JUMP 4'b1000
`define COND_JUMP 4'b1001
`define JAL 4'b1100
`define JR 4'b1101

//Addressing mode
`define IMMEDIATE 3'b00
`define REGISTER 3'b001
`define BASE_INDEXED 3'b010
`define BASE 3'b011
`define MEM_INDIRECT 3'b100
`define PC_RELATIVE 3'b101

// Conditional Jump types
`define JZ 3'b000
`define JNZ 3'b100
`define JV 3'b001
`define JNV 3'b101
`define JC 3'b011
`define JNC 3'b111
`define JM 3'b010
`define JNM 3'b110

// Control module states
// Used in the control module and the control_signals module
`define S_RESET 6'd0

`define S_INS_FETCH_PC_INC_1 6'd1
`define S_INS_FETCH_PC_INC_2 6'd2
`define S_INS_FETCH_PC_INC_3 6'd3

`define S_STORE_PROLOGUE_1 6'd4
`define S_STORE_PROLOGUE_2 6'd5
`define S_STORE_PROLOGUE_3 6'd6
`define S_STORE_PROLOGUE_4 6'd7

`define S_STORE_BASE_IND_1 6'd8
`define S_STORE_BASE_IND_2 6'd9
`define S_STORE_BASE_IND_3 6'd10

`define S_STORE_BASE 6'd11

`define S_STORE_MEM_INDIRECT_1 6'd12
`define S_STORE_MEM_INDIRECT_2 6'd13
`define S_STORE_MEM_INDIRECT_3 6'd14
`define S_STORE_MEM_INDIRECT_4 6'd15

`define S_STORE_EPILOGUE_1 6'd16
`define S_STORE_EPILOGUE_2 6'd17

`define S_JUMP_1 6'd18
`define S_JUMP_2 6'd19
`define S_JUMP_3 6'd20
`define S_JUMP_4 6'd21

`define S_JUMP_AND_LINK_1 6'd22
`define S_JUMP_AND_LINK_2 6'd23
`define S_JUMP_AND_LINK_3 6'd24
`define S_JUMP_AND_LINK_4 6'd25

`define S_JUMP_RETURN 6'd26

`define S_IMMEDIATE_ADDR_1 6'd27
`define S_IMMEDIATE_ADDR_2 6'd28
`define S_IMMEDIATE_ADDR_3 6'd29

`define S_REGISTER_ADDR_1 6'd30

`define S_BASE_INDEXED_ADDR_1 6'd31
`define S_BASE_INDEXED_ADDR_2 6'd32
`define S_BASE_INDEXED_ADDR_3 6'd33
`define S_BASE_INDEXED_ADDR_4 6'd34
`define S_BASE_INDEXED_ADDR_5 6'd35
`define S_BASE_INDEXED_ADDR_6 6'd36
`define S_BASE_INDEXED_ADDR_7 6'd37
`define S_BASE_INDEXED_ADDR_8 6'd38

`define S_BASE_ADDR_1 6'd39
`define S_BASE_ADDR_2 6'd40
`define S_BASE_ADDR_3 6'd41
`define S_BASE_ADDR_4 6'd42
`define S_BASE_ADDR_5 6'd43
`define S_BASE_ADDR_6 6'd44

`define S_MEM_INDIRECT_ADDR_1 6'd45
`define S_MEM_INDIRECT_ADDR_2 6'd46
`define S_MEM_INDIRECT_ADDR_3 6'd47
`define S_MEM_INDIRECT_ADDR_4 6'd48
`define S_MEM_INDIRECT_ADDR_5 6'd49
`define S_MEM_INDIRECT_ADDR_6 6'd50
`define S_MEM_INDIRECT_ADDR_7 6'd51
`define S_MEM_INDIRECT_ADDR_8 6'd52
`define S_MEM_INDIRECT_ADDR_9 6'd53

`define S_PC_RELATIVE_1 6'd54
`define S_PC_RELATIVE_2 6'd55
`define S_PC_RELATIVE_3 6'd56
`define S_PC_RELATIVE_4 6'd57
`define S_PC_RELATIVE_5 6'd58

`define S_ALU_POST_ADDR 6'd59
`define S_LOAD_POST_ADDR 6'd60
//`define S_ALU_OPERATION 5'd3
//`define S_STORE_RESULT_1 5'd4
//`define S_STORE_RESULT_2 5'd5
//`define S_FETCH_IMMEDIATE 5'd6
//`define S_COPY_REGISTER 5'd7
//`define S_FETCH_ADDRESS_1 5'd8
//`define S_FETCH_ADDRESS_2 5'd9
//`define S_FETCH_MEMORY 5'd10
//`define S_STORE_MEMORY 5'd11
//`define S_TEMP_FETCH 5'd12
//`define S_FETCH_ADDRESS_3 5'd13
//`define S_FETCH_ADDRESS_4 5'd14
//`define S_TEMP_STORE 5'd15
//`define S_LOAD_JUMP_1 5'd16
//`define S_LOAD_JUMP_2 5'd17
//`define S_EXECUTE_JUMP 5'd18
`define S_HALT 6'd61
//`define S_ALU_IMMEDIATE 5'd20

`endif