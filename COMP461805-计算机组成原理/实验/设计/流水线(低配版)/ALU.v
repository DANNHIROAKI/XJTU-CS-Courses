//算数逻辑单元的设计，支持19条指令

`include "defines.v"

//输入AB为待处理的两个操作数
//输入M为ALU控制信号，用于选择ALU的操作
//输入Imm1和Imm2为立即数，位数为16位和5位，用于某些指令
//输出C为AB结果ALU的运算结果
//输出Z为ALU的零标志位，当C为0时，Z=1
module ALU(A, B, M, Z, C, Imm1, Imm2); // inputA, inputB, ALUCtrl, ZF, sum

	//定义类型和宽度
	input wire [`WORD_WIDTH-1:0] A,B;
	input wire [`ALUCtrl_WIDTH-1:0] M;
	input wire [15:0] Imm1;
	input wire [4:0] Imm2;
	output reg Z;
	output reg [`WORD_WIDTH-1:0] C;

	//当输入信号有任何改变时，执行以下模块
	always @(*) begin
		case (M) //根据ALU的控制信号M，来确定ALU执行什么操作


		    /*1.加减运算：R型指令，特殊*/
			//ADD实现了有符号的加，将输入视为有符号数，相加后的输出也是有符号数
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100000<Add>
			`ADD: 
				begin
					C = $signed(A)+$signed(B);
					Z = !(!C);//也可以写作Z=(C==0);
				end
			//SUB实现了有符号的减，将输入视为有符号数，相减后的输出也是有符号数
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100010<Sub>
			`SUB:
				begin
					C = $signed(A)-$signed(B);
					Z = !(!C);
				end
			//ADDU实现了无符号的加，将输入视为无符号数，相加后的输出也是无符号数
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100001<Addu>
			`ADDU: 
				begin
					C = $unsigned(A)+$unsigned(B);
					Z = !(!C);
				end
			//SUBU实现了无符号的减，将输入视为无符号数，相减后的输出也是无符号数
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100011<Subu>
			`SUBU:
				begin
					C = $unsigned(A)-$unsigned(B);
					Z = !(!C);
				end
			

			/*2.移位运算：R型指令，特殊*/
			//SLT实现了将输入B左移Imm2位，低位补0
			//000000<special>00000<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>xxxxxx<位移量>000000<Sll>
			`SLL:
				begin
					C = B<<Imm2;
					Z = !(!C);
				end
			//SRL实现了将输入B右移Imm2位，高位补0
			//000000<special>00000<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>xxxxxx<位移量>000010<Srl>
			`SRL:
				begin
					C = B>>Imm2;
					Z = !(!C);
				end
			//SRA实现了将输入B右移Imm2位，高位补符号位
			//000000<special>00000<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>xxxxxx<位移量>000011<Sra>
			`SRA:
				begin
					C = B>>>Imm2;
					Z = !(!C);
				end


			/*3.逻辑运算：R型指令，特殊*/
			//AND实现了AB的与运算
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100100<And>
			`AND:
				begin
					C = A&B;
					Z = !(!C);
				end
			//NOR实现了AB的或运算
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100101<Or>
			`OR:
				begin
					C = A|B;
					Z = !(!C);
				end
			//XOR实现了AB的异或运算，即相同为0不同为1
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100110<Xor>
			`XOR:
				begin
					C = A^B;
					Z = !(!C);
				end
			//NOR实现了AB的同或运算，即相同为1不同为0
			//000000<special>xxxxx<源操作数1>xxxxx<源操作数2>xxxxx<目的操作数>000000<位移量>100111<Nor>
			`NOR:
				begin
					C = ~(A|B);
					Z = !(!C);
				end
			
			
			/*4.立即数有关指令：I型指令，非特殊*/
			//ADDIU实现了与立即数的有符号加，相加后的输出也是有符号数
			//001000<Addi>xxxxx<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`ADDI:
				begin
					//Imm1[15]是立即数Imm1的符号位
					//16{Imm1[15]}在高位设置了16个符号位
					//{{16{Imm1[15]}}, Imm1}将Imm1符号扩展到32位
					C = $signed(A)+{{16{Imm1[15]}}, Imm1};
					Z = !(!C);
				end
			//ADDIU实现了与立即数的无符号加，相加后的输出也是无符号数
			//001001<Addiu>xxxxx<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`ADDIU:
				begin
					C = $unsigned(A)+{{16{Imm1[15]}}, Imm1};
					Z = !(!C);
				end
			//ANDI实现了与立即数的与运算
			//001100<Andi>xxxxx<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`ANDI:
				begin
					//Imm1高位补0
					C = A&{{16{1'b0}}, Imm1};
					Z = !(!C);
				end
			//LUI实现了立即数16位到32位的扩展，低16位补0
			//001111<Lui>00000<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`LUI:
				begin
					C = {Imm1, {16{1'b0}}};
					Z = !(!C);
				end
			//ORI实现了与立即数的或运算，立即数要预先高位补0处理
			//001101<Ori>xxxxx<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`ORI:
				begin
					C = A|{{16{1'b0}}, Imm1};
					Z = !(!C);
				end
			//SLTI实现了与立即数的有符号比较，相比较后的输出也是有符号数
			//001010<Slti>xxxxx<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`SLTI:
				begin
					//{{16{Imm1[15]}}, Imm1}是将Imm1符号扩展到32位
					//A<{{16{Imm1[15]}}, Imm1}是将A与Imm1符号扩展后的数比较
					//如果A<扩展后的立即数，则C=1
					//如果A>=扩展后的立即数，则C=0
					C = ($signed(A) < $signed({{16{Imm1[15]}}, Imm1})) ? 32'b1 : 32'b0;
					Z = !(!C);
				end
			//SLTIU实现了与立即数的无符号比较，相比较后的输出也是无符号数
			//001011<Sltiu>xxxxx<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`SLTIU:
			    begin
                    C = ($unsigned(A) < $unsigned({{16{Imm1[15]}}, Imm1})) ? 32'b1 : 32'b0;
                    Z = !C;
                end
			//XORI实现了与立即数的异或运算，立即数要预先高位补0处理
			//001110<Xori>xxxxx<源操作数>xxxxx<目的操作数>xxxxxxxxxxxxxxxx<立即数>
			`XORI:
				begin
					C = A^{{16{1'b0}}, Imm1};
					Z = !(!C);
				end
			
		endcase
	end
endmodule


