module Turn( input clk_50,node,
             input [11:0]ch5,ch6,ch7,
				 input [1:0] direction,
				 output node_r,
				 output [7:0]lm,lmn,rm,rmn,
				 output [4:0]node_count_port
			  );
			  
reg [7:0]lmr = 0;
reg [7:0]rmr = 0;
reg [7:0]lmnr = 0;
reg [7:0]rmnr = 0;
reg node_rr = 0; // rr = return reg
reg turn_s = 0; // s = started
reg [11:0]w = 768; // 300h
reg [11:0]b = 1280; // 500h
reg [4:0]node_count = 0;
reg [2:1]lap = 1;
reg line = 0;
reg ncd = 0;
reg reverse = 0;

time t = 0;
time t2 = 0;

assign lm = lmr;
assign rm = rmr;
assign lmn = lmnr;
assign rmn = rmnr;
assign node_r = node_rr;
assign node_count_port = node_count;


always @(posedge clk_50) begin

   if(node == 1) begin
	
	   t = t + 1;
	   t2 = t2 + 1;	
			
		   if(ch5 > b || ch6 > b || ch7 > b) begin // detecting is there line to detect line after crossing node
		      line = 1;
		   end
		   else line = 0;
			
			if(t > 21000000) begin /// 21000000 clk cycle delay after detecting node
				
				
			   if(ncd == 0) begin /// ncd = node count done
				
				if(node_count == 8) begin
				   node_count = 0;
					lap = lap + 1;
				end
			   node_count = node_count + 1;
				ncd = 1;
				
			   lmr = 0;
				rmr = 0;
				
				end
				
				if(turn_s == 0) begin
				
				if(direction == 3) begin
			      
					node_rr = 1;
					
		      end	
				else if(direction == 2) begin
				
				   lmr = 77;
					rmnr = 80;
					t2 = 0;
				
				end
			   else if(direction == 1) begin
				
				   lmnr = 77;
					rmr = 80;
					t2 = 0;
				
				end
				else if(direction == 0) begin
				
				   lmnr = 77;
					rmr = 80;
					t2 = 0;
					reverse = 1;
				
				end
				
				turn_s = 1;
				
				end
		
            if(t2 > 25000000 && line == 1 && turn_s == 1) begin
		     
			      if(reverse == 1 && t2 > 50000000) begin
					
					   lmr = 0;
					   rmnr = 0;
					   node_rr = 1;
					
					end
			  
            end		
			
			end
			
		
		   
		if(t > 100000000) t = 100000000;
		if(t2 > 50000009) t2 = 50000009;
		
	end
	
	////////////// reseting all variables after node goes to low
	
	else if(node == 0) begin
	   node_rr = 0;
		turn_s = 0;
		ncd = 0;
		reverse = 0;
		
		t = 0;
		t2 = 0;
		
		lmr = 77;
		lmnr = 0; 
		rmr = 80;
		rmnr = 0;
	end

end

			  
endmodule 