// SM : Task 2 A : ADC
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design ADC Controller.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//ADC Controller design
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame	//To represent 16-cycle frame (optional)
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

// All Declarations are made here

integer count = -1;
integer counter = 0;
reg din_reg = 0;
reg adc_sck_reg = 0;
reg [11:0] d_out_chX;
reg [1:0] data_frame_reg = 1;
reg [11:0] d_out_ch5_reg = 12'b000000000000;
reg [11:0] d_out_ch6_reg = 12'b000000000000;
reg [11:0] d_out_ch7_reg = 12'b000000000000;

// All assignments to the ports are made here

assign adc_cs_n = 0;
assign din = din_reg;
assign adc_sck = adc_sck_reg;
assign data_frame = data_frame_reg;
assign d_out_ch5 = d_out_ch5_reg;
assign d_out_ch6 = d_out_ch6_reg;
assign d_out_ch7 = d_out_ch7_reg;


// Modulation of frequency from 50 MHz to 2.5 MHz

always @(negedge clk_50) begin

   count = count + 1;
	if(count == 10) begin
	   adc_sck_reg = ~adc_sck_reg;
		count = 0;
	end
	
end

// Code for data_frame port

always @(negedge adc_sck) begin

   if(counter == 16) begin
	   case (data_frame_reg)
		
	      2'b01 : data_frame_reg = 2'b10;
		   2'b10 : data_frame_reg = 2'b11;
		   2'b11 : data_frame_reg = 2'b01;

		endcase
	end
end

// Code for Din

always @(negedge adc_sck) begin

   if(counter == 2) din_reg = 1;
	if(counter == 3) begin
	   if(data_frame_reg == 1) din_reg = 0;
		else din_reg = 1;
	end
	if(counter == 4) begin
	   if(data_frame_reg == 2) din_reg = 0;
		else din_reg = 1;
	end
	if(counter == 5) din_reg = 0;
	
end

// Code to update channels with an counter at every positive edge of clock ( adc_sck )

always @(negedge adc_sck) begin

   if(counter == 16) begin
	   counter = 0;
		// update channel
		if(data_frame_reg == 1) d_out_ch6_reg = d_out_chX;
		if(data_frame_reg == 2) d_out_ch7_reg = d_out_chX;
		if(data_frame_reg == 3) d_out_ch5_reg = d_out_chX;
	end
   
	counter = counter + 1;
	
end

// Storing bits to compile it in single variable

always @(posedge adc_sck) begin

   if(counter >= 5) begin
	   d_out_chX[11-counter+5] = dout;
	end
	
end


////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////