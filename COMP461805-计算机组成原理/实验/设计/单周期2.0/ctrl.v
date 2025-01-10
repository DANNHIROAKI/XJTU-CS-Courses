// `include "ctrl_encode_def.v"


module ctrl(Op, Funct, Zero, 
            RegWrite, MemWrite,
            EXTOp, ALUOp, NPCOp, 
            ALUSrc, GPRSel, WDSel, ALUSrcA
            );
            
   input  [5:0] Op;       // opcode
   input  [5:0] Funct;    // funct
   input        Zero;
   
   output       RegWrite; // control signal for register write
   output       MemWrite; // control signal for memory write
   output       EXTOp;    // control signal to signed extension
   output [3:0] ALUOp;    // ALU opertion
   output [1:0] NPCOp;    // next pc operation
   output       ALUSrc;   // ALU source for B 	0:B来自RD2; 1:B来自立即数
   output       ALUSrcA;  // ALU source for A 	0:A来自RD1;	1:A来自shamt
   output [1:0] GPRSel;   // general purpose register selection 对应A3选择器
   output [1:0] WDSel;    // (register) write data selection 对应连接WD的选择器
   
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
  // generate control signals
  assign RegWrite   = rtype&~i_jr | i_lw | i_addi | i_ori | i_jal | i_lui | i_slti | i_andi | i_jalr; // register write
  
  assign MemWrite   = i_sw;                           // memory write
  assign ALUSrc     = i_lw | i_sw | i_addi | i_ori | i_lui | i_slti | i_andi;   // ALU B is from instruction immediate 
  assign EXTOp      = i_addi | i_lw | i_sw | i_lui | i_slti;           // signed extension
  assign ALUSrcA	= i_sll | i_srl;	//ALU A 来自shamt字段
  
  // GPRSel_RD   2'b00
  // GPRSel_RT   2'b01
  // GPRSel_31   2'b10
  assign GPRSel[0] = i_lw | i_addi | i_ori | i_lui | i_slti | i_andi;
  assign GPRSel[1] = i_jal;
  
  // WDSel_FromALU 2'b00
  // WDSel_FromMEM 2'b01
  // WDSel_FromPC  2'b10 
  assign WDSel[0] = i_lw;
  assign WDSel[1] = i_jal | i_jalr;

  // NPC_PLUS4   2'b00
  // NPC_BRANCH  2'b01
  // NPC_JUMP    2'b10
  // NPC_JUMPR   2'b11
  assign NPCOp[0] = i_beq & Zero | i_bne & ~Zero | i_jr | i_jalr;
  assign NPCOp[1] = i_j | i_jal | i_jr | i_jalr;
  
  // ALU_NOP   4'b0000
  // ALU_ADD   4'b0001
  // ALU_SUB   4'b0010
  // ALU_BNE   4'b0010
  // ALU_AND   4'b0011
  // ALU_ANDI  4'b0011
  // ALU_OR    4'b0100
  // ALU_SLT   4'b0101
  // ALU_SLTI  4'b0101
  // ALU_SLTU  4'b0110
  // ALU_SLLV  4'b0111 
  // ALU_SLL   4'b1000
  // ALU_NOR   4'b1001
  // ALU_LUI   4'b1010
  // ALU_SRL   4'b1011
  // ALU_SRLV  4'b1100
  assign ALUOp[0] = i_add | i_lw | i_sw | i_addi | i_and | i_slt | i_addu | i_nor | i_slti | i_andi | i_srl | i_sllv;
  assign ALUOp[1] = i_sub | i_beq | i_and | i_sltu | i_subu | i_lui | i_bne | i_andi | i_srl | i_sllv;
  assign ALUOp[2] = i_or | i_ori | i_slt | i_sltu | i_slti | i_sllv | i_srlv;
  assign ALUOp[3] = i_sll | i_nor | i_lui | i_srl | i_srlv;
endmodule
