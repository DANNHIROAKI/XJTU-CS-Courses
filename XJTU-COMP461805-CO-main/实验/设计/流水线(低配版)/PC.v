//程序计数器的设计

//先引入事先定义的常量
`include "defines.v"

//定义PC模块，输入时钟信号CLK，输出Q
//Q为PC当前值，其宽度等于define中定义的WORD_WIDTH
module PC(CLK, Q);

    //声明了输入信号为时钟信号CLK，输出信号为Q(并定义Q的宽度为WORD_WIDTH)
	input wire CLK;
	output reg [`WORD_WIDTH-1:0] Q;

    //初始化模块，将输出信号Q初始化为0
	//WORD_WIDTH'b0表示一个宽度为WORD_WIDTH位的二进制数，所有位都是 0
	initial 
	begin
		Q <= `WORD_WIDTH'b0;
	end
	
	//时序逻辑，描述了PC模块的行为，当时钟信号CLK的上升沿到来时，Q的值加1
	always @(posedge CLK) 
	begin
		Q <= Q+1;
	end
endmodule

