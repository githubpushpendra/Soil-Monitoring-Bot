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
// CREATED		"Thu Feb 24 22:23:43 2022"

module BDv(
	clk_50,
	dout,
	OUT,
	adc_cs_n,
	din,
	adc_sck,
	node,
	tx,
	s2,
	s3,
	data_frame,
	led,
	lmotor,
	node_count_port,
	rmotor
);


input wire	clk_50;
input wire	dout;
input wire	OUT;
output wire	adc_cs_n;
output wire	din;
output wire	adc_sck;
output wire	node;
output wire	tx;
output wire	s2;
output wire	s3;
output wire	[1:0] data_frame;
output wire	[2:0] led;
output wire	[1:0] lmotor;
output wire	[4:0] node_count_port;
output wire	[1:0] rmotor;

wire	[1:0] lmotor_ALTERA_SYNTHESIZED;
wire	[1:0] rmotor_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[11:0] SYNTHESIZED_WIRE_22;
wire	[11:0] SYNTHESIZED_WIRE_23;
wire	[11:0] SYNTHESIZED_WIRE_24;
wire	[1:0] SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_25;
wire	[7:0] SYNTHESIZED_WIRE_7;
wire	[7:0] SYNTHESIZED_WIRE_8;
wire	[7:0] SYNTHESIZED_WIRE_10;
wire	[7:0] SYNTHESIZED_WIRE_11;
wire	[7:0] SYNTHESIZED_WIRE_12;
wire	[7:0] SYNTHESIZED_WIRE_13;
wire	[7:0] SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_19;
wire	[2:0] SYNTHESIZED_WIRE_20;
wire	[7:0] SYNTHESIZED_WIRE_21;

assign	adc_sck = SYNTHESIZED_WIRE_0;
assign	node = SYNTHESIZED_WIRE_25;
assign	led = SYNTHESIZED_WIRE_20;




adc_control	b2v_inst(
	.clk_50(clk_50),
	.dout(dout),
	.adc_cs_n(adc_cs_n),
	.din(din),
	.adc_sck(SYNTHESIZED_WIRE_0),
	.d_out_ch5(SYNTHESIZED_WIRE_22),
	.d_out_ch6(SYNTHESIZED_WIRE_23),
	.d_out_ch7(SYNTHESIZED_WIRE_24),
	.data_frame(SYNTHESIZED_WIRE_5));


BLF	b2v_inst1(
	.clk_50(clk_50),
	.adc_clk(SYNTHESIZED_WIRE_0),
	.node_r(SYNTHESIZED_WIRE_1),
	.ch5(SYNTHESIZED_WIRE_22),
	.ch6(SYNTHESIZED_WIRE_23),
	.ch7(SYNTHESIZED_WIRE_24),
	.data_frame(SYNTHESIZED_WIRE_5),
	.node(SYNTHESIZED_WIRE_25),
	.lm(SYNTHESIZED_WIRE_7),
	.rm(SYNTHESIZED_WIRE_10));


SM1511_FILTER	b2v_inst10(
	.clk_50(clk_50),
	.node(SYNTHESIZED_WIRE_25),
	.lfr(SYNTHESIZED_WIRE_7),
	.nd(SYNTHESIZED_WIRE_8),
	.speed(SYNTHESIZED_WIRE_12));


SM1511_FILTER	b2v_inst11(
	.clk_50(clk_50),
	.node(SYNTHESIZED_WIRE_25),
	.lfr(SYNTHESIZED_WIRE_10),
	.nd(SYNTHESIZED_WIRE_11),
	.speed(SYNTHESIZED_WIRE_21));


PWM	b2v_inst12(
	.clk_50(clk_50),
	.in(SYNTHESIZED_WIRE_12),
	.ou(lmotor_ALTERA_SYNTHESIZED[1]));


PWM	b2v_inst14(
	.clk_50(clk_50),
	.in(SYNTHESIZED_WIRE_13),
	.ou(lmotor_ALTERA_SYNTHESIZED[0]));


PWM	b2v_inst15(
	.clk_50(clk_50),
	.in(SYNTHESIZED_WIRE_14),
	.ou(rmotor_ALTERA_SYNTHESIZED[0]));


Turn	b2v_inst2(
	.clk_50(clk_50),
	.node(SYNTHESIZED_WIRE_25),
	.ch5(SYNTHESIZED_WIRE_22),
	.ch6(SYNTHESIZED_WIRE_23),
	.ch7(SYNTHESIZED_WIRE_24),
	.node_r(SYNTHESIZED_WIRE_1),
	.lm(SYNTHESIZED_WIRE_8),
	.lmn(SYNTHESIZED_WIRE_13),
	.node_count_port(node_count_port),
	.rm(SYNTHESIZED_WIRE_11),
	.rmn(SYNTHESIZED_WIRE_14));


SM1511_CD	b2v_inst3(
	.clk_50(clk_50),
	.OUT(OUT),
	.s2(s2),
	.s3(s3),
	.tcs_clk(SYNTHESIZED_WIRE_19),
	.data_frame(data_frame),
	.led(SYNTHESIZED_WIRE_20));


SM1511_CDM	b2v_inst4(
	.clk_50(clk_50),
	.tcs_clk(SYNTHESIZED_WIRE_19),
	.led(SYNTHESIZED_WIRE_20),
	.tx(tx));
	defparam	b2v_inst4.clean = 4'b0111;
	defparam	b2v_inst4.data_bit = 4'b0010;
	defparam	b2v_inst4.idle = 4'b0000;
	defparam	b2v_inst4.s0 = 4'b0000;
	defparam	b2v_inst4.s1 = 4'b0100;
	defparam	b2v_inst4.s10 = 4'b1110;
	defparam	b2v_inst4.s11 = 4'b1111;
	defparam	b2v_inst4.s2 = 4'b0101;
	defparam	b2v_inst4.s3 = 4'b0110;
	defparam	b2v_inst4.s4 = 4'b1000;
	defparam	b2v_inst4.s5 = 4'b1001;
	defparam	b2v_inst4.s6 = 4'b1010;
	defparam	b2v_inst4.s7 = 4'b1011;
	defparam	b2v_inst4.s8 = 4'b1100;
	defparam	b2v_inst4.s9 = 4'b1101;
	defparam	b2v_inst4.start_bit = 4'b0001;
	defparam	b2v_inst4.stop_bit = 4'b0011;


PWM	b2v_inst9(
	.clk_50(clk_50),
	.in(SYNTHESIZED_WIRE_21),
	.ou(rmotor_ALTERA_SYNTHESIZED[1]));

assign	lmotor = lmotor_ALTERA_SYNTHESIZED;
assign	rmotor = rmotor_ALTERA_SYNTHESIZED;

endmodule
