// CPU.v
`timescale 1ns/1ns
`include "defines.v"

module CPU();

	//设置时钟信号，驱动CPU的运行
	reg CLK;

    //声明变量Q用于储存PC当前值，实例化PC模块为pc
	/*
	**1.CLK是输入时钟信号为
	**2.Q是PC当前指向(输出)的值为
	*/
	wire [`WORD_WIDTH-1:0] Q;
	PC pc(CLK, Q);
	
	
	wire [`WORD_WIDTH-1:0] IR_0, IR_1;
	MEM mem(Q, IR_0, 1'b1);
	FI_ID fi_id(CLK, IR_0, IR_1);

	wire [5:0] Out31_26_0, Out5_0_0, Out31_26_1, Out5_0_1;
	wire [4:0] Out25_21_0, Out20_16_0, Out15_11_0, Out10_6_0, Out25_21_1, Out20_16_1, Out15_11_1, Out10_6_1;
	IR ir(CLK, IR_1, Out31_26_0, Out25_21_0, Out20_16_0, Out15_11_0, Out10_6_0, Out5_0_0);
	
	wire [`WORD_WIDTH-1:0] A_0, B_0, C_0, A_1, B_1, C_1, C_Out;
	wire [4:0] Addr_1, Addr_Out;
	wire [`ALUCtrl_WIDTH-1:0] M;
	wire Z;
	RF rf(CLK, 1'b1, Out25_21_0, Out20_16_0, Addr_Out, C_Out, A_0, B_0, `Special);
	ID_EX id_ex(CLK, A_0, B_0, Out31_26_0, Out25_21_0, Out20_16_0, Out15_11_0, Out10_6_0, Out5_0_0, 
					A_1, B_1, Out31_26_1, Out25_21_1, Out20_16_1, Out15_11_1, Out10_6_1, Out5_0_1);
	
	CU cu(Out31_26_1, Out5_0_1, M);
	ALU alu(A_1, B_1, M, Z, C_0, {Out15_11_1, Out10_6_1, Out5_0_1}, Out10_6_1);

	EX_MA ex_ma(CLK, C_0, Out20_16_1, Out15_11_1, C_1, Addr_1, Out31_26_1);
	MA_WB ma_wb(CLK, C_1, Addr_1, C_Out, Addr_Out);

	initial begin
      CLK = 0;
      forever begin
         #10 CLK = ~CLK;
      end
   end

endmodule
