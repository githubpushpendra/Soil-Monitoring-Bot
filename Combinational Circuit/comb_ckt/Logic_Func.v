// SM : Task 1 A : Combinational Circuit
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design 4 input logic function.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			Do not make any changes to Test_Bench_Vector.txt file. Violating will result into Disqualification.
-------------------
*/

//4 input logic function design
//Inputs  : C, D, E, F
//Output  : Y

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module Logic_Func(
	input		C,       //INPUT C
	input		D,			//INPUT D
	input		E,       //INPUT E
	input		F,			//INPUT F
	output	Y			//OUTPUT Y
);

////////////////////////WRITE YOUR CODE FROM HERE//////////////////// 
	
assign Y = (~C&~D&~E) | (~C&D&E) | (C&~E&~F) | (C&E&F);

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////