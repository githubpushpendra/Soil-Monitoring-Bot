// SM : Task 1 C : Finite State Machine
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a Finite State Machine.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			Do not make any changes to Test_Bench_Vector.txt file. Violating will result into Disqualification.
-------------------
*/

//Finite State Machine design
//Inputs  : I (4 bit) and CLK (clock)
//Output  : Y (Y = 1 when 1094 sequence(decimal number sequence) is detected)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module fsm(
	input CLK,			  //Clock
	input [3:0]I,       //INPUT I
	output	  Y		  //OUTPUT Y
);

////////////////////////WRITE YOUR CODE FROM HERE//////////////////// 


// Tip : Write your code such that Quartus Generates a State Machine 
//			(Tools > Netlist Viewers > State Machine Viewer).
// 		For doing so, you will have to properly declare State Variables of the
//       State Machine and also perform State Assignments correctly.
//			Use Verilog case statement to design.
	reg Y1=0;
	assign Y=Y1;
	parameter 
	s0=3'b000,
	s1=3'b001,
	s2=3'b010,
	s3=3'b011,
	s4=3'b100;
	
	reg [2:0] current_state=s0;
	reg n1=4'b0001;
	reg n0=4'b0000;
	reg n9=4'b1001;
	reg n4=4'b0100;
 
	always @(posedge CLK) begin
	
	case(current_state)
	s0 : begin
	if(I==4'b0001)begin
	current_state=s1;
	end
	else begin current_state=s0;
	end
	end
	s1 : begin
	if(I==4'b0000) begin
	current_state=s2;
	Y1=0;
	end
	else 
	begin
	current_state=s0;
	Y1=0;
	end
	end
	s2 : begin
	if(I==4'b1001) begin
	current_state=s3;
	Y1=0;
	end
	else 
	begin
	current_state=s0;
	Y1=0;
	end
	end
	s3 : begin
	if(I==4'b0100) begin
	current_state=s4;
	Y1=1;
	end
	else 
	begin
	current_state=s0;
	Y1=0;
	end
	end
	s4 : begin
	if(I==4'b0001)begin
	current_state=s1;
	Y1=0;
	end
	else begin
	current_state=s0;
	Y1=0;
	end
	end
	default : begin
	current_state=s0;
	Y1=0;
	end
	endcase
	end
	 assign Y=Y1;	
   

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////