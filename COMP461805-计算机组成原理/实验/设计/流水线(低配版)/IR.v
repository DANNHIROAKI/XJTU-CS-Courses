//指令寄存器的设计

//包含常量定义文件
`include "defines.v"

//定义了模块的接口
//CLK：输入的时钟信号
//D：输入的指令，其宽度由定义文件中的WORD_WIDTH决定，即32位
//Out31_26：输出指令的[31:26]位，即操作码
//Out25_21：输出指令的[25:21]位，可以是第一个操作数的寄存器地址
//以此类推，Out20_16，Out15_11，Out10_6，Out5_0都代表指令的不同部分
module IR(CLK, D, Out31_26, Out25_21, Out20_16, Out15_11, Out10_6, Out5_0);

	//输入输出声明
	//输入时钟信号，输入指令(定义为32位)
	input wire CLK;
	input wire [`WORD_WIDTH-1:0] D;

	//输出指令的不同部分,注意不同部分宽度有所不同，但都为reg寄存器类型
	//使用reg类型是因为，所有在always块中被赋值的变量都必须是reg类型
	output reg [5:0] Out31_26, Out5_0;
	output reg [4:0] Out25_21,Out20_16, Out15_11, Out10_6;

	//always块中，当时钟信号变化时，将输入指令的不同部分赋值给输出指令对应部分
	always @(*) 
	begin
		Out31_26 <= D[31:26];
		Out25_21 <= D[25:21];
		Out20_16 <= D[20:16];
		Out15_11 <= D[15:11];
		Out10_6 <= D[10:6];
		Out5_0 <= D[5:0];
	end
endmodule
