// module takes 8 bit duty cycle "in" as an input and apply it on signal to give output "ou"

module PWM( input clk_50,
            input [7:0]in,
            output ou
			 );

// declarting regs
			 
//reg st = 0; // "st" stands for status of input signal -- 1 or 0
reg our = 0; // r = reg
reg [7:0]inr; // r = reg
reg [7:0]inl = 0;
reg [10:0]clkc = 0; // clk = clock count
reg [7:0]countc = 0;

// assigning

assign ou = (inr == 100) ? 1 : our;


always @(in) begin  // detecting change in duty cycle

   inr = in;
	inl = 8'd100 - inr;
	
end


always @(posedge clk_50) begin  // counting clock cycles
   if(clkc > 1001)
	   clkc = 0;
   clkc = clkc+ 1;
end

////////////// generating output signal according to the duty cycle

always @(posedge clk_50) begin

   if(inr == 0) our = 0;
	else if(inr == 100) our = 1;
	else begin
	
	if(clkc > 999)
      countc = countc + 1;
	if(our == 1 && countc == inr) begin
	   our = ~our;
		countc = 0;
	end
	else if(our == 0 && countc == inl) begin
	   our = ~our;
		countc = 0;
	end
	if(countc > 99) countc = 0;
	
	end
	
end
			 
endmodule 