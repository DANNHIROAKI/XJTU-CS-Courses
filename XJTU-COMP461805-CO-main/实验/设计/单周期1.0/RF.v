//寄存器堆的设计，也就是CPU指令执行过程中所用到的寄存器


`include "defines.v"

//定义模块及其接口
//输入的控制信号：CLK时钟信号，RegWr写使能信号(MCU发出)
//输入的地址信号：R_Reg1，R_Reg2，W_Reg寄存器地址
//输入的数据信号：W_data写入数据
//输入的附加信号：Out31_26指令的31-26位，用于判断是否为特殊指令
//输出信号：寄存器读出的数据R_data1，R_data2
module RF(CLK, RegWr, R_Reg1, R_Reg2, W_Reg, W_data, R_data1, R_data2, Out31_26);

	//定义接口及其类型和位宽，含义见上
	//关于是wire还是reg类型，判断依据是：是否有always块对其赋值
	input wire CLK, RegWr;
	input wire [`REG_WIDTH-1:0] R_Reg1, R_Reg2, W_Reg;
	input wire [`WORD_WIDTH-1:0] W_data;
	input wire [5:0] Out31_26;
	output reg [`WORD_WIDTH-1:0] R_data1, R_data2;

	//定义寄存器堆，共32个寄存器，每个寄存器宽度为32位
	//reg表示寄存器堆的类型，`WORD_WIDTH-1:0表示寄存器的位宽32位
	//REG是寄存器数组的名称，(1<<`REG_WIDTH)-1:0是寄存器数组的大小，即32个寄存器
	reg [`WORD_WIDTH-1:0] REG[(1<<`REG_WIDTH)-1:0];

    //这一段的作用是初始化寄存器堆，将所有寄存器的值初始化为0 
	integer i;
	initial
	begin
		for(i=0; i<(1<<`REG_WIDTH); i=i+1) 
		begin: REG_INIT //REG_INIT是一个标签，用于跳转
			REG[i] <= 0;
		end
	end

	//以下模块在时钟CLK上升沿时执行，用于写入数据到寄存器堆
	always @(posedge CLK) 
	begin
		
		//检查三个条件：写使能RegWr要为1，指令31-26位不能是特殊指令，不写入0号寄存器(规定不可写入)
		//如果满足上述条件，将数据W_data写入寄存器堆中R_Reg2指定的寄存器
		if(RegWr && Out31_26 != `Special && R_Reg2 != `REG_WIDTH'b0) 
		begin
			REG[R_Reg2] = W_data;
		end

		//另一种情况，写使能RegWr=1，不写入0号寄存器，但允许写入特殊指令
		else if(RegWr && W_Reg != `REG_WIDTH'b0) 
		begin
			REG[W_Reg] = W_data;
		end
	end

    //以下模块在发生任何信号变化时执行，用于读取寄存器堆中的数据
	always @(*) 
	begin

		//当R_Reg1所指不是0号寄存器时，将寄存器堆中R_eg1指定的寄存器的值赋给R_data1
		if(R_Reg1 != `REG_WIDTH'b0) 
		begin
			R_data1 = REG[R_Reg1];
		end

        //当R_Reg1所指是0号寄存器时，将R_data1赋值为0
		else 
		begin
			R_data1 = `WORD_WIDTH'b0;
		end

        //对于R_Reg2，同理
		if(R_Reg2 != `REG_WIDTH'b0) 
		begin
			R_data2 = REG[R_Reg2];
		end
		else 
		begin
			R_data2 = `WORD_WIDTH'b0;
		end
	end
		
endmodule
