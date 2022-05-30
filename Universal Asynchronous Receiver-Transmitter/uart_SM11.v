
// SM : Task 2 B : UART
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design UART Transmitter.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//UART Transmitter design
//Input   : clk_50M : 50 MHz clock
//Output  : tx : UART transmit output

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module uart(
	input clk_50M,	//50 MHz clock
	output tx		//UART transmit output
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

 
 parameter
  idle = 4'b0000,
  start_bit = 4'b0001,
  data_bit = 4'b0010,
  stop_bit = 4'b0011,
  clean=4'b111,
  s0 = 4'b0100,
  s1 = 4'b0101,
  s2 = 4'b0110,
  s3 = 4'b1000;
  
  reg       tx_dv =1'b1;
  reg [3:0] bit_index   = 0;  
  reg [3:0] next_bit_state ;
  reg [7:0] current_bit ;
  reg [9:0] clock_count = 0;
  reg [3:0] current_bit_state = s0;
  reg [3:0]current_state=idle;
     
  
  always@(posedge clk_50M)
  
 begin
	 if(clock_count < 434)
		 begin
		 clock_count=clock_count+1;
		 end
	 else
	 begin
	 bit_index=(bit_index<11)?bit_index+1:1;
			 clock_count=1;
	 end
	 
 case(current_state)
 
 idle:
 begin
	  tx_dv=1'b1;
	  
	  if(clock_count == 434)
	  current_state = start_bit;
	  
 end
 
 start_bit:
 begin
	 tx_dv=1'b0;
	 
	 if(clock_count == 434)
	 current_state = data_bit;
	
 end
  
 data_bit:
  begin
	  tx_dv=current_bit[bit_index-2];
	  if(bit_index==9 && clock_count==434	)
	  current_state = stop_bit;	  
 end
 
 stop_bit:
 begin
		tx_dv=1'b1;
		
		if(clock_count == 434)
		current_state = idle;
		
 end
 endcase	

 
 if(current_bit_state==s0)
begin
			current_bit = 8'b01010011;
			if(bit_index==10)
				next_bit_state= s1 ;  //changing state on end of data bit
			
end
    		
 else if(current_bit_state == s1) 
begin
			current_bit = 8'b01001101;
			if(bit_index==10)
				next_bit_state = s2;
			
end
		
 else if(current_bit_state == s2)
begin
			 current_bit = 8'b00110001;
			 if(bit_index==10)
				next_bit_state = s3;
			
end
		
 else if(current_bit_state == s3)
begin
		   current_bit=8'b00110001;
			if(bit_index==10)
		    next_bit_state = clean;
			 
end
	
if(bit_index== 11)
	 current_bit_state = next_bit_state; // changing state at the end of data frame(11 bit)
end  
      
  assign tx = (current_bit_state!=clean) ? tx_dv : 1; 	
  
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////