//CPU顶层架构


//时间标度，1ns/1ns表示1ns的仿真时间对应1ns的实际时间
`timescale 1ns/1ns

//包含各个模块的定义
`include "defines.v"
`include "ALU.v"
`include "CU.v"
`include "IR.v"
`include "MEM.v"
`include "PC.v"
`include "RF.v"

//定义CPU模块
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
	

	//声明变量now_ir用于储存当前指令，实例化MEM模块为mem，
	/*
	**1.Q是当前PC的值，在此处作位访问存储器的地址输入
	**2.now_ir是根据地址Q，从存储器中读出的当前指令
	**3.1'b1是写使能信号
	*/
	wire [`WORD_WIDTH-1:0] now_ir;
	MEM mem(Q, now_ir, 1'b1);


    //声明变量Out31_26...Out5_0用于储存当前指令的不同部分，实例化IR模块为ir
	/*
	**1.CLK是输入时钟信号
	**2.now_ir是根据地址Q从存储器中读出的指令，此处直接输入指令寄存器
	**3.Out31_26...Out5_0是对当前指令分割并输出，用于判断指令类型
	** 1)在R型指令中
	**   Out31_26：操作码
	**   Out25_21：源操作数1
	**   Out20_16：源操作数2
	**   Out15_11：目的操作数
	**   Out10_6：移位位数
	**   Out5_0：功能码
	** 2)在I型指令中
	**   Out31_26：操作码
	**   Out25_21：源操作数1
	**   Out20_16：目的操作数
	**   Out15_0：立即数
	** 3)在J型指令中
	**   Out31_26：操作码
	**   Out25_0：立即数，用于跳转
	*/
	//一旦CLK或者now_ir发生变化，就将now_ir的不同部分赋值给对应Out31_26...Out5_0
	wire [5:0] Out31_26, Out5_0;
	wire [4:0] Out25_21,Out20_16, Out15_11, Out10_6;
	IR ir(CLK, now_ir, Out31_26, Out25_21, Out20_16, Out15_11, Out10_6, Out5_0);


	//声明ALU有关变量，AB为两个输入，C为输出，M为控制信号，Z为ALU的零标志位
	wire [`WORD_WIDTH-1:0] A,B,C;
	wire [`ALUCtrl_WIDTH-1:0] M;
	wire Z;


	//将CU模块实例化为cu
	/*
	**1.将来自IR的Out31_26输入，用于判断指令类型是否为special
	**2.将来自IR的Out5_0输入，用于判断完指令是否为special后，再来判断指令的类型
	**3.M为根据指令类型生成的控制信号，用于控制ALU的操作
	*/
	CU cu(Out31_26, Out5_0, M);


	//将RF模块实例化为rf
	/*
	**1.CLK是输入时钟信号
	**2.1'b1是写使能信号，没有读使能信号
	**3.Out25_21(源操作数1)，Out20_16(源操作数2)，Out15_11(目的操作数)，来自IR模块并输入RF
	**4.C是ALU的运算结果(输入RF)，AB是ALU的两个输入(从RF读出)
	**
	**5.写入：Out31_26来自IR并输入RF，用于判断是否为特殊指令(此处特殊指令=I型，其他=R型)
	**  1)对于非特殊指令(R型)，则C写入Out20_16指定的寄存器(0号寄存器除外)
	**  2)对于特殊指令(I型)，则C写入Out15_11指定的寄存器(0号寄存器除外)
	**
	**6.读出
	**  1)当Out25_21(源操作数1)对应的不是0寄存器时，将Out25_21的值赋给A
	**  2)当Out20_16(源操作数2)对应的不是0寄存器时，将Out20_16的值赋给B
	**  3)当Out25_21(源操作数1)对应的是0寄存器时，将0赋给A
	**  4)当Out20_16(源操作数2)对应的是0寄存器时，将0赋给B
	*/
	RF rf(CLK, 1'b1, Out25_21, Out20_16, Out15_11, C, A, B, Out31_26);

	//将ALU模块实例化为alu，
	/*
	**1.ABMZC分别为输入1，输入2，控制信号，零标志位，输出
	**2.当控制信号指定ALU执行立即数有关操作时，把低16位拼成{Out15_11, Out10_6, Out5_0}当作立即数
	**3.当控制信号指定ALU执行移位操作时，把Out10_6当作移位位数
	*/
	ALU alu(A, B, M, Z, C, {Out15_11, Out10_6, Out5_0}, Out10_6);

    //以下为时钟信号的生成
	initial 
	begin
	  //初始化时钟信号为0，forever表示无限循环
      CLK = 0; 
      forever

      //每隔10ns，时钟信号取反
	  begin
         #10 CLK = ~CLK;
      end
   end

endmodule
