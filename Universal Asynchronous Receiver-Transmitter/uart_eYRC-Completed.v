
//////// there are two messages to send one is msgp ( message pick ) and other msgd ( message diposite )
//////// one trigger is set to trigger this module
//////// when module is trigger ( many times , possibly zero ) all variables and states are reset to their initial 
//////// there is a pin named "p" to tell which message of the two is to be sent4
//////// there is a state named "clean", in this state module is inactive , will sending no bit to be recieved and showed on Hterm

module message_DP_PP ( input clk_50,
                       output tx
					      );
					
				
  parameter size = 14, //// size of message
            idle = 4'b0000,        // message transfer will start from idle state
            start_bit = 4'b0001,   /// start bit make sure that reciever will start recieving data just after ended this state
            data_bit = 4'b0010,    //////// this state will tranfer data bits 
            stop_bit = 4'b0011,    // after data transfered stop bit will start to make sure that reciever will not recieve message from now
            clean=4'b0111;         // now this while "message" module is inactive till current state goes to idle state

  reg [size*8:1] msgp = "eYRC-Completed";   
  reg       tx_dv =1'b1;
  reg [3:0] bit_index = 0;  
  reg [7:0] current_bit ;
  reg [9:0] clock_count = 0;
  reg [3:0] current_state=idle;// current state for 2nd state machine
  time t = 0;
  integer len = 14; /// length of message  

  always @(posedge clk_50) begin
  
    if( t == 50000000 && current_state == clean) begin
	 
	   current_state = idle;
		bit_index = 0;
		len = 14;
		clock_count = 0;
		t = 0;
	 
	 end
    
    t = t + 1;
    if(t > 50000000) t = 50000000;	 

    if(clock_count < 434) begin   ///// one data bit will be 434 clk cycles long
		 
	   clock_count = clock_count + 1;
		 
	 end
	 
	 else begin
	 
	   bit_index = (bit_index < 11) ? bit_index + 1 : 1;
		clock_count = 1;
		
	 end
	 
	 ////// states - of - start bit, data bit and end bit
	 
	 case(current_state) // 1st finite state machine

      idle: begin // message transfer will start from idle state

	     tx_dv=1'b1;
	  
	     if(clock_count == 434) begin
		  
	       current_state = start_bit;
			 
			 if( len == 14 ) current_bit = msgp[14*8:(14-1)*8+1];
			 if( len == 13 ) current_bit = msgp[13*8:(13-1)*8+1];	// S		 
			 if( len == 12 ) current_bit = msgp[12*8:(12-1)*8+1]; // _
			 if( len == 11 ) current_bit = msgp[11*8:(11-1)*8+1];
			 if( len == 10 ) current_bit = msgp[10*8:(10-1)*8+1]; // _
			 if( len == 9 ) current_bit = msgp[9*8:(9-1)*8+1];    // D
			 if( len == 8 ) current_bit = msgp[8*8:(8-1)*8+1];    // Z
			 if( len == 7 ) current_bit = msgp[7*8:(7-1)*8+1];    // N
			 if( len == 6 ) current_bit = msgp[6*8:(6-1)*8+1];    // 1
			 if( len == 5 ) current_bit = msgp[5*8:(5-1)*8+1];    // _
			 if( len == 4 ) current_bit = msgp[4*8:(4-1)*8+1];    // N
			 if( len == 3 ) current_bit = msgp[3*8:(3-1)*8+1];    // _
			 if( len == 2 ) current_bit = msgp[2*8:(2-1)*8+1];    // #
			 if( len == 1 ) current_bit = msgp[1*8:(1-1)*8+1];    // \n
			 
		  end
	  
      end
 
      start_bit: begin /// start bit make sure that reciever will start recieving data just after ended this state

	     tx_dv=1'b0;
	 
	     if(clock_count == 434)
	       current_state = data_bit;
	
      end
  
      data_bit: begin //////// this state will tranfer data bits 

	     tx_dv = current_bit[bit_index-2];
	  
	      if(bit_index == 9 && clock_count == 434	)
	        current_state = stop_bit;
			  
      end
 
      stop_bit: begin // after data transfered stop bit will start to make sure that reciever will not recieve message from now

	     tx_dv=1'b1;
		
		  if(clock_count == 434) begin
		  
		    current_state = idle;
		    len = len - 1;
			 
		  end
			 
			 if(len == 0) current_state = clean;
		
      end
	 
    endcase	
	 
  end // always block ends here 
  
assign tx = (current_state != clean) ? tx_dv : 1; // if current state is clean then tx will be high so no data will be recieved
					
					
					
endmodule