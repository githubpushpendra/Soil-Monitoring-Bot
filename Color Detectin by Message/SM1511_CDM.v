module SM1511_CDM(
	input clk_50,	//50 MHz clock
	input tcs_clk,
	input [2:0]led,
   output tx		//UART transmit output
);

 
 parameter
  idle = 4'b0000,
  start_bit = 4'b0001,
  data_bit = 4'b0010,
  stop_bit = 4'b0011,
  clean=4'b0111,
  s0 = 4'b0000,
  s1 = 4'b0100,
  s2 = 4'b0101,
  s3 = 4'b0110,
  s4 = 4'b1000,
  s5 = 4'b1001,
  s6 = 4'b1010,
  s7 = 4'b1011,
  s8 = 4'b1100,
  s9 = 4'b1101,
  s10 = 4'b1110,
  s11 = 4'b1111;
  
  
  reg       tx_dv =1'b1;
  reg [3:0] bit_index = 0;  
  reg [3:0] next_bit_state ;
  reg [7:0] current_bit ;
  reg [9:0] clock_count = 0;
  reg [3:0] current_bit_state = clean;// current state for 1st state machine
  reg [3:0] current_state=idle;// current state for 2nd state machine
  reg [7:0] req_data[11:0];// initialising data which need to be transfer in a array
  reg led_red =0 ;
  reg led_blue =0;
  reg led_green =0;
  reg send = 0;
  reg [2:0] pre_led = 0;
  integer tcs_count = 1;
  
  initial 
  begin
  req_data[0] = 8'b01010011;//binary of S
  req_data[1] = 8'b01001101;// binary of M
  req_data[2] = 8'b01001001;//binary of I
  req_data[3] = 8'b01010000;//binary of P
  req_data[4] = 8'b01001110;//binary of N
  req_data[5] = 8'b01010111;// binary of W
  req_data[6] = 8'b00110001;// 1
  req_data[7] = 8'b00110010;// 2
  req_data[8] = 8'b00110011;// 3
  req_data[9] = 8'b00101101;// -
  req_data[10] = 8'b00100011;// #
  req_data[11] = 8'b00001010;// new line character
  end
  
always @(posedge tcs_clk) begin

   if(tcs_count == 50000)
      tcs_count = 0;
	tcs_count = tcs_count + 1;

end	
  
always@(posedge clk_50)
begin
   if(tcs_count == 1 && pre_led != led) begin
	   led_red=led[2];
      led_blue=led[0];
      led_green=led[1];
      send = 1;
		pre_led = led;
	end
   
	if(tcs_count == 2) begin
	   send = 0;
	end
 
   if(send == 1 && current_bit_state == clean) begin
	   current_state = idle;
		current_bit_state = s0;
		clock_count = 0;
		bit_index = 0;
	end
 
 if(clock_count < 434)
		 begin
		 clock_count=clock_count+1;
		 end
	 else
	 begin
	 bit_index=(bit_index<11)?bit_index+1:1;
			 clock_count=1;
	 end

if(led > 0) begin
	 
 case(current_state) // 1st finite state machine

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

end

 //for changing the data bit state
 
if(current_bit_state==s0)
begin
			current_bit = req_data[0];
			if(bit_index==10)
				next_bit_state= s1 ;  
			
end
    		
else if(current_bit_state == s1) 
begin
			current_bit = req_data[2];
			if(bit_index==10)
				next_bit_state = s2;
			
end
		
else if(current_bit_state == s2)
begin
			 current_bit = req_data[9];
			 if(bit_index==10)
				next_bit_state = s3;
			
end
else if(current_bit_state == s3) 
begin
			current_bit = req_data[0];
			if(bit_index==10)
				next_bit_state = s4;
			
end
		
else if(current_bit_state == s4)
begin
			 current_bit = req_data[2];
			 if(bit_index==10)
				next_bit_state = s5;
			
end
else if(current_bit_state == s5) 
begin
			current_bit = req_data[1];
			if(bit_index==10)
				next_bit_state = s6;
			
end
		
else if(current_bit_state == s6)
begin

   if(led_red==1)
      current_bit = req_data[6];
   if(led_blue==1)
      current_bit = req_data[8];
   if(led_green==1)
      current_bit = req_data[7];
   if(bit_index==10)
      next_bit_state = s7;
			
end
else if(current_bit_state == s7) 
begin
			current_bit = req_data[9];
			if(bit_index==10)
				next_bit_state = s8;
			
end
		
else if(current_bit_state == s8)
begin
 
   if(led_red==1)
      current_bit = req_data[3];
   if(led_blue==1)
      current_bit = req_data[5];
   if(led_green == 1)
      current_bit = req_data[4];
	if(bit_index==10)
		next_bit_state = s9;
			
end
else if(current_bit_state == s9) 
begin
			current_bit = req_data[9];
			if(bit_index==10)
				next_bit_state = s10;
			
end
else if(current_bit_state == s10) 
begin
			current_bit = req_data[10];
			if(bit_index==10)
				next_bit_state = s11;
			
end
else if(current_bit_state == s11)
begin
		   current_bit= req_data[11];
			if(bit_index==10)
		    next_bit_state = clean;
			 
end
	
if(bit_index== 11)
	 current_bit_state = next_bit_state; 
 
end      
assign tx = (current_bit_state != clean) ? tx_dv : 1; 
endmodule
