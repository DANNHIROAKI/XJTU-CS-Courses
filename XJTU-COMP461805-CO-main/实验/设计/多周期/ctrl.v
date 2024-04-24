//`include "ctrl_encode_def.v"


module ctrl(clk, rst, Zero, Op, Funct,
            RegWrite, MemWrite, PCWrite, IRWrite,
            EXTOp, ALUOp, PCSource, ALUSrcA, ALUSrcB, 
            GPRSel, WDSel, IorD);
    
   input  clk, rst, Zero;
   input  [5:0] Op;       // opcode
   input  [5:0] Funct;    // funct
   output reg       RegWrite; // control signal for register write
   output reg       MemWrite; // control signal for memory write
   output reg       PCWrite;  // control signal for PC write
   output reg       IRWrite;  // control signal for IR write
   output reg       EXTOp;    // control signal to signed extension
   output reg [1:0] ALUSrcA;  // ALU source for A, 0 - PC, 1 - ReadData1, 2 - shamt
   output reg [1:0] ALUSrcB;  // ALU source for B, 0 - ReadData2, 1 - 4, 2 - extended immediate, 3 - branch offset
   output reg [3:0] ALUOp;    // ALU opertion
   output reg [1:0] PCSource; // PC source, 0- ALU, 1-ALUOut, 2-JUMP address
   output reg [1:0] GPRSel;   // general purpose register selection
   output reg [1:0] WDSel;    // (register) write data selection
   output reg       IorD;     // 0-memory access for instruction, 1 - memory access for data
   
   parameter  [2:0] sif  = 3'b000,                // 去指令
                    sid  = 3'b001,                // 指令译码
                    sexe = 3'b010,                // 执行
                    smem = 3'b011,                // 访问内存
                    swb  = 3'b100;                // 写回
  // r format
   wire rtype  = ~|Op;
   wire i_add  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // add
   wire i_sub  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // sub
   wire i_and  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // and
   wire i_or   = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0]; // or
   wire i_slt  = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // slt
   wire i_sltu = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sltu
   wire i_addu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // addu
   wire i_subu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // subu
   wire i_sll  = rtype& ~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; //sll
   wire i_nor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; //nor
   wire i_srl  = rtype& ~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&Funct[1]&~Funct[0]; //srl
   wire i_sllv = rtype& ~Funct[5]&~Funct[4]&~Funct[3]&Funct[2]&~Funct[1]&~Funct[0];  //sllv
   wire i_srlv = rtype& ~Funct[5]&~Funct[4]&~Funct[3]&Funct[2]&Funct[1]&~Funct[0];  //srlv
   
  // i format
   wire i_addi = ~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // addi
   wire i_ori  = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]& Op[0]; // ori
   wire i_lw   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lw
   wire i_sw   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sw
   wire i_beq  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // beq
   wire i_lui  = ~Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0]; // lui
   wire i_slti = ~Op[5]&~Op[4]& Op[3]& ~Op[2]& Op[1]& ~Op[0]; // slti
   wire i_bne  = ~Op[5]&~Op[4]& ~Op[3]& Op[2]& ~Op[1]& Op[0]; // bne
   wire i_andi = ~Op[5]&~Op[4]& Op[3]& Op[2]& ~Op[1]& ~Op[0]; //andi
   
  // j format
   wire i_j    = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]&~Op[0];  // j
   wire i_jal  = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];  // jal
   wire i_jr   = rtype& ~Funct[5]&~Funct[4]&Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // jr op段与r型指令一样全为0
   wire i_jalr = rtype& ~Funct[5]&~Funct[4]&Funct[3]&~Funct[2]&~Funct[1]&Funct[0]; // jalr
  /*************************************************/
  /******               有限状态机                   ******/
   reg [2:0] nextstate;//当前状态和下一状态
   reg [2:0] state;
   
   always @(posedge clk or posedge rst) begin
     if ( rst )
       state <= sif;
     else
       state <= nextstate;//更新到下一状态，具体说明状态由控制信号逻辑决定
   end 

  /*************************************************/
  /******         控制信号             ******/
   always @(*) begin
     RegWrite = 0;
     MemWrite = 0;
     PCWrite  = 0;
     IRWrite  = 0;
     EXTOp    = 1;           // signed extension
     ALUSrcA  = 2'b01;           // 1 - ReadData1
     ALUSrcB  = 2'b00;       // 0 - ReadData2
     ALUOp    = 4'b0001;      // ALU_ADD       3'b001
     GPRSel   = 2'b00;       // GPRSel_RD     2'b00
     WDSel    = 2'b00;       // WDSel_FromALU 2'b00
     PCSource = 2'b00;       // PC + 4 (ALU)
     IorD     = 0;           // 0-memory access for instruction

     case (state)

         //在取指令阶段，设置好默认的控制信号
         sif: begin
           PCWrite = 1;
           IRWrite = 1;
           ALUSrcA = 2'b00;      // PC
           ALUSrcB = 2'b01;  // 4
           nextstate = sid;
         end
         

         //在指令译码阶段，根据指令的不同，设置不同的控制信号，并更新到下一个状态
         sid: begin
           //对于跳转指令，设置好控制信号后按照NPC的逻辑更新PC
           //然后直接回到取指令解阶段(执行下一个指令)
           if (i_j) 
           begin
             PCSource = 2'b10;
             PCWrite = 1;
             nextstate = sif;
           end 
           else if (i_jal) 
           begin
             PCSource = 2'b10; // JUMP address
             PCWrite = 1;
             RegWrite = 1;
             WDSel = 2'b10;    // WDSel_FromPC  2'b10 
             GPRSel = 2'b10;   // GPRSel_31     2'b10
             nextstate = sif;
           end 
           else if(i_jr) 
             begin
		    	   PCSource = 2'b11;
		    	   PCWrite = 1;
			       nextstate = sif;
		       end 
           else if(i_jalr) 
           begin
			       PCSource = 2'b11;
			       PCWrite = 1;
			       nextstate = sif;
			       RegWrite = 1;
             WDSel = 2'b10; 
			       GPRSel =  2'b00;
		       end

           //对于其他指令，初始化ALU两端控制信号后，进入执行阶段
		       else 
           begin
             ALUSrcA = 2'b00;   
             ALUSrcB = 2'b11;  
             nextstate = sexe;
           end
         end
         

         //执行阶段
         sexe: begin

          //确定要执行什么指令
           ALUOp[0] = i_add | i_lw | i_sw | i_addi | i_and | i_slt | i_addu | i_sll | i_lui | i_slti || i_andi | i_sllv;
           ALUOp[1] = i_sub | i_beq | i_and | i_sltu | i_subu | i_sll | i_bne | i_andi | i_srl | i_sllv;
           ALUOp[2] = i_or | i_ori | i_slt | i_sltu | i_sll | i_slti | i_srlv;
		       ALUOp[3] = i_nor | i_lui | i_srl | i_sllv | i_srlv;

           //分支处理，如果分支成立，设置好PC以跳转到下一个指令，然后回到取指令阶段
           if (i_beq | i_bne) begin
             PCSource = 2'b01; // ALUout, branch address
             PCWrite = i_beq & Zero | i_bne & ~Zero;
             nextstate = sif;
           end 
           //内存访问，设置好ALU两端控制信号，然后进入内存访问阶段
           else if (i_lw || i_sw) begin
             ALUSrcB = 2'b10; // select offset
             nextstate = smem;
           end 
           //移位指令，设置好ALU两端(特殊)控制信号，然后进入写回阶段
           else if (i_sll | i_srl)begin
			       ALUSrcA = 2'b10; //shamt
			       nextstate = swb;
			     end

           //对于其他的所有指令，相应指令设置好相应控制信号，就进入写回阶段
		   		 else begin
             if (i_addi || i_ori || i_lui || i_slti || i_andi)
               ALUSrcB = 2'b10; // select immediate
             if (i_ori || i_andi)
               EXTOp = 0; // zero extension
             nextstate = swb;
           end
         end


         //内存访问阶段，设置好内存访问控制信号，然后进入写回阶段
         smem: begin
           IorD = 1;  // 表示ALU输出的是内存地址
           if (i_lw) begin
             nextstate = swb;
           end 
           else begin  // i_sw
             MemWrite = 1;
             nextstate = sif;
           end
         end
         

         //写回阶段，设置好写回控制信号(把什么写回，写回到哪里)，然后回到取指令阶段
         swb: begin
           if (i_lw)
             WDSel = 2'b01;     // WDSel_FromMEM 2'b01
           if (i_lw | i_addi | i_ori | i_lui | i_slti | i_andi) begin
             GPRSel = 2'b01;    // GPRSel_RT     2'b01
           end
           RegWrite = 1;
           nextstate = sif;
         end

        
         default: begin
           nextstate = sif;
         end
      
     endcase
   end // end always
   
endmodule
