
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	6dc080e7          	jalr	1756(ra) # 6e4 <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	b6450513          	addi	a0,a0,-1180 # b80 <malloc+0xfa>
  24:	00001097          	auipc	ra,0x1
  28:	9aa080e7          	jalr	-1622(ra) # 9ce <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	616080e7          	jalr	1558(ra) # 644 <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	addi	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	addi	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	684080e7          	jalr	1668(ra) # 6cc <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
  58:	a019                	j	5e <countfree+0x28>
  5a:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  5e:	6505                	lui	a0,0x1
  60:	00000097          	auipc	ra,0x0
  64:	66c080e7          	jalr	1644(ra) # 6cc <sbrk>
  68:	ff2519e3          	bne	a0,s2,5a <countfree+0x24>
  }
  sinfo(&info);
  6c:	fc040513          	addi	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	64c080e7          	jalr	1612(ra) # 6cc <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	640080e7          	jalr	1600(ra) # 6cc <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	addi	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	af250513          	addi	a0,a0,-1294 # b98 <malloc+0x112>
  ae:	00001097          	auipc	ra,0x1
  b2:	920080e7          	jalr	-1760(ra) # 9ce <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	58c080e7          	jalr	1420(ra) # 644 <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	addi	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	addi	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	5e0080e7          	jalr	1504(ra) # 6cc <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	addi	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	5b8080e7          	jalr	1464(ra) # 6cc <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	addi	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	addi	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	a8c50513          	addi	a0,a0,-1396 # bd0 <malloc+0x14a>
 14c:	00001097          	auipc	ra,0x1
 150:	882080e7          	jalr	-1918(ra) # 9ce <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	4ee080e7          	jalr	1262(ra) # 644 <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	aa250513          	addi	a0,a0,-1374 # c00 <malloc+0x17a>
 166:	00001097          	auipc	ra,0x1
 16a:	868080e7          	jalr	-1944(ra) # 9ce <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	4d4080e7          	jalr	1236(ra) # 644 <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	a5850513          	addi	a0,a0,-1448 # bd0 <malloc+0x14a>
 180:	00001097          	auipc	ra,0x1
 184:	84e080e7          	jalr	-1970(ra) # 9ce <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	4ba080e7          	jalr	1210(ra) # 644 <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	a6e50513          	addi	a0,a0,-1426 # c00 <malloc+0x17a>
 19a:	00001097          	auipc	ra,0x1
 19e:	834080e7          	jalr	-1996(ra) # 9ce <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	4a0080e7          	jalr	1184(ra) # 644 <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	a2250513          	addi	a0,a0,-1502 # bd0 <malloc+0x14a>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	818080e7          	jalr	-2024(ra) # 9ce <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	484080e7          	jalr	1156(ra) # 644 <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	addi	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	addi	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	510080e7          	jalr	1296(ra) # 6e4 <sysinfo>
 1dc:	02054163          	bltz	a0,1fe <testcall+0x36>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	00001517          	auipc	a0,0x1
 1e4:	99053503          	ld	a0,-1648(a0) # b70 <malloc+0xea>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	4fc080e7          	jalr	1276(ra) # 6e4 <sysinfo>
 1f0:	57fd                	li	a5,-1
 1f2:	02f51363          	bne	a0,a5,218 <testcall+0x50>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	a1250513          	addi	a0,a0,-1518 # c10 <malloc+0x18a>
 206:	00000097          	auipc	ra,0x0
 20a:	7c8080e7          	jalr	1992(ra) # 9ce <printf>
    exit(1);
 20e:	4505                	li	a0,1
 210:	00000097          	auipc	ra,0x0
 214:	434080e7          	jalr	1076(ra) # 644 <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 218:	00001517          	auipc	a0,0x1
 21c:	a1050513          	addi	a0,a0,-1520 # c28 <malloc+0x1a2>
 220:	00000097          	auipc	ra,0x0
 224:	7ae080e7          	jalr	1966(ra) # 9ce <printf>
    exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	41a080e7          	jalr	1050(ra) # 644 <exit>

0000000000000232 <testproc>:

void testproc() {
 232:	7139                	addi	sp,sp,-64
 234:	fc06                	sd	ra,56(sp)
 236:	f822                	sd	s0,48(sp)
 238:	f426                	sd	s1,40(sp)
 23a:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 23c:	fd040513          	addi	a0,s0,-48
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <sinfo>
  nproc = info.nproc;
 248:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 24c:	00000097          	auipc	ra,0x0
 250:	3f0080e7          	jalr	1008(ra) # 63c <fork>
  if(pid < 0){
 254:	02054c63          	bltz	a0,28c <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 258:	ed21                	bnez	a0,2b0 <testproc+0x7e>
    sinfo(&info);
 25a:	fd040513          	addi	a0,s0,-48
 25e:	00000097          	auipc	ra,0x0
 262:	da2080e7          	jalr	-606(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 266:	fd843583          	ld	a1,-40(s0)
 26a:	00148613          	addi	a2,s1,1
 26e:	02c58c63          	beq	a1,a2,2a6 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 272:	00001517          	auipc	a0,0x1
 276:	a0650513          	addi	a0,a0,-1530 # c78 <malloc+0x1f2>
 27a:	00000097          	auipc	ra,0x0
 27e:	754080e7          	jalr	1876(ra) # 9ce <printf>
      exit(1);
 282:	4505                	li	a0,1
 284:	00000097          	auipc	ra,0x0
 288:	3c0080e7          	jalr	960(ra) # 644 <exit>
    printf("sysinfotest: fork failed\n");
 28c:	00001517          	auipc	a0,0x1
 290:	9cc50513          	addi	a0,a0,-1588 # c58 <malloc+0x1d2>
 294:	00000097          	auipc	ra,0x0
 298:	73a080e7          	jalr	1850(ra) # 9ce <printf>
    exit(1);
 29c:	4505                	li	a0,1
 29e:	00000097          	auipc	ra,0x0
 2a2:	3a6080e7          	jalr	934(ra) # 644 <exit>
    }
    exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	39c080e7          	jalr	924(ra) # 644 <exit>
  }
  wait(&status);
 2b0:	fcc40513          	addi	a0,s0,-52
 2b4:	00000097          	auipc	ra,0x0
 2b8:	398080e7          	jalr	920(ra) # 64c <wait>
  sinfo(&info);
 2bc:	fd040513          	addi	a0,s0,-48
 2c0:	00000097          	auipc	ra,0x0
 2c4:	d40080e7          	jalr	-704(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2c8:	fd843583          	ld	a1,-40(s0)
 2cc:	00959763          	bne	a1,s1,2da <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2d0:	70e2                	ld	ra,56(sp)
 2d2:	7442                	ld	s0,48(sp)
 2d4:	74a2                	ld	s1,40(sp)
 2d6:	6121                	addi	sp,sp,64
 2d8:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2da:	8626                	mv	a2,s1
 2dc:	00001517          	auipc	a0,0x1
 2e0:	99c50513          	addi	a0,a0,-1636 # c78 <malloc+0x1f2>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	6ea080e7          	jalr	1770(ra) # 9ce <printf>
      exit(1);
 2ec:	4505                	li	a0,1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	356080e7          	jalr	854(ra) # 644 <exit>

00000000000002f6 <testbad>:

void testbad() {
 2f6:	1101                	addi	sp,sp,-32
 2f8:	ec06                	sd	ra,24(sp)
 2fa:	e822                	sd	s0,16(sp)
 2fc:	1000                	addi	s0,sp,32
  int pid = fork();
 2fe:	00000097          	auipc	ra,0x0
 302:	33e080e7          	jalr	830(ra) # 63c <fork>
  int xstatus;
  
  if(pid < 0){
 306:	00054c63          	bltz	a0,31e <testbad+0x28>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 30a:	e51d                	bnez	a0,338 <testbad+0x42>
      sinfo(0x0);
 30c:	00000097          	auipc	ra,0x0
 310:	cf4080e7          	jalr	-780(ra) # 0 <sinfo>
      exit(0);
 314:	4501                	li	a0,0
 316:	00000097          	auipc	ra,0x0
 31a:	32e080e7          	jalr	814(ra) # 644 <exit>
    printf("sysinfotest: fork failed\n");
 31e:	00001517          	auipc	a0,0x1
 322:	93a50513          	addi	a0,a0,-1734 # c58 <malloc+0x1d2>
 326:	00000097          	auipc	ra,0x0
 32a:	6a8080e7          	jalr	1704(ra) # 9ce <printf>
    exit(1);
 32e:	4505                	li	a0,1
 330:	00000097          	auipc	ra,0x0
 334:	314080e7          	jalr	788(ra) # 644 <exit>
  }
  wait(&xstatus);
 338:	fec40513          	addi	a0,s0,-20
 33c:	00000097          	auipc	ra,0x0
 340:	310080e7          	jalr	784(ra) # 64c <wait>
  if(xstatus == -1)  // kernel killed child?
 344:	fec42583          	lw	a1,-20(s0)
 348:	57fd                	li	a5,-1
 34a:	02f58063          	beq	a1,a5,36a <testbad+0x74>
    exit(0);
  else {
    printf("sysinfotest: testbad succeeded %d\n", xstatus);
 34e:	00001517          	auipc	a0,0x1
 352:	95a50513          	addi	a0,a0,-1702 # ca8 <malloc+0x222>
 356:	00000097          	auipc	ra,0x0
 35a:	678080e7          	jalr	1656(ra) # 9ce <printf>
    exit(xstatus);
 35e:	fec42503          	lw	a0,-20(s0)
 362:	00000097          	auipc	ra,0x0
 366:	2e2080e7          	jalr	738(ra) # 644 <exit>
    exit(0);
 36a:	4501                	li	a0,0
 36c:	00000097          	auipc	ra,0x0
 370:	2d8080e7          	jalr	728(ra) # 644 <exit>

0000000000000374 <main>:
  }
}

int
main(int argc, char *argv[])
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  printf("sysinfotest: start\n");
 37c:	00001517          	auipc	a0,0x1
 380:	95450513          	addi	a0,a0,-1708 # cd0 <malloc+0x24a>
 384:	00000097          	auipc	ra,0x0
 388:	64a080e7          	jalr	1610(ra) # 9ce <printf>
  testcall();
 38c:	00000097          	auipc	ra,0x0
 390:	e3c080e7          	jalr	-452(ra) # 1c8 <testcall>
  testmem();
 394:	00000097          	auipc	ra,0x0
 398:	d2c080e7          	jalr	-724(ra) # c0 <testmem>
  testproc();
 39c:	00000097          	auipc	ra,0x0
 3a0:	e96080e7          	jalr	-362(ra) # 232 <testproc>
  printf("sysinfotest: OK\n");
 3a4:	00001517          	auipc	a0,0x1
 3a8:	94450513          	addi	a0,a0,-1724 # ce8 <malloc+0x262>
 3ac:	00000097          	auipc	ra,0x0
 3b0:	622080e7          	jalr	1570(ra) # 9ce <printf>
  exit(0);
 3b4:	4501                	li	a0,0
 3b6:	00000097          	auipc	ra,0x0
 3ba:	28e080e7          	jalr	654(ra) # 644 <exit>

00000000000003be <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e406                	sd	ra,8(sp)
 3c2:	e022                	sd	s0,0(sp)
 3c4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3c6:	00000097          	auipc	ra,0x0
 3ca:	fae080e7          	jalr	-82(ra) # 374 <main>
  exit(0);
 3ce:	4501                	li	a0,0
 3d0:	00000097          	auipc	ra,0x0
 3d4:	274080e7          	jalr	628(ra) # 644 <exit>

00000000000003d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3de:	87aa                	mv	a5,a0
 3e0:	0585                	addi	a1,a1,1 # fffffffffffff001 <base+0xffffffffffffdff1>
 3e2:	0785                	addi	a5,a5,1
 3e4:	fff5c703          	lbu	a4,-1(a1)
 3e8:	fee78fa3          	sb	a4,-1(a5)
 3ec:	fb75                	bnez	a4,3e0 <strcpy+0x8>
    ;
  return os;
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cb91                	beqz	a5,412 <strcmp+0x1e>
 400:	0005c703          	lbu	a4,0(a1)
 404:	00f71763          	bne	a4,a5,412 <strcmp+0x1e>
    p++, q++;
 408:	0505                	addi	a0,a0,1
 40a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 40c:	00054783          	lbu	a5,0(a0)
 410:	fbe5                	bnez	a5,400 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 412:	0005c503          	lbu	a0,0(a1)
}
 416:	40a7853b          	subw	a0,a5,a0
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <strlen>:

uint
strlen(const char *s)
{
 420:	1141                	addi	sp,sp,-16
 422:	e422                	sd	s0,8(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 426:	00054783          	lbu	a5,0(a0)
 42a:	cf91                	beqz	a5,446 <strlen+0x26>
 42c:	0505                	addi	a0,a0,1
 42e:	87aa                	mv	a5,a0
 430:	4685                	li	a3,1
 432:	9e89                	subw	a3,a3,a0
 434:	00f6853b          	addw	a0,a3,a5
 438:	0785                	addi	a5,a5,1
 43a:	fff7c703          	lbu	a4,-1(a5)
 43e:	fb7d                	bnez	a4,434 <strlen+0x14>
    ;
  return n;
}
 440:	6422                	ld	s0,8(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  for(n = 0; s[n]; n++)
 446:	4501                	li	a0,0
 448:	bfe5                	j	440 <strlen+0x20>

000000000000044a <memset>:

void*
memset(void *dst, int c, uint n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 450:	ca19                	beqz	a2,466 <memset+0x1c>
 452:	87aa                	mv	a5,a0
 454:	1602                	slli	a2,a2,0x20
 456:	9201                	srli	a2,a2,0x20
 458:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 45c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 460:	0785                	addi	a5,a5,1
 462:	fee79de3          	bne	a5,a4,45c <memset+0x12>
  }
  return dst;
}
 466:	6422                	ld	s0,8(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret

000000000000046c <strchr>:

char*
strchr(const char *s, char c)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	addi	s0,sp,16
  for(; *s; s++)
 472:	00054783          	lbu	a5,0(a0)
 476:	cb99                	beqz	a5,48c <strchr+0x20>
    if(*s == c)
 478:	00f58763          	beq	a1,a5,486 <strchr+0x1a>
  for(; *s; s++)
 47c:	0505                	addi	a0,a0,1
 47e:	00054783          	lbu	a5,0(a0)
 482:	fbfd                	bnez	a5,478 <strchr+0xc>
      return (char*)s;
  return 0;
 484:	4501                	li	a0,0
}
 486:	6422                	ld	s0,8(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret
  return 0;
 48c:	4501                	li	a0,0
 48e:	bfe5                	j	486 <strchr+0x1a>

0000000000000490 <gets>:

char*
gets(char *buf, int max)
{
 490:	711d                	addi	sp,sp,-96
 492:	ec86                	sd	ra,88(sp)
 494:	e8a2                	sd	s0,80(sp)
 496:	e4a6                	sd	s1,72(sp)
 498:	e0ca                	sd	s2,64(sp)
 49a:	fc4e                	sd	s3,56(sp)
 49c:	f852                	sd	s4,48(sp)
 49e:	f456                	sd	s5,40(sp)
 4a0:	f05a                	sd	s6,32(sp)
 4a2:	ec5e                	sd	s7,24(sp)
 4a4:	1080                	addi	s0,sp,96
 4a6:	8baa                	mv	s7,a0
 4a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4aa:	892a                	mv	s2,a0
 4ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4ae:	4aa9                	li	s5,10
 4b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4b2:	89a6                	mv	s3,s1
 4b4:	2485                	addiw	s1,s1,1
 4b6:	0344d863          	bge	s1,s4,4e6 <gets+0x56>
    cc = read(0, &c, 1);
 4ba:	4605                	li	a2,1
 4bc:	faf40593          	addi	a1,s0,-81
 4c0:	4501                	li	a0,0
 4c2:	00000097          	auipc	ra,0x0
 4c6:	19a080e7          	jalr	410(ra) # 65c <read>
    if(cc < 1)
 4ca:	00a05e63          	blez	a0,4e6 <gets+0x56>
    buf[i++] = c;
 4ce:	faf44783          	lbu	a5,-81(s0)
 4d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4d6:	01578763          	beq	a5,s5,4e4 <gets+0x54>
 4da:	0905                	addi	s2,s2,1
 4dc:	fd679be3          	bne	a5,s6,4b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 4e0:	89a6                	mv	s3,s1
 4e2:	a011                	j	4e6 <gets+0x56>
 4e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4e6:	99de                	add	s3,s3,s7
 4e8:	00098023          	sb	zero,0(s3) # 1000 <freep>
  return buf;
}
 4ec:	855e                	mv	a0,s7
 4ee:	60e6                	ld	ra,88(sp)
 4f0:	6446                	ld	s0,80(sp)
 4f2:	64a6                	ld	s1,72(sp)
 4f4:	6906                	ld	s2,64(sp)
 4f6:	79e2                	ld	s3,56(sp)
 4f8:	7a42                	ld	s4,48(sp)
 4fa:	7aa2                	ld	s5,40(sp)
 4fc:	7b02                	ld	s6,32(sp)
 4fe:	6be2                	ld	s7,24(sp)
 500:	6125                	addi	sp,sp,96
 502:	8082                	ret

0000000000000504 <stat>:

int
stat(const char *n, struct stat *st)
{
 504:	1101                	addi	sp,sp,-32
 506:	ec06                	sd	ra,24(sp)
 508:	e822                	sd	s0,16(sp)
 50a:	e426                	sd	s1,8(sp)
 50c:	e04a                	sd	s2,0(sp)
 50e:	1000                	addi	s0,sp,32
 510:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 512:	4581                	li	a1,0
 514:	00000097          	auipc	ra,0x0
 518:	170080e7          	jalr	368(ra) # 684 <open>
  if(fd < 0)
 51c:	02054563          	bltz	a0,546 <stat+0x42>
 520:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 522:	85ca                	mv	a1,s2
 524:	00000097          	auipc	ra,0x0
 528:	178080e7          	jalr	376(ra) # 69c <fstat>
 52c:	892a                	mv	s2,a0
  close(fd);
 52e:	8526                	mv	a0,s1
 530:	00000097          	auipc	ra,0x0
 534:	13c080e7          	jalr	316(ra) # 66c <close>
  return r;
}
 538:	854a                	mv	a0,s2
 53a:	60e2                	ld	ra,24(sp)
 53c:	6442                	ld	s0,16(sp)
 53e:	64a2                	ld	s1,8(sp)
 540:	6902                	ld	s2,0(sp)
 542:	6105                	addi	sp,sp,32
 544:	8082                	ret
    return -1;
 546:	597d                	li	s2,-1
 548:	bfc5                	j	538 <stat+0x34>

000000000000054a <atoi>:

int
atoi(const char *s)
{
 54a:	1141                	addi	sp,sp,-16
 54c:	e422                	sd	s0,8(sp)
 54e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 550:	00054683          	lbu	a3,0(a0)
 554:	fd06879b          	addiw	a5,a3,-48
 558:	0ff7f793          	zext.b	a5,a5
 55c:	4625                	li	a2,9
 55e:	02f66863          	bltu	a2,a5,58e <atoi+0x44>
 562:	872a                	mv	a4,a0
  n = 0;
 564:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 566:	0705                	addi	a4,a4,1
 568:	0025179b          	slliw	a5,a0,0x2
 56c:	9fa9                	addw	a5,a5,a0
 56e:	0017979b          	slliw	a5,a5,0x1
 572:	9fb5                	addw	a5,a5,a3
 574:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 578:	00074683          	lbu	a3,0(a4)
 57c:	fd06879b          	addiw	a5,a3,-48
 580:	0ff7f793          	zext.b	a5,a5
 584:	fef671e3          	bgeu	a2,a5,566 <atoi+0x1c>
  return n;
}
 588:	6422                	ld	s0,8(sp)
 58a:	0141                	addi	sp,sp,16
 58c:	8082                	ret
  n = 0;
 58e:	4501                	li	a0,0
 590:	bfe5                	j	588 <atoi+0x3e>

0000000000000592 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 592:	1141                	addi	sp,sp,-16
 594:	e422                	sd	s0,8(sp)
 596:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 598:	02b57463          	bgeu	a0,a1,5c0 <memmove+0x2e>
    while(n-- > 0)
 59c:	00c05f63          	blez	a2,5ba <memmove+0x28>
 5a0:	1602                	slli	a2,a2,0x20
 5a2:	9201                	srli	a2,a2,0x20
 5a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 5aa:	0585                	addi	a1,a1,1
 5ac:	0705                	addi	a4,a4,1
 5ae:	fff5c683          	lbu	a3,-1(a1)
 5b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5b6:	fee79ae3          	bne	a5,a4,5aa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5ba:	6422                	ld	s0,8(sp)
 5bc:	0141                	addi	sp,sp,16
 5be:	8082                	ret
    dst += n;
 5c0:	00c50733          	add	a4,a0,a2
    src += n;
 5c4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5c6:	fec05ae3          	blez	a2,5ba <memmove+0x28>
 5ca:	fff6079b          	addiw	a5,a2,-1
 5ce:	1782                	slli	a5,a5,0x20
 5d0:	9381                	srli	a5,a5,0x20
 5d2:	fff7c793          	not	a5,a5
 5d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5d8:	15fd                	addi	a1,a1,-1
 5da:	177d                	addi	a4,a4,-1
 5dc:	0005c683          	lbu	a3,0(a1)
 5e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5e4:	fee79ae3          	bne	a5,a4,5d8 <memmove+0x46>
 5e8:	bfc9                	j	5ba <memmove+0x28>

00000000000005ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5ea:	1141                	addi	sp,sp,-16
 5ec:	e422                	sd	s0,8(sp)
 5ee:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5f0:	ca05                	beqz	a2,620 <memcmp+0x36>
 5f2:	fff6069b          	addiw	a3,a2,-1
 5f6:	1682                	slli	a3,a3,0x20
 5f8:	9281                	srli	a3,a3,0x20
 5fa:	0685                	addi	a3,a3,1
 5fc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5fe:	00054783          	lbu	a5,0(a0)
 602:	0005c703          	lbu	a4,0(a1)
 606:	00e79863          	bne	a5,a4,616 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 60a:	0505                	addi	a0,a0,1
    p2++;
 60c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 60e:	fed518e3          	bne	a0,a3,5fe <memcmp+0x14>
  }
  return 0;
 612:	4501                	li	a0,0
 614:	a019                	j	61a <memcmp+0x30>
      return *p1 - *p2;
 616:	40e7853b          	subw	a0,a5,a4
}
 61a:	6422                	ld	s0,8(sp)
 61c:	0141                	addi	sp,sp,16
 61e:	8082                	ret
  return 0;
 620:	4501                	li	a0,0
 622:	bfe5                	j	61a <memcmp+0x30>

0000000000000624 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 624:	1141                	addi	sp,sp,-16
 626:	e406                	sd	ra,8(sp)
 628:	e022                	sd	s0,0(sp)
 62a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 62c:	00000097          	auipc	ra,0x0
 630:	f66080e7          	jalr	-154(ra) # 592 <memmove>
}
 634:	60a2                	ld	ra,8(sp)
 636:	6402                	ld	s0,0(sp)
 638:	0141                	addi	sp,sp,16
 63a:	8082                	ret

000000000000063c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 63c:	4885                	li	a7,1
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <exit>:
.global exit
exit:
 li a7, SYS_exit
 644:	4889                	li	a7,2
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <wait>:
.global wait
wait:
 li a7, SYS_wait
 64c:	488d                	li	a7,3
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 654:	4891                	li	a7,4
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <read>:
.global read
read:
 li a7, SYS_read
 65c:	4895                	li	a7,5
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <write>:
.global write
write:
 li a7, SYS_write
 664:	48c1                	li	a7,16
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <close>:
.global close
close:
 li a7, SYS_close
 66c:	48d5                	li	a7,21
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <kill>:
.global kill
kill:
 li a7, SYS_kill
 674:	4899                	li	a7,6
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <exec>:
.global exec
exec:
 li a7, SYS_exec
 67c:	489d                	li	a7,7
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <open>:
.global open
open:
 li a7, SYS_open
 684:	48bd                	li	a7,15
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 68c:	48c5                	li	a7,17
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 694:	48c9                	li	a7,18
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 69c:	48a1                	li	a7,8
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <link>:
.global link
link:
 li a7, SYS_link
 6a4:	48cd                	li	a7,19
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6ac:	48d1                	li	a7,20
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6b4:	48a5                	li	a7,9
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <dup>:
.global dup
dup:
 li a7, SYS_dup
 6bc:	48a9                	li	a7,10
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6c4:	48ad                	li	a7,11
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6cc:	48b1                	li	a7,12
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6d4:	48b5                	li	a7,13
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6dc:	48b9                	li	a7,14
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6e4:	48d9                	li	a7,22
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 6ec:	48dd                	li	a7,23
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f4:	1101                	addi	sp,sp,-32
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 700:	4605                	li	a2,1
 702:	fef40593          	addi	a1,s0,-17
 706:	00000097          	auipc	ra,0x0
 70a:	f5e080e7          	jalr	-162(ra) # 664 <write>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6105                	addi	sp,sp,32
 714:	8082                	ret

0000000000000716 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 716:	7139                	addi	sp,sp,-64
 718:	fc06                	sd	ra,56(sp)
 71a:	f822                	sd	s0,48(sp)
 71c:	f426                	sd	s1,40(sp)
 71e:	f04a                	sd	s2,32(sp)
 720:	ec4e                	sd	s3,24(sp)
 722:	0080                	addi	s0,sp,64
 724:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 726:	c299                	beqz	a3,72c <printint+0x16>
 728:	0805c963          	bltz	a1,7ba <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 72c:	2581                	sext.w	a1,a1
  neg = 0;
 72e:	4881                	li	a7,0
 730:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 734:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 736:	2601                	sext.w	a2,a2
 738:	00000517          	auipc	a0,0x0
 73c:	62850513          	addi	a0,a0,1576 # d60 <digits>
 740:	883a                	mv	a6,a4
 742:	2705                	addiw	a4,a4,1
 744:	02c5f7bb          	remuw	a5,a1,a2
 748:	1782                	slli	a5,a5,0x20
 74a:	9381                	srli	a5,a5,0x20
 74c:	97aa                	add	a5,a5,a0
 74e:	0007c783          	lbu	a5,0(a5)
 752:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 756:	0005879b          	sext.w	a5,a1
 75a:	02c5d5bb          	divuw	a1,a1,a2
 75e:	0685                	addi	a3,a3,1
 760:	fec7f0e3          	bgeu	a5,a2,740 <printint+0x2a>
  if(neg)
 764:	00088c63          	beqz	a7,77c <printint+0x66>
    buf[i++] = '-';
 768:	fd070793          	addi	a5,a4,-48
 76c:	00878733          	add	a4,a5,s0
 770:	02d00793          	li	a5,45
 774:	fef70823          	sb	a5,-16(a4)
 778:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 77c:	02e05863          	blez	a4,7ac <printint+0x96>
 780:	fc040793          	addi	a5,s0,-64
 784:	00e78933          	add	s2,a5,a4
 788:	fff78993          	addi	s3,a5,-1
 78c:	99ba                	add	s3,s3,a4
 78e:	377d                	addiw	a4,a4,-1
 790:	1702                	slli	a4,a4,0x20
 792:	9301                	srli	a4,a4,0x20
 794:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 798:	fff94583          	lbu	a1,-1(s2)
 79c:	8526                	mv	a0,s1
 79e:	00000097          	auipc	ra,0x0
 7a2:	f56080e7          	jalr	-170(ra) # 6f4 <putc>
  while(--i >= 0)
 7a6:	197d                	addi	s2,s2,-1
 7a8:	ff3918e3          	bne	s2,s3,798 <printint+0x82>
}
 7ac:	70e2                	ld	ra,56(sp)
 7ae:	7442                	ld	s0,48(sp)
 7b0:	74a2                	ld	s1,40(sp)
 7b2:	7902                	ld	s2,32(sp)
 7b4:	69e2                	ld	s3,24(sp)
 7b6:	6121                	addi	sp,sp,64
 7b8:	8082                	ret
    x = -xx;
 7ba:	40b005bb          	negw	a1,a1
    neg = 1;
 7be:	4885                	li	a7,1
    x = -xx;
 7c0:	bf85                	j	730 <printint+0x1a>

00000000000007c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c2:	7119                	addi	sp,sp,-128
 7c4:	fc86                	sd	ra,120(sp)
 7c6:	f8a2                	sd	s0,112(sp)
 7c8:	f4a6                	sd	s1,104(sp)
 7ca:	f0ca                	sd	s2,96(sp)
 7cc:	ecce                	sd	s3,88(sp)
 7ce:	e8d2                	sd	s4,80(sp)
 7d0:	e4d6                	sd	s5,72(sp)
 7d2:	e0da                	sd	s6,64(sp)
 7d4:	fc5e                	sd	s7,56(sp)
 7d6:	f862                	sd	s8,48(sp)
 7d8:	f466                	sd	s9,40(sp)
 7da:	f06a                	sd	s10,32(sp)
 7dc:	ec6e                	sd	s11,24(sp)
 7de:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7e0:	0005c903          	lbu	s2,0(a1)
 7e4:	18090f63          	beqz	s2,982 <vprintf+0x1c0>
 7e8:	8aaa                	mv	s5,a0
 7ea:	8b32                	mv	s6,a2
 7ec:	00158493          	addi	s1,a1,1
  state = 0;
 7f0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7f2:	02500a13          	li	s4,37
 7f6:	4c55                	li	s8,21
 7f8:	00000c97          	auipc	s9,0x0
 7fc:	510c8c93          	addi	s9,s9,1296 # d08 <malloc+0x282>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 800:	02800d93          	li	s11,40
  putc(fd, 'x');
 804:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 806:	00000b97          	auipc	s7,0x0
 80a:	55ab8b93          	addi	s7,s7,1370 # d60 <digits>
 80e:	a839                	j	82c <vprintf+0x6a>
        putc(fd, c);
 810:	85ca                	mv	a1,s2
 812:	8556                	mv	a0,s5
 814:	00000097          	auipc	ra,0x0
 818:	ee0080e7          	jalr	-288(ra) # 6f4 <putc>
 81c:	a019                	j	822 <vprintf+0x60>
    } else if(state == '%'){
 81e:	01498d63          	beq	s3,s4,838 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 822:	0485                	addi	s1,s1,1
 824:	fff4c903          	lbu	s2,-1(s1)
 828:	14090d63          	beqz	s2,982 <vprintf+0x1c0>
    if(state == 0){
 82c:	fe0999e3          	bnez	s3,81e <vprintf+0x5c>
      if(c == '%'){
 830:	ff4910e3          	bne	s2,s4,810 <vprintf+0x4e>
        state = '%';
 834:	89d2                	mv	s3,s4
 836:	b7f5                	j	822 <vprintf+0x60>
      if(c == 'd'){
 838:	11490c63          	beq	s2,s4,950 <vprintf+0x18e>
 83c:	f9d9079b          	addiw	a5,s2,-99
 840:	0ff7f793          	zext.b	a5,a5
 844:	10fc6e63          	bltu	s8,a5,960 <vprintf+0x19e>
 848:	f9d9079b          	addiw	a5,s2,-99
 84c:	0ff7f713          	zext.b	a4,a5
 850:	10ec6863          	bltu	s8,a4,960 <vprintf+0x19e>
 854:	00271793          	slli	a5,a4,0x2
 858:	97e6                	add	a5,a5,s9
 85a:	439c                	lw	a5,0(a5)
 85c:	97e6                	add	a5,a5,s9
 85e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 860:	008b0913          	addi	s2,s6,8
 864:	4685                	li	a3,1
 866:	4629                	li	a2,10
 868:	000b2583          	lw	a1,0(s6)
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	ea8080e7          	jalr	-344(ra) # 716 <printint>
 876:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 878:	4981                	li	s3,0
 87a:	b765                	j	822 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 87c:	008b0913          	addi	s2,s6,8
 880:	4681                	li	a3,0
 882:	4629                	li	a2,10
 884:	000b2583          	lw	a1,0(s6)
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	e8c080e7          	jalr	-372(ra) # 716 <printint>
 892:	8b4a                	mv	s6,s2
      state = 0;
 894:	4981                	li	s3,0
 896:	b771                	j	822 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 898:	008b0913          	addi	s2,s6,8
 89c:	4681                	li	a3,0
 89e:	866a                	mv	a2,s10
 8a0:	000b2583          	lw	a1,0(s6)
 8a4:	8556                	mv	a0,s5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	e70080e7          	jalr	-400(ra) # 716 <printint>
 8ae:	8b4a                	mv	s6,s2
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	bf85                	j	822 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8b4:	008b0793          	addi	a5,s6,8
 8b8:	f8f43423          	sd	a5,-120(s0)
 8bc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8c0:	03000593          	li	a1,48
 8c4:	8556                	mv	a0,s5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	e2e080e7          	jalr	-466(ra) # 6f4 <putc>
  putc(fd, 'x');
 8ce:	07800593          	li	a1,120
 8d2:	8556                	mv	a0,s5
 8d4:	00000097          	auipc	ra,0x0
 8d8:	e20080e7          	jalr	-480(ra) # 6f4 <putc>
 8dc:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8de:	03c9d793          	srli	a5,s3,0x3c
 8e2:	97de                	add	a5,a5,s7
 8e4:	0007c583          	lbu	a1,0(a5)
 8e8:	8556                	mv	a0,s5
 8ea:	00000097          	auipc	ra,0x0
 8ee:	e0a080e7          	jalr	-502(ra) # 6f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8f2:	0992                	slli	s3,s3,0x4
 8f4:	397d                	addiw	s2,s2,-1
 8f6:	fe0914e3          	bnez	s2,8de <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 8fa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8fe:	4981                	li	s3,0
 900:	b70d                	j	822 <vprintf+0x60>
        s = va_arg(ap, char*);
 902:	008b0913          	addi	s2,s6,8
 906:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 90a:	02098163          	beqz	s3,92c <vprintf+0x16a>
        while(*s != 0){
 90e:	0009c583          	lbu	a1,0(s3)
 912:	c5ad                	beqz	a1,97c <vprintf+0x1ba>
          putc(fd, *s);
 914:	8556                	mv	a0,s5
 916:	00000097          	auipc	ra,0x0
 91a:	dde080e7          	jalr	-546(ra) # 6f4 <putc>
          s++;
 91e:	0985                	addi	s3,s3,1
        while(*s != 0){
 920:	0009c583          	lbu	a1,0(s3)
 924:	f9e5                	bnez	a1,914 <vprintf+0x152>
        s = va_arg(ap, char*);
 926:	8b4a                	mv	s6,s2
      state = 0;
 928:	4981                	li	s3,0
 92a:	bde5                	j	822 <vprintf+0x60>
          s = "(null)";
 92c:	00000997          	auipc	s3,0x0
 930:	3d498993          	addi	s3,s3,980 # d00 <malloc+0x27a>
        while(*s != 0){
 934:	85ee                	mv	a1,s11
 936:	bff9                	j	914 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 938:	008b0913          	addi	s2,s6,8
 93c:	000b4583          	lbu	a1,0(s6)
 940:	8556                	mv	a0,s5
 942:	00000097          	auipc	ra,0x0
 946:	db2080e7          	jalr	-590(ra) # 6f4 <putc>
 94a:	8b4a                	mv	s6,s2
      state = 0;
 94c:	4981                	li	s3,0
 94e:	bdd1                	j	822 <vprintf+0x60>
        putc(fd, c);
 950:	85d2                	mv	a1,s4
 952:	8556                	mv	a0,s5
 954:	00000097          	auipc	ra,0x0
 958:	da0080e7          	jalr	-608(ra) # 6f4 <putc>
      state = 0;
 95c:	4981                	li	s3,0
 95e:	b5d1                	j	822 <vprintf+0x60>
        putc(fd, '%');
 960:	85d2                	mv	a1,s4
 962:	8556                	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	d90080e7          	jalr	-624(ra) # 6f4 <putc>
        putc(fd, c);
 96c:	85ca                	mv	a1,s2
 96e:	8556                	mv	a0,s5
 970:	00000097          	auipc	ra,0x0
 974:	d84080e7          	jalr	-636(ra) # 6f4 <putc>
      state = 0;
 978:	4981                	li	s3,0
 97a:	b565                	j	822 <vprintf+0x60>
        s = va_arg(ap, char*);
 97c:	8b4a                	mv	s6,s2
      state = 0;
 97e:	4981                	li	s3,0
 980:	b54d                	j	822 <vprintf+0x60>
    }
  }
}
 982:	70e6                	ld	ra,120(sp)
 984:	7446                	ld	s0,112(sp)
 986:	74a6                	ld	s1,104(sp)
 988:	7906                	ld	s2,96(sp)
 98a:	69e6                	ld	s3,88(sp)
 98c:	6a46                	ld	s4,80(sp)
 98e:	6aa6                	ld	s5,72(sp)
 990:	6b06                	ld	s6,64(sp)
 992:	7be2                	ld	s7,56(sp)
 994:	7c42                	ld	s8,48(sp)
 996:	7ca2                	ld	s9,40(sp)
 998:	7d02                	ld	s10,32(sp)
 99a:	6de2                	ld	s11,24(sp)
 99c:	6109                	addi	sp,sp,128
 99e:	8082                	ret

00000000000009a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9a0:	715d                	addi	sp,sp,-80
 9a2:	ec06                	sd	ra,24(sp)
 9a4:	e822                	sd	s0,16(sp)
 9a6:	1000                	addi	s0,sp,32
 9a8:	e010                	sd	a2,0(s0)
 9aa:	e414                	sd	a3,8(s0)
 9ac:	e818                	sd	a4,16(s0)
 9ae:	ec1c                	sd	a5,24(s0)
 9b0:	03043023          	sd	a6,32(s0)
 9b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9bc:	8622                	mv	a2,s0
 9be:	00000097          	auipc	ra,0x0
 9c2:	e04080e7          	jalr	-508(ra) # 7c2 <vprintf>
}
 9c6:	60e2                	ld	ra,24(sp)
 9c8:	6442                	ld	s0,16(sp)
 9ca:	6161                	addi	sp,sp,80
 9cc:	8082                	ret

00000000000009ce <printf>:

void
printf(const char *fmt, ...)
{
 9ce:	711d                	addi	sp,sp,-96
 9d0:	ec06                	sd	ra,24(sp)
 9d2:	e822                	sd	s0,16(sp)
 9d4:	1000                	addi	s0,sp,32
 9d6:	e40c                	sd	a1,8(s0)
 9d8:	e810                	sd	a2,16(s0)
 9da:	ec14                	sd	a3,24(s0)
 9dc:	f018                	sd	a4,32(s0)
 9de:	f41c                	sd	a5,40(s0)
 9e0:	03043823          	sd	a6,48(s0)
 9e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9e8:	00840613          	addi	a2,s0,8
 9ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9f0:	85aa                	mv	a1,a0
 9f2:	4505                	li	a0,1
 9f4:	00000097          	auipc	ra,0x0
 9f8:	dce080e7          	jalr	-562(ra) # 7c2 <vprintf>
}
 9fc:	60e2                	ld	ra,24(sp)
 9fe:	6442                	ld	s0,16(sp)
 a00:	6125                	addi	sp,sp,96
 a02:	8082                	ret

0000000000000a04 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a04:	1141                	addi	sp,sp,-16
 a06:	e422                	sd	s0,8(sp)
 a08:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a0a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0e:	00000797          	auipc	a5,0x0
 a12:	5f27b783          	ld	a5,1522(a5) # 1000 <freep>
 a16:	a02d                	j	a40 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a18:	4618                	lw	a4,8(a2)
 a1a:	9f2d                	addw	a4,a4,a1
 a1c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a20:	6398                	ld	a4,0(a5)
 a22:	6310                	ld	a2,0(a4)
 a24:	a83d                	j	a62 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a26:	ff852703          	lw	a4,-8(a0)
 a2a:	9f31                	addw	a4,a4,a2
 a2c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a2e:	ff053683          	ld	a3,-16(a0)
 a32:	a091                	j	a76 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a34:	6398                	ld	a4,0(a5)
 a36:	00e7e463          	bltu	a5,a4,a3e <free+0x3a>
 a3a:	00e6ea63          	bltu	a3,a4,a4e <free+0x4a>
{
 a3e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a40:	fed7fae3          	bgeu	a5,a3,a34 <free+0x30>
 a44:	6398                	ld	a4,0(a5)
 a46:	00e6e463          	bltu	a3,a4,a4e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a4a:	fee7eae3          	bltu	a5,a4,a3e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a4e:	ff852583          	lw	a1,-8(a0)
 a52:	6390                	ld	a2,0(a5)
 a54:	02059813          	slli	a6,a1,0x20
 a58:	01c85713          	srli	a4,a6,0x1c
 a5c:	9736                	add	a4,a4,a3
 a5e:	fae60de3          	beq	a2,a4,a18 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a62:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a66:	4790                	lw	a2,8(a5)
 a68:	02061593          	slli	a1,a2,0x20
 a6c:	01c5d713          	srli	a4,a1,0x1c
 a70:	973e                	add	a4,a4,a5
 a72:	fae68ae3          	beq	a3,a4,a26 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a76:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a78:	00000717          	auipc	a4,0x0
 a7c:	58f73423          	sd	a5,1416(a4) # 1000 <freep>
}
 a80:	6422                	ld	s0,8(sp)
 a82:	0141                	addi	sp,sp,16
 a84:	8082                	ret

0000000000000a86 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a86:	7139                	addi	sp,sp,-64
 a88:	fc06                	sd	ra,56(sp)
 a8a:	f822                	sd	s0,48(sp)
 a8c:	f426                	sd	s1,40(sp)
 a8e:	f04a                	sd	s2,32(sp)
 a90:	ec4e                	sd	s3,24(sp)
 a92:	e852                	sd	s4,16(sp)
 a94:	e456                	sd	s5,8(sp)
 a96:	e05a                	sd	s6,0(sp)
 a98:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a9a:	02051493          	slli	s1,a0,0x20
 a9e:	9081                	srli	s1,s1,0x20
 aa0:	04bd                	addi	s1,s1,15
 aa2:	8091                	srli	s1,s1,0x4
 aa4:	0014899b          	addiw	s3,s1,1
 aa8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 aaa:	00000517          	auipc	a0,0x0
 aae:	55653503          	ld	a0,1366(a0) # 1000 <freep>
 ab2:	c515                	beqz	a0,ade <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab6:	4798                	lw	a4,8(a5)
 ab8:	02977f63          	bgeu	a4,s1,af6 <malloc+0x70>
 abc:	8a4e                	mv	s4,s3
 abe:	0009871b          	sext.w	a4,s3
 ac2:	6685                	lui	a3,0x1
 ac4:	00d77363          	bgeu	a4,a3,aca <malloc+0x44>
 ac8:	6a05                	lui	s4,0x1
 aca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ace:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ad2:	00000917          	auipc	s2,0x0
 ad6:	52e90913          	addi	s2,s2,1326 # 1000 <freep>
  if(p == (char*)-1)
 ada:	5afd                	li	s5,-1
 adc:	a895                	j	b50 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 ade:	00000797          	auipc	a5,0x0
 ae2:	53278793          	addi	a5,a5,1330 # 1010 <base>
 ae6:	00000717          	auipc	a4,0x0
 aea:	50f73d23          	sd	a5,1306(a4) # 1000 <freep>
 aee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 af0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 af4:	b7e1                	j	abc <malloc+0x36>
      if(p->s.size == nunits)
 af6:	02e48c63          	beq	s1,a4,b2e <malloc+0xa8>
        p->s.size -= nunits;
 afa:	4137073b          	subw	a4,a4,s3
 afe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b00:	02071693          	slli	a3,a4,0x20
 b04:	01c6d713          	srli	a4,a3,0x1c
 b08:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b0a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b0e:	00000717          	auipc	a4,0x0
 b12:	4ea73923          	sd	a0,1266(a4) # 1000 <freep>
      return (void*)(p + 1);
 b16:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b1a:	70e2                	ld	ra,56(sp)
 b1c:	7442                	ld	s0,48(sp)
 b1e:	74a2                	ld	s1,40(sp)
 b20:	7902                	ld	s2,32(sp)
 b22:	69e2                	ld	s3,24(sp)
 b24:	6a42                	ld	s4,16(sp)
 b26:	6aa2                	ld	s5,8(sp)
 b28:	6b02                	ld	s6,0(sp)
 b2a:	6121                	addi	sp,sp,64
 b2c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b2e:	6398                	ld	a4,0(a5)
 b30:	e118                	sd	a4,0(a0)
 b32:	bff1                	j	b0e <malloc+0x88>
  hp->s.size = nu;
 b34:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b38:	0541                	addi	a0,a0,16
 b3a:	00000097          	auipc	ra,0x0
 b3e:	eca080e7          	jalr	-310(ra) # a04 <free>
  return freep;
 b42:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b46:	d971                	beqz	a0,b1a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b48:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b4a:	4798                	lw	a4,8(a5)
 b4c:	fa9775e3          	bgeu	a4,s1,af6 <malloc+0x70>
    if(p == freep)
 b50:	00093703          	ld	a4,0(s2)
 b54:	853e                	mv	a0,a5
 b56:	fef719e3          	bne	a4,a5,b48 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b5a:	8552                	mv	a0,s4
 b5c:	00000097          	auipc	ra,0x0
 b60:	b70080e7          	jalr	-1168(ra) # 6cc <sbrk>
  if(p == (char*)-1)
 b64:	fd5518e3          	bne	a0,s5,b34 <malloc+0xae>
        return 0;
 b68:	4501                	li	a0,0
 b6a:	bf45                	j	b1a <malloc+0x94>
