
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8d013103          	ld	sp,-1840(sp) # 800088d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	8e070713          	addi	a4,a4,-1824 # 80008930 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	f5e78793          	addi	a5,a5,-162 # 80005fc0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca5f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e1678793          	addi	a5,a5,-490 # 80000ec2 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	4b6080e7          	jalr	1206(ra) # 800025e0 <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	784080e7          	jalr	1924(ra) # 800008be <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8e650513          	addi	a0,a0,-1818 # 80010a70 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a8e080e7          	jalr	-1394(ra) # 80000c20 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8d648493          	addi	s1,s1,-1834 # 80010a70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	96690913          	addi	s2,s2,-1690 # 80010b08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	91a080e7          	jalr	-1766(ra) # 80001ada <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	262080e7          	jalr	610(ra) # 8000242a <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	fac080e7          	jalr	-84(ra) # 80002182 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	378080e7          	jalr	888(ra) # 8000258a <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	84a50513          	addi	a0,a0,-1974 # 80010a70 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	aa6080e7          	jalr	-1370(ra) # 80000cd4 <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	83450513          	addi	a0,a0,-1996 # 80010a70 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a90080e7          	jalr	-1392(ra) # 80000cd4 <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	88f72b23          	sw	a5,-1898(a4) # 80010b08 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	560080e7          	jalr	1376(ra) # 800007ec <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54e080e7          	jalr	1358(ra) # 800007ec <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	542080e7          	jalr	1346(ra) # 800007ec <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	538080e7          	jalr	1336(ra) # 800007ec <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	7a450513          	addi	a0,a0,1956 # 80010a70 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	94c080e7          	jalr	-1716(ra) # 80000c20 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	344080e7          	jalr	836(ra) # 80002636 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	77650513          	addi	a0,a0,1910 # 80010a70 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	9d2080e7          	jalr	-1582(ra) # 80000cd4 <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	75270713          	addi	a4,a4,1874 # 80010a70 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	72878793          	addi	a5,a5,1832 # 80010a70 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7927a783          	lw	a5,1938(a5) # 80010b08 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6e670713          	addi	a4,a4,1766 # 80010a70 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6d648493          	addi	s1,s1,1750 # 80010a70 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	69a70713          	addi	a4,a4,1690 # 80010a70 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	72f72223          	sw	a5,1828(a4) # 80010b10 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	65e78793          	addi	a5,a5,1630 # 80010a70 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	6cc7ab23          	sw	a2,1750(a5) # 80010b0c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6ca50513          	addi	a0,a0,1738 # 80010b08 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	da0080e7          	jalr	-608(ra) # 800021e6 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	61050513          	addi	a0,a0,1552 # 80010a70 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	728080e7          	jalr	1832(ra) # 80000b90 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00020797          	auipc	a5,0x20
    8000047c:	79078793          	addi	a5,a5,1936 # 80020c08 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7670713          	addi	a4,a4,-906 # 80000100 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054763          	bltz	a0,80000538 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088c63          	beqz	a7,800004fe <printint+0x62>
    buf[i++] = '-';
    800004ea:	fe070793          	addi	a5,a4,-32
    800004ee:	00878733          	add	a4,a5,s0
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x90>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d5e080e7          	jalr	-674(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7e>
}
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    x = -xx;
    80000538:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053c:	4885                	li	a7,1
    x = -xx;
    8000053e:	bf95                	j	800004b2 <printint+0x16>

0000000080000540 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054c:	00010797          	auipc	a5,0x10
    80000550:	5e07a223          	sw	zero,1508(a5) # 80010b30 <pr+0x18>
  printf("panic: ");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	b5a50513          	addi	a0,a0,-1190 # 800080c8 <digits+0x88>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00008717          	auipc	a4,0x8
    80000584:	36f72823          	sw	a5,880(a4) # 800088f0 <panicked>
  for(;;)
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
{
    8000058a:	7131                	addi	sp,sp,-192
    8000058c:	fc86                	sd	ra,120(sp)
    8000058e:	f8a2                	sd	s0,112(sp)
    80000590:	f4a6                	sd	s1,104(sp)
    80000592:	f0ca                	sd	s2,96(sp)
    80000594:	ecce                	sd	s3,88(sp)
    80000596:	e8d2                	sd	s4,80(sp)
    80000598:	e4d6                	sd	s5,72(sp)
    8000059a:	e0da                	sd	s6,64(sp)
    8000059c:	fc5e                	sd	s7,56(sp)
    8000059e:	f862                	sd	s8,48(sp)
    800005a0:	f466                	sd	s9,40(sp)
    800005a2:	f06a                	sd	s10,32(sp)
    800005a4:	ec6e                	sd	s11,24(sp)
    800005a6:	0100                	addi	s0,sp,128
    800005a8:	8a2a                	mv	s4,a0
    800005aa:	e40c                	sd	a1,8(s0)
    800005ac:	e810                	sd	a2,16(s0)
    800005ae:	ec14                	sd	a3,24(s0)
    800005b0:	f018                	sd	a4,32(s0)
    800005b2:	f41c                	sd	a5,40(s0)
    800005b4:	03043823          	sd	a6,48(s0)
    800005b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005bc:	00010d97          	auipc	s11,0x10
    800005c0:	574dad83          	lw	s11,1396(s11) # 80010b30 <pr+0x18>
  if(locking)
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
  if (fmt == 0)
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
  va_start(ap, fmt);
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    if(c != '%'){
    800005de:	02500a93          	li	s5,37
    switch(c){
    800005e2:	07000b93          	li	s7,112
  consputc('x');
    800005e6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e8:	00008b17          	auipc	s6,0x8
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80008040 <digits>
    switch(c){
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00010517          	auipc	a0,0x10
    800005fe:	51e50513          	addi	a0,a0,1310 # 80010b18 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	61e080e7          	jalr	1566(ra) # 80000c20 <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80008028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
      consputc(c);
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c60080e7          	jalr	-928(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    if(c != '%'){
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    switch(c){
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e30080e7          	jalr	-464(ra) # 8000049c <printint>
      break;
    80000674:	bf45                	j	80000624 <printf+0x9a>
    switch(c){
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0c080e7          	jalr	-500(ra) # 8000049c <printint>
      break;
    80000698:	b771                	j	80000624 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bce080e7          	jalr	-1074(ra) # 8000027c <consputc>
  consputc('x');
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc2080e7          	jalr	-1086(ra) # 8000027c <consputc>
    800006c2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bae080e7          	jalr	-1106(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
      for(; *s; s++)
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
        consputc(*s);
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
        s = "(null)";
    80000706:	00008497          	auipc	s1,0x8
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
      consputc('%');
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b66080e7          	jalr	-1178(ra) # 8000027c <consputc>
      break;
    8000071e:	b719                	j	80000624 <printf+0x9a>
      consputc('%');
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5a080e7          	jalr	-1190(ra) # 8000027c <consputc>
      consputc(c);
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b50080e7          	jalr	-1200(ra) # 8000027c <consputc>
      break;
    80000734:	bdc5                	j	80000624 <printf+0x9a>
  if(locking)
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
}
    8000073a:	70e6                	ld	ra,120(sp)
    8000073c:	7446                	ld	s0,112(sp)
    8000073e:	74a6                	ld	s1,104(sp)
    80000740:	7906                	ld	s2,96(sp)
    80000742:	69e6                	ld	s3,88(sp)
    80000744:	6a46                	ld	s4,80(sp)
    80000746:	6aa6                	ld	s5,72(sp)
    80000748:	6b06                	ld	s6,64(sp)
    8000074a:	7be2                	ld	s7,56(sp)
    8000074c:	7c42                	ld	s8,48(sp)
    8000074e:	7ca2                	ld	s9,40(sp)
    80000750:	7d02                	ld	s10,32(sp)
    80000752:	6de2                	ld	s11,24(sp)
    80000754:	6129                	addi	sp,sp,192
    80000756:	8082                	ret
    release(&pr.lock);
    80000758:	00010517          	auipc	a0,0x10
    8000075c:	3c050513          	addi	a0,a0,960 # 80010b18 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	574080e7          	jalr	1396(ra) # 80000cd4 <release>
}
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000774:	00010497          	auipc	s1,0x10
    80000778:	3a448493          	addi	s1,s1,932 # 80010b18 <pr>
    8000077c:	00008597          	auipc	a1,0x8
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80008038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	40a080e7          	jalr	1034(ra) # 80000b90 <initlock>
  pr.locking = 1;
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007be:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80008058 <digits+0x18>
    800007d4:	00010517          	auipc	a0,0x10
    800007d8:	36450513          	addi	a0,a0,868 # 80010b38 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	3b4080e7          	jalr	948(ra) # 80000b90 <initlock>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
  push_off();
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	3dc080e7          	jalr	988(ra) # 80000bd4 <push_off>

  if(panicked){
    80000800:	00008797          	auipc	a5,0x8
    80000804:	0f07a783          	lw	a5,240(a5) # 800088f0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000808:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    for(;;)
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081a:	0ff4f513          	zext.b	a0,s1
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	44e080e7          	jalr	1102(ra) # 80000c74 <pop_off>
}
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000838:	00008797          	auipc	a5,0x8
    8000083c:	0c07b783          	ld	a5,192(a5) # 800088f8 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	0c073703          	ld	a4,192(a4) # 80008900 <uart_tx_w>
    80000848:	06f70a63          	beq	a4,a5,800008bc <uartstart+0x84>
{
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000862:	00010a17          	auipc	s4,0x10
    80000866:	2d6a0a13          	addi	s4,s4,726 # 80010b38 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	08e48493          	addi	s1,s1,142 # 800088f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00008997          	auipc	s3,0x8
    80000876:	08e98993          	addi	s3,s3,142 # 80008900 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	c705                	beqz	a4,800008aa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000884:	01f7f713          	andi	a4,a5,31
    80000888:	9752                	add	a4,a4,s4
    8000088a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088e:	0785                	addi	a5,a5,1
    80000890:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000892:	8526                	mv	a0,s1
    80000894:	00002097          	auipc	ra,0x2
    80000898:	952080e7          	jalr	-1710(ra) # 800021e6 <wakeup>
    
    WriteReg(THR, c);
    8000089c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008a0:	609c                	ld	a5,0(s1)
    800008a2:	0009b703          	ld	a4,0(s3)
    800008a6:	fcf71ae3          	bne	a4,a5,8000087a <uartstart+0x42>
  }
}
    800008aa:	70e2                	ld	ra,56(sp)
    800008ac:	7442                	ld	s0,48(sp)
    800008ae:	74a2                	ld	s1,40(sp)
    800008b0:	7902                	ld	s2,32(sp)
    800008b2:	69e2                	ld	s3,24(sp)
    800008b4:	6a42                	ld	s4,16(sp)
    800008b6:	6aa2                	ld	s5,8(sp)
    800008b8:	6121                	addi	sp,sp,64
    800008ba:	8082                	ret
    800008bc:	8082                	ret

00000000800008be <uartputc>:
{
    800008be:	7179                	addi	sp,sp,-48
    800008c0:	f406                	sd	ra,40(sp)
    800008c2:	f022                	sd	s0,32(sp)
    800008c4:	ec26                	sd	s1,24(sp)
    800008c6:	e84a                	sd	s2,16(sp)
    800008c8:	e44e                	sd	s3,8(sp)
    800008ca:	e052                	sd	s4,0(sp)
    800008cc:	1800                	addi	s0,sp,48
    800008ce:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008d0:	00010517          	auipc	a0,0x10
    800008d4:	26850513          	addi	a0,a0,616 # 80010b38 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	348080e7          	jalr	840(ra) # 80000c20 <acquire>
  if(panicked){
    800008e0:	00008797          	auipc	a5,0x8
    800008e4:	0107a783          	lw	a5,16(a5) # 800088f0 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00008717          	auipc	a4,0x8
    800008ee:	01673703          	ld	a4,22(a4) # 80008900 <uart_tx_w>
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	0067b783          	ld	a5,6(a5) # 800088f8 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00010997          	auipc	s3,0x10
    80000902:	23a98993          	addi	s3,s3,570 # 80010b38 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	ff248493          	addi	s1,s1,-14 # 800088f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	ff290913          	addi	s2,s2,-14 # 80008900 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00002097          	auipc	ra,0x2
    80000922:	864080e7          	jalr	-1948(ra) # 80002182 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00010497          	auipc	s1,0x10
    80000938:	20448493          	addi	s1,s1,516 # 80010b38 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	fae7bc23          	sd	a4,-72(a5) # 80008900 <uart_tx_w>
  uartstart();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee8080e7          	jalr	-280(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	37a080e7          	jalr	890(ra) # 80000cd4 <release>
}
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret
    for(;;)
    80000972:	a001                	j	80000972 <uartputc+0xb4>

0000000080000974 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000974:	1141                	addi	sp,sp,-16
    80000976:	e422                	sd	s0,8(sp)
    80000978:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000097a:	100007b7          	lui	a5,0x10000
    8000097e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000982:	8b85                	andi	a5,a5,1
    80000984:	cb81                	beqz	a5,80000994 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000986:	100007b7          	lui	a5,0x10000
    8000098a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret
    return -1;
    80000994:	557d                	li	a0,-1
    80000996:	bfe5                	j	8000098e <uartgetc+0x1a>

0000000080000998 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a2:	54fd                	li	s1,-1
    800009a4:	a029                	j	800009ae <uartintr+0x16>
      break;
    consoleintr(c);
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	918080e7          	jalr	-1768(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fc6080e7          	jalr	-58(ra) # 80000974 <uartgetc>
    if(c == -1)
    800009b6:	fe9518e3          	bne	a0,s1,800009a6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ba:	00010497          	auipc	s1,0x10
    800009be:	17e48493          	addi	s1,s1,382 # 80010b38 <uart_tx_lock>
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	25c080e7          	jalr	604(ra) # 80000c20 <acquire>
  uartstart();
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e6c080e7          	jalr	-404(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	2fe080e7          	jalr	766(ra) # 80000cd4 <release>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	e04a                	sd	s2,0(sp)
    800009f2:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f4:	03451793          	slli	a5,a0,0x34
    800009f8:	ebb9                	bnez	a5,80000a4e <kfree+0x66>
    800009fa:	84aa                	mv	s1,a0
    800009fc:	00021797          	auipc	a5,0x21
    80000a00:	3a478793          	addi	a5,a5,932 # 80021da0 <end>
    80000a04:	04f56563          	bltu	a0,a5,80000a4e <kfree+0x66>
    80000a08:	47c5                	li	a5,17
    80000a0a:	07ee                	slli	a5,a5,0x1b
    80000a0c:	04f57163          	bgeu	a0,a5,80000a4e <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a10:	6605                	lui	a2,0x1
    80000a12:	4585                	li	a1,1
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	308080e7          	jalr	776(ra) # 80000d1c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1c:	00010917          	auipc	s2,0x10
    80000a20:	15490913          	addi	s2,s2,340 # 80010b70 <kmem>
    80000a24:	854a                	mv	a0,s2
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	1fa080e7          	jalr	506(ra) # 80000c20 <acquire>
  r->next = kmem.freelist;
    80000a2e:	01893783          	ld	a5,24(s2)
    80000a32:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a34:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a38:	854a                	mv	a0,s2
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	29a080e7          	jalr	666(ra) # 80000cd4 <release>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6902                	ld	s2,0(sp)
    80000a4a:	6105                	addi	sp,sp,32
    80000a4c:	8082                	ret
    panic("kfree");
    80000a4e:	00007517          	auipc	a0,0x7
    80000a52:	61250513          	addi	a0,a0,1554 # 80008060 <digits+0x20>
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	aea080e7          	jalr	-1302(ra) # 80000540 <panic>

0000000080000a5e <freerange>:
{
    80000a5e:	7179                	addi	sp,sp,-48
    80000a60:	f406                	sd	ra,40(sp)
    80000a62:	f022                	sd	s0,32(sp)
    80000a64:	ec26                	sd	s1,24(sp)
    80000a66:	e84a                	sd	s2,16(sp)
    80000a68:	e44e                	sd	s3,8(sp)
    80000a6a:	e052                	sd	s4,0(sp)
    80000a6c:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a74:	00e504b3          	add	s1,a0,a4
    80000a78:	777d                	lui	a4,0xfffff
    80000a7a:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3c>
    80000a82:	892e                	mv	s2,a1
    kfree(p);
    80000a84:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	6985                	lui	s3,0x1
    kfree(p);
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5c080e7          	jalr	-164(ra) # 800009e8 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x2a>
}
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
{
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80008068 <digits+0x28>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	0b650513          	addi	a0,a0,182 # 80010b70 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	0ce080e7          	jalr	206(ra) # 80000b90 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00021517          	auipc	a0,0x21
    80000ad2:	2d250513          	addi	a0,a0,722 # 80021da0 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f88080e7          	jalr	-120(ra) # 80000a5e <freerange>
}
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	08048493          	addi	s1,s1,128 # 80010b70 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	126080e7          	jalr	294(ra) # 80000c20 <acquire>
  r = kmem.freelist;
    80000b02:	6c84                	ld	s1,24(s1)
  if(r)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	06850513          	addi	a0,a0,104 # 80010b70 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	1c2080e7          	jalr	450(ra) # 80000cd4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1fc080e7          	jalr	508(ra) # 80000d1c <memset>
  return (void*)r;
}
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
  release(&kmem.lock);
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	03c50513          	addi	a0,a0,60 # 80010b70 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	198080e7          	jalr	408(ra) # 80000cd4 <release>
  if(r)
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <freememcnt>:

uint64 freememcnt(void)
{
    80000b46:	1101                	addi	sp,sp,-32
    80000b48:	ec06                	sd	ra,24(sp)
    80000b4a:	e822                	sd	s0,16(sp)
    80000b4c:	e426                	sd	s1,8(sp)
    80000b4e:	1000                	addi	s0,sp,32
struct run* r;
uint64 freemem = 0;
acquire(&kmem.lock);
    80000b50:	00010497          	auipc	s1,0x10
    80000b54:	02048493          	addi	s1,s1,32 # 80010b70 <kmem>
    80000b58:	8526                	mv	a0,s1
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	0c6080e7          	jalr	198(ra) # 80000c20 <acquire>
r = kmem.freelist;
    80000b62:	6c9c                	ld	a5,24(s1)
while(r)
    80000b64:	c785                	beqz	a5,80000b8c <freememcnt+0x46>
uint64 freemem = 0;
    80000b66:	4481                	li	s1,0
{
 freemem++;
    80000b68:	0485                	addi	s1,s1,1
 r = r->next;
    80000b6a:	639c                	ld	a5,0(a5)
while(r)
    80000b6c:	fff5                	bnez	a5,80000b68 <freememcnt+0x22>
}
release(&kmem.lock);
    80000b6e:	00010517          	auipc	a0,0x10
    80000b72:	00250513          	addi	a0,a0,2 # 80010b70 <kmem>
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	15e080e7          	jalr	350(ra) # 80000cd4 <release>
return freemem*4096;
    80000b7e:	00c49513          	slli	a0,s1,0xc
    80000b82:	60e2                	ld	ra,24(sp)
    80000b84:	6442                	ld	s0,16(sp)
    80000b86:	64a2                	ld	s1,8(sp)
    80000b88:	6105                	addi	sp,sp,32
    80000b8a:	8082                	ret
uint64 freemem = 0;
    80000b8c:	4481                	li	s1,0
    80000b8e:	b7c5                	j	80000b6e <freememcnt+0x28>

0000000080000b90 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b90:	1141                	addi	sp,sp,-16
    80000b92:	e422                	sd	s0,8(sp)
    80000b94:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b96:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b98:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b9c:	00053823          	sd	zero,16(a0)
}
    80000ba0:	6422                	ld	s0,8(sp)
    80000ba2:	0141                	addi	sp,sp,16
    80000ba4:	8082                	ret

0000000080000ba6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000ba6:	411c                	lw	a5,0(a0)
    80000ba8:	e399                	bnez	a5,80000bae <holding+0x8>
    80000baa:	4501                	li	a0,0
  return r;
}
    80000bac:	8082                	ret
{
    80000bae:	1101                	addi	sp,sp,-32
    80000bb0:	ec06                	sd	ra,24(sp)
    80000bb2:	e822                	sd	s0,16(sp)
    80000bb4:	e426                	sd	s1,8(sp)
    80000bb6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	6904                	ld	s1,16(a0)
    80000bba:	00001097          	auipc	ra,0x1
    80000bbe:	f04080e7          	jalr	-252(ra) # 80001abe <mycpu>
    80000bc2:	40a48533          	sub	a0,s1,a0
    80000bc6:	00153513          	seqz	a0,a0
}
    80000bca:	60e2                	ld	ra,24(sp)
    80000bcc:	6442                	ld	s0,16(sp)
    80000bce:	64a2                	ld	s1,8(sp)
    80000bd0:	6105                	addi	sp,sp,32
    80000bd2:	8082                	ret

0000000080000bd4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bd4:	1101                	addi	sp,sp,-32
    80000bd6:	ec06                	sd	ra,24(sp)
    80000bd8:	e822                	sd	s0,16(sp)
    80000bda:	e426                	sd	s1,8(sp)
    80000bdc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bde:	100024f3          	csrr	s1,sstatus
    80000be2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000be6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000be8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bec:	00001097          	auipc	ra,0x1
    80000bf0:	ed2080e7          	jalr	-302(ra) # 80001abe <mycpu>
    80000bf4:	5d3c                	lw	a5,120(a0)
    80000bf6:	cf89                	beqz	a5,80000c10 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bf8:	00001097          	auipc	ra,0x1
    80000bfc:	ec6080e7          	jalr	-314(ra) # 80001abe <mycpu>
    80000c00:	5d3c                	lw	a5,120(a0)
    80000c02:	2785                	addiw	a5,a5,1
    80000c04:	dd3c                	sw	a5,120(a0)
}
    80000c06:	60e2                	ld	ra,24(sp)
    80000c08:	6442                	ld	s0,16(sp)
    80000c0a:	64a2                	ld	s1,8(sp)
    80000c0c:	6105                	addi	sp,sp,32
    80000c0e:	8082                	ret
    mycpu()->intena = old;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	eae080e7          	jalr	-338(ra) # 80001abe <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c18:	8085                	srli	s1,s1,0x1
    80000c1a:	8885                	andi	s1,s1,1
    80000c1c:	dd64                	sw	s1,124(a0)
    80000c1e:	bfe9                	j	80000bf8 <push_off+0x24>

0000000080000c20 <acquire>:
{
    80000c20:	1101                	addi	sp,sp,-32
    80000c22:	ec06                	sd	ra,24(sp)
    80000c24:	e822                	sd	s0,16(sp)
    80000c26:	e426                	sd	s1,8(sp)
    80000c28:	1000                	addi	s0,sp,32
    80000c2a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c2c:	00000097          	auipc	ra,0x0
    80000c30:	fa8080e7          	jalr	-88(ra) # 80000bd4 <push_off>
  if(holding(lk))
    80000c34:	8526                	mv	a0,s1
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	f70080e7          	jalr	-144(ra) # 80000ba6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	4705                	li	a4,1
  if(holding(lk))
    80000c40:	e115                	bnez	a0,80000c64 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c42:	87ba                	mv	a5,a4
    80000c44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c48:	2781                	sext.w	a5,a5
    80000c4a:	ffe5                	bnez	a5,80000c42 <acquire+0x22>
  __sync_synchronize();
    80000c4c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c50:	00001097          	auipc	ra,0x1
    80000c54:	e6e080e7          	jalr	-402(ra) # 80001abe <mycpu>
    80000c58:	e888                	sd	a0,16(s1)
}
    80000c5a:	60e2                	ld	ra,24(sp)
    80000c5c:	6442                	ld	s0,16(sp)
    80000c5e:	64a2                	ld	s1,8(sp)
    80000c60:	6105                	addi	sp,sp,32
    80000c62:	8082                	ret
    panic("acquire");
    80000c64:	00007517          	auipc	a0,0x7
    80000c68:	40c50513          	addi	a0,a0,1036 # 80008070 <digits+0x30>
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	8d4080e7          	jalr	-1836(ra) # 80000540 <panic>

0000000080000c74 <pop_off>:

void
pop_off(void)
{
    80000c74:	1141                	addi	sp,sp,-16
    80000c76:	e406                	sd	ra,8(sp)
    80000c78:	e022                	sd	s0,0(sp)
    80000c7a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c7c:	00001097          	auipc	ra,0x1
    80000c80:	e42080e7          	jalr	-446(ra) # 80001abe <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c84:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c88:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c8a:	e78d                	bnez	a5,80000cb4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c8c:	5d3c                	lw	a5,120(a0)
    80000c8e:	02f05b63          	blez	a5,80000cc4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c92:	37fd                	addiw	a5,a5,-1
    80000c94:	0007871b          	sext.w	a4,a5
    80000c98:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c9a:	eb09                	bnez	a4,80000cac <pop_off+0x38>
    80000c9c:	5d7c                	lw	a5,124(a0)
    80000c9e:	c799                	beqz	a5,80000cac <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ca0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ca4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ca8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cac:	60a2                	ld	ra,8(sp)
    80000cae:	6402                	ld	s0,0(sp)
    80000cb0:	0141                	addi	sp,sp,16
    80000cb2:	8082                	ret
    panic("pop_off - interruptible");
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	3c450513          	addi	a0,a0,964 # 80008078 <digits+0x38>
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	884080e7          	jalr	-1916(ra) # 80000540 <panic>
    panic("pop_off");
    80000cc4:	00007517          	auipc	a0,0x7
    80000cc8:	3cc50513          	addi	a0,a0,972 # 80008090 <digits+0x50>
    80000ccc:	00000097          	auipc	ra,0x0
    80000cd0:	874080e7          	jalr	-1932(ra) # 80000540 <panic>

0000000080000cd4 <release>:
{
    80000cd4:	1101                	addi	sp,sp,-32
    80000cd6:	ec06                	sd	ra,24(sp)
    80000cd8:	e822                	sd	s0,16(sp)
    80000cda:	e426                	sd	s1,8(sp)
    80000cdc:	1000                	addi	s0,sp,32
    80000cde:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	ec6080e7          	jalr	-314(ra) # 80000ba6 <holding>
    80000ce8:	c115                	beqz	a0,80000d0c <release+0x38>
  lk->cpu = 0;
    80000cea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cee:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cf2:	0f50000f          	fence	iorw,ow
    80000cf6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	f7a080e7          	jalr	-134(ra) # 80000c74 <pop_off>
}
    80000d02:	60e2                	ld	ra,24(sp)
    80000d04:	6442                	ld	s0,16(sp)
    80000d06:	64a2                	ld	s1,8(sp)
    80000d08:	6105                	addi	sp,sp,32
    80000d0a:	8082                	ret
    panic("release");
    80000d0c:	00007517          	auipc	a0,0x7
    80000d10:	38c50513          	addi	a0,a0,908 # 80008098 <digits+0x58>
    80000d14:	00000097          	auipc	ra,0x0
    80000d18:	82c080e7          	jalr	-2004(ra) # 80000540 <panic>

0000000080000d1c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d1c:	1141                	addi	sp,sp,-16
    80000d1e:	e422                	sd	s0,8(sp)
    80000d20:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d22:	ca19                	beqz	a2,80000d38 <memset+0x1c>
    80000d24:	87aa                	mv	a5,a0
    80000d26:	1602                	slli	a2,a2,0x20
    80000d28:	9201                	srli	a2,a2,0x20
    80000d2a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d2e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d32:	0785                	addi	a5,a5,1
    80000d34:	fee79de3          	bne	a5,a4,80000d2e <memset+0x12>
  }
  return dst;
}
    80000d38:	6422                	ld	s0,8(sp)
    80000d3a:	0141                	addi	sp,sp,16
    80000d3c:	8082                	ret

0000000080000d3e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d3e:	1141                	addi	sp,sp,-16
    80000d40:	e422                	sd	s0,8(sp)
    80000d42:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d44:	ca05                	beqz	a2,80000d74 <memcmp+0x36>
    80000d46:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d4a:	1682                	slli	a3,a3,0x20
    80000d4c:	9281                	srli	a3,a3,0x20
    80000d4e:	0685                	addi	a3,a3,1
    80000d50:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d52:	00054783          	lbu	a5,0(a0)
    80000d56:	0005c703          	lbu	a4,0(a1)
    80000d5a:	00e79863          	bne	a5,a4,80000d6a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d5e:	0505                	addi	a0,a0,1
    80000d60:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d62:	fed518e3          	bne	a0,a3,80000d52 <memcmp+0x14>
  }

  return 0;
    80000d66:	4501                	li	a0,0
    80000d68:	a019                	j	80000d6e <memcmp+0x30>
      return *s1 - *s2;
    80000d6a:	40e7853b          	subw	a0,a5,a4
}
    80000d6e:	6422                	ld	s0,8(sp)
    80000d70:	0141                	addi	sp,sp,16
    80000d72:	8082                	ret
  return 0;
    80000d74:	4501                	li	a0,0
    80000d76:	bfe5                	j	80000d6e <memcmp+0x30>

0000000080000d78 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d78:	1141                	addi	sp,sp,-16
    80000d7a:	e422                	sd	s0,8(sp)
    80000d7c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d7e:	c205                	beqz	a2,80000d9e <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d80:	02a5e263          	bltu	a1,a0,80000da4 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d84:	1602                	slli	a2,a2,0x20
    80000d86:	9201                	srli	a2,a2,0x20
    80000d88:	00c587b3          	add	a5,a1,a2
{
    80000d8c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d8e:	0585                	addi	a1,a1,1
    80000d90:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd261>
    80000d92:	fff5c683          	lbu	a3,-1(a1)
    80000d96:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d9a:	fef59ae3          	bne	a1,a5,80000d8e <memmove+0x16>

  return dst;
}
    80000d9e:	6422                	ld	s0,8(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret
  if(s < d && s + n > d){
    80000da4:	02061693          	slli	a3,a2,0x20
    80000da8:	9281                	srli	a3,a3,0x20
    80000daa:	00d58733          	add	a4,a1,a3
    80000dae:	fce57be3          	bgeu	a0,a4,80000d84 <memmove+0xc>
    d += n;
    80000db2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000db4:	fff6079b          	addiw	a5,a2,-1
    80000db8:	1782                	slli	a5,a5,0x20
    80000dba:	9381                	srli	a5,a5,0x20
    80000dbc:	fff7c793          	not	a5,a5
    80000dc0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dc2:	177d                	addi	a4,a4,-1
    80000dc4:	16fd                	addi	a3,a3,-1
    80000dc6:	00074603          	lbu	a2,0(a4)
    80000dca:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000dce:	fee79ae3          	bne	a5,a4,80000dc2 <memmove+0x4a>
    80000dd2:	b7f1                	j	80000d9e <memmove+0x26>

0000000080000dd4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dd4:	1141                	addi	sp,sp,-16
    80000dd6:	e406                	sd	ra,8(sp)
    80000dd8:	e022                	sd	s0,0(sp)
    80000dda:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ddc:	00000097          	auipc	ra,0x0
    80000de0:	f9c080e7          	jalr	-100(ra) # 80000d78 <memmove>
}
    80000de4:	60a2                	ld	ra,8(sp)
    80000de6:	6402                	ld	s0,0(sp)
    80000de8:	0141                	addi	sp,sp,16
    80000dea:	8082                	ret

0000000080000dec <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dec:	1141                	addi	sp,sp,-16
    80000dee:	e422                	sd	s0,8(sp)
    80000df0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000df2:	ce11                	beqz	a2,80000e0e <strncmp+0x22>
    80000df4:	00054783          	lbu	a5,0(a0)
    80000df8:	cf89                	beqz	a5,80000e12 <strncmp+0x26>
    80000dfa:	0005c703          	lbu	a4,0(a1)
    80000dfe:	00f71a63          	bne	a4,a5,80000e12 <strncmp+0x26>
    n--, p++, q++;
    80000e02:	367d                	addiw	a2,a2,-1
    80000e04:	0505                	addi	a0,a0,1
    80000e06:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e08:	f675                	bnez	a2,80000df4 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e0a:	4501                	li	a0,0
    80000e0c:	a809                	j	80000e1e <strncmp+0x32>
    80000e0e:	4501                	li	a0,0
    80000e10:	a039                	j	80000e1e <strncmp+0x32>
  if(n == 0)
    80000e12:	ca09                	beqz	a2,80000e24 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e14:	00054503          	lbu	a0,0(a0)
    80000e18:	0005c783          	lbu	a5,0(a1)
    80000e1c:	9d1d                	subw	a0,a0,a5
}
    80000e1e:	6422                	ld	s0,8(sp)
    80000e20:	0141                	addi	sp,sp,16
    80000e22:	8082                	ret
    return 0;
    80000e24:	4501                	li	a0,0
    80000e26:	bfe5                	j	80000e1e <strncmp+0x32>

0000000080000e28 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e2e:	872a                	mv	a4,a0
    80000e30:	8832                	mv	a6,a2
    80000e32:	367d                	addiw	a2,a2,-1
    80000e34:	01005963          	blez	a6,80000e46 <strncpy+0x1e>
    80000e38:	0705                	addi	a4,a4,1
    80000e3a:	0005c783          	lbu	a5,0(a1)
    80000e3e:	fef70fa3          	sb	a5,-1(a4)
    80000e42:	0585                	addi	a1,a1,1
    80000e44:	f7f5                	bnez	a5,80000e30 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e46:	86ba                	mv	a3,a4
    80000e48:	00c05c63          	blez	a2,80000e60 <strncpy+0x38>
    *s++ = 0;
    80000e4c:	0685                	addi	a3,a3,1
    80000e4e:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e52:	40d707bb          	subw	a5,a4,a3
    80000e56:	37fd                	addiw	a5,a5,-1
    80000e58:	010787bb          	addw	a5,a5,a6
    80000e5c:	fef048e3          	bgtz	a5,80000e4c <strncpy+0x24>
  return os;
}
    80000e60:	6422                	ld	s0,8(sp)
    80000e62:	0141                	addi	sp,sp,16
    80000e64:	8082                	ret

0000000080000e66 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e6c:	02c05363          	blez	a2,80000e92 <safestrcpy+0x2c>
    80000e70:	fff6069b          	addiw	a3,a2,-1
    80000e74:	1682                	slli	a3,a3,0x20
    80000e76:	9281                	srli	a3,a3,0x20
    80000e78:	96ae                	add	a3,a3,a1
    80000e7a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e7c:	00d58963          	beq	a1,a3,80000e8e <safestrcpy+0x28>
    80000e80:	0585                	addi	a1,a1,1
    80000e82:	0785                	addi	a5,a5,1
    80000e84:	fff5c703          	lbu	a4,-1(a1)
    80000e88:	fee78fa3          	sb	a4,-1(a5)
    80000e8c:	fb65                	bnez	a4,80000e7c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e8e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e92:	6422                	ld	s0,8(sp)
    80000e94:	0141                	addi	sp,sp,16
    80000e96:	8082                	ret

0000000080000e98 <strlen>:

int
strlen(const char *s)
{
    80000e98:	1141                	addi	sp,sp,-16
    80000e9a:	e422                	sd	s0,8(sp)
    80000e9c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e9e:	00054783          	lbu	a5,0(a0)
    80000ea2:	cf91                	beqz	a5,80000ebe <strlen+0x26>
    80000ea4:	0505                	addi	a0,a0,1
    80000ea6:	87aa                	mv	a5,a0
    80000ea8:	4685                	li	a3,1
    80000eaa:	9e89                	subw	a3,a3,a0
    80000eac:	00f6853b          	addw	a0,a3,a5
    80000eb0:	0785                	addi	a5,a5,1
    80000eb2:	fff7c703          	lbu	a4,-1(a5)
    80000eb6:	fb7d                	bnez	a4,80000eac <strlen+0x14>
    ;
  return n;
}
    80000eb8:	6422                	ld	s0,8(sp)
    80000eba:	0141                	addi	sp,sp,16
    80000ebc:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ebe:	4501                	li	a0,0
    80000ec0:	bfe5                	j	80000eb8 <strlen+0x20>

0000000080000ec2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ec2:	1141                	addi	sp,sp,-16
    80000ec4:	e406                	sd	ra,8(sp)
    80000ec6:	e022                	sd	s0,0(sp)
    80000ec8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eca:	00001097          	auipc	ra,0x1
    80000ece:	be4080e7          	jalr	-1052(ra) # 80001aae <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ed2:	00008717          	auipc	a4,0x8
    80000ed6:	a3670713          	addi	a4,a4,-1482 # 80008908 <started>
  if(cpuid() == 0){
    80000eda:	c139                	beqz	a0,80000f20 <main+0x5e>
    while(started == 0)
    80000edc:	431c                	lw	a5,0(a4)
    80000ede:	2781                	sext.w	a5,a5
    80000ee0:	dff5                	beqz	a5,80000edc <main+0x1a>
      ;
    __sync_synchronize();
    80000ee2:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ee6:	00001097          	auipc	ra,0x1
    80000eea:	bc8080e7          	jalr	-1080(ra) # 80001aae <cpuid>
    80000eee:	85aa                	mv	a1,a0
    80000ef0:	00007517          	auipc	a0,0x7
    80000ef4:	1c850513          	addi	a0,a0,456 # 800080b8 <digits+0x78>
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	692080e7          	jalr	1682(ra) # 8000058a <printf>
    kvminithart();    // turn on paging
    80000f00:	00000097          	auipc	ra,0x0
    80000f04:	0d8080e7          	jalr	216(ra) # 80000fd8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f08:	00002097          	auipc	ra,0x2
    80000f0c:	8a0080e7          	jalr	-1888(ra) # 800027a8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	0f0080e7          	jalr	240(ra) # 80006000 <plicinithart>
  }

  scheduler();        
    80000f18:	00001097          	auipc	ra,0x1
    80000f1c:	0b8080e7          	jalr	184(ra) # 80001fd0 <scheduler>
    consoleinit();
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	530080e7          	jalr	1328(ra) # 80000450 <consoleinit>
    printfinit();
    80000f28:	00000097          	auipc	ra,0x0
    80000f2c:	842080e7          	jalr	-1982(ra) # 8000076a <printfinit>
    printf("\n");
    80000f30:	00007517          	auipc	a0,0x7
    80000f34:	19850513          	addi	a0,a0,408 # 800080c8 <digits+0x88>
    80000f38:	fffff097          	auipc	ra,0xfffff
    80000f3c:	652080e7          	jalr	1618(ra) # 8000058a <printf>
    printf("xv6 kernel is booting\n");
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	16050513          	addi	a0,a0,352 # 800080a0 <digits+0x60>
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	642080e7          	jalr	1602(ra) # 8000058a <printf>
    printf("\n");
    80000f50:	00007517          	auipc	a0,0x7
    80000f54:	17850513          	addi	a0,a0,376 # 800080c8 <digits+0x88>
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	632080e7          	jalr	1586(ra) # 8000058a <printf>
    kinit();         // physical page allocator
    80000f60:	00000097          	auipc	ra,0x0
    80000f64:	b4a080e7          	jalr	-1206(ra) # 80000aaa <kinit>
    kvminit();       // create kernel page table
    80000f68:	00000097          	auipc	ra,0x0
    80000f6c:	326080e7          	jalr	806(ra) # 8000128e <kvminit>
    kvminithart();   // turn on paging
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	068080e7          	jalr	104(ra) # 80000fd8 <kvminithart>
    procinit();      // process table
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	a82080e7          	jalr	-1406(ra) # 800019fa <procinit>
    trapinit();      // trap vectors
    80000f80:	00002097          	auipc	ra,0x2
    80000f84:	800080e7          	jalr	-2048(ra) # 80002780 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f88:	00002097          	auipc	ra,0x2
    80000f8c:	820080e7          	jalr	-2016(ra) # 800027a8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f90:	00005097          	auipc	ra,0x5
    80000f94:	05a080e7          	jalr	90(ra) # 80005fea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f98:	00005097          	auipc	ra,0x5
    80000f9c:	068080e7          	jalr	104(ra) # 80006000 <plicinithart>
    binit();         // buffer cache
    80000fa0:	00002097          	auipc	ra,0x2
    80000fa4:	082080e7          	jalr	130(ra) # 80003022 <binit>
    iinit();         // inode table
    80000fa8:	00002097          	auipc	ra,0x2
    80000fac:	7dc080e7          	jalr	2012(ra) # 80003784 <iinit>
    fileinit();      // file table
    80000fb0:	00004097          	auipc	ra,0x4
    80000fb4:	82e080e7          	jalr	-2002(ra) # 800047de <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fb8:	00005097          	auipc	ra,0x5
    80000fbc:	150080e7          	jalr	336(ra) # 80006108 <virtio_disk_init>
    userinit();      // first user process
    80000fc0:	00001097          	auipc	ra,0x1
    80000fc4:	df2080e7          	jalr	-526(ra) # 80001db2 <userinit>
    __sync_synchronize();
    80000fc8:	0ff0000f          	fence
    started = 1;
    80000fcc:	4785                	li	a5,1
    80000fce:	00008717          	auipc	a4,0x8
    80000fd2:	92f72d23          	sw	a5,-1734(a4) # 80008908 <started>
    80000fd6:	b789                	j	80000f18 <main+0x56>

0000000080000fd8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fd8:	1141                	addi	sp,sp,-16
    80000fda:	e422                	sd	s0,8(sp)
    80000fdc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fde:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000fe2:	00008797          	auipc	a5,0x8
    80000fe6:	9367b783          	ld	a5,-1738(a5) # 80008918 <kernel_pagetable>
    80000fea:	83b1                	srli	a5,a5,0xc
    80000fec:	577d                	li	a4,-1
    80000fee:	177e                	slli	a4,a4,0x3f
    80000ff0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000ff2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ff6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ffa:	6422                	ld	s0,8(sp)
    80000ffc:	0141                	addi	sp,sp,16
    80000ffe:	8082                	ret

0000000080001000 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001000:	7139                	addi	sp,sp,-64
    80001002:	fc06                	sd	ra,56(sp)
    80001004:	f822                	sd	s0,48(sp)
    80001006:	f426                	sd	s1,40(sp)
    80001008:	f04a                	sd	s2,32(sp)
    8000100a:	ec4e                	sd	s3,24(sp)
    8000100c:	e852                	sd	s4,16(sp)
    8000100e:	e456                	sd	s5,8(sp)
    80001010:	e05a                	sd	s6,0(sp)
    80001012:	0080                	addi	s0,sp,64
    80001014:	84aa                	mv	s1,a0
    80001016:	89ae                	mv	s3,a1
    80001018:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000101a:	57fd                	li	a5,-1
    8000101c:	83e9                	srli	a5,a5,0x1a
    8000101e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001020:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001022:	04b7f263          	bgeu	a5,a1,80001066 <walk+0x66>
    panic("walk");
    80001026:	00007517          	auipc	a0,0x7
    8000102a:	0aa50513          	addi	a0,a0,170 # 800080d0 <digits+0x90>
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	512080e7          	jalr	1298(ra) # 80000540 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001036:	060a8663          	beqz	s5,800010a2 <walk+0xa2>
    8000103a:	00000097          	auipc	ra,0x0
    8000103e:	aac080e7          	jalr	-1364(ra) # 80000ae6 <kalloc>
    80001042:	84aa                	mv	s1,a0
    80001044:	c529                	beqz	a0,8000108e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001046:	6605                	lui	a2,0x1
    80001048:	4581                	li	a1,0
    8000104a:	00000097          	auipc	ra,0x0
    8000104e:	cd2080e7          	jalr	-814(ra) # 80000d1c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001052:	00c4d793          	srli	a5,s1,0xc
    80001056:	07aa                	slli	a5,a5,0xa
    80001058:	0017e793          	ori	a5,a5,1
    8000105c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001060:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd257>
    80001062:	036a0063          	beq	s4,s6,80001082 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001066:	0149d933          	srl	s2,s3,s4
    8000106a:	1ff97913          	andi	s2,s2,511
    8000106e:	090e                	slli	s2,s2,0x3
    80001070:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001072:	00093483          	ld	s1,0(s2)
    80001076:	0014f793          	andi	a5,s1,1
    8000107a:	dfd5                	beqz	a5,80001036 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000107c:	80a9                	srli	s1,s1,0xa
    8000107e:	04b2                	slli	s1,s1,0xc
    80001080:	b7c5                	j	80001060 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001082:	00c9d513          	srli	a0,s3,0xc
    80001086:	1ff57513          	andi	a0,a0,511
    8000108a:	050e                	slli	a0,a0,0x3
    8000108c:	9526                	add	a0,a0,s1
}
    8000108e:	70e2                	ld	ra,56(sp)
    80001090:	7442                	ld	s0,48(sp)
    80001092:	74a2                	ld	s1,40(sp)
    80001094:	7902                	ld	s2,32(sp)
    80001096:	69e2                	ld	s3,24(sp)
    80001098:	6a42                	ld	s4,16(sp)
    8000109a:	6aa2                	ld	s5,8(sp)
    8000109c:	6b02                	ld	s6,0(sp)
    8000109e:	6121                	addi	sp,sp,64
    800010a0:	8082                	ret
        return 0;
    800010a2:	4501                	li	a0,0
    800010a4:	b7ed                	j	8000108e <walk+0x8e>

00000000800010a6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010a6:	57fd                	li	a5,-1
    800010a8:	83e9                	srli	a5,a5,0x1a
    800010aa:	00b7f463          	bgeu	a5,a1,800010b2 <walkaddr+0xc>
    return 0;
    800010ae:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010b0:	8082                	ret
{
    800010b2:	1141                	addi	sp,sp,-16
    800010b4:	e406                	sd	ra,8(sp)
    800010b6:	e022                	sd	s0,0(sp)
    800010b8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ba:	4601                	li	a2,0
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	f44080e7          	jalr	-188(ra) # 80001000 <walk>
  if(pte == 0)
    800010c4:	c105                	beqz	a0,800010e4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010c6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010c8:	0117f693          	andi	a3,a5,17
    800010cc:	4745                	li	a4,17
    return 0;
    800010ce:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010d0:	00e68663          	beq	a3,a4,800010dc <walkaddr+0x36>
}
    800010d4:	60a2                	ld	ra,8(sp)
    800010d6:	6402                	ld	s0,0(sp)
    800010d8:	0141                	addi	sp,sp,16
    800010da:	8082                	ret
  pa = PTE2PA(*pte);
    800010dc:	83a9                	srli	a5,a5,0xa
    800010de:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010e2:	bfcd                	j	800010d4 <walkaddr+0x2e>
    return 0;
    800010e4:	4501                	li	a0,0
    800010e6:	b7fd                	j	800010d4 <walkaddr+0x2e>

00000000800010e8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010e8:	715d                	addi	sp,sp,-80
    800010ea:	e486                	sd	ra,72(sp)
    800010ec:	e0a2                	sd	s0,64(sp)
    800010ee:	fc26                	sd	s1,56(sp)
    800010f0:	f84a                	sd	s2,48(sp)
    800010f2:	f44e                	sd	s3,40(sp)
    800010f4:	f052                	sd	s4,32(sp)
    800010f6:	ec56                	sd	s5,24(sp)
    800010f8:	e85a                	sd	s6,16(sp)
    800010fa:	e45e                	sd	s7,8(sp)
    800010fc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010fe:	c639                	beqz	a2,8000114c <mappages+0x64>
    80001100:	8aaa                	mv	s5,a0
    80001102:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001104:	777d                	lui	a4,0xfffff
    80001106:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000110a:	fff58993          	addi	s3,a1,-1
    8000110e:	99b2                	add	s3,s3,a2
    80001110:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001114:	893e                	mv	s2,a5
    80001116:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000111a:	6b85                	lui	s7,0x1
    8000111c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001120:	4605                	li	a2,1
    80001122:	85ca                	mv	a1,s2
    80001124:	8556                	mv	a0,s5
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	eda080e7          	jalr	-294(ra) # 80001000 <walk>
    8000112e:	cd1d                	beqz	a0,8000116c <mappages+0x84>
    if(*pte & PTE_V)
    80001130:	611c                	ld	a5,0(a0)
    80001132:	8b85                	andi	a5,a5,1
    80001134:	e785                	bnez	a5,8000115c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001136:	80b1                	srli	s1,s1,0xc
    80001138:	04aa                	slli	s1,s1,0xa
    8000113a:	0164e4b3          	or	s1,s1,s6
    8000113e:	0014e493          	ori	s1,s1,1
    80001142:	e104                	sd	s1,0(a0)
    if(a == last)
    80001144:	05390063          	beq	s2,s3,80001184 <mappages+0x9c>
    a += PGSIZE;
    80001148:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000114a:	bfc9                	j	8000111c <mappages+0x34>
    panic("mappages: size");
    8000114c:	00007517          	auipc	a0,0x7
    80001150:	f8c50513          	addi	a0,a0,-116 # 800080d8 <digits+0x98>
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	3ec080e7          	jalr	1004(ra) # 80000540 <panic>
      panic("mappages: remap");
    8000115c:	00007517          	auipc	a0,0x7
    80001160:	f8c50513          	addi	a0,a0,-116 # 800080e8 <digits+0xa8>
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	3dc080e7          	jalr	988(ra) # 80000540 <panic>
      return -1;
    8000116c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000116e:	60a6                	ld	ra,72(sp)
    80001170:	6406                	ld	s0,64(sp)
    80001172:	74e2                	ld	s1,56(sp)
    80001174:	7942                	ld	s2,48(sp)
    80001176:	79a2                	ld	s3,40(sp)
    80001178:	7a02                	ld	s4,32(sp)
    8000117a:	6ae2                	ld	s5,24(sp)
    8000117c:	6b42                	ld	s6,16(sp)
    8000117e:	6ba2                	ld	s7,8(sp)
    80001180:	6161                	addi	sp,sp,80
    80001182:	8082                	ret
  return 0;
    80001184:	4501                	li	a0,0
    80001186:	b7e5                	j	8000116e <mappages+0x86>

0000000080001188 <kvmmap>:
{
    80001188:	1141                	addi	sp,sp,-16
    8000118a:	e406                	sd	ra,8(sp)
    8000118c:	e022                	sd	s0,0(sp)
    8000118e:	0800                	addi	s0,sp,16
    80001190:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001192:	86b2                	mv	a3,a2
    80001194:	863e                	mv	a2,a5
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	f52080e7          	jalr	-174(ra) # 800010e8 <mappages>
    8000119e:	e509                	bnez	a0,800011a8 <kvmmap+0x20>
}
    800011a0:	60a2                	ld	ra,8(sp)
    800011a2:	6402                	ld	s0,0(sp)
    800011a4:	0141                	addi	sp,sp,16
    800011a6:	8082                	ret
    panic("kvmmap");
    800011a8:	00007517          	auipc	a0,0x7
    800011ac:	f5050513          	addi	a0,a0,-176 # 800080f8 <digits+0xb8>
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	390080e7          	jalr	912(ra) # 80000540 <panic>

00000000800011b8 <kvmmake>:
{
    800011b8:	1101                	addi	sp,sp,-32
    800011ba:	ec06                	sd	ra,24(sp)
    800011bc:	e822                	sd	s0,16(sp)
    800011be:	e426                	sd	s1,8(sp)
    800011c0:	e04a                	sd	s2,0(sp)
    800011c2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	922080e7          	jalr	-1758(ra) # 80000ae6 <kalloc>
    800011cc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011ce:	6605                	lui	a2,0x1
    800011d0:	4581                	li	a1,0
    800011d2:	00000097          	auipc	ra,0x0
    800011d6:	b4a080e7          	jalr	-1206(ra) # 80000d1c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011da:	4719                	li	a4,6
    800011dc:	6685                	lui	a3,0x1
    800011de:	10000637          	lui	a2,0x10000
    800011e2:	100005b7          	lui	a1,0x10000
    800011e6:	8526                	mv	a0,s1
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	fa0080e7          	jalr	-96(ra) # 80001188 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011f0:	4719                	li	a4,6
    800011f2:	6685                	lui	a3,0x1
    800011f4:	10001637          	lui	a2,0x10001
    800011f8:	100015b7          	lui	a1,0x10001
    800011fc:	8526                	mv	a0,s1
    800011fe:	00000097          	auipc	ra,0x0
    80001202:	f8a080e7          	jalr	-118(ra) # 80001188 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001206:	4719                	li	a4,6
    80001208:	004006b7          	lui	a3,0x400
    8000120c:	0c000637          	lui	a2,0xc000
    80001210:	0c0005b7          	lui	a1,0xc000
    80001214:	8526                	mv	a0,s1
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	f72080e7          	jalr	-142(ra) # 80001188 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000121e:	00007917          	auipc	s2,0x7
    80001222:	de290913          	addi	s2,s2,-542 # 80008000 <etext>
    80001226:	4729                	li	a4,10
    80001228:	80007697          	auipc	a3,0x80007
    8000122c:	dd868693          	addi	a3,a3,-552 # 8000 <_entry-0x7fff8000>
    80001230:	4605                	li	a2,1
    80001232:	067e                	slli	a2,a2,0x1f
    80001234:	85b2                	mv	a1,a2
    80001236:	8526                	mv	a0,s1
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	f50080e7          	jalr	-176(ra) # 80001188 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001240:	4719                	li	a4,6
    80001242:	46c5                	li	a3,17
    80001244:	06ee                	slli	a3,a3,0x1b
    80001246:	412686b3          	sub	a3,a3,s2
    8000124a:	864a                	mv	a2,s2
    8000124c:	85ca                	mv	a1,s2
    8000124e:	8526                	mv	a0,s1
    80001250:	00000097          	auipc	ra,0x0
    80001254:	f38080e7          	jalr	-200(ra) # 80001188 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001258:	4729                	li	a4,10
    8000125a:	6685                	lui	a3,0x1
    8000125c:	00006617          	auipc	a2,0x6
    80001260:	da460613          	addi	a2,a2,-604 # 80007000 <_trampoline>
    80001264:	040005b7          	lui	a1,0x4000
    80001268:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000126a:	05b2                	slli	a1,a1,0xc
    8000126c:	8526                	mv	a0,s1
    8000126e:	00000097          	auipc	ra,0x0
    80001272:	f1a080e7          	jalr	-230(ra) # 80001188 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001276:	8526                	mv	a0,s1
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	6ec080e7          	jalr	1772(ra) # 80001964 <proc_mapstacks>
}
    80001280:	8526                	mv	a0,s1
    80001282:	60e2                	ld	ra,24(sp)
    80001284:	6442                	ld	s0,16(sp)
    80001286:	64a2                	ld	s1,8(sp)
    80001288:	6902                	ld	s2,0(sp)
    8000128a:	6105                	addi	sp,sp,32
    8000128c:	8082                	ret

000000008000128e <kvminit>:
{
    8000128e:	1141                	addi	sp,sp,-16
    80001290:	e406                	sd	ra,8(sp)
    80001292:	e022                	sd	s0,0(sp)
    80001294:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	f22080e7          	jalr	-222(ra) # 800011b8 <kvmmake>
    8000129e:	00007797          	auipc	a5,0x7
    800012a2:	66a7bd23          	sd	a0,1658(a5) # 80008918 <kernel_pagetable>
}
    800012a6:	60a2                	ld	ra,8(sp)
    800012a8:	6402                	ld	s0,0(sp)
    800012aa:	0141                	addi	sp,sp,16
    800012ac:	8082                	ret

00000000800012ae <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012ae:	715d                	addi	sp,sp,-80
    800012b0:	e486                	sd	ra,72(sp)
    800012b2:	e0a2                	sd	s0,64(sp)
    800012b4:	fc26                	sd	s1,56(sp)
    800012b6:	f84a                	sd	s2,48(sp)
    800012b8:	f44e                	sd	s3,40(sp)
    800012ba:	f052                	sd	s4,32(sp)
    800012bc:	ec56                	sd	s5,24(sp)
    800012be:	e85a                	sd	s6,16(sp)
    800012c0:	e45e                	sd	s7,8(sp)
    800012c2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c4:	03459793          	slli	a5,a1,0x34
    800012c8:	e795                	bnez	a5,800012f4 <uvmunmap+0x46>
    800012ca:	8a2a                	mv	s4,a0
    800012cc:	892e                	mv	s2,a1
    800012ce:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012d0:	0632                	slli	a2,a2,0xc
    800012d2:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012d6:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012d8:	6b05                	lui	s6,0x1
    800012da:	0735e263          	bltu	a1,s3,8000133e <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012de:	60a6                	ld	ra,72(sp)
    800012e0:	6406                	ld	s0,64(sp)
    800012e2:	74e2                	ld	s1,56(sp)
    800012e4:	7942                	ld	s2,48(sp)
    800012e6:	79a2                	ld	s3,40(sp)
    800012e8:	7a02                	ld	s4,32(sp)
    800012ea:	6ae2                	ld	s5,24(sp)
    800012ec:	6b42                	ld	s6,16(sp)
    800012ee:	6ba2                	ld	s7,8(sp)
    800012f0:	6161                	addi	sp,sp,80
    800012f2:	8082                	ret
    panic("uvmunmap: not aligned");
    800012f4:	00007517          	auipc	a0,0x7
    800012f8:	e0c50513          	addi	a0,a0,-500 # 80008100 <digits+0xc0>
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	244080e7          	jalr	580(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    80001304:	00007517          	auipc	a0,0x7
    80001308:	e1450513          	addi	a0,a0,-492 # 80008118 <digits+0xd8>
    8000130c:	fffff097          	auipc	ra,0xfffff
    80001310:	234080e7          	jalr	564(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    80001314:	00007517          	auipc	a0,0x7
    80001318:	e1450513          	addi	a0,a0,-492 # 80008128 <digits+0xe8>
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	224080e7          	jalr	548(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    80001324:	00007517          	auipc	a0,0x7
    80001328:	e1c50513          	addi	a0,a0,-484 # 80008140 <digits+0x100>
    8000132c:	fffff097          	auipc	ra,0xfffff
    80001330:	214080e7          	jalr	532(ra) # 80000540 <panic>
    *pte = 0;
    80001334:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001338:	995a                	add	s2,s2,s6
    8000133a:	fb3972e3          	bgeu	s2,s3,800012de <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000133e:	4601                	li	a2,0
    80001340:	85ca                	mv	a1,s2
    80001342:	8552                	mv	a0,s4
    80001344:	00000097          	auipc	ra,0x0
    80001348:	cbc080e7          	jalr	-836(ra) # 80001000 <walk>
    8000134c:	84aa                	mv	s1,a0
    8000134e:	d95d                	beqz	a0,80001304 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001350:	6108                	ld	a0,0(a0)
    80001352:	00157793          	andi	a5,a0,1
    80001356:	dfdd                	beqz	a5,80001314 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001358:	3ff57793          	andi	a5,a0,1023
    8000135c:	fd7784e3          	beq	a5,s7,80001324 <uvmunmap+0x76>
    if(do_free){
    80001360:	fc0a8ae3          	beqz	s5,80001334 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001364:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001366:	0532                	slli	a0,a0,0xc
    80001368:	fffff097          	auipc	ra,0xfffff
    8000136c:	680080e7          	jalr	1664(ra) # 800009e8 <kfree>
    80001370:	b7d1                	j	80001334 <uvmunmap+0x86>

0000000080001372 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001372:	1101                	addi	sp,sp,-32
    80001374:	ec06                	sd	ra,24(sp)
    80001376:	e822                	sd	s0,16(sp)
    80001378:	e426                	sd	s1,8(sp)
    8000137a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000137c:	fffff097          	auipc	ra,0xfffff
    80001380:	76a080e7          	jalr	1898(ra) # 80000ae6 <kalloc>
    80001384:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001386:	c519                	beqz	a0,80001394 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001388:	6605                	lui	a2,0x1
    8000138a:	4581                	li	a1,0
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	990080e7          	jalr	-1648(ra) # 80000d1c <memset>
  return pagetable;
}
    80001394:	8526                	mv	a0,s1
    80001396:	60e2                	ld	ra,24(sp)
    80001398:	6442                	ld	s0,16(sp)
    8000139a:	64a2                	ld	s1,8(sp)
    8000139c:	6105                	addi	sp,sp,32
    8000139e:	8082                	ret

00000000800013a0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013a0:	7179                	addi	sp,sp,-48
    800013a2:	f406                	sd	ra,40(sp)
    800013a4:	f022                	sd	s0,32(sp)
    800013a6:	ec26                	sd	s1,24(sp)
    800013a8:	e84a                	sd	s2,16(sp)
    800013aa:	e44e                	sd	s3,8(sp)
    800013ac:	e052                	sd	s4,0(sp)
    800013ae:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013b0:	6785                	lui	a5,0x1
    800013b2:	04f67863          	bgeu	a2,a5,80001402 <uvmfirst+0x62>
    800013b6:	8a2a                	mv	s4,a0
    800013b8:	89ae                	mv	s3,a1
    800013ba:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	72a080e7          	jalr	1834(ra) # 80000ae6 <kalloc>
    800013c4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013c6:	6605                	lui	a2,0x1
    800013c8:	4581                	li	a1,0
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	952080e7          	jalr	-1710(ra) # 80000d1c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013d2:	4779                	li	a4,30
    800013d4:	86ca                	mv	a3,s2
    800013d6:	6605                	lui	a2,0x1
    800013d8:	4581                	li	a1,0
    800013da:	8552                	mv	a0,s4
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	d0c080e7          	jalr	-756(ra) # 800010e8 <mappages>
  memmove(mem, src, sz);
    800013e4:	8626                	mv	a2,s1
    800013e6:	85ce                	mv	a1,s3
    800013e8:	854a                	mv	a0,s2
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	98e080e7          	jalr	-1650(ra) # 80000d78 <memmove>
}
    800013f2:	70a2                	ld	ra,40(sp)
    800013f4:	7402                	ld	s0,32(sp)
    800013f6:	64e2                	ld	s1,24(sp)
    800013f8:	6942                	ld	s2,16(sp)
    800013fa:	69a2                	ld	s3,8(sp)
    800013fc:	6a02                	ld	s4,0(sp)
    800013fe:	6145                	addi	sp,sp,48
    80001400:	8082                	ret
    panic("uvmfirst: more than a page");
    80001402:	00007517          	auipc	a0,0x7
    80001406:	d5650513          	addi	a0,a0,-682 # 80008158 <digits+0x118>
    8000140a:	fffff097          	auipc	ra,0xfffff
    8000140e:	136080e7          	jalr	310(ra) # 80000540 <panic>

0000000080001412 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001412:	1101                	addi	sp,sp,-32
    80001414:	ec06                	sd	ra,24(sp)
    80001416:	e822                	sd	s0,16(sp)
    80001418:	e426                	sd	s1,8(sp)
    8000141a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000141c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000141e:	00b67d63          	bgeu	a2,a1,80001438 <uvmdealloc+0x26>
    80001422:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001424:	6785                	lui	a5,0x1
    80001426:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001428:	00f60733          	add	a4,a2,a5
    8000142c:	76fd                	lui	a3,0xfffff
    8000142e:	8f75                	and	a4,a4,a3
    80001430:	97ae                	add	a5,a5,a1
    80001432:	8ff5                	and	a5,a5,a3
    80001434:	00f76863          	bltu	a4,a5,80001444 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001438:	8526                	mv	a0,s1
    8000143a:	60e2                	ld	ra,24(sp)
    8000143c:	6442                	ld	s0,16(sp)
    8000143e:	64a2                	ld	s1,8(sp)
    80001440:	6105                	addi	sp,sp,32
    80001442:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001444:	8f99                	sub	a5,a5,a4
    80001446:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001448:	4685                	li	a3,1
    8000144a:	0007861b          	sext.w	a2,a5
    8000144e:	85ba                	mv	a1,a4
    80001450:	00000097          	auipc	ra,0x0
    80001454:	e5e080e7          	jalr	-418(ra) # 800012ae <uvmunmap>
    80001458:	b7c5                	j	80001438 <uvmdealloc+0x26>

000000008000145a <uvmalloc>:
  if(newsz < oldsz)
    8000145a:	0ab66563          	bltu	a2,a1,80001504 <uvmalloc+0xaa>
{
    8000145e:	7139                	addi	sp,sp,-64
    80001460:	fc06                	sd	ra,56(sp)
    80001462:	f822                	sd	s0,48(sp)
    80001464:	f426                	sd	s1,40(sp)
    80001466:	f04a                	sd	s2,32(sp)
    80001468:	ec4e                	sd	s3,24(sp)
    8000146a:	e852                	sd	s4,16(sp)
    8000146c:	e456                	sd	s5,8(sp)
    8000146e:	e05a                	sd	s6,0(sp)
    80001470:	0080                	addi	s0,sp,64
    80001472:	8aaa                	mv	s5,a0
    80001474:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001476:	6785                	lui	a5,0x1
    80001478:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000147a:	95be                	add	a1,a1,a5
    8000147c:	77fd                	lui	a5,0xfffff
    8000147e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001482:	08c9f363          	bgeu	s3,a2,80001508 <uvmalloc+0xae>
    80001486:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001488:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000148c:	fffff097          	auipc	ra,0xfffff
    80001490:	65a080e7          	jalr	1626(ra) # 80000ae6 <kalloc>
    80001494:	84aa                	mv	s1,a0
    if(mem == 0){
    80001496:	c51d                	beqz	a0,800014c4 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001498:	6605                	lui	a2,0x1
    8000149a:	4581                	li	a1,0
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	880080e7          	jalr	-1920(ra) # 80000d1c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014a4:	875a                	mv	a4,s6
    800014a6:	86a6                	mv	a3,s1
    800014a8:	6605                	lui	a2,0x1
    800014aa:	85ca                	mv	a1,s2
    800014ac:	8556                	mv	a0,s5
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	c3a080e7          	jalr	-966(ra) # 800010e8 <mappages>
    800014b6:	e90d                	bnez	a0,800014e8 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014b8:	6785                	lui	a5,0x1
    800014ba:	993e                	add	s2,s2,a5
    800014bc:	fd4968e3          	bltu	s2,s4,8000148c <uvmalloc+0x32>
  return newsz;
    800014c0:	8552                	mv	a0,s4
    800014c2:	a809                	j	800014d4 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    800014c4:	864e                	mv	a2,s3
    800014c6:	85ca                	mv	a1,s2
    800014c8:	8556                	mv	a0,s5
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	f48080e7          	jalr	-184(ra) # 80001412 <uvmdealloc>
      return 0;
    800014d2:	4501                	li	a0,0
}
    800014d4:	70e2                	ld	ra,56(sp)
    800014d6:	7442                	ld	s0,48(sp)
    800014d8:	74a2                	ld	s1,40(sp)
    800014da:	7902                	ld	s2,32(sp)
    800014dc:	69e2                	ld	s3,24(sp)
    800014de:	6a42                	ld	s4,16(sp)
    800014e0:	6aa2                	ld	s5,8(sp)
    800014e2:	6b02                	ld	s6,0(sp)
    800014e4:	6121                	addi	sp,sp,64
    800014e6:	8082                	ret
      kfree(mem);
    800014e8:	8526                	mv	a0,s1
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	4fe080e7          	jalr	1278(ra) # 800009e8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014f2:	864e                	mv	a2,s3
    800014f4:	85ca                	mv	a1,s2
    800014f6:	8556                	mv	a0,s5
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	f1a080e7          	jalr	-230(ra) # 80001412 <uvmdealloc>
      return 0;
    80001500:	4501                	li	a0,0
    80001502:	bfc9                	j	800014d4 <uvmalloc+0x7a>
    return oldsz;
    80001504:	852e                	mv	a0,a1
}
    80001506:	8082                	ret
  return newsz;
    80001508:	8532                	mv	a0,a2
    8000150a:	b7e9                	j	800014d4 <uvmalloc+0x7a>

000000008000150c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000150c:	7179                	addi	sp,sp,-48
    8000150e:	f406                	sd	ra,40(sp)
    80001510:	f022                	sd	s0,32(sp)
    80001512:	ec26                	sd	s1,24(sp)
    80001514:	e84a                	sd	s2,16(sp)
    80001516:	e44e                	sd	s3,8(sp)
    80001518:	e052                	sd	s4,0(sp)
    8000151a:	1800                	addi	s0,sp,48
    8000151c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000151e:	84aa                	mv	s1,a0
    80001520:	6905                	lui	s2,0x1
    80001522:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001524:	4985                	li	s3,1
    80001526:	a829                	j	80001540 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001528:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000152a:	00c79513          	slli	a0,a5,0xc
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	fde080e7          	jalr	-34(ra) # 8000150c <freewalk>
      pagetable[i] = 0;
    80001536:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000153a:	04a1                	addi	s1,s1,8
    8000153c:	03248163          	beq	s1,s2,8000155e <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001540:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001542:	00f7f713          	andi	a4,a5,15
    80001546:	ff3701e3          	beq	a4,s3,80001528 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000154a:	8b85                	andi	a5,a5,1
    8000154c:	d7fd                	beqz	a5,8000153a <freewalk+0x2e>
      panic("freewalk: leaf");
    8000154e:	00007517          	auipc	a0,0x7
    80001552:	c2a50513          	addi	a0,a0,-982 # 80008178 <digits+0x138>
    80001556:	fffff097          	auipc	ra,0xfffff
    8000155a:	fea080e7          	jalr	-22(ra) # 80000540 <panic>
    }
  }
  kfree((void*)pagetable);
    8000155e:	8552                	mv	a0,s4
    80001560:	fffff097          	auipc	ra,0xfffff
    80001564:	488080e7          	jalr	1160(ra) # 800009e8 <kfree>
}
    80001568:	70a2                	ld	ra,40(sp)
    8000156a:	7402                	ld	s0,32(sp)
    8000156c:	64e2                	ld	s1,24(sp)
    8000156e:	6942                	ld	s2,16(sp)
    80001570:	69a2                	ld	s3,8(sp)
    80001572:	6a02                	ld	s4,0(sp)
    80001574:	6145                	addi	sp,sp,48
    80001576:	8082                	ret

0000000080001578 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001578:	1101                	addi	sp,sp,-32
    8000157a:	ec06                	sd	ra,24(sp)
    8000157c:	e822                	sd	s0,16(sp)
    8000157e:	e426                	sd	s1,8(sp)
    80001580:	1000                	addi	s0,sp,32
    80001582:	84aa                	mv	s1,a0
  if(sz > 0)
    80001584:	e999                	bnez	a1,8000159a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001586:	8526                	mv	a0,s1
    80001588:	00000097          	auipc	ra,0x0
    8000158c:	f84080e7          	jalr	-124(ra) # 8000150c <freewalk>
}
    80001590:	60e2                	ld	ra,24(sp)
    80001592:	6442                	ld	s0,16(sp)
    80001594:	64a2                	ld	s1,8(sp)
    80001596:	6105                	addi	sp,sp,32
    80001598:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000159a:	6785                	lui	a5,0x1
    8000159c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000159e:	95be                	add	a1,a1,a5
    800015a0:	4685                	li	a3,1
    800015a2:	00c5d613          	srli	a2,a1,0xc
    800015a6:	4581                	li	a1,0
    800015a8:	00000097          	auipc	ra,0x0
    800015ac:	d06080e7          	jalr	-762(ra) # 800012ae <uvmunmap>
    800015b0:	bfd9                	j	80001586 <uvmfree+0xe>

00000000800015b2 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015b2:	c679                	beqz	a2,80001680 <uvmcopy+0xce>
{
    800015b4:	715d                	addi	sp,sp,-80
    800015b6:	e486                	sd	ra,72(sp)
    800015b8:	e0a2                	sd	s0,64(sp)
    800015ba:	fc26                	sd	s1,56(sp)
    800015bc:	f84a                	sd	s2,48(sp)
    800015be:	f44e                	sd	s3,40(sp)
    800015c0:	f052                	sd	s4,32(sp)
    800015c2:	ec56                	sd	s5,24(sp)
    800015c4:	e85a                	sd	s6,16(sp)
    800015c6:	e45e                	sd	s7,8(sp)
    800015c8:	0880                	addi	s0,sp,80
    800015ca:	8b2a                	mv	s6,a0
    800015cc:	8aae                	mv	s5,a1
    800015ce:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015d0:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015d2:	4601                	li	a2,0
    800015d4:	85ce                	mv	a1,s3
    800015d6:	855a                	mv	a0,s6
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	a28080e7          	jalr	-1496(ra) # 80001000 <walk>
    800015e0:	c531                	beqz	a0,8000162c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015e2:	6118                	ld	a4,0(a0)
    800015e4:	00177793          	andi	a5,a4,1
    800015e8:	cbb1                	beqz	a5,8000163c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015ea:	00a75593          	srli	a1,a4,0xa
    800015ee:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015f2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015f6:	fffff097          	auipc	ra,0xfffff
    800015fa:	4f0080e7          	jalr	1264(ra) # 80000ae6 <kalloc>
    800015fe:	892a                	mv	s2,a0
    80001600:	c939                	beqz	a0,80001656 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001602:	6605                	lui	a2,0x1
    80001604:	85de                	mv	a1,s7
    80001606:	fffff097          	auipc	ra,0xfffff
    8000160a:	772080e7          	jalr	1906(ra) # 80000d78 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000160e:	8726                	mv	a4,s1
    80001610:	86ca                	mv	a3,s2
    80001612:	6605                	lui	a2,0x1
    80001614:	85ce                	mv	a1,s3
    80001616:	8556                	mv	a0,s5
    80001618:	00000097          	auipc	ra,0x0
    8000161c:	ad0080e7          	jalr	-1328(ra) # 800010e8 <mappages>
    80001620:	e515                	bnez	a0,8000164c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001622:	6785                	lui	a5,0x1
    80001624:	99be                	add	s3,s3,a5
    80001626:	fb49e6e3          	bltu	s3,s4,800015d2 <uvmcopy+0x20>
    8000162a:	a081                	j	8000166a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    8000162c:	00007517          	auipc	a0,0x7
    80001630:	b5c50513          	addi	a0,a0,-1188 # 80008188 <digits+0x148>
    80001634:	fffff097          	auipc	ra,0xfffff
    80001638:	f0c080e7          	jalr	-244(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    8000163c:	00007517          	auipc	a0,0x7
    80001640:	b6c50513          	addi	a0,a0,-1172 # 800081a8 <digits+0x168>
    80001644:	fffff097          	auipc	ra,0xfffff
    80001648:	efc080e7          	jalr	-260(ra) # 80000540 <panic>
      kfree(mem);
    8000164c:	854a                	mv	a0,s2
    8000164e:	fffff097          	auipc	ra,0xfffff
    80001652:	39a080e7          	jalr	922(ra) # 800009e8 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001656:	4685                	li	a3,1
    80001658:	00c9d613          	srli	a2,s3,0xc
    8000165c:	4581                	li	a1,0
    8000165e:	8556                	mv	a0,s5
    80001660:	00000097          	auipc	ra,0x0
    80001664:	c4e080e7          	jalr	-946(ra) # 800012ae <uvmunmap>
  return -1;
    80001668:	557d                	li	a0,-1
}
    8000166a:	60a6                	ld	ra,72(sp)
    8000166c:	6406                	ld	s0,64(sp)
    8000166e:	74e2                	ld	s1,56(sp)
    80001670:	7942                	ld	s2,48(sp)
    80001672:	79a2                	ld	s3,40(sp)
    80001674:	7a02                	ld	s4,32(sp)
    80001676:	6ae2                	ld	s5,24(sp)
    80001678:	6b42                	ld	s6,16(sp)
    8000167a:	6ba2                	ld	s7,8(sp)
    8000167c:	6161                	addi	sp,sp,80
    8000167e:	8082                	ret
  return 0;
    80001680:	4501                	li	a0,0
}
    80001682:	8082                	ret

0000000080001684 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001684:	1141                	addi	sp,sp,-16
    80001686:	e406                	sd	ra,8(sp)
    80001688:	e022                	sd	s0,0(sp)
    8000168a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000168c:	4601                	li	a2,0
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	972080e7          	jalr	-1678(ra) # 80001000 <walk>
  if(pte == 0)
    80001696:	c901                	beqz	a0,800016a6 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001698:	611c                	ld	a5,0(a0)
    8000169a:	9bbd                	andi	a5,a5,-17
    8000169c:	e11c                	sd	a5,0(a0)
}
    8000169e:	60a2                	ld	ra,8(sp)
    800016a0:	6402                	ld	s0,0(sp)
    800016a2:	0141                	addi	sp,sp,16
    800016a4:	8082                	ret
    panic("uvmclear");
    800016a6:	00007517          	auipc	a0,0x7
    800016aa:	b2250513          	addi	a0,a0,-1246 # 800081c8 <digits+0x188>
    800016ae:	fffff097          	auipc	ra,0xfffff
    800016b2:	e92080e7          	jalr	-366(ra) # 80000540 <panic>

00000000800016b6 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016b6:	c6bd                	beqz	a3,80001724 <copyout+0x6e>
{
    800016b8:	715d                	addi	sp,sp,-80
    800016ba:	e486                	sd	ra,72(sp)
    800016bc:	e0a2                	sd	s0,64(sp)
    800016be:	fc26                	sd	s1,56(sp)
    800016c0:	f84a                	sd	s2,48(sp)
    800016c2:	f44e                	sd	s3,40(sp)
    800016c4:	f052                	sd	s4,32(sp)
    800016c6:	ec56                	sd	s5,24(sp)
    800016c8:	e85a                	sd	s6,16(sp)
    800016ca:	e45e                	sd	s7,8(sp)
    800016cc:	e062                	sd	s8,0(sp)
    800016ce:	0880                	addi	s0,sp,80
    800016d0:	8b2a                	mv	s6,a0
    800016d2:	8c2e                	mv	s8,a1
    800016d4:	8a32                	mv	s4,a2
    800016d6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016d8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016da:	6a85                	lui	s5,0x1
    800016dc:	a015                	j	80001700 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016de:	9562                	add	a0,a0,s8
    800016e0:	0004861b          	sext.w	a2,s1
    800016e4:	85d2                	mv	a1,s4
    800016e6:	41250533          	sub	a0,a0,s2
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	68e080e7          	jalr	1678(ra) # 80000d78 <memmove>

    len -= n;
    800016f2:	409989b3          	sub	s3,s3,s1
    src += n;
    800016f6:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016f8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016fc:	02098263          	beqz	s3,80001720 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001700:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001704:	85ca                	mv	a1,s2
    80001706:	855a                	mv	a0,s6
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	99e080e7          	jalr	-1634(ra) # 800010a6 <walkaddr>
    if(pa0 == 0)
    80001710:	cd01                	beqz	a0,80001728 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001712:	418904b3          	sub	s1,s2,s8
    80001716:	94d6                	add	s1,s1,s5
    80001718:	fc99f3e3          	bgeu	s3,s1,800016de <copyout+0x28>
    8000171c:	84ce                	mv	s1,s3
    8000171e:	b7c1                	j	800016de <copyout+0x28>
  }
  return 0;
    80001720:	4501                	li	a0,0
    80001722:	a021                	j	8000172a <copyout+0x74>
    80001724:	4501                	li	a0,0
}
    80001726:	8082                	ret
      return -1;
    80001728:	557d                	li	a0,-1
}
    8000172a:	60a6                	ld	ra,72(sp)
    8000172c:	6406                	ld	s0,64(sp)
    8000172e:	74e2                	ld	s1,56(sp)
    80001730:	7942                	ld	s2,48(sp)
    80001732:	79a2                	ld	s3,40(sp)
    80001734:	7a02                	ld	s4,32(sp)
    80001736:	6ae2                	ld	s5,24(sp)
    80001738:	6b42                	ld	s6,16(sp)
    8000173a:	6ba2                	ld	s7,8(sp)
    8000173c:	6c02                	ld	s8,0(sp)
    8000173e:	6161                	addi	sp,sp,80
    80001740:	8082                	ret

0000000080001742 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001742:	caa5                	beqz	a3,800017b2 <copyin+0x70>
{
    80001744:	715d                	addi	sp,sp,-80
    80001746:	e486                	sd	ra,72(sp)
    80001748:	e0a2                	sd	s0,64(sp)
    8000174a:	fc26                	sd	s1,56(sp)
    8000174c:	f84a                	sd	s2,48(sp)
    8000174e:	f44e                	sd	s3,40(sp)
    80001750:	f052                	sd	s4,32(sp)
    80001752:	ec56                	sd	s5,24(sp)
    80001754:	e85a                	sd	s6,16(sp)
    80001756:	e45e                	sd	s7,8(sp)
    80001758:	e062                	sd	s8,0(sp)
    8000175a:	0880                	addi	s0,sp,80
    8000175c:	8b2a                	mv	s6,a0
    8000175e:	8a2e                	mv	s4,a1
    80001760:	8c32                	mv	s8,a2
    80001762:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001764:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001766:	6a85                	lui	s5,0x1
    80001768:	a01d                	j	8000178e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000176a:	018505b3          	add	a1,a0,s8
    8000176e:	0004861b          	sext.w	a2,s1
    80001772:	412585b3          	sub	a1,a1,s2
    80001776:	8552                	mv	a0,s4
    80001778:	fffff097          	auipc	ra,0xfffff
    8000177c:	600080e7          	jalr	1536(ra) # 80000d78 <memmove>

    len -= n;
    80001780:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001784:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001786:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000178a:	02098263          	beqz	s3,800017ae <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000178e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001792:	85ca                	mv	a1,s2
    80001794:	855a                	mv	a0,s6
    80001796:	00000097          	auipc	ra,0x0
    8000179a:	910080e7          	jalr	-1776(ra) # 800010a6 <walkaddr>
    if(pa0 == 0)
    8000179e:	cd01                	beqz	a0,800017b6 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017a0:	418904b3          	sub	s1,s2,s8
    800017a4:	94d6                	add	s1,s1,s5
    800017a6:	fc99f2e3          	bgeu	s3,s1,8000176a <copyin+0x28>
    800017aa:	84ce                	mv	s1,s3
    800017ac:	bf7d                	j	8000176a <copyin+0x28>
  }
  return 0;
    800017ae:	4501                	li	a0,0
    800017b0:	a021                	j	800017b8 <copyin+0x76>
    800017b2:	4501                	li	a0,0
}
    800017b4:	8082                	ret
      return -1;
    800017b6:	557d                	li	a0,-1
}
    800017b8:	60a6                	ld	ra,72(sp)
    800017ba:	6406                	ld	s0,64(sp)
    800017bc:	74e2                	ld	s1,56(sp)
    800017be:	7942                	ld	s2,48(sp)
    800017c0:	79a2                	ld	s3,40(sp)
    800017c2:	7a02                	ld	s4,32(sp)
    800017c4:	6ae2                	ld	s5,24(sp)
    800017c6:	6b42                	ld	s6,16(sp)
    800017c8:	6ba2                	ld	s7,8(sp)
    800017ca:	6c02                	ld	s8,0(sp)
    800017cc:	6161                	addi	sp,sp,80
    800017ce:	8082                	ret

00000000800017d0 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017d0:	c2dd                	beqz	a3,80001876 <copyinstr+0xa6>
{
    800017d2:	715d                	addi	sp,sp,-80
    800017d4:	e486                	sd	ra,72(sp)
    800017d6:	e0a2                	sd	s0,64(sp)
    800017d8:	fc26                	sd	s1,56(sp)
    800017da:	f84a                	sd	s2,48(sp)
    800017dc:	f44e                	sd	s3,40(sp)
    800017de:	f052                	sd	s4,32(sp)
    800017e0:	ec56                	sd	s5,24(sp)
    800017e2:	e85a                	sd	s6,16(sp)
    800017e4:	e45e                	sd	s7,8(sp)
    800017e6:	0880                	addi	s0,sp,80
    800017e8:	8a2a                	mv	s4,a0
    800017ea:	8b2e                	mv	s6,a1
    800017ec:	8bb2                	mv	s7,a2
    800017ee:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017f0:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017f2:	6985                	lui	s3,0x1
    800017f4:	a02d                	j	8000181e <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017f6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017fa:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017fc:	37fd                	addiw	a5,a5,-1
    800017fe:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001802:	60a6                	ld	ra,72(sp)
    80001804:	6406                	ld	s0,64(sp)
    80001806:	74e2                	ld	s1,56(sp)
    80001808:	7942                	ld	s2,48(sp)
    8000180a:	79a2                	ld	s3,40(sp)
    8000180c:	7a02                	ld	s4,32(sp)
    8000180e:	6ae2                	ld	s5,24(sp)
    80001810:	6b42                	ld	s6,16(sp)
    80001812:	6ba2                	ld	s7,8(sp)
    80001814:	6161                	addi	sp,sp,80
    80001816:	8082                	ret
    srcva = va0 + PGSIZE;
    80001818:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000181c:	c8a9                	beqz	s1,8000186e <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    8000181e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001822:	85ca                	mv	a1,s2
    80001824:	8552                	mv	a0,s4
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	880080e7          	jalr	-1920(ra) # 800010a6 <walkaddr>
    if(pa0 == 0)
    8000182e:	c131                	beqz	a0,80001872 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001830:	417906b3          	sub	a3,s2,s7
    80001834:	96ce                	add	a3,a3,s3
    80001836:	00d4f363          	bgeu	s1,a3,8000183c <copyinstr+0x6c>
    8000183a:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000183c:	955e                	add	a0,a0,s7
    8000183e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001842:	daf9                	beqz	a3,80001818 <copyinstr+0x48>
    80001844:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001846:	41650633          	sub	a2,a0,s6
    8000184a:	fff48593          	addi	a1,s1,-1
    8000184e:	95da                	add	a1,a1,s6
    while(n > 0){
    80001850:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80001852:	00f60733          	add	a4,a2,a5
    80001856:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd260>
    8000185a:	df51                	beqz	a4,800017f6 <copyinstr+0x26>
        *dst = *p;
    8000185c:	00e78023          	sb	a4,0(a5)
      --max;
    80001860:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001864:	0785                	addi	a5,a5,1
    while(n > 0){
    80001866:	fed796e3          	bne	a5,a3,80001852 <copyinstr+0x82>
      dst++;
    8000186a:	8b3e                	mv	s6,a5
    8000186c:	b775                	j	80001818 <copyinstr+0x48>
    8000186e:	4781                	li	a5,0
    80001870:	b771                	j	800017fc <copyinstr+0x2c>
      return -1;
    80001872:	557d                	li	a0,-1
    80001874:	b779                	j	80001802 <copyinstr+0x32>
  int got_null = 0;
    80001876:	4781                	li	a5,0
  if(got_null){
    80001878:	37fd                	addiw	a5,a5,-1
    8000187a:	0007851b          	sext.w	a0,a5
}
    8000187e:	8082                	ret

0000000080001880 <vmprint>:

static int depth=0;

void vmprint(pagetable_t pt)
{
    80001880:	711d                	addi	sp,sp,-96
    80001882:	ec86                	sd	ra,88(sp)
    80001884:	e8a2                	sd	s0,80(sp)
    80001886:	e4a6                	sd	s1,72(sp)
    80001888:	e0ca                	sd	s2,64(sp)
    8000188a:	fc4e                	sd	s3,56(sp)
    8000188c:	f852                	sd	s4,48(sp)
    8000188e:	f456                	sd	s5,40(sp)
    80001890:	f05a                	sd	s6,32(sp)
    80001892:	ec5e                	sd	s7,24(sp)
    80001894:	e862                	sd	s8,16(sp)
    80001896:	e466                	sd	s9,8(sp)
    80001898:	1080                	addi	s0,sp,96
    8000189a:	8a2a                	mv	s4,a0
 if (depth == 0)
    8000189c:	00007797          	auipc	a5,0x7
    800018a0:	0747a783          	lw	a5,116(a5) # 80008910 <depth>
    800018a4:	c395                	beqz	a5,800018c8 <vmprint+0x48>
{
    800018a6:	4981                	li	s3,0
     switch (pte & PTE_V)
     {
         case 1:  // 当 pte & PTE_V 为真
             {
                 int j = 0;
                 while (j < depth)
    800018a8:	00007a97          	auipc	s5,0x7
    800018ac:	068a8a93          	addi	s5,s5,104 # 80008910 <depth>
                 {
                     printf(".. ");
                     j++;
                 }
                 printf("..%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
    800018b0:	00007c17          	auipc	s8,0x7
    800018b4:	940c0c13          	addi	s8,s8,-1728 # 800081f0 <digits+0x1b0>
                 int j = 0;
    800018b8:	4c81                	li	s9,0
                     printf(".. ");
    800018ba:	00007b17          	auipc	s6,0x7
    800018be:	92eb0b13          	addi	s6,s6,-1746 # 800081e8 <digits+0x1a8>
 while (i < 512)
    800018c2:	20000b93          	li	s7,512
    800018c6:	a839                	j	800018e4 <vmprint+0x64>
     printf("page table %p\n", (uint64)pt);
    800018c8:	85aa                	mv	a1,a0
    800018ca:	00007517          	auipc	a0,0x7
    800018ce:	90e50513          	addi	a0,a0,-1778 # 800081d8 <digits+0x198>
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	cb8080e7          	jalr	-840(ra) # 8000058a <printf>
    800018da:	b7f1                	j	800018a6 <vmprint+0x26>
             }
             break;
         default:
             break;
     }
     i++;
    800018dc:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
 while (i < 512)
    800018de:	0a21                	addi	s4,s4,8
    800018e0:	07798563          	beq	s3,s7,8000194a <vmprint+0xca>
     pte_t pte = pt[i];
    800018e4:	000a3903          	ld	s2,0(s4)
     switch (pte & PTE_V)
    800018e8:	00197793          	andi	a5,s2,1
    800018ec:	dbe5                	beqz	a5,800018dc <vmprint+0x5c>
                 while (j < depth)
    800018ee:	000aa783          	lw	a5,0(s5)
    800018f2:	00f05d63          	blez	a5,8000190c <vmprint+0x8c>
                 int j = 0;
    800018f6:	84e6                	mv	s1,s9
                     printf(".. ");
    800018f8:	855a                	mv	a0,s6
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	c90080e7          	jalr	-880(ra) # 8000058a <printf>
                     j++;
    80001902:	2485                	addiw	s1,s1,1
                 while (j < depth)
    80001904:	000aa783          	lw	a5,0(s5)
    80001908:	fef4c8e3          	blt	s1,a5,800018f8 <vmprint+0x78>
                 printf("..%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
    8000190c:	00a95493          	srli	s1,s2,0xa
    80001910:	04b2                	slli	s1,s1,0xc
    80001912:	86a6                	mv	a3,s1
    80001914:	864a                	mv	a2,s2
    80001916:	85ce                	mv	a1,s3
    80001918:	8562                	mv	a0,s8
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	c70080e7          	jalr	-912(ra) # 8000058a <printf>
             if (!(pte & (PTE_R | PTE_W | PTE_X)))
    80001922:	00e97913          	andi	s2,s2,14
    80001926:	fa091be3          	bnez	s2,800018dc <vmprint+0x5c>
                 depth++;
    8000192a:	000aa783          	lw	a5,0(s5)
    8000192e:	2785                	addiw	a5,a5,1
    80001930:	00faa023          	sw	a5,0(s5)
                 vmprint((pagetable_t)pa);
    80001934:	8526                	mv	a0,s1
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	f4a080e7          	jalr	-182(ra) # 80001880 <vmprint>
                 depth--;
    8000193e:	000aa783          	lw	a5,0(s5)
    80001942:	37fd                	addiw	a5,a5,-1
    80001944:	00faa023          	sw	a5,0(s5)
    80001948:	bf51                	j	800018dc <vmprint+0x5c>
 }
    8000194a:	60e6                	ld	ra,88(sp)
    8000194c:	6446                	ld	s0,80(sp)
    8000194e:	64a6                	ld	s1,72(sp)
    80001950:	6906                	ld	s2,64(sp)
    80001952:	79e2                	ld	s3,56(sp)
    80001954:	7a42                	ld	s4,48(sp)
    80001956:	7aa2                	ld	s5,40(sp)
    80001958:	7b02                	ld	s6,32(sp)
    8000195a:	6be2                	ld	s7,24(sp)
    8000195c:	6c42                	ld	s8,16(sp)
    8000195e:	6ca2                	ld	s9,8(sp)
    80001960:	6125                	addi	sp,sp,96
    80001962:	8082                	ret

0000000080001964 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001964:	7139                	addi	sp,sp,-64
    80001966:	fc06                	sd	ra,56(sp)
    80001968:	f822                	sd	s0,48(sp)
    8000196a:	f426                	sd	s1,40(sp)
    8000196c:	f04a                	sd	s2,32(sp)
    8000196e:	ec4e                	sd	s3,24(sp)
    80001970:	e852                	sd	s4,16(sp)
    80001972:	e456                	sd	s5,8(sp)
    80001974:	e05a                	sd	s6,0(sp)
    80001976:	0080                	addi	s0,sp,64
    80001978:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000197a:	0000f497          	auipc	s1,0xf
    8000197e:	64648493          	addi	s1,s1,1606 # 80010fc0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001982:	8b26                	mv	s6,s1
    80001984:	00006a97          	auipc	s5,0x6
    80001988:	67ca8a93          	addi	s5,s5,1660 # 80008000 <etext>
    8000198c:	04000937          	lui	s2,0x4000
    80001990:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001992:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001994:	00015a17          	auipc	s4,0x15
    80001998:	02ca0a13          	addi	s4,s4,44 # 800169c0 <tickslock>
    char *pa = kalloc();
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	14a080e7          	jalr	330(ra) # 80000ae6 <kalloc>
    800019a4:	862a                	mv	a2,a0
    if(pa == 0)
    800019a6:	c131                	beqz	a0,800019ea <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800019a8:	416485b3          	sub	a1,s1,s6
    800019ac:	858d                	srai	a1,a1,0x3
    800019ae:	000ab783          	ld	a5,0(s5)
    800019b2:	02f585b3          	mul	a1,a1,a5
    800019b6:	2585                	addiw	a1,a1,1
    800019b8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019bc:	4719                	li	a4,6
    800019be:	6685                	lui	a3,0x1
    800019c0:	40b905b3          	sub	a1,s2,a1
    800019c4:	854e                	mv	a0,s3
    800019c6:	fffff097          	auipc	ra,0xfffff
    800019ca:	7c2080e7          	jalr	1986(ra) # 80001188 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ce:	16848493          	addi	s1,s1,360
    800019d2:	fd4495e3          	bne	s1,s4,8000199c <proc_mapstacks+0x38>
  }
}
    800019d6:	70e2                	ld	ra,56(sp)
    800019d8:	7442                	ld	s0,48(sp)
    800019da:	74a2                	ld	s1,40(sp)
    800019dc:	7902                	ld	s2,32(sp)
    800019de:	69e2                	ld	s3,24(sp)
    800019e0:	6a42                	ld	s4,16(sp)
    800019e2:	6aa2                	ld	s5,8(sp)
    800019e4:	6b02                	ld	s6,0(sp)
    800019e6:	6121                	addi	sp,sp,64
    800019e8:	8082                	ret
      panic("kalloc");
    800019ea:	00007517          	auipc	a0,0x7
    800019ee:	81e50513          	addi	a0,a0,-2018 # 80008208 <digits+0x1c8>
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	b4e080e7          	jalr	-1202(ra) # 80000540 <panic>

00000000800019fa <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800019fa:	7139                	addi	sp,sp,-64
    800019fc:	fc06                	sd	ra,56(sp)
    800019fe:	f822                	sd	s0,48(sp)
    80001a00:	f426                	sd	s1,40(sp)
    80001a02:	f04a                	sd	s2,32(sp)
    80001a04:	ec4e                	sd	s3,24(sp)
    80001a06:	e852                	sd	s4,16(sp)
    80001a08:	e456                	sd	s5,8(sp)
    80001a0a:	e05a                	sd	s6,0(sp)
    80001a0c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001a0e:	00007597          	auipc	a1,0x7
    80001a12:	80258593          	addi	a1,a1,-2046 # 80008210 <digits+0x1d0>
    80001a16:	0000f517          	auipc	a0,0xf
    80001a1a:	17a50513          	addi	a0,a0,378 # 80010b90 <pid_lock>
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	172080e7          	jalr	370(ra) # 80000b90 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001a26:	00006597          	auipc	a1,0x6
    80001a2a:	7f258593          	addi	a1,a1,2034 # 80008218 <digits+0x1d8>
    80001a2e:	0000f517          	auipc	a0,0xf
    80001a32:	17a50513          	addi	a0,a0,378 # 80010ba8 <wait_lock>
    80001a36:	fffff097          	auipc	ra,0xfffff
    80001a3a:	15a080e7          	jalr	346(ra) # 80000b90 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a3e:	0000f497          	auipc	s1,0xf
    80001a42:	58248493          	addi	s1,s1,1410 # 80010fc0 <proc>
      initlock(&p->lock, "proc");
    80001a46:	00006b17          	auipc	s6,0x6
    80001a4a:	7e2b0b13          	addi	s6,s6,2018 # 80008228 <digits+0x1e8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001a4e:	8aa6                	mv	s5,s1
    80001a50:	00006a17          	auipc	s4,0x6
    80001a54:	5b0a0a13          	addi	s4,s4,1456 # 80008000 <etext>
    80001a58:	04000937          	lui	s2,0x4000
    80001a5c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001a5e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a60:	00015997          	auipc	s3,0x15
    80001a64:	f6098993          	addi	s3,s3,-160 # 800169c0 <tickslock>
      initlock(&p->lock, "proc");
    80001a68:	85da                	mv	a1,s6
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	124080e7          	jalr	292(ra) # 80000b90 <initlock>
      p->state = UNUSED;
    80001a74:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001a78:	415487b3          	sub	a5,s1,s5
    80001a7c:	878d                	srai	a5,a5,0x3
    80001a7e:	000a3703          	ld	a4,0(s4)
    80001a82:	02e787b3          	mul	a5,a5,a4
    80001a86:	2785                	addiw	a5,a5,1
    80001a88:	00d7979b          	slliw	a5,a5,0xd
    80001a8c:	40f907b3          	sub	a5,s2,a5
    80001a90:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a92:	16848493          	addi	s1,s1,360
    80001a96:	fd3499e3          	bne	s1,s3,80001a68 <procinit+0x6e>
  }
}
    80001a9a:	70e2                	ld	ra,56(sp)
    80001a9c:	7442                	ld	s0,48(sp)
    80001a9e:	74a2                	ld	s1,40(sp)
    80001aa0:	7902                	ld	s2,32(sp)
    80001aa2:	69e2                	ld	s3,24(sp)
    80001aa4:	6a42                	ld	s4,16(sp)
    80001aa6:	6aa2                	ld	s5,8(sp)
    80001aa8:	6b02                	ld	s6,0(sp)
    80001aaa:	6121                	addi	sp,sp,64
    80001aac:	8082                	ret

0000000080001aae <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001aae:	1141                	addi	sp,sp,-16
    80001ab0:	e422                	sd	s0,8(sp)
    80001ab2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ab4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001ab6:	2501                	sext.w	a0,a0
    80001ab8:	6422                	ld	s0,8(sp)
    80001aba:	0141                	addi	sp,sp,16
    80001abc:	8082                	ret

0000000080001abe <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001abe:	1141                	addi	sp,sp,-16
    80001ac0:	e422                	sd	s0,8(sp)
    80001ac2:	0800                	addi	s0,sp,16
    80001ac4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001ac6:	2781                	sext.w	a5,a5
    80001ac8:	079e                	slli	a5,a5,0x7
  return c;
}
    80001aca:	0000f517          	auipc	a0,0xf
    80001ace:	0f650513          	addi	a0,a0,246 # 80010bc0 <cpus>
    80001ad2:	953e                	add	a0,a0,a5
    80001ad4:	6422                	ld	s0,8(sp)
    80001ad6:	0141                	addi	sp,sp,16
    80001ad8:	8082                	ret

0000000080001ada <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001ada:	1101                	addi	sp,sp,-32
    80001adc:	ec06                	sd	ra,24(sp)
    80001ade:	e822                	sd	s0,16(sp)
    80001ae0:	e426                	sd	s1,8(sp)
    80001ae2:	1000                	addi	s0,sp,32
  push_off();
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	0f0080e7          	jalr	240(ra) # 80000bd4 <push_off>
    80001aec:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001aee:	2781                	sext.w	a5,a5
    80001af0:	079e                	slli	a5,a5,0x7
    80001af2:	0000f717          	auipc	a4,0xf
    80001af6:	09e70713          	addi	a4,a4,158 # 80010b90 <pid_lock>
    80001afa:	97ba                	add	a5,a5,a4
    80001afc:	7b84                	ld	s1,48(a5)
  pop_off();
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	176080e7          	jalr	374(ra) # 80000c74 <pop_off>
  return p;
}
    80001b06:	8526                	mv	a0,s1
    80001b08:	60e2                	ld	ra,24(sp)
    80001b0a:	6442                	ld	s0,16(sp)
    80001b0c:	64a2                	ld	s1,8(sp)
    80001b0e:	6105                	addi	sp,sp,32
    80001b10:	8082                	ret

0000000080001b12 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001b1a:	00000097          	auipc	ra,0x0
    80001b1e:	fc0080e7          	jalr	-64(ra) # 80001ada <myproc>
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	1b2080e7          	jalr	434(ra) # 80000cd4 <release>

  if (first) {
    80001b2a:	00007797          	auipc	a5,0x7
    80001b2e:	d567a783          	lw	a5,-682(a5) # 80008880 <first.1>
    80001b32:	eb89                	bnez	a5,80001b44 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001b34:	00001097          	auipc	ra,0x1
    80001b38:	c8c080e7          	jalr	-884(ra) # 800027c0 <usertrapret>
}
    80001b3c:	60a2                	ld	ra,8(sp)
    80001b3e:	6402                	ld	s0,0(sp)
    80001b40:	0141                	addi	sp,sp,16
    80001b42:	8082                	ret
    first = 0;
    80001b44:	00007797          	auipc	a5,0x7
    80001b48:	d207ae23          	sw	zero,-708(a5) # 80008880 <first.1>
    fsinit(ROOTDEV);
    80001b4c:	4505                	li	a0,1
    80001b4e:	00002097          	auipc	ra,0x2
    80001b52:	bb6080e7          	jalr	-1098(ra) # 80003704 <fsinit>
    80001b56:	bff9                	j	80001b34 <forkret+0x22>

0000000080001b58 <allocpid>:
{
    80001b58:	1101                	addi	sp,sp,-32
    80001b5a:	ec06                	sd	ra,24(sp)
    80001b5c:	e822                	sd	s0,16(sp)
    80001b5e:	e426                	sd	s1,8(sp)
    80001b60:	e04a                	sd	s2,0(sp)
    80001b62:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b64:	0000f917          	auipc	s2,0xf
    80001b68:	02c90913          	addi	s2,s2,44 # 80010b90 <pid_lock>
    80001b6c:	854a                	mv	a0,s2
    80001b6e:	fffff097          	auipc	ra,0xfffff
    80001b72:	0b2080e7          	jalr	178(ra) # 80000c20 <acquire>
  pid = nextpid;
    80001b76:	00007797          	auipc	a5,0x7
    80001b7a:	d0e78793          	addi	a5,a5,-754 # 80008884 <nextpid>
    80001b7e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b80:	0014871b          	addiw	a4,s1,1
    80001b84:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b86:	854a                	mv	a0,s2
    80001b88:	fffff097          	auipc	ra,0xfffff
    80001b8c:	14c080e7          	jalr	332(ra) # 80000cd4 <release>
}
    80001b90:	8526                	mv	a0,s1
    80001b92:	60e2                	ld	ra,24(sp)
    80001b94:	6442                	ld	s0,16(sp)
    80001b96:	64a2                	ld	s1,8(sp)
    80001b98:	6902                	ld	s2,0(sp)
    80001b9a:	6105                	addi	sp,sp,32
    80001b9c:	8082                	ret

0000000080001b9e <proc_pagetable>:
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	e04a                	sd	s2,0(sp)
    80001ba8:	1000                	addi	s0,sp,32
    80001baa:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001bac:	fffff097          	auipc	ra,0xfffff
    80001bb0:	7c6080e7          	jalr	1990(ra) # 80001372 <uvmcreate>
    80001bb4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001bb6:	c121                	beqz	a0,80001bf6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001bb8:	4729                	li	a4,10
    80001bba:	00005697          	auipc	a3,0x5
    80001bbe:	44668693          	addi	a3,a3,1094 # 80007000 <_trampoline>
    80001bc2:	6605                	lui	a2,0x1
    80001bc4:	040005b7          	lui	a1,0x4000
    80001bc8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bca:	05b2                	slli	a1,a1,0xc
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	51c080e7          	jalr	1308(ra) # 800010e8 <mappages>
    80001bd4:	02054863          	bltz	a0,80001c04 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001bd8:	4719                	li	a4,6
    80001bda:	05893683          	ld	a3,88(s2)
    80001bde:	6605                	lui	a2,0x1
    80001be0:	020005b7          	lui	a1,0x2000
    80001be4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001be6:	05b6                	slli	a1,a1,0xd
    80001be8:	8526                	mv	a0,s1
    80001bea:	fffff097          	auipc	ra,0xfffff
    80001bee:	4fe080e7          	jalr	1278(ra) # 800010e8 <mappages>
    80001bf2:	02054163          	bltz	a0,80001c14 <proc_pagetable+0x76>
}
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	60e2                	ld	ra,24(sp)
    80001bfa:	6442                	ld	s0,16(sp)
    80001bfc:	64a2                	ld	s1,8(sp)
    80001bfe:	6902                	ld	s2,0(sp)
    80001c00:	6105                	addi	sp,sp,32
    80001c02:	8082                	ret
    uvmfree(pagetable, 0);
    80001c04:	4581                	li	a1,0
    80001c06:	8526                	mv	a0,s1
    80001c08:	00000097          	auipc	ra,0x0
    80001c0c:	970080e7          	jalr	-1680(ra) # 80001578 <uvmfree>
    return 0;
    80001c10:	4481                	li	s1,0
    80001c12:	b7d5                	j	80001bf6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c14:	4681                	li	a3,0
    80001c16:	4605                	li	a2,1
    80001c18:	040005b7          	lui	a1,0x4000
    80001c1c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c1e:	05b2                	slli	a1,a1,0xc
    80001c20:	8526                	mv	a0,s1
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	68c080e7          	jalr	1676(ra) # 800012ae <uvmunmap>
    uvmfree(pagetable, 0);
    80001c2a:	4581                	li	a1,0
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	94a080e7          	jalr	-1718(ra) # 80001578 <uvmfree>
    return 0;
    80001c36:	4481                	li	s1,0
    80001c38:	bf7d                	j	80001bf6 <proc_pagetable+0x58>

0000000080001c3a <proc_freepagetable>:
{
    80001c3a:	1101                	addi	sp,sp,-32
    80001c3c:	ec06                	sd	ra,24(sp)
    80001c3e:	e822                	sd	s0,16(sp)
    80001c40:	e426                	sd	s1,8(sp)
    80001c42:	e04a                	sd	s2,0(sp)
    80001c44:	1000                	addi	s0,sp,32
    80001c46:	84aa                	mv	s1,a0
    80001c48:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c4a:	4681                	li	a3,0
    80001c4c:	4605                	li	a2,1
    80001c4e:	040005b7          	lui	a1,0x4000
    80001c52:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c54:	05b2                	slli	a1,a1,0xc
    80001c56:	fffff097          	auipc	ra,0xfffff
    80001c5a:	658080e7          	jalr	1624(ra) # 800012ae <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c5e:	4681                	li	a3,0
    80001c60:	4605                	li	a2,1
    80001c62:	020005b7          	lui	a1,0x2000
    80001c66:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c68:	05b6                	slli	a1,a1,0xd
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	642080e7          	jalr	1602(ra) # 800012ae <uvmunmap>
  uvmfree(pagetable, sz);
    80001c74:	85ca                	mv	a1,s2
    80001c76:	8526                	mv	a0,s1
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	900080e7          	jalr	-1792(ra) # 80001578 <uvmfree>
}
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	64a2                	ld	s1,8(sp)
    80001c86:	6902                	ld	s2,0(sp)
    80001c88:	6105                	addi	sp,sp,32
    80001c8a:	8082                	ret

0000000080001c8c <freeproc>:
{
    80001c8c:	1101                	addi	sp,sp,-32
    80001c8e:	ec06                	sd	ra,24(sp)
    80001c90:	e822                	sd	s0,16(sp)
    80001c92:	e426                	sd	s1,8(sp)
    80001c94:	1000                	addi	s0,sp,32
    80001c96:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c98:	6d28                	ld	a0,88(a0)
    80001c9a:	c509                	beqz	a0,80001ca4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	d4c080e7          	jalr	-692(ra) # 800009e8 <kfree>
  p->trapframe = 0;
    80001ca4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001ca8:	68a8                	ld	a0,80(s1)
    80001caa:	c511                	beqz	a0,80001cb6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001cac:	64ac                	ld	a1,72(s1)
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	f8c080e7          	jalr	-116(ra) # 80001c3a <proc_freepagetable>
  p->pagetable = 0;
    80001cb6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001cba:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001cbe:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001cc2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001cc6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001cca:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001cce:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001cd2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001cd6:	0004ac23          	sw	zero,24(s1)
}
    80001cda:	60e2                	ld	ra,24(sp)
    80001cdc:	6442                	ld	s0,16(sp)
    80001cde:	64a2                	ld	s1,8(sp)
    80001ce0:	6105                	addi	sp,sp,32
    80001ce2:	8082                	ret

0000000080001ce4 <allocproc>:
{
    80001ce4:	1101                	addi	sp,sp,-32
    80001ce6:	ec06                	sd	ra,24(sp)
    80001ce8:	e822                	sd	s0,16(sp)
    80001cea:	e426                	sd	s1,8(sp)
    80001cec:	e04a                	sd	s2,0(sp)
    80001cee:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cf0:	0000f497          	auipc	s1,0xf
    80001cf4:	2d048493          	addi	s1,s1,720 # 80010fc0 <proc>
    80001cf8:	00015917          	auipc	s2,0x15
    80001cfc:	cc890913          	addi	s2,s2,-824 # 800169c0 <tickslock>
    acquire(&p->lock);
    80001d00:	8526                	mv	a0,s1
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	f1e080e7          	jalr	-226(ra) # 80000c20 <acquire>
    if(p->state == UNUSED) {
    80001d0a:	4c9c                	lw	a5,24(s1)
    80001d0c:	cf81                	beqz	a5,80001d24 <allocproc+0x40>
      release(&p->lock);
    80001d0e:	8526                	mv	a0,s1
    80001d10:	fffff097          	auipc	ra,0xfffff
    80001d14:	fc4080e7          	jalr	-60(ra) # 80000cd4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d18:	16848493          	addi	s1,s1,360
    80001d1c:	ff2492e3          	bne	s1,s2,80001d00 <allocproc+0x1c>
  return 0;
    80001d20:	4481                	li	s1,0
    80001d22:	a889                	j	80001d74 <allocproc+0x90>
  p->pid = allocpid();
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	e34080e7          	jalr	-460(ra) # 80001b58 <allocpid>
    80001d2c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d2e:	4785                	li	a5,1
    80001d30:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	db4080e7          	jalr	-588(ra) # 80000ae6 <kalloc>
    80001d3a:	892a                	mv	s2,a0
    80001d3c:	eca8                	sd	a0,88(s1)
    80001d3e:	c131                	beqz	a0,80001d82 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001d40:	8526                	mv	a0,s1
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	e5c080e7          	jalr	-420(ra) # 80001b9e <proc_pagetable>
    80001d4a:	892a                	mv	s2,a0
    80001d4c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001d4e:	c531                	beqz	a0,80001d9a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001d50:	07000613          	li	a2,112
    80001d54:	4581                	li	a1,0
    80001d56:	06048513          	addi	a0,s1,96
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	fc2080e7          	jalr	-62(ra) # 80000d1c <memset>
  p->context.ra = (uint64)forkret;
    80001d62:	00000797          	auipc	a5,0x0
    80001d66:	db078793          	addi	a5,a5,-592 # 80001b12 <forkret>
    80001d6a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d6c:	60bc                	ld	a5,64(s1)
    80001d6e:	6705                	lui	a4,0x1
    80001d70:	97ba                	add	a5,a5,a4
    80001d72:	f4bc                	sd	a5,104(s1)
}
    80001d74:	8526                	mv	a0,s1
    80001d76:	60e2                	ld	ra,24(sp)
    80001d78:	6442                	ld	s0,16(sp)
    80001d7a:	64a2                	ld	s1,8(sp)
    80001d7c:	6902                	ld	s2,0(sp)
    80001d7e:	6105                	addi	sp,sp,32
    80001d80:	8082                	ret
    freeproc(p);
    80001d82:	8526                	mv	a0,s1
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	f08080e7          	jalr	-248(ra) # 80001c8c <freeproc>
    release(&p->lock);
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	f46080e7          	jalr	-186(ra) # 80000cd4 <release>
    return 0;
    80001d96:	84ca                	mv	s1,s2
    80001d98:	bff1                	j	80001d74 <allocproc+0x90>
    freeproc(p);
    80001d9a:	8526                	mv	a0,s1
    80001d9c:	00000097          	auipc	ra,0x0
    80001da0:	ef0080e7          	jalr	-272(ra) # 80001c8c <freeproc>
    release(&p->lock);
    80001da4:	8526                	mv	a0,s1
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	f2e080e7          	jalr	-210(ra) # 80000cd4 <release>
    return 0;
    80001dae:	84ca                	mv	s1,s2
    80001db0:	b7d1                	j	80001d74 <allocproc+0x90>

0000000080001db2 <userinit>:
{
    80001db2:	1101                	addi	sp,sp,-32
    80001db4:	ec06                	sd	ra,24(sp)
    80001db6:	e822                	sd	s0,16(sp)
    80001db8:	e426                	sd	s1,8(sp)
    80001dba:	1000                	addi	s0,sp,32
  p = allocproc();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	f28080e7          	jalr	-216(ra) # 80001ce4 <allocproc>
    80001dc4:	84aa                	mv	s1,a0
  initproc = p;
    80001dc6:	00007797          	auipc	a5,0x7
    80001dca:	b4a7bd23          	sd	a0,-1190(a5) # 80008920 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001dce:	03400613          	li	a2,52
    80001dd2:	00007597          	auipc	a1,0x7
    80001dd6:	abe58593          	addi	a1,a1,-1346 # 80008890 <initcode>
    80001dda:	6928                	ld	a0,80(a0)
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	5c4080e7          	jalr	1476(ra) # 800013a0 <uvmfirst>
  p->sz = PGSIZE;
    80001de4:	6785                	lui	a5,0x1
    80001de6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001de8:	6cb8                	ld	a4,88(s1)
    80001dea:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001dee:	6cb8                	ld	a4,88(s1)
    80001df0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001df2:	4641                	li	a2,16
    80001df4:	00006597          	auipc	a1,0x6
    80001df8:	43c58593          	addi	a1,a1,1084 # 80008230 <digits+0x1f0>
    80001dfc:	15848513          	addi	a0,s1,344
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	066080e7          	jalr	102(ra) # 80000e66 <safestrcpy>
  p->cwd = namei("/");
    80001e08:	00006517          	auipc	a0,0x6
    80001e0c:	43850513          	addi	a0,a0,1080 # 80008240 <digits+0x200>
    80001e10:	00002097          	auipc	ra,0x2
    80001e14:	3ca080e7          	jalr	970(ra) # 800041da <namei>
    80001e18:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001e1c:	478d                	li	a5,3
    80001e1e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001e20:	8526                	mv	a0,s1
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	eb2080e7          	jalr	-334(ra) # 80000cd4 <release>
}
    80001e2a:	60e2                	ld	ra,24(sp)
    80001e2c:	6442                	ld	s0,16(sp)
    80001e2e:	64a2                	ld	s1,8(sp)
    80001e30:	6105                	addi	sp,sp,32
    80001e32:	8082                	ret

0000000080001e34 <growproc>:
{
    80001e34:	1101                	addi	sp,sp,-32
    80001e36:	ec06                	sd	ra,24(sp)
    80001e38:	e822                	sd	s0,16(sp)
    80001e3a:	e426                	sd	s1,8(sp)
    80001e3c:	e04a                	sd	s2,0(sp)
    80001e3e:	1000                	addi	s0,sp,32
    80001e40:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001e42:	00000097          	auipc	ra,0x0
    80001e46:	c98080e7          	jalr	-872(ra) # 80001ada <myproc>
    80001e4a:	84aa                	mv	s1,a0
  sz = p->sz;
    80001e4c:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001e4e:	01204c63          	bgtz	s2,80001e66 <growproc+0x32>
  } else if(n < 0){
    80001e52:	02094663          	bltz	s2,80001e7e <growproc+0x4a>
  p->sz = sz;
    80001e56:	e4ac                	sd	a1,72(s1)
  return 0;
    80001e58:	4501                	li	a0,0
}
    80001e5a:	60e2                	ld	ra,24(sp)
    80001e5c:	6442                	ld	s0,16(sp)
    80001e5e:	64a2                	ld	s1,8(sp)
    80001e60:	6902                	ld	s2,0(sp)
    80001e62:	6105                	addi	sp,sp,32
    80001e64:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001e66:	4691                	li	a3,4
    80001e68:	00b90633          	add	a2,s2,a1
    80001e6c:	6928                	ld	a0,80(a0)
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	5ec080e7          	jalr	1516(ra) # 8000145a <uvmalloc>
    80001e76:	85aa                	mv	a1,a0
    80001e78:	fd79                	bnez	a0,80001e56 <growproc+0x22>
      return -1;
    80001e7a:	557d                	li	a0,-1
    80001e7c:	bff9                	j	80001e5a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e7e:	00b90633          	add	a2,s2,a1
    80001e82:	6928                	ld	a0,80(a0)
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	58e080e7          	jalr	1422(ra) # 80001412 <uvmdealloc>
    80001e8c:	85aa                	mv	a1,a0
    80001e8e:	b7e1                	j	80001e56 <growproc+0x22>

0000000080001e90 <fork>:
{
    80001e90:	7139                	addi	sp,sp,-64
    80001e92:	fc06                	sd	ra,56(sp)
    80001e94:	f822                	sd	s0,48(sp)
    80001e96:	f426                	sd	s1,40(sp)
    80001e98:	f04a                	sd	s2,32(sp)
    80001e9a:	ec4e                	sd	s3,24(sp)
    80001e9c:	e852                	sd	s4,16(sp)
    80001e9e:	e456                	sd	s5,8(sp)
    80001ea0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001ea2:	00000097          	auipc	ra,0x0
    80001ea6:	c38080e7          	jalr	-968(ra) # 80001ada <myproc>
    80001eaa:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001eac:	00000097          	auipc	ra,0x0
    80001eb0:	e38080e7          	jalr	-456(ra) # 80001ce4 <allocproc>
    80001eb4:	10050c63          	beqz	a0,80001fcc <fork+0x13c>
    80001eb8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001eba:	048ab603          	ld	a2,72(s5)
    80001ebe:	692c                	ld	a1,80(a0)
    80001ec0:	050ab503          	ld	a0,80(s5)
    80001ec4:	fffff097          	auipc	ra,0xfffff
    80001ec8:	6ee080e7          	jalr	1774(ra) # 800015b2 <uvmcopy>
    80001ecc:	04054863          	bltz	a0,80001f1c <fork+0x8c>
  np->sz = p->sz;
    80001ed0:	048ab783          	ld	a5,72(s5)
    80001ed4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001ed8:	058ab683          	ld	a3,88(s5)
    80001edc:	87b6                	mv	a5,a3
    80001ede:	058a3703          	ld	a4,88(s4)
    80001ee2:	12068693          	addi	a3,a3,288
    80001ee6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001eea:	6788                	ld	a0,8(a5)
    80001eec:	6b8c                	ld	a1,16(a5)
    80001eee:	6f90                	ld	a2,24(a5)
    80001ef0:	01073023          	sd	a6,0(a4)
    80001ef4:	e708                	sd	a0,8(a4)
    80001ef6:	eb0c                	sd	a1,16(a4)
    80001ef8:	ef10                	sd	a2,24(a4)
    80001efa:	02078793          	addi	a5,a5,32
    80001efe:	02070713          	addi	a4,a4,32
    80001f02:	fed792e3          	bne	a5,a3,80001ee6 <fork+0x56>
  np->trapframe->a0 = 0;
    80001f06:	058a3783          	ld	a5,88(s4)
    80001f0a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001f0e:	0d0a8493          	addi	s1,s5,208
    80001f12:	0d0a0913          	addi	s2,s4,208
    80001f16:	150a8993          	addi	s3,s5,336
    80001f1a:	a00d                	j	80001f3c <fork+0xac>
    freeproc(np);
    80001f1c:	8552                	mv	a0,s4
    80001f1e:	00000097          	auipc	ra,0x0
    80001f22:	d6e080e7          	jalr	-658(ra) # 80001c8c <freeproc>
    release(&np->lock);
    80001f26:	8552                	mv	a0,s4
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	dac080e7          	jalr	-596(ra) # 80000cd4 <release>
    return -1;
    80001f30:	597d                	li	s2,-1
    80001f32:	a059                	j	80001fb8 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001f34:	04a1                	addi	s1,s1,8
    80001f36:	0921                	addi	s2,s2,8
    80001f38:	01348b63          	beq	s1,s3,80001f4e <fork+0xbe>
    if(p->ofile[i])
    80001f3c:	6088                	ld	a0,0(s1)
    80001f3e:	d97d                	beqz	a0,80001f34 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f40:	00003097          	auipc	ra,0x3
    80001f44:	930080e7          	jalr	-1744(ra) # 80004870 <filedup>
    80001f48:	00a93023          	sd	a0,0(s2)
    80001f4c:	b7e5                	j	80001f34 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001f4e:	150ab503          	ld	a0,336(s5)
    80001f52:	00002097          	auipc	ra,0x2
    80001f56:	9f2080e7          	jalr	-1550(ra) # 80003944 <idup>
    80001f5a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f5e:	4641                	li	a2,16
    80001f60:	158a8593          	addi	a1,s5,344
    80001f64:	158a0513          	addi	a0,s4,344
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	efe080e7          	jalr	-258(ra) # 80000e66 <safestrcpy>
  pid = np->pid;
    80001f70:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001f74:	8552                	mv	a0,s4
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	d5e080e7          	jalr	-674(ra) # 80000cd4 <release>
  acquire(&wait_lock);
    80001f7e:	0000f497          	auipc	s1,0xf
    80001f82:	c2a48493          	addi	s1,s1,-982 # 80010ba8 <wait_lock>
    80001f86:	8526                	mv	a0,s1
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	c98080e7          	jalr	-872(ra) # 80000c20 <acquire>
  np->parent = p;
    80001f90:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001f94:	8526                	mv	a0,s1
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	d3e080e7          	jalr	-706(ra) # 80000cd4 <release>
  acquire(&np->lock);
    80001f9e:	8552                	mv	a0,s4
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	c80080e7          	jalr	-896(ra) # 80000c20 <acquire>
  np->state = RUNNABLE;
    80001fa8:	478d                	li	a5,3
    80001faa:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001fae:	8552                	mv	a0,s4
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	d24080e7          	jalr	-732(ra) # 80000cd4 <release>
}
    80001fb8:	854a                	mv	a0,s2
    80001fba:	70e2                	ld	ra,56(sp)
    80001fbc:	7442                	ld	s0,48(sp)
    80001fbe:	74a2                	ld	s1,40(sp)
    80001fc0:	7902                	ld	s2,32(sp)
    80001fc2:	69e2                	ld	s3,24(sp)
    80001fc4:	6a42                	ld	s4,16(sp)
    80001fc6:	6aa2                	ld	s5,8(sp)
    80001fc8:	6121                	addi	sp,sp,64
    80001fca:	8082                	ret
    return -1;
    80001fcc:	597d                	li	s2,-1
    80001fce:	b7ed                	j	80001fb8 <fork+0x128>

0000000080001fd0 <scheduler>:
{
    80001fd0:	7139                	addi	sp,sp,-64
    80001fd2:	fc06                	sd	ra,56(sp)
    80001fd4:	f822                	sd	s0,48(sp)
    80001fd6:	f426                	sd	s1,40(sp)
    80001fd8:	f04a                	sd	s2,32(sp)
    80001fda:	ec4e                	sd	s3,24(sp)
    80001fdc:	e852                	sd	s4,16(sp)
    80001fde:	e456                	sd	s5,8(sp)
    80001fe0:	e05a                	sd	s6,0(sp)
    80001fe2:	0080                	addi	s0,sp,64
    80001fe4:	8792                	mv	a5,tp
  int id = r_tp();
    80001fe6:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fe8:	00779a93          	slli	s5,a5,0x7
    80001fec:	0000f717          	auipc	a4,0xf
    80001ff0:	ba470713          	addi	a4,a4,-1116 # 80010b90 <pid_lock>
    80001ff4:	9756                	add	a4,a4,s5
    80001ff6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ffa:	0000f717          	auipc	a4,0xf
    80001ffe:	bce70713          	addi	a4,a4,-1074 # 80010bc8 <cpus+0x8>
    80002002:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002004:	498d                	li	s3,3
        p->state = RUNNING;
    80002006:	4b11                	li	s6,4
        c->proc = p;
    80002008:	079e                	slli	a5,a5,0x7
    8000200a:	0000fa17          	auipc	s4,0xf
    8000200e:	b86a0a13          	addi	s4,s4,-1146 # 80010b90 <pid_lock>
    80002012:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002014:	00015917          	auipc	s2,0x15
    80002018:	9ac90913          	addi	s2,s2,-1620 # 800169c0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000201c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002020:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002024:	10079073          	csrw	sstatus,a5
    80002028:	0000f497          	auipc	s1,0xf
    8000202c:	f9848493          	addi	s1,s1,-104 # 80010fc0 <proc>
    80002030:	a811                	j	80002044 <scheduler+0x74>
      release(&p->lock);
    80002032:	8526                	mv	a0,s1
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	ca0080e7          	jalr	-864(ra) # 80000cd4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000203c:	16848493          	addi	s1,s1,360
    80002040:	fd248ee3          	beq	s1,s2,8000201c <scheduler+0x4c>
      acquire(&p->lock);
    80002044:	8526                	mv	a0,s1
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	bda080e7          	jalr	-1062(ra) # 80000c20 <acquire>
      if(p->state == RUNNABLE) {
    8000204e:	4c9c                	lw	a5,24(s1)
    80002050:	ff3791e3          	bne	a5,s3,80002032 <scheduler+0x62>
        p->state = RUNNING;
    80002054:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002058:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000205c:	06048593          	addi	a1,s1,96
    80002060:	8556                	mv	a0,s5
    80002062:	00000097          	auipc	ra,0x0
    80002066:	6b4080e7          	jalr	1716(ra) # 80002716 <swtch>
        c->proc = 0;
    8000206a:	020a3823          	sd	zero,48(s4)
    8000206e:	b7d1                	j	80002032 <scheduler+0x62>

0000000080002070 <sched>:
{
    80002070:	7179                	addi	sp,sp,-48
    80002072:	f406                	sd	ra,40(sp)
    80002074:	f022                	sd	s0,32(sp)
    80002076:	ec26                	sd	s1,24(sp)
    80002078:	e84a                	sd	s2,16(sp)
    8000207a:	e44e                	sd	s3,8(sp)
    8000207c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	a5c080e7          	jalr	-1444(ra) # 80001ada <myproc>
    80002086:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	b1e080e7          	jalr	-1250(ra) # 80000ba6 <holding>
    80002090:	c93d                	beqz	a0,80002106 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002092:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002094:	2781                	sext.w	a5,a5
    80002096:	079e                	slli	a5,a5,0x7
    80002098:	0000f717          	auipc	a4,0xf
    8000209c:	af870713          	addi	a4,a4,-1288 # 80010b90 <pid_lock>
    800020a0:	97ba                	add	a5,a5,a4
    800020a2:	0a87a703          	lw	a4,168(a5)
    800020a6:	4785                	li	a5,1
    800020a8:	06f71763          	bne	a4,a5,80002116 <sched+0xa6>
  if(p->state == RUNNING)
    800020ac:	4c98                	lw	a4,24(s1)
    800020ae:	4791                	li	a5,4
    800020b0:	06f70b63          	beq	a4,a5,80002126 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020b4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020b8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020ba:	efb5                	bnez	a5,80002136 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020bc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020be:	0000f917          	auipc	s2,0xf
    800020c2:	ad290913          	addi	s2,s2,-1326 # 80010b90 <pid_lock>
    800020c6:	2781                	sext.w	a5,a5
    800020c8:	079e                	slli	a5,a5,0x7
    800020ca:	97ca                	add	a5,a5,s2
    800020cc:	0ac7a983          	lw	s3,172(a5)
    800020d0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020d2:	2781                	sext.w	a5,a5
    800020d4:	079e                	slli	a5,a5,0x7
    800020d6:	0000f597          	auipc	a1,0xf
    800020da:	af258593          	addi	a1,a1,-1294 # 80010bc8 <cpus+0x8>
    800020de:	95be                	add	a1,a1,a5
    800020e0:	06048513          	addi	a0,s1,96
    800020e4:	00000097          	auipc	ra,0x0
    800020e8:	632080e7          	jalr	1586(ra) # 80002716 <swtch>
    800020ec:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020ee:	2781                	sext.w	a5,a5
    800020f0:	079e                	slli	a5,a5,0x7
    800020f2:	993e                	add	s2,s2,a5
    800020f4:	0b392623          	sw	s3,172(s2)
}
    800020f8:	70a2                	ld	ra,40(sp)
    800020fa:	7402                	ld	s0,32(sp)
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	6942                	ld	s2,16(sp)
    80002100:	69a2                	ld	s3,8(sp)
    80002102:	6145                	addi	sp,sp,48
    80002104:	8082                	ret
    panic("sched p->lock");
    80002106:	00006517          	auipc	a0,0x6
    8000210a:	14250513          	addi	a0,a0,322 # 80008248 <digits+0x208>
    8000210e:	ffffe097          	auipc	ra,0xffffe
    80002112:	432080e7          	jalr	1074(ra) # 80000540 <panic>
    panic("sched locks");
    80002116:	00006517          	auipc	a0,0x6
    8000211a:	14250513          	addi	a0,a0,322 # 80008258 <digits+0x218>
    8000211e:	ffffe097          	auipc	ra,0xffffe
    80002122:	422080e7          	jalr	1058(ra) # 80000540 <panic>
    panic("sched running");
    80002126:	00006517          	auipc	a0,0x6
    8000212a:	14250513          	addi	a0,a0,322 # 80008268 <digits+0x228>
    8000212e:	ffffe097          	auipc	ra,0xffffe
    80002132:	412080e7          	jalr	1042(ra) # 80000540 <panic>
    panic("sched interruptible");
    80002136:	00006517          	auipc	a0,0x6
    8000213a:	14250513          	addi	a0,a0,322 # 80008278 <digits+0x238>
    8000213e:	ffffe097          	auipc	ra,0xffffe
    80002142:	402080e7          	jalr	1026(ra) # 80000540 <panic>

0000000080002146 <yield>:
{
    80002146:	1101                	addi	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002150:	00000097          	auipc	ra,0x0
    80002154:	98a080e7          	jalr	-1654(ra) # 80001ada <myproc>
    80002158:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	ac6080e7          	jalr	-1338(ra) # 80000c20 <acquire>
  p->state = RUNNABLE;
    80002162:	478d                	li	a5,3
    80002164:	cc9c                	sw	a5,24(s1)
  sched();
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	f0a080e7          	jalr	-246(ra) # 80002070 <sched>
  release(&p->lock);
    8000216e:	8526                	mv	a0,s1
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	b64080e7          	jalr	-1180(ra) # 80000cd4 <release>
}
    80002178:	60e2                	ld	ra,24(sp)
    8000217a:	6442                	ld	s0,16(sp)
    8000217c:	64a2                	ld	s1,8(sp)
    8000217e:	6105                	addi	sp,sp,32
    80002180:	8082                	ret

0000000080002182 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002182:	7179                	addi	sp,sp,-48
    80002184:	f406                	sd	ra,40(sp)
    80002186:	f022                	sd	s0,32(sp)
    80002188:	ec26                	sd	s1,24(sp)
    8000218a:	e84a                	sd	s2,16(sp)
    8000218c:	e44e                	sd	s3,8(sp)
    8000218e:	1800                	addi	s0,sp,48
    80002190:	89aa                	mv	s3,a0
    80002192:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002194:	00000097          	auipc	ra,0x0
    80002198:	946080e7          	jalr	-1722(ra) # 80001ada <myproc>
    8000219c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	a82080e7          	jalr	-1406(ra) # 80000c20 <acquire>
  release(lk);
    800021a6:	854a                	mv	a0,s2
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	b2c080e7          	jalr	-1236(ra) # 80000cd4 <release>

  // Go to sleep.
  p->chan = chan;
    800021b0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800021b4:	4789                	li	a5,2
    800021b6:	cc9c                	sw	a5,24(s1)

  sched();
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	eb8080e7          	jalr	-328(ra) # 80002070 <sched>

  // Tidy up.
  p->chan = 0;
    800021c0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	b0e080e7          	jalr	-1266(ra) # 80000cd4 <release>
  acquire(lk);
    800021ce:	854a                	mv	a0,s2
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	a50080e7          	jalr	-1456(ra) # 80000c20 <acquire>
}
    800021d8:	70a2                	ld	ra,40(sp)
    800021da:	7402                	ld	s0,32(sp)
    800021dc:	64e2                	ld	s1,24(sp)
    800021de:	6942                	ld	s2,16(sp)
    800021e0:	69a2                	ld	s3,8(sp)
    800021e2:	6145                	addi	sp,sp,48
    800021e4:	8082                	ret

00000000800021e6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800021e6:	7139                	addi	sp,sp,-64
    800021e8:	fc06                	sd	ra,56(sp)
    800021ea:	f822                	sd	s0,48(sp)
    800021ec:	f426                	sd	s1,40(sp)
    800021ee:	f04a                	sd	s2,32(sp)
    800021f0:	ec4e                	sd	s3,24(sp)
    800021f2:	e852                	sd	s4,16(sp)
    800021f4:	e456                	sd	s5,8(sp)
    800021f6:	0080                	addi	s0,sp,64
    800021f8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800021fa:	0000f497          	auipc	s1,0xf
    800021fe:	dc648493          	addi	s1,s1,-570 # 80010fc0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002202:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002204:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002206:	00014917          	auipc	s2,0x14
    8000220a:	7ba90913          	addi	s2,s2,1978 # 800169c0 <tickslock>
    8000220e:	a811                	j	80002222 <wakeup+0x3c>
      }
      release(&p->lock);
    80002210:	8526                	mv	a0,s1
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	ac2080e7          	jalr	-1342(ra) # 80000cd4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000221a:	16848493          	addi	s1,s1,360
    8000221e:	03248663          	beq	s1,s2,8000224a <wakeup+0x64>
    if(p != myproc()){
    80002222:	00000097          	auipc	ra,0x0
    80002226:	8b8080e7          	jalr	-1864(ra) # 80001ada <myproc>
    8000222a:	fea488e3          	beq	s1,a0,8000221a <wakeup+0x34>
      acquire(&p->lock);
    8000222e:	8526                	mv	a0,s1
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	9f0080e7          	jalr	-1552(ra) # 80000c20 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002238:	4c9c                	lw	a5,24(s1)
    8000223a:	fd379be3          	bne	a5,s3,80002210 <wakeup+0x2a>
    8000223e:	709c                	ld	a5,32(s1)
    80002240:	fd4798e3          	bne	a5,s4,80002210 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002244:	0154ac23          	sw	s5,24(s1)
    80002248:	b7e1                	j	80002210 <wakeup+0x2a>
    }
  }
}
    8000224a:	70e2                	ld	ra,56(sp)
    8000224c:	7442                	ld	s0,48(sp)
    8000224e:	74a2                	ld	s1,40(sp)
    80002250:	7902                	ld	s2,32(sp)
    80002252:	69e2                	ld	s3,24(sp)
    80002254:	6a42                	ld	s4,16(sp)
    80002256:	6aa2                	ld	s5,8(sp)
    80002258:	6121                	addi	sp,sp,64
    8000225a:	8082                	ret

000000008000225c <reparent>:
{
    8000225c:	7179                	addi	sp,sp,-48
    8000225e:	f406                	sd	ra,40(sp)
    80002260:	f022                	sd	s0,32(sp)
    80002262:	ec26                	sd	s1,24(sp)
    80002264:	e84a                	sd	s2,16(sp)
    80002266:	e44e                	sd	s3,8(sp)
    80002268:	e052                	sd	s4,0(sp)
    8000226a:	1800                	addi	s0,sp,48
    8000226c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000226e:	0000f497          	auipc	s1,0xf
    80002272:	d5248493          	addi	s1,s1,-686 # 80010fc0 <proc>
      pp->parent = initproc;
    80002276:	00006a17          	auipc	s4,0x6
    8000227a:	6aaa0a13          	addi	s4,s4,1706 # 80008920 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000227e:	00014997          	auipc	s3,0x14
    80002282:	74298993          	addi	s3,s3,1858 # 800169c0 <tickslock>
    80002286:	a029                	j	80002290 <reparent+0x34>
    80002288:	16848493          	addi	s1,s1,360
    8000228c:	01348d63          	beq	s1,s3,800022a6 <reparent+0x4a>
    if(pp->parent == p){
    80002290:	7c9c                	ld	a5,56(s1)
    80002292:	ff279be3          	bne	a5,s2,80002288 <reparent+0x2c>
      pp->parent = initproc;
    80002296:	000a3503          	ld	a0,0(s4)
    8000229a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	f4a080e7          	jalr	-182(ra) # 800021e6 <wakeup>
    800022a4:	b7d5                	j	80002288 <reparent+0x2c>
}
    800022a6:	70a2                	ld	ra,40(sp)
    800022a8:	7402                	ld	s0,32(sp)
    800022aa:	64e2                	ld	s1,24(sp)
    800022ac:	6942                	ld	s2,16(sp)
    800022ae:	69a2                	ld	s3,8(sp)
    800022b0:	6a02                	ld	s4,0(sp)
    800022b2:	6145                	addi	sp,sp,48
    800022b4:	8082                	ret

00000000800022b6 <exit>:
{
    800022b6:	7179                	addi	sp,sp,-48
    800022b8:	f406                	sd	ra,40(sp)
    800022ba:	f022                	sd	s0,32(sp)
    800022bc:	ec26                	sd	s1,24(sp)
    800022be:	e84a                	sd	s2,16(sp)
    800022c0:	e44e                	sd	s3,8(sp)
    800022c2:	e052                	sd	s4,0(sp)
    800022c4:	1800                	addi	s0,sp,48
    800022c6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800022c8:	00000097          	auipc	ra,0x0
    800022cc:	812080e7          	jalr	-2030(ra) # 80001ada <myproc>
    800022d0:	89aa                	mv	s3,a0
  if(p == initproc)
    800022d2:	00006797          	auipc	a5,0x6
    800022d6:	64e7b783          	ld	a5,1614(a5) # 80008920 <initproc>
    800022da:	0d050493          	addi	s1,a0,208
    800022de:	15050913          	addi	s2,a0,336
    800022e2:	02a79363          	bne	a5,a0,80002308 <exit+0x52>
    panic("init exiting");
    800022e6:	00006517          	auipc	a0,0x6
    800022ea:	faa50513          	addi	a0,a0,-86 # 80008290 <digits+0x250>
    800022ee:	ffffe097          	auipc	ra,0xffffe
    800022f2:	252080e7          	jalr	594(ra) # 80000540 <panic>
      fileclose(f);
    800022f6:	00002097          	auipc	ra,0x2
    800022fa:	5cc080e7          	jalr	1484(ra) # 800048c2 <fileclose>
      p->ofile[fd] = 0;
    800022fe:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002302:	04a1                	addi	s1,s1,8
    80002304:	01248563          	beq	s1,s2,8000230e <exit+0x58>
    if(p->ofile[fd]){
    80002308:	6088                	ld	a0,0(s1)
    8000230a:	f575                	bnez	a0,800022f6 <exit+0x40>
    8000230c:	bfdd                	j	80002302 <exit+0x4c>
  begin_op();
    8000230e:	00002097          	auipc	ra,0x2
    80002312:	0ec080e7          	jalr	236(ra) # 800043fa <begin_op>
  iput(p->cwd);
    80002316:	1509b503          	ld	a0,336(s3)
    8000231a:	00002097          	auipc	ra,0x2
    8000231e:	8cc080e7          	jalr	-1844(ra) # 80003be6 <iput>
  end_op();
    80002322:	00002097          	auipc	ra,0x2
    80002326:	156080e7          	jalr	342(ra) # 80004478 <end_op>
  p->cwd = 0;
    8000232a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000232e:	0000f497          	auipc	s1,0xf
    80002332:	87a48493          	addi	s1,s1,-1926 # 80010ba8 <wait_lock>
    80002336:	8526                	mv	a0,s1
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	8e8080e7          	jalr	-1816(ra) # 80000c20 <acquire>
  reparent(p);
    80002340:	854e                	mv	a0,s3
    80002342:	00000097          	auipc	ra,0x0
    80002346:	f1a080e7          	jalr	-230(ra) # 8000225c <reparent>
  wakeup(p->parent);
    8000234a:	0389b503          	ld	a0,56(s3)
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	e98080e7          	jalr	-360(ra) # 800021e6 <wakeup>
  acquire(&p->lock);
    80002356:	854e                	mv	a0,s3
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	8c8080e7          	jalr	-1848(ra) # 80000c20 <acquire>
  p->xstate = status;
    80002360:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002364:	4795                	li	a5,5
    80002366:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000236a:	8526                	mv	a0,s1
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	968080e7          	jalr	-1688(ra) # 80000cd4 <release>
  sched();
    80002374:	00000097          	auipc	ra,0x0
    80002378:	cfc080e7          	jalr	-772(ra) # 80002070 <sched>
  panic("zombie exit");
    8000237c:	00006517          	auipc	a0,0x6
    80002380:	f2450513          	addi	a0,a0,-220 # 800082a0 <digits+0x260>
    80002384:	ffffe097          	auipc	ra,0xffffe
    80002388:	1bc080e7          	jalr	444(ra) # 80000540 <panic>

000000008000238c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000238c:	7179                	addi	sp,sp,-48
    8000238e:	f406                	sd	ra,40(sp)
    80002390:	f022                	sd	s0,32(sp)
    80002392:	ec26                	sd	s1,24(sp)
    80002394:	e84a                	sd	s2,16(sp)
    80002396:	e44e                	sd	s3,8(sp)
    80002398:	1800                	addi	s0,sp,48
    8000239a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000239c:	0000f497          	auipc	s1,0xf
    800023a0:	c2448493          	addi	s1,s1,-988 # 80010fc0 <proc>
    800023a4:	00014997          	auipc	s3,0x14
    800023a8:	61c98993          	addi	s3,s3,1564 # 800169c0 <tickslock>
    acquire(&p->lock);
    800023ac:	8526                	mv	a0,s1
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	872080e7          	jalr	-1934(ra) # 80000c20 <acquire>
    if(p->pid == pid){
    800023b6:	589c                	lw	a5,48(s1)
    800023b8:	01278d63          	beq	a5,s2,800023d2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023bc:	8526                	mv	a0,s1
    800023be:	fffff097          	auipc	ra,0xfffff
    800023c2:	916080e7          	jalr	-1770(ra) # 80000cd4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023c6:	16848493          	addi	s1,s1,360
    800023ca:	ff3491e3          	bne	s1,s3,800023ac <kill+0x20>
  }
  return -1;
    800023ce:	557d                	li	a0,-1
    800023d0:	a829                	j	800023ea <kill+0x5e>
      p->killed = 1;
    800023d2:	4785                	li	a5,1
    800023d4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023d6:	4c98                	lw	a4,24(s1)
    800023d8:	4789                	li	a5,2
    800023da:	00f70f63          	beq	a4,a5,800023f8 <kill+0x6c>
      release(&p->lock);
    800023de:	8526                	mv	a0,s1
    800023e0:	fffff097          	auipc	ra,0xfffff
    800023e4:	8f4080e7          	jalr	-1804(ra) # 80000cd4 <release>
      return 0;
    800023e8:	4501                	li	a0,0
}
    800023ea:	70a2                	ld	ra,40(sp)
    800023ec:	7402                	ld	s0,32(sp)
    800023ee:	64e2                	ld	s1,24(sp)
    800023f0:	6942                	ld	s2,16(sp)
    800023f2:	69a2                	ld	s3,8(sp)
    800023f4:	6145                	addi	sp,sp,48
    800023f6:	8082                	ret
        p->state = RUNNABLE;
    800023f8:	478d                	li	a5,3
    800023fa:	cc9c                	sw	a5,24(s1)
    800023fc:	b7cd                	j	800023de <kill+0x52>

00000000800023fe <setkilled>:

void
setkilled(struct proc *p)
{
    800023fe:	1101                	addi	sp,sp,-32
    80002400:	ec06                	sd	ra,24(sp)
    80002402:	e822                	sd	s0,16(sp)
    80002404:	e426                	sd	s1,8(sp)
    80002406:	1000                	addi	s0,sp,32
    80002408:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	816080e7          	jalr	-2026(ra) # 80000c20 <acquire>
  p->killed = 1;
    80002412:	4785                	li	a5,1
    80002414:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002416:	8526                	mv	a0,s1
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	8bc080e7          	jalr	-1860(ra) # 80000cd4 <release>
}
    80002420:	60e2                	ld	ra,24(sp)
    80002422:	6442                	ld	s0,16(sp)
    80002424:	64a2                	ld	s1,8(sp)
    80002426:	6105                	addi	sp,sp,32
    80002428:	8082                	ret

000000008000242a <killed>:

int
killed(struct proc *p)
{
    8000242a:	1101                	addi	sp,sp,-32
    8000242c:	ec06                	sd	ra,24(sp)
    8000242e:	e822                	sd	s0,16(sp)
    80002430:	e426                	sd	s1,8(sp)
    80002432:	e04a                	sd	s2,0(sp)
    80002434:	1000                	addi	s0,sp,32
    80002436:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002438:	ffffe097          	auipc	ra,0xffffe
    8000243c:	7e8080e7          	jalr	2024(ra) # 80000c20 <acquire>
  k = p->killed;
    80002440:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002444:	8526                	mv	a0,s1
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	88e080e7          	jalr	-1906(ra) # 80000cd4 <release>
  return k;
}
    8000244e:	854a                	mv	a0,s2
    80002450:	60e2                	ld	ra,24(sp)
    80002452:	6442                	ld	s0,16(sp)
    80002454:	64a2                	ld	s1,8(sp)
    80002456:	6902                	ld	s2,0(sp)
    80002458:	6105                	addi	sp,sp,32
    8000245a:	8082                	ret

000000008000245c <wait>:
{
    8000245c:	715d                	addi	sp,sp,-80
    8000245e:	e486                	sd	ra,72(sp)
    80002460:	e0a2                	sd	s0,64(sp)
    80002462:	fc26                	sd	s1,56(sp)
    80002464:	f84a                	sd	s2,48(sp)
    80002466:	f44e                	sd	s3,40(sp)
    80002468:	f052                	sd	s4,32(sp)
    8000246a:	ec56                	sd	s5,24(sp)
    8000246c:	e85a                	sd	s6,16(sp)
    8000246e:	e45e                	sd	s7,8(sp)
    80002470:	e062                	sd	s8,0(sp)
    80002472:	0880                	addi	s0,sp,80
    80002474:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	664080e7          	jalr	1636(ra) # 80001ada <myproc>
    8000247e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002480:	0000e517          	auipc	a0,0xe
    80002484:	72850513          	addi	a0,a0,1832 # 80010ba8 <wait_lock>
    80002488:	ffffe097          	auipc	ra,0xffffe
    8000248c:	798080e7          	jalr	1944(ra) # 80000c20 <acquire>
    havekids = 0;
    80002490:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002492:	4a15                	li	s4,5
        havekids = 1;
    80002494:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002496:	00014997          	auipc	s3,0x14
    8000249a:	52a98993          	addi	s3,s3,1322 # 800169c0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000249e:	0000ec17          	auipc	s8,0xe
    800024a2:	70ac0c13          	addi	s8,s8,1802 # 80010ba8 <wait_lock>
    havekids = 0;
    800024a6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024a8:	0000f497          	auipc	s1,0xf
    800024ac:	b1848493          	addi	s1,s1,-1256 # 80010fc0 <proc>
    800024b0:	a0bd                	j	8000251e <wait+0xc2>
          pid = pp->pid;
    800024b2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800024b6:	000b0e63          	beqz	s6,800024d2 <wait+0x76>
    800024ba:	4691                	li	a3,4
    800024bc:	02c48613          	addi	a2,s1,44
    800024c0:	85da                	mv	a1,s6
    800024c2:	05093503          	ld	a0,80(s2)
    800024c6:	fffff097          	auipc	ra,0xfffff
    800024ca:	1f0080e7          	jalr	496(ra) # 800016b6 <copyout>
    800024ce:	02054563          	bltz	a0,800024f8 <wait+0x9c>
          freeproc(pp);
    800024d2:	8526                	mv	a0,s1
    800024d4:	fffff097          	auipc	ra,0xfffff
    800024d8:	7b8080e7          	jalr	1976(ra) # 80001c8c <freeproc>
          release(&pp->lock);
    800024dc:	8526                	mv	a0,s1
    800024de:	ffffe097          	auipc	ra,0xffffe
    800024e2:	7f6080e7          	jalr	2038(ra) # 80000cd4 <release>
          release(&wait_lock);
    800024e6:	0000e517          	auipc	a0,0xe
    800024ea:	6c250513          	addi	a0,a0,1730 # 80010ba8 <wait_lock>
    800024ee:	ffffe097          	auipc	ra,0xffffe
    800024f2:	7e6080e7          	jalr	2022(ra) # 80000cd4 <release>
          return pid;
    800024f6:	a0b5                	j	80002562 <wait+0x106>
            release(&pp->lock);
    800024f8:	8526                	mv	a0,s1
    800024fa:	ffffe097          	auipc	ra,0xffffe
    800024fe:	7da080e7          	jalr	2010(ra) # 80000cd4 <release>
            release(&wait_lock);
    80002502:	0000e517          	auipc	a0,0xe
    80002506:	6a650513          	addi	a0,a0,1702 # 80010ba8 <wait_lock>
    8000250a:	ffffe097          	auipc	ra,0xffffe
    8000250e:	7ca080e7          	jalr	1994(ra) # 80000cd4 <release>
            return -1;
    80002512:	59fd                	li	s3,-1
    80002514:	a0b9                	j	80002562 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002516:	16848493          	addi	s1,s1,360
    8000251a:	03348463          	beq	s1,s3,80002542 <wait+0xe6>
      if(pp->parent == p){
    8000251e:	7c9c                	ld	a5,56(s1)
    80002520:	ff279be3          	bne	a5,s2,80002516 <wait+0xba>
        acquire(&pp->lock);
    80002524:	8526                	mv	a0,s1
    80002526:	ffffe097          	auipc	ra,0xffffe
    8000252a:	6fa080e7          	jalr	1786(ra) # 80000c20 <acquire>
        if(pp->state == ZOMBIE){
    8000252e:	4c9c                	lw	a5,24(s1)
    80002530:	f94781e3          	beq	a5,s4,800024b2 <wait+0x56>
        release(&pp->lock);
    80002534:	8526                	mv	a0,s1
    80002536:	ffffe097          	auipc	ra,0xffffe
    8000253a:	79e080e7          	jalr	1950(ra) # 80000cd4 <release>
        havekids = 1;
    8000253e:	8756                	mv	a4,s5
    80002540:	bfd9                	j	80002516 <wait+0xba>
    if(!havekids || killed(p)){
    80002542:	c719                	beqz	a4,80002550 <wait+0xf4>
    80002544:	854a                	mv	a0,s2
    80002546:	00000097          	auipc	ra,0x0
    8000254a:	ee4080e7          	jalr	-284(ra) # 8000242a <killed>
    8000254e:	c51d                	beqz	a0,8000257c <wait+0x120>
      release(&wait_lock);
    80002550:	0000e517          	auipc	a0,0xe
    80002554:	65850513          	addi	a0,a0,1624 # 80010ba8 <wait_lock>
    80002558:	ffffe097          	auipc	ra,0xffffe
    8000255c:	77c080e7          	jalr	1916(ra) # 80000cd4 <release>
      return -1;
    80002560:	59fd                	li	s3,-1
}
    80002562:	854e                	mv	a0,s3
    80002564:	60a6                	ld	ra,72(sp)
    80002566:	6406                	ld	s0,64(sp)
    80002568:	74e2                	ld	s1,56(sp)
    8000256a:	7942                	ld	s2,48(sp)
    8000256c:	79a2                	ld	s3,40(sp)
    8000256e:	7a02                	ld	s4,32(sp)
    80002570:	6ae2                	ld	s5,24(sp)
    80002572:	6b42                	ld	s6,16(sp)
    80002574:	6ba2                	ld	s7,8(sp)
    80002576:	6c02                	ld	s8,0(sp)
    80002578:	6161                	addi	sp,sp,80
    8000257a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000257c:	85e2                	mv	a1,s8
    8000257e:	854a                	mv	a0,s2
    80002580:	00000097          	auipc	ra,0x0
    80002584:	c02080e7          	jalr	-1022(ra) # 80002182 <sleep>
    havekids = 0;
    80002588:	bf39                	j	800024a6 <wait+0x4a>

000000008000258a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000258a:	7179                	addi	sp,sp,-48
    8000258c:	f406                	sd	ra,40(sp)
    8000258e:	f022                	sd	s0,32(sp)
    80002590:	ec26                	sd	s1,24(sp)
    80002592:	e84a                	sd	s2,16(sp)
    80002594:	e44e                	sd	s3,8(sp)
    80002596:	e052                	sd	s4,0(sp)
    80002598:	1800                	addi	s0,sp,48
    8000259a:	84aa                	mv	s1,a0
    8000259c:	892e                	mv	s2,a1
    8000259e:	89b2                	mv	s3,a2
    800025a0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025a2:	fffff097          	auipc	ra,0xfffff
    800025a6:	538080e7          	jalr	1336(ra) # 80001ada <myproc>
  if(user_dst){
    800025aa:	c08d                	beqz	s1,800025cc <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800025ac:	86d2                	mv	a3,s4
    800025ae:	864e                	mv	a2,s3
    800025b0:	85ca                	mv	a1,s2
    800025b2:	6928                	ld	a0,80(a0)
    800025b4:	fffff097          	auipc	ra,0xfffff
    800025b8:	102080e7          	jalr	258(ra) # 800016b6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800025bc:	70a2                	ld	ra,40(sp)
    800025be:	7402                	ld	s0,32(sp)
    800025c0:	64e2                	ld	s1,24(sp)
    800025c2:	6942                	ld	s2,16(sp)
    800025c4:	69a2                	ld	s3,8(sp)
    800025c6:	6a02                	ld	s4,0(sp)
    800025c8:	6145                	addi	sp,sp,48
    800025ca:	8082                	ret
    memmove((char *)dst, src, len);
    800025cc:	000a061b          	sext.w	a2,s4
    800025d0:	85ce                	mv	a1,s3
    800025d2:	854a                	mv	a0,s2
    800025d4:	ffffe097          	auipc	ra,0xffffe
    800025d8:	7a4080e7          	jalr	1956(ra) # 80000d78 <memmove>
    return 0;
    800025dc:	8526                	mv	a0,s1
    800025de:	bff9                	j	800025bc <either_copyout+0x32>

00000000800025e0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800025e0:	7179                	addi	sp,sp,-48
    800025e2:	f406                	sd	ra,40(sp)
    800025e4:	f022                	sd	s0,32(sp)
    800025e6:	ec26                	sd	s1,24(sp)
    800025e8:	e84a                	sd	s2,16(sp)
    800025ea:	e44e                	sd	s3,8(sp)
    800025ec:	e052                	sd	s4,0(sp)
    800025ee:	1800                	addi	s0,sp,48
    800025f0:	892a                	mv	s2,a0
    800025f2:	84ae                	mv	s1,a1
    800025f4:	89b2                	mv	s3,a2
    800025f6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025f8:	fffff097          	auipc	ra,0xfffff
    800025fc:	4e2080e7          	jalr	1250(ra) # 80001ada <myproc>
  if(user_src){
    80002600:	c08d                	beqz	s1,80002622 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002602:	86d2                	mv	a3,s4
    80002604:	864e                	mv	a2,s3
    80002606:	85ca                	mv	a1,s2
    80002608:	6928                	ld	a0,80(a0)
    8000260a:	fffff097          	auipc	ra,0xfffff
    8000260e:	138080e7          	jalr	312(ra) # 80001742 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002612:	70a2                	ld	ra,40(sp)
    80002614:	7402                	ld	s0,32(sp)
    80002616:	64e2                	ld	s1,24(sp)
    80002618:	6942                	ld	s2,16(sp)
    8000261a:	69a2                	ld	s3,8(sp)
    8000261c:	6a02                	ld	s4,0(sp)
    8000261e:	6145                	addi	sp,sp,48
    80002620:	8082                	ret
    memmove(dst, (char*)src, len);
    80002622:	000a061b          	sext.w	a2,s4
    80002626:	85ce                	mv	a1,s3
    80002628:	854a                	mv	a0,s2
    8000262a:	ffffe097          	auipc	ra,0xffffe
    8000262e:	74e080e7          	jalr	1870(ra) # 80000d78 <memmove>
    return 0;
    80002632:	8526                	mv	a0,s1
    80002634:	bff9                	j	80002612 <either_copyin+0x32>

0000000080002636 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002636:	715d                	addi	sp,sp,-80
    80002638:	e486                	sd	ra,72(sp)
    8000263a:	e0a2                	sd	s0,64(sp)
    8000263c:	fc26                	sd	s1,56(sp)
    8000263e:	f84a                	sd	s2,48(sp)
    80002640:	f44e                	sd	s3,40(sp)
    80002642:	f052                	sd	s4,32(sp)
    80002644:	ec56                	sd	s5,24(sp)
    80002646:	e85a                	sd	s6,16(sp)
    80002648:	e45e                	sd	s7,8(sp)
    8000264a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000264c:	00006517          	auipc	a0,0x6
    80002650:	a7c50513          	addi	a0,a0,-1412 # 800080c8 <digits+0x88>
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	f36080e7          	jalr	-202(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000265c:	0000f497          	auipc	s1,0xf
    80002660:	abc48493          	addi	s1,s1,-1348 # 80011118 <proc+0x158>
    80002664:	00014917          	auipc	s2,0x14
    80002668:	4b490913          	addi	s2,s2,1204 # 80016b18 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000266c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000266e:	00006997          	auipc	s3,0x6
    80002672:	c4298993          	addi	s3,s3,-958 # 800082b0 <digits+0x270>
    printf("%d %s %s", p->pid, state, p->name);
    80002676:	00006a97          	auipc	s5,0x6
    8000267a:	c42a8a93          	addi	s5,s5,-958 # 800082b8 <digits+0x278>
    printf("\n");
    8000267e:	00006a17          	auipc	s4,0x6
    80002682:	a4aa0a13          	addi	s4,s4,-1462 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002686:	00006b97          	auipc	s7,0x6
    8000268a:	c72b8b93          	addi	s7,s7,-910 # 800082f8 <states.0>
    8000268e:	a00d                	j	800026b0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002690:	ed86a583          	lw	a1,-296(a3)
    80002694:	8556                	mv	a0,s5
    80002696:	ffffe097          	auipc	ra,0xffffe
    8000269a:	ef4080e7          	jalr	-268(ra) # 8000058a <printf>
    printf("\n");
    8000269e:	8552                	mv	a0,s4
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	eea080e7          	jalr	-278(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026a8:	16848493          	addi	s1,s1,360
    800026ac:	03248263          	beq	s1,s2,800026d0 <procdump+0x9a>
    if(p->state == UNUSED)
    800026b0:	86a6                	mv	a3,s1
    800026b2:	ec04a783          	lw	a5,-320(s1)
    800026b6:	dbed                	beqz	a5,800026a8 <procdump+0x72>
      state = "???";
    800026b8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026ba:	fcfb6be3          	bltu	s6,a5,80002690 <procdump+0x5a>
    800026be:	02079713          	slli	a4,a5,0x20
    800026c2:	01d75793          	srli	a5,a4,0x1d
    800026c6:	97de                	add	a5,a5,s7
    800026c8:	6390                	ld	a2,0(a5)
    800026ca:	f279                	bnez	a2,80002690 <procdump+0x5a>
      state = "???";
    800026cc:	864e                	mv	a2,s3
    800026ce:	b7c9                	j	80002690 <procdump+0x5a>
  }
}
    800026d0:	60a6                	ld	ra,72(sp)
    800026d2:	6406                	ld	s0,64(sp)
    800026d4:	74e2                	ld	s1,56(sp)
    800026d6:	7942                	ld	s2,48(sp)
    800026d8:	79a2                	ld	s3,40(sp)
    800026da:	7a02                	ld	s4,32(sp)
    800026dc:	6ae2                	ld	s5,24(sp)
    800026de:	6b42                	ld	s6,16(sp)
    800026e0:	6ba2                	ld	s7,8(sp)
    800026e2:	6161                	addi	sp,sp,80
    800026e4:	8082                	ret

00000000800026e6 <proccnt>:

int proccnt(void)
{
    800026e6:	1141                	addi	sp,sp,-16
    800026e8:	e422                	sd	s0,8(sp)
    800026ea:	0800                	addi	s0,sp,16
int nproc = 0;
struct proc* p;
for (p=proc;p<&proc[NPROC];p++)
    800026ec:	0000f797          	auipc	a5,0xf
    800026f0:	8d478793          	addi	a5,a5,-1836 # 80010fc0 <proc>
int nproc = 0;
    800026f4:	4501                	li	a0,0
for (p=proc;p<&proc[NPROC];p++)
    800026f6:	00014697          	auipc	a3,0x14
    800026fa:	2ca68693          	addi	a3,a3,714 # 800169c0 <tickslock>
    800026fe:	a029                	j	80002708 <proccnt+0x22>
    80002700:	16878793          	addi	a5,a5,360
    80002704:	00d78663          	beq	a5,a3,80002710 <proccnt+0x2a>
{
 if (p->state != UNUSED)
    80002708:	4f98                	lw	a4,24(a5)
    8000270a:	db7d                	beqz	a4,80002700 <proccnt+0x1a>
 {
   nproc++;
    8000270c:	2505                	addiw	a0,a0,1
    8000270e:	bfcd                	j	80002700 <proccnt+0x1a>
 }
}
return nproc;
}
    80002710:	6422                	ld	s0,8(sp)
    80002712:	0141                	addi	sp,sp,16
    80002714:	8082                	ret

0000000080002716 <swtch>:
    80002716:	00153023          	sd	ra,0(a0)
    8000271a:	00253423          	sd	sp,8(a0)
    8000271e:	e900                	sd	s0,16(a0)
    80002720:	ed04                	sd	s1,24(a0)
    80002722:	03253023          	sd	s2,32(a0)
    80002726:	03353423          	sd	s3,40(a0)
    8000272a:	03453823          	sd	s4,48(a0)
    8000272e:	03553c23          	sd	s5,56(a0)
    80002732:	05653023          	sd	s6,64(a0)
    80002736:	05753423          	sd	s7,72(a0)
    8000273a:	05853823          	sd	s8,80(a0)
    8000273e:	05953c23          	sd	s9,88(a0)
    80002742:	07a53023          	sd	s10,96(a0)
    80002746:	07b53423          	sd	s11,104(a0)
    8000274a:	0005b083          	ld	ra,0(a1)
    8000274e:	0085b103          	ld	sp,8(a1)
    80002752:	6980                	ld	s0,16(a1)
    80002754:	6d84                	ld	s1,24(a1)
    80002756:	0205b903          	ld	s2,32(a1)
    8000275a:	0285b983          	ld	s3,40(a1)
    8000275e:	0305ba03          	ld	s4,48(a1)
    80002762:	0385ba83          	ld	s5,56(a1)
    80002766:	0405bb03          	ld	s6,64(a1)
    8000276a:	0485bb83          	ld	s7,72(a1)
    8000276e:	0505bc03          	ld	s8,80(a1)
    80002772:	0585bc83          	ld	s9,88(a1)
    80002776:	0605bd03          	ld	s10,96(a1)
    8000277a:	0685bd83          	ld	s11,104(a1)
    8000277e:	8082                	ret

0000000080002780 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002780:	1141                	addi	sp,sp,-16
    80002782:	e406                	sd	ra,8(sp)
    80002784:	e022                	sd	s0,0(sp)
    80002786:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002788:	00006597          	auipc	a1,0x6
    8000278c:	ba058593          	addi	a1,a1,-1120 # 80008328 <states.0+0x30>
    80002790:	00014517          	auipc	a0,0x14
    80002794:	23050513          	addi	a0,a0,560 # 800169c0 <tickslock>
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	3f8080e7          	jalr	1016(ra) # 80000b90 <initlock>
}
    800027a0:	60a2                	ld	ra,8(sp)
    800027a2:	6402                	ld	s0,0(sp)
    800027a4:	0141                	addi	sp,sp,16
    800027a6:	8082                	ret

00000000800027a8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027a8:	1141                	addi	sp,sp,-16
    800027aa:	e422                	sd	s0,8(sp)
    800027ac:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027ae:	00003797          	auipc	a5,0x3
    800027b2:	78278793          	addi	a5,a5,1922 # 80005f30 <kernelvec>
    800027b6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027ba:	6422                	ld	s0,8(sp)
    800027bc:	0141                	addi	sp,sp,16
    800027be:	8082                	ret

00000000800027c0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800027c0:	1141                	addi	sp,sp,-16
    800027c2:	e406                	sd	ra,8(sp)
    800027c4:	e022                	sd	s0,0(sp)
    800027c6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027c8:	fffff097          	auipc	ra,0xfffff
    800027cc:	312080e7          	jalr	786(ra) # 80001ada <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027d0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027d4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027d6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027da:	00005697          	auipc	a3,0x5
    800027de:	82668693          	addi	a3,a3,-2010 # 80007000 <_trampoline>
    800027e2:	00005717          	auipc	a4,0x5
    800027e6:	81e70713          	addi	a4,a4,-2018 # 80007000 <_trampoline>
    800027ea:	8f15                	sub	a4,a4,a3
    800027ec:	040007b7          	lui	a5,0x4000
    800027f0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800027f2:	07b2                	slli	a5,a5,0xc
    800027f4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027f6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800027fa:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800027fc:	18002673          	csrr	a2,satp
    80002800:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002802:	6d30                	ld	a2,88(a0)
    80002804:	6138                	ld	a4,64(a0)
    80002806:	6585                	lui	a1,0x1
    80002808:	972e                	add	a4,a4,a1
    8000280a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000280c:	6d38                	ld	a4,88(a0)
    8000280e:	00000617          	auipc	a2,0x0
    80002812:	13060613          	addi	a2,a2,304 # 8000293e <usertrap>
    80002816:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002818:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000281a:	8612                	mv	a2,tp
    8000281c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000281e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002822:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002826:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000282a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000282e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002830:	6f18                	ld	a4,24(a4)
    80002832:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002836:	6928                	ld	a0,80(a0)
    80002838:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000283a:	00005717          	auipc	a4,0x5
    8000283e:	86270713          	addi	a4,a4,-1950 # 8000709c <userret>
    80002842:	8f15                	sub	a4,a4,a3
    80002844:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002846:	577d                	li	a4,-1
    80002848:	177e                	slli	a4,a4,0x3f
    8000284a:	8d59                	or	a0,a0,a4
    8000284c:	9782                	jalr	a5
}
    8000284e:	60a2                	ld	ra,8(sp)
    80002850:	6402                	ld	s0,0(sp)
    80002852:	0141                	addi	sp,sp,16
    80002854:	8082                	ret

0000000080002856 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002856:	1101                	addi	sp,sp,-32
    80002858:	ec06                	sd	ra,24(sp)
    8000285a:	e822                	sd	s0,16(sp)
    8000285c:	e426                	sd	s1,8(sp)
    8000285e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002860:	00014497          	auipc	s1,0x14
    80002864:	16048493          	addi	s1,s1,352 # 800169c0 <tickslock>
    80002868:	8526                	mv	a0,s1
    8000286a:	ffffe097          	auipc	ra,0xffffe
    8000286e:	3b6080e7          	jalr	950(ra) # 80000c20 <acquire>
  ticks++;
    80002872:	00006517          	auipc	a0,0x6
    80002876:	0b650513          	addi	a0,a0,182 # 80008928 <ticks>
    8000287a:	411c                	lw	a5,0(a0)
    8000287c:	2785                	addiw	a5,a5,1
    8000287e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002880:	00000097          	auipc	ra,0x0
    80002884:	966080e7          	jalr	-1690(ra) # 800021e6 <wakeup>
  release(&tickslock);
    80002888:	8526                	mv	a0,s1
    8000288a:	ffffe097          	auipc	ra,0xffffe
    8000288e:	44a080e7          	jalr	1098(ra) # 80000cd4 <release>
}
    80002892:	60e2                	ld	ra,24(sp)
    80002894:	6442                	ld	s0,16(sp)
    80002896:	64a2                	ld	s1,8(sp)
    80002898:	6105                	addi	sp,sp,32
    8000289a:	8082                	ret

000000008000289c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000289c:	1101                	addi	sp,sp,-32
    8000289e:	ec06                	sd	ra,24(sp)
    800028a0:	e822                	sd	s0,16(sp)
    800028a2:	e426                	sd	s1,8(sp)
    800028a4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028a6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800028aa:	00074d63          	bltz	a4,800028c4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800028ae:	57fd                	li	a5,-1
    800028b0:	17fe                	slli	a5,a5,0x3f
    800028b2:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800028b4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800028b6:	06f70363          	beq	a4,a5,8000291c <devintr+0x80>
  }
}
    800028ba:	60e2                	ld	ra,24(sp)
    800028bc:	6442                	ld	s0,16(sp)
    800028be:	64a2                	ld	s1,8(sp)
    800028c0:	6105                	addi	sp,sp,32
    800028c2:	8082                	ret
     (scause & 0xff) == 9){
    800028c4:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    800028c8:	46a5                	li	a3,9
    800028ca:	fed792e3          	bne	a5,a3,800028ae <devintr+0x12>
    int irq = plic_claim();
    800028ce:	00003097          	auipc	ra,0x3
    800028d2:	76a080e7          	jalr	1898(ra) # 80006038 <plic_claim>
    800028d6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800028d8:	47a9                	li	a5,10
    800028da:	02f50763          	beq	a0,a5,80002908 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800028de:	4785                	li	a5,1
    800028e0:	02f50963          	beq	a0,a5,80002912 <devintr+0x76>
    return 1;
    800028e4:	4505                	li	a0,1
    } else if(irq){
    800028e6:	d8f1                	beqz	s1,800028ba <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800028e8:	85a6                	mv	a1,s1
    800028ea:	00006517          	auipc	a0,0x6
    800028ee:	a4650513          	addi	a0,a0,-1466 # 80008330 <states.0+0x38>
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	c98080e7          	jalr	-872(ra) # 8000058a <printf>
      plic_complete(irq);
    800028fa:	8526                	mv	a0,s1
    800028fc:	00003097          	auipc	ra,0x3
    80002900:	760080e7          	jalr	1888(ra) # 8000605c <plic_complete>
    return 1;
    80002904:	4505                	li	a0,1
    80002906:	bf55                	j	800028ba <devintr+0x1e>
      uartintr();
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	090080e7          	jalr	144(ra) # 80000998 <uartintr>
    80002910:	b7ed                	j	800028fa <devintr+0x5e>
      virtio_disk_intr();
    80002912:	00004097          	auipc	ra,0x4
    80002916:	c12080e7          	jalr	-1006(ra) # 80006524 <virtio_disk_intr>
    8000291a:	b7c5                	j	800028fa <devintr+0x5e>
    if(cpuid() == 0){
    8000291c:	fffff097          	auipc	ra,0xfffff
    80002920:	192080e7          	jalr	402(ra) # 80001aae <cpuid>
    80002924:	c901                	beqz	a0,80002934 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002926:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000292a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000292c:	14479073          	csrw	sip,a5
    return 2;
    80002930:	4509                	li	a0,2
    80002932:	b761                	j	800028ba <devintr+0x1e>
      clockintr();
    80002934:	00000097          	auipc	ra,0x0
    80002938:	f22080e7          	jalr	-222(ra) # 80002856 <clockintr>
    8000293c:	b7ed                	j	80002926 <devintr+0x8a>

000000008000293e <usertrap>:
{
    8000293e:	1101                	addi	sp,sp,-32
    80002940:	ec06                	sd	ra,24(sp)
    80002942:	e822                	sd	s0,16(sp)
    80002944:	e426                	sd	s1,8(sp)
    80002946:	e04a                	sd	s2,0(sp)
    80002948:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000294a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000294e:	1007f793          	andi	a5,a5,256
    80002952:	e3b1                	bnez	a5,80002996 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002954:	00003797          	auipc	a5,0x3
    80002958:	5dc78793          	addi	a5,a5,1500 # 80005f30 <kernelvec>
    8000295c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002960:	fffff097          	auipc	ra,0xfffff
    80002964:	17a080e7          	jalr	378(ra) # 80001ada <myproc>
    80002968:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000296a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000296c:	14102773          	csrr	a4,sepc
    80002970:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002972:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002976:	47a1                	li	a5,8
    80002978:	02f70763          	beq	a4,a5,800029a6 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	f20080e7          	jalr	-224(ra) # 8000289c <devintr>
    80002984:	892a                	mv	s2,a0
    80002986:	c151                	beqz	a0,80002a0a <usertrap+0xcc>
  if(killed(p))
    80002988:	8526                	mv	a0,s1
    8000298a:	00000097          	auipc	ra,0x0
    8000298e:	aa0080e7          	jalr	-1376(ra) # 8000242a <killed>
    80002992:	c929                	beqz	a0,800029e4 <usertrap+0xa6>
    80002994:	a099                	j	800029da <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	9ba50513          	addi	a0,a0,-1606 # 80008350 <states.0+0x58>
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	ba2080e7          	jalr	-1118(ra) # 80000540 <panic>
    if(killed(p))
    800029a6:	00000097          	auipc	ra,0x0
    800029aa:	a84080e7          	jalr	-1404(ra) # 8000242a <killed>
    800029ae:	e921                	bnez	a0,800029fe <usertrap+0xc0>
    p->trapframe->epc += 4;
    800029b0:	6cb8                	ld	a4,88(s1)
    800029b2:	6f1c                	ld	a5,24(a4)
    800029b4:	0791                	addi	a5,a5,4
    800029b6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029c0:	10079073          	csrw	sstatus,a5
    syscall();
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	2d4080e7          	jalr	724(ra) # 80002c98 <syscall>
  if(killed(p))
    800029cc:	8526                	mv	a0,s1
    800029ce:	00000097          	auipc	ra,0x0
    800029d2:	a5c080e7          	jalr	-1444(ra) # 8000242a <killed>
    800029d6:	c911                	beqz	a0,800029ea <usertrap+0xac>
    800029d8:	4901                	li	s2,0
    exit(-1);
    800029da:	557d                	li	a0,-1
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	8da080e7          	jalr	-1830(ra) # 800022b6 <exit>
  if(which_dev == 2)
    800029e4:	4789                	li	a5,2
    800029e6:	04f90f63          	beq	s2,a5,80002a44 <usertrap+0x106>
  usertrapret();
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	dd6080e7          	jalr	-554(ra) # 800027c0 <usertrapret>
}
    800029f2:	60e2                	ld	ra,24(sp)
    800029f4:	6442                	ld	s0,16(sp)
    800029f6:	64a2                	ld	s1,8(sp)
    800029f8:	6902                	ld	s2,0(sp)
    800029fa:	6105                	addi	sp,sp,32
    800029fc:	8082                	ret
      exit(-1);
    800029fe:	557d                	li	a0,-1
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	8b6080e7          	jalr	-1866(ra) # 800022b6 <exit>
    80002a08:	b765                	j	800029b0 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a0a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002a0e:	5890                	lw	a2,48(s1)
    80002a10:	00006517          	auipc	a0,0x6
    80002a14:	96050513          	addi	a0,a0,-1696 # 80008370 <states.0+0x78>
    80002a18:	ffffe097          	auipc	ra,0xffffe
    80002a1c:	b72080e7          	jalr	-1166(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a20:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a24:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	97850513          	addi	a0,a0,-1672 # 800083a0 <states.0+0xa8>
    80002a30:	ffffe097          	auipc	ra,0xffffe
    80002a34:	b5a080e7          	jalr	-1190(ra) # 8000058a <printf>
    setkilled(p);
    80002a38:	8526                	mv	a0,s1
    80002a3a:	00000097          	auipc	ra,0x0
    80002a3e:	9c4080e7          	jalr	-1596(ra) # 800023fe <setkilled>
    80002a42:	b769                	j	800029cc <usertrap+0x8e>
    yield();
    80002a44:	fffff097          	auipc	ra,0xfffff
    80002a48:	702080e7          	jalr	1794(ra) # 80002146 <yield>
    80002a4c:	bf79                	j	800029ea <usertrap+0xac>

0000000080002a4e <kerneltrap>:
{
    80002a4e:	7179                	addi	sp,sp,-48
    80002a50:	f406                	sd	ra,40(sp)
    80002a52:	f022                	sd	s0,32(sp)
    80002a54:	ec26                	sd	s1,24(sp)
    80002a56:	e84a                	sd	s2,16(sp)
    80002a58:	e44e                	sd	s3,8(sp)
    80002a5a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a5c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a60:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a64:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a68:	1004f793          	andi	a5,s1,256
    80002a6c:	cb85                	beqz	a5,80002a9c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a6e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a72:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a74:	ef85                	bnez	a5,80002aac <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a76:	00000097          	auipc	ra,0x0
    80002a7a:	e26080e7          	jalr	-474(ra) # 8000289c <devintr>
    80002a7e:	cd1d                	beqz	a0,80002abc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a80:	4789                	li	a5,2
    80002a82:	06f50a63          	beq	a0,a5,80002af6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a86:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a8a:	10049073          	csrw	sstatus,s1
}
    80002a8e:	70a2                	ld	ra,40(sp)
    80002a90:	7402                	ld	s0,32(sp)
    80002a92:	64e2                	ld	s1,24(sp)
    80002a94:	6942                	ld	s2,16(sp)
    80002a96:	69a2                	ld	s3,8(sp)
    80002a98:	6145                	addi	sp,sp,48
    80002a9a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a9c:	00006517          	auipc	a0,0x6
    80002aa0:	92450513          	addi	a0,a0,-1756 # 800083c0 <states.0+0xc8>
    80002aa4:	ffffe097          	auipc	ra,0xffffe
    80002aa8:	a9c080e7          	jalr	-1380(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002aac:	00006517          	auipc	a0,0x6
    80002ab0:	93c50513          	addi	a0,a0,-1732 # 800083e8 <states.0+0xf0>
    80002ab4:	ffffe097          	auipc	ra,0xffffe
    80002ab8:	a8c080e7          	jalr	-1396(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002abc:	85ce                	mv	a1,s3
    80002abe:	00006517          	auipc	a0,0x6
    80002ac2:	94a50513          	addi	a0,a0,-1718 # 80008408 <states.0+0x110>
    80002ac6:	ffffe097          	auipc	ra,0xffffe
    80002aca:	ac4080e7          	jalr	-1340(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ace:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ad2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ad6:	00006517          	auipc	a0,0x6
    80002ada:	94250513          	addi	a0,a0,-1726 # 80008418 <states.0+0x120>
    80002ade:	ffffe097          	auipc	ra,0xffffe
    80002ae2:	aac080e7          	jalr	-1364(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002ae6:	00006517          	auipc	a0,0x6
    80002aea:	94a50513          	addi	a0,a0,-1718 # 80008430 <states.0+0x138>
    80002aee:	ffffe097          	auipc	ra,0xffffe
    80002af2:	a52080e7          	jalr	-1454(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002af6:	fffff097          	auipc	ra,0xfffff
    80002afa:	fe4080e7          	jalr	-28(ra) # 80001ada <myproc>
    80002afe:	d541                	beqz	a0,80002a86 <kerneltrap+0x38>
    80002b00:	fffff097          	auipc	ra,0xfffff
    80002b04:	fda080e7          	jalr	-38(ra) # 80001ada <myproc>
    80002b08:	4d18                	lw	a4,24(a0)
    80002b0a:	4791                	li	a5,4
    80002b0c:	f6f71de3          	bne	a4,a5,80002a86 <kerneltrap+0x38>
    yield();
    80002b10:	fffff097          	auipc	ra,0xfffff
    80002b14:	636080e7          	jalr	1590(ra) # 80002146 <yield>
    80002b18:	b7bd                	j	80002a86 <kerneltrap+0x38>

0000000080002b1a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b1a:	1101                	addi	sp,sp,-32
    80002b1c:	ec06                	sd	ra,24(sp)
    80002b1e:	e822                	sd	s0,16(sp)
    80002b20:	e426                	sd	s1,8(sp)
    80002b22:	1000                	addi	s0,sp,32
    80002b24:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b26:	fffff097          	auipc	ra,0xfffff
    80002b2a:	fb4080e7          	jalr	-76(ra) # 80001ada <myproc>
  switch (n) {
    80002b2e:	4795                	li	a5,5
    80002b30:	0497e163          	bltu	a5,s1,80002b72 <argraw+0x58>
    80002b34:	048a                	slli	s1,s1,0x2
    80002b36:	00006717          	auipc	a4,0x6
    80002b3a:	93270713          	addi	a4,a4,-1742 # 80008468 <states.0+0x170>
    80002b3e:	94ba                	add	s1,s1,a4
    80002b40:	409c                	lw	a5,0(s1)
    80002b42:	97ba                	add	a5,a5,a4
    80002b44:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b46:	6d3c                	ld	a5,88(a0)
    80002b48:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b4a:	60e2                	ld	ra,24(sp)
    80002b4c:	6442                	ld	s0,16(sp)
    80002b4e:	64a2                	ld	s1,8(sp)
    80002b50:	6105                	addi	sp,sp,32
    80002b52:	8082                	ret
    return p->trapframe->a1;
    80002b54:	6d3c                	ld	a5,88(a0)
    80002b56:	7fa8                	ld	a0,120(a5)
    80002b58:	bfcd                	j	80002b4a <argraw+0x30>
    return p->trapframe->a2;
    80002b5a:	6d3c                	ld	a5,88(a0)
    80002b5c:	63c8                	ld	a0,128(a5)
    80002b5e:	b7f5                	j	80002b4a <argraw+0x30>
    return p->trapframe->a3;
    80002b60:	6d3c                	ld	a5,88(a0)
    80002b62:	67c8                	ld	a0,136(a5)
    80002b64:	b7dd                	j	80002b4a <argraw+0x30>
    return p->trapframe->a4;
    80002b66:	6d3c                	ld	a5,88(a0)
    80002b68:	6bc8                	ld	a0,144(a5)
    80002b6a:	b7c5                	j	80002b4a <argraw+0x30>
    return p->trapframe->a5;
    80002b6c:	6d3c                	ld	a5,88(a0)
    80002b6e:	6fc8                	ld	a0,152(a5)
    80002b70:	bfe9                	j	80002b4a <argraw+0x30>
  panic("argraw");
    80002b72:	00006517          	auipc	a0,0x6
    80002b76:	8ce50513          	addi	a0,a0,-1842 # 80008440 <states.0+0x148>
    80002b7a:	ffffe097          	auipc	ra,0xffffe
    80002b7e:	9c6080e7          	jalr	-1594(ra) # 80000540 <panic>

0000000080002b82 <fetchaddr>:
{
    80002b82:	1101                	addi	sp,sp,-32
    80002b84:	ec06                	sd	ra,24(sp)
    80002b86:	e822                	sd	s0,16(sp)
    80002b88:	e426                	sd	s1,8(sp)
    80002b8a:	e04a                	sd	s2,0(sp)
    80002b8c:	1000                	addi	s0,sp,32
    80002b8e:	84aa                	mv	s1,a0
    80002b90:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b92:	fffff097          	auipc	ra,0xfffff
    80002b96:	f48080e7          	jalr	-184(ra) # 80001ada <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b9a:	653c                	ld	a5,72(a0)
    80002b9c:	02f4f863          	bgeu	s1,a5,80002bcc <fetchaddr+0x4a>
    80002ba0:	00848713          	addi	a4,s1,8
    80002ba4:	02e7e663          	bltu	a5,a4,80002bd0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ba8:	46a1                	li	a3,8
    80002baa:	8626                	mv	a2,s1
    80002bac:	85ca                	mv	a1,s2
    80002bae:	6928                	ld	a0,80(a0)
    80002bb0:	fffff097          	auipc	ra,0xfffff
    80002bb4:	b92080e7          	jalr	-1134(ra) # 80001742 <copyin>
    80002bb8:	00a03533          	snez	a0,a0
    80002bbc:	40a00533          	neg	a0,a0
}
    80002bc0:	60e2                	ld	ra,24(sp)
    80002bc2:	6442                	ld	s0,16(sp)
    80002bc4:	64a2                	ld	s1,8(sp)
    80002bc6:	6902                	ld	s2,0(sp)
    80002bc8:	6105                	addi	sp,sp,32
    80002bca:	8082                	ret
    return -1;
    80002bcc:	557d                	li	a0,-1
    80002bce:	bfcd                	j	80002bc0 <fetchaddr+0x3e>
    80002bd0:	557d                	li	a0,-1
    80002bd2:	b7fd                	j	80002bc0 <fetchaddr+0x3e>

0000000080002bd4 <fetchstr>:
{
    80002bd4:	7179                	addi	sp,sp,-48
    80002bd6:	f406                	sd	ra,40(sp)
    80002bd8:	f022                	sd	s0,32(sp)
    80002bda:	ec26                	sd	s1,24(sp)
    80002bdc:	e84a                	sd	s2,16(sp)
    80002bde:	e44e                	sd	s3,8(sp)
    80002be0:	1800                	addi	s0,sp,48
    80002be2:	892a                	mv	s2,a0
    80002be4:	84ae                	mv	s1,a1
    80002be6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002be8:	fffff097          	auipc	ra,0xfffff
    80002bec:	ef2080e7          	jalr	-270(ra) # 80001ada <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002bf0:	86ce                	mv	a3,s3
    80002bf2:	864a                	mv	a2,s2
    80002bf4:	85a6                	mv	a1,s1
    80002bf6:	6928                	ld	a0,80(a0)
    80002bf8:	fffff097          	auipc	ra,0xfffff
    80002bfc:	bd8080e7          	jalr	-1064(ra) # 800017d0 <copyinstr>
    80002c00:	00054e63          	bltz	a0,80002c1c <fetchstr+0x48>
  return strlen(buf);
    80002c04:	8526                	mv	a0,s1
    80002c06:	ffffe097          	auipc	ra,0xffffe
    80002c0a:	292080e7          	jalr	658(ra) # 80000e98 <strlen>
}
    80002c0e:	70a2                	ld	ra,40(sp)
    80002c10:	7402                	ld	s0,32(sp)
    80002c12:	64e2                	ld	s1,24(sp)
    80002c14:	6942                	ld	s2,16(sp)
    80002c16:	69a2                	ld	s3,8(sp)
    80002c18:	6145                	addi	sp,sp,48
    80002c1a:	8082                	ret
    return -1;
    80002c1c:	557d                	li	a0,-1
    80002c1e:	bfc5                	j	80002c0e <fetchstr+0x3a>

0000000080002c20 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002c20:	1101                	addi	sp,sp,-32
    80002c22:	ec06                	sd	ra,24(sp)
    80002c24:	e822                	sd	s0,16(sp)
    80002c26:	e426                	sd	s1,8(sp)
    80002c28:	1000                	addi	s0,sp,32
    80002c2a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	eee080e7          	jalr	-274(ra) # 80002b1a <argraw>
    80002c34:	c088                	sw	a0,0(s1)
}
    80002c36:	60e2                	ld	ra,24(sp)
    80002c38:	6442                	ld	s0,16(sp)
    80002c3a:	64a2                	ld	s1,8(sp)
    80002c3c:	6105                	addi	sp,sp,32
    80002c3e:	8082                	ret

0000000080002c40 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002c40:	1101                	addi	sp,sp,-32
    80002c42:	ec06                	sd	ra,24(sp)
    80002c44:	e822                	sd	s0,16(sp)
    80002c46:	e426                	sd	s1,8(sp)
    80002c48:	1000                	addi	s0,sp,32
    80002c4a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c4c:	00000097          	auipc	ra,0x0
    80002c50:	ece080e7          	jalr	-306(ra) # 80002b1a <argraw>
    80002c54:	e088                	sd	a0,0(s1)
}
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	64a2                	ld	s1,8(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret

0000000080002c60 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c60:	7179                	addi	sp,sp,-48
    80002c62:	f406                	sd	ra,40(sp)
    80002c64:	f022                	sd	s0,32(sp)
    80002c66:	ec26                	sd	s1,24(sp)
    80002c68:	e84a                	sd	s2,16(sp)
    80002c6a:	1800                	addi	s0,sp,48
    80002c6c:	84ae                	mv	s1,a1
    80002c6e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c70:	fd840593          	addi	a1,s0,-40
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	fcc080e7          	jalr	-52(ra) # 80002c40 <argaddr>
  return fetchstr(addr, buf, max);
    80002c7c:	864a                	mv	a2,s2
    80002c7e:	85a6                	mv	a1,s1
    80002c80:	fd843503          	ld	a0,-40(s0)
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	f50080e7          	jalr	-176(ra) # 80002bd4 <fetchstr>
}
    80002c8c:	70a2                	ld	ra,40(sp)
    80002c8e:	7402                	ld	s0,32(sp)
    80002c90:	64e2                	ld	s1,24(sp)
    80002c92:	6942                	ld	s2,16(sp)
    80002c94:	6145                	addi	sp,sp,48
    80002c96:	8082                	ret

0000000080002c98 <syscall>:
[SYS_pgaccess] sys_pgaccess,
};

void
syscall(void)
{
    80002c98:	1101                	addi	sp,sp,-32
    80002c9a:	ec06                	sd	ra,24(sp)
    80002c9c:	e822                	sd	s0,16(sp)
    80002c9e:	e426                	sd	s1,8(sp)
    80002ca0:	e04a                	sd	s2,0(sp)
    80002ca2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ca4:	fffff097          	auipc	ra,0xfffff
    80002ca8:	e36080e7          	jalr	-458(ra) # 80001ada <myproc>
    80002cac:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002cae:	05853903          	ld	s2,88(a0)
    80002cb2:	0a893783          	ld	a5,168(s2)
    80002cb6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cba:	37fd                	addiw	a5,a5,-1
    80002cbc:	4759                	li	a4,22
    80002cbe:	00f76f63          	bltu	a4,a5,80002cdc <syscall+0x44>
    80002cc2:	00369713          	slli	a4,a3,0x3
    80002cc6:	00005797          	auipc	a5,0x5
    80002cca:	7ba78793          	addi	a5,a5,1978 # 80008480 <syscalls>
    80002cce:	97ba                	add	a5,a5,a4
    80002cd0:	639c                	ld	a5,0(a5)
    80002cd2:	c789                	beqz	a5,80002cdc <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002cd4:	9782                	jalr	a5
    80002cd6:	06a93823          	sd	a0,112(s2)
    80002cda:	a839                	j	80002cf8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002cdc:	15848613          	addi	a2,s1,344
    80002ce0:	588c                	lw	a1,48(s1)
    80002ce2:	00005517          	auipc	a0,0x5
    80002ce6:	76650513          	addi	a0,a0,1894 # 80008448 <states.0+0x150>
    80002cea:	ffffe097          	auipc	ra,0xffffe
    80002cee:	8a0080e7          	jalr	-1888(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002cf2:	6cbc                	ld	a5,88(s1)
    80002cf4:	577d                	li	a4,-1
    80002cf6:	fbb8                	sd	a4,112(a5)
  }
}
    80002cf8:	60e2                	ld	ra,24(sp)
    80002cfa:	6442                	ld	s0,16(sp)
    80002cfc:	64a2                	ld	s1,8(sp)
    80002cfe:	6902                	ld	s2,0(sp)
    80002d00:	6105                	addi	sp,sp,32
    80002d02:	8082                	ret

0000000080002d04 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002d04:	1101                	addi	sp,sp,-32
    80002d06:	ec06                	sd	ra,24(sp)
    80002d08:	e822                	sd	s0,16(sp)
    80002d0a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002d0c:	fec40593          	addi	a1,s0,-20
    80002d10:	4501                	li	a0,0
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	f0e080e7          	jalr	-242(ra) # 80002c20 <argint>
  exit(n);
    80002d1a:	fec42503          	lw	a0,-20(s0)
    80002d1e:	fffff097          	auipc	ra,0xfffff
    80002d22:	598080e7          	jalr	1432(ra) # 800022b6 <exit>
  return 0;  // not reached
}
    80002d26:	4501                	li	a0,0
    80002d28:	60e2                	ld	ra,24(sp)
    80002d2a:	6442                	ld	s0,16(sp)
    80002d2c:	6105                	addi	sp,sp,32
    80002d2e:	8082                	ret

0000000080002d30 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d30:	1141                	addi	sp,sp,-16
    80002d32:	e406                	sd	ra,8(sp)
    80002d34:	e022                	sd	s0,0(sp)
    80002d36:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d38:	fffff097          	auipc	ra,0xfffff
    80002d3c:	da2080e7          	jalr	-606(ra) # 80001ada <myproc>
}
    80002d40:	5908                	lw	a0,48(a0)
    80002d42:	60a2                	ld	ra,8(sp)
    80002d44:	6402                	ld	s0,0(sp)
    80002d46:	0141                	addi	sp,sp,16
    80002d48:	8082                	ret

0000000080002d4a <sys_fork>:

uint64
sys_fork(void)
{
    80002d4a:	1141                	addi	sp,sp,-16
    80002d4c:	e406                	sd	ra,8(sp)
    80002d4e:	e022                	sd	s0,0(sp)
    80002d50:	0800                	addi	s0,sp,16
  return fork();
    80002d52:	fffff097          	auipc	ra,0xfffff
    80002d56:	13e080e7          	jalr	318(ra) # 80001e90 <fork>
}
    80002d5a:	60a2                	ld	ra,8(sp)
    80002d5c:	6402                	ld	s0,0(sp)
    80002d5e:	0141                	addi	sp,sp,16
    80002d60:	8082                	ret

0000000080002d62 <sys_wait>:

uint64
sys_wait(void)
{
    80002d62:	1101                	addi	sp,sp,-32
    80002d64:	ec06                	sd	ra,24(sp)
    80002d66:	e822                	sd	s0,16(sp)
    80002d68:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d6a:	fe840593          	addi	a1,s0,-24
    80002d6e:	4501                	li	a0,0
    80002d70:	00000097          	auipc	ra,0x0
    80002d74:	ed0080e7          	jalr	-304(ra) # 80002c40 <argaddr>
  return wait(p);
    80002d78:	fe843503          	ld	a0,-24(s0)
    80002d7c:	fffff097          	auipc	ra,0xfffff
    80002d80:	6e0080e7          	jalr	1760(ra) # 8000245c <wait>
}
    80002d84:	60e2                	ld	ra,24(sp)
    80002d86:	6442                	ld	s0,16(sp)
    80002d88:	6105                	addi	sp,sp,32
    80002d8a:	8082                	ret

0000000080002d8c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d8c:	7179                	addi	sp,sp,-48
    80002d8e:	f406                	sd	ra,40(sp)
    80002d90:	f022                	sd	s0,32(sp)
    80002d92:	ec26                	sd	s1,24(sp)
    80002d94:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d96:	fdc40593          	addi	a1,s0,-36
    80002d9a:	4501                	li	a0,0
    80002d9c:	00000097          	auipc	ra,0x0
    80002da0:	e84080e7          	jalr	-380(ra) # 80002c20 <argint>
  addr = myproc()->sz;
    80002da4:	fffff097          	auipc	ra,0xfffff
    80002da8:	d36080e7          	jalr	-714(ra) # 80001ada <myproc>
    80002dac:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002dae:	fdc42503          	lw	a0,-36(s0)
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	082080e7          	jalr	130(ra) # 80001e34 <growproc>
    80002dba:	00054863          	bltz	a0,80002dca <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002dbe:	8526                	mv	a0,s1
    80002dc0:	70a2                	ld	ra,40(sp)
    80002dc2:	7402                	ld	s0,32(sp)
    80002dc4:	64e2                	ld	s1,24(sp)
    80002dc6:	6145                	addi	sp,sp,48
    80002dc8:	8082                	ret
    return -1;
    80002dca:	54fd                	li	s1,-1
    80002dcc:	bfcd                	j	80002dbe <sys_sbrk+0x32>

0000000080002dce <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dce:	7139                	addi	sp,sp,-64
    80002dd0:	fc06                	sd	ra,56(sp)
    80002dd2:	f822                	sd	s0,48(sp)
    80002dd4:	f426                	sd	s1,40(sp)
    80002dd6:	f04a                	sd	s2,32(sp)
    80002dd8:	ec4e                	sd	s3,24(sp)
    80002dda:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ddc:	fcc40593          	addi	a1,s0,-52
    80002de0:	4501                	li	a0,0
    80002de2:	00000097          	auipc	ra,0x0
    80002de6:	e3e080e7          	jalr	-450(ra) # 80002c20 <argint>
  acquire(&tickslock);
    80002dea:	00014517          	auipc	a0,0x14
    80002dee:	bd650513          	addi	a0,a0,-1066 # 800169c0 <tickslock>
    80002df2:	ffffe097          	auipc	ra,0xffffe
    80002df6:	e2e080e7          	jalr	-466(ra) # 80000c20 <acquire>
  ticks0 = ticks;
    80002dfa:	00006917          	auipc	s2,0x6
    80002dfe:	b2e92903          	lw	s2,-1234(s2) # 80008928 <ticks>
  while(ticks - ticks0 < n){
    80002e02:	fcc42783          	lw	a5,-52(s0)
    80002e06:	cf9d                	beqz	a5,80002e44 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e08:	00014997          	auipc	s3,0x14
    80002e0c:	bb898993          	addi	s3,s3,-1096 # 800169c0 <tickslock>
    80002e10:	00006497          	auipc	s1,0x6
    80002e14:	b1848493          	addi	s1,s1,-1256 # 80008928 <ticks>
    if(killed(myproc())){
    80002e18:	fffff097          	auipc	ra,0xfffff
    80002e1c:	cc2080e7          	jalr	-830(ra) # 80001ada <myproc>
    80002e20:	fffff097          	auipc	ra,0xfffff
    80002e24:	60a080e7          	jalr	1546(ra) # 8000242a <killed>
    80002e28:	ed15                	bnez	a0,80002e64 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002e2a:	85ce                	mv	a1,s3
    80002e2c:	8526                	mv	a0,s1
    80002e2e:	fffff097          	auipc	ra,0xfffff
    80002e32:	354080e7          	jalr	852(ra) # 80002182 <sleep>
  while(ticks - ticks0 < n){
    80002e36:	409c                	lw	a5,0(s1)
    80002e38:	412787bb          	subw	a5,a5,s2
    80002e3c:	fcc42703          	lw	a4,-52(s0)
    80002e40:	fce7ece3          	bltu	a5,a4,80002e18 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002e44:	00014517          	auipc	a0,0x14
    80002e48:	b7c50513          	addi	a0,a0,-1156 # 800169c0 <tickslock>
    80002e4c:	ffffe097          	auipc	ra,0xffffe
    80002e50:	e88080e7          	jalr	-376(ra) # 80000cd4 <release>
  return 0;
    80002e54:	4501                	li	a0,0
}
    80002e56:	70e2                	ld	ra,56(sp)
    80002e58:	7442                	ld	s0,48(sp)
    80002e5a:	74a2                	ld	s1,40(sp)
    80002e5c:	7902                	ld	s2,32(sp)
    80002e5e:	69e2                	ld	s3,24(sp)
    80002e60:	6121                	addi	sp,sp,64
    80002e62:	8082                	ret
      release(&tickslock);
    80002e64:	00014517          	auipc	a0,0x14
    80002e68:	b5c50513          	addi	a0,a0,-1188 # 800169c0 <tickslock>
    80002e6c:	ffffe097          	auipc	ra,0xffffe
    80002e70:	e68080e7          	jalr	-408(ra) # 80000cd4 <release>
      return -1;
    80002e74:	557d                	li	a0,-1
    80002e76:	b7c5                	j	80002e56 <sys_sleep+0x88>

0000000080002e78 <sys_kill>:

uint64
sys_kill(void)
{
    80002e78:	1101                	addi	sp,sp,-32
    80002e7a:	ec06                	sd	ra,24(sp)
    80002e7c:	e822                	sd	s0,16(sp)
    80002e7e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e80:	fec40593          	addi	a1,s0,-20
    80002e84:	4501                	li	a0,0
    80002e86:	00000097          	auipc	ra,0x0
    80002e8a:	d9a080e7          	jalr	-614(ra) # 80002c20 <argint>
  return kill(pid);
    80002e8e:	fec42503          	lw	a0,-20(s0)
    80002e92:	fffff097          	auipc	ra,0xfffff
    80002e96:	4fa080e7          	jalr	1274(ra) # 8000238c <kill>
}
    80002e9a:	60e2                	ld	ra,24(sp)
    80002e9c:	6442                	ld	s0,16(sp)
    80002e9e:	6105                	addi	sp,sp,32
    80002ea0:	8082                	ret

0000000080002ea2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ea2:	1101                	addi	sp,sp,-32
    80002ea4:	ec06                	sd	ra,24(sp)
    80002ea6:	e822                	sd	s0,16(sp)
    80002ea8:	e426                	sd	s1,8(sp)
    80002eaa:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002eac:	00014517          	auipc	a0,0x14
    80002eb0:	b1450513          	addi	a0,a0,-1260 # 800169c0 <tickslock>
    80002eb4:	ffffe097          	auipc	ra,0xffffe
    80002eb8:	d6c080e7          	jalr	-660(ra) # 80000c20 <acquire>
  xticks = ticks;
    80002ebc:	00006497          	auipc	s1,0x6
    80002ec0:	a6c4a483          	lw	s1,-1428(s1) # 80008928 <ticks>
  release(&tickslock);
    80002ec4:	00014517          	auipc	a0,0x14
    80002ec8:	afc50513          	addi	a0,a0,-1284 # 800169c0 <tickslock>
    80002ecc:	ffffe097          	auipc	ra,0xffffe
    80002ed0:	e08080e7          	jalr	-504(ra) # 80000cd4 <release>
  return xticks;
}
    80002ed4:	02049513          	slli	a0,s1,0x20
    80002ed8:	9101                	srli	a0,a0,0x20
    80002eda:	60e2                	ld	ra,24(sp)
    80002edc:	6442                	ld	s0,16(sp)
    80002ede:	64a2                	ld	s1,8(sp)
    80002ee0:	6105                	addi	sp,sp,32
    80002ee2:	8082                	ret

0000000080002ee4 <sys_sysinfo>:

uint64 sys_sysinfo(void)
{
    80002ee4:	7179                	addi	sp,sp,-48
    80002ee6:	f406                	sd	ra,40(sp)
    80002ee8:	f022                	sd	s0,32(sp)
    80002eea:	1800                	addi	s0,sp,48
uint64 si_addr;
argaddr(0, &si_addr);
    80002eec:	fe840593          	addi	a1,s0,-24
    80002ef0:	4501                	li	a0,0
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	d4e080e7          	jalr	-690(ra) # 80002c40 <argaddr>

struct sysinfo systeminfo;
systeminfo.freemem = freememcnt();
    80002efa:	ffffe097          	auipc	ra,0xffffe
    80002efe:	c4c080e7          	jalr	-948(ra) # 80000b46 <freememcnt>
    80002f02:	fca43c23          	sd	a0,-40(s0)
systeminfo.nproc = proccnt();
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	7e0080e7          	jalr	2016(ra) # 800026e6 <proccnt>
    80002f0e:	fea43023          	sd	a0,-32(s0)

struct proc* p = myproc();
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	bc8080e7          	jalr	-1080(ra) # 80001ada <myproc>

int copyResult = copyout(p->pagetable, si_addr, (char*)&systeminfo, sizeof(systeminfo));
    80002f1a:	46c1                	li	a3,16
    80002f1c:	fd840613          	addi	a2,s0,-40
    80002f20:	fe843583          	ld	a1,-24(s0)
    80002f24:	6928                	ld	a0,80(a0)
    80002f26:	ffffe097          	auipc	ra,0xffffe
    80002f2a:	790080e7          	jalr	1936(ra) # 800016b6 <copyout>
switch (copyResult) {
    80002f2e:	0505                	addi	a0,a0,1
    80002f30:	00153513          	seqz	a0,a0
 case -1:
   return -1;
 default:
   return 0;
}
}
    80002f34:	40a00533          	neg	a0,a0
    80002f38:	70a2                	ld	ra,40(sp)
    80002f3a:	7402                	ld	s0,32(sp)
    80002f3c:	6145                	addi	sp,sp,48
    80002f3e:	8082                	ret

0000000080002f40 <sys_pgaccess>:

int sys_pgaccess(void) {
    80002f40:	715d                	addi	sp,sp,-80
    80002f42:	e486                	sd	ra,72(sp)
    80002f44:	e0a2                	sd	s0,64(sp)
    80002f46:	fc26                	sd	s1,56(sp)
    80002f48:	f84a                	sd	s2,48(sp)
    80002f4a:	f44e                	sd	s3,40(sp)
    80002f4c:	f052                	sd	s4,32(sp)
    80002f4e:	0880                	addi	s0,sp,80
 uint64 va;
 int page;
 uint64 ua;
 argaddr(0, &va);
    80002f50:	fc840593          	addi	a1,s0,-56
    80002f54:	4501                	li	a0,0
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	cea080e7          	jalr	-790(ra) # 80002c40 <argaddr>
 argint(1, &page);
    80002f5e:	fc440593          	addi	a1,s0,-60
    80002f62:	4505                	li	a0,1
    80002f64:	00000097          	auipc	ra,0x0
    80002f68:	cbc080e7          	jalr	-836(ra) # 80002c20 <argint>
 argaddr(2, &ua);
    80002f6c:	fb840593          	addi	a1,s0,-72
    80002f70:	4509                	li	a0,2
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	cce080e7          	jalr	-818(ra) # 80002c40 <argaddr>

 const int MAX_PAGE_LIMIT = 1024; 
 if (page > MAX_PAGE_LIMIT) {
    80002f7a:	fc442703          	lw	a4,-60(s0)
    80002f7e:	40000793          	li	a5,1024
    80002f82:	08e7cc63          	blt	a5,a4,8000301a <sys_pgaccess+0xda>
     return -1;
 }

 uint64 mask = 0;
    80002f86:	fa043823          	sd	zero,-80(s0)
 struct proc* p = myproc();
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	b50080e7          	jalr	-1200(ra) # 80001ada <myproc>
    80002f92:	89aa                	mv	s3,a0
 int i = 0;
 while (i < page) {
    80002f94:	fc442783          	lw	a5,-60(s0)
    80002f98:	04f05c63          	blez	a5,80002ff0 <sys_pgaccess+0xb0>
    80002f9c:	4481                	li	s1,0
     if (pte == 0) {
         return -1; // 页不存在时返回错误
     }
     switch (PTE_FLAGS(*pte) & PTE_A) {
         case PTE_A:
             mask |= (1L << i);
    80002f9e:	4a05                	li	s4,1
    80002fa0:	a801                	j	80002fb0 <sys_pgaccess+0x70>
 while (i < page) {
    80002fa2:	0485                	addi	s1,s1,1
    80002fa4:	fc442703          	lw	a4,-60(s0)
    80002fa8:	0004879b          	sext.w	a5,s1
    80002fac:	04e7d263          	bge	a5,a4,80002ff0 <sys_pgaccess+0xb0>
    80002fb0:	0004891b          	sext.w	s2,s1
     pte_t* pte = walk(p->pagetable, va + i * PGSIZE, 0);
    80002fb4:	00c49593          	slli	a1,s1,0xc
    80002fb8:	4601                	li	a2,0
    80002fba:	fc843783          	ld	a5,-56(s0)
    80002fbe:	95be                	add	a1,a1,a5
    80002fc0:	0509b503          	ld	a0,80(s3)
    80002fc4:	ffffe097          	auipc	ra,0xffffe
    80002fc8:	03c080e7          	jalr	60(ra) # 80001000 <walk>
     if (pte == 0) {
    80002fcc:	c929                	beqz	a0,8000301e <sys_pgaccess+0xde>
     switch (PTE_FLAGS(*pte) & PTE_A) {
    80002fce:	611c                	ld	a5,0(a0)
    80002fd0:	0407f793          	andi	a5,a5,64
    80002fd4:	d7f9                	beqz	a5,80002fa2 <sys_pgaccess+0x62>
             mask |= (1L << i);
    80002fd6:	012a1933          	sll	s2,s4,s2
    80002fda:	fb043783          	ld	a5,-80(s0)
    80002fde:	0127e7b3          	or	a5,a5,s2
    80002fe2:	faf43823          	sd	a5,-80(s0)
             *pte &= ~PTE_A; // 清除访问位
    80002fe6:	611c                	ld	a5,0(a0)
    80002fe8:	fbf7f793          	andi	a5,a5,-65
    80002fec:	e11c                	sd	a5,0(a0)
             break;
    80002fee:	bf55                	j	80002fa2 <sys_pgaccess+0x62>
             break;
     }
     i++;
 }

 if (copyout(p->pagetable, ua, (char*)&mask, sizeof(mask)) < 0) {
    80002ff0:	46a1                	li	a3,8
    80002ff2:	fb040613          	addi	a2,s0,-80
    80002ff6:	fb843583          	ld	a1,-72(s0)
    80002ffa:	0509b503          	ld	a0,80(s3)
    80002ffe:	ffffe097          	auipc	ra,0xffffe
    80003002:	6b8080e7          	jalr	1720(ra) # 800016b6 <copyout>
    80003006:	41f5551b          	sraiw	a0,a0,0x1f
     return -1; // 复制失败时返回错误
 }
 return 0;
    8000300a:	60a6                	ld	ra,72(sp)
    8000300c:	6406                	ld	s0,64(sp)
    8000300e:	74e2                	ld	s1,56(sp)
    80003010:	7942                	ld	s2,48(sp)
    80003012:	79a2                	ld	s3,40(sp)
    80003014:	7a02                	ld	s4,32(sp)
    80003016:	6161                	addi	sp,sp,80
    80003018:	8082                	ret
     return -1;
    8000301a:	557d                	li	a0,-1
    8000301c:	b7fd                	j	8000300a <sys_pgaccess+0xca>
         return -1; // 页不存在时返回错误
    8000301e:	557d                	li	a0,-1
    80003020:	b7ed                	j	8000300a <sys_pgaccess+0xca>

0000000080003022 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003022:	7179                	addi	sp,sp,-48
    80003024:	f406                	sd	ra,40(sp)
    80003026:	f022                	sd	s0,32(sp)
    80003028:	ec26                	sd	s1,24(sp)
    8000302a:	e84a                	sd	s2,16(sp)
    8000302c:	e44e                	sd	s3,8(sp)
    8000302e:	e052                	sd	s4,0(sp)
    80003030:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003032:	00005597          	auipc	a1,0x5
    80003036:	50e58593          	addi	a1,a1,1294 # 80008540 <syscalls+0xc0>
    8000303a:	00014517          	auipc	a0,0x14
    8000303e:	99e50513          	addi	a0,a0,-1634 # 800169d8 <bcache>
    80003042:	ffffe097          	auipc	ra,0xffffe
    80003046:	b4e080e7          	jalr	-1202(ra) # 80000b90 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000304a:	0001c797          	auipc	a5,0x1c
    8000304e:	98e78793          	addi	a5,a5,-1650 # 8001e9d8 <bcache+0x8000>
    80003052:	0001c717          	auipc	a4,0x1c
    80003056:	bee70713          	addi	a4,a4,-1042 # 8001ec40 <bcache+0x8268>
    8000305a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000305e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003062:	00014497          	auipc	s1,0x14
    80003066:	98e48493          	addi	s1,s1,-1650 # 800169f0 <bcache+0x18>
    b->next = bcache.head.next;
    8000306a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000306c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000306e:	00005a17          	auipc	s4,0x5
    80003072:	4daa0a13          	addi	s4,s4,1242 # 80008548 <syscalls+0xc8>
    b->next = bcache.head.next;
    80003076:	2b893783          	ld	a5,696(s2)
    8000307a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000307c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003080:	85d2                	mv	a1,s4
    80003082:	01048513          	addi	a0,s1,16
    80003086:	00001097          	auipc	ra,0x1
    8000308a:	62e080e7          	jalr	1582(ra) # 800046b4 <initsleeplock>
    bcache.head.next->prev = b;
    8000308e:	2b893783          	ld	a5,696(s2)
    80003092:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003094:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003098:	45848493          	addi	s1,s1,1112
    8000309c:	fd349de3          	bne	s1,s3,80003076 <binit+0x54>
  }
}
    800030a0:	70a2                	ld	ra,40(sp)
    800030a2:	7402                	ld	s0,32(sp)
    800030a4:	64e2                	ld	s1,24(sp)
    800030a6:	6942                	ld	s2,16(sp)
    800030a8:	69a2                	ld	s3,8(sp)
    800030aa:	6a02                	ld	s4,0(sp)
    800030ac:	6145                	addi	sp,sp,48
    800030ae:	8082                	ret

00000000800030b0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800030b0:	7179                	addi	sp,sp,-48
    800030b2:	f406                	sd	ra,40(sp)
    800030b4:	f022                	sd	s0,32(sp)
    800030b6:	ec26                	sd	s1,24(sp)
    800030b8:	e84a                	sd	s2,16(sp)
    800030ba:	e44e                	sd	s3,8(sp)
    800030bc:	1800                	addi	s0,sp,48
    800030be:	892a                	mv	s2,a0
    800030c0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800030c2:	00014517          	auipc	a0,0x14
    800030c6:	91650513          	addi	a0,a0,-1770 # 800169d8 <bcache>
    800030ca:	ffffe097          	auipc	ra,0xffffe
    800030ce:	b56080e7          	jalr	-1194(ra) # 80000c20 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030d2:	0001c497          	auipc	s1,0x1c
    800030d6:	bbe4b483          	ld	s1,-1090(s1) # 8001ec90 <bcache+0x82b8>
    800030da:	0001c797          	auipc	a5,0x1c
    800030de:	b6678793          	addi	a5,a5,-1178 # 8001ec40 <bcache+0x8268>
    800030e2:	02f48f63          	beq	s1,a5,80003120 <bread+0x70>
    800030e6:	873e                	mv	a4,a5
    800030e8:	a021                	j	800030f0 <bread+0x40>
    800030ea:	68a4                	ld	s1,80(s1)
    800030ec:	02e48a63          	beq	s1,a4,80003120 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800030f0:	449c                	lw	a5,8(s1)
    800030f2:	ff279ce3          	bne	a5,s2,800030ea <bread+0x3a>
    800030f6:	44dc                	lw	a5,12(s1)
    800030f8:	ff3799e3          	bne	a5,s3,800030ea <bread+0x3a>
      b->refcnt++;
    800030fc:	40bc                	lw	a5,64(s1)
    800030fe:	2785                	addiw	a5,a5,1
    80003100:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003102:	00014517          	auipc	a0,0x14
    80003106:	8d650513          	addi	a0,a0,-1834 # 800169d8 <bcache>
    8000310a:	ffffe097          	auipc	ra,0xffffe
    8000310e:	bca080e7          	jalr	-1078(ra) # 80000cd4 <release>
      acquiresleep(&b->lock);
    80003112:	01048513          	addi	a0,s1,16
    80003116:	00001097          	auipc	ra,0x1
    8000311a:	5d8080e7          	jalr	1496(ra) # 800046ee <acquiresleep>
      return b;
    8000311e:	a8b9                	j	8000317c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003120:	0001c497          	auipc	s1,0x1c
    80003124:	b684b483          	ld	s1,-1176(s1) # 8001ec88 <bcache+0x82b0>
    80003128:	0001c797          	auipc	a5,0x1c
    8000312c:	b1878793          	addi	a5,a5,-1256 # 8001ec40 <bcache+0x8268>
    80003130:	00f48863          	beq	s1,a5,80003140 <bread+0x90>
    80003134:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003136:	40bc                	lw	a5,64(s1)
    80003138:	cf81                	beqz	a5,80003150 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000313a:	64a4                	ld	s1,72(s1)
    8000313c:	fee49de3          	bne	s1,a4,80003136 <bread+0x86>
  panic("bget: no buffers");
    80003140:	00005517          	auipc	a0,0x5
    80003144:	41050513          	addi	a0,a0,1040 # 80008550 <syscalls+0xd0>
    80003148:	ffffd097          	auipc	ra,0xffffd
    8000314c:	3f8080e7          	jalr	1016(ra) # 80000540 <panic>
      b->dev = dev;
    80003150:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003154:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003158:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000315c:	4785                	li	a5,1
    8000315e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003160:	00014517          	auipc	a0,0x14
    80003164:	87850513          	addi	a0,a0,-1928 # 800169d8 <bcache>
    80003168:	ffffe097          	auipc	ra,0xffffe
    8000316c:	b6c080e7          	jalr	-1172(ra) # 80000cd4 <release>
      acquiresleep(&b->lock);
    80003170:	01048513          	addi	a0,s1,16
    80003174:	00001097          	auipc	ra,0x1
    80003178:	57a080e7          	jalr	1402(ra) # 800046ee <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000317c:	409c                	lw	a5,0(s1)
    8000317e:	cb89                	beqz	a5,80003190 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003180:	8526                	mv	a0,s1
    80003182:	70a2                	ld	ra,40(sp)
    80003184:	7402                	ld	s0,32(sp)
    80003186:	64e2                	ld	s1,24(sp)
    80003188:	6942                	ld	s2,16(sp)
    8000318a:	69a2                	ld	s3,8(sp)
    8000318c:	6145                	addi	sp,sp,48
    8000318e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003190:	4581                	li	a1,0
    80003192:	8526                	mv	a0,s1
    80003194:	00003097          	auipc	ra,0x3
    80003198:	15e080e7          	jalr	350(ra) # 800062f2 <virtio_disk_rw>
    b->valid = 1;
    8000319c:	4785                	li	a5,1
    8000319e:	c09c                	sw	a5,0(s1)
  return b;
    800031a0:	b7c5                	j	80003180 <bread+0xd0>

00000000800031a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800031a2:	1101                	addi	sp,sp,-32
    800031a4:	ec06                	sd	ra,24(sp)
    800031a6:	e822                	sd	s0,16(sp)
    800031a8:	e426                	sd	s1,8(sp)
    800031aa:	1000                	addi	s0,sp,32
    800031ac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031ae:	0541                	addi	a0,a0,16
    800031b0:	00001097          	auipc	ra,0x1
    800031b4:	5d8080e7          	jalr	1496(ra) # 80004788 <holdingsleep>
    800031b8:	cd01                	beqz	a0,800031d0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800031ba:	4585                	li	a1,1
    800031bc:	8526                	mv	a0,s1
    800031be:	00003097          	auipc	ra,0x3
    800031c2:	134080e7          	jalr	308(ra) # 800062f2 <virtio_disk_rw>
}
    800031c6:	60e2                	ld	ra,24(sp)
    800031c8:	6442                	ld	s0,16(sp)
    800031ca:	64a2                	ld	s1,8(sp)
    800031cc:	6105                	addi	sp,sp,32
    800031ce:	8082                	ret
    panic("bwrite");
    800031d0:	00005517          	auipc	a0,0x5
    800031d4:	39850513          	addi	a0,a0,920 # 80008568 <syscalls+0xe8>
    800031d8:	ffffd097          	auipc	ra,0xffffd
    800031dc:	368080e7          	jalr	872(ra) # 80000540 <panic>

00000000800031e0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800031e0:	1101                	addi	sp,sp,-32
    800031e2:	ec06                	sd	ra,24(sp)
    800031e4:	e822                	sd	s0,16(sp)
    800031e6:	e426                	sd	s1,8(sp)
    800031e8:	e04a                	sd	s2,0(sp)
    800031ea:	1000                	addi	s0,sp,32
    800031ec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031ee:	01050913          	addi	s2,a0,16
    800031f2:	854a                	mv	a0,s2
    800031f4:	00001097          	auipc	ra,0x1
    800031f8:	594080e7          	jalr	1428(ra) # 80004788 <holdingsleep>
    800031fc:	c92d                	beqz	a0,8000326e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800031fe:	854a                	mv	a0,s2
    80003200:	00001097          	auipc	ra,0x1
    80003204:	544080e7          	jalr	1348(ra) # 80004744 <releasesleep>

  acquire(&bcache.lock);
    80003208:	00013517          	auipc	a0,0x13
    8000320c:	7d050513          	addi	a0,a0,2000 # 800169d8 <bcache>
    80003210:	ffffe097          	auipc	ra,0xffffe
    80003214:	a10080e7          	jalr	-1520(ra) # 80000c20 <acquire>
  b->refcnt--;
    80003218:	40bc                	lw	a5,64(s1)
    8000321a:	37fd                	addiw	a5,a5,-1
    8000321c:	0007871b          	sext.w	a4,a5
    80003220:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003222:	eb05                	bnez	a4,80003252 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003224:	68bc                	ld	a5,80(s1)
    80003226:	64b8                	ld	a4,72(s1)
    80003228:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000322a:	64bc                	ld	a5,72(s1)
    8000322c:	68b8                	ld	a4,80(s1)
    8000322e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003230:	0001b797          	auipc	a5,0x1b
    80003234:	7a878793          	addi	a5,a5,1960 # 8001e9d8 <bcache+0x8000>
    80003238:	2b87b703          	ld	a4,696(a5)
    8000323c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000323e:	0001c717          	auipc	a4,0x1c
    80003242:	a0270713          	addi	a4,a4,-1534 # 8001ec40 <bcache+0x8268>
    80003246:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003248:	2b87b703          	ld	a4,696(a5)
    8000324c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000324e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003252:	00013517          	auipc	a0,0x13
    80003256:	78650513          	addi	a0,a0,1926 # 800169d8 <bcache>
    8000325a:	ffffe097          	auipc	ra,0xffffe
    8000325e:	a7a080e7          	jalr	-1414(ra) # 80000cd4 <release>
}
    80003262:	60e2                	ld	ra,24(sp)
    80003264:	6442                	ld	s0,16(sp)
    80003266:	64a2                	ld	s1,8(sp)
    80003268:	6902                	ld	s2,0(sp)
    8000326a:	6105                	addi	sp,sp,32
    8000326c:	8082                	ret
    panic("brelse");
    8000326e:	00005517          	auipc	a0,0x5
    80003272:	30250513          	addi	a0,a0,770 # 80008570 <syscalls+0xf0>
    80003276:	ffffd097          	auipc	ra,0xffffd
    8000327a:	2ca080e7          	jalr	714(ra) # 80000540 <panic>

000000008000327e <bpin>:

void
bpin(struct buf *b) {
    8000327e:	1101                	addi	sp,sp,-32
    80003280:	ec06                	sd	ra,24(sp)
    80003282:	e822                	sd	s0,16(sp)
    80003284:	e426                	sd	s1,8(sp)
    80003286:	1000                	addi	s0,sp,32
    80003288:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000328a:	00013517          	auipc	a0,0x13
    8000328e:	74e50513          	addi	a0,a0,1870 # 800169d8 <bcache>
    80003292:	ffffe097          	auipc	ra,0xffffe
    80003296:	98e080e7          	jalr	-1650(ra) # 80000c20 <acquire>
  b->refcnt++;
    8000329a:	40bc                	lw	a5,64(s1)
    8000329c:	2785                	addiw	a5,a5,1
    8000329e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032a0:	00013517          	auipc	a0,0x13
    800032a4:	73850513          	addi	a0,a0,1848 # 800169d8 <bcache>
    800032a8:	ffffe097          	auipc	ra,0xffffe
    800032ac:	a2c080e7          	jalr	-1492(ra) # 80000cd4 <release>
}
    800032b0:	60e2                	ld	ra,24(sp)
    800032b2:	6442                	ld	s0,16(sp)
    800032b4:	64a2                	ld	s1,8(sp)
    800032b6:	6105                	addi	sp,sp,32
    800032b8:	8082                	ret

00000000800032ba <bunpin>:

void
bunpin(struct buf *b) {
    800032ba:	1101                	addi	sp,sp,-32
    800032bc:	ec06                	sd	ra,24(sp)
    800032be:	e822                	sd	s0,16(sp)
    800032c0:	e426                	sd	s1,8(sp)
    800032c2:	1000                	addi	s0,sp,32
    800032c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800032c6:	00013517          	auipc	a0,0x13
    800032ca:	71250513          	addi	a0,a0,1810 # 800169d8 <bcache>
    800032ce:	ffffe097          	auipc	ra,0xffffe
    800032d2:	952080e7          	jalr	-1710(ra) # 80000c20 <acquire>
  b->refcnt--;
    800032d6:	40bc                	lw	a5,64(s1)
    800032d8:	37fd                	addiw	a5,a5,-1
    800032da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032dc:	00013517          	auipc	a0,0x13
    800032e0:	6fc50513          	addi	a0,a0,1788 # 800169d8 <bcache>
    800032e4:	ffffe097          	auipc	ra,0xffffe
    800032e8:	9f0080e7          	jalr	-1552(ra) # 80000cd4 <release>
}
    800032ec:	60e2                	ld	ra,24(sp)
    800032ee:	6442                	ld	s0,16(sp)
    800032f0:	64a2                	ld	s1,8(sp)
    800032f2:	6105                	addi	sp,sp,32
    800032f4:	8082                	ret

00000000800032f6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032f6:	1101                	addi	sp,sp,-32
    800032f8:	ec06                	sd	ra,24(sp)
    800032fa:	e822                	sd	s0,16(sp)
    800032fc:	e426                	sd	s1,8(sp)
    800032fe:	e04a                	sd	s2,0(sp)
    80003300:	1000                	addi	s0,sp,32
    80003302:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003304:	00d5d59b          	srliw	a1,a1,0xd
    80003308:	0001c797          	auipc	a5,0x1c
    8000330c:	dac7a783          	lw	a5,-596(a5) # 8001f0b4 <sb+0x1c>
    80003310:	9dbd                	addw	a1,a1,a5
    80003312:	00000097          	auipc	ra,0x0
    80003316:	d9e080e7          	jalr	-610(ra) # 800030b0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000331a:	0074f713          	andi	a4,s1,7
    8000331e:	4785                	li	a5,1
    80003320:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003324:	14ce                	slli	s1,s1,0x33
    80003326:	90d9                	srli	s1,s1,0x36
    80003328:	00950733          	add	a4,a0,s1
    8000332c:	05874703          	lbu	a4,88(a4)
    80003330:	00e7f6b3          	and	a3,a5,a4
    80003334:	c69d                	beqz	a3,80003362 <bfree+0x6c>
    80003336:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003338:	94aa                	add	s1,s1,a0
    8000333a:	fff7c793          	not	a5,a5
    8000333e:	8f7d                	and	a4,a4,a5
    80003340:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003344:	00001097          	auipc	ra,0x1
    80003348:	28c080e7          	jalr	652(ra) # 800045d0 <log_write>
  brelse(bp);
    8000334c:	854a                	mv	a0,s2
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	e92080e7          	jalr	-366(ra) # 800031e0 <brelse>
}
    80003356:	60e2                	ld	ra,24(sp)
    80003358:	6442                	ld	s0,16(sp)
    8000335a:	64a2                	ld	s1,8(sp)
    8000335c:	6902                	ld	s2,0(sp)
    8000335e:	6105                	addi	sp,sp,32
    80003360:	8082                	ret
    panic("freeing free block");
    80003362:	00005517          	auipc	a0,0x5
    80003366:	21650513          	addi	a0,a0,534 # 80008578 <syscalls+0xf8>
    8000336a:	ffffd097          	auipc	ra,0xffffd
    8000336e:	1d6080e7          	jalr	470(ra) # 80000540 <panic>

0000000080003372 <balloc>:
{
    80003372:	711d                	addi	sp,sp,-96
    80003374:	ec86                	sd	ra,88(sp)
    80003376:	e8a2                	sd	s0,80(sp)
    80003378:	e4a6                	sd	s1,72(sp)
    8000337a:	e0ca                	sd	s2,64(sp)
    8000337c:	fc4e                	sd	s3,56(sp)
    8000337e:	f852                	sd	s4,48(sp)
    80003380:	f456                	sd	s5,40(sp)
    80003382:	f05a                	sd	s6,32(sp)
    80003384:	ec5e                	sd	s7,24(sp)
    80003386:	e862                	sd	s8,16(sp)
    80003388:	e466                	sd	s9,8(sp)
    8000338a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000338c:	0001c797          	auipc	a5,0x1c
    80003390:	d107a783          	lw	a5,-752(a5) # 8001f09c <sb+0x4>
    80003394:	cff5                	beqz	a5,80003490 <balloc+0x11e>
    80003396:	8baa                	mv	s7,a0
    80003398:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000339a:	0001cb17          	auipc	s6,0x1c
    8000339e:	cfeb0b13          	addi	s6,s6,-770 # 8001f098 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033a2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800033a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800033a8:	6c89                	lui	s9,0x2
    800033aa:	a061                	j	80003432 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800033ac:	97ca                	add	a5,a5,s2
    800033ae:	8e55                	or	a2,a2,a3
    800033b0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800033b4:	854a                	mv	a0,s2
    800033b6:	00001097          	auipc	ra,0x1
    800033ba:	21a080e7          	jalr	538(ra) # 800045d0 <log_write>
        brelse(bp);
    800033be:	854a                	mv	a0,s2
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	e20080e7          	jalr	-480(ra) # 800031e0 <brelse>
  bp = bread(dev, bno);
    800033c8:	85a6                	mv	a1,s1
    800033ca:	855e                	mv	a0,s7
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	ce4080e7          	jalr	-796(ra) # 800030b0 <bread>
    800033d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800033d6:	40000613          	li	a2,1024
    800033da:	4581                	li	a1,0
    800033dc:	05850513          	addi	a0,a0,88
    800033e0:	ffffe097          	auipc	ra,0xffffe
    800033e4:	93c080e7          	jalr	-1732(ra) # 80000d1c <memset>
  log_write(bp);
    800033e8:	854a                	mv	a0,s2
    800033ea:	00001097          	auipc	ra,0x1
    800033ee:	1e6080e7          	jalr	486(ra) # 800045d0 <log_write>
  brelse(bp);
    800033f2:	854a                	mv	a0,s2
    800033f4:	00000097          	auipc	ra,0x0
    800033f8:	dec080e7          	jalr	-532(ra) # 800031e0 <brelse>
}
    800033fc:	8526                	mv	a0,s1
    800033fe:	60e6                	ld	ra,88(sp)
    80003400:	6446                	ld	s0,80(sp)
    80003402:	64a6                	ld	s1,72(sp)
    80003404:	6906                	ld	s2,64(sp)
    80003406:	79e2                	ld	s3,56(sp)
    80003408:	7a42                	ld	s4,48(sp)
    8000340a:	7aa2                	ld	s5,40(sp)
    8000340c:	7b02                	ld	s6,32(sp)
    8000340e:	6be2                	ld	s7,24(sp)
    80003410:	6c42                	ld	s8,16(sp)
    80003412:	6ca2                	ld	s9,8(sp)
    80003414:	6125                	addi	sp,sp,96
    80003416:	8082                	ret
    brelse(bp);
    80003418:	854a                	mv	a0,s2
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	dc6080e7          	jalr	-570(ra) # 800031e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003422:	015c87bb          	addw	a5,s9,s5
    80003426:	00078a9b          	sext.w	s5,a5
    8000342a:	004b2703          	lw	a4,4(s6)
    8000342e:	06eaf163          	bgeu	s5,a4,80003490 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003432:	41fad79b          	sraiw	a5,s5,0x1f
    80003436:	0137d79b          	srliw	a5,a5,0x13
    8000343a:	015787bb          	addw	a5,a5,s5
    8000343e:	40d7d79b          	sraiw	a5,a5,0xd
    80003442:	01cb2583          	lw	a1,28(s6)
    80003446:	9dbd                	addw	a1,a1,a5
    80003448:	855e                	mv	a0,s7
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	c66080e7          	jalr	-922(ra) # 800030b0 <bread>
    80003452:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003454:	004b2503          	lw	a0,4(s6)
    80003458:	000a849b          	sext.w	s1,s5
    8000345c:	8762                	mv	a4,s8
    8000345e:	faa4fde3          	bgeu	s1,a0,80003418 <balloc+0xa6>
      m = 1 << (bi % 8);
    80003462:	00777693          	andi	a3,a4,7
    80003466:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000346a:	41f7579b          	sraiw	a5,a4,0x1f
    8000346e:	01d7d79b          	srliw	a5,a5,0x1d
    80003472:	9fb9                	addw	a5,a5,a4
    80003474:	4037d79b          	sraiw	a5,a5,0x3
    80003478:	00f90633          	add	a2,s2,a5
    8000347c:	05864603          	lbu	a2,88(a2)
    80003480:	00c6f5b3          	and	a1,a3,a2
    80003484:	d585                	beqz	a1,800033ac <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003486:	2705                	addiw	a4,a4,1
    80003488:	2485                	addiw	s1,s1,1
    8000348a:	fd471ae3          	bne	a4,s4,8000345e <balloc+0xec>
    8000348e:	b769                	j	80003418 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003490:	00005517          	auipc	a0,0x5
    80003494:	10050513          	addi	a0,a0,256 # 80008590 <syscalls+0x110>
    80003498:	ffffd097          	auipc	ra,0xffffd
    8000349c:	0f2080e7          	jalr	242(ra) # 8000058a <printf>
  return 0;
    800034a0:	4481                	li	s1,0
    800034a2:	bfa9                	j	800033fc <balloc+0x8a>

00000000800034a4 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode* ip, uint bn) {
    800034a4:	7139                	addi	sp,sp,-64
    800034a6:	fc06                	sd	ra,56(sp)
    800034a8:	f822                	sd	s0,48(sp)
    800034aa:	f426                	sd	s1,40(sp)
    800034ac:	f04a                	sd	s2,32(sp)
    800034ae:	ec4e                	sd	s3,24(sp)
    800034b0:	e852                	sd	s4,16(sp)
    800034b2:	e456                	sd	s5,8(sp)
    800034b4:	0080                	addi	s0,sp,64
    800034b6:	89aa                	mv	s3,a0
uint addr, * a;
struct buf* bp;

switch (bn < NDIRECT) {
    800034b8:	47a9                	li	a5,10
    800034ba:	04b7e063          	bltu	a5,a1,800034fa <bmap+0x56>
   case 1:
       addr = ip->addrs[bn];
    800034be:	02059793          	slli	a5,a1,0x20
    800034c2:	01e7d593          	srli	a1,a5,0x1e
    800034c6:	00b504b3          	add	s1,a0,a1
    800034ca:	0504a903          	lw	s2,80(s1)
       switch (addr) {
    800034ce:	00090c63          	beqz	s2,800034e6 <bmap+0x42>
       brelse(bp);
       return addr;
}

panic("bmap: out of range");
}
    800034d2:	854a                	mv	a0,s2
    800034d4:	70e2                	ld	ra,56(sp)
    800034d6:	7442                	ld	s0,48(sp)
    800034d8:	74a2                	ld	s1,40(sp)
    800034da:	7902                	ld	s2,32(sp)
    800034dc:	69e2                	ld	s3,24(sp)
    800034de:	6a42                	ld	s4,16(sp)
    800034e0:	6aa2                	ld	s5,8(sp)
    800034e2:	6121                	addi	sp,sp,64
    800034e4:	8082                	ret
               ip->addrs[bn] = addr = balloc(ip->dev);
    800034e6:	4108                	lw	a0,0(a0)
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	e8a080e7          	jalr	-374(ra) # 80003372 <balloc>
    800034f0:	0005091b          	sext.w	s2,a0
    800034f4:	0524a823          	sw	s2,80(s1)
               break;
    800034f8:	bfe9                	j	800034d2 <bmap+0x2e>
bn -= NDIRECT;
    800034fa:	ff55849b          	addiw	s1,a1,-11
    800034fe:	0004871b          	sext.w	a4,s1
switch (bn < NINDIRECT) {
    80003502:	0ff00793          	li	a5,255
    80003506:	06e7e663          	bltu	a5,a4,80003572 <bmap+0xce>
       addr = ip->addrs[NDIRECT];
    8000350a:	5d6c                	lw	a1,124(a0)
       switch (addr) {
    8000350c:	c98d                	beqz	a1,8000353e <bmap+0x9a>
       bp = bread(ip->dev, addr);
    8000350e:	0009a503          	lw	a0,0(s3)
    80003512:	00000097          	auipc	ra,0x0
    80003516:	b9e080e7          	jalr	-1122(ra) # 800030b0 <bread>
    8000351a:	8a2a                	mv	s4,a0
       a = (uint*)bp->data;
    8000351c:	05850793          	addi	a5,a0,88
       addr = a[bn];
    80003520:	02049713          	slli	a4,s1,0x20
    80003524:	01e75493          	srli	s1,a4,0x1e
    80003528:	94be                	add	s1,s1,a5
    8000352a:	0004a903          	lw	s2,0(s1)
       switch (addr) {
    8000352e:	02090263          	beqz	s2,80003552 <bmap+0xae>
       brelse(bp);
    80003532:	8552                	mv	a0,s4
    80003534:	00000097          	auipc	ra,0x0
    80003538:	cac080e7          	jalr	-852(ra) # 800031e0 <brelse>
       return addr;
    8000353c:	bf59                	j	800034d2 <bmap+0x2e>
               ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000353e:	4108                	lw	a0,0(a0)
    80003540:	00000097          	auipc	ra,0x0
    80003544:	e32080e7          	jalr	-462(ra) # 80003372 <balloc>
    80003548:	0005059b          	sext.w	a1,a0
    8000354c:	06b9ae23          	sw	a1,124(s3)
               break;
    80003550:	bf7d                	j	8000350e <bmap+0x6a>
               a[bn] = addr = balloc(ip->dev);
    80003552:	0009a503          	lw	a0,0(s3)
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	e1c080e7          	jalr	-484(ra) # 80003372 <balloc>
    8000355e:	0005091b          	sext.w	s2,a0
    80003562:	0124a023          	sw	s2,0(s1)
               log_write(bp);
    80003566:	8552                	mv	a0,s4
    80003568:	00001097          	auipc	ra,0x1
    8000356c:	068080e7          	jalr	104(ra) # 800045d0 <log_write>
               break;
    80003570:	b7c9                	j	80003532 <bmap+0x8e>
bn -= NINDIRECT;
    80003572:	ef55849b          	addiw	s1,a1,-267
    80003576:	0004871b          	sext.w	a4,s1
switch (bn < NDUOINDIRECT) {
    8000357a:	67c1                	lui	a5,0x10
    8000357c:	0af77e63          	bgeu	a4,a5,80003638 <bmap+0x194>
       addr = ip->addrs[NDIRECT + 1];
    80003580:	08052583          	lw	a1,128(a0)
       switch (addr) {
    80003584:	c1a5                	beqz	a1,800035e4 <bmap+0x140>
       bp = bread(ip->dev, addr);
    80003586:	0009a503          	lw	a0,0(s3)
    8000358a:	00000097          	auipc	ra,0x0
    8000358e:	b26080e7          	jalr	-1242(ra) # 800030b0 <bread>
    80003592:	892a                	mv	s2,a0
       a = (uint*)bp->data;
    80003594:	05850a13          	addi	s4,a0,88
       addr = a[bn / NINDIRECT];
    80003598:	0084d79b          	srliw	a5,s1,0x8
    8000359c:	078a                	slli	a5,a5,0x2
    8000359e:	9a3e                	add	s4,s4,a5
    800035a0:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
       switch (addr) {
    800035a4:	040a8a63          	beqz	s5,800035f8 <bmap+0x154>
       brelse(bp);
    800035a8:	854a                	mv	a0,s2
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	c36080e7          	jalr	-970(ra) # 800031e0 <brelse>
       bp = bread(ip->dev, addr);
    800035b2:	85d6                	mv	a1,s5
    800035b4:	0009a503          	lw	a0,0(s3)
    800035b8:	00000097          	auipc	ra,0x0
    800035bc:	af8080e7          	jalr	-1288(ra) # 800030b0 <bread>
    800035c0:	8a2a                	mv	s4,a0
       a = (uint*)bp->data;
    800035c2:	05850793          	addi	a5,a0,88
       addr = a[bn % NINDIRECT];
    800035c6:	0ff4f593          	zext.b	a1,s1
    800035ca:	058a                	slli	a1,a1,0x2
    800035cc:	00b784b3          	add	s1,a5,a1
    800035d0:	0004a903          	lw	s2,0(s1)
       switch (addr) {
    800035d4:	04090263          	beqz	s2,80003618 <bmap+0x174>
       brelse(bp);
    800035d8:	8552                	mv	a0,s4
    800035da:	00000097          	auipc	ra,0x0
    800035de:	c06080e7          	jalr	-1018(ra) # 800031e0 <brelse>
       return addr;
    800035e2:	bdc5                	j	800034d2 <bmap+0x2e>
               ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    800035e4:	4108                	lw	a0,0(a0)
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	d8c080e7          	jalr	-628(ra) # 80003372 <balloc>
    800035ee:	0005059b          	sext.w	a1,a0
    800035f2:	08b9a023          	sw	a1,128(s3)
               break;
    800035f6:	bf41                	j	80003586 <bmap+0xe2>
               a[bn / NINDIRECT] = addr = balloc(ip->dev);
    800035f8:	0009a503          	lw	a0,0(s3)
    800035fc:	00000097          	auipc	ra,0x0
    80003600:	d76080e7          	jalr	-650(ra) # 80003372 <balloc>
    80003604:	00050a9b          	sext.w	s5,a0
    80003608:	015a2023          	sw	s5,0(s4)
               log_write(bp);
    8000360c:	854a                	mv	a0,s2
    8000360e:	00001097          	auipc	ra,0x1
    80003612:	fc2080e7          	jalr	-62(ra) # 800045d0 <log_write>
               break;
    80003616:	bf49                	j	800035a8 <bmap+0x104>
               a[bn % NINDIRECT] = addr = balloc(ip->dev);
    80003618:	0009a503          	lw	a0,0(s3)
    8000361c:	00000097          	auipc	ra,0x0
    80003620:	d56080e7          	jalr	-682(ra) # 80003372 <balloc>
    80003624:	0005091b          	sext.w	s2,a0
    80003628:	0124a023          	sw	s2,0(s1)
               log_write(bp);
    8000362c:	8552                	mv	a0,s4
    8000362e:	00001097          	auipc	ra,0x1
    80003632:	fa2080e7          	jalr	-94(ra) # 800045d0 <log_write>
               break;
    80003636:	b74d                	j	800035d8 <bmap+0x134>
panic("bmap: out of range");
    80003638:	00005517          	auipc	a0,0x5
    8000363c:	f7050513          	addi	a0,a0,-144 # 800085a8 <syscalls+0x128>
    80003640:	ffffd097          	auipc	ra,0xffffd
    80003644:	f00080e7          	jalr	-256(ra) # 80000540 <panic>

0000000080003648 <iget>:
{
    80003648:	7179                	addi	sp,sp,-48
    8000364a:	f406                	sd	ra,40(sp)
    8000364c:	f022                	sd	s0,32(sp)
    8000364e:	ec26                	sd	s1,24(sp)
    80003650:	e84a                	sd	s2,16(sp)
    80003652:	e44e                	sd	s3,8(sp)
    80003654:	e052                	sd	s4,0(sp)
    80003656:	1800                	addi	s0,sp,48
    80003658:	89aa                	mv	s3,a0
    8000365a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000365c:	0001c517          	auipc	a0,0x1c
    80003660:	a5c50513          	addi	a0,a0,-1444 # 8001f0b8 <itable>
    80003664:	ffffd097          	auipc	ra,0xffffd
    80003668:	5bc080e7          	jalr	1468(ra) # 80000c20 <acquire>
  empty = 0;
    8000366c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000366e:	0001c497          	auipc	s1,0x1c
    80003672:	a6248493          	addi	s1,s1,-1438 # 8001f0d0 <itable+0x18>
    80003676:	0001d697          	auipc	a3,0x1d
    8000367a:	4ea68693          	addi	a3,a3,1258 # 80020b60 <log>
    8000367e:	a039                	j	8000368c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003680:	02090b63          	beqz	s2,800036b6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003684:	08848493          	addi	s1,s1,136
    80003688:	02d48a63          	beq	s1,a3,800036bc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000368c:	449c                	lw	a5,8(s1)
    8000368e:	fef059e3          	blez	a5,80003680 <iget+0x38>
    80003692:	4098                	lw	a4,0(s1)
    80003694:	ff3716e3          	bne	a4,s3,80003680 <iget+0x38>
    80003698:	40d8                	lw	a4,4(s1)
    8000369a:	ff4713e3          	bne	a4,s4,80003680 <iget+0x38>
      ip->ref++;
    8000369e:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    800036a0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800036a2:	0001c517          	auipc	a0,0x1c
    800036a6:	a1650513          	addi	a0,a0,-1514 # 8001f0b8 <itable>
    800036aa:	ffffd097          	auipc	ra,0xffffd
    800036ae:	62a080e7          	jalr	1578(ra) # 80000cd4 <release>
      return ip;
    800036b2:	8926                	mv	s2,s1
    800036b4:	a03d                	j	800036e2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800036b6:	f7f9                	bnez	a5,80003684 <iget+0x3c>
    800036b8:	8926                	mv	s2,s1
    800036ba:	b7e9                	j	80003684 <iget+0x3c>
  if(empty == 0)
    800036bc:	02090c63          	beqz	s2,800036f4 <iget+0xac>
  ip->dev = dev;
    800036c0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800036c4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800036c8:	4785                	li	a5,1
    800036ca:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800036ce:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800036d2:	0001c517          	auipc	a0,0x1c
    800036d6:	9e650513          	addi	a0,a0,-1562 # 8001f0b8 <itable>
    800036da:	ffffd097          	auipc	ra,0xffffd
    800036de:	5fa080e7          	jalr	1530(ra) # 80000cd4 <release>
}
    800036e2:	854a                	mv	a0,s2
    800036e4:	70a2                	ld	ra,40(sp)
    800036e6:	7402                	ld	s0,32(sp)
    800036e8:	64e2                	ld	s1,24(sp)
    800036ea:	6942                	ld	s2,16(sp)
    800036ec:	69a2                	ld	s3,8(sp)
    800036ee:	6a02                	ld	s4,0(sp)
    800036f0:	6145                	addi	sp,sp,48
    800036f2:	8082                	ret
    panic("iget: no inodes");
    800036f4:	00005517          	auipc	a0,0x5
    800036f8:	ecc50513          	addi	a0,a0,-308 # 800085c0 <syscalls+0x140>
    800036fc:	ffffd097          	auipc	ra,0xffffd
    80003700:	e44080e7          	jalr	-444(ra) # 80000540 <panic>

0000000080003704 <fsinit>:
fsinit(int dev) {
    80003704:	7179                	addi	sp,sp,-48
    80003706:	f406                	sd	ra,40(sp)
    80003708:	f022                	sd	s0,32(sp)
    8000370a:	ec26                	sd	s1,24(sp)
    8000370c:	e84a                	sd	s2,16(sp)
    8000370e:	e44e                	sd	s3,8(sp)
    80003710:	1800                	addi	s0,sp,48
    80003712:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003714:	4585                	li	a1,1
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	99a080e7          	jalr	-1638(ra) # 800030b0 <bread>
    8000371e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003720:	0001c997          	auipc	s3,0x1c
    80003724:	97898993          	addi	s3,s3,-1672 # 8001f098 <sb>
    80003728:	02000613          	li	a2,32
    8000372c:	05850593          	addi	a1,a0,88
    80003730:	854e                	mv	a0,s3
    80003732:	ffffd097          	auipc	ra,0xffffd
    80003736:	646080e7          	jalr	1606(ra) # 80000d78 <memmove>
  brelse(bp);
    8000373a:	8526                	mv	a0,s1
    8000373c:	00000097          	auipc	ra,0x0
    80003740:	aa4080e7          	jalr	-1372(ra) # 800031e0 <brelse>
  if(sb.magic != FSMAGIC)
    80003744:	0009a703          	lw	a4,0(s3)
    80003748:	102037b7          	lui	a5,0x10203
    8000374c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003750:	02f71263          	bne	a4,a5,80003774 <fsinit+0x70>
  initlog(dev, &sb);
    80003754:	0001c597          	auipc	a1,0x1c
    80003758:	94458593          	addi	a1,a1,-1724 # 8001f098 <sb>
    8000375c:	854a                	mv	a0,s2
    8000375e:	00001097          	auipc	ra,0x1
    80003762:	bf6080e7          	jalr	-1034(ra) # 80004354 <initlog>
}
    80003766:	70a2                	ld	ra,40(sp)
    80003768:	7402                	ld	s0,32(sp)
    8000376a:	64e2                	ld	s1,24(sp)
    8000376c:	6942                	ld	s2,16(sp)
    8000376e:	69a2                	ld	s3,8(sp)
    80003770:	6145                	addi	sp,sp,48
    80003772:	8082                	ret
    panic("invalid file system");
    80003774:	00005517          	auipc	a0,0x5
    80003778:	e5c50513          	addi	a0,a0,-420 # 800085d0 <syscalls+0x150>
    8000377c:	ffffd097          	auipc	ra,0xffffd
    80003780:	dc4080e7          	jalr	-572(ra) # 80000540 <panic>

0000000080003784 <iinit>:
{
    80003784:	7179                	addi	sp,sp,-48
    80003786:	f406                	sd	ra,40(sp)
    80003788:	f022                	sd	s0,32(sp)
    8000378a:	ec26                	sd	s1,24(sp)
    8000378c:	e84a                	sd	s2,16(sp)
    8000378e:	e44e                	sd	s3,8(sp)
    80003790:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003792:	00005597          	auipc	a1,0x5
    80003796:	e5658593          	addi	a1,a1,-426 # 800085e8 <syscalls+0x168>
    8000379a:	0001c517          	auipc	a0,0x1c
    8000379e:	91e50513          	addi	a0,a0,-1762 # 8001f0b8 <itable>
    800037a2:	ffffd097          	auipc	ra,0xffffd
    800037a6:	3ee080e7          	jalr	1006(ra) # 80000b90 <initlock>
  for(i = 0; i < NINODE; i++) {
    800037aa:	0001c497          	auipc	s1,0x1c
    800037ae:	93648493          	addi	s1,s1,-1738 # 8001f0e0 <itable+0x28>
    800037b2:	0001d997          	auipc	s3,0x1d
    800037b6:	3be98993          	addi	s3,s3,958 # 80020b70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800037ba:	00005917          	auipc	s2,0x5
    800037be:	e3690913          	addi	s2,s2,-458 # 800085f0 <syscalls+0x170>
    800037c2:	85ca                	mv	a1,s2
    800037c4:	8526                	mv	a0,s1
    800037c6:	00001097          	auipc	ra,0x1
    800037ca:	eee080e7          	jalr	-274(ra) # 800046b4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800037ce:	08848493          	addi	s1,s1,136
    800037d2:	ff3498e3          	bne	s1,s3,800037c2 <iinit+0x3e>
}
    800037d6:	70a2                	ld	ra,40(sp)
    800037d8:	7402                	ld	s0,32(sp)
    800037da:	64e2                	ld	s1,24(sp)
    800037dc:	6942                	ld	s2,16(sp)
    800037de:	69a2                	ld	s3,8(sp)
    800037e0:	6145                	addi	sp,sp,48
    800037e2:	8082                	ret

00000000800037e4 <ialloc>:
{
    800037e4:	715d                	addi	sp,sp,-80
    800037e6:	e486                	sd	ra,72(sp)
    800037e8:	e0a2                	sd	s0,64(sp)
    800037ea:	fc26                	sd	s1,56(sp)
    800037ec:	f84a                	sd	s2,48(sp)
    800037ee:	f44e                	sd	s3,40(sp)
    800037f0:	f052                	sd	s4,32(sp)
    800037f2:	ec56                	sd	s5,24(sp)
    800037f4:	e85a                	sd	s6,16(sp)
    800037f6:	e45e                	sd	s7,8(sp)
    800037f8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800037fa:	0001c717          	auipc	a4,0x1c
    800037fe:	8aa72703          	lw	a4,-1878(a4) # 8001f0a4 <sb+0xc>
    80003802:	4785                	li	a5,1
    80003804:	04e7fa63          	bgeu	a5,a4,80003858 <ialloc+0x74>
    80003808:	8aaa                	mv	s5,a0
    8000380a:	8bae                	mv	s7,a1
    8000380c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000380e:	0001ca17          	auipc	s4,0x1c
    80003812:	88aa0a13          	addi	s4,s4,-1910 # 8001f098 <sb>
    80003816:	00048b1b          	sext.w	s6,s1
    8000381a:	0044d593          	srli	a1,s1,0x4
    8000381e:	018a2783          	lw	a5,24(s4)
    80003822:	9dbd                	addw	a1,a1,a5
    80003824:	8556                	mv	a0,s5
    80003826:	00000097          	auipc	ra,0x0
    8000382a:	88a080e7          	jalr	-1910(ra) # 800030b0 <bread>
    8000382e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003830:	05850993          	addi	s3,a0,88
    80003834:	00f4f793          	andi	a5,s1,15
    80003838:	079a                	slli	a5,a5,0x6
    8000383a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000383c:	00099783          	lh	a5,0(s3)
    80003840:	c3a1                	beqz	a5,80003880 <ialloc+0x9c>
    brelse(bp);
    80003842:	00000097          	auipc	ra,0x0
    80003846:	99e080e7          	jalr	-1634(ra) # 800031e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000384a:	0485                	addi	s1,s1,1
    8000384c:	00ca2703          	lw	a4,12(s4)
    80003850:	0004879b          	sext.w	a5,s1
    80003854:	fce7e1e3          	bltu	a5,a4,80003816 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003858:	00005517          	auipc	a0,0x5
    8000385c:	da050513          	addi	a0,a0,-608 # 800085f8 <syscalls+0x178>
    80003860:	ffffd097          	auipc	ra,0xffffd
    80003864:	d2a080e7          	jalr	-726(ra) # 8000058a <printf>
  return 0;
    80003868:	4501                	li	a0,0
}
    8000386a:	60a6                	ld	ra,72(sp)
    8000386c:	6406                	ld	s0,64(sp)
    8000386e:	74e2                	ld	s1,56(sp)
    80003870:	7942                	ld	s2,48(sp)
    80003872:	79a2                	ld	s3,40(sp)
    80003874:	7a02                	ld	s4,32(sp)
    80003876:	6ae2                	ld	s5,24(sp)
    80003878:	6b42                	ld	s6,16(sp)
    8000387a:	6ba2                	ld	s7,8(sp)
    8000387c:	6161                	addi	sp,sp,80
    8000387e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003880:	04000613          	li	a2,64
    80003884:	4581                	li	a1,0
    80003886:	854e                	mv	a0,s3
    80003888:	ffffd097          	auipc	ra,0xffffd
    8000388c:	494080e7          	jalr	1172(ra) # 80000d1c <memset>
      dip->type = type;
    80003890:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003894:	854a                	mv	a0,s2
    80003896:	00001097          	auipc	ra,0x1
    8000389a:	d3a080e7          	jalr	-710(ra) # 800045d0 <log_write>
      brelse(bp);
    8000389e:	854a                	mv	a0,s2
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	940080e7          	jalr	-1728(ra) # 800031e0 <brelse>
      return iget(dev, inum);
    800038a8:	85da                	mv	a1,s6
    800038aa:	8556                	mv	a0,s5
    800038ac:	00000097          	auipc	ra,0x0
    800038b0:	d9c080e7          	jalr	-612(ra) # 80003648 <iget>
    800038b4:	bf5d                	j	8000386a <ialloc+0x86>

00000000800038b6 <iupdate>:
{
    800038b6:	1101                	addi	sp,sp,-32
    800038b8:	ec06                	sd	ra,24(sp)
    800038ba:	e822                	sd	s0,16(sp)
    800038bc:	e426                	sd	s1,8(sp)
    800038be:	e04a                	sd	s2,0(sp)
    800038c0:	1000                	addi	s0,sp,32
    800038c2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038c4:	415c                	lw	a5,4(a0)
    800038c6:	0047d79b          	srliw	a5,a5,0x4
    800038ca:	0001b597          	auipc	a1,0x1b
    800038ce:	7e65a583          	lw	a1,2022(a1) # 8001f0b0 <sb+0x18>
    800038d2:	9dbd                	addw	a1,a1,a5
    800038d4:	4108                	lw	a0,0(a0)
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	7da080e7          	jalr	2010(ra) # 800030b0 <bread>
    800038de:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038e0:	05850793          	addi	a5,a0,88
    800038e4:	40d8                	lw	a4,4(s1)
    800038e6:	8b3d                	andi	a4,a4,15
    800038e8:	071a                	slli	a4,a4,0x6
    800038ea:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800038ec:	04449703          	lh	a4,68(s1)
    800038f0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800038f4:	04649703          	lh	a4,70(s1)
    800038f8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800038fc:	04849703          	lh	a4,72(s1)
    80003900:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003904:	04a49703          	lh	a4,74(s1)
    80003908:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000390c:	44f8                	lw	a4,76(s1)
    8000390e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003910:	03400613          	li	a2,52
    80003914:	05048593          	addi	a1,s1,80
    80003918:	00c78513          	addi	a0,a5,12
    8000391c:	ffffd097          	auipc	ra,0xffffd
    80003920:	45c080e7          	jalr	1116(ra) # 80000d78 <memmove>
  log_write(bp);
    80003924:	854a                	mv	a0,s2
    80003926:	00001097          	auipc	ra,0x1
    8000392a:	caa080e7          	jalr	-854(ra) # 800045d0 <log_write>
  brelse(bp);
    8000392e:	854a                	mv	a0,s2
    80003930:	00000097          	auipc	ra,0x0
    80003934:	8b0080e7          	jalr	-1872(ra) # 800031e0 <brelse>
}
    80003938:	60e2                	ld	ra,24(sp)
    8000393a:	6442                	ld	s0,16(sp)
    8000393c:	64a2                	ld	s1,8(sp)
    8000393e:	6902                	ld	s2,0(sp)
    80003940:	6105                	addi	sp,sp,32
    80003942:	8082                	ret

0000000080003944 <idup>:
{
    80003944:	1101                	addi	sp,sp,-32
    80003946:	ec06                	sd	ra,24(sp)
    80003948:	e822                	sd	s0,16(sp)
    8000394a:	e426                	sd	s1,8(sp)
    8000394c:	1000                	addi	s0,sp,32
    8000394e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003950:	0001b517          	auipc	a0,0x1b
    80003954:	76850513          	addi	a0,a0,1896 # 8001f0b8 <itable>
    80003958:	ffffd097          	auipc	ra,0xffffd
    8000395c:	2c8080e7          	jalr	712(ra) # 80000c20 <acquire>
  ip->ref++;
    80003960:	449c                	lw	a5,8(s1)
    80003962:	2785                	addiw	a5,a5,1
    80003964:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003966:	0001b517          	auipc	a0,0x1b
    8000396a:	75250513          	addi	a0,a0,1874 # 8001f0b8 <itable>
    8000396e:	ffffd097          	auipc	ra,0xffffd
    80003972:	366080e7          	jalr	870(ra) # 80000cd4 <release>
}
    80003976:	8526                	mv	a0,s1
    80003978:	60e2                	ld	ra,24(sp)
    8000397a:	6442                	ld	s0,16(sp)
    8000397c:	64a2                	ld	s1,8(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret

0000000080003982 <ilock>:
{
    80003982:	1101                	addi	sp,sp,-32
    80003984:	ec06                	sd	ra,24(sp)
    80003986:	e822                	sd	s0,16(sp)
    80003988:	e426                	sd	s1,8(sp)
    8000398a:	e04a                	sd	s2,0(sp)
    8000398c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000398e:	c115                	beqz	a0,800039b2 <ilock+0x30>
    80003990:	84aa                	mv	s1,a0
    80003992:	451c                	lw	a5,8(a0)
    80003994:	00f05f63          	blez	a5,800039b2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003998:	0541                	addi	a0,a0,16
    8000399a:	00001097          	auipc	ra,0x1
    8000399e:	d54080e7          	jalr	-684(ra) # 800046ee <acquiresleep>
  if(ip->valid == 0){
    800039a2:	40bc                	lw	a5,64(s1)
    800039a4:	cf99                	beqz	a5,800039c2 <ilock+0x40>
}
    800039a6:	60e2                	ld	ra,24(sp)
    800039a8:	6442                	ld	s0,16(sp)
    800039aa:	64a2                	ld	s1,8(sp)
    800039ac:	6902                	ld	s2,0(sp)
    800039ae:	6105                	addi	sp,sp,32
    800039b0:	8082                	ret
    panic("ilock");
    800039b2:	00005517          	auipc	a0,0x5
    800039b6:	c5e50513          	addi	a0,a0,-930 # 80008610 <syscalls+0x190>
    800039ba:	ffffd097          	auipc	ra,0xffffd
    800039be:	b86080e7          	jalr	-1146(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039c2:	40dc                	lw	a5,4(s1)
    800039c4:	0047d79b          	srliw	a5,a5,0x4
    800039c8:	0001b597          	auipc	a1,0x1b
    800039cc:	6e85a583          	lw	a1,1768(a1) # 8001f0b0 <sb+0x18>
    800039d0:	9dbd                	addw	a1,a1,a5
    800039d2:	4088                	lw	a0,0(s1)
    800039d4:	fffff097          	auipc	ra,0xfffff
    800039d8:	6dc080e7          	jalr	1756(ra) # 800030b0 <bread>
    800039dc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800039de:	05850593          	addi	a1,a0,88
    800039e2:	40dc                	lw	a5,4(s1)
    800039e4:	8bbd                	andi	a5,a5,15
    800039e6:	079a                	slli	a5,a5,0x6
    800039e8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800039ea:	00059783          	lh	a5,0(a1)
    800039ee:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800039f2:	00259783          	lh	a5,2(a1)
    800039f6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800039fa:	00459783          	lh	a5,4(a1)
    800039fe:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003a02:	00659783          	lh	a5,6(a1)
    80003a06:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003a0a:	459c                	lw	a5,8(a1)
    80003a0c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a0e:	03400613          	li	a2,52
    80003a12:	05b1                	addi	a1,a1,12
    80003a14:	05048513          	addi	a0,s1,80
    80003a18:	ffffd097          	auipc	ra,0xffffd
    80003a1c:	360080e7          	jalr	864(ra) # 80000d78 <memmove>
    brelse(bp);
    80003a20:	854a                	mv	a0,s2
    80003a22:	fffff097          	auipc	ra,0xfffff
    80003a26:	7be080e7          	jalr	1982(ra) # 800031e0 <brelse>
    ip->valid = 1;
    80003a2a:	4785                	li	a5,1
    80003a2c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003a2e:	04449783          	lh	a5,68(s1)
    80003a32:	fbb5                	bnez	a5,800039a6 <ilock+0x24>
      panic("ilock: no type");
    80003a34:	00005517          	auipc	a0,0x5
    80003a38:	be450513          	addi	a0,a0,-1052 # 80008618 <syscalls+0x198>
    80003a3c:	ffffd097          	auipc	ra,0xffffd
    80003a40:	b04080e7          	jalr	-1276(ra) # 80000540 <panic>

0000000080003a44 <iunlock>:
{
    80003a44:	1101                	addi	sp,sp,-32
    80003a46:	ec06                	sd	ra,24(sp)
    80003a48:	e822                	sd	s0,16(sp)
    80003a4a:	e426                	sd	s1,8(sp)
    80003a4c:	e04a                	sd	s2,0(sp)
    80003a4e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003a50:	c905                	beqz	a0,80003a80 <iunlock+0x3c>
    80003a52:	84aa                	mv	s1,a0
    80003a54:	01050913          	addi	s2,a0,16
    80003a58:	854a                	mv	a0,s2
    80003a5a:	00001097          	auipc	ra,0x1
    80003a5e:	d2e080e7          	jalr	-722(ra) # 80004788 <holdingsleep>
    80003a62:	cd19                	beqz	a0,80003a80 <iunlock+0x3c>
    80003a64:	449c                	lw	a5,8(s1)
    80003a66:	00f05d63          	blez	a5,80003a80 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003a6a:	854a                	mv	a0,s2
    80003a6c:	00001097          	auipc	ra,0x1
    80003a70:	cd8080e7          	jalr	-808(ra) # 80004744 <releasesleep>
}
    80003a74:	60e2                	ld	ra,24(sp)
    80003a76:	6442                	ld	s0,16(sp)
    80003a78:	64a2                	ld	s1,8(sp)
    80003a7a:	6902                	ld	s2,0(sp)
    80003a7c:	6105                	addi	sp,sp,32
    80003a7e:	8082                	ret
    panic("iunlock");
    80003a80:	00005517          	auipc	a0,0x5
    80003a84:	ba850513          	addi	a0,a0,-1112 # 80008628 <syscalls+0x1a8>
    80003a88:	ffffd097          	auipc	ra,0xffffd
    80003a8c:	ab8080e7          	jalr	-1352(ra) # 80000540 <panic>

0000000080003a90 <itrunc>:


// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80003a90:	715d                	addi	sp,sp,-80
    80003a92:	e486                	sd	ra,72(sp)
    80003a94:	e0a2                	sd	s0,64(sp)
    80003a96:	fc26                	sd	s1,56(sp)
    80003a98:	f84a                	sd	s2,48(sp)
    80003a9a:	f44e                	sd	s3,40(sp)
    80003a9c:	f052                	sd	s4,32(sp)
    80003a9e:	ec56                	sd	s5,24(sp)
    80003aa0:	e85a                	sd	s6,16(sp)
    80003aa2:	e45e                	sd	s7,8(sp)
    80003aa4:	e062                	sd	s8,0(sp)
    80003aa6:	0880                	addi	s0,sp,80
    80003aa8:	89aa                	mv	s3,a0
int i, j, k;
struct buf *bp, *bp2;
uint *a, *a2;

i = 0;
while(i < NDIRECT) {
    80003aaa:	05050493          	addi	s1,a0,80
    80003aae:	07c50913          	addi	s2,a0,124
    80003ab2:	a021                	j	80003aba <itrunc+0x2a>
    80003ab4:	0491                	addi	s1,s1,4
    80003ab6:	01248d63          	beq	s1,s2,80003ad0 <itrunc+0x40>
   switch(ip->addrs[i]) {
    80003aba:	408c                	lw	a1,0(s1)
    80003abc:	dde5                	beqz	a1,80003ab4 <itrunc+0x24>
       case 0:
           break;
       default:
           bfree(ip->dev, ip->addrs[i]);
    80003abe:	0009a503          	lw	a0,0(s3)
    80003ac2:	00000097          	auipc	ra,0x0
    80003ac6:	834080e7          	jalr	-1996(ra) # 800032f6 <bfree>
           ip->addrs[i] = 0;
    80003aca:	0004a023          	sw	zero,0(s1)
    80003ace:	b7dd                	j	80003ab4 <itrunc+0x24>
   }
   i++;
}

if(ip->addrs[NDIRECT]) {
    80003ad0:	07c9a583          	lw	a1,124(s3)
    80003ad4:	e59d                	bnez	a1,80003b02 <itrunc+0x72>
   bfree(ip->dev, ip->addrs[NDIRECT]);
   ip->addrs[NDIRECT] = 0;
}

// lab_4
if(ip->addrs[NDIRECT+1]) {
    80003ad6:	0809a583          	lw	a1,128(s3)
    80003ada:	eda5                	bnez	a1,80003b52 <itrunc+0xc2>
   brelse(bp);
   bfree(ip->dev, ip->addrs[NDIRECT+1]);
   ip->addrs[NDIRECT+1] = 0;
}

ip->size = 0;
    80003adc:	0409a623          	sw	zero,76(s3)
iupdate(ip);
    80003ae0:	854e                	mv	a0,s3
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	dd4080e7          	jalr	-556(ra) # 800038b6 <iupdate>
}
    80003aea:	60a6                	ld	ra,72(sp)
    80003aec:	6406                	ld	s0,64(sp)
    80003aee:	74e2                	ld	s1,56(sp)
    80003af0:	7942                	ld	s2,48(sp)
    80003af2:	79a2                	ld	s3,40(sp)
    80003af4:	7a02                	ld	s4,32(sp)
    80003af6:	6ae2                	ld	s5,24(sp)
    80003af8:	6b42                	ld	s6,16(sp)
    80003afa:	6ba2                	ld	s7,8(sp)
    80003afc:	6c02                	ld	s8,0(sp)
    80003afe:	6161                	addi	sp,sp,80
    80003b00:	8082                	ret
   bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003b02:	0009a503          	lw	a0,0(s3)
    80003b06:	fffff097          	auipc	ra,0xfffff
    80003b0a:	5aa080e7          	jalr	1450(ra) # 800030b0 <bread>
    80003b0e:	8a2a                	mv	s4,a0
   while(j < NINDIRECT) {
    80003b10:	05850493          	addi	s1,a0,88
    80003b14:	45850913          	addi	s2,a0,1112
    80003b18:	a021                	j	80003b20 <itrunc+0x90>
    80003b1a:	0491                	addi	s1,s1,4
    80003b1c:	01248b63          	beq	s1,s2,80003b32 <itrunc+0xa2>
       if(a[j])
    80003b20:	408c                	lw	a1,0(s1)
    80003b22:	dde5                	beqz	a1,80003b1a <itrunc+0x8a>
           bfree(ip->dev, a[j]);
    80003b24:	0009a503          	lw	a0,0(s3)
    80003b28:	fffff097          	auipc	ra,0xfffff
    80003b2c:	7ce080e7          	jalr	1998(ra) # 800032f6 <bfree>
    80003b30:	b7ed                	j	80003b1a <itrunc+0x8a>
   brelse(bp);
    80003b32:	8552                	mv	a0,s4
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	6ac080e7          	jalr	1708(ra) # 800031e0 <brelse>
   bfree(ip->dev, ip->addrs[NDIRECT]);
    80003b3c:	07c9a583          	lw	a1,124(s3)
    80003b40:	0009a503          	lw	a0,0(s3)
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	7b2080e7          	jalr	1970(ra) # 800032f6 <bfree>
   ip->addrs[NDIRECT] = 0;
    80003b4c:	0609ae23          	sw	zero,124(s3)
    80003b50:	b759                	j	80003ad6 <itrunc+0x46>
   bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    80003b52:	0009a503          	lw	a0,0(s3)
    80003b56:	fffff097          	auipc	ra,0xfffff
    80003b5a:	55a080e7          	jalr	1370(ra) # 800030b0 <bread>
    80003b5e:	8c2a                	mv	s8,a0
   for(j = 0; j < NINDIRECT; ++j) {
    80003b60:	05850a13          	addi	s4,a0,88
    80003b64:	45850b13          	addi	s6,a0,1112
    80003b68:	a83d                	j	80003ba6 <itrunc+0x116>
           for(k = 0; k < NINDIRECT; ++k) {
    80003b6a:	0491                	addi	s1,s1,4
    80003b6c:	00990b63          	beq	s2,s1,80003b82 <itrunc+0xf2>
               if(a2[k])
    80003b70:	408c                	lw	a1,0(s1)
    80003b72:	dde5                	beqz	a1,80003b6a <itrunc+0xda>
                   bfree(ip->dev, a2[k]);
    80003b74:	0009a503          	lw	a0,0(s3)
    80003b78:	fffff097          	auipc	ra,0xfffff
    80003b7c:	77e080e7          	jalr	1918(ra) # 800032f6 <bfree>
    80003b80:	b7ed                	j	80003b6a <itrunc+0xda>
           brelse(bp2);
    80003b82:	855e                	mv	a0,s7
    80003b84:	fffff097          	auipc	ra,0xfffff
    80003b88:	65c080e7          	jalr	1628(ra) # 800031e0 <brelse>
           bfree(ip->dev, a[j]);
    80003b8c:	000aa583          	lw	a1,0(s5)
    80003b90:	0009a503          	lw	a0,0(s3)
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	762080e7          	jalr	1890(ra) # 800032f6 <bfree>
           a[j] = 0;
    80003b9c:	000aa023          	sw	zero,0(s5)
   for(j = 0; j < NINDIRECT; ++j) {
    80003ba0:	0a11                	addi	s4,s4,4
    80003ba2:	036a0263          	beq	s4,s6,80003bc6 <itrunc+0x136>
       if(a[j]) {
    80003ba6:	8ad2                	mv	s5,s4
    80003ba8:	000a2583          	lw	a1,0(s4)
    80003bac:	d9f5                	beqz	a1,80003ba0 <itrunc+0x110>
           bp2 = bread(ip->dev, a[j]);
    80003bae:	0009a503          	lw	a0,0(s3)
    80003bb2:	fffff097          	auipc	ra,0xfffff
    80003bb6:	4fe080e7          	jalr	1278(ra) # 800030b0 <bread>
    80003bba:	8baa                	mv	s7,a0
           for(k = 0; k < NINDIRECT; ++k) {
    80003bbc:	05850493          	addi	s1,a0,88
    80003bc0:	45850913          	addi	s2,a0,1112
    80003bc4:	b775                	j	80003b70 <itrunc+0xe0>
   brelse(bp);
    80003bc6:	8562                	mv	a0,s8
    80003bc8:	fffff097          	auipc	ra,0xfffff
    80003bcc:	618080e7          	jalr	1560(ra) # 800031e0 <brelse>
   bfree(ip->dev, ip->addrs[NDIRECT+1]);
    80003bd0:	0809a583          	lw	a1,128(s3)
    80003bd4:	0009a503          	lw	a0,0(s3)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	71e080e7          	jalr	1822(ra) # 800032f6 <bfree>
   ip->addrs[NDIRECT+1] = 0;
    80003be0:	0809a023          	sw	zero,128(s3)
    80003be4:	bde5                	j	80003adc <itrunc+0x4c>

0000000080003be6 <iput>:
{
    80003be6:	1101                	addi	sp,sp,-32
    80003be8:	ec06                	sd	ra,24(sp)
    80003bea:	e822                	sd	s0,16(sp)
    80003bec:	e426                	sd	s1,8(sp)
    80003bee:	e04a                	sd	s2,0(sp)
    80003bf0:	1000                	addi	s0,sp,32
    80003bf2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003bf4:	0001b517          	auipc	a0,0x1b
    80003bf8:	4c450513          	addi	a0,a0,1220 # 8001f0b8 <itable>
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	024080e7          	jalr	36(ra) # 80000c20 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c04:	4498                	lw	a4,8(s1)
    80003c06:	4785                	li	a5,1
    80003c08:	02f70363          	beq	a4,a5,80003c2e <iput+0x48>
  ip->ref--;
    80003c0c:	449c                	lw	a5,8(s1)
    80003c0e:	37fd                	addiw	a5,a5,-1
    80003c10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c12:	0001b517          	auipc	a0,0x1b
    80003c16:	4a650513          	addi	a0,a0,1190 # 8001f0b8 <itable>
    80003c1a:	ffffd097          	auipc	ra,0xffffd
    80003c1e:	0ba080e7          	jalr	186(ra) # 80000cd4 <release>
}
    80003c22:	60e2                	ld	ra,24(sp)
    80003c24:	6442                	ld	s0,16(sp)
    80003c26:	64a2                	ld	s1,8(sp)
    80003c28:	6902                	ld	s2,0(sp)
    80003c2a:	6105                	addi	sp,sp,32
    80003c2c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c2e:	40bc                	lw	a5,64(s1)
    80003c30:	dff1                	beqz	a5,80003c0c <iput+0x26>
    80003c32:	04a49783          	lh	a5,74(s1)
    80003c36:	fbf9                	bnez	a5,80003c0c <iput+0x26>
    acquiresleep(&ip->lock);
    80003c38:	01048913          	addi	s2,s1,16
    80003c3c:	854a                	mv	a0,s2
    80003c3e:	00001097          	auipc	ra,0x1
    80003c42:	ab0080e7          	jalr	-1360(ra) # 800046ee <acquiresleep>
    release(&itable.lock);
    80003c46:	0001b517          	auipc	a0,0x1b
    80003c4a:	47250513          	addi	a0,a0,1138 # 8001f0b8 <itable>
    80003c4e:	ffffd097          	auipc	ra,0xffffd
    80003c52:	086080e7          	jalr	134(ra) # 80000cd4 <release>
    itrunc(ip);
    80003c56:	8526                	mv	a0,s1
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	e38080e7          	jalr	-456(ra) # 80003a90 <itrunc>
    ip->type = 0;
    80003c60:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c64:	8526                	mv	a0,s1
    80003c66:	00000097          	auipc	ra,0x0
    80003c6a:	c50080e7          	jalr	-944(ra) # 800038b6 <iupdate>
    ip->valid = 0;
    80003c6e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c72:	854a                	mv	a0,s2
    80003c74:	00001097          	auipc	ra,0x1
    80003c78:	ad0080e7          	jalr	-1328(ra) # 80004744 <releasesleep>
    acquire(&itable.lock);
    80003c7c:	0001b517          	auipc	a0,0x1b
    80003c80:	43c50513          	addi	a0,a0,1084 # 8001f0b8 <itable>
    80003c84:	ffffd097          	auipc	ra,0xffffd
    80003c88:	f9c080e7          	jalr	-100(ra) # 80000c20 <acquire>
    80003c8c:	b741                	j	80003c0c <iput+0x26>

0000000080003c8e <iunlockput>:
{
    80003c8e:	1101                	addi	sp,sp,-32
    80003c90:	ec06                	sd	ra,24(sp)
    80003c92:	e822                	sd	s0,16(sp)
    80003c94:	e426                	sd	s1,8(sp)
    80003c96:	1000                	addi	s0,sp,32
    80003c98:	84aa                	mv	s1,a0
  iunlock(ip);
    80003c9a:	00000097          	auipc	ra,0x0
    80003c9e:	daa080e7          	jalr	-598(ra) # 80003a44 <iunlock>
  iput(ip);
    80003ca2:	8526                	mv	a0,s1
    80003ca4:	00000097          	auipc	ra,0x0
    80003ca8:	f42080e7          	jalr	-190(ra) # 80003be6 <iput>
}
    80003cac:	60e2                	ld	ra,24(sp)
    80003cae:	6442                	ld	s0,16(sp)
    80003cb0:	64a2                	ld	s1,8(sp)
    80003cb2:	6105                	addi	sp,sp,32
    80003cb4:	8082                	ret

0000000080003cb6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003cb6:	1141                	addi	sp,sp,-16
    80003cb8:	e422                	sd	s0,8(sp)
    80003cba:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003cbc:	411c                	lw	a5,0(a0)
    80003cbe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003cc0:	415c                	lw	a5,4(a0)
    80003cc2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003cc4:	04451783          	lh	a5,68(a0)
    80003cc8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003ccc:	04a51783          	lh	a5,74(a0)
    80003cd0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003cd4:	04c56783          	lwu	a5,76(a0)
    80003cd8:	e99c                	sd	a5,16(a1)
}
    80003cda:	6422                	ld	s0,8(sp)
    80003cdc:	0141                	addi	sp,sp,16
    80003cde:	8082                	ret

0000000080003ce0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ce0:	457c                	lw	a5,76(a0)
    80003ce2:	0ed7e963          	bltu	a5,a3,80003dd4 <readi+0xf4>
{
    80003ce6:	7159                	addi	sp,sp,-112
    80003ce8:	f486                	sd	ra,104(sp)
    80003cea:	f0a2                	sd	s0,96(sp)
    80003cec:	eca6                	sd	s1,88(sp)
    80003cee:	e8ca                	sd	s2,80(sp)
    80003cf0:	e4ce                	sd	s3,72(sp)
    80003cf2:	e0d2                	sd	s4,64(sp)
    80003cf4:	fc56                	sd	s5,56(sp)
    80003cf6:	f85a                	sd	s6,48(sp)
    80003cf8:	f45e                	sd	s7,40(sp)
    80003cfa:	f062                	sd	s8,32(sp)
    80003cfc:	ec66                	sd	s9,24(sp)
    80003cfe:	e86a                	sd	s10,16(sp)
    80003d00:	e46e                	sd	s11,8(sp)
    80003d02:	1880                	addi	s0,sp,112
    80003d04:	8b2a                	mv	s6,a0
    80003d06:	8bae                	mv	s7,a1
    80003d08:	8a32                	mv	s4,a2
    80003d0a:	84b6                	mv	s1,a3
    80003d0c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003d0e:	9f35                	addw	a4,a4,a3
    return 0;
    80003d10:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d12:	0ad76063          	bltu	a4,a3,80003db2 <readi+0xd2>
  if(off + n > ip->size)
    80003d16:	00e7f463          	bgeu	a5,a4,80003d1e <readi+0x3e>
    n = ip->size - off;
    80003d1a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d1e:	0a0a8963          	beqz	s5,80003dd0 <readi+0xf0>
    80003d22:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d24:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d28:	5c7d                	li	s8,-1
    80003d2a:	a82d                	j	80003d64 <readi+0x84>
    80003d2c:	020d1d93          	slli	s11,s10,0x20
    80003d30:	020ddd93          	srli	s11,s11,0x20
    80003d34:	05890613          	addi	a2,s2,88
    80003d38:	86ee                	mv	a3,s11
    80003d3a:	963a                	add	a2,a2,a4
    80003d3c:	85d2                	mv	a1,s4
    80003d3e:	855e                	mv	a0,s7
    80003d40:	fffff097          	auipc	ra,0xfffff
    80003d44:	84a080e7          	jalr	-1974(ra) # 8000258a <either_copyout>
    80003d48:	05850d63          	beq	a0,s8,80003da2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003d4c:	854a                	mv	a0,s2
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	492080e7          	jalr	1170(ra) # 800031e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d56:	013d09bb          	addw	s3,s10,s3
    80003d5a:	009d04bb          	addw	s1,s10,s1
    80003d5e:	9a6e                	add	s4,s4,s11
    80003d60:	0559f763          	bgeu	s3,s5,80003dae <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003d64:	00a4d59b          	srliw	a1,s1,0xa
    80003d68:	855a                	mv	a0,s6
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	73a080e7          	jalr	1850(ra) # 800034a4 <bmap>
    80003d72:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003d76:	cd85                	beqz	a1,80003dae <readi+0xce>
    bp = bread(ip->dev, addr);
    80003d78:	000b2503          	lw	a0,0(s6)
    80003d7c:	fffff097          	auipc	ra,0xfffff
    80003d80:	334080e7          	jalr	820(ra) # 800030b0 <bread>
    80003d84:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d86:	3ff4f713          	andi	a4,s1,1023
    80003d8a:	40ec87bb          	subw	a5,s9,a4
    80003d8e:	413a86bb          	subw	a3,s5,s3
    80003d92:	8d3e                	mv	s10,a5
    80003d94:	2781                	sext.w	a5,a5
    80003d96:	0006861b          	sext.w	a2,a3
    80003d9a:	f8f679e3          	bgeu	a2,a5,80003d2c <readi+0x4c>
    80003d9e:	8d36                	mv	s10,a3
    80003da0:	b771                	j	80003d2c <readi+0x4c>
      brelse(bp);
    80003da2:	854a                	mv	a0,s2
    80003da4:	fffff097          	auipc	ra,0xfffff
    80003da8:	43c080e7          	jalr	1084(ra) # 800031e0 <brelse>
      tot = -1;
    80003dac:	59fd                	li	s3,-1
  }
  return tot;
    80003dae:	0009851b          	sext.w	a0,s3
}
    80003db2:	70a6                	ld	ra,104(sp)
    80003db4:	7406                	ld	s0,96(sp)
    80003db6:	64e6                	ld	s1,88(sp)
    80003db8:	6946                	ld	s2,80(sp)
    80003dba:	69a6                	ld	s3,72(sp)
    80003dbc:	6a06                	ld	s4,64(sp)
    80003dbe:	7ae2                	ld	s5,56(sp)
    80003dc0:	7b42                	ld	s6,48(sp)
    80003dc2:	7ba2                	ld	s7,40(sp)
    80003dc4:	7c02                	ld	s8,32(sp)
    80003dc6:	6ce2                	ld	s9,24(sp)
    80003dc8:	6d42                	ld	s10,16(sp)
    80003dca:	6da2                	ld	s11,8(sp)
    80003dcc:	6165                	addi	sp,sp,112
    80003dce:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003dd0:	89d6                	mv	s3,s5
    80003dd2:	bff1                	j	80003dae <readi+0xce>
    return 0;
    80003dd4:	4501                	li	a0,0
}
    80003dd6:	8082                	ret

0000000080003dd8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dd8:	457c                	lw	a5,76(a0)
    80003dda:	10d7e963          	bltu	a5,a3,80003eec <writei+0x114>
{
    80003dde:	7159                	addi	sp,sp,-112
    80003de0:	f486                	sd	ra,104(sp)
    80003de2:	f0a2                	sd	s0,96(sp)
    80003de4:	eca6                	sd	s1,88(sp)
    80003de6:	e8ca                	sd	s2,80(sp)
    80003de8:	e4ce                	sd	s3,72(sp)
    80003dea:	e0d2                	sd	s4,64(sp)
    80003dec:	fc56                	sd	s5,56(sp)
    80003dee:	f85a                	sd	s6,48(sp)
    80003df0:	f45e                	sd	s7,40(sp)
    80003df2:	f062                	sd	s8,32(sp)
    80003df4:	ec66                	sd	s9,24(sp)
    80003df6:	e86a                	sd	s10,16(sp)
    80003df8:	e46e                	sd	s11,8(sp)
    80003dfa:	1880                	addi	s0,sp,112
    80003dfc:	8aaa                	mv	s5,a0
    80003dfe:	8bae                	mv	s7,a1
    80003e00:	8a32                	mv	s4,a2
    80003e02:	8936                	mv	s2,a3
    80003e04:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e06:	9f35                	addw	a4,a4,a3
    80003e08:	0ed76463          	bltu	a4,a3,80003ef0 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e0c:	040437b7          	lui	a5,0x4043
    80003e10:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003e14:	0ee7e063          	bltu	a5,a4,80003ef4 <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e18:	0c0b0863          	beqz	s6,80003ee8 <writei+0x110>
    80003e1c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e1e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e22:	5c7d                	li	s8,-1
    80003e24:	a091                	j	80003e68 <writei+0x90>
    80003e26:	020d1d93          	slli	s11,s10,0x20
    80003e2a:	020ddd93          	srli	s11,s11,0x20
    80003e2e:	05848513          	addi	a0,s1,88
    80003e32:	86ee                	mv	a3,s11
    80003e34:	8652                	mv	a2,s4
    80003e36:	85de                	mv	a1,s7
    80003e38:	953a                	add	a0,a0,a4
    80003e3a:	ffffe097          	auipc	ra,0xffffe
    80003e3e:	7a6080e7          	jalr	1958(ra) # 800025e0 <either_copyin>
    80003e42:	07850263          	beq	a0,s8,80003ea6 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003e46:	8526                	mv	a0,s1
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	788080e7          	jalr	1928(ra) # 800045d0 <log_write>
    brelse(bp);
    80003e50:	8526                	mv	a0,s1
    80003e52:	fffff097          	auipc	ra,0xfffff
    80003e56:	38e080e7          	jalr	910(ra) # 800031e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e5a:	013d09bb          	addw	s3,s10,s3
    80003e5e:	012d093b          	addw	s2,s10,s2
    80003e62:	9a6e                	add	s4,s4,s11
    80003e64:	0569f663          	bgeu	s3,s6,80003eb0 <writei+0xd8>
    uint addr = bmap(ip, off/BSIZE);
    80003e68:	00a9559b          	srliw	a1,s2,0xa
    80003e6c:	8556                	mv	a0,s5
    80003e6e:	fffff097          	auipc	ra,0xfffff
    80003e72:	636080e7          	jalr	1590(ra) # 800034a4 <bmap>
    80003e76:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003e7a:	c99d                	beqz	a1,80003eb0 <writei+0xd8>
    bp = bread(ip->dev, addr);
    80003e7c:	000aa503          	lw	a0,0(s5)
    80003e80:	fffff097          	auipc	ra,0xfffff
    80003e84:	230080e7          	jalr	560(ra) # 800030b0 <bread>
    80003e88:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e8a:	3ff97713          	andi	a4,s2,1023
    80003e8e:	40ec87bb          	subw	a5,s9,a4
    80003e92:	413b06bb          	subw	a3,s6,s3
    80003e96:	8d3e                	mv	s10,a5
    80003e98:	2781                	sext.w	a5,a5
    80003e9a:	0006861b          	sext.w	a2,a3
    80003e9e:	f8f674e3          	bgeu	a2,a5,80003e26 <writei+0x4e>
    80003ea2:	8d36                	mv	s10,a3
    80003ea4:	b749                	j	80003e26 <writei+0x4e>
      brelse(bp);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	338080e7          	jalr	824(ra) # 800031e0 <brelse>
  }

  if(off > ip->size)
    80003eb0:	04caa783          	lw	a5,76(s5)
    80003eb4:	0127f463          	bgeu	a5,s2,80003ebc <writei+0xe4>
    ip->size = off;
    80003eb8:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003ebc:	8556                	mv	a0,s5
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	9f8080e7          	jalr	-1544(ra) # 800038b6 <iupdate>

  return tot;
    80003ec6:	0009851b          	sext.w	a0,s3
}
    80003eca:	70a6                	ld	ra,104(sp)
    80003ecc:	7406                	ld	s0,96(sp)
    80003ece:	64e6                	ld	s1,88(sp)
    80003ed0:	6946                	ld	s2,80(sp)
    80003ed2:	69a6                	ld	s3,72(sp)
    80003ed4:	6a06                	ld	s4,64(sp)
    80003ed6:	7ae2                	ld	s5,56(sp)
    80003ed8:	7b42                	ld	s6,48(sp)
    80003eda:	7ba2                	ld	s7,40(sp)
    80003edc:	7c02                	ld	s8,32(sp)
    80003ede:	6ce2                	ld	s9,24(sp)
    80003ee0:	6d42                	ld	s10,16(sp)
    80003ee2:	6da2                	ld	s11,8(sp)
    80003ee4:	6165                	addi	sp,sp,112
    80003ee6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ee8:	89da                	mv	s3,s6
    80003eea:	bfc9                	j	80003ebc <writei+0xe4>
    return -1;
    80003eec:	557d                	li	a0,-1
}
    80003eee:	8082                	ret
    return -1;
    80003ef0:	557d                	li	a0,-1
    80003ef2:	bfe1                	j	80003eca <writei+0xf2>
    return -1;
    80003ef4:	557d                	li	a0,-1
    80003ef6:	bfd1                	j	80003eca <writei+0xf2>

0000000080003ef8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ef8:	1141                	addi	sp,sp,-16
    80003efa:	e406                	sd	ra,8(sp)
    80003efc:	e022                	sd	s0,0(sp)
    80003efe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f00:	4639                	li	a2,14
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	eea080e7          	jalr	-278(ra) # 80000dec <strncmp>
}
    80003f0a:	60a2                	ld	ra,8(sp)
    80003f0c:	6402                	ld	s0,0(sp)
    80003f0e:	0141                	addi	sp,sp,16
    80003f10:	8082                	ret

0000000080003f12 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f12:	7139                	addi	sp,sp,-64
    80003f14:	fc06                	sd	ra,56(sp)
    80003f16:	f822                	sd	s0,48(sp)
    80003f18:	f426                	sd	s1,40(sp)
    80003f1a:	f04a                	sd	s2,32(sp)
    80003f1c:	ec4e                	sd	s3,24(sp)
    80003f1e:	e852                	sd	s4,16(sp)
    80003f20:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003f22:	04451703          	lh	a4,68(a0)
    80003f26:	4785                	li	a5,1
    80003f28:	00f71a63          	bne	a4,a5,80003f3c <dirlookup+0x2a>
    80003f2c:	892a                	mv	s2,a0
    80003f2e:	89ae                	mv	s3,a1
    80003f30:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f32:	457c                	lw	a5,76(a0)
    80003f34:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003f36:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f38:	e79d                	bnez	a5,80003f66 <dirlookup+0x54>
    80003f3a:	a8a5                	j	80003fb2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003f3c:	00004517          	auipc	a0,0x4
    80003f40:	6f450513          	addi	a0,a0,1780 # 80008630 <syscalls+0x1b0>
    80003f44:	ffffc097          	auipc	ra,0xffffc
    80003f48:	5fc080e7          	jalr	1532(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003f4c:	00004517          	auipc	a0,0x4
    80003f50:	6fc50513          	addi	a0,a0,1788 # 80008648 <syscalls+0x1c8>
    80003f54:	ffffc097          	auipc	ra,0xffffc
    80003f58:	5ec080e7          	jalr	1516(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f5c:	24c1                	addiw	s1,s1,16
    80003f5e:	04c92783          	lw	a5,76(s2)
    80003f62:	04f4f763          	bgeu	s1,a5,80003fb0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f66:	4741                	li	a4,16
    80003f68:	86a6                	mv	a3,s1
    80003f6a:	fc040613          	addi	a2,s0,-64
    80003f6e:	4581                	li	a1,0
    80003f70:	854a                	mv	a0,s2
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	d6e080e7          	jalr	-658(ra) # 80003ce0 <readi>
    80003f7a:	47c1                	li	a5,16
    80003f7c:	fcf518e3          	bne	a0,a5,80003f4c <dirlookup+0x3a>
    if(de.inum == 0)
    80003f80:	fc045783          	lhu	a5,-64(s0)
    80003f84:	dfe1                	beqz	a5,80003f5c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003f86:	fc240593          	addi	a1,s0,-62
    80003f8a:	854e                	mv	a0,s3
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	f6c080e7          	jalr	-148(ra) # 80003ef8 <namecmp>
    80003f94:	f561                	bnez	a0,80003f5c <dirlookup+0x4a>
      if(poff)
    80003f96:	000a0463          	beqz	s4,80003f9e <dirlookup+0x8c>
        *poff = off;
    80003f9a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003f9e:	fc045583          	lhu	a1,-64(s0)
    80003fa2:	00092503          	lw	a0,0(s2)
    80003fa6:	fffff097          	auipc	ra,0xfffff
    80003faa:	6a2080e7          	jalr	1698(ra) # 80003648 <iget>
    80003fae:	a011                	j	80003fb2 <dirlookup+0xa0>
  return 0;
    80003fb0:	4501                	li	a0,0
}
    80003fb2:	70e2                	ld	ra,56(sp)
    80003fb4:	7442                	ld	s0,48(sp)
    80003fb6:	74a2                	ld	s1,40(sp)
    80003fb8:	7902                	ld	s2,32(sp)
    80003fba:	69e2                	ld	s3,24(sp)
    80003fbc:	6a42                	ld	s4,16(sp)
    80003fbe:	6121                	addi	sp,sp,64
    80003fc0:	8082                	ret

0000000080003fc2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003fc2:	711d                	addi	sp,sp,-96
    80003fc4:	ec86                	sd	ra,88(sp)
    80003fc6:	e8a2                	sd	s0,80(sp)
    80003fc8:	e4a6                	sd	s1,72(sp)
    80003fca:	e0ca                	sd	s2,64(sp)
    80003fcc:	fc4e                	sd	s3,56(sp)
    80003fce:	f852                	sd	s4,48(sp)
    80003fd0:	f456                	sd	s5,40(sp)
    80003fd2:	f05a                	sd	s6,32(sp)
    80003fd4:	ec5e                	sd	s7,24(sp)
    80003fd6:	e862                	sd	s8,16(sp)
    80003fd8:	e466                	sd	s9,8(sp)
    80003fda:	e06a                	sd	s10,0(sp)
    80003fdc:	1080                	addi	s0,sp,96
    80003fde:	84aa                	mv	s1,a0
    80003fe0:	8b2e                	mv	s6,a1
    80003fe2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003fe4:	00054703          	lbu	a4,0(a0)
    80003fe8:	02f00793          	li	a5,47
    80003fec:	02f70363          	beq	a4,a5,80004012 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003ff0:	ffffe097          	auipc	ra,0xffffe
    80003ff4:	aea080e7          	jalr	-1302(ra) # 80001ada <myproc>
    80003ff8:	15053503          	ld	a0,336(a0)
    80003ffc:	00000097          	auipc	ra,0x0
    80004000:	948080e7          	jalr	-1720(ra) # 80003944 <idup>
    80004004:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004006:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000400a:	4cb5                	li	s9,13
  len = path - s;
    8000400c:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000400e:	4c05                	li	s8,1
    80004010:	a87d                	j	800040ce <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004012:	4585                	li	a1,1
    80004014:	4505                	li	a0,1
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	632080e7          	jalr	1586(ra) # 80003648 <iget>
    8000401e:	8a2a                	mv	s4,a0
    80004020:	b7dd                	j	80004006 <namex+0x44>
      iunlockput(ip);
    80004022:	8552                	mv	a0,s4
    80004024:	00000097          	auipc	ra,0x0
    80004028:	c6a080e7          	jalr	-918(ra) # 80003c8e <iunlockput>
      return 0;
    8000402c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000402e:	8552                	mv	a0,s4
    80004030:	60e6                	ld	ra,88(sp)
    80004032:	6446                	ld	s0,80(sp)
    80004034:	64a6                	ld	s1,72(sp)
    80004036:	6906                	ld	s2,64(sp)
    80004038:	79e2                	ld	s3,56(sp)
    8000403a:	7a42                	ld	s4,48(sp)
    8000403c:	7aa2                	ld	s5,40(sp)
    8000403e:	7b02                	ld	s6,32(sp)
    80004040:	6be2                	ld	s7,24(sp)
    80004042:	6c42                	ld	s8,16(sp)
    80004044:	6ca2                	ld	s9,8(sp)
    80004046:	6d02                	ld	s10,0(sp)
    80004048:	6125                	addi	sp,sp,96
    8000404a:	8082                	ret
      iunlock(ip);
    8000404c:	8552                	mv	a0,s4
    8000404e:	00000097          	auipc	ra,0x0
    80004052:	9f6080e7          	jalr	-1546(ra) # 80003a44 <iunlock>
      return ip;
    80004056:	bfe1                	j	8000402e <namex+0x6c>
      iunlockput(ip);
    80004058:	8552                	mv	a0,s4
    8000405a:	00000097          	auipc	ra,0x0
    8000405e:	c34080e7          	jalr	-972(ra) # 80003c8e <iunlockput>
      return 0;
    80004062:	8a4e                	mv	s4,s3
    80004064:	b7e9                	j	8000402e <namex+0x6c>
  len = path - s;
    80004066:	40998633          	sub	a2,s3,s1
    8000406a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000406e:	09acd863          	bge	s9,s10,800040fe <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80004072:	4639                	li	a2,14
    80004074:	85a6                	mv	a1,s1
    80004076:	8556                	mv	a0,s5
    80004078:	ffffd097          	auipc	ra,0xffffd
    8000407c:	d00080e7          	jalr	-768(ra) # 80000d78 <memmove>
    80004080:	84ce                	mv	s1,s3
  while(*path == '/')
    80004082:	0004c783          	lbu	a5,0(s1)
    80004086:	01279763          	bne	a5,s2,80004094 <namex+0xd2>
    path++;
    8000408a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000408c:	0004c783          	lbu	a5,0(s1)
    80004090:	ff278de3          	beq	a5,s2,8000408a <namex+0xc8>
    ilock(ip);
    80004094:	8552                	mv	a0,s4
    80004096:	00000097          	auipc	ra,0x0
    8000409a:	8ec080e7          	jalr	-1812(ra) # 80003982 <ilock>
    if(ip->type != T_DIR){
    8000409e:	044a1783          	lh	a5,68(s4)
    800040a2:	f98790e3          	bne	a5,s8,80004022 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800040a6:	000b0563          	beqz	s6,800040b0 <namex+0xee>
    800040aa:	0004c783          	lbu	a5,0(s1)
    800040ae:	dfd9                	beqz	a5,8000404c <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800040b0:	865e                	mv	a2,s7
    800040b2:	85d6                	mv	a1,s5
    800040b4:	8552                	mv	a0,s4
    800040b6:	00000097          	auipc	ra,0x0
    800040ba:	e5c080e7          	jalr	-420(ra) # 80003f12 <dirlookup>
    800040be:	89aa                	mv	s3,a0
    800040c0:	dd41                	beqz	a0,80004058 <namex+0x96>
    iunlockput(ip);
    800040c2:	8552                	mv	a0,s4
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	bca080e7          	jalr	-1078(ra) # 80003c8e <iunlockput>
    ip = next;
    800040cc:	8a4e                	mv	s4,s3
  while(*path == '/')
    800040ce:	0004c783          	lbu	a5,0(s1)
    800040d2:	01279763          	bne	a5,s2,800040e0 <namex+0x11e>
    path++;
    800040d6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040d8:	0004c783          	lbu	a5,0(s1)
    800040dc:	ff278de3          	beq	a5,s2,800040d6 <namex+0x114>
  if(*path == 0)
    800040e0:	cb9d                	beqz	a5,80004116 <namex+0x154>
  while(*path != '/' && *path != 0)
    800040e2:	0004c783          	lbu	a5,0(s1)
    800040e6:	89a6                	mv	s3,s1
  len = path - s;
    800040e8:	8d5e                	mv	s10,s7
    800040ea:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800040ec:	01278963          	beq	a5,s2,800040fe <namex+0x13c>
    800040f0:	dbbd                	beqz	a5,80004066 <namex+0xa4>
    path++;
    800040f2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800040f4:	0009c783          	lbu	a5,0(s3)
    800040f8:	ff279ce3          	bne	a5,s2,800040f0 <namex+0x12e>
    800040fc:	b7ad                	j	80004066 <namex+0xa4>
    memmove(name, s, len);
    800040fe:	2601                	sext.w	a2,a2
    80004100:	85a6                	mv	a1,s1
    80004102:	8556                	mv	a0,s5
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	c74080e7          	jalr	-908(ra) # 80000d78 <memmove>
    name[len] = 0;
    8000410c:	9d56                	add	s10,s10,s5
    8000410e:	000d0023          	sb	zero,0(s10)
    80004112:	84ce                	mv	s1,s3
    80004114:	b7bd                	j	80004082 <namex+0xc0>
  if(nameiparent){
    80004116:	f00b0ce3          	beqz	s6,8000402e <namex+0x6c>
    iput(ip);
    8000411a:	8552                	mv	a0,s4
    8000411c:	00000097          	auipc	ra,0x0
    80004120:	aca080e7          	jalr	-1334(ra) # 80003be6 <iput>
    return 0;
    80004124:	4a01                	li	s4,0
    80004126:	b721                	j	8000402e <namex+0x6c>

0000000080004128 <dirlink>:
{
    80004128:	7139                	addi	sp,sp,-64
    8000412a:	fc06                	sd	ra,56(sp)
    8000412c:	f822                	sd	s0,48(sp)
    8000412e:	f426                	sd	s1,40(sp)
    80004130:	f04a                	sd	s2,32(sp)
    80004132:	ec4e                	sd	s3,24(sp)
    80004134:	e852                	sd	s4,16(sp)
    80004136:	0080                	addi	s0,sp,64
    80004138:	892a                	mv	s2,a0
    8000413a:	8a2e                	mv	s4,a1
    8000413c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000413e:	4601                	li	a2,0
    80004140:	00000097          	auipc	ra,0x0
    80004144:	dd2080e7          	jalr	-558(ra) # 80003f12 <dirlookup>
    80004148:	e93d                	bnez	a0,800041be <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000414a:	04c92483          	lw	s1,76(s2)
    8000414e:	c49d                	beqz	s1,8000417c <dirlink+0x54>
    80004150:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004152:	4741                	li	a4,16
    80004154:	86a6                	mv	a3,s1
    80004156:	fc040613          	addi	a2,s0,-64
    8000415a:	4581                	li	a1,0
    8000415c:	854a                	mv	a0,s2
    8000415e:	00000097          	auipc	ra,0x0
    80004162:	b82080e7          	jalr	-1150(ra) # 80003ce0 <readi>
    80004166:	47c1                	li	a5,16
    80004168:	06f51163          	bne	a0,a5,800041ca <dirlink+0xa2>
    if(de.inum == 0)
    8000416c:	fc045783          	lhu	a5,-64(s0)
    80004170:	c791                	beqz	a5,8000417c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004172:	24c1                	addiw	s1,s1,16
    80004174:	04c92783          	lw	a5,76(s2)
    80004178:	fcf4ede3          	bltu	s1,a5,80004152 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000417c:	4639                	li	a2,14
    8000417e:	85d2                	mv	a1,s4
    80004180:	fc240513          	addi	a0,s0,-62
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	ca4080e7          	jalr	-860(ra) # 80000e28 <strncpy>
  de.inum = inum;
    8000418c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004190:	4741                	li	a4,16
    80004192:	86a6                	mv	a3,s1
    80004194:	fc040613          	addi	a2,s0,-64
    80004198:	4581                	li	a1,0
    8000419a:	854a                	mv	a0,s2
    8000419c:	00000097          	auipc	ra,0x0
    800041a0:	c3c080e7          	jalr	-964(ra) # 80003dd8 <writei>
    800041a4:	1541                	addi	a0,a0,-16
    800041a6:	00a03533          	snez	a0,a0
    800041aa:	40a00533          	neg	a0,a0
}
    800041ae:	70e2                	ld	ra,56(sp)
    800041b0:	7442                	ld	s0,48(sp)
    800041b2:	74a2                	ld	s1,40(sp)
    800041b4:	7902                	ld	s2,32(sp)
    800041b6:	69e2                	ld	s3,24(sp)
    800041b8:	6a42                	ld	s4,16(sp)
    800041ba:	6121                	addi	sp,sp,64
    800041bc:	8082                	ret
    iput(ip);
    800041be:	00000097          	auipc	ra,0x0
    800041c2:	a28080e7          	jalr	-1496(ra) # 80003be6 <iput>
    return -1;
    800041c6:	557d                	li	a0,-1
    800041c8:	b7dd                	j	800041ae <dirlink+0x86>
      panic("dirlink read");
    800041ca:	00004517          	auipc	a0,0x4
    800041ce:	48e50513          	addi	a0,a0,1166 # 80008658 <syscalls+0x1d8>
    800041d2:	ffffc097          	auipc	ra,0xffffc
    800041d6:	36e080e7          	jalr	878(ra) # 80000540 <panic>

00000000800041da <namei>:

struct inode*
namei(char *path)
{
    800041da:	1101                	addi	sp,sp,-32
    800041dc:	ec06                	sd	ra,24(sp)
    800041de:	e822                	sd	s0,16(sp)
    800041e0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800041e2:	fe040613          	addi	a2,s0,-32
    800041e6:	4581                	li	a1,0
    800041e8:	00000097          	auipc	ra,0x0
    800041ec:	dda080e7          	jalr	-550(ra) # 80003fc2 <namex>
}
    800041f0:	60e2                	ld	ra,24(sp)
    800041f2:	6442                	ld	s0,16(sp)
    800041f4:	6105                	addi	sp,sp,32
    800041f6:	8082                	ret

00000000800041f8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800041f8:	1141                	addi	sp,sp,-16
    800041fa:	e406                	sd	ra,8(sp)
    800041fc:	e022                	sd	s0,0(sp)
    800041fe:	0800                	addi	s0,sp,16
    80004200:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004202:	4585                	li	a1,1
    80004204:	00000097          	auipc	ra,0x0
    80004208:	dbe080e7          	jalr	-578(ra) # 80003fc2 <namex>
}
    8000420c:	60a2                	ld	ra,8(sp)
    8000420e:	6402                	ld	s0,0(sp)
    80004210:	0141                	addi	sp,sp,16
    80004212:	8082                	ret

0000000080004214 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004214:	1101                	addi	sp,sp,-32
    80004216:	ec06                	sd	ra,24(sp)
    80004218:	e822                	sd	s0,16(sp)
    8000421a:	e426                	sd	s1,8(sp)
    8000421c:	e04a                	sd	s2,0(sp)
    8000421e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004220:	0001d917          	auipc	s2,0x1d
    80004224:	94090913          	addi	s2,s2,-1728 # 80020b60 <log>
    80004228:	01892583          	lw	a1,24(s2)
    8000422c:	02892503          	lw	a0,40(s2)
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	e80080e7          	jalr	-384(ra) # 800030b0 <bread>
    80004238:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000423a:	02c92683          	lw	a3,44(s2)
    8000423e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004240:	02d05863          	blez	a3,80004270 <write_head+0x5c>
    80004244:	0001d797          	auipc	a5,0x1d
    80004248:	94c78793          	addi	a5,a5,-1716 # 80020b90 <log+0x30>
    8000424c:	05c50713          	addi	a4,a0,92
    80004250:	36fd                	addiw	a3,a3,-1
    80004252:	02069613          	slli	a2,a3,0x20
    80004256:	01e65693          	srli	a3,a2,0x1e
    8000425a:	0001d617          	auipc	a2,0x1d
    8000425e:	93a60613          	addi	a2,a2,-1734 # 80020b94 <log+0x34>
    80004262:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004264:	4390                	lw	a2,0(a5)
    80004266:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004268:	0791                	addi	a5,a5,4
    8000426a:	0711                	addi	a4,a4,4
    8000426c:	fed79ce3          	bne	a5,a3,80004264 <write_head+0x50>
  }
  bwrite(buf);
    80004270:	8526                	mv	a0,s1
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	f30080e7          	jalr	-208(ra) # 800031a2 <bwrite>
  brelse(buf);
    8000427a:	8526                	mv	a0,s1
    8000427c:	fffff097          	auipc	ra,0xfffff
    80004280:	f64080e7          	jalr	-156(ra) # 800031e0 <brelse>
}
    80004284:	60e2                	ld	ra,24(sp)
    80004286:	6442                	ld	s0,16(sp)
    80004288:	64a2                	ld	s1,8(sp)
    8000428a:	6902                	ld	s2,0(sp)
    8000428c:	6105                	addi	sp,sp,32
    8000428e:	8082                	ret

0000000080004290 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004290:	0001d797          	auipc	a5,0x1d
    80004294:	8fc7a783          	lw	a5,-1796(a5) # 80020b8c <log+0x2c>
    80004298:	0af05d63          	blez	a5,80004352 <install_trans+0xc2>
{
    8000429c:	7139                	addi	sp,sp,-64
    8000429e:	fc06                	sd	ra,56(sp)
    800042a0:	f822                	sd	s0,48(sp)
    800042a2:	f426                	sd	s1,40(sp)
    800042a4:	f04a                	sd	s2,32(sp)
    800042a6:	ec4e                	sd	s3,24(sp)
    800042a8:	e852                	sd	s4,16(sp)
    800042aa:	e456                	sd	s5,8(sp)
    800042ac:	e05a                	sd	s6,0(sp)
    800042ae:	0080                	addi	s0,sp,64
    800042b0:	8b2a                	mv	s6,a0
    800042b2:	0001da97          	auipc	s5,0x1d
    800042b6:	8dea8a93          	addi	s5,s5,-1826 # 80020b90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042ba:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042bc:	0001d997          	auipc	s3,0x1d
    800042c0:	8a498993          	addi	s3,s3,-1884 # 80020b60 <log>
    800042c4:	a00d                	j	800042e6 <install_trans+0x56>
    brelse(lbuf);
    800042c6:	854a                	mv	a0,s2
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	f18080e7          	jalr	-232(ra) # 800031e0 <brelse>
    brelse(dbuf);
    800042d0:	8526                	mv	a0,s1
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	f0e080e7          	jalr	-242(ra) # 800031e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042da:	2a05                	addiw	s4,s4,1
    800042dc:	0a91                	addi	s5,s5,4
    800042de:	02c9a783          	lw	a5,44(s3)
    800042e2:	04fa5e63          	bge	s4,a5,8000433e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042e6:	0189a583          	lw	a1,24(s3)
    800042ea:	014585bb          	addw	a1,a1,s4
    800042ee:	2585                	addiw	a1,a1,1
    800042f0:	0289a503          	lw	a0,40(s3)
    800042f4:	fffff097          	auipc	ra,0xfffff
    800042f8:	dbc080e7          	jalr	-580(ra) # 800030b0 <bread>
    800042fc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800042fe:	000aa583          	lw	a1,0(s5)
    80004302:	0289a503          	lw	a0,40(s3)
    80004306:	fffff097          	auipc	ra,0xfffff
    8000430a:	daa080e7          	jalr	-598(ra) # 800030b0 <bread>
    8000430e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004310:	40000613          	li	a2,1024
    80004314:	05890593          	addi	a1,s2,88
    80004318:	05850513          	addi	a0,a0,88
    8000431c:	ffffd097          	auipc	ra,0xffffd
    80004320:	a5c080e7          	jalr	-1444(ra) # 80000d78 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004324:	8526                	mv	a0,s1
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	e7c080e7          	jalr	-388(ra) # 800031a2 <bwrite>
    if(recovering == 0)
    8000432e:	f80b1ce3          	bnez	s6,800042c6 <install_trans+0x36>
      bunpin(dbuf);
    80004332:	8526                	mv	a0,s1
    80004334:	fffff097          	auipc	ra,0xfffff
    80004338:	f86080e7          	jalr	-122(ra) # 800032ba <bunpin>
    8000433c:	b769                	j	800042c6 <install_trans+0x36>
}
    8000433e:	70e2                	ld	ra,56(sp)
    80004340:	7442                	ld	s0,48(sp)
    80004342:	74a2                	ld	s1,40(sp)
    80004344:	7902                	ld	s2,32(sp)
    80004346:	69e2                	ld	s3,24(sp)
    80004348:	6a42                	ld	s4,16(sp)
    8000434a:	6aa2                	ld	s5,8(sp)
    8000434c:	6b02                	ld	s6,0(sp)
    8000434e:	6121                	addi	sp,sp,64
    80004350:	8082                	ret
    80004352:	8082                	ret

0000000080004354 <initlog>:
{
    80004354:	7179                	addi	sp,sp,-48
    80004356:	f406                	sd	ra,40(sp)
    80004358:	f022                	sd	s0,32(sp)
    8000435a:	ec26                	sd	s1,24(sp)
    8000435c:	e84a                	sd	s2,16(sp)
    8000435e:	e44e                	sd	s3,8(sp)
    80004360:	1800                	addi	s0,sp,48
    80004362:	892a                	mv	s2,a0
    80004364:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004366:	0001c497          	auipc	s1,0x1c
    8000436a:	7fa48493          	addi	s1,s1,2042 # 80020b60 <log>
    8000436e:	00004597          	auipc	a1,0x4
    80004372:	2fa58593          	addi	a1,a1,762 # 80008668 <syscalls+0x1e8>
    80004376:	8526                	mv	a0,s1
    80004378:	ffffd097          	auipc	ra,0xffffd
    8000437c:	818080e7          	jalr	-2024(ra) # 80000b90 <initlock>
  log.start = sb->logstart;
    80004380:	0149a583          	lw	a1,20(s3)
    80004384:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004386:	0109a783          	lw	a5,16(s3)
    8000438a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000438c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004390:	854a                	mv	a0,s2
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	d1e080e7          	jalr	-738(ra) # 800030b0 <bread>
  log.lh.n = lh->n;
    8000439a:	4d34                	lw	a3,88(a0)
    8000439c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000439e:	02d05663          	blez	a3,800043ca <initlog+0x76>
    800043a2:	05c50793          	addi	a5,a0,92
    800043a6:	0001c717          	auipc	a4,0x1c
    800043aa:	7ea70713          	addi	a4,a4,2026 # 80020b90 <log+0x30>
    800043ae:	36fd                	addiw	a3,a3,-1
    800043b0:	02069613          	slli	a2,a3,0x20
    800043b4:	01e65693          	srli	a3,a2,0x1e
    800043b8:	06050613          	addi	a2,a0,96
    800043bc:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800043be:	4390                	lw	a2,0(a5)
    800043c0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800043c2:	0791                	addi	a5,a5,4
    800043c4:	0711                	addi	a4,a4,4
    800043c6:	fed79ce3          	bne	a5,a3,800043be <initlog+0x6a>
  brelse(buf);
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	e16080e7          	jalr	-490(ra) # 800031e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800043d2:	4505                	li	a0,1
    800043d4:	00000097          	auipc	ra,0x0
    800043d8:	ebc080e7          	jalr	-324(ra) # 80004290 <install_trans>
  log.lh.n = 0;
    800043dc:	0001c797          	auipc	a5,0x1c
    800043e0:	7a07a823          	sw	zero,1968(a5) # 80020b8c <log+0x2c>
  write_head(); // clear the log
    800043e4:	00000097          	auipc	ra,0x0
    800043e8:	e30080e7          	jalr	-464(ra) # 80004214 <write_head>
}
    800043ec:	70a2                	ld	ra,40(sp)
    800043ee:	7402                	ld	s0,32(sp)
    800043f0:	64e2                	ld	s1,24(sp)
    800043f2:	6942                	ld	s2,16(sp)
    800043f4:	69a2                	ld	s3,8(sp)
    800043f6:	6145                	addi	sp,sp,48
    800043f8:	8082                	ret

00000000800043fa <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800043fa:	1101                	addi	sp,sp,-32
    800043fc:	ec06                	sd	ra,24(sp)
    800043fe:	e822                	sd	s0,16(sp)
    80004400:	e426                	sd	s1,8(sp)
    80004402:	e04a                	sd	s2,0(sp)
    80004404:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004406:	0001c517          	auipc	a0,0x1c
    8000440a:	75a50513          	addi	a0,a0,1882 # 80020b60 <log>
    8000440e:	ffffd097          	auipc	ra,0xffffd
    80004412:	812080e7          	jalr	-2030(ra) # 80000c20 <acquire>
  while(1){
    if(log.committing){
    80004416:	0001c497          	auipc	s1,0x1c
    8000441a:	74a48493          	addi	s1,s1,1866 # 80020b60 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000441e:	4979                	li	s2,30
    80004420:	a039                	j	8000442e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004422:	85a6                	mv	a1,s1
    80004424:	8526                	mv	a0,s1
    80004426:	ffffe097          	auipc	ra,0xffffe
    8000442a:	d5c080e7          	jalr	-676(ra) # 80002182 <sleep>
    if(log.committing){
    8000442e:	50dc                	lw	a5,36(s1)
    80004430:	fbed                	bnez	a5,80004422 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004432:	5098                	lw	a4,32(s1)
    80004434:	2705                	addiw	a4,a4,1
    80004436:	0007069b          	sext.w	a3,a4
    8000443a:	0027179b          	slliw	a5,a4,0x2
    8000443e:	9fb9                	addw	a5,a5,a4
    80004440:	0017979b          	slliw	a5,a5,0x1
    80004444:	54d8                	lw	a4,44(s1)
    80004446:	9fb9                	addw	a5,a5,a4
    80004448:	00f95963          	bge	s2,a5,8000445a <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000444c:	85a6                	mv	a1,s1
    8000444e:	8526                	mv	a0,s1
    80004450:	ffffe097          	auipc	ra,0xffffe
    80004454:	d32080e7          	jalr	-718(ra) # 80002182 <sleep>
    80004458:	bfd9                	j	8000442e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000445a:	0001c517          	auipc	a0,0x1c
    8000445e:	70650513          	addi	a0,a0,1798 # 80020b60 <log>
    80004462:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004464:	ffffd097          	auipc	ra,0xffffd
    80004468:	870080e7          	jalr	-1936(ra) # 80000cd4 <release>
      break;
    }
  }
}
    8000446c:	60e2                	ld	ra,24(sp)
    8000446e:	6442                	ld	s0,16(sp)
    80004470:	64a2                	ld	s1,8(sp)
    80004472:	6902                	ld	s2,0(sp)
    80004474:	6105                	addi	sp,sp,32
    80004476:	8082                	ret

0000000080004478 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004478:	7139                	addi	sp,sp,-64
    8000447a:	fc06                	sd	ra,56(sp)
    8000447c:	f822                	sd	s0,48(sp)
    8000447e:	f426                	sd	s1,40(sp)
    80004480:	f04a                	sd	s2,32(sp)
    80004482:	ec4e                	sd	s3,24(sp)
    80004484:	e852                	sd	s4,16(sp)
    80004486:	e456                	sd	s5,8(sp)
    80004488:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000448a:	0001c497          	auipc	s1,0x1c
    8000448e:	6d648493          	addi	s1,s1,1750 # 80020b60 <log>
    80004492:	8526                	mv	a0,s1
    80004494:	ffffc097          	auipc	ra,0xffffc
    80004498:	78c080e7          	jalr	1932(ra) # 80000c20 <acquire>
  log.outstanding -= 1;
    8000449c:	509c                	lw	a5,32(s1)
    8000449e:	37fd                	addiw	a5,a5,-1
    800044a0:	0007891b          	sext.w	s2,a5
    800044a4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800044a6:	50dc                	lw	a5,36(s1)
    800044a8:	e7b9                	bnez	a5,800044f6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800044aa:	04091e63          	bnez	s2,80004506 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800044ae:	0001c497          	auipc	s1,0x1c
    800044b2:	6b248493          	addi	s1,s1,1714 # 80020b60 <log>
    800044b6:	4785                	li	a5,1
    800044b8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800044ba:	8526                	mv	a0,s1
    800044bc:	ffffd097          	auipc	ra,0xffffd
    800044c0:	818080e7          	jalr	-2024(ra) # 80000cd4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800044c4:	54dc                	lw	a5,44(s1)
    800044c6:	06f04763          	bgtz	a5,80004534 <end_op+0xbc>
    acquire(&log.lock);
    800044ca:	0001c497          	auipc	s1,0x1c
    800044ce:	69648493          	addi	s1,s1,1686 # 80020b60 <log>
    800044d2:	8526                	mv	a0,s1
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	74c080e7          	jalr	1868(ra) # 80000c20 <acquire>
    log.committing = 0;
    800044dc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800044e0:	8526                	mv	a0,s1
    800044e2:	ffffe097          	auipc	ra,0xffffe
    800044e6:	d04080e7          	jalr	-764(ra) # 800021e6 <wakeup>
    release(&log.lock);
    800044ea:	8526                	mv	a0,s1
    800044ec:	ffffc097          	auipc	ra,0xffffc
    800044f0:	7e8080e7          	jalr	2024(ra) # 80000cd4 <release>
}
    800044f4:	a03d                	j	80004522 <end_op+0xaa>
    panic("log.committing");
    800044f6:	00004517          	auipc	a0,0x4
    800044fa:	17a50513          	addi	a0,a0,378 # 80008670 <syscalls+0x1f0>
    800044fe:	ffffc097          	auipc	ra,0xffffc
    80004502:	042080e7          	jalr	66(ra) # 80000540 <panic>
    wakeup(&log);
    80004506:	0001c497          	auipc	s1,0x1c
    8000450a:	65a48493          	addi	s1,s1,1626 # 80020b60 <log>
    8000450e:	8526                	mv	a0,s1
    80004510:	ffffe097          	auipc	ra,0xffffe
    80004514:	cd6080e7          	jalr	-810(ra) # 800021e6 <wakeup>
  release(&log.lock);
    80004518:	8526                	mv	a0,s1
    8000451a:	ffffc097          	auipc	ra,0xffffc
    8000451e:	7ba080e7          	jalr	1978(ra) # 80000cd4 <release>
}
    80004522:	70e2                	ld	ra,56(sp)
    80004524:	7442                	ld	s0,48(sp)
    80004526:	74a2                	ld	s1,40(sp)
    80004528:	7902                	ld	s2,32(sp)
    8000452a:	69e2                	ld	s3,24(sp)
    8000452c:	6a42                	ld	s4,16(sp)
    8000452e:	6aa2                	ld	s5,8(sp)
    80004530:	6121                	addi	sp,sp,64
    80004532:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004534:	0001ca97          	auipc	s5,0x1c
    80004538:	65ca8a93          	addi	s5,s5,1628 # 80020b90 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000453c:	0001ca17          	auipc	s4,0x1c
    80004540:	624a0a13          	addi	s4,s4,1572 # 80020b60 <log>
    80004544:	018a2583          	lw	a1,24(s4)
    80004548:	012585bb          	addw	a1,a1,s2
    8000454c:	2585                	addiw	a1,a1,1
    8000454e:	028a2503          	lw	a0,40(s4)
    80004552:	fffff097          	auipc	ra,0xfffff
    80004556:	b5e080e7          	jalr	-1186(ra) # 800030b0 <bread>
    8000455a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000455c:	000aa583          	lw	a1,0(s5)
    80004560:	028a2503          	lw	a0,40(s4)
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	b4c080e7          	jalr	-1204(ra) # 800030b0 <bread>
    8000456c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000456e:	40000613          	li	a2,1024
    80004572:	05850593          	addi	a1,a0,88
    80004576:	05848513          	addi	a0,s1,88
    8000457a:	ffffc097          	auipc	ra,0xffffc
    8000457e:	7fe080e7          	jalr	2046(ra) # 80000d78 <memmove>
    bwrite(to);  // write the log
    80004582:	8526                	mv	a0,s1
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	c1e080e7          	jalr	-994(ra) # 800031a2 <bwrite>
    brelse(from);
    8000458c:	854e                	mv	a0,s3
    8000458e:	fffff097          	auipc	ra,0xfffff
    80004592:	c52080e7          	jalr	-942(ra) # 800031e0 <brelse>
    brelse(to);
    80004596:	8526                	mv	a0,s1
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	c48080e7          	jalr	-952(ra) # 800031e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045a0:	2905                	addiw	s2,s2,1
    800045a2:	0a91                	addi	s5,s5,4
    800045a4:	02ca2783          	lw	a5,44(s4)
    800045a8:	f8f94ee3          	blt	s2,a5,80004544 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800045ac:	00000097          	auipc	ra,0x0
    800045b0:	c68080e7          	jalr	-920(ra) # 80004214 <write_head>
    install_trans(0); // Now install writes to home locations
    800045b4:	4501                	li	a0,0
    800045b6:	00000097          	auipc	ra,0x0
    800045ba:	cda080e7          	jalr	-806(ra) # 80004290 <install_trans>
    log.lh.n = 0;
    800045be:	0001c797          	auipc	a5,0x1c
    800045c2:	5c07a723          	sw	zero,1486(a5) # 80020b8c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800045c6:	00000097          	auipc	ra,0x0
    800045ca:	c4e080e7          	jalr	-946(ra) # 80004214 <write_head>
    800045ce:	bdf5                	j	800044ca <end_op+0x52>

00000000800045d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800045d0:	1101                	addi	sp,sp,-32
    800045d2:	ec06                	sd	ra,24(sp)
    800045d4:	e822                	sd	s0,16(sp)
    800045d6:	e426                	sd	s1,8(sp)
    800045d8:	e04a                	sd	s2,0(sp)
    800045da:	1000                	addi	s0,sp,32
    800045dc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800045de:	0001c917          	auipc	s2,0x1c
    800045e2:	58290913          	addi	s2,s2,1410 # 80020b60 <log>
    800045e6:	854a                	mv	a0,s2
    800045e8:	ffffc097          	auipc	ra,0xffffc
    800045ec:	638080e7          	jalr	1592(ra) # 80000c20 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800045f0:	02c92603          	lw	a2,44(s2)
    800045f4:	47f5                	li	a5,29
    800045f6:	06c7c563          	blt	a5,a2,80004660 <log_write+0x90>
    800045fa:	0001c797          	auipc	a5,0x1c
    800045fe:	5827a783          	lw	a5,1410(a5) # 80020b7c <log+0x1c>
    80004602:	37fd                	addiw	a5,a5,-1
    80004604:	04f65e63          	bge	a2,a5,80004660 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004608:	0001c797          	auipc	a5,0x1c
    8000460c:	5787a783          	lw	a5,1400(a5) # 80020b80 <log+0x20>
    80004610:	06f05063          	blez	a5,80004670 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004614:	4781                	li	a5,0
    80004616:	06c05563          	blez	a2,80004680 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000461a:	44cc                	lw	a1,12(s1)
    8000461c:	0001c717          	auipc	a4,0x1c
    80004620:	57470713          	addi	a4,a4,1396 # 80020b90 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004624:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004626:	4314                	lw	a3,0(a4)
    80004628:	04b68c63          	beq	a3,a1,80004680 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000462c:	2785                	addiw	a5,a5,1
    8000462e:	0711                	addi	a4,a4,4
    80004630:	fef61be3          	bne	a2,a5,80004626 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004634:	0621                	addi	a2,a2,8
    80004636:	060a                	slli	a2,a2,0x2
    80004638:	0001c797          	auipc	a5,0x1c
    8000463c:	52878793          	addi	a5,a5,1320 # 80020b60 <log>
    80004640:	97b2                	add	a5,a5,a2
    80004642:	44d8                	lw	a4,12(s1)
    80004644:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004646:	8526                	mv	a0,s1
    80004648:	fffff097          	auipc	ra,0xfffff
    8000464c:	c36080e7          	jalr	-970(ra) # 8000327e <bpin>
    log.lh.n++;
    80004650:	0001c717          	auipc	a4,0x1c
    80004654:	51070713          	addi	a4,a4,1296 # 80020b60 <log>
    80004658:	575c                	lw	a5,44(a4)
    8000465a:	2785                	addiw	a5,a5,1
    8000465c:	d75c                	sw	a5,44(a4)
    8000465e:	a82d                	j	80004698 <log_write+0xc8>
    panic("too big a transaction");
    80004660:	00004517          	auipc	a0,0x4
    80004664:	02050513          	addi	a0,a0,32 # 80008680 <syscalls+0x200>
    80004668:	ffffc097          	auipc	ra,0xffffc
    8000466c:	ed8080e7          	jalr	-296(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    80004670:	00004517          	auipc	a0,0x4
    80004674:	02850513          	addi	a0,a0,40 # 80008698 <syscalls+0x218>
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	ec8080e7          	jalr	-312(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    80004680:	00878693          	addi	a3,a5,8
    80004684:	068a                	slli	a3,a3,0x2
    80004686:	0001c717          	auipc	a4,0x1c
    8000468a:	4da70713          	addi	a4,a4,1242 # 80020b60 <log>
    8000468e:	9736                	add	a4,a4,a3
    80004690:	44d4                	lw	a3,12(s1)
    80004692:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004694:	faf609e3          	beq	a2,a5,80004646 <log_write+0x76>
  }
  release(&log.lock);
    80004698:	0001c517          	auipc	a0,0x1c
    8000469c:	4c850513          	addi	a0,a0,1224 # 80020b60 <log>
    800046a0:	ffffc097          	auipc	ra,0xffffc
    800046a4:	634080e7          	jalr	1588(ra) # 80000cd4 <release>
}
    800046a8:	60e2                	ld	ra,24(sp)
    800046aa:	6442                	ld	s0,16(sp)
    800046ac:	64a2                	ld	s1,8(sp)
    800046ae:	6902                	ld	s2,0(sp)
    800046b0:	6105                	addi	sp,sp,32
    800046b2:	8082                	ret

00000000800046b4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800046b4:	1101                	addi	sp,sp,-32
    800046b6:	ec06                	sd	ra,24(sp)
    800046b8:	e822                	sd	s0,16(sp)
    800046ba:	e426                	sd	s1,8(sp)
    800046bc:	e04a                	sd	s2,0(sp)
    800046be:	1000                	addi	s0,sp,32
    800046c0:	84aa                	mv	s1,a0
    800046c2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800046c4:	00004597          	auipc	a1,0x4
    800046c8:	ff458593          	addi	a1,a1,-12 # 800086b8 <syscalls+0x238>
    800046cc:	0521                	addi	a0,a0,8
    800046ce:	ffffc097          	auipc	ra,0xffffc
    800046d2:	4c2080e7          	jalr	1218(ra) # 80000b90 <initlock>
  lk->name = name;
    800046d6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800046da:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046de:	0204a423          	sw	zero,40(s1)
}
    800046e2:	60e2                	ld	ra,24(sp)
    800046e4:	6442                	ld	s0,16(sp)
    800046e6:	64a2                	ld	s1,8(sp)
    800046e8:	6902                	ld	s2,0(sp)
    800046ea:	6105                	addi	sp,sp,32
    800046ec:	8082                	ret

00000000800046ee <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800046ee:	1101                	addi	sp,sp,-32
    800046f0:	ec06                	sd	ra,24(sp)
    800046f2:	e822                	sd	s0,16(sp)
    800046f4:	e426                	sd	s1,8(sp)
    800046f6:	e04a                	sd	s2,0(sp)
    800046f8:	1000                	addi	s0,sp,32
    800046fa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800046fc:	00850913          	addi	s2,a0,8
    80004700:	854a                	mv	a0,s2
    80004702:	ffffc097          	auipc	ra,0xffffc
    80004706:	51e080e7          	jalr	1310(ra) # 80000c20 <acquire>
  while (lk->locked) {
    8000470a:	409c                	lw	a5,0(s1)
    8000470c:	cb89                	beqz	a5,8000471e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000470e:	85ca                	mv	a1,s2
    80004710:	8526                	mv	a0,s1
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	a70080e7          	jalr	-1424(ra) # 80002182 <sleep>
  while (lk->locked) {
    8000471a:	409c                	lw	a5,0(s1)
    8000471c:	fbed                	bnez	a5,8000470e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000471e:	4785                	li	a5,1
    80004720:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004722:	ffffd097          	auipc	ra,0xffffd
    80004726:	3b8080e7          	jalr	952(ra) # 80001ada <myproc>
    8000472a:	591c                	lw	a5,48(a0)
    8000472c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000472e:	854a                	mv	a0,s2
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	5a4080e7          	jalr	1444(ra) # 80000cd4 <release>
}
    80004738:	60e2                	ld	ra,24(sp)
    8000473a:	6442                	ld	s0,16(sp)
    8000473c:	64a2                	ld	s1,8(sp)
    8000473e:	6902                	ld	s2,0(sp)
    80004740:	6105                	addi	sp,sp,32
    80004742:	8082                	ret

0000000080004744 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004744:	1101                	addi	sp,sp,-32
    80004746:	ec06                	sd	ra,24(sp)
    80004748:	e822                	sd	s0,16(sp)
    8000474a:	e426                	sd	s1,8(sp)
    8000474c:	e04a                	sd	s2,0(sp)
    8000474e:	1000                	addi	s0,sp,32
    80004750:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004752:	00850913          	addi	s2,a0,8
    80004756:	854a                	mv	a0,s2
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	4c8080e7          	jalr	1224(ra) # 80000c20 <acquire>
  lk->locked = 0;
    80004760:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004764:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004768:	8526                	mv	a0,s1
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	a7c080e7          	jalr	-1412(ra) # 800021e6 <wakeup>
  release(&lk->lk);
    80004772:	854a                	mv	a0,s2
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	560080e7          	jalr	1376(ra) # 80000cd4 <release>
}
    8000477c:	60e2                	ld	ra,24(sp)
    8000477e:	6442                	ld	s0,16(sp)
    80004780:	64a2                	ld	s1,8(sp)
    80004782:	6902                	ld	s2,0(sp)
    80004784:	6105                	addi	sp,sp,32
    80004786:	8082                	ret

0000000080004788 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004788:	7179                	addi	sp,sp,-48
    8000478a:	f406                	sd	ra,40(sp)
    8000478c:	f022                	sd	s0,32(sp)
    8000478e:	ec26                	sd	s1,24(sp)
    80004790:	e84a                	sd	s2,16(sp)
    80004792:	e44e                	sd	s3,8(sp)
    80004794:	1800                	addi	s0,sp,48
    80004796:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004798:	00850913          	addi	s2,a0,8
    8000479c:	854a                	mv	a0,s2
    8000479e:	ffffc097          	auipc	ra,0xffffc
    800047a2:	482080e7          	jalr	1154(ra) # 80000c20 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800047a6:	409c                	lw	a5,0(s1)
    800047a8:	ef99                	bnez	a5,800047c6 <holdingsleep+0x3e>
    800047aa:	4481                	li	s1,0
  release(&lk->lk);
    800047ac:	854a                	mv	a0,s2
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	526080e7          	jalr	1318(ra) # 80000cd4 <release>
  return r;
}
    800047b6:	8526                	mv	a0,s1
    800047b8:	70a2                	ld	ra,40(sp)
    800047ba:	7402                	ld	s0,32(sp)
    800047bc:	64e2                	ld	s1,24(sp)
    800047be:	6942                	ld	s2,16(sp)
    800047c0:	69a2                	ld	s3,8(sp)
    800047c2:	6145                	addi	sp,sp,48
    800047c4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800047c6:	0284a983          	lw	s3,40(s1)
    800047ca:	ffffd097          	auipc	ra,0xffffd
    800047ce:	310080e7          	jalr	784(ra) # 80001ada <myproc>
    800047d2:	5904                	lw	s1,48(a0)
    800047d4:	413484b3          	sub	s1,s1,s3
    800047d8:	0014b493          	seqz	s1,s1
    800047dc:	bfc1                	j	800047ac <holdingsleep+0x24>

00000000800047de <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800047de:	1141                	addi	sp,sp,-16
    800047e0:	e406                	sd	ra,8(sp)
    800047e2:	e022                	sd	s0,0(sp)
    800047e4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800047e6:	00004597          	auipc	a1,0x4
    800047ea:	ee258593          	addi	a1,a1,-286 # 800086c8 <syscalls+0x248>
    800047ee:	0001c517          	auipc	a0,0x1c
    800047f2:	4ba50513          	addi	a0,a0,1210 # 80020ca8 <ftable>
    800047f6:	ffffc097          	auipc	ra,0xffffc
    800047fa:	39a080e7          	jalr	922(ra) # 80000b90 <initlock>
}
    800047fe:	60a2                	ld	ra,8(sp)
    80004800:	6402                	ld	s0,0(sp)
    80004802:	0141                	addi	sp,sp,16
    80004804:	8082                	ret

0000000080004806 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004806:	1101                	addi	sp,sp,-32
    80004808:	ec06                	sd	ra,24(sp)
    8000480a:	e822                	sd	s0,16(sp)
    8000480c:	e426                	sd	s1,8(sp)
    8000480e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004810:	0001c517          	auipc	a0,0x1c
    80004814:	49850513          	addi	a0,a0,1176 # 80020ca8 <ftable>
    80004818:	ffffc097          	auipc	ra,0xffffc
    8000481c:	408080e7          	jalr	1032(ra) # 80000c20 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004820:	0001c497          	auipc	s1,0x1c
    80004824:	4a048493          	addi	s1,s1,1184 # 80020cc0 <ftable+0x18>
    80004828:	0001d717          	auipc	a4,0x1d
    8000482c:	43870713          	addi	a4,a4,1080 # 80021c60 <disk>
    if(f->ref == 0){
    80004830:	40dc                	lw	a5,4(s1)
    80004832:	cf99                	beqz	a5,80004850 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004834:	02848493          	addi	s1,s1,40
    80004838:	fee49ce3          	bne	s1,a4,80004830 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000483c:	0001c517          	auipc	a0,0x1c
    80004840:	46c50513          	addi	a0,a0,1132 # 80020ca8 <ftable>
    80004844:	ffffc097          	auipc	ra,0xffffc
    80004848:	490080e7          	jalr	1168(ra) # 80000cd4 <release>
  return 0;
    8000484c:	4481                	li	s1,0
    8000484e:	a819                	j	80004864 <filealloc+0x5e>
      f->ref = 1;
    80004850:	4785                	li	a5,1
    80004852:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004854:	0001c517          	auipc	a0,0x1c
    80004858:	45450513          	addi	a0,a0,1108 # 80020ca8 <ftable>
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	478080e7          	jalr	1144(ra) # 80000cd4 <release>
}
    80004864:	8526                	mv	a0,s1
    80004866:	60e2                	ld	ra,24(sp)
    80004868:	6442                	ld	s0,16(sp)
    8000486a:	64a2                	ld	s1,8(sp)
    8000486c:	6105                	addi	sp,sp,32
    8000486e:	8082                	ret

0000000080004870 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004870:	1101                	addi	sp,sp,-32
    80004872:	ec06                	sd	ra,24(sp)
    80004874:	e822                	sd	s0,16(sp)
    80004876:	e426                	sd	s1,8(sp)
    80004878:	1000                	addi	s0,sp,32
    8000487a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000487c:	0001c517          	auipc	a0,0x1c
    80004880:	42c50513          	addi	a0,a0,1068 # 80020ca8 <ftable>
    80004884:	ffffc097          	auipc	ra,0xffffc
    80004888:	39c080e7          	jalr	924(ra) # 80000c20 <acquire>
  if(f->ref < 1)
    8000488c:	40dc                	lw	a5,4(s1)
    8000488e:	02f05263          	blez	a5,800048b2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004892:	2785                	addiw	a5,a5,1
    80004894:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004896:	0001c517          	auipc	a0,0x1c
    8000489a:	41250513          	addi	a0,a0,1042 # 80020ca8 <ftable>
    8000489e:	ffffc097          	auipc	ra,0xffffc
    800048a2:	436080e7          	jalr	1078(ra) # 80000cd4 <release>
  return f;
}
    800048a6:	8526                	mv	a0,s1
    800048a8:	60e2                	ld	ra,24(sp)
    800048aa:	6442                	ld	s0,16(sp)
    800048ac:	64a2                	ld	s1,8(sp)
    800048ae:	6105                	addi	sp,sp,32
    800048b0:	8082                	ret
    panic("filedup");
    800048b2:	00004517          	auipc	a0,0x4
    800048b6:	e1e50513          	addi	a0,a0,-482 # 800086d0 <syscalls+0x250>
    800048ba:	ffffc097          	auipc	ra,0xffffc
    800048be:	c86080e7          	jalr	-890(ra) # 80000540 <panic>

00000000800048c2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800048c2:	7139                	addi	sp,sp,-64
    800048c4:	fc06                	sd	ra,56(sp)
    800048c6:	f822                	sd	s0,48(sp)
    800048c8:	f426                	sd	s1,40(sp)
    800048ca:	f04a                	sd	s2,32(sp)
    800048cc:	ec4e                	sd	s3,24(sp)
    800048ce:	e852                	sd	s4,16(sp)
    800048d0:	e456                	sd	s5,8(sp)
    800048d2:	0080                	addi	s0,sp,64
    800048d4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800048d6:	0001c517          	auipc	a0,0x1c
    800048da:	3d250513          	addi	a0,a0,978 # 80020ca8 <ftable>
    800048de:	ffffc097          	auipc	ra,0xffffc
    800048e2:	342080e7          	jalr	834(ra) # 80000c20 <acquire>
  if(f->ref < 1)
    800048e6:	40dc                	lw	a5,4(s1)
    800048e8:	06f05163          	blez	a5,8000494a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800048ec:	37fd                	addiw	a5,a5,-1
    800048ee:	0007871b          	sext.w	a4,a5
    800048f2:	c0dc                	sw	a5,4(s1)
    800048f4:	06e04363          	bgtz	a4,8000495a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800048f8:	0004a903          	lw	s2,0(s1)
    800048fc:	0094ca83          	lbu	s5,9(s1)
    80004900:	0104ba03          	ld	s4,16(s1)
    80004904:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004908:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000490c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004910:	0001c517          	auipc	a0,0x1c
    80004914:	39850513          	addi	a0,a0,920 # 80020ca8 <ftable>
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	3bc080e7          	jalr	956(ra) # 80000cd4 <release>

  if(ff.type == FD_PIPE){
    80004920:	4785                	li	a5,1
    80004922:	04f90d63          	beq	s2,a5,8000497c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004926:	3979                	addiw	s2,s2,-2
    80004928:	4785                	li	a5,1
    8000492a:	0527e063          	bltu	a5,s2,8000496a <fileclose+0xa8>
    begin_op();
    8000492e:	00000097          	auipc	ra,0x0
    80004932:	acc080e7          	jalr	-1332(ra) # 800043fa <begin_op>
    iput(ff.ip);
    80004936:	854e                	mv	a0,s3
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	2ae080e7          	jalr	686(ra) # 80003be6 <iput>
    end_op();
    80004940:	00000097          	auipc	ra,0x0
    80004944:	b38080e7          	jalr	-1224(ra) # 80004478 <end_op>
    80004948:	a00d                	j	8000496a <fileclose+0xa8>
    panic("fileclose");
    8000494a:	00004517          	auipc	a0,0x4
    8000494e:	d8e50513          	addi	a0,a0,-626 # 800086d8 <syscalls+0x258>
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	bee080e7          	jalr	-1042(ra) # 80000540 <panic>
    release(&ftable.lock);
    8000495a:	0001c517          	auipc	a0,0x1c
    8000495e:	34e50513          	addi	a0,a0,846 # 80020ca8 <ftable>
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	372080e7          	jalr	882(ra) # 80000cd4 <release>
  }
}
    8000496a:	70e2                	ld	ra,56(sp)
    8000496c:	7442                	ld	s0,48(sp)
    8000496e:	74a2                	ld	s1,40(sp)
    80004970:	7902                	ld	s2,32(sp)
    80004972:	69e2                	ld	s3,24(sp)
    80004974:	6a42                	ld	s4,16(sp)
    80004976:	6aa2                	ld	s5,8(sp)
    80004978:	6121                	addi	sp,sp,64
    8000497a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000497c:	85d6                	mv	a1,s5
    8000497e:	8552                	mv	a0,s4
    80004980:	00000097          	auipc	ra,0x0
    80004984:	34c080e7          	jalr	844(ra) # 80004ccc <pipeclose>
    80004988:	b7cd                	j	8000496a <fileclose+0xa8>

000000008000498a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000498a:	715d                	addi	sp,sp,-80
    8000498c:	e486                	sd	ra,72(sp)
    8000498e:	e0a2                	sd	s0,64(sp)
    80004990:	fc26                	sd	s1,56(sp)
    80004992:	f84a                	sd	s2,48(sp)
    80004994:	f44e                	sd	s3,40(sp)
    80004996:	0880                	addi	s0,sp,80
    80004998:	84aa                	mv	s1,a0
    8000499a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000499c:	ffffd097          	auipc	ra,0xffffd
    800049a0:	13e080e7          	jalr	318(ra) # 80001ada <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800049a4:	409c                	lw	a5,0(s1)
    800049a6:	37f9                	addiw	a5,a5,-2
    800049a8:	4705                	li	a4,1
    800049aa:	04f76763          	bltu	a4,a5,800049f8 <filestat+0x6e>
    800049ae:	892a                	mv	s2,a0
    ilock(f->ip);
    800049b0:	6c88                	ld	a0,24(s1)
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	fd0080e7          	jalr	-48(ra) # 80003982 <ilock>
    stati(f->ip, &st);
    800049ba:	fb840593          	addi	a1,s0,-72
    800049be:	6c88                	ld	a0,24(s1)
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	2f6080e7          	jalr	758(ra) # 80003cb6 <stati>
    iunlock(f->ip);
    800049c8:	6c88                	ld	a0,24(s1)
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	07a080e7          	jalr	122(ra) # 80003a44 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800049d2:	46e1                	li	a3,24
    800049d4:	fb840613          	addi	a2,s0,-72
    800049d8:	85ce                	mv	a1,s3
    800049da:	05093503          	ld	a0,80(s2)
    800049de:	ffffd097          	auipc	ra,0xffffd
    800049e2:	cd8080e7          	jalr	-808(ra) # 800016b6 <copyout>
    800049e6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800049ea:	60a6                	ld	ra,72(sp)
    800049ec:	6406                	ld	s0,64(sp)
    800049ee:	74e2                	ld	s1,56(sp)
    800049f0:	7942                	ld	s2,48(sp)
    800049f2:	79a2                	ld	s3,40(sp)
    800049f4:	6161                	addi	sp,sp,80
    800049f6:	8082                	ret
  return -1;
    800049f8:	557d                	li	a0,-1
    800049fa:	bfc5                	j	800049ea <filestat+0x60>

00000000800049fc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800049fc:	7179                	addi	sp,sp,-48
    800049fe:	f406                	sd	ra,40(sp)
    80004a00:	f022                	sd	s0,32(sp)
    80004a02:	ec26                	sd	s1,24(sp)
    80004a04:	e84a                	sd	s2,16(sp)
    80004a06:	e44e                	sd	s3,8(sp)
    80004a08:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a0a:	00854783          	lbu	a5,8(a0)
    80004a0e:	c3d5                	beqz	a5,80004ab2 <fileread+0xb6>
    80004a10:	84aa                	mv	s1,a0
    80004a12:	89ae                	mv	s3,a1
    80004a14:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a16:	411c                	lw	a5,0(a0)
    80004a18:	4705                	li	a4,1
    80004a1a:	04e78963          	beq	a5,a4,80004a6c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a1e:	470d                	li	a4,3
    80004a20:	04e78d63          	beq	a5,a4,80004a7a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a24:	4709                	li	a4,2
    80004a26:	06e79e63          	bne	a5,a4,80004aa2 <fileread+0xa6>
    ilock(f->ip);
    80004a2a:	6d08                	ld	a0,24(a0)
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	f56080e7          	jalr	-170(ra) # 80003982 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004a34:	874a                	mv	a4,s2
    80004a36:	5094                	lw	a3,32(s1)
    80004a38:	864e                	mv	a2,s3
    80004a3a:	4585                	li	a1,1
    80004a3c:	6c88                	ld	a0,24(s1)
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	2a2080e7          	jalr	674(ra) # 80003ce0 <readi>
    80004a46:	892a                	mv	s2,a0
    80004a48:	00a05563          	blez	a0,80004a52 <fileread+0x56>
      f->off += r;
    80004a4c:	509c                	lw	a5,32(s1)
    80004a4e:	9fa9                	addw	a5,a5,a0
    80004a50:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004a52:	6c88                	ld	a0,24(s1)
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	ff0080e7          	jalr	-16(ra) # 80003a44 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004a5c:	854a                	mv	a0,s2
    80004a5e:	70a2                	ld	ra,40(sp)
    80004a60:	7402                	ld	s0,32(sp)
    80004a62:	64e2                	ld	s1,24(sp)
    80004a64:	6942                	ld	s2,16(sp)
    80004a66:	69a2                	ld	s3,8(sp)
    80004a68:	6145                	addi	sp,sp,48
    80004a6a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a6c:	6908                	ld	a0,16(a0)
    80004a6e:	00000097          	auipc	ra,0x0
    80004a72:	3c6080e7          	jalr	966(ra) # 80004e34 <piperead>
    80004a76:	892a                	mv	s2,a0
    80004a78:	b7d5                	j	80004a5c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a7a:	02451783          	lh	a5,36(a0)
    80004a7e:	03079693          	slli	a3,a5,0x30
    80004a82:	92c1                	srli	a3,a3,0x30
    80004a84:	4725                	li	a4,9
    80004a86:	02d76863          	bltu	a4,a3,80004ab6 <fileread+0xba>
    80004a8a:	0792                	slli	a5,a5,0x4
    80004a8c:	0001c717          	auipc	a4,0x1c
    80004a90:	17c70713          	addi	a4,a4,380 # 80020c08 <devsw>
    80004a94:	97ba                	add	a5,a5,a4
    80004a96:	639c                	ld	a5,0(a5)
    80004a98:	c38d                	beqz	a5,80004aba <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004a9a:	4505                	li	a0,1
    80004a9c:	9782                	jalr	a5
    80004a9e:	892a                	mv	s2,a0
    80004aa0:	bf75                	j	80004a5c <fileread+0x60>
    panic("fileread");
    80004aa2:	00004517          	auipc	a0,0x4
    80004aa6:	c4650513          	addi	a0,a0,-954 # 800086e8 <syscalls+0x268>
    80004aaa:	ffffc097          	auipc	ra,0xffffc
    80004aae:	a96080e7          	jalr	-1386(ra) # 80000540 <panic>
    return -1;
    80004ab2:	597d                	li	s2,-1
    80004ab4:	b765                	j	80004a5c <fileread+0x60>
      return -1;
    80004ab6:	597d                	li	s2,-1
    80004ab8:	b755                	j	80004a5c <fileread+0x60>
    80004aba:	597d                	li	s2,-1
    80004abc:	b745                	j	80004a5c <fileread+0x60>

0000000080004abe <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004abe:	715d                	addi	sp,sp,-80
    80004ac0:	e486                	sd	ra,72(sp)
    80004ac2:	e0a2                	sd	s0,64(sp)
    80004ac4:	fc26                	sd	s1,56(sp)
    80004ac6:	f84a                	sd	s2,48(sp)
    80004ac8:	f44e                	sd	s3,40(sp)
    80004aca:	f052                	sd	s4,32(sp)
    80004acc:	ec56                	sd	s5,24(sp)
    80004ace:	e85a                	sd	s6,16(sp)
    80004ad0:	e45e                	sd	s7,8(sp)
    80004ad2:	e062                	sd	s8,0(sp)
    80004ad4:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004ad6:	00954783          	lbu	a5,9(a0)
    80004ada:	10078663          	beqz	a5,80004be6 <filewrite+0x128>
    80004ade:	892a                	mv	s2,a0
    80004ae0:	8b2e                	mv	s6,a1
    80004ae2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ae4:	411c                	lw	a5,0(a0)
    80004ae6:	4705                	li	a4,1
    80004ae8:	02e78263          	beq	a5,a4,80004b0c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004aec:	470d                	li	a4,3
    80004aee:	02e78663          	beq	a5,a4,80004b1a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004af2:	4709                	li	a4,2
    80004af4:	0ee79163          	bne	a5,a4,80004bd6 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004af8:	0ac05d63          	blez	a2,80004bb2 <filewrite+0xf4>
    int i = 0;
    80004afc:	4981                	li	s3,0
    80004afe:	6b85                	lui	s7,0x1
    80004b00:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004b04:	6c05                	lui	s8,0x1
    80004b06:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004b0a:	a861                	j	80004ba2 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004b0c:	6908                	ld	a0,16(a0)
    80004b0e:	00000097          	auipc	ra,0x0
    80004b12:	22e080e7          	jalr	558(ra) # 80004d3c <pipewrite>
    80004b16:	8a2a                	mv	s4,a0
    80004b18:	a045                	j	80004bb8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004b1a:	02451783          	lh	a5,36(a0)
    80004b1e:	03079693          	slli	a3,a5,0x30
    80004b22:	92c1                	srli	a3,a3,0x30
    80004b24:	4725                	li	a4,9
    80004b26:	0cd76263          	bltu	a4,a3,80004bea <filewrite+0x12c>
    80004b2a:	0792                	slli	a5,a5,0x4
    80004b2c:	0001c717          	auipc	a4,0x1c
    80004b30:	0dc70713          	addi	a4,a4,220 # 80020c08 <devsw>
    80004b34:	97ba                	add	a5,a5,a4
    80004b36:	679c                	ld	a5,8(a5)
    80004b38:	cbdd                	beqz	a5,80004bee <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004b3a:	4505                	li	a0,1
    80004b3c:	9782                	jalr	a5
    80004b3e:	8a2a                	mv	s4,a0
    80004b40:	a8a5                	j	80004bb8 <filewrite+0xfa>
    80004b42:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004b46:	00000097          	auipc	ra,0x0
    80004b4a:	8b4080e7          	jalr	-1868(ra) # 800043fa <begin_op>
      ilock(f->ip);
    80004b4e:	01893503          	ld	a0,24(s2)
    80004b52:	fffff097          	auipc	ra,0xfffff
    80004b56:	e30080e7          	jalr	-464(ra) # 80003982 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b5a:	8756                	mv	a4,s5
    80004b5c:	02092683          	lw	a3,32(s2)
    80004b60:	01698633          	add	a2,s3,s6
    80004b64:	4585                	li	a1,1
    80004b66:	01893503          	ld	a0,24(s2)
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	26e080e7          	jalr	622(ra) # 80003dd8 <writei>
    80004b72:	84aa                	mv	s1,a0
    80004b74:	00a05763          	blez	a0,80004b82 <filewrite+0xc4>
        f->off += r;
    80004b78:	02092783          	lw	a5,32(s2)
    80004b7c:	9fa9                	addw	a5,a5,a0
    80004b7e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004b82:	01893503          	ld	a0,24(s2)
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	ebe080e7          	jalr	-322(ra) # 80003a44 <iunlock>
      end_op();
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	8ea080e7          	jalr	-1814(ra) # 80004478 <end_op>

      if(r != n1){
    80004b96:	009a9f63          	bne	s5,s1,80004bb4 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004b9a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004b9e:	0149db63          	bge	s3,s4,80004bb4 <filewrite+0xf6>
      int n1 = n - i;
    80004ba2:	413a04bb          	subw	s1,s4,s3
    80004ba6:	0004879b          	sext.w	a5,s1
    80004baa:	f8fbdce3          	bge	s7,a5,80004b42 <filewrite+0x84>
    80004bae:	84e2                	mv	s1,s8
    80004bb0:	bf49                	j	80004b42 <filewrite+0x84>
    int i = 0;
    80004bb2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004bb4:	013a1f63          	bne	s4,s3,80004bd2 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004bb8:	8552                	mv	a0,s4
    80004bba:	60a6                	ld	ra,72(sp)
    80004bbc:	6406                	ld	s0,64(sp)
    80004bbe:	74e2                	ld	s1,56(sp)
    80004bc0:	7942                	ld	s2,48(sp)
    80004bc2:	79a2                	ld	s3,40(sp)
    80004bc4:	7a02                	ld	s4,32(sp)
    80004bc6:	6ae2                	ld	s5,24(sp)
    80004bc8:	6b42                	ld	s6,16(sp)
    80004bca:	6ba2                	ld	s7,8(sp)
    80004bcc:	6c02                	ld	s8,0(sp)
    80004bce:	6161                	addi	sp,sp,80
    80004bd0:	8082                	ret
    ret = (i == n ? n : -1);
    80004bd2:	5a7d                	li	s4,-1
    80004bd4:	b7d5                	j	80004bb8 <filewrite+0xfa>
    panic("filewrite");
    80004bd6:	00004517          	auipc	a0,0x4
    80004bda:	b2250513          	addi	a0,a0,-1246 # 800086f8 <syscalls+0x278>
    80004bde:	ffffc097          	auipc	ra,0xffffc
    80004be2:	962080e7          	jalr	-1694(ra) # 80000540 <panic>
    return -1;
    80004be6:	5a7d                	li	s4,-1
    80004be8:	bfc1                	j	80004bb8 <filewrite+0xfa>
      return -1;
    80004bea:	5a7d                	li	s4,-1
    80004bec:	b7f1                	j	80004bb8 <filewrite+0xfa>
    80004bee:	5a7d                	li	s4,-1
    80004bf0:	b7e1                	j	80004bb8 <filewrite+0xfa>

0000000080004bf2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004bf2:	7179                	addi	sp,sp,-48
    80004bf4:	f406                	sd	ra,40(sp)
    80004bf6:	f022                	sd	s0,32(sp)
    80004bf8:	ec26                	sd	s1,24(sp)
    80004bfa:	e84a                	sd	s2,16(sp)
    80004bfc:	e44e                	sd	s3,8(sp)
    80004bfe:	e052                	sd	s4,0(sp)
    80004c00:	1800                	addi	s0,sp,48
    80004c02:	84aa                	mv	s1,a0
    80004c04:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c06:	0005b023          	sd	zero,0(a1)
    80004c0a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004c0e:	00000097          	auipc	ra,0x0
    80004c12:	bf8080e7          	jalr	-1032(ra) # 80004806 <filealloc>
    80004c16:	e088                	sd	a0,0(s1)
    80004c18:	c551                	beqz	a0,80004ca4 <pipealloc+0xb2>
    80004c1a:	00000097          	auipc	ra,0x0
    80004c1e:	bec080e7          	jalr	-1044(ra) # 80004806 <filealloc>
    80004c22:	00aa3023          	sd	a0,0(s4)
    80004c26:	c92d                	beqz	a0,80004c98 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004c28:	ffffc097          	auipc	ra,0xffffc
    80004c2c:	ebe080e7          	jalr	-322(ra) # 80000ae6 <kalloc>
    80004c30:	892a                	mv	s2,a0
    80004c32:	c125                	beqz	a0,80004c92 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004c34:	4985                	li	s3,1
    80004c36:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004c3a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004c3e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004c42:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004c46:	00004597          	auipc	a1,0x4
    80004c4a:	ac258593          	addi	a1,a1,-1342 # 80008708 <syscalls+0x288>
    80004c4e:	ffffc097          	auipc	ra,0xffffc
    80004c52:	f42080e7          	jalr	-190(ra) # 80000b90 <initlock>
  (*f0)->type = FD_PIPE;
    80004c56:	609c                	ld	a5,0(s1)
    80004c58:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004c5c:	609c                	ld	a5,0(s1)
    80004c5e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004c62:	609c                	ld	a5,0(s1)
    80004c64:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004c68:	609c                	ld	a5,0(s1)
    80004c6a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004c6e:	000a3783          	ld	a5,0(s4)
    80004c72:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004c76:	000a3783          	ld	a5,0(s4)
    80004c7a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004c7e:	000a3783          	ld	a5,0(s4)
    80004c82:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c86:	000a3783          	ld	a5,0(s4)
    80004c8a:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c8e:	4501                	li	a0,0
    80004c90:	a025                	j	80004cb8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c92:	6088                	ld	a0,0(s1)
    80004c94:	e501                	bnez	a0,80004c9c <pipealloc+0xaa>
    80004c96:	a039                	j	80004ca4 <pipealloc+0xb2>
    80004c98:	6088                	ld	a0,0(s1)
    80004c9a:	c51d                	beqz	a0,80004cc8 <pipealloc+0xd6>
    fileclose(*f0);
    80004c9c:	00000097          	auipc	ra,0x0
    80004ca0:	c26080e7          	jalr	-986(ra) # 800048c2 <fileclose>
  if(*f1)
    80004ca4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ca8:	557d                	li	a0,-1
  if(*f1)
    80004caa:	c799                	beqz	a5,80004cb8 <pipealloc+0xc6>
    fileclose(*f1);
    80004cac:	853e                	mv	a0,a5
    80004cae:	00000097          	auipc	ra,0x0
    80004cb2:	c14080e7          	jalr	-1004(ra) # 800048c2 <fileclose>
  return -1;
    80004cb6:	557d                	li	a0,-1
}
    80004cb8:	70a2                	ld	ra,40(sp)
    80004cba:	7402                	ld	s0,32(sp)
    80004cbc:	64e2                	ld	s1,24(sp)
    80004cbe:	6942                	ld	s2,16(sp)
    80004cc0:	69a2                	ld	s3,8(sp)
    80004cc2:	6a02                	ld	s4,0(sp)
    80004cc4:	6145                	addi	sp,sp,48
    80004cc6:	8082                	ret
  return -1;
    80004cc8:	557d                	li	a0,-1
    80004cca:	b7fd                	j	80004cb8 <pipealloc+0xc6>

0000000080004ccc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ccc:	1101                	addi	sp,sp,-32
    80004cce:	ec06                	sd	ra,24(sp)
    80004cd0:	e822                	sd	s0,16(sp)
    80004cd2:	e426                	sd	s1,8(sp)
    80004cd4:	e04a                	sd	s2,0(sp)
    80004cd6:	1000                	addi	s0,sp,32
    80004cd8:	84aa                	mv	s1,a0
    80004cda:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004cdc:	ffffc097          	auipc	ra,0xffffc
    80004ce0:	f44080e7          	jalr	-188(ra) # 80000c20 <acquire>
  if(writable){
    80004ce4:	02090d63          	beqz	s2,80004d1e <pipeclose+0x52>
    pi->writeopen = 0;
    80004ce8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004cec:	21848513          	addi	a0,s1,536
    80004cf0:	ffffd097          	auipc	ra,0xffffd
    80004cf4:	4f6080e7          	jalr	1270(ra) # 800021e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004cf8:	2204b783          	ld	a5,544(s1)
    80004cfc:	eb95                	bnez	a5,80004d30 <pipeclose+0x64>
    release(&pi->lock);
    80004cfe:	8526                	mv	a0,s1
    80004d00:	ffffc097          	auipc	ra,0xffffc
    80004d04:	fd4080e7          	jalr	-44(ra) # 80000cd4 <release>
    kfree((char*)pi);
    80004d08:	8526                	mv	a0,s1
    80004d0a:	ffffc097          	auipc	ra,0xffffc
    80004d0e:	cde080e7          	jalr	-802(ra) # 800009e8 <kfree>
  } else
    release(&pi->lock);
}
    80004d12:	60e2                	ld	ra,24(sp)
    80004d14:	6442                	ld	s0,16(sp)
    80004d16:	64a2                	ld	s1,8(sp)
    80004d18:	6902                	ld	s2,0(sp)
    80004d1a:	6105                	addi	sp,sp,32
    80004d1c:	8082                	ret
    pi->readopen = 0;
    80004d1e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004d22:	21c48513          	addi	a0,s1,540
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	4c0080e7          	jalr	1216(ra) # 800021e6 <wakeup>
    80004d2e:	b7e9                	j	80004cf8 <pipeclose+0x2c>
    release(&pi->lock);
    80004d30:	8526                	mv	a0,s1
    80004d32:	ffffc097          	auipc	ra,0xffffc
    80004d36:	fa2080e7          	jalr	-94(ra) # 80000cd4 <release>
}
    80004d3a:	bfe1                	j	80004d12 <pipeclose+0x46>

0000000080004d3c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004d3c:	711d                	addi	sp,sp,-96
    80004d3e:	ec86                	sd	ra,88(sp)
    80004d40:	e8a2                	sd	s0,80(sp)
    80004d42:	e4a6                	sd	s1,72(sp)
    80004d44:	e0ca                	sd	s2,64(sp)
    80004d46:	fc4e                	sd	s3,56(sp)
    80004d48:	f852                	sd	s4,48(sp)
    80004d4a:	f456                	sd	s5,40(sp)
    80004d4c:	f05a                	sd	s6,32(sp)
    80004d4e:	ec5e                	sd	s7,24(sp)
    80004d50:	e862                	sd	s8,16(sp)
    80004d52:	1080                	addi	s0,sp,96
    80004d54:	84aa                	mv	s1,a0
    80004d56:	8aae                	mv	s5,a1
    80004d58:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004d5a:	ffffd097          	auipc	ra,0xffffd
    80004d5e:	d80080e7          	jalr	-640(ra) # 80001ada <myproc>
    80004d62:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004d64:	8526                	mv	a0,s1
    80004d66:	ffffc097          	auipc	ra,0xffffc
    80004d6a:	eba080e7          	jalr	-326(ra) # 80000c20 <acquire>
  while(i < n){
    80004d6e:	0b405663          	blez	s4,80004e1a <pipewrite+0xde>
  int i = 0;
    80004d72:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d74:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004d76:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004d7a:	21c48b93          	addi	s7,s1,540
    80004d7e:	a089                	j	80004dc0 <pipewrite+0x84>
      release(&pi->lock);
    80004d80:	8526                	mv	a0,s1
    80004d82:	ffffc097          	auipc	ra,0xffffc
    80004d86:	f52080e7          	jalr	-174(ra) # 80000cd4 <release>
      return -1;
    80004d8a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004d8c:	854a                	mv	a0,s2
    80004d8e:	60e6                	ld	ra,88(sp)
    80004d90:	6446                	ld	s0,80(sp)
    80004d92:	64a6                	ld	s1,72(sp)
    80004d94:	6906                	ld	s2,64(sp)
    80004d96:	79e2                	ld	s3,56(sp)
    80004d98:	7a42                	ld	s4,48(sp)
    80004d9a:	7aa2                	ld	s5,40(sp)
    80004d9c:	7b02                	ld	s6,32(sp)
    80004d9e:	6be2                	ld	s7,24(sp)
    80004da0:	6c42                	ld	s8,16(sp)
    80004da2:	6125                	addi	sp,sp,96
    80004da4:	8082                	ret
      wakeup(&pi->nread);
    80004da6:	8562                	mv	a0,s8
    80004da8:	ffffd097          	auipc	ra,0xffffd
    80004dac:	43e080e7          	jalr	1086(ra) # 800021e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004db0:	85a6                	mv	a1,s1
    80004db2:	855e                	mv	a0,s7
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	3ce080e7          	jalr	974(ra) # 80002182 <sleep>
  while(i < n){
    80004dbc:	07495063          	bge	s2,s4,80004e1c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004dc0:	2204a783          	lw	a5,544(s1)
    80004dc4:	dfd5                	beqz	a5,80004d80 <pipewrite+0x44>
    80004dc6:	854e                	mv	a0,s3
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	662080e7          	jalr	1634(ra) # 8000242a <killed>
    80004dd0:	f945                	bnez	a0,80004d80 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004dd2:	2184a783          	lw	a5,536(s1)
    80004dd6:	21c4a703          	lw	a4,540(s1)
    80004dda:	2007879b          	addiw	a5,a5,512
    80004dde:	fcf704e3          	beq	a4,a5,80004da6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004de2:	4685                	li	a3,1
    80004de4:	01590633          	add	a2,s2,s5
    80004de8:	faf40593          	addi	a1,s0,-81
    80004dec:	0509b503          	ld	a0,80(s3)
    80004df0:	ffffd097          	auipc	ra,0xffffd
    80004df4:	952080e7          	jalr	-1710(ra) # 80001742 <copyin>
    80004df8:	03650263          	beq	a0,s6,80004e1c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004dfc:	21c4a783          	lw	a5,540(s1)
    80004e00:	0017871b          	addiw	a4,a5,1
    80004e04:	20e4ae23          	sw	a4,540(s1)
    80004e08:	1ff7f793          	andi	a5,a5,511
    80004e0c:	97a6                	add	a5,a5,s1
    80004e0e:	faf44703          	lbu	a4,-81(s0)
    80004e12:	00e78c23          	sb	a4,24(a5)
      i++;
    80004e16:	2905                	addiw	s2,s2,1
    80004e18:	b755                	j	80004dbc <pipewrite+0x80>
  int i = 0;
    80004e1a:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004e1c:	21848513          	addi	a0,s1,536
    80004e20:	ffffd097          	auipc	ra,0xffffd
    80004e24:	3c6080e7          	jalr	966(ra) # 800021e6 <wakeup>
  release(&pi->lock);
    80004e28:	8526                	mv	a0,s1
    80004e2a:	ffffc097          	auipc	ra,0xffffc
    80004e2e:	eaa080e7          	jalr	-342(ra) # 80000cd4 <release>
  return i;
    80004e32:	bfa9                	j	80004d8c <pipewrite+0x50>

0000000080004e34 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004e34:	715d                	addi	sp,sp,-80
    80004e36:	e486                	sd	ra,72(sp)
    80004e38:	e0a2                	sd	s0,64(sp)
    80004e3a:	fc26                	sd	s1,56(sp)
    80004e3c:	f84a                	sd	s2,48(sp)
    80004e3e:	f44e                	sd	s3,40(sp)
    80004e40:	f052                	sd	s4,32(sp)
    80004e42:	ec56                	sd	s5,24(sp)
    80004e44:	e85a                	sd	s6,16(sp)
    80004e46:	0880                	addi	s0,sp,80
    80004e48:	84aa                	mv	s1,a0
    80004e4a:	892e                	mv	s2,a1
    80004e4c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004e4e:	ffffd097          	auipc	ra,0xffffd
    80004e52:	c8c080e7          	jalr	-884(ra) # 80001ada <myproc>
    80004e56:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	ffffc097          	auipc	ra,0xffffc
    80004e5e:	dc6080e7          	jalr	-570(ra) # 80000c20 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e62:	2184a703          	lw	a4,536(s1)
    80004e66:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e6a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e6e:	02f71763          	bne	a4,a5,80004e9c <piperead+0x68>
    80004e72:	2244a783          	lw	a5,548(s1)
    80004e76:	c39d                	beqz	a5,80004e9c <piperead+0x68>
    if(killed(pr)){
    80004e78:	8552                	mv	a0,s4
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	5b0080e7          	jalr	1456(ra) # 8000242a <killed>
    80004e82:	e949                	bnez	a0,80004f14 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e84:	85a6                	mv	a1,s1
    80004e86:	854e                	mv	a0,s3
    80004e88:	ffffd097          	auipc	ra,0xffffd
    80004e8c:	2fa080e7          	jalr	762(ra) # 80002182 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e90:	2184a703          	lw	a4,536(s1)
    80004e94:	21c4a783          	lw	a5,540(s1)
    80004e98:	fcf70de3          	beq	a4,a5,80004e72 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e9c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e9e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ea0:	05505463          	blez	s5,80004ee8 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004ea4:	2184a783          	lw	a5,536(s1)
    80004ea8:	21c4a703          	lw	a4,540(s1)
    80004eac:	02f70e63          	beq	a4,a5,80004ee8 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004eb0:	0017871b          	addiw	a4,a5,1
    80004eb4:	20e4ac23          	sw	a4,536(s1)
    80004eb8:	1ff7f793          	andi	a5,a5,511
    80004ebc:	97a6                	add	a5,a5,s1
    80004ebe:	0187c783          	lbu	a5,24(a5)
    80004ec2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ec6:	4685                	li	a3,1
    80004ec8:	fbf40613          	addi	a2,s0,-65
    80004ecc:	85ca                	mv	a1,s2
    80004ece:	050a3503          	ld	a0,80(s4)
    80004ed2:	ffffc097          	auipc	ra,0xffffc
    80004ed6:	7e4080e7          	jalr	2020(ra) # 800016b6 <copyout>
    80004eda:	01650763          	beq	a0,s6,80004ee8 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ede:	2985                	addiw	s3,s3,1
    80004ee0:	0905                	addi	s2,s2,1
    80004ee2:	fd3a91e3          	bne	s5,s3,80004ea4 <piperead+0x70>
    80004ee6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ee8:	21c48513          	addi	a0,s1,540
    80004eec:	ffffd097          	auipc	ra,0xffffd
    80004ef0:	2fa080e7          	jalr	762(ra) # 800021e6 <wakeup>
  release(&pi->lock);
    80004ef4:	8526                	mv	a0,s1
    80004ef6:	ffffc097          	auipc	ra,0xffffc
    80004efa:	dde080e7          	jalr	-546(ra) # 80000cd4 <release>
  return i;
}
    80004efe:	854e                	mv	a0,s3
    80004f00:	60a6                	ld	ra,72(sp)
    80004f02:	6406                	ld	s0,64(sp)
    80004f04:	74e2                	ld	s1,56(sp)
    80004f06:	7942                	ld	s2,48(sp)
    80004f08:	79a2                	ld	s3,40(sp)
    80004f0a:	7a02                	ld	s4,32(sp)
    80004f0c:	6ae2                	ld	s5,24(sp)
    80004f0e:	6b42                	ld	s6,16(sp)
    80004f10:	6161                	addi	sp,sp,80
    80004f12:	8082                	ret
      release(&pi->lock);
    80004f14:	8526                	mv	a0,s1
    80004f16:	ffffc097          	auipc	ra,0xffffc
    80004f1a:	dbe080e7          	jalr	-578(ra) # 80000cd4 <release>
      return -1;
    80004f1e:	59fd                	li	s3,-1
    80004f20:	bff9                	j	80004efe <piperead+0xca>

0000000080004f22 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004f22:	1141                	addi	sp,sp,-16
    80004f24:	e422                	sd	s0,8(sp)
    80004f26:	0800                	addi	s0,sp,16
    80004f28:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004f2a:	8905                	andi	a0,a0,1
    80004f2c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004f2e:	8b89                	andi	a5,a5,2
    80004f30:	c399                	beqz	a5,80004f36 <flags2perm+0x14>
      perm |= PTE_W;
    80004f32:	00456513          	ori	a0,a0,4
    return perm;
}
    80004f36:	6422                	ld	s0,8(sp)
    80004f38:	0141                	addi	sp,sp,16
    80004f3a:	8082                	ret

0000000080004f3c <exec>:

int
exec(char *path, char **argv)
{
    80004f3c:	de010113          	addi	sp,sp,-544
    80004f40:	20113c23          	sd	ra,536(sp)
    80004f44:	20813823          	sd	s0,528(sp)
    80004f48:	20913423          	sd	s1,520(sp)
    80004f4c:	21213023          	sd	s2,512(sp)
    80004f50:	ffce                	sd	s3,504(sp)
    80004f52:	fbd2                	sd	s4,496(sp)
    80004f54:	f7d6                	sd	s5,488(sp)
    80004f56:	f3da                	sd	s6,480(sp)
    80004f58:	efde                	sd	s7,472(sp)
    80004f5a:	ebe2                	sd	s8,464(sp)
    80004f5c:	e7e6                	sd	s9,456(sp)
    80004f5e:	e3ea                	sd	s10,448(sp)
    80004f60:	ff6e                	sd	s11,440(sp)
    80004f62:	1400                	addi	s0,sp,544
    80004f64:	892a                	mv	s2,a0
    80004f66:	dea43423          	sd	a0,-536(s0)
    80004f6a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004f6e:	ffffd097          	auipc	ra,0xffffd
    80004f72:	b6c080e7          	jalr	-1172(ra) # 80001ada <myproc>
    80004f76:	84aa                	mv	s1,a0

  begin_op();
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	482080e7          	jalr	1154(ra) # 800043fa <begin_op>

  if((ip = namei(path)) == 0){
    80004f80:	854a                	mv	a0,s2
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	258080e7          	jalr	600(ra) # 800041da <namei>
    80004f8a:	c93d                	beqz	a0,80005000 <exec+0xc4>
    80004f8c:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	9f4080e7          	jalr	-1548(ra) # 80003982 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004f96:	04000713          	li	a4,64
    80004f9a:	4681                	li	a3,0
    80004f9c:	e5040613          	addi	a2,s0,-432
    80004fa0:	4581                	li	a1,0
    80004fa2:	8556                	mv	a0,s5
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	d3c080e7          	jalr	-708(ra) # 80003ce0 <readi>
    80004fac:	04000793          	li	a5,64
    80004fb0:	00f51a63          	bne	a0,a5,80004fc4 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004fb4:	e5042703          	lw	a4,-432(s0)
    80004fb8:	464c47b7          	lui	a5,0x464c4
    80004fbc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004fc0:	04f70663          	beq	a4,a5,8000500c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004fc4:	8556                	mv	a0,s5
    80004fc6:	fffff097          	auipc	ra,0xfffff
    80004fca:	cc8080e7          	jalr	-824(ra) # 80003c8e <iunlockput>
    end_op();
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	4aa080e7          	jalr	1194(ra) # 80004478 <end_op>
  }
  return -1;
    80004fd6:	557d                	li	a0,-1
}
    80004fd8:	21813083          	ld	ra,536(sp)
    80004fdc:	21013403          	ld	s0,528(sp)
    80004fe0:	20813483          	ld	s1,520(sp)
    80004fe4:	20013903          	ld	s2,512(sp)
    80004fe8:	79fe                	ld	s3,504(sp)
    80004fea:	7a5e                	ld	s4,496(sp)
    80004fec:	7abe                	ld	s5,488(sp)
    80004fee:	7b1e                	ld	s6,480(sp)
    80004ff0:	6bfe                	ld	s7,472(sp)
    80004ff2:	6c5e                	ld	s8,464(sp)
    80004ff4:	6cbe                	ld	s9,456(sp)
    80004ff6:	6d1e                	ld	s10,448(sp)
    80004ff8:	7dfa                	ld	s11,440(sp)
    80004ffa:	22010113          	addi	sp,sp,544
    80004ffe:	8082                	ret
    end_op();
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	478080e7          	jalr	1144(ra) # 80004478 <end_op>
    return -1;
    80005008:	557d                	li	a0,-1
    8000500a:	b7f9                	j	80004fd8 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000500c:	8526                	mv	a0,s1
    8000500e:	ffffd097          	auipc	ra,0xffffd
    80005012:	b90080e7          	jalr	-1136(ra) # 80001b9e <proc_pagetable>
    80005016:	8b2a                	mv	s6,a0
    80005018:	d555                	beqz	a0,80004fc4 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000501a:	e7042783          	lw	a5,-400(s0)
    8000501e:	e8845703          	lhu	a4,-376(s0)
    80005022:	c735                	beqz	a4,8000508e <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005024:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005026:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000502a:	6a05                	lui	s4,0x1
    8000502c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005030:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80005034:	6d85                	lui	s11,0x1
    80005036:	7d7d                	lui	s10,0xfffff
    80005038:	ac99                	j	8000528e <exec+0x352>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000503a:	00003517          	auipc	a0,0x3
    8000503e:	6d650513          	addi	a0,a0,1750 # 80008710 <syscalls+0x290>
    80005042:	ffffb097          	auipc	ra,0xffffb
    80005046:	4fe080e7          	jalr	1278(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000504a:	874a                	mv	a4,s2
    8000504c:	009c86bb          	addw	a3,s9,s1
    80005050:	4581                	li	a1,0
    80005052:	8556                	mv	a0,s5
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	c8c080e7          	jalr	-884(ra) # 80003ce0 <readi>
    8000505c:	2501                	sext.w	a0,a0
    8000505e:	1ca91563          	bne	s2,a0,80005228 <exec+0x2ec>
  for(i = 0; i < sz; i += PGSIZE){
    80005062:	009d84bb          	addw	s1,s11,s1
    80005066:	013d09bb          	addw	s3,s10,s3
    8000506a:	2174f263          	bgeu	s1,s7,8000526e <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    8000506e:	02049593          	slli	a1,s1,0x20
    80005072:	9181                	srli	a1,a1,0x20
    80005074:	95e2                	add	a1,a1,s8
    80005076:	855a                	mv	a0,s6
    80005078:	ffffc097          	auipc	ra,0xffffc
    8000507c:	02e080e7          	jalr	46(ra) # 800010a6 <walkaddr>
    80005080:	862a                	mv	a2,a0
    if(pa == 0)
    80005082:	dd45                	beqz	a0,8000503a <exec+0xfe>
      n = PGSIZE;
    80005084:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80005086:	fd49f2e3          	bgeu	s3,s4,8000504a <exec+0x10e>
      n = sz - i;
    8000508a:	894e                	mv	s2,s3
    8000508c:	bf7d                	j	8000504a <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000508e:	4901                	li	s2,0
  iunlockput(ip);
    80005090:	8556                	mv	a0,s5
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	bfc080e7          	jalr	-1028(ra) # 80003c8e <iunlockput>
  end_op();
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	3de080e7          	jalr	990(ra) # 80004478 <end_op>
  p = myproc();
    800050a2:	ffffd097          	auipc	ra,0xffffd
    800050a6:	a38080e7          	jalr	-1480(ra) # 80001ada <myproc>
    800050aa:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800050ac:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800050b0:	6785                	lui	a5,0x1
    800050b2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800050b4:	97ca                	add	a5,a5,s2
    800050b6:	777d                	lui	a4,0xfffff
    800050b8:	8ff9                	and	a5,a5,a4
    800050ba:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800050be:	4691                	li	a3,4
    800050c0:	6609                	lui	a2,0x2
    800050c2:	963e                	add	a2,a2,a5
    800050c4:	85be                	mv	a1,a5
    800050c6:	855a                	mv	a0,s6
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	392080e7          	jalr	914(ra) # 8000145a <uvmalloc>
    800050d0:	8c2a                	mv	s8,a0
  ip = 0;
    800050d2:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800050d4:	14050a63          	beqz	a0,80005228 <exec+0x2ec>
  uvmclear(pagetable, sz-2*PGSIZE);
    800050d8:	75f9                	lui	a1,0xffffe
    800050da:	95aa                	add	a1,a1,a0
    800050dc:	855a                	mv	a0,s6
    800050de:	ffffc097          	auipc	ra,0xffffc
    800050e2:	5a6080e7          	jalr	1446(ra) # 80001684 <uvmclear>
  stackbase = sp - PGSIZE;
    800050e6:	7afd                	lui	s5,0xfffff
    800050e8:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800050ea:	df043783          	ld	a5,-528(s0)
    800050ee:	6388                	ld	a0,0(a5)
    800050f0:	c925                	beqz	a0,80005160 <exec+0x224>
    800050f2:	e9040993          	addi	s3,s0,-368
    800050f6:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800050fa:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800050fc:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800050fe:	ffffc097          	auipc	ra,0xffffc
    80005102:	d9a080e7          	jalr	-614(ra) # 80000e98 <strlen>
    80005106:	0015079b          	addiw	a5,a0,1
    8000510a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000510e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005112:	15596263          	bltu	s2,s5,80005256 <exec+0x31a>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005116:	df043d83          	ld	s11,-528(s0)
    8000511a:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000511e:	8552                	mv	a0,s4
    80005120:	ffffc097          	auipc	ra,0xffffc
    80005124:	d78080e7          	jalr	-648(ra) # 80000e98 <strlen>
    80005128:	0015069b          	addiw	a3,a0,1
    8000512c:	8652                	mv	a2,s4
    8000512e:	85ca                	mv	a1,s2
    80005130:	855a                	mv	a0,s6
    80005132:	ffffc097          	auipc	ra,0xffffc
    80005136:	584080e7          	jalr	1412(ra) # 800016b6 <copyout>
    8000513a:	12054263          	bltz	a0,8000525e <exec+0x322>
    ustack[argc] = sp;
    8000513e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005142:	0485                	addi	s1,s1,1
    80005144:	008d8793          	addi	a5,s11,8
    80005148:	def43823          	sd	a5,-528(s0)
    8000514c:	008db503          	ld	a0,8(s11)
    80005150:	c911                	beqz	a0,80005164 <exec+0x228>
    if(argc >= MAXARG)
    80005152:	09a1                	addi	s3,s3,8
    80005154:	fb3c95e3          	bne	s9,s3,800050fe <exec+0x1c2>
  sz = sz1;
    80005158:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000515c:	4a81                	li	s5,0
    8000515e:	a0e9                	j	80005228 <exec+0x2ec>
  sp = sz;
    80005160:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005162:	4481                	li	s1,0
  ustack[argc] = 0;
    80005164:	00349793          	slli	a5,s1,0x3
    80005168:	f9078793          	addi	a5,a5,-112
    8000516c:	97a2                	add	a5,a5,s0
    8000516e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005172:	00148693          	addi	a3,s1,1
    80005176:	068e                	slli	a3,a3,0x3
    80005178:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000517c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005180:	01597663          	bgeu	s2,s5,8000518c <exec+0x250>
  sz = sz1;
    80005184:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005188:	4a81                	li	s5,0
    8000518a:	a879                	j	80005228 <exec+0x2ec>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000518c:	e9040613          	addi	a2,s0,-368
    80005190:	85ca                	mv	a1,s2
    80005192:	855a                	mv	a0,s6
    80005194:	ffffc097          	auipc	ra,0xffffc
    80005198:	522080e7          	jalr	1314(ra) # 800016b6 <copyout>
    8000519c:	0c054563          	bltz	a0,80005266 <exec+0x32a>
  p->trapframe->a1 = sp;
    800051a0:	058bb783          	ld	a5,88(s7)
    800051a4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800051a8:	de843783          	ld	a5,-536(s0)
    800051ac:	0007c703          	lbu	a4,0(a5)
    800051b0:	cf11                	beqz	a4,800051cc <exec+0x290>
    800051b2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800051b4:	02f00693          	li	a3,47
    800051b8:	a039                	j	800051c6 <exec+0x28a>
      last = s+1;
    800051ba:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800051be:	0785                	addi	a5,a5,1
    800051c0:	fff7c703          	lbu	a4,-1(a5)
    800051c4:	c701                	beqz	a4,800051cc <exec+0x290>
    if(*s == '/')
    800051c6:	fed71ce3          	bne	a4,a3,800051be <exec+0x282>
    800051ca:	bfc5                	j	800051ba <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800051cc:	4641                	li	a2,16
    800051ce:	de843583          	ld	a1,-536(s0)
    800051d2:	158b8513          	addi	a0,s7,344
    800051d6:	ffffc097          	auipc	ra,0xffffc
    800051da:	c90080e7          	jalr	-880(ra) # 80000e66 <safestrcpy>
  oldpagetable = p->pagetable;
    800051de:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800051e2:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800051e6:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800051ea:	058bb783          	ld	a5,88(s7)
    800051ee:	e6843703          	ld	a4,-408(s0)
    800051f2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800051f4:	058bb783          	ld	a5,88(s7)
    800051f8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800051fc:	85ea                	mv	a1,s10
    800051fe:	ffffd097          	auipc	ra,0xffffd
    80005202:	a3c080e7          	jalr	-1476(ra) # 80001c3a <proc_freepagetable>
if (p->pid == 1) 
    80005206:	030ba703          	lw	a4,48(s7)
    8000520a:	4785                	li	a5,1
    8000520c:	00f70563          	beq	a4,a5,80005216 <exec+0x2da>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005210:	0004851b          	sext.w	a0,s1
    80005214:	b3d1                	j	80004fd8 <exec+0x9c>
 vmprint(p->pagetable);
    80005216:	050bb503          	ld	a0,80(s7)
    8000521a:	ffffc097          	auipc	ra,0xffffc
    8000521e:	666080e7          	jalr	1638(ra) # 80001880 <vmprint>
    80005222:	b7fd                	j	80005210 <exec+0x2d4>
    80005224:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005228:	df843583          	ld	a1,-520(s0)
    8000522c:	855a                	mv	a0,s6
    8000522e:	ffffd097          	auipc	ra,0xffffd
    80005232:	a0c080e7          	jalr	-1524(ra) # 80001c3a <proc_freepagetable>
  if(ip){
    80005236:	d80a97e3          	bnez	s5,80004fc4 <exec+0x88>
  return -1;
    8000523a:	557d                	li	a0,-1
    8000523c:	bb71                	j	80004fd8 <exec+0x9c>
    8000523e:	df243c23          	sd	s2,-520(s0)
    80005242:	b7dd                	j	80005228 <exec+0x2ec>
    80005244:	df243c23          	sd	s2,-520(s0)
    80005248:	b7c5                	j	80005228 <exec+0x2ec>
    8000524a:	df243c23          	sd	s2,-520(s0)
    8000524e:	bfe9                	j	80005228 <exec+0x2ec>
    80005250:	df243c23          	sd	s2,-520(s0)
    80005254:	bfd1                	j	80005228 <exec+0x2ec>
  sz = sz1;
    80005256:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000525a:	4a81                	li	s5,0
    8000525c:	b7f1                	j	80005228 <exec+0x2ec>
  sz = sz1;
    8000525e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005262:	4a81                	li	s5,0
    80005264:	b7d1                	j	80005228 <exec+0x2ec>
  sz = sz1;
    80005266:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000526a:	4a81                	li	s5,0
    8000526c:	bf75                	j	80005228 <exec+0x2ec>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000526e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005272:	e0843783          	ld	a5,-504(s0)
    80005276:	0017869b          	addiw	a3,a5,1
    8000527a:	e0d43423          	sd	a3,-504(s0)
    8000527e:	e0043783          	ld	a5,-512(s0)
    80005282:	0387879b          	addiw	a5,a5,56
    80005286:	e8845703          	lhu	a4,-376(s0)
    8000528a:	e0e6d3e3          	bge	a3,a4,80005090 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000528e:	2781                	sext.w	a5,a5
    80005290:	e0f43023          	sd	a5,-512(s0)
    80005294:	03800713          	li	a4,56
    80005298:	86be                	mv	a3,a5
    8000529a:	e1840613          	addi	a2,s0,-488
    8000529e:	4581                	li	a1,0
    800052a0:	8556                	mv	a0,s5
    800052a2:	fffff097          	auipc	ra,0xfffff
    800052a6:	a3e080e7          	jalr	-1474(ra) # 80003ce0 <readi>
    800052aa:	03800793          	li	a5,56
    800052ae:	f6f51be3          	bne	a0,a5,80005224 <exec+0x2e8>
    if(ph.type != ELF_PROG_LOAD)
    800052b2:	e1842783          	lw	a5,-488(s0)
    800052b6:	4705                	li	a4,1
    800052b8:	fae79de3          	bne	a5,a4,80005272 <exec+0x336>
    if(ph.memsz < ph.filesz)
    800052bc:	e4043483          	ld	s1,-448(s0)
    800052c0:	e3843783          	ld	a5,-456(s0)
    800052c4:	f6f4ede3          	bltu	s1,a5,8000523e <exec+0x302>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800052c8:	e2843783          	ld	a5,-472(s0)
    800052cc:	94be                	add	s1,s1,a5
    800052ce:	f6f4ebe3          	bltu	s1,a5,80005244 <exec+0x308>
    if(ph.vaddr % PGSIZE != 0)
    800052d2:	de043703          	ld	a4,-544(s0)
    800052d6:	8ff9                	and	a5,a5,a4
    800052d8:	fbad                	bnez	a5,8000524a <exec+0x30e>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800052da:	e1c42503          	lw	a0,-484(s0)
    800052de:	00000097          	auipc	ra,0x0
    800052e2:	c44080e7          	jalr	-956(ra) # 80004f22 <flags2perm>
    800052e6:	86aa                	mv	a3,a0
    800052e8:	8626                	mv	a2,s1
    800052ea:	85ca                	mv	a1,s2
    800052ec:	855a                	mv	a0,s6
    800052ee:	ffffc097          	auipc	ra,0xffffc
    800052f2:	16c080e7          	jalr	364(ra) # 8000145a <uvmalloc>
    800052f6:	dea43c23          	sd	a0,-520(s0)
    800052fa:	d939                	beqz	a0,80005250 <exec+0x314>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800052fc:	e2843c03          	ld	s8,-472(s0)
    80005300:	e2042c83          	lw	s9,-480(s0)
    80005304:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005308:	f60b83e3          	beqz	s7,8000526e <exec+0x332>
    8000530c:	89de                	mv	s3,s7
    8000530e:	4481                	li	s1,0
    80005310:	bbb9                	j	8000506e <exec+0x132>

0000000080005312 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005312:	7179                	addi	sp,sp,-48
    80005314:	f406                	sd	ra,40(sp)
    80005316:	f022                	sd	s0,32(sp)
    80005318:	ec26                	sd	s1,24(sp)
    8000531a:	e84a                	sd	s2,16(sp)
    8000531c:	1800                	addi	s0,sp,48
    8000531e:	892e                	mv	s2,a1
    80005320:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005322:	fdc40593          	addi	a1,s0,-36
    80005326:	ffffe097          	auipc	ra,0xffffe
    8000532a:	8fa080e7          	jalr	-1798(ra) # 80002c20 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000532e:	fdc42703          	lw	a4,-36(s0)
    80005332:	47bd                	li	a5,15
    80005334:	02e7eb63          	bltu	a5,a4,8000536a <argfd+0x58>
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	7a2080e7          	jalr	1954(ra) # 80001ada <myproc>
    80005340:	fdc42703          	lw	a4,-36(s0)
    80005344:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd27a>
    80005348:	078e                	slli	a5,a5,0x3
    8000534a:	953e                	add	a0,a0,a5
    8000534c:	611c                	ld	a5,0(a0)
    8000534e:	c385                	beqz	a5,8000536e <argfd+0x5c>
    return -1;
  if(pfd)
    80005350:	00090463          	beqz	s2,80005358 <argfd+0x46>
    *pfd = fd;
    80005354:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005358:	4501                	li	a0,0
  if(pf)
    8000535a:	c091                	beqz	s1,8000535e <argfd+0x4c>
    *pf = f;
    8000535c:	e09c                	sd	a5,0(s1)
}
    8000535e:	70a2                	ld	ra,40(sp)
    80005360:	7402                	ld	s0,32(sp)
    80005362:	64e2                	ld	s1,24(sp)
    80005364:	6942                	ld	s2,16(sp)
    80005366:	6145                	addi	sp,sp,48
    80005368:	8082                	ret
    return -1;
    8000536a:	557d                	li	a0,-1
    8000536c:	bfcd                	j	8000535e <argfd+0x4c>
    8000536e:	557d                	li	a0,-1
    80005370:	b7fd                	j	8000535e <argfd+0x4c>

0000000080005372 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005372:	1101                	addi	sp,sp,-32
    80005374:	ec06                	sd	ra,24(sp)
    80005376:	e822                	sd	s0,16(sp)
    80005378:	e426                	sd	s1,8(sp)
    8000537a:	1000                	addi	s0,sp,32
    8000537c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000537e:	ffffc097          	auipc	ra,0xffffc
    80005382:	75c080e7          	jalr	1884(ra) # 80001ada <myproc>
    80005386:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005388:	0d050793          	addi	a5,a0,208
    8000538c:	4501                	li	a0,0
    8000538e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005390:	6398                	ld	a4,0(a5)
    80005392:	cb19                	beqz	a4,800053a8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005394:	2505                	addiw	a0,a0,1
    80005396:	07a1                	addi	a5,a5,8
    80005398:	fed51ce3          	bne	a0,a3,80005390 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000539c:	557d                	li	a0,-1
}
    8000539e:	60e2                	ld	ra,24(sp)
    800053a0:	6442                	ld	s0,16(sp)
    800053a2:	64a2                	ld	s1,8(sp)
    800053a4:	6105                	addi	sp,sp,32
    800053a6:	8082                	ret
      p->ofile[fd] = f;
    800053a8:	01a50793          	addi	a5,a0,26
    800053ac:	078e                	slli	a5,a5,0x3
    800053ae:	963e                	add	a2,a2,a5
    800053b0:	e204                	sd	s1,0(a2)
      return fd;
    800053b2:	b7f5                	j	8000539e <fdalloc+0x2c>

00000000800053b4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800053b4:	715d                	addi	sp,sp,-80
    800053b6:	e486                	sd	ra,72(sp)
    800053b8:	e0a2                	sd	s0,64(sp)
    800053ba:	fc26                	sd	s1,56(sp)
    800053bc:	f84a                	sd	s2,48(sp)
    800053be:	f44e                	sd	s3,40(sp)
    800053c0:	f052                	sd	s4,32(sp)
    800053c2:	ec56                	sd	s5,24(sp)
    800053c4:	e85a                	sd	s6,16(sp)
    800053c6:	0880                	addi	s0,sp,80
    800053c8:	8b2e                	mv	s6,a1
    800053ca:	89b2                	mv	s3,a2
    800053cc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800053ce:	fb040593          	addi	a1,s0,-80
    800053d2:	fffff097          	auipc	ra,0xfffff
    800053d6:	e26080e7          	jalr	-474(ra) # 800041f8 <nameiparent>
    800053da:	84aa                	mv	s1,a0
    800053dc:	14050f63          	beqz	a0,8000553a <create+0x186>
    return 0;

  ilock(dp);
    800053e0:	ffffe097          	auipc	ra,0xffffe
    800053e4:	5a2080e7          	jalr	1442(ra) # 80003982 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800053e8:	4601                	li	a2,0
    800053ea:	fb040593          	addi	a1,s0,-80
    800053ee:	8526                	mv	a0,s1
    800053f0:	fffff097          	auipc	ra,0xfffff
    800053f4:	b22080e7          	jalr	-1246(ra) # 80003f12 <dirlookup>
    800053f8:	8aaa                	mv	s5,a0
    800053fa:	c931                	beqz	a0,8000544e <create+0x9a>
    iunlockput(dp);
    800053fc:	8526                	mv	a0,s1
    800053fe:	fffff097          	auipc	ra,0xfffff
    80005402:	890080e7          	jalr	-1904(ra) # 80003c8e <iunlockput>
    ilock(ip);
    80005406:	8556                	mv	a0,s5
    80005408:	ffffe097          	auipc	ra,0xffffe
    8000540c:	57a080e7          	jalr	1402(ra) # 80003982 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005410:	000b059b          	sext.w	a1,s6
    80005414:	4789                	li	a5,2
    80005416:	02f59563          	bne	a1,a5,80005440 <create+0x8c>
    8000541a:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd2a4>
    8000541e:	37f9                	addiw	a5,a5,-2
    80005420:	17c2                	slli	a5,a5,0x30
    80005422:	93c1                	srli	a5,a5,0x30
    80005424:	4705                	li	a4,1
    80005426:	00f76d63          	bltu	a4,a5,80005440 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000542a:	8556                	mv	a0,s5
    8000542c:	60a6                	ld	ra,72(sp)
    8000542e:	6406                	ld	s0,64(sp)
    80005430:	74e2                	ld	s1,56(sp)
    80005432:	7942                	ld	s2,48(sp)
    80005434:	79a2                	ld	s3,40(sp)
    80005436:	7a02                	ld	s4,32(sp)
    80005438:	6ae2                	ld	s5,24(sp)
    8000543a:	6b42                	ld	s6,16(sp)
    8000543c:	6161                	addi	sp,sp,80
    8000543e:	8082                	ret
    iunlockput(ip);
    80005440:	8556                	mv	a0,s5
    80005442:	fffff097          	auipc	ra,0xfffff
    80005446:	84c080e7          	jalr	-1972(ra) # 80003c8e <iunlockput>
    return 0;
    8000544a:	4a81                	li	s5,0
    8000544c:	bff9                	j	8000542a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000544e:	85da                	mv	a1,s6
    80005450:	4088                	lw	a0,0(s1)
    80005452:	ffffe097          	auipc	ra,0xffffe
    80005456:	392080e7          	jalr	914(ra) # 800037e4 <ialloc>
    8000545a:	8a2a                	mv	s4,a0
    8000545c:	c539                	beqz	a0,800054aa <create+0xf6>
  ilock(ip);
    8000545e:	ffffe097          	auipc	ra,0xffffe
    80005462:	524080e7          	jalr	1316(ra) # 80003982 <ilock>
  ip->major = major;
    80005466:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000546a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000546e:	4905                	li	s2,1
    80005470:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005474:	8552                	mv	a0,s4
    80005476:	ffffe097          	auipc	ra,0xffffe
    8000547a:	440080e7          	jalr	1088(ra) # 800038b6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000547e:	000b059b          	sext.w	a1,s6
    80005482:	03258b63          	beq	a1,s2,800054b8 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005486:	004a2603          	lw	a2,4(s4)
    8000548a:	fb040593          	addi	a1,s0,-80
    8000548e:	8526                	mv	a0,s1
    80005490:	fffff097          	auipc	ra,0xfffff
    80005494:	c98080e7          	jalr	-872(ra) # 80004128 <dirlink>
    80005498:	06054f63          	bltz	a0,80005516 <create+0x162>
  iunlockput(dp);
    8000549c:	8526                	mv	a0,s1
    8000549e:	ffffe097          	auipc	ra,0xffffe
    800054a2:	7f0080e7          	jalr	2032(ra) # 80003c8e <iunlockput>
  return ip;
    800054a6:	8ad2                	mv	s5,s4
    800054a8:	b749                	j	8000542a <create+0x76>
    iunlockput(dp);
    800054aa:	8526                	mv	a0,s1
    800054ac:	ffffe097          	auipc	ra,0xffffe
    800054b0:	7e2080e7          	jalr	2018(ra) # 80003c8e <iunlockput>
    return 0;
    800054b4:	8ad2                	mv	s5,s4
    800054b6:	bf95                	j	8000542a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800054b8:	004a2603          	lw	a2,4(s4)
    800054bc:	00003597          	auipc	a1,0x3
    800054c0:	27458593          	addi	a1,a1,628 # 80008730 <syscalls+0x2b0>
    800054c4:	8552                	mv	a0,s4
    800054c6:	fffff097          	auipc	ra,0xfffff
    800054ca:	c62080e7          	jalr	-926(ra) # 80004128 <dirlink>
    800054ce:	04054463          	bltz	a0,80005516 <create+0x162>
    800054d2:	40d0                	lw	a2,4(s1)
    800054d4:	00003597          	auipc	a1,0x3
    800054d8:	26458593          	addi	a1,a1,612 # 80008738 <syscalls+0x2b8>
    800054dc:	8552                	mv	a0,s4
    800054de:	fffff097          	auipc	ra,0xfffff
    800054e2:	c4a080e7          	jalr	-950(ra) # 80004128 <dirlink>
    800054e6:	02054863          	bltz	a0,80005516 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800054ea:	004a2603          	lw	a2,4(s4)
    800054ee:	fb040593          	addi	a1,s0,-80
    800054f2:	8526                	mv	a0,s1
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	c34080e7          	jalr	-972(ra) # 80004128 <dirlink>
    800054fc:	00054d63          	bltz	a0,80005516 <create+0x162>
    dp->nlink++;  // for ".."
    80005500:	04a4d783          	lhu	a5,74(s1)
    80005504:	2785                	addiw	a5,a5,1
    80005506:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000550a:	8526                	mv	a0,s1
    8000550c:	ffffe097          	auipc	ra,0xffffe
    80005510:	3aa080e7          	jalr	938(ra) # 800038b6 <iupdate>
    80005514:	b761                	j	8000549c <create+0xe8>
  ip->nlink = 0;
    80005516:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000551a:	8552                	mv	a0,s4
    8000551c:	ffffe097          	auipc	ra,0xffffe
    80005520:	39a080e7          	jalr	922(ra) # 800038b6 <iupdate>
  iunlockput(ip);
    80005524:	8552                	mv	a0,s4
    80005526:	ffffe097          	auipc	ra,0xffffe
    8000552a:	768080e7          	jalr	1896(ra) # 80003c8e <iunlockput>
  iunlockput(dp);
    8000552e:	8526                	mv	a0,s1
    80005530:	ffffe097          	auipc	ra,0xffffe
    80005534:	75e080e7          	jalr	1886(ra) # 80003c8e <iunlockput>
  return 0;
    80005538:	bdcd                	j	8000542a <create+0x76>
    return 0;
    8000553a:	8aaa                	mv	s5,a0
    8000553c:	b5fd                	j	8000542a <create+0x76>

000000008000553e <sys_dup>:
{
    8000553e:	7179                	addi	sp,sp,-48
    80005540:	f406                	sd	ra,40(sp)
    80005542:	f022                	sd	s0,32(sp)
    80005544:	ec26                	sd	s1,24(sp)
    80005546:	e84a                	sd	s2,16(sp)
    80005548:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000554a:	fd840613          	addi	a2,s0,-40
    8000554e:	4581                	li	a1,0
    80005550:	4501                	li	a0,0
    80005552:	00000097          	auipc	ra,0x0
    80005556:	dc0080e7          	jalr	-576(ra) # 80005312 <argfd>
    return -1;
    8000555a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000555c:	02054363          	bltz	a0,80005582 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005560:	fd843903          	ld	s2,-40(s0)
    80005564:	854a                	mv	a0,s2
    80005566:	00000097          	auipc	ra,0x0
    8000556a:	e0c080e7          	jalr	-500(ra) # 80005372 <fdalloc>
    8000556e:	84aa                	mv	s1,a0
    return -1;
    80005570:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005572:	00054863          	bltz	a0,80005582 <sys_dup+0x44>
  filedup(f);
    80005576:	854a                	mv	a0,s2
    80005578:	fffff097          	auipc	ra,0xfffff
    8000557c:	2f8080e7          	jalr	760(ra) # 80004870 <filedup>
  return fd;
    80005580:	87a6                	mv	a5,s1
}
    80005582:	853e                	mv	a0,a5
    80005584:	70a2                	ld	ra,40(sp)
    80005586:	7402                	ld	s0,32(sp)
    80005588:	64e2                	ld	s1,24(sp)
    8000558a:	6942                	ld	s2,16(sp)
    8000558c:	6145                	addi	sp,sp,48
    8000558e:	8082                	ret

0000000080005590 <sys_read>:
{
    80005590:	7179                	addi	sp,sp,-48
    80005592:	f406                	sd	ra,40(sp)
    80005594:	f022                	sd	s0,32(sp)
    80005596:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005598:	fd840593          	addi	a1,s0,-40
    8000559c:	4505                	li	a0,1
    8000559e:	ffffd097          	auipc	ra,0xffffd
    800055a2:	6a2080e7          	jalr	1698(ra) # 80002c40 <argaddr>
  argint(2, &n);
    800055a6:	fe440593          	addi	a1,s0,-28
    800055aa:	4509                	li	a0,2
    800055ac:	ffffd097          	auipc	ra,0xffffd
    800055b0:	674080e7          	jalr	1652(ra) # 80002c20 <argint>
  if(argfd(0, 0, &f) < 0)
    800055b4:	fe840613          	addi	a2,s0,-24
    800055b8:	4581                	li	a1,0
    800055ba:	4501                	li	a0,0
    800055bc:	00000097          	auipc	ra,0x0
    800055c0:	d56080e7          	jalr	-682(ra) # 80005312 <argfd>
    800055c4:	87aa                	mv	a5,a0
    return -1;
    800055c6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800055c8:	0007cc63          	bltz	a5,800055e0 <sys_read+0x50>
  return fileread(f, p, n);
    800055cc:	fe442603          	lw	a2,-28(s0)
    800055d0:	fd843583          	ld	a1,-40(s0)
    800055d4:	fe843503          	ld	a0,-24(s0)
    800055d8:	fffff097          	auipc	ra,0xfffff
    800055dc:	424080e7          	jalr	1060(ra) # 800049fc <fileread>
}
    800055e0:	70a2                	ld	ra,40(sp)
    800055e2:	7402                	ld	s0,32(sp)
    800055e4:	6145                	addi	sp,sp,48
    800055e6:	8082                	ret

00000000800055e8 <sys_write>:
{
    800055e8:	7179                	addi	sp,sp,-48
    800055ea:	f406                	sd	ra,40(sp)
    800055ec:	f022                	sd	s0,32(sp)
    800055ee:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800055f0:	fd840593          	addi	a1,s0,-40
    800055f4:	4505                	li	a0,1
    800055f6:	ffffd097          	auipc	ra,0xffffd
    800055fa:	64a080e7          	jalr	1610(ra) # 80002c40 <argaddr>
  argint(2, &n);
    800055fe:	fe440593          	addi	a1,s0,-28
    80005602:	4509                	li	a0,2
    80005604:	ffffd097          	auipc	ra,0xffffd
    80005608:	61c080e7          	jalr	1564(ra) # 80002c20 <argint>
  if(argfd(0, 0, &f) < 0)
    8000560c:	fe840613          	addi	a2,s0,-24
    80005610:	4581                	li	a1,0
    80005612:	4501                	li	a0,0
    80005614:	00000097          	auipc	ra,0x0
    80005618:	cfe080e7          	jalr	-770(ra) # 80005312 <argfd>
    8000561c:	87aa                	mv	a5,a0
    return -1;
    8000561e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005620:	0007cc63          	bltz	a5,80005638 <sys_write+0x50>
  return filewrite(f, p, n);
    80005624:	fe442603          	lw	a2,-28(s0)
    80005628:	fd843583          	ld	a1,-40(s0)
    8000562c:	fe843503          	ld	a0,-24(s0)
    80005630:	fffff097          	auipc	ra,0xfffff
    80005634:	48e080e7          	jalr	1166(ra) # 80004abe <filewrite>
}
    80005638:	70a2                	ld	ra,40(sp)
    8000563a:	7402                	ld	s0,32(sp)
    8000563c:	6145                	addi	sp,sp,48
    8000563e:	8082                	ret

0000000080005640 <sys_close>:
{
    80005640:	1101                	addi	sp,sp,-32
    80005642:	ec06                	sd	ra,24(sp)
    80005644:	e822                	sd	s0,16(sp)
    80005646:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005648:	fe040613          	addi	a2,s0,-32
    8000564c:	fec40593          	addi	a1,s0,-20
    80005650:	4501                	li	a0,0
    80005652:	00000097          	auipc	ra,0x0
    80005656:	cc0080e7          	jalr	-832(ra) # 80005312 <argfd>
    return -1;
    8000565a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000565c:	02054463          	bltz	a0,80005684 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005660:	ffffc097          	auipc	ra,0xffffc
    80005664:	47a080e7          	jalr	1146(ra) # 80001ada <myproc>
    80005668:	fec42783          	lw	a5,-20(s0)
    8000566c:	07e9                	addi	a5,a5,26
    8000566e:	078e                	slli	a5,a5,0x3
    80005670:	953e                	add	a0,a0,a5
    80005672:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005676:	fe043503          	ld	a0,-32(s0)
    8000567a:	fffff097          	auipc	ra,0xfffff
    8000567e:	248080e7          	jalr	584(ra) # 800048c2 <fileclose>
  return 0;
    80005682:	4781                	li	a5,0
}
    80005684:	853e                	mv	a0,a5
    80005686:	60e2                	ld	ra,24(sp)
    80005688:	6442                	ld	s0,16(sp)
    8000568a:	6105                	addi	sp,sp,32
    8000568c:	8082                	ret

000000008000568e <sys_fstat>:
{
    8000568e:	1101                	addi	sp,sp,-32
    80005690:	ec06                	sd	ra,24(sp)
    80005692:	e822                	sd	s0,16(sp)
    80005694:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005696:	fe040593          	addi	a1,s0,-32
    8000569a:	4505                	li	a0,1
    8000569c:	ffffd097          	auipc	ra,0xffffd
    800056a0:	5a4080e7          	jalr	1444(ra) # 80002c40 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800056a4:	fe840613          	addi	a2,s0,-24
    800056a8:	4581                	li	a1,0
    800056aa:	4501                	li	a0,0
    800056ac:	00000097          	auipc	ra,0x0
    800056b0:	c66080e7          	jalr	-922(ra) # 80005312 <argfd>
    800056b4:	87aa                	mv	a5,a0
    return -1;
    800056b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056b8:	0007ca63          	bltz	a5,800056cc <sys_fstat+0x3e>
  return filestat(f, st);
    800056bc:	fe043583          	ld	a1,-32(s0)
    800056c0:	fe843503          	ld	a0,-24(s0)
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	2c6080e7          	jalr	710(ra) # 8000498a <filestat>
}
    800056cc:	60e2                	ld	ra,24(sp)
    800056ce:	6442                	ld	s0,16(sp)
    800056d0:	6105                	addi	sp,sp,32
    800056d2:	8082                	ret

00000000800056d4 <sys_link>:
{
    800056d4:	7169                	addi	sp,sp,-304
    800056d6:	f606                	sd	ra,296(sp)
    800056d8:	f222                	sd	s0,288(sp)
    800056da:	ee26                	sd	s1,280(sp)
    800056dc:	ea4a                	sd	s2,272(sp)
    800056de:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056e0:	08000613          	li	a2,128
    800056e4:	ed040593          	addi	a1,s0,-304
    800056e8:	4501                	li	a0,0
    800056ea:	ffffd097          	auipc	ra,0xffffd
    800056ee:	576080e7          	jalr	1398(ra) # 80002c60 <argstr>
    return -1;
    800056f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056f4:	10054e63          	bltz	a0,80005810 <sys_link+0x13c>
    800056f8:	08000613          	li	a2,128
    800056fc:	f5040593          	addi	a1,s0,-176
    80005700:	4505                	li	a0,1
    80005702:	ffffd097          	auipc	ra,0xffffd
    80005706:	55e080e7          	jalr	1374(ra) # 80002c60 <argstr>
    return -1;
    8000570a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000570c:	10054263          	bltz	a0,80005810 <sys_link+0x13c>
  begin_op();
    80005710:	fffff097          	auipc	ra,0xfffff
    80005714:	cea080e7          	jalr	-790(ra) # 800043fa <begin_op>
  if((ip = namei(old)) == 0){
    80005718:	ed040513          	addi	a0,s0,-304
    8000571c:	fffff097          	auipc	ra,0xfffff
    80005720:	abe080e7          	jalr	-1346(ra) # 800041da <namei>
    80005724:	84aa                	mv	s1,a0
    80005726:	c551                	beqz	a0,800057b2 <sys_link+0xde>
  ilock(ip);
    80005728:	ffffe097          	auipc	ra,0xffffe
    8000572c:	25a080e7          	jalr	602(ra) # 80003982 <ilock>
  if(ip->type == T_DIR){
    80005730:	04449703          	lh	a4,68(s1)
    80005734:	4785                	li	a5,1
    80005736:	08f70463          	beq	a4,a5,800057be <sys_link+0xea>
  ip->nlink++;
    8000573a:	04a4d783          	lhu	a5,74(s1)
    8000573e:	2785                	addiw	a5,a5,1
    80005740:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005744:	8526                	mv	a0,s1
    80005746:	ffffe097          	auipc	ra,0xffffe
    8000574a:	170080e7          	jalr	368(ra) # 800038b6 <iupdate>
  iunlock(ip);
    8000574e:	8526                	mv	a0,s1
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	2f4080e7          	jalr	756(ra) # 80003a44 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005758:	fd040593          	addi	a1,s0,-48
    8000575c:	f5040513          	addi	a0,s0,-176
    80005760:	fffff097          	auipc	ra,0xfffff
    80005764:	a98080e7          	jalr	-1384(ra) # 800041f8 <nameiparent>
    80005768:	892a                	mv	s2,a0
    8000576a:	c935                	beqz	a0,800057de <sys_link+0x10a>
  ilock(dp);
    8000576c:	ffffe097          	auipc	ra,0xffffe
    80005770:	216080e7          	jalr	534(ra) # 80003982 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005774:	00092703          	lw	a4,0(s2)
    80005778:	409c                	lw	a5,0(s1)
    8000577a:	04f71d63          	bne	a4,a5,800057d4 <sys_link+0x100>
    8000577e:	40d0                	lw	a2,4(s1)
    80005780:	fd040593          	addi	a1,s0,-48
    80005784:	854a                	mv	a0,s2
    80005786:	fffff097          	auipc	ra,0xfffff
    8000578a:	9a2080e7          	jalr	-1630(ra) # 80004128 <dirlink>
    8000578e:	04054363          	bltz	a0,800057d4 <sys_link+0x100>
  iunlockput(dp);
    80005792:	854a                	mv	a0,s2
    80005794:	ffffe097          	auipc	ra,0xffffe
    80005798:	4fa080e7          	jalr	1274(ra) # 80003c8e <iunlockput>
  iput(ip);
    8000579c:	8526                	mv	a0,s1
    8000579e:	ffffe097          	auipc	ra,0xffffe
    800057a2:	448080e7          	jalr	1096(ra) # 80003be6 <iput>
  end_op();
    800057a6:	fffff097          	auipc	ra,0xfffff
    800057aa:	cd2080e7          	jalr	-814(ra) # 80004478 <end_op>
  return 0;
    800057ae:	4781                	li	a5,0
    800057b0:	a085                	j	80005810 <sys_link+0x13c>
    end_op();
    800057b2:	fffff097          	auipc	ra,0xfffff
    800057b6:	cc6080e7          	jalr	-826(ra) # 80004478 <end_op>
    return -1;
    800057ba:	57fd                	li	a5,-1
    800057bc:	a891                	j	80005810 <sys_link+0x13c>
    iunlockput(ip);
    800057be:	8526                	mv	a0,s1
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	4ce080e7          	jalr	1230(ra) # 80003c8e <iunlockput>
    end_op();
    800057c8:	fffff097          	auipc	ra,0xfffff
    800057cc:	cb0080e7          	jalr	-848(ra) # 80004478 <end_op>
    return -1;
    800057d0:	57fd                	li	a5,-1
    800057d2:	a83d                	j	80005810 <sys_link+0x13c>
    iunlockput(dp);
    800057d4:	854a                	mv	a0,s2
    800057d6:	ffffe097          	auipc	ra,0xffffe
    800057da:	4b8080e7          	jalr	1208(ra) # 80003c8e <iunlockput>
  ilock(ip);
    800057de:	8526                	mv	a0,s1
    800057e0:	ffffe097          	auipc	ra,0xffffe
    800057e4:	1a2080e7          	jalr	418(ra) # 80003982 <ilock>
  ip->nlink--;
    800057e8:	04a4d783          	lhu	a5,74(s1)
    800057ec:	37fd                	addiw	a5,a5,-1
    800057ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057f2:	8526                	mv	a0,s1
    800057f4:	ffffe097          	auipc	ra,0xffffe
    800057f8:	0c2080e7          	jalr	194(ra) # 800038b6 <iupdate>
  iunlockput(ip);
    800057fc:	8526                	mv	a0,s1
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	490080e7          	jalr	1168(ra) # 80003c8e <iunlockput>
  end_op();
    80005806:	fffff097          	auipc	ra,0xfffff
    8000580a:	c72080e7          	jalr	-910(ra) # 80004478 <end_op>
  return -1;
    8000580e:	57fd                	li	a5,-1
}
    80005810:	853e                	mv	a0,a5
    80005812:	70b2                	ld	ra,296(sp)
    80005814:	7412                	ld	s0,288(sp)
    80005816:	64f2                	ld	s1,280(sp)
    80005818:	6952                	ld	s2,272(sp)
    8000581a:	6155                	addi	sp,sp,304
    8000581c:	8082                	ret

000000008000581e <sys_unlink>:
{
    8000581e:	7151                	addi	sp,sp,-240
    80005820:	f586                	sd	ra,232(sp)
    80005822:	f1a2                	sd	s0,224(sp)
    80005824:	eda6                	sd	s1,216(sp)
    80005826:	e9ca                	sd	s2,208(sp)
    80005828:	e5ce                	sd	s3,200(sp)
    8000582a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000582c:	08000613          	li	a2,128
    80005830:	f3040593          	addi	a1,s0,-208
    80005834:	4501                	li	a0,0
    80005836:	ffffd097          	auipc	ra,0xffffd
    8000583a:	42a080e7          	jalr	1066(ra) # 80002c60 <argstr>
    8000583e:	18054163          	bltz	a0,800059c0 <sys_unlink+0x1a2>
  begin_op();
    80005842:	fffff097          	auipc	ra,0xfffff
    80005846:	bb8080e7          	jalr	-1096(ra) # 800043fa <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000584a:	fb040593          	addi	a1,s0,-80
    8000584e:	f3040513          	addi	a0,s0,-208
    80005852:	fffff097          	auipc	ra,0xfffff
    80005856:	9a6080e7          	jalr	-1626(ra) # 800041f8 <nameiparent>
    8000585a:	84aa                	mv	s1,a0
    8000585c:	c979                	beqz	a0,80005932 <sys_unlink+0x114>
  ilock(dp);
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	124080e7          	jalr	292(ra) # 80003982 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005866:	00003597          	auipc	a1,0x3
    8000586a:	eca58593          	addi	a1,a1,-310 # 80008730 <syscalls+0x2b0>
    8000586e:	fb040513          	addi	a0,s0,-80
    80005872:	ffffe097          	auipc	ra,0xffffe
    80005876:	686080e7          	jalr	1670(ra) # 80003ef8 <namecmp>
    8000587a:	14050a63          	beqz	a0,800059ce <sys_unlink+0x1b0>
    8000587e:	00003597          	auipc	a1,0x3
    80005882:	eba58593          	addi	a1,a1,-326 # 80008738 <syscalls+0x2b8>
    80005886:	fb040513          	addi	a0,s0,-80
    8000588a:	ffffe097          	auipc	ra,0xffffe
    8000588e:	66e080e7          	jalr	1646(ra) # 80003ef8 <namecmp>
    80005892:	12050e63          	beqz	a0,800059ce <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005896:	f2c40613          	addi	a2,s0,-212
    8000589a:	fb040593          	addi	a1,s0,-80
    8000589e:	8526                	mv	a0,s1
    800058a0:	ffffe097          	auipc	ra,0xffffe
    800058a4:	672080e7          	jalr	1650(ra) # 80003f12 <dirlookup>
    800058a8:	892a                	mv	s2,a0
    800058aa:	12050263          	beqz	a0,800059ce <sys_unlink+0x1b0>
  ilock(ip);
    800058ae:	ffffe097          	auipc	ra,0xffffe
    800058b2:	0d4080e7          	jalr	212(ra) # 80003982 <ilock>
  if(ip->nlink < 1)
    800058b6:	04a91783          	lh	a5,74(s2)
    800058ba:	08f05263          	blez	a5,8000593e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800058be:	04491703          	lh	a4,68(s2)
    800058c2:	4785                	li	a5,1
    800058c4:	08f70563          	beq	a4,a5,8000594e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800058c8:	4641                	li	a2,16
    800058ca:	4581                	li	a1,0
    800058cc:	fc040513          	addi	a0,s0,-64
    800058d0:	ffffb097          	auipc	ra,0xffffb
    800058d4:	44c080e7          	jalr	1100(ra) # 80000d1c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058d8:	4741                	li	a4,16
    800058da:	f2c42683          	lw	a3,-212(s0)
    800058de:	fc040613          	addi	a2,s0,-64
    800058e2:	4581                	li	a1,0
    800058e4:	8526                	mv	a0,s1
    800058e6:	ffffe097          	auipc	ra,0xffffe
    800058ea:	4f2080e7          	jalr	1266(ra) # 80003dd8 <writei>
    800058ee:	47c1                	li	a5,16
    800058f0:	0af51563          	bne	a0,a5,8000599a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800058f4:	04491703          	lh	a4,68(s2)
    800058f8:	4785                	li	a5,1
    800058fa:	0af70863          	beq	a4,a5,800059aa <sys_unlink+0x18c>
  iunlockput(dp);
    800058fe:	8526                	mv	a0,s1
    80005900:	ffffe097          	auipc	ra,0xffffe
    80005904:	38e080e7          	jalr	910(ra) # 80003c8e <iunlockput>
  ip->nlink--;
    80005908:	04a95783          	lhu	a5,74(s2)
    8000590c:	37fd                	addiw	a5,a5,-1
    8000590e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005912:	854a                	mv	a0,s2
    80005914:	ffffe097          	auipc	ra,0xffffe
    80005918:	fa2080e7          	jalr	-94(ra) # 800038b6 <iupdate>
  iunlockput(ip);
    8000591c:	854a                	mv	a0,s2
    8000591e:	ffffe097          	auipc	ra,0xffffe
    80005922:	370080e7          	jalr	880(ra) # 80003c8e <iunlockput>
  end_op();
    80005926:	fffff097          	auipc	ra,0xfffff
    8000592a:	b52080e7          	jalr	-1198(ra) # 80004478 <end_op>
  return 0;
    8000592e:	4501                	li	a0,0
    80005930:	a84d                	j	800059e2 <sys_unlink+0x1c4>
    end_op();
    80005932:	fffff097          	auipc	ra,0xfffff
    80005936:	b46080e7          	jalr	-1210(ra) # 80004478 <end_op>
    return -1;
    8000593a:	557d                	li	a0,-1
    8000593c:	a05d                	j	800059e2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000593e:	00003517          	auipc	a0,0x3
    80005942:	e0250513          	addi	a0,a0,-510 # 80008740 <syscalls+0x2c0>
    80005946:	ffffb097          	auipc	ra,0xffffb
    8000594a:	bfa080e7          	jalr	-1030(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000594e:	04c92703          	lw	a4,76(s2)
    80005952:	02000793          	li	a5,32
    80005956:	f6e7f9e3          	bgeu	a5,a4,800058c8 <sys_unlink+0xaa>
    8000595a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000595e:	4741                	li	a4,16
    80005960:	86ce                	mv	a3,s3
    80005962:	f1840613          	addi	a2,s0,-232
    80005966:	4581                	li	a1,0
    80005968:	854a                	mv	a0,s2
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	376080e7          	jalr	886(ra) # 80003ce0 <readi>
    80005972:	47c1                	li	a5,16
    80005974:	00f51b63          	bne	a0,a5,8000598a <sys_unlink+0x16c>
    if(de.inum != 0)
    80005978:	f1845783          	lhu	a5,-232(s0)
    8000597c:	e7a1                	bnez	a5,800059c4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000597e:	29c1                	addiw	s3,s3,16
    80005980:	04c92783          	lw	a5,76(s2)
    80005984:	fcf9ede3          	bltu	s3,a5,8000595e <sys_unlink+0x140>
    80005988:	b781                	j	800058c8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000598a:	00003517          	auipc	a0,0x3
    8000598e:	dce50513          	addi	a0,a0,-562 # 80008758 <syscalls+0x2d8>
    80005992:	ffffb097          	auipc	ra,0xffffb
    80005996:	bae080e7          	jalr	-1106(ra) # 80000540 <panic>
    panic("unlink: writei");
    8000599a:	00003517          	auipc	a0,0x3
    8000599e:	dd650513          	addi	a0,a0,-554 # 80008770 <syscalls+0x2f0>
    800059a2:	ffffb097          	auipc	ra,0xffffb
    800059a6:	b9e080e7          	jalr	-1122(ra) # 80000540 <panic>
    dp->nlink--;
    800059aa:	04a4d783          	lhu	a5,74(s1)
    800059ae:	37fd                	addiw	a5,a5,-1
    800059b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800059b4:	8526                	mv	a0,s1
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	f00080e7          	jalr	-256(ra) # 800038b6 <iupdate>
    800059be:	b781                	j	800058fe <sys_unlink+0xe0>
    return -1;
    800059c0:	557d                	li	a0,-1
    800059c2:	a005                	j	800059e2 <sys_unlink+0x1c4>
    iunlockput(ip);
    800059c4:	854a                	mv	a0,s2
    800059c6:	ffffe097          	auipc	ra,0xffffe
    800059ca:	2c8080e7          	jalr	712(ra) # 80003c8e <iunlockput>
  iunlockput(dp);
    800059ce:	8526                	mv	a0,s1
    800059d0:	ffffe097          	auipc	ra,0xffffe
    800059d4:	2be080e7          	jalr	702(ra) # 80003c8e <iunlockput>
  end_op();
    800059d8:	fffff097          	auipc	ra,0xfffff
    800059dc:	aa0080e7          	jalr	-1376(ra) # 80004478 <end_op>
  return -1;
    800059e0:	557d                	li	a0,-1
}
    800059e2:	70ae                	ld	ra,232(sp)
    800059e4:	740e                	ld	s0,224(sp)
    800059e6:	64ee                	ld	s1,216(sp)
    800059e8:	694e                	ld	s2,208(sp)
    800059ea:	69ae                	ld	s3,200(sp)
    800059ec:	616d                	addi	sp,sp,240
    800059ee:	8082                	ret

00000000800059f0 <sys_open>:

uint64
sys_open(void)
{
    800059f0:	7131                	addi	sp,sp,-192
    800059f2:	fd06                	sd	ra,184(sp)
    800059f4:	f922                	sd	s0,176(sp)
    800059f6:	f526                	sd	s1,168(sp)
    800059f8:	f14a                	sd	s2,160(sp)
    800059fa:	ed4e                	sd	s3,152(sp)
    800059fc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800059fe:	f4c40593          	addi	a1,s0,-180
    80005a02:	4505                	li	a0,1
    80005a04:	ffffd097          	auipc	ra,0xffffd
    80005a08:	21c080e7          	jalr	540(ra) # 80002c20 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005a0c:	08000613          	li	a2,128
    80005a10:	f5040593          	addi	a1,s0,-176
    80005a14:	4501                	li	a0,0
    80005a16:	ffffd097          	auipc	ra,0xffffd
    80005a1a:	24a080e7          	jalr	586(ra) # 80002c60 <argstr>
    80005a1e:	87aa                	mv	a5,a0
    return -1;
    80005a20:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005a22:	0a07c963          	bltz	a5,80005ad4 <sys_open+0xe4>

  begin_op();
    80005a26:	fffff097          	auipc	ra,0xfffff
    80005a2a:	9d4080e7          	jalr	-1580(ra) # 800043fa <begin_op>

  if(omode & O_CREATE){
    80005a2e:	f4c42783          	lw	a5,-180(s0)
    80005a32:	2007f793          	andi	a5,a5,512
    80005a36:	cfc5                	beqz	a5,80005aee <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005a38:	4681                	li	a3,0
    80005a3a:	4601                	li	a2,0
    80005a3c:	4589                	li	a1,2
    80005a3e:	f5040513          	addi	a0,s0,-176
    80005a42:	00000097          	auipc	ra,0x0
    80005a46:	972080e7          	jalr	-1678(ra) # 800053b4 <create>
    80005a4a:	84aa                	mv	s1,a0
    if(ip == 0){
    80005a4c:	c959                	beqz	a0,80005ae2 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005a4e:	04449703          	lh	a4,68(s1)
    80005a52:	478d                	li	a5,3
    80005a54:	00f71763          	bne	a4,a5,80005a62 <sys_open+0x72>
    80005a58:	0464d703          	lhu	a4,70(s1)
    80005a5c:	47a5                	li	a5,9
    80005a5e:	0ce7ed63          	bltu	a5,a4,80005b38 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005a62:	fffff097          	auipc	ra,0xfffff
    80005a66:	da4080e7          	jalr	-604(ra) # 80004806 <filealloc>
    80005a6a:	89aa                	mv	s3,a0
    80005a6c:	10050363          	beqz	a0,80005b72 <sys_open+0x182>
    80005a70:	00000097          	auipc	ra,0x0
    80005a74:	902080e7          	jalr	-1790(ra) # 80005372 <fdalloc>
    80005a78:	892a                	mv	s2,a0
    80005a7a:	0e054763          	bltz	a0,80005b68 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005a7e:	04449703          	lh	a4,68(s1)
    80005a82:	478d                	li	a5,3
    80005a84:	0cf70563          	beq	a4,a5,80005b4e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005a88:	4789                	li	a5,2
    80005a8a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005a8e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005a92:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005a96:	f4c42783          	lw	a5,-180(s0)
    80005a9a:	0017c713          	xori	a4,a5,1
    80005a9e:	8b05                	andi	a4,a4,1
    80005aa0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005aa4:	0037f713          	andi	a4,a5,3
    80005aa8:	00e03733          	snez	a4,a4
    80005aac:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ab0:	4007f793          	andi	a5,a5,1024
    80005ab4:	c791                	beqz	a5,80005ac0 <sys_open+0xd0>
    80005ab6:	04449703          	lh	a4,68(s1)
    80005aba:	4789                	li	a5,2
    80005abc:	0af70063          	beq	a4,a5,80005b5c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005ac0:	8526                	mv	a0,s1
    80005ac2:	ffffe097          	auipc	ra,0xffffe
    80005ac6:	f82080e7          	jalr	-126(ra) # 80003a44 <iunlock>
  end_op();
    80005aca:	fffff097          	auipc	ra,0xfffff
    80005ace:	9ae080e7          	jalr	-1618(ra) # 80004478 <end_op>

  return fd;
    80005ad2:	854a                	mv	a0,s2
}
    80005ad4:	70ea                	ld	ra,184(sp)
    80005ad6:	744a                	ld	s0,176(sp)
    80005ad8:	74aa                	ld	s1,168(sp)
    80005ada:	790a                	ld	s2,160(sp)
    80005adc:	69ea                	ld	s3,152(sp)
    80005ade:	6129                	addi	sp,sp,192
    80005ae0:	8082                	ret
      end_op();
    80005ae2:	fffff097          	auipc	ra,0xfffff
    80005ae6:	996080e7          	jalr	-1642(ra) # 80004478 <end_op>
      return -1;
    80005aea:	557d                	li	a0,-1
    80005aec:	b7e5                	j	80005ad4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005aee:	f5040513          	addi	a0,s0,-176
    80005af2:	ffffe097          	auipc	ra,0xffffe
    80005af6:	6e8080e7          	jalr	1768(ra) # 800041da <namei>
    80005afa:	84aa                	mv	s1,a0
    80005afc:	c905                	beqz	a0,80005b2c <sys_open+0x13c>
    ilock(ip);
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	e84080e7          	jalr	-380(ra) # 80003982 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b06:	04449703          	lh	a4,68(s1)
    80005b0a:	4785                	li	a5,1
    80005b0c:	f4f711e3          	bne	a4,a5,80005a4e <sys_open+0x5e>
    80005b10:	f4c42783          	lw	a5,-180(s0)
    80005b14:	d7b9                	beqz	a5,80005a62 <sys_open+0x72>
      iunlockput(ip);
    80005b16:	8526                	mv	a0,s1
    80005b18:	ffffe097          	auipc	ra,0xffffe
    80005b1c:	176080e7          	jalr	374(ra) # 80003c8e <iunlockput>
      end_op();
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	958080e7          	jalr	-1704(ra) # 80004478 <end_op>
      return -1;
    80005b28:	557d                	li	a0,-1
    80005b2a:	b76d                	j	80005ad4 <sys_open+0xe4>
      end_op();
    80005b2c:	fffff097          	auipc	ra,0xfffff
    80005b30:	94c080e7          	jalr	-1716(ra) # 80004478 <end_op>
      return -1;
    80005b34:	557d                	li	a0,-1
    80005b36:	bf79                	j	80005ad4 <sys_open+0xe4>
    iunlockput(ip);
    80005b38:	8526                	mv	a0,s1
    80005b3a:	ffffe097          	auipc	ra,0xffffe
    80005b3e:	154080e7          	jalr	340(ra) # 80003c8e <iunlockput>
    end_op();
    80005b42:	fffff097          	auipc	ra,0xfffff
    80005b46:	936080e7          	jalr	-1738(ra) # 80004478 <end_op>
    return -1;
    80005b4a:	557d                	li	a0,-1
    80005b4c:	b761                	j	80005ad4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005b4e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005b52:	04649783          	lh	a5,70(s1)
    80005b56:	02f99223          	sh	a5,36(s3)
    80005b5a:	bf25                	j	80005a92 <sys_open+0xa2>
    itrunc(ip);
    80005b5c:	8526                	mv	a0,s1
    80005b5e:	ffffe097          	auipc	ra,0xffffe
    80005b62:	f32080e7          	jalr	-206(ra) # 80003a90 <itrunc>
    80005b66:	bfa9                	j	80005ac0 <sys_open+0xd0>
      fileclose(f);
    80005b68:	854e                	mv	a0,s3
    80005b6a:	fffff097          	auipc	ra,0xfffff
    80005b6e:	d58080e7          	jalr	-680(ra) # 800048c2 <fileclose>
    iunlockput(ip);
    80005b72:	8526                	mv	a0,s1
    80005b74:	ffffe097          	auipc	ra,0xffffe
    80005b78:	11a080e7          	jalr	282(ra) # 80003c8e <iunlockput>
    end_op();
    80005b7c:	fffff097          	auipc	ra,0xfffff
    80005b80:	8fc080e7          	jalr	-1796(ra) # 80004478 <end_op>
    return -1;
    80005b84:	557d                	li	a0,-1
    80005b86:	b7b9                	j	80005ad4 <sys_open+0xe4>

0000000080005b88 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005b88:	7175                	addi	sp,sp,-144
    80005b8a:	e506                	sd	ra,136(sp)
    80005b8c:	e122                	sd	s0,128(sp)
    80005b8e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005b90:	fffff097          	auipc	ra,0xfffff
    80005b94:	86a080e7          	jalr	-1942(ra) # 800043fa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005b98:	08000613          	li	a2,128
    80005b9c:	f7040593          	addi	a1,s0,-144
    80005ba0:	4501                	li	a0,0
    80005ba2:	ffffd097          	auipc	ra,0xffffd
    80005ba6:	0be080e7          	jalr	190(ra) # 80002c60 <argstr>
    80005baa:	02054963          	bltz	a0,80005bdc <sys_mkdir+0x54>
    80005bae:	4681                	li	a3,0
    80005bb0:	4601                	li	a2,0
    80005bb2:	4585                	li	a1,1
    80005bb4:	f7040513          	addi	a0,s0,-144
    80005bb8:	fffff097          	auipc	ra,0xfffff
    80005bbc:	7fc080e7          	jalr	2044(ra) # 800053b4 <create>
    80005bc0:	cd11                	beqz	a0,80005bdc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005bc2:	ffffe097          	auipc	ra,0xffffe
    80005bc6:	0cc080e7          	jalr	204(ra) # 80003c8e <iunlockput>
  end_op();
    80005bca:	fffff097          	auipc	ra,0xfffff
    80005bce:	8ae080e7          	jalr	-1874(ra) # 80004478 <end_op>
  return 0;
    80005bd2:	4501                	li	a0,0
}
    80005bd4:	60aa                	ld	ra,136(sp)
    80005bd6:	640a                	ld	s0,128(sp)
    80005bd8:	6149                	addi	sp,sp,144
    80005bda:	8082                	ret
    end_op();
    80005bdc:	fffff097          	auipc	ra,0xfffff
    80005be0:	89c080e7          	jalr	-1892(ra) # 80004478 <end_op>
    return -1;
    80005be4:	557d                	li	a0,-1
    80005be6:	b7fd                	j	80005bd4 <sys_mkdir+0x4c>

0000000080005be8 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005be8:	7135                	addi	sp,sp,-160
    80005bea:	ed06                	sd	ra,152(sp)
    80005bec:	e922                	sd	s0,144(sp)
    80005bee:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005bf0:	fffff097          	auipc	ra,0xfffff
    80005bf4:	80a080e7          	jalr	-2038(ra) # 800043fa <begin_op>
  argint(1, &major);
    80005bf8:	f6c40593          	addi	a1,s0,-148
    80005bfc:	4505                	li	a0,1
    80005bfe:	ffffd097          	auipc	ra,0xffffd
    80005c02:	022080e7          	jalr	34(ra) # 80002c20 <argint>
  argint(2, &minor);
    80005c06:	f6840593          	addi	a1,s0,-152
    80005c0a:	4509                	li	a0,2
    80005c0c:	ffffd097          	auipc	ra,0xffffd
    80005c10:	014080e7          	jalr	20(ra) # 80002c20 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c14:	08000613          	li	a2,128
    80005c18:	f7040593          	addi	a1,s0,-144
    80005c1c:	4501                	li	a0,0
    80005c1e:	ffffd097          	auipc	ra,0xffffd
    80005c22:	042080e7          	jalr	66(ra) # 80002c60 <argstr>
    80005c26:	02054b63          	bltz	a0,80005c5c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005c2a:	f6841683          	lh	a3,-152(s0)
    80005c2e:	f6c41603          	lh	a2,-148(s0)
    80005c32:	458d                	li	a1,3
    80005c34:	f7040513          	addi	a0,s0,-144
    80005c38:	fffff097          	auipc	ra,0xfffff
    80005c3c:	77c080e7          	jalr	1916(ra) # 800053b4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c40:	cd11                	beqz	a0,80005c5c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c42:	ffffe097          	auipc	ra,0xffffe
    80005c46:	04c080e7          	jalr	76(ra) # 80003c8e <iunlockput>
  end_op();
    80005c4a:	fffff097          	auipc	ra,0xfffff
    80005c4e:	82e080e7          	jalr	-2002(ra) # 80004478 <end_op>
  return 0;
    80005c52:	4501                	li	a0,0
}
    80005c54:	60ea                	ld	ra,152(sp)
    80005c56:	644a                	ld	s0,144(sp)
    80005c58:	610d                	addi	sp,sp,160
    80005c5a:	8082                	ret
    end_op();
    80005c5c:	fffff097          	auipc	ra,0xfffff
    80005c60:	81c080e7          	jalr	-2020(ra) # 80004478 <end_op>
    return -1;
    80005c64:	557d                	li	a0,-1
    80005c66:	b7fd                	j	80005c54 <sys_mknod+0x6c>

0000000080005c68 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c68:	7135                	addi	sp,sp,-160
    80005c6a:	ed06                	sd	ra,152(sp)
    80005c6c:	e922                	sd	s0,144(sp)
    80005c6e:	e526                	sd	s1,136(sp)
    80005c70:	e14a                	sd	s2,128(sp)
    80005c72:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005c74:	ffffc097          	auipc	ra,0xffffc
    80005c78:	e66080e7          	jalr	-410(ra) # 80001ada <myproc>
    80005c7c:	892a                	mv	s2,a0
  
  begin_op();
    80005c7e:	ffffe097          	auipc	ra,0xffffe
    80005c82:	77c080e7          	jalr	1916(ra) # 800043fa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005c86:	08000613          	li	a2,128
    80005c8a:	f6040593          	addi	a1,s0,-160
    80005c8e:	4501                	li	a0,0
    80005c90:	ffffd097          	auipc	ra,0xffffd
    80005c94:	fd0080e7          	jalr	-48(ra) # 80002c60 <argstr>
    80005c98:	04054b63          	bltz	a0,80005cee <sys_chdir+0x86>
    80005c9c:	f6040513          	addi	a0,s0,-160
    80005ca0:	ffffe097          	auipc	ra,0xffffe
    80005ca4:	53a080e7          	jalr	1338(ra) # 800041da <namei>
    80005ca8:	84aa                	mv	s1,a0
    80005caa:	c131                	beqz	a0,80005cee <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005cac:	ffffe097          	auipc	ra,0xffffe
    80005cb0:	cd6080e7          	jalr	-810(ra) # 80003982 <ilock>
  if(ip->type != T_DIR){
    80005cb4:	04449703          	lh	a4,68(s1)
    80005cb8:	4785                	li	a5,1
    80005cba:	04f71063          	bne	a4,a5,80005cfa <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005cbe:	8526                	mv	a0,s1
    80005cc0:	ffffe097          	auipc	ra,0xffffe
    80005cc4:	d84080e7          	jalr	-636(ra) # 80003a44 <iunlock>
  iput(p->cwd);
    80005cc8:	15093503          	ld	a0,336(s2)
    80005ccc:	ffffe097          	auipc	ra,0xffffe
    80005cd0:	f1a080e7          	jalr	-230(ra) # 80003be6 <iput>
  end_op();
    80005cd4:	ffffe097          	auipc	ra,0xffffe
    80005cd8:	7a4080e7          	jalr	1956(ra) # 80004478 <end_op>
  p->cwd = ip;
    80005cdc:	14993823          	sd	s1,336(s2)
  return 0;
    80005ce0:	4501                	li	a0,0
}
    80005ce2:	60ea                	ld	ra,152(sp)
    80005ce4:	644a                	ld	s0,144(sp)
    80005ce6:	64aa                	ld	s1,136(sp)
    80005ce8:	690a                	ld	s2,128(sp)
    80005cea:	610d                	addi	sp,sp,160
    80005cec:	8082                	ret
    end_op();
    80005cee:	ffffe097          	auipc	ra,0xffffe
    80005cf2:	78a080e7          	jalr	1930(ra) # 80004478 <end_op>
    return -1;
    80005cf6:	557d                	li	a0,-1
    80005cf8:	b7ed                	j	80005ce2 <sys_chdir+0x7a>
    iunlockput(ip);
    80005cfa:	8526                	mv	a0,s1
    80005cfc:	ffffe097          	auipc	ra,0xffffe
    80005d00:	f92080e7          	jalr	-110(ra) # 80003c8e <iunlockput>
    end_op();
    80005d04:	ffffe097          	auipc	ra,0xffffe
    80005d08:	774080e7          	jalr	1908(ra) # 80004478 <end_op>
    return -1;
    80005d0c:	557d                	li	a0,-1
    80005d0e:	bfd1                	j	80005ce2 <sys_chdir+0x7a>

0000000080005d10 <sys_exec>:

uint64
sys_exec(void)
{
    80005d10:	7145                	addi	sp,sp,-464
    80005d12:	e786                	sd	ra,456(sp)
    80005d14:	e3a2                	sd	s0,448(sp)
    80005d16:	ff26                	sd	s1,440(sp)
    80005d18:	fb4a                	sd	s2,432(sp)
    80005d1a:	f74e                	sd	s3,424(sp)
    80005d1c:	f352                	sd	s4,416(sp)
    80005d1e:	ef56                	sd	s5,408(sp)
    80005d20:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005d22:	e3840593          	addi	a1,s0,-456
    80005d26:	4505                	li	a0,1
    80005d28:	ffffd097          	auipc	ra,0xffffd
    80005d2c:	f18080e7          	jalr	-232(ra) # 80002c40 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005d30:	08000613          	li	a2,128
    80005d34:	f4040593          	addi	a1,s0,-192
    80005d38:	4501                	li	a0,0
    80005d3a:	ffffd097          	auipc	ra,0xffffd
    80005d3e:	f26080e7          	jalr	-218(ra) # 80002c60 <argstr>
    80005d42:	87aa                	mv	a5,a0
    return -1;
    80005d44:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005d46:	0c07c363          	bltz	a5,80005e0c <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005d4a:	10000613          	li	a2,256
    80005d4e:	4581                	li	a1,0
    80005d50:	e4040513          	addi	a0,s0,-448
    80005d54:	ffffb097          	auipc	ra,0xffffb
    80005d58:	fc8080e7          	jalr	-56(ra) # 80000d1c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d5c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005d60:	89a6                	mv	s3,s1
    80005d62:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005d64:	02000a13          	li	s4,32
    80005d68:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d6c:	00391513          	slli	a0,s2,0x3
    80005d70:	e3040593          	addi	a1,s0,-464
    80005d74:	e3843783          	ld	a5,-456(s0)
    80005d78:	953e                	add	a0,a0,a5
    80005d7a:	ffffd097          	auipc	ra,0xffffd
    80005d7e:	e08080e7          	jalr	-504(ra) # 80002b82 <fetchaddr>
    80005d82:	02054a63          	bltz	a0,80005db6 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005d86:	e3043783          	ld	a5,-464(s0)
    80005d8a:	c3b9                	beqz	a5,80005dd0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005d8c:	ffffb097          	auipc	ra,0xffffb
    80005d90:	d5a080e7          	jalr	-678(ra) # 80000ae6 <kalloc>
    80005d94:	85aa                	mv	a1,a0
    80005d96:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005d9a:	cd11                	beqz	a0,80005db6 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d9c:	6605                	lui	a2,0x1
    80005d9e:	e3043503          	ld	a0,-464(s0)
    80005da2:	ffffd097          	auipc	ra,0xffffd
    80005da6:	e32080e7          	jalr	-462(ra) # 80002bd4 <fetchstr>
    80005daa:	00054663          	bltz	a0,80005db6 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005dae:	0905                	addi	s2,s2,1
    80005db0:	09a1                	addi	s3,s3,8
    80005db2:	fb491be3          	bne	s2,s4,80005d68 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005db6:	f4040913          	addi	s2,s0,-192
    80005dba:	6088                	ld	a0,0(s1)
    80005dbc:	c539                	beqz	a0,80005e0a <sys_exec+0xfa>
    kfree(argv[i]);
    80005dbe:	ffffb097          	auipc	ra,0xffffb
    80005dc2:	c2a080e7          	jalr	-982(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dc6:	04a1                	addi	s1,s1,8
    80005dc8:	ff2499e3          	bne	s1,s2,80005dba <sys_exec+0xaa>
  return -1;
    80005dcc:	557d                	li	a0,-1
    80005dce:	a83d                	j	80005e0c <sys_exec+0xfc>
      argv[i] = 0;
    80005dd0:	0a8e                	slli	s5,s5,0x3
    80005dd2:	fc0a8793          	addi	a5,s5,-64
    80005dd6:	00878ab3          	add	s5,a5,s0
    80005dda:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005dde:	e4040593          	addi	a1,s0,-448
    80005de2:	f4040513          	addi	a0,s0,-192
    80005de6:	fffff097          	auipc	ra,0xfffff
    80005dea:	156080e7          	jalr	342(ra) # 80004f3c <exec>
    80005dee:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005df0:	f4040993          	addi	s3,s0,-192
    80005df4:	6088                	ld	a0,0(s1)
    80005df6:	c901                	beqz	a0,80005e06 <sys_exec+0xf6>
    kfree(argv[i]);
    80005df8:	ffffb097          	auipc	ra,0xffffb
    80005dfc:	bf0080e7          	jalr	-1040(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e00:	04a1                	addi	s1,s1,8
    80005e02:	ff3499e3          	bne	s1,s3,80005df4 <sys_exec+0xe4>
  return ret;
    80005e06:	854a                	mv	a0,s2
    80005e08:	a011                	j	80005e0c <sys_exec+0xfc>
  return -1;
    80005e0a:	557d                	li	a0,-1
}
    80005e0c:	60be                	ld	ra,456(sp)
    80005e0e:	641e                	ld	s0,448(sp)
    80005e10:	74fa                	ld	s1,440(sp)
    80005e12:	795a                	ld	s2,432(sp)
    80005e14:	79ba                	ld	s3,424(sp)
    80005e16:	7a1a                	ld	s4,416(sp)
    80005e18:	6afa                	ld	s5,408(sp)
    80005e1a:	6179                	addi	sp,sp,464
    80005e1c:	8082                	ret

0000000080005e1e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e1e:	7139                	addi	sp,sp,-64
    80005e20:	fc06                	sd	ra,56(sp)
    80005e22:	f822                	sd	s0,48(sp)
    80005e24:	f426                	sd	s1,40(sp)
    80005e26:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e28:	ffffc097          	auipc	ra,0xffffc
    80005e2c:	cb2080e7          	jalr	-846(ra) # 80001ada <myproc>
    80005e30:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005e32:	fd840593          	addi	a1,s0,-40
    80005e36:	4501                	li	a0,0
    80005e38:	ffffd097          	auipc	ra,0xffffd
    80005e3c:	e08080e7          	jalr	-504(ra) # 80002c40 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005e40:	fc840593          	addi	a1,s0,-56
    80005e44:	fd040513          	addi	a0,s0,-48
    80005e48:	fffff097          	auipc	ra,0xfffff
    80005e4c:	daa080e7          	jalr	-598(ra) # 80004bf2 <pipealloc>
    return -1;
    80005e50:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005e52:	0c054463          	bltz	a0,80005f1a <sys_pipe+0xfc>
  fd0 = -1;
    80005e56:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e5a:	fd043503          	ld	a0,-48(s0)
    80005e5e:	fffff097          	auipc	ra,0xfffff
    80005e62:	514080e7          	jalr	1300(ra) # 80005372 <fdalloc>
    80005e66:	fca42223          	sw	a0,-60(s0)
    80005e6a:	08054b63          	bltz	a0,80005f00 <sys_pipe+0xe2>
    80005e6e:	fc843503          	ld	a0,-56(s0)
    80005e72:	fffff097          	auipc	ra,0xfffff
    80005e76:	500080e7          	jalr	1280(ra) # 80005372 <fdalloc>
    80005e7a:	fca42023          	sw	a0,-64(s0)
    80005e7e:	06054863          	bltz	a0,80005eee <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e82:	4691                	li	a3,4
    80005e84:	fc440613          	addi	a2,s0,-60
    80005e88:	fd843583          	ld	a1,-40(s0)
    80005e8c:	68a8                	ld	a0,80(s1)
    80005e8e:	ffffc097          	auipc	ra,0xffffc
    80005e92:	828080e7          	jalr	-2008(ra) # 800016b6 <copyout>
    80005e96:	02054063          	bltz	a0,80005eb6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e9a:	4691                	li	a3,4
    80005e9c:	fc040613          	addi	a2,s0,-64
    80005ea0:	fd843583          	ld	a1,-40(s0)
    80005ea4:	0591                	addi	a1,a1,4
    80005ea6:	68a8                	ld	a0,80(s1)
    80005ea8:	ffffc097          	auipc	ra,0xffffc
    80005eac:	80e080e7          	jalr	-2034(ra) # 800016b6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005eb0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005eb2:	06055463          	bgez	a0,80005f1a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005eb6:	fc442783          	lw	a5,-60(s0)
    80005eba:	07e9                	addi	a5,a5,26
    80005ebc:	078e                	slli	a5,a5,0x3
    80005ebe:	97a6                	add	a5,a5,s1
    80005ec0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ec4:	fc042783          	lw	a5,-64(s0)
    80005ec8:	07e9                	addi	a5,a5,26
    80005eca:	078e                	slli	a5,a5,0x3
    80005ecc:	94be                	add	s1,s1,a5
    80005ece:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005ed2:	fd043503          	ld	a0,-48(s0)
    80005ed6:	fffff097          	auipc	ra,0xfffff
    80005eda:	9ec080e7          	jalr	-1556(ra) # 800048c2 <fileclose>
    fileclose(wf);
    80005ede:	fc843503          	ld	a0,-56(s0)
    80005ee2:	fffff097          	auipc	ra,0xfffff
    80005ee6:	9e0080e7          	jalr	-1568(ra) # 800048c2 <fileclose>
    return -1;
    80005eea:	57fd                	li	a5,-1
    80005eec:	a03d                	j	80005f1a <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005eee:	fc442783          	lw	a5,-60(s0)
    80005ef2:	0007c763          	bltz	a5,80005f00 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005ef6:	07e9                	addi	a5,a5,26
    80005ef8:	078e                	slli	a5,a5,0x3
    80005efa:	97a6                	add	a5,a5,s1
    80005efc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005f00:	fd043503          	ld	a0,-48(s0)
    80005f04:	fffff097          	auipc	ra,0xfffff
    80005f08:	9be080e7          	jalr	-1602(ra) # 800048c2 <fileclose>
    fileclose(wf);
    80005f0c:	fc843503          	ld	a0,-56(s0)
    80005f10:	fffff097          	auipc	ra,0xfffff
    80005f14:	9b2080e7          	jalr	-1614(ra) # 800048c2 <fileclose>
    return -1;
    80005f18:	57fd                	li	a5,-1
}
    80005f1a:	853e                	mv	a0,a5
    80005f1c:	70e2                	ld	ra,56(sp)
    80005f1e:	7442                	ld	s0,48(sp)
    80005f20:	74a2                	ld	s1,40(sp)
    80005f22:	6121                	addi	sp,sp,64
    80005f24:	8082                	ret
	...

0000000080005f30 <kernelvec>:
    80005f30:	7111                	addi	sp,sp,-256
    80005f32:	e006                	sd	ra,0(sp)
    80005f34:	e40a                	sd	sp,8(sp)
    80005f36:	e80e                	sd	gp,16(sp)
    80005f38:	ec12                	sd	tp,24(sp)
    80005f3a:	f016                	sd	t0,32(sp)
    80005f3c:	f41a                	sd	t1,40(sp)
    80005f3e:	f81e                	sd	t2,48(sp)
    80005f40:	fc22                	sd	s0,56(sp)
    80005f42:	e0a6                	sd	s1,64(sp)
    80005f44:	e4aa                	sd	a0,72(sp)
    80005f46:	e8ae                	sd	a1,80(sp)
    80005f48:	ecb2                	sd	a2,88(sp)
    80005f4a:	f0b6                	sd	a3,96(sp)
    80005f4c:	f4ba                	sd	a4,104(sp)
    80005f4e:	f8be                	sd	a5,112(sp)
    80005f50:	fcc2                	sd	a6,120(sp)
    80005f52:	e146                	sd	a7,128(sp)
    80005f54:	e54a                	sd	s2,136(sp)
    80005f56:	e94e                	sd	s3,144(sp)
    80005f58:	ed52                	sd	s4,152(sp)
    80005f5a:	f156                	sd	s5,160(sp)
    80005f5c:	f55a                	sd	s6,168(sp)
    80005f5e:	f95e                	sd	s7,176(sp)
    80005f60:	fd62                	sd	s8,184(sp)
    80005f62:	e1e6                	sd	s9,192(sp)
    80005f64:	e5ea                	sd	s10,200(sp)
    80005f66:	e9ee                	sd	s11,208(sp)
    80005f68:	edf2                	sd	t3,216(sp)
    80005f6a:	f1f6                	sd	t4,224(sp)
    80005f6c:	f5fa                	sd	t5,232(sp)
    80005f6e:	f9fe                	sd	t6,240(sp)
    80005f70:	adffc0ef          	jal	ra,80002a4e <kerneltrap>
    80005f74:	6082                	ld	ra,0(sp)
    80005f76:	6122                	ld	sp,8(sp)
    80005f78:	61c2                	ld	gp,16(sp)
    80005f7a:	7282                	ld	t0,32(sp)
    80005f7c:	7322                	ld	t1,40(sp)
    80005f7e:	73c2                	ld	t2,48(sp)
    80005f80:	7462                	ld	s0,56(sp)
    80005f82:	6486                	ld	s1,64(sp)
    80005f84:	6526                	ld	a0,72(sp)
    80005f86:	65c6                	ld	a1,80(sp)
    80005f88:	6666                	ld	a2,88(sp)
    80005f8a:	7686                	ld	a3,96(sp)
    80005f8c:	7726                	ld	a4,104(sp)
    80005f8e:	77c6                	ld	a5,112(sp)
    80005f90:	7866                	ld	a6,120(sp)
    80005f92:	688a                	ld	a7,128(sp)
    80005f94:	692a                	ld	s2,136(sp)
    80005f96:	69ca                	ld	s3,144(sp)
    80005f98:	6a6a                	ld	s4,152(sp)
    80005f9a:	7a8a                	ld	s5,160(sp)
    80005f9c:	7b2a                	ld	s6,168(sp)
    80005f9e:	7bca                	ld	s7,176(sp)
    80005fa0:	7c6a                	ld	s8,184(sp)
    80005fa2:	6c8e                	ld	s9,192(sp)
    80005fa4:	6d2e                	ld	s10,200(sp)
    80005fa6:	6dce                	ld	s11,208(sp)
    80005fa8:	6e6e                	ld	t3,216(sp)
    80005faa:	7e8e                	ld	t4,224(sp)
    80005fac:	7f2e                	ld	t5,232(sp)
    80005fae:	7fce                	ld	t6,240(sp)
    80005fb0:	6111                	addi	sp,sp,256
    80005fb2:	10200073          	sret
    80005fb6:	00000013          	nop
    80005fba:	00000013          	nop
    80005fbe:	0001                	nop

0000000080005fc0 <timervec>:
    80005fc0:	34051573          	csrrw	a0,mscratch,a0
    80005fc4:	e10c                	sd	a1,0(a0)
    80005fc6:	e510                	sd	a2,8(a0)
    80005fc8:	e914                	sd	a3,16(a0)
    80005fca:	6d0c                	ld	a1,24(a0)
    80005fcc:	7110                	ld	a2,32(a0)
    80005fce:	6194                	ld	a3,0(a1)
    80005fd0:	96b2                	add	a3,a3,a2
    80005fd2:	e194                	sd	a3,0(a1)
    80005fd4:	4589                	li	a1,2
    80005fd6:	14459073          	csrw	sip,a1
    80005fda:	6914                	ld	a3,16(a0)
    80005fdc:	6510                	ld	a2,8(a0)
    80005fde:	610c                	ld	a1,0(a0)
    80005fe0:	34051573          	csrrw	a0,mscratch,a0
    80005fe4:	30200073          	mret
	...

0000000080005fea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005fea:	1141                	addi	sp,sp,-16
    80005fec:	e422                	sd	s0,8(sp)
    80005fee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005ff0:	0c0007b7          	lui	a5,0xc000
    80005ff4:	4705                	li	a4,1
    80005ff6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005ff8:	c3d8                	sw	a4,4(a5)
}
    80005ffa:	6422                	ld	s0,8(sp)
    80005ffc:	0141                	addi	sp,sp,16
    80005ffe:	8082                	ret

0000000080006000 <plicinithart>:

void
plicinithart(void)
{
    80006000:	1141                	addi	sp,sp,-16
    80006002:	e406                	sd	ra,8(sp)
    80006004:	e022                	sd	s0,0(sp)
    80006006:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006008:	ffffc097          	auipc	ra,0xffffc
    8000600c:	aa6080e7          	jalr	-1370(ra) # 80001aae <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006010:	0085171b          	slliw	a4,a0,0x8
    80006014:	0c0027b7          	lui	a5,0xc002
    80006018:	97ba                	add	a5,a5,a4
    8000601a:	40200713          	li	a4,1026
    8000601e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006022:	00d5151b          	slliw	a0,a0,0xd
    80006026:	0c2017b7          	lui	a5,0xc201
    8000602a:	97aa                	add	a5,a5,a0
    8000602c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006030:	60a2                	ld	ra,8(sp)
    80006032:	6402                	ld	s0,0(sp)
    80006034:	0141                	addi	sp,sp,16
    80006036:	8082                	ret

0000000080006038 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006038:	1141                	addi	sp,sp,-16
    8000603a:	e406                	sd	ra,8(sp)
    8000603c:	e022                	sd	s0,0(sp)
    8000603e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006040:	ffffc097          	auipc	ra,0xffffc
    80006044:	a6e080e7          	jalr	-1426(ra) # 80001aae <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006048:	00d5151b          	slliw	a0,a0,0xd
    8000604c:	0c2017b7          	lui	a5,0xc201
    80006050:	97aa                	add	a5,a5,a0
  return irq;
}
    80006052:	43c8                	lw	a0,4(a5)
    80006054:	60a2                	ld	ra,8(sp)
    80006056:	6402                	ld	s0,0(sp)
    80006058:	0141                	addi	sp,sp,16
    8000605a:	8082                	ret

000000008000605c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000605c:	1101                	addi	sp,sp,-32
    8000605e:	ec06                	sd	ra,24(sp)
    80006060:	e822                	sd	s0,16(sp)
    80006062:	e426                	sd	s1,8(sp)
    80006064:	1000                	addi	s0,sp,32
    80006066:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006068:	ffffc097          	auipc	ra,0xffffc
    8000606c:	a46080e7          	jalr	-1466(ra) # 80001aae <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006070:	00d5151b          	slliw	a0,a0,0xd
    80006074:	0c2017b7          	lui	a5,0xc201
    80006078:	97aa                	add	a5,a5,a0
    8000607a:	c3c4                	sw	s1,4(a5)
}
    8000607c:	60e2                	ld	ra,24(sp)
    8000607e:	6442                	ld	s0,16(sp)
    80006080:	64a2                	ld	s1,8(sp)
    80006082:	6105                	addi	sp,sp,32
    80006084:	8082                	ret

0000000080006086 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006086:	1141                	addi	sp,sp,-16
    80006088:	e406                	sd	ra,8(sp)
    8000608a:	e022                	sd	s0,0(sp)
    8000608c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000608e:	479d                	li	a5,7
    80006090:	04a7cc63          	blt	a5,a0,800060e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006094:	0001c797          	auipc	a5,0x1c
    80006098:	bcc78793          	addi	a5,a5,-1076 # 80021c60 <disk>
    8000609c:	97aa                	add	a5,a5,a0
    8000609e:	0187c783          	lbu	a5,24(a5)
    800060a2:	ebb9                	bnez	a5,800060f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800060a4:	00451693          	slli	a3,a0,0x4
    800060a8:	0001c797          	auipc	a5,0x1c
    800060ac:	bb878793          	addi	a5,a5,-1096 # 80021c60 <disk>
    800060b0:	6398                	ld	a4,0(a5)
    800060b2:	9736                	add	a4,a4,a3
    800060b4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800060b8:	6398                	ld	a4,0(a5)
    800060ba:	9736                	add	a4,a4,a3
    800060bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800060c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800060c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800060c8:	97aa                	add	a5,a5,a0
    800060ca:	4705                	li	a4,1
    800060cc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800060d0:	0001c517          	auipc	a0,0x1c
    800060d4:	ba850513          	addi	a0,a0,-1112 # 80021c78 <disk+0x18>
    800060d8:	ffffc097          	auipc	ra,0xffffc
    800060dc:	10e080e7          	jalr	270(ra) # 800021e6 <wakeup>
}
    800060e0:	60a2                	ld	ra,8(sp)
    800060e2:	6402                	ld	s0,0(sp)
    800060e4:	0141                	addi	sp,sp,16
    800060e6:	8082                	ret
    panic("free_desc 1");
    800060e8:	00002517          	auipc	a0,0x2
    800060ec:	69850513          	addi	a0,a0,1688 # 80008780 <syscalls+0x300>
    800060f0:	ffffa097          	auipc	ra,0xffffa
    800060f4:	450080e7          	jalr	1104(ra) # 80000540 <panic>
    panic("free_desc 2");
    800060f8:	00002517          	auipc	a0,0x2
    800060fc:	69850513          	addi	a0,a0,1688 # 80008790 <syscalls+0x310>
    80006100:	ffffa097          	auipc	ra,0xffffa
    80006104:	440080e7          	jalr	1088(ra) # 80000540 <panic>

0000000080006108 <virtio_disk_init>:
{
    80006108:	1101                	addi	sp,sp,-32
    8000610a:	ec06                	sd	ra,24(sp)
    8000610c:	e822                	sd	s0,16(sp)
    8000610e:	e426                	sd	s1,8(sp)
    80006110:	e04a                	sd	s2,0(sp)
    80006112:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006114:	00002597          	auipc	a1,0x2
    80006118:	68c58593          	addi	a1,a1,1676 # 800087a0 <syscalls+0x320>
    8000611c:	0001c517          	auipc	a0,0x1c
    80006120:	c6c50513          	addi	a0,a0,-916 # 80021d88 <disk+0x128>
    80006124:	ffffb097          	auipc	ra,0xffffb
    80006128:	a6c080e7          	jalr	-1428(ra) # 80000b90 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000612c:	100017b7          	lui	a5,0x10001
    80006130:	4398                	lw	a4,0(a5)
    80006132:	2701                	sext.w	a4,a4
    80006134:	747277b7          	lui	a5,0x74727
    80006138:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000613c:	14f71b63          	bne	a4,a5,80006292 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006140:	100017b7          	lui	a5,0x10001
    80006144:	43dc                	lw	a5,4(a5)
    80006146:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006148:	4709                	li	a4,2
    8000614a:	14e79463          	bne	a5,a4,80006292 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000614e:	100017b7          	lui	a5,0x10001
    80006152:	479c                	lw	a5,8(a5)
    80006154:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006156:	12e79e63          	bne	a5,a4,80006292 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000615a:	100017b7          	lui	a5,0x10001
    8000615e:	47d8                	lw	a4,12(a5)
    80006160:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006162:	554d47b7          	lui	a5,0x554d4
    80006166:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000616a:	12f71463          	bne	a4,a5,80006292 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000616e:	100017b7          	lui	a5,0x10001
    80006172:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006176:	4705                	li	a4,1
    80006178:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000617a:	470d                	li	a4,3
    8000617c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000617e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006180:	c7ffe6b7          	lui	a3,0xc7ffe
    80006184:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9bf>
    80006188:	8f75                	and	a4,a4,a3
    8000618a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000618c:	472d                	li	a4,11
    8000618e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006190:	5bbc                	lw	a5,112(a5)
    80006192:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006196:	8ba1                	andi	a5,a5,8
    80006198:	10078563          	beqz	a5,800062a2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000619c:	100017b7          	lui	a5,0x10001
    800061a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800061a4:	43fc                	lw	a5,68(a5)
    800061a6:	2781                	sext.w	a5,a5
    800061a8:	10079563          	bnez	a5,800062b2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800061ac:	100017b7          	lui	a5,0x10001
    800061b0:	5bdc                	lw	a5,52(a5)
    800061b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800061b4:	10078763          	beqz	a5,800062c2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800061b8:	471d                	li	a4,7
    800061ba:	10f77c63          	bgeu	a4,a5,800062d2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	928080e7          	jalr	-1752(ra) # 80000ae6 <kalloc>
    800061c6:	0001c497          	auipc	s1,0x1c
    800061ca:	a9a48493          	addi	s1,s1,-1382 # 80021c60 <disk>
    800061ce:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800061d0:	ffffb097          	auipc	ra,0xffffb
    800061d4:	916080e7          	jalr	-1770(ra) # 80000ae6 <kalloc>
    800061d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800061da:	ffffb097          	auipc	ra,0xffffb
    800061de:	90c080e7          	jalr	-1780(ra) # 80000ae6 <kalloc>
    800061e2:	87aa                	mv	a5,a0
    800061e4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800061e6:	6088                	ld	a0,0(s1)
    800061e8:	cd6d                	beqz	a0,800062e2 <virtio_disk_init+0x1da>
    800061ea:	0001c717          	auipc	a4,0x1c
    800061ee:	a7e73703          	ld	a4,-1410(a4) # 80021c68 <disk+0x8>
    800061f2:	cb65                	beqz	a4,800062e2 <virtio_disk_init+0x1da>
    800061f4:	c7fd                	beqz	a5,800062e2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800061f6:	6605                	lui	a2,0x1
    800061f8:	4581                	li	a1,0
    800061fa:	ffffb097          	auipc	ra,0xffffb
    800061fe:	b22080e7          	jalr	-1246(ra) # 80000d1c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006202:	0001c497          	auipc	s1,0x1c
    80006206:	a5e48493          	addi	s1,s1,-1442 # 80021c60 <disk>
    8000620a:	6605                	lui	a2,0x1
    8000620c:	4581                	li	a1,0
    8000620e:	6488                	ld	a0,8(s1)
    80006210:	ffffb097          	auipc	ra,0xffffb
    80006214:	b0c080e7          	jalr	-1268(ra) # 80000d1c <memset>
  memset(disk.used, 0, PGSIZE);
    80006218:	6605                	lui	a2,0x1
    8000621a:	4581                	li	a1,0
    8000621c:	6888                	ld	a0,16(s1)
    8000621e:	ffffb097          	auipc	ra,0xffffb
    80006222:	afe080e7          	jalr	-1282(ra) # 80000d1c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006226:	100017b7          	lui	a5,0x10001
    8000622a:	4721                	li	a4,8
    8000622c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000622e:	4098                	lw	a4,0(s1)
    80006230:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006234:	40d8                	lw	a4,4(s1)
    80006236:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000623a:	6498                	ld	a4,8(s1)
    8000623c:	0007069b          	sext.w	a3,a4
    80006240:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006244:	9701                	srai	a4,a4,0x20
    80006246:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000624a:	6898                	ld	a4,16(s1)
    8000624c:	0007069b          	sext.w	a3,a4
    80006250:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006254:	9701                	srai	a4,a4,0x20
    80006256:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000625a:	4705                	li	a4,1
    8000625c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000625e:	00e48c23          	sb	a4,24(s1)
    80006262:	00e48ca3          	sb	a4,25(s1)
    80006266:	00e48d23          	sb	a4,26(s1)
    8000626a:	00e48da3          	sb	a4,27(s1)
    8000626e:	00e48e23          	sb	a4,28(s1)
    80006272:	00e48ea3          	sb	a4,29(s1)
    80006276:	00e48f23          	sb	a4,30(s1)
    8000627a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000627e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006282:	0727a823          	sw	s2,112(a5)
}
    80006286:	60e2                	ld	ra,24(sp)
    80006288:	6442                	ld	s0,16(sp)
    8000628a:	64a2                	ld	s1,8(sp)
    8000628c:	6902                	ld	s2,0(sp)
    8000628e:	6105                	addi	sp,sp,32
    80006290:	8082                	ret
    panic("could not find virtio disk");
    80006292:	00002517          	auipc	a0,0x2
    80006296:	51e50513          	addi	a0,a0,1310 # 800087b0 <syscalls+0x330>
    8000629a:	ffffa097          	auipc	ra,0xffffa
    8000629e:	2a6080e7          	jalr	678(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    800062a2:	00002517          	auipc	a0,0x2
    800062a6:	52e50513          	addi	a0,a0,1326 # 800087d0 <syscalls+0x350>
    800062aa:	ffffa097          	auipc	ra,0xffffa
    800062ae:	296080e7          	jalr	662(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    800062b2:	00002517          	auipc	a0,0x2
    800062b6:	53e50513          	addi	a0,a0,1342 # 800087f0 <syscalls+0x370>
    800062ba:	ffffa097          	auipc	ra,0xffffa
    800062be:	286080e7          	jalr	646(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    800062c2:	00002517          	auipc	a0,0x2
    800062c6:	54e50513          	addi	a0,a0,1358 # 80008810 <syscalls+0x390>
    800062ca:	ffffa097          	auipc	ra,0xffffa
    800062ce:	276080e7          	jalr	630(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    800062d2:	00002517          	auipc	a0,0x2
    800062d6:	55e50513          	addi	a0,a0,1374 # 80008830 <syscalls+0x3b0>
    800062da:	ffffa097          	auipc	ra,0xffffa
    800062de:	266080e7          	jalr	614(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    800062e2:	00002517          	auipc	a0,0x2
    800062e6:	56e50513          	addi	a0,a0,1390 # 80008850 <syscalls+0x3d0>
    800062ea:	ffffa097          	auipc	ra,0xffffa
    800062ee:	256080e7          	jalr	598(ra) # 80000540 <panic>

00000000800062f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800062f2:	7119                	addi	sp,sp,-128
    800062f4:	fc86                	sd	ra,120(sp)
    800062f6:	f8a2                	sd	s0,112(sp)
    800062f8:	f4a6                	sd	s1,104(sp)
    800062fa:	f0ca                	sd	s2,96(sp)
    800062fc:	ecce                	sd	s3,88(sp)
    800062fe:	e8d2                	sd	s4,80(sp)
    80006300:	e4d6                	sd	s5,72(sp)
    80006302:	e0da                	sd	s6,64(sp)
    80006304:	fc5e                	sd	s7,56(sp)
    80006306:	f862                	sd	s8,48(sp)
    80006308:	f466                	sd	s9,40(sp)
    8000630a:	f06a                	sd	s10,32(sp)
    8000630c:	ec6e                	sd	s11,24(sp)
    8000630e:	0100                	addi	s0,sp,128
    80006310:	8aaa                	mv	s5,a0
    80006312:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006314:	00c52d03          	lw	s10,12(a0)
    80006318:	001d1d1b          	slliw	s10,s10,0x1
    8000631c:	1d02                	slli	s10,s10,0x20
    8000631e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006322:	0001c517          	auipc	a0,0x1c
    80006326:	a6650513          	addi	a0,a0,-1434 # 80021d88 <disk+0x128>
    8000632a:	ffffb097          	auipc	ra,0xffffb
    8000632e:	8f6080e7          	jalr	-1802(ra) # 80000c20 <acquire>
  for(int i = 0; i < 3; i++){
    80006332:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006334:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006336:	0001cb97          	auipc	s7,0x1c
    8000633a:	92ab8b93          	addi	s7,s7,-1750 # 80021c60 <disk>
  for(int i = 0; i < 3; i++){
    8000633e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006340:	0001cc97          	auipc	s9,0x1c
    80006344:	a48c8c93          	addi	s9,s9,-1464 # 80021d88 <disk+0x128>
    80006348:	a08d                	j	800063aa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000634a:	00fb8733          	add	a4,s7,a5
    8000634e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006352:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006354:	0207c563          	bltz	a5,8000637e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80006358:	2905                	addiw	s2,s2,1
    8000635a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000635c:	05690c63          	beq	s2,s6,800063b4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006360:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006362:	0001c717          	auipc	a4,0x1c
    80006366:	8fe70713          	addi	a4,a4,-1794 # 80021c60 <disk>
    8000636a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000636c:	01874683          	lbu	a3,24(a4)
    80006370:	fee9                	bnez	a3,8000634a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006372:	2785                	addiw	a5,a5,1
    80006374:	0705                	addi	a4,a4,1
    80006376:	fe979be3          	bne	a5,s1,8000636c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000637a:	57fd                	li	a5,-1
    8000637c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000637e:	01205d63          	blez	s2,80006398 <virtio_disk_rw+0xa6>
    80006382:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006384:	000a2503          	lw	a0,0(s4)
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	cfe080e7          	jalr	-770(ra) # 80006086 <free_desc>
      for(int j = 0; j < i; j++)
    80006390:	2d85                	addiw	s11,s11,1
    80006392:	0a11                	addi	s4,s4,4
    80006394:	ff2d98e3          	bne	s11,s2,80006384 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006398:	85e6                	mv	a1,s9
    8000639a:	0001c517          	auipc	a0,0x1c
    8000639e:	8de50513          	addi	a0,a0,-1826 # 80021c78 <disk+0x18>
    800063a2:	ffffc097          	auipc	ra,0xffffc
    800063a6:	de0080e7          	jalr	-544(ra) # 80002182 <sleep>
  for(int i = 0; i < 3; i++){
    800063aa:	f8040a13          	addi	s4,s0,-128
{
    800063ae:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800063b0:	894e                	mv	s2,s3
    800063b2:	b77d                	j	80006360 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800063b4:	f8042503          	lw	a0,-128(s0)
    800063b8:	00a50713          	addi	a4,a0,10
    800063bc:	0712                	slli	a4,a4,0x4

  if(write)
    800063be:	0001c797          	auipc	a5,0x1c
    800063c2:	8a278793          	addi	a5,a5,-1886 # 80021c60 <disk>
    800063c6:	00e786b3          	add	a3,a5,a4
    800063ca:	01803633          	snez	a2,s8
    800063ce:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800063d0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800063d4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800063d8:	f6070613          	addi	a2,a4,-160
    800063dc:	6394                	ld	a3,0(a5)
    800063de:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800063e0:	00870593          	addi	a1,a4,8
    800063e4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800063e6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800063e8:	0007b803          	ld	a6,0(a5)
    800063ec:	9642                	add	a2,a2,a6
    800063ee:	46c1                	li	a3,16
    800063f0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800063f2:	4585                	li	a1,1
    800063f4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800063f8:	f8442683          	lw	a3,-124(s0)
    800063fc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006400:	0692                	slli	a3,a3,0x4
    80006402:	9836                	add	a6,a6,a3
    80006404:	058a8613          	addi	a2,s5,88
    80006408:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000640c:	0007b803          	ld	a6,0(a5)
    80006410:	96c2                	add	a3,a3,a6
    80006412:	40000613          	li	a2,1024
    80006416:	c690                	sw	a2,8(a3)
  if(write)
    80006418:	001c3613          	seqz	a2,s8
    8000641c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006420:	00166613          	ori	a2,a2,1
    80006424:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006428:	f8842603          	lw	a2,-120(s0)
    8000642c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006430:	00250693          	addi	a3,a0,2
    80006434:	0692                	slli	a3,a3,0x4
    80006436:	96be                	add	a3,a3,a5
    80006438:	58fd                	li	a7,-1
    8000643a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000643e:	0612                	slli	a2,a2,0x4
    80006440:	9832                	add	a6,a6,a2
    80006442:	f9070713          	addi	a4,a4,-112
    80006446:	973e                	add	a4,a4,a5
    80006448:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000644c:	6398                	ld	a4,0(a5)
    8000644e:	9732                	add	a4,a4,a2
    80006450:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006452:	4609                	li	a2,2
    80006454:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80006458:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000645c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006460:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006464:	6794                	ld	a3,8(a5)
    80006466:	0026d703          	lhu	a4,2(a3)
    8000646a:	8b1d                	andi	a4,a4,7
    8000646c:	0706                	slli	a4,a4,0x1
    8000646e:	96ba                	add	a3,a3,a4
    80006470:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006474:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006478:	6798                	ld	a4,8(a5)
    8000647a:	00275783          	lhu	a5,2(a4)
    8000647e:	2785                	addiw	a5,a5,1
    80006480:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006484:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006488:	100017b7          	lui	a5,0x10001
    8000648c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006490:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80006494:	0001c917          	auipc	s2,0x1c
    80006498:	8f490913          	addi	s2,s2,-1804 # 80021d88 <disk+0x128>
  while(b->disk == 1) {
    8000649c:	4485                	li	s1,1
    8000649e:	00b79c63          	bne	a5,a1,800064b6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800064a2:	85ca                	mv	a1,s2
    800064a4:	8556                	mv	a0,s5
    800064a6:	ffffc097          	auipc	ra,0xffffc
    800064aa:	cdc080e7          	jalr	-804(ra) # 80002182 <sleep>
  while(b->disk == 1) {
    800064ae:	004aa783          	lw	a5,4(s5)
    800064b2:	fe9788e3          	beq	a5,s1,800064a2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800064b6:	f8042903          	lw	s2,-128(s0)
    800064ba:	00290713          	addi	a4,s2,2
    800064be:	0712                	slli	a4,a4,0x4
    800064c0:	0001b797          	auipc	a5,0x1b
    800064c4:	7a078793          	addi	a5,a5,1952 # 80021c60 <disk>
    800064c8:	97ba                	add	a5,a5,a4
    800064ca:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800064ce:	0001b997          	auipc	s3,0x1b
    800064d2:	79298993          	addi	s3,s3,1938 # 80021c60 <disk>
    800064d6:	00491713          	slli	a4,s2,0x4
    800064da:	0009b783          	ld	a5,0(s3)
    800064de:	97ba                	add	a5,a5,a4
    800064e0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800064e4:	854a                	mv	a0,s2
    800064e6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800064ea:	00000097          	auipc	ra,0x0
    800064ee:	b9c080e7          	jalr	-1124(ra) # 80006086 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800064f2:	8885                	andi	s1,s1,1
    800064f4:	f0ed                	bnez	s1,800064d6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800064f6:	0001c517          	auipc	a0,0x1c
    800064fa:	89250513          	addi	a0,a0,-1902 # 80021d88 <disk+0x128>
    800064fe:	ffffa097          	auipc	ra,0xffffa
    80006502:	7d6080e7          	jalr	2006(ra) # 80000cd4 <release>
}
    80006506:	70e6                	ld	ra,120(sp)
    80006508:	7446                	ld	s0,112(sp)
    8000650a:	74a6                	ld	s1,104(sp)
    8000650c:	7906                	ld	s2,96(sp)
    8000650e:	69e6                	ld	s3,88(sp)
    80006510:	6a46                	ld	s4,80(sp)
    80006512:	6aa6                	ld	s5,72(sp)
    80006514:	6b06                	ld	s6,64(sp)
    80006516:	7be2                	ld	s7,56(sp)
    80006518:	7c42                	ld	s8,48(sp)
    8000651a:	7ca2                	ld	s9,40(sp)
    8000651c:	7d02                	ld	s10,32(sp)
    8000651e:	6de2                	ld	s11,24(sp)
    80006520:	6109                	addi	sp,sp,128
    80006522:	8082                	ret

0000000080006524 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006524:	1101                	addi	sp,sp,-32
    80006526:	ec06                	sd	ra,24(sp)
    80006528:	e822                	sd	s0,16(sp)
    8000652a:	e426                	sd	s1,8(sp)
    8000652c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000652e:	0001b497          	auipc	s1,0x1b
    80006532:	73248493          	addi	s1,s1,1842 # 80021c60 <disk>
    80006536:	0001c517          	auipc	a0,0x1c
    8000653a:	85250513          	addi	a0,a0,-1966 # 80021d88 <disk+0x128>
    8000653e:	ffffa097          	auipc	ra,0xffffa
    80006542:	6e2080e7          	jalr	1762(ra) # 80000c20 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006546:	10001737          	lui	a4,0x10001
    8000654a:	533c                	lw	a5,96(a4)
    8000654c:	8b8d                	andi	a5,a5,3
    8000654e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006550:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006554:	689c                	ld	a5,16(s1)
    80006556:	0204d703          	lhu	a4,32(s1)
    8000655a:	0027d783          	lhu	a5,2(a5)
    8000655e:	04f70863          	beq	a4,a5,800065ae <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006562:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006566:	6898                	ld	a4,16(s1)
    80006568:	0204d783          	lhu	a5,32(s1)
    8000656c:	8b9d                	andi	a5,a5,7
    8000656e:	078e                	slli	a5,a5,0x3
    80006570:	97ba                	add	a5,a5,a4
    80006572:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006574:	00278713          	addi	a4,a5,2
    80006578:	0712                	slli	a4,a4,0x4
    8000657a:	9726                	add	a4,a4,s1
    8000657c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006580:	e721                	bnez	a4,800065c8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006582:	0789                	addi	a5,a5,2
    80006584:	0792                	slli	a5,a5,0x4
    80006586:	97a6                	add	a5,a5,s1
    80006588:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000658a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000658e:	ffffc097          	auipc	ra,0xffffc
    80006592:	c58080e7          	jalr	-936(ra) # 800021e6 <wakeup>

    disk.used_idx += 1;
    80006596:	0204d783          	lhu	a5,32(s1)
    8000659a:	2785                	addiw	a5,a5,1
    8000659c:	17c2                	slli	a5,a5,0x30
    8000659e:	93c1                	srli	a5,a5,0x30
    800065a0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800065a4:	6898                	ld	a4,16(s1)
    800065a6:	00275703          	lhu	a4,2(a4)
    800065aa:	faf71ce3          	bne	a4,a5,80006562 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800065ae:	0001b517          	auipc	a0,0x1b
    800065b2:	7da50513          	addi	a0,a0,2010 # 80021d88 <disk+0x128>
    800065b6:	ffffa097          	auipc	ra,0xffffa
    800065ba:	71e080e7          	jalr	1822(ra) # 80000cd4 <release>
}
    800065be:	60e2                	ld	ra,24(sp)
    800065c0:	6442                	ld	s0,16(sp)
    800065c2:	64a2                	ld	s1,8(sp)
    800065c4:	6105                	addi	sp,sp,32
    800065c6:	8082                	ret
      panic("virtio_disk_intr status");
    800065c8:	00002517          	auipc	a0,0x2
    800065cc:	2a050513          	addi	a0,a0,672 # 80008868 <syscalls+0x3e8>
    800065d0:	ffffa097          	auipc	ra,0xffffa
    800065d4:	f70080e7          	jalr	-144(ra) # 80000540 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
