module BLF(input clk_50,
           input [11:0]ch5,
           input [11:0]ch6,
           input [11:0]ch7,
           input adc_clk,node_r,
           input [1:0]data_frame,
           output node,
           output [7:0]lm,rm
    );

integer counter = 0;
reg [7:0]lmr = 0;
reg [7:0]rmr = 0;
reg noder = 0;
reg [4:0]position = 0;
reg [7:0]change = 0;
reg [11:0]w = 768; // 300h
reg [11:0]b = 1280; // 500h
assign lm = lmr;
assign rm = rmr;
assign node = noder;
	 
always@( negedge adc_clk)begin
if(counter == 16)
counter = 0 ;
counter = counter + 1;
end

always @(posedge clk_50) begin

   if(data_frame == 1 && counter == 1) begin
	
	   if(ch5 < w && ch6 > b && ch7 < w) begin // center
		   position = 0;
			position[2] = 1;
			change = 0;
		end
		
	   if(ch5 > b && ch6 < w && ch7 < w) begin // left
		   position = 0;
			position[4] = 1;
			change = 27;
		end
		
		if(ch5 < b && ch5 > w && ch7 < w) begin // between left and center
		   position = 0;
			position[3] = 1;
			change = 5;
		end
		
		if(ch5 < w && ch6 < w && ch7 > b) begin // right
		   position = 0;
			position[0] = 1;
			change = 27;
		end
		
		if(ch5 < w && ch7 > w && ch7 < b) begin // between right and center
		   position = 0;
			position[1] = 1;
			change = 5;
		end
		
		if(ch5 > b && ch6 > b && ch7 > b) begin // node
		   position = 0;
			position[2] = 1;
			lmr = 1;
			rmr = 1;
			noder = 1;
			change = 0;
		end
		
		// assigning speed to the motors
	  if(position < 4) begin
		   lmr = 70 + change;
			rmr = 73 - change;
		end
		else if(position > 4) begin
		   lmr = 70 - change;
			rmr = 73 + change;
		end
		
	end
	
	if(node_r == 1)
	   noder = 0;

end	 
	 
endmodule