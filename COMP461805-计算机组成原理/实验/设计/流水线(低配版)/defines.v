//该文件定义了CPU设计中用到的各种常量

//定义了数据宽度，一个字节宽8位，一个字宽32位
`define BYTE_WIDTH		8
`define WORD_WIDTH		4*`BYTE_WIDTH

//ALU的控制信号宽度为5位，
`define ALUCtrl_WIDTH	5

//为ALU的不同操作指定唯一的操作码
//本质是一个宏替换：例如代码中出现ADD，实际上会被替换成`ALUCtrl_WIDTH'd0
//dn表示十进制的n，对应一个五位二进制，从而对应一个ALU的控制信号(操作)
`define ADD				`ALUCtrl_WIDTH'd0
`define SUB				`ALUCtrl_WIDTH'd1
`define ADDU			`ALUCtrl_WIDTH'd2
`define SUBU			`ALUCtrl_WIDTH'd3
`define SLL				`ALUCtrl_WIDTH'd4
`define SRL				`ALUCtrl_WIDTH'd5
`define SRA				`ALUCtrl_WIDTH'd6
`define AND				`ALUCtrl_WIDTH'd7
`define OR				`ALUCtrl_WIDTH'd8
`define XOR				`ALUCtrl_WIDTH'd9
`define NOR				`ALUCtrl_WIDTH'd10
`define ADDI            `ALUCtrl_WIDTH'd11
`define ADDIU           `ALUCtrl_WIDTH'd12
`define ANDI            `ALUCtrl_WIDTH'd13
`define LUI             `ALUCtrl_WIDTH'd14
`define ORI             `ALUCtrl_WIDTH'd15
`define SLTI            `ALUCtrl_WIDTH'd16
`define SLTIU           `ALUCtrl_WIDTH'd17
`define XORI            `ALUCtrl_WIDTH'd18

//定义寄存器地址的宽度为5位，用于寻址32个寄存器
`define REG_WIDTH		5

//定义存储器的大小，在这里是105字，即105*32bit
`define MEM_NUM			105 

//为CU的不同操作指定唯一的操作码，依然是宏替换，但是是6位二进制数
`define Special			6'b000000 //特殊指令
`define Add				6'b100000
`define Sub				6'b100010
`define Addu			6'b100001
`define Subu			6'b100011
`define Sll				6'b000000
`define Srl				6'b000010
`define Sra				6'b000011
`define And				6'b100100
`define Or				6'b100101
`define Xor				6'b100110
`define Nor				6'b100111

`define Addi            6'b001000
`define Addiu           6'b001001
`define Andi            6'b001100
`define Lui             6'b001111
`define Ori             6'b001101
`define Slti            6'b001010
`define Sltiu           6'b001011
`define Xori            6'b001110
