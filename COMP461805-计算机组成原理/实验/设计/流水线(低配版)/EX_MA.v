//从执行到访问内存

`timescale 1ns/1ns
`include "defines.v"

//传入时钟信号，ALU的运算结果，分割后的指令字段
//ALU的运算结果直接传递到访问内存阶段
//再根据指令类型(是否为特指令)，来确认哪个是地址字段，然后将地址传给访问内存阶段
module EX_MA(CLK, C_0, Out20_16_1, Out15_11_1, C_1, Addr_1, Out31_26_1);

	// init
    input wire CLK;
	input wire [`WORD_WIDTH-1:0] C_0;
	input wire [4:0] Out20_16_1, Out15_11_1;
    input wire [5:0] Out31_26_1;
	output reg [`WORD_WIDTH-1:0] C_1;
	output reg [4:0] Addr_1;
	
	// process
	always @(posedge CLK) begin
		if(Out31_26_1 == `Special) begin
            Addr_1 = Out15_11_1;
        end
        else begin
            Addr_1 = Out20_16_1;
        end
        C_1 = C_0;
	end

endmodule
