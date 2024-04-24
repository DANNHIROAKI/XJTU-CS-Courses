
//控制单元的实现

`include "defines.v"

//模块及其接口定义
//输入信号Out31_26是指令的[31:26]位，用于判断是否为特殊指令
//输入信号Out5_0是指令的[5:0]位，用于判断指令的具体类型
//输出信号M是给ALU控制信号，用于控制ALU的运算类型
module CU(Out31_26, Out5_0, M);

	// init
	input wire [5:0] Out31_26, Out5_0;
	output reg [`ALUCtrl_WIDTH-1:0] M;
	
	
	//输入信号发生变化时，执行以下模块，用于决定将什么控制信号丢给ALU
	always @(*) begin

		//对于被标识为特殊的指令(31_26位全0)，根据其[5:0]位的值，决定ALU的运算类型
		if(Out31_26 == `Special) 
		begin
			case (Out5_0)
				`Add:
					M <= `ADD;//
				`Sub:
					M <= `SUB;
				`Addu:
					M <= `ADDU;
				`Subu:
					M <= `SUBU;
				`Sll:
					M <= `SLL;
				`Srl:
					M <= `SRL;
				`Sra:
					M <= `SRA;
				`And:
					M <= `AND;
				`Or:
					M <= `OR;
				`Xor:
					M <= `XOR;
				`Nor:
					M <= `NOR;
			endcase
		end

		//对于其他指令，根据其[5:0]位的值，决定ALU的运算类型
		else 
		begin
			case (Out31_26)
				`Addi:
					M <= `ADDI;
				`Addiu:
					M <= `ADDIU;
				`Andi:
					M <= `ANDI;
				`Lui:
					M <= `LUI;
				`Ori:
					M <= `ORI;
				`Slti:
					M <= `SLTI;
				`Sltiu:
					M <= `SLTIU;
				`Xori:
					M <= `XORI;
			endcase
		end
			
	end
endmodule
