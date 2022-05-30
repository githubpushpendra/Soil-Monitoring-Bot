// SM : Task 1 A : Combinational Circuit
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design 4 bit comparator.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			Do not make any changes to Test_Bench_Vector.txt file. Violating will result into Disqualification.
-------------------
*/

//4 bit comparator design
//Inputs  : A and B (4 bit)
//Outputs : A_Greater (A>B), Equal (A=B), B_Greater (A<B)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module Four_Bit_Comparator(
	input		[3:0]A,           //4-bit INPUT A
	input		[3:0]B,				//4-bit INPUT B				
	output	A_Greater,			//OUTPUT BIT A>B
	output	Equal,				//OUTPUT BIT A=B
	output	B_Greater			//OUTPUT BIT A<B
);

/*Hints
	1. Define wires.
	2. Instantiate Two_Bit_Comparator.v module and pass necessary signals.
		This needs to be done twice, first for lower two bits 
		and next for upper two bits.
	3. Output "Equal" of 4-bit comparator will be high if and only if:
		(Upper two bits of A = Upper two bits of B) AND (Lower two bits of A = Lower two bits of B). 
*/

////////////////////////WRITE YOUR CODE FROM HERE//////////////////// 

wire [2:0] X;
wire [2:0] Y;

Two_Bit_Comparator C1( .A (A[3:2]),
                    .B (B[3:2]),
						  .A_Greater (X[2]),
						  .Equal (X[1]),
						  .B_Greater (X[0])
						  );
Two_Bit_Comparator C2( .A (A[1:0]),
                    .B (B[1:0]),
						  .A_Greater (Y[2]),
						  .Equal (Y[1]),
						  .B_Greater (Y[0])
						  );
assign A_Greater = X[2] | (X[1]&Y[2]);
assign Equal = X[1] & Y[1];
assign B_Greater = X[0] | (X[1]&Y[0]);
						  
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////