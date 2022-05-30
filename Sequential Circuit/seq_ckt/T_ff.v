// SM : Task 1 B : Sequential Circuit

/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design T Flip Flop (Positive edge triggered).

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			
-------------------
*/

//T Flip Flop design
//Inputs  : T and CLK 
//Outputs : q and q_bar

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module T_ff (T, CLK, q, q_bar);

input T, CLK;					//INPUT T and CLK
output reg q = 0;				//OUTPUT q
output reg q_bar = 1;		//OUTPUT q_bar


always @(posedge CLK)
////////////////////////WRITE YOUR CODE FROM HERE//////////////////// 
begin
if (T) begin
 q=~q;           
 end else
 begin
 q=q;                        
 end
 begin
 q_bar=~q;
end 
 end

	
	

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////