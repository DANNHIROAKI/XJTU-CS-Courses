//从译码到执行


//再存译码后得到的操作数/地址字段，然后将其传递到执行阶段
`timescale 1ns/1ns
`include "defines.v"
module ID_EX(CLK, 
             A_0, B_0, 
			 Out31_26_0, Out25_21_0, Out20_16_0, Out15_11_0, Out10_6_0, Out5_0_0, 
			 A_1, B_1, 
			 Out31_26_1, Out25_21_1, Out20_16_1, Out15_11_1, Out10_6_1, Out5_0_1
			 );

	// init
    input wire CLK;
	input wire [`WORD_WIDTH-1:0] A_0, B_0;
	input wire [5:0] Out31_26_0, Out5_0_0;
	input wire [4:0] Out25_21_0, Out20_16_0, Out15_11_0, Out10_6_0;
	output reg [`WORD_WIDTH-1:0] A_1, B_1;
	output reg [5:0] Out31_26_1, Out5_0_1;
	output reg [4:0] Out25_21_1, Out20_16_1, Out15_11_1, Out10_6_1;
	
	// process
	always @(posedge CLK) begin
		A_1 <= A_0;
		B_1 <= B_0;
		Out31_26_1 <= Out31_26_0;
		Out25_21_1 <= Out25_21_0;
		Out20_16_1 <= Out20_16_0;
		Out15_11_1 <= Out15_11_0;
		Out10_6_1 <= Out10_6_0;
		Out5_0_1 <= Out5_0_0;
	end

endmodule
