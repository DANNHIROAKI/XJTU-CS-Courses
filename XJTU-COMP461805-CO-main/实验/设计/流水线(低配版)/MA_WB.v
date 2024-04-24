//从访问内存到写回

`timescale 1ns/1ns
`include "defines.v"

//输入时钟，访存阶段计算所得的结果和地址
//将运算结果/地址，传递给写回阶段，输出
module MA_WB(CLK, C_1, Addr_1, C_Out, Addr_Out);

	// init
    input wire CLK;
	input wire [`WORD_WIDTH-1:0] C_1;
	input wire [4:0] Addr_1;
	output reg [`WORD_WIDTH-1:0] C_Out;
	output reg [4:0] Addr_Out;
	
	// process
	always @(posedge CLK) begin
        #5
		C_Out = C_1;
        Addr_Out = Addr_1;
	end

endmodule
