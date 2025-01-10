//从取指令到译码

`timescale 1ns/1ns
`include "defines.v"

//定义模块
//输入时钟信号
//输入取值阶段所获得的指令
//在上升沿的时候，将取值阶段的指令传递到译码阶段
module FI_ID(CLK, IR_0, IR_1);

	// init
    input wire CLK;
	input wire [`WORD_WIDTH-1:0] IR_0;
	output reg [`WORD_WIDTH-1:0] IR_1;
	
	//在每个时钟周期的上升沿，将取指令阶段的指令传递到译码阶段
	always @(posedge CLK) begin
		IR_1 <= IR_0;
	end

endmodule
