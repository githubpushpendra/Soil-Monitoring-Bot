// Copyright (C) 2019  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition"
// CREATED		"Tue Nov 02 13:55:43 2021"

module seq_block_verilog(
	CLK,
	Y
);


input wire	CLK;
output wire	[2:0] Y;

wire	[2:0] Y_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_11;





T_ff	b2v_inst(
	.T(SYNTHESIZED_WIRE_0),
	.CLK(CLK),
	.q(Y_ALTERA_SYNTHESIZED[2]),
	.q_bar(SYNTHESIZED_WIRE_14));


T_ff	b2v_inst1(
	.T(SYNTHESIZED_WIRE_1),
	.CLK(CLK),
	.q(Y_ALTERA_SYNTHESIZED[1]),
	.q_bar(SYNTHESIZED_WIRE_15));

assign	SYNTHESIZED_WIRE_6 = Y_ALTERA_SYNTHESIZED[1] & SYNTHESIZED_WIRE_2;

assign	SYNTHESIZED_WIRE_0 = SYNTHESIZED_WIRE_3 | SYNTHESIZED_WIRE_4 | SYNTHESIZED_WIRE_5;

assign	SYNTHESIZED_WIRE_11 = SYNTHESIZED_WIRE_6 | SYNTHESIZED_WIRE_7 | SYNTHESIZED_WIRE_8;

assign	SYNTHESIZED_WIRE_1 = ~(Y_ALTERA_SYNTHESIZED[1] & Y_ALTERA_SYNTHESIZED[2]);

assign	SYNTHESIZED_WIRE_8 = SYNTHESIZED_WIRE_14 & SYNTHESIZED_WIRE_15 & Y_ALTERA_SYNTHESIZED[0];


T_ff	b2v_inst2(
	.T(SYNTHESIZED_WIRE_11),
	.CLK(CLK),
	.q(Y_ALTERA_SYNTHESIZED[0]),
	.q_bar(SYNTHESIZED_WIRE_2));

assign	SYNTHESIZED_WIRE_5 = Y_ALTERA_SYNTHESIZED[2] & Y_ALTERA_SYNTHESIZED[1];

assign	SYNTHESIZED_WIRE_3 = Y_ALTERA_SYNTHESIZED[1] & Y_ALTERA_SYNTHESIZED[0];

assign	SYNTHESIZED_WIRE_4 = SYNTHESIZED_WIRE_14 & SYNTHESIZED_WIRE_15;

assign	SYNTHESIZED_WIRE_7 = Y_ALTERA_SYNTHESIZED[2] & Y_ALTERA_SYNTHESIZED[1];

assign	Y = Y_ALTERA_SYNTHESIZED;

endmodule
