//存储器的设计

`include "defines.v"

//定义存储器模块
//输入信号为Addr(访问存储器的地址)，R(读使能信号)
//输出信号为R_data(读出的数据)
module MEM(Addr, R_data, R);

	//信号的声明，包含类型和宽度，数据和地址的宽度都为WORD_WIDTH
	//默认R宽度为1位
	input wire [`WORD_WIDTH-1:0] Addr;
	input wire R;
	output reg [`WORD_WIDTH-1:0] R_data;
	
	//定义了一个存储器数组mem，每个元素宽32位，共有105个元素(之前定义的)
	reg [`WORD_WIDTH-1:0] mem[`MEM_NUM-1:0];
	
	//初始化，从文件MEMINIT中读取数据，存入mem数组中
	initial 
	begin
		$readmemb("./MEMINIT", mem);
	end

	//时序逻辑，在任何输入信号变化时执行
	//读使能R=1时，将mem中Addr指定的数据赋给输出信号R_data
	always @(*) 
	begin
		if(R) 
		begin
			R_data <= mem[Addr];
		end
	end
endmodule

