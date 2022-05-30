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
// CREATED		"Sun Oct 31 16:23:49 2021"

module comb_ckt_verilog(
	C,
	D,
	E,
	F,
	S1,
	S0,
	A,
	B,
	Y
);


input wire	C;
input wire	D;
input wire	E;
input wire	F;
input wire	S1;
input wire	S0;
input wire	[3:0] A;
input wire	[3:0] B;
output wire	Y;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;





Four_Bit_Comparator	b2v_inst(
	.A(A),
	.B(B),
	.A_Greater(SYNTHESIZED_WIRE_0),
	.Equal(SYNTHESIZED_WIRE_1),
	.B_Greater(SYNTHESIZED_WIRE_2));


Logic_Func	b2v_inst1(
	.C(C),
	.D(D),
	.E(E),
	.F(F),
	.Y(SYNTHESIZED_WIRE_3));


Mux_4_to_1	b2v_inst2(
	.I3(SYNTHESIZED_WIRE_0),
	.I2(SYNTHESIZED_WIRE_1),
	.I1(SYNTHESIZED_WIRE_2),
	.I0(SYNTHESIZED_WIRE_3),
	.S1(S1),
	.S0(S0),
	.Y(Y));


endmodule
