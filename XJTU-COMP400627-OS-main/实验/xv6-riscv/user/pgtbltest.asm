
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	ff293903          	ld	s2,-14(s2) # 1000 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	446080e7          	jalr	1094(ra) # 45c <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	8ec50513          	addi	a0,a0,-1812 # 910 <malloc+0xf2>
  2c:	00000097          	auipc	ra,0x0
  30:	73a080e7          	jalr	1850(ra) # 766 <printf>
  exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	3a6080e7          	jalr	934(ra) # 3dc <exit>

000000000000003e <pgaccess_test>:
}


void
pgaccess_test()
{
  3e:	7179                	addi	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	addi	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	8f050513          	addi	a0,a0,-1808 # 938 <malloc+0x11a>
  50:	00000097          	auipc	ra,0x0
  54:	716080e7          	jalr	1814(ra) # 766 <printf>
  testname = "pgaccess_test";
  58:	00001797          	auipc	a5,0x1
  5c:	8f878793          	addi	a5,a5,-1800 # 950 <malloc+0x132>
  60:	00001717          	auipc	a4,0x1
  64:	faf73023          	sd	a5,-96(a4) # 1000 <testname>
  buf = malloc(32 * PGSIZE);
  68:	00020537          	lui	a0,0x20
  6c:	00000097          	auipc	ra,0x0
  70:	7b2080e7          	jalr	1970(ra) # 81e <malloc>
  74:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
  76:	fdc40613          	addi	a2,s0,-36
  7a:	02000593          	li	a1,32
  7e:	00000097          	auipc	ra,0x0
  82:	406080e7          	jalr	1030(ra) # 484 <pgaccess>
  86:	06054b63          	bltz	a0,fc <pgaccess_test+0xbe>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
  8a:	6785                	lui	a5,0x1
  8c:	97a6                	add	a5,a5,s1
  8e:	0007c703          	lbu	a4,0(a5) # 1000 <testname>
  92:	2705                	addiw	a4,a4,1
  94:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
  98:	6789                	lui	a5,0x2
  9a:	97a6                	add	a5,a5,s1
  9c:	0007c703          	lbu	a4,0(a5) # 2000 <base+0xfe0>
  a0:	2705                	addiw	a4,a4,1
  a2:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
  a6:	67f9                	lui	a5,0x1e
  a8:	97a6                	add	a5,a5,s1
  aa:	0007c703          	lbu	a4,0(a5) # 1e000 <base+0x1cfe0>
  ae:	2705                	addiw	a4,a4,1
  b0:	00e78023          	sb	a4,0(a5)
  if (pgaccess(buf, 32, &abits) < 0)
  b4:	fdc40613          	addi	a2,s0,-36
  b8:	02000593          	li	a1,32
  bc:	8526                	mv	a0,s1
  be:	00000097          	auipc	ra,0x0
  c2:	3c6080e7          	jalr	966(ra) # 484 <pgaccess>
  c6:	04054363          	bltz	a0,10c <pgaccess_test+0xce>
    err("pgaccess failed");
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
  ca:	fdc42703          	lw	a4,-36(s0)
  ce:	400007b7          	lui	a5,0x40000
  d2:	0799                	addi	a5,a5,6 # 40000006 <base+0x3fffefe6>
  d4:	04f71463          	bne	a4,a5,11c <pgaccess_test+0xde>
    err("incorrect access bits set");
  free(buf);
  d8:	8526                	mv	a0,s1
  da:	00000097          	auipc	ra,0x0
  de:	6c2080e7          	jalr	1730(ra) # 79c <free>
  printf("pgaccess_test: OK\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	8ae50513          	addi	a0,a0,-1874 # 990 <malloc+0x172>
  ea:	00000097          	auipc	ra,0x0
  ee:	67c080e7          	jalr	1660(ra) # 766 <printf>
}
  f2:	70a2                	ld	ra,40(sp)
  f4:	7402                	ld	s0,32(sp)
  f6:	64e2                	ld	s1,24(sp)
  f8:	6145                	addi	sp,sp,48
  fa:	8082                	ret
    err("pgaccess failed");
  fc:	00001517          	auipc	a0,0x1
 100:	86450513          	addi	a0,a0,-1948 # 960 <malloc+0x142>
 104:	00000097          	auipc	ra,0x0
 108:	efc080e7          	jalr	-260(ra) # 0 <err>
    err("pgaccess failed");
 10c:	00001517          	auipc	a0,0x1
 110:	85450513          	addi	a0,a0,-1964 # 960 <malloc+0x142>
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <err>
    err("incorrect access bits set");
 11c:	00001517          	auipc	a0,0x1
 120:	85450513          	addi	a0,a0,-1964 # 970 <malloc+0x152>
 124:	00000097          	auipc	ra,0x0
 128:	edc080e7          	jalr	-292(ra) # 0 <err>

000000000000012c <main>:
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  pgaccess_test();
 134:	00000097          	auipc	ra,0x0
 138:	f0a080e7          	jalr	-246(ra) # 3e <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 13c:	00001517          	auipc	a0,0x1
 140:	86c50513          	addi	a0,a0,-1940 # 9a8 <malloc+0x18a>
 144:	00000097          	auipc	ra,0x0
 148:	622080e7          	jalr	1570(ra) # 766 <printf>
  exit(0);
 14c:	4501                	li	a0,0
 14e:	00000097          	auipc	ra,0x0
 152:	28e080e7          	jalr	654(ra) # 3dc <exit>

0000000000000156 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 15e:	00000097          	auipc	ra,0x0
 162:	fce080e7          	jalr	-50(ra) # 12c <main>
  exit(0);
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	274080e7          	jalr	628(ra) # 3dc <exit>

0000000000000170 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 170:	1141                	addi	sp,sp,-16
 172:	e422                	sd	s0,8(sp)
 174:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 176:	87aa                	mv	a5,a0
 178:	0585                	addi	a1,a1,1
 17a:	0785                	addi	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fb75                	bnez	a4,178 <strcpy+0x8>
    ;
  return os;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb91                	beqz	a5,1aa <strcmp+0x1e>
 198:	0005c703          	lbu	a4,0(a1)
 19c:	00f71763          	bne	a4,a5,1aa <strcmp+0x1e>
    p++, q++;
 1a0:	0505                	addi	a0,a0,1
 1a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	fbe5                	bnez	a5,198 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1aa:	0005c503          	lbu	a0,0(a1)
}
 1ae:	40a7853b          	subw	a0,a5,a0
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strlen>:

uint
strlen(const char *s)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf91                	beqz	a5,1de <strlen+0x26>
 1c4:	0505                	addi	a0,a0,1
 1c6:	87aa                	mv	a5,a0
 1c8:	4685                	li	a3,1
 1ca:	9e89                	subw	a3,a3,a0
 1cc:	00f6853b          	addw	a0,a3,a5
 1d0:	0785                	addi	a5,a5,1
 1d2:	fff7c703          	lbu	a4,-1(a5)
 1d6:	fb7d                	bnez	a4,1cc <strlen+0x14>
    ;
  return n;
}
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret
  for(n = 0; s[n]; n++)
 1de:	4501                	li	a0,0
 1e0:	bfe5                	j	1d8 <strlen+0x20>

00000000000001e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e8:	ca19                	beqz	a2,1fe <memset+0x1c>
 1ea:	87aa                	mv	a5,a0
 1ec:	1602                	slli	a2,a2,0x20
 1ee:	9201                	srli	a2,a2,0x20
 1f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f8:	0785                	addi	a5,a5,1
 1fa:	fee79de3          	bne	a5,a4,1f4 <memset+0x12>
  }
  return dst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret

0000000000000204 <strchr>:

char*
strchr(const char *s, char c)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  for(; *s; s++)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cb99                	beqz	a5,224 <strchr+0x20>
    if(*s == c)
 210:	00f58763          	beq	a1,a5,21e <strchr+0x1a>
  for(; *s; s++)
 214:	0505                	addi	a0,a0,1
 216:	00054783          	lbu	a5,0(a0)
 21a:	fbfd                	bnez	a5,210 <strchr+0xc>
      return (char*)s;
  return 0;
 21c:	4501                	li	a0,0
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  return 0;
 224:	4501                	li	a0,0
 226:	bfe5                	j	21e <strchr+0x1a>

0000000000000228 <gets>:

char*
gets(char *buf, int max)
{
 228:	711d                	addi	sp,sp,-96
 22a:	ec86                	sd	ra,88(sp)
 22c:	e8a2                	sd	s0,80(sp)
 22e:	e4a6                	sd	s1,72(sp)
 230:	e0ca                	sd	s2,64(sp)
 232:	fc4e                	sd	s3,56(sp)
 234:	f852                	sd	s4,48(sp)
 236:	f456                	sd	s5,40(sp)
 238:	f05a                	sd	s6,32(sp)
 23a:	ec5e                	sd	s7,24(sp)
 23c:	1080                	addi	s0,sp,96
 23e:	8baa                	mv	s7,a0
 240:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 242:	892a                	mv	s2,a0
 244:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 246:	4aa9                	li	s5,10
 248:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 24a:	89a6                	mv	s3,s1
 24c:	2485                	addiw	s1,s1,1
 24e:	0344d863          	bge	s1,s4,27e <gets+0x56>
    cc = read(0, &c, 1);
 252:	4605                	li	a2,1
 254:	faf40593          	addi	a1,s0,-81
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	19a080e7          	jalr	410(ra) # 3f4 <read>
    if(cc < 1)
 262:	00a05e63          	blez	a0,27e <gets+0x56>
    buf[i++] = c;
 266:	faf44783          	lbu	a5,-81(s0)
 26a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 26e:	01578763          	beq	a5,s5,27c <gets+0x54>
 272:	0905                	addi	s2,s2,1
 274:	fd679be3          	bne	a5,s6,24a <gets+0x22>
  for(i=0; i+1 < max; ){
 278:	89a6                	mv	s3,s1
 27a:	a011                	j	27e <gets+0x56>
 27c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 27e:	99de                	add	s3,s3,s7
 280:	00098023          	sb	zero,0(s3)
  return buf;
}
 284:	855e                	mv	a0,s7
 286:	60e6                	ld	ra,88(sp)
 288:	6446                	ld	s0,80(sp)
 28a:	64a6                	ld	s1,72(sp)
 28c:	6906                	ld	s2,64(sp)
 28e:	79e2                	ld	s3,56(sp)
 290:	7a42                	ld	s4,48(sp)
 292:	7aa2                	ld	s5,40(sp)
 294:	7b02                	ld	s6,32(sp)
 296:	6be2                	ld	s7,24(sp)
 298:	6125                	addi	sp,sp,96
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	addi	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e426                	sd	s1,8(sp)
 2a4:	e04a                	sd	s2,0(sp)
 2a6:	1000                	addi	s0,sp,32
 2a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2aa:	4581                	li	a1,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	170080e7          	jalr	368(ra) # 41c <open>
  if(fd < 0)
 2b4:	02054563          	bltz	a0,2de <stat+0x42>
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	00000097          	auipc	ra,0x0
 2c0:	178080e7          	jalr	376(ra) # 434 <fstat>
 2c4:	892a                	mv	s2,a0
  close(fd);
 2c6:	8526                	mv	a0,s1
 2c8:	00000097          	auipc	ra,0x0
 2cc:	13c080e7          	jalr	316(ra) # 404 <close>
  return r;
}
 2d0:	854a                	mv	a0,s2
 2d2:	60e2                	ld	ra,24(sp)
 2d4:	6442                	ld	s0,16(sp)
 2d6:	64a2                	ld	s1,8(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfc5                	j	2d0 <stat+0x34>

00000000000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e8:	00054683          	lbu	a3,0(a0)
 2ec:	fd06879b          	addiw	a5,a3,-48
 2f0:	0ff7f793          	zext.b	a5,a5
 2f4:	4625                	li	a2,9
 2f6:	02f66863          	bltu	a2,a5,326 <atoi+0x44>
 2fa:	872a                	mv	a4,a0
  n = 0;
 2fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2fe:	0705                	addi	a4,a4,1
 300:	0025179b          	slliw	a5,a0,0x2
 304:	9fa9                	addw	a5,a5,a0
 306:	0017979b          	slliw	a5,a5,0x1
 30a:	9fb5                	addw	a5,a5,a3
 30c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 310:	00074683          	lbu	a3,0(a4)
 314:	fd06879b          	addiw	a5,a3,-48
 318:	0ff7f793          	zext.b	a5,a5
 31c:	fef671e3          	bgeu	a2,a5,2fe <atoi+0x1c>
  return n;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  n = 0;
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <atoi+0x3e>

000000000000032a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 330:	02b57463          	bgeu	a0,a1,358 <memmove+0x2e>
    while(n-- > 0)
 334:	00c05f63          	blez	a2,352 <memmove+0x28>
 338:	1602                	slli	a2,a2,0x20
 33a:	9201                	srli	a2,a2,0x20
 33c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 340:	872a                	mv	a4,a0
      *dst++ = *src++;
 342:	0585                	addi	a1,a1,1
 344:	0705                	addi	a4,a4,1
 346:	fff5c683          	lbu	a3,-1(a1)
 34a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 34e:	fee79ae3          	bne	a5,a4,342 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
    dst += n;
 358:	00c50733          	add	a4,a0,a2
    src += n;
 35c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 35e:	fec05ae3          	blez	a2,352 <memmove+0x28>
 362:	fff6079b          	addiw	a5,a2,-1
 366:	1782                	slli	a5,a5,0x20
 368:	9381                	srli	a5,a5,0x20
 36a:	fff7c793          	not	a5,a5
 36e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 370:	15fd                	addi	a1,a1,-1
 372:	177d                	addi	a4,a4,-1
 374:	0005c683          	lbu	a3,0(a1)
 378:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 37c:	fee79ae3          	bne	a5,a4,370 <memmove+0x46>
 380:	bfc9                	j	352 <memmove+0x28>

0000000000000382 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 388:	ca05                	beqz	a2,3b8 <memcmp+0x36>
 38a:	fff6069b          	addiw	a3,a2,-1
 38e:	1682                	slli	a3,a3,0x20
 390:	9281                	srli	a3,a3,0x20
 392:	0685                	addi	a3,a3,1
 394:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 396:	00054783          	lbu	a5,0(a0)
 39a:	0005c703          	lbu	a4,0(a1)
 39e:	00e79863          	bne	a5,a4,3ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a2:	0505                	addi	a0,a0,1
    p2++;
 3a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a6:	fed518e3          	bne	a0,a3,396 <memcmp+0x14>
  }
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	a019                	j	3b2 <memcmp+0x30>
      return *p1 - *p2;
 3ae:	40e7853b          	subw	a0,a5,a4
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret
  return 0;
 3b8:	4501                	li	a0,0
 3ba:	bfe5                	j	3b2 <memcmp+0x30>

00000000000003bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e406                	sd	ra,8(sp)
 3c0:	e022                	sd	s0,0(sp)
 3c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c4:	00000097          	auipc	ra,0x0
 3c8:	f66080e7          	jalr	-154(ra) # 32a <memmove>
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d4:	4885                	li	a7,1
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3dc:	4889                	li	a7,2
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e4:	488d                	li	a7,3
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ec:	4891                	li	a7,4
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <read>:
.global read
read:
 li a7, SYS_read
 3f4:	4895                	li	a7,5
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <write>:
.global write
write:
 li a7, SYS_write
 3fc:	48c1                	li	a7,16
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <close>:
.global close
close:
 li a7, SYS_close
 404:	48d5                	li	a7,21
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <kill>:
.global kill
kill:
 li a7, SYS_kill
 40c:	4899                	li	a7,6
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <exec>:
.global exec
exec:
 li a7, SYS_exec
 414:	489d                	li	a7,7
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <open>:
.global open
open:
 li a7, SYS_open
 41c:	48bd                	li	a7,15
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 424:	48c5                	li	a7,17
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42c:	48c9                	li	a7,18
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 434:	48a1                	li	a7,8
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <link>:
.global link
link:
 li a7, SYS_link
 43c:	48cd                	li	a7,19
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 444:	48d1                	li	a7,20
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44c:	48a5                	li	a7,9
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <dup>:
.global dup
dup:
 li a7, SYS_dup
 454:	48a9                	li	a7,10
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45c:	48ad                	li	a7,11
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 464:	48b1                	li	a7,12
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 46c:	48b5                	li	a7,13
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 474:	48b9                	li	a7,14
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 47c:	48d9                	li	a7,22
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 484:	48dd                	li	a7,23
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48c:	1101                	addi	sp,sp,-32
 48e:	ec06                	sd	ra,24(sp)
 490:	e822                	sd	s0,16(sp)
 492:	1000                	addi	s0,sp,32
 494:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 498:	4605                	li	a2,1
 49a:	fef40593          	addi	a1,s0,-17
 49e:	00000097          	auipc	ra,0x0
 4a2:	f5e080e7          	jalr	-162(ra) # 3fc <write>
}
 4a6:	60e2                	ld	ra,24(sp)
 4a8:	6442                	ld	s0,16(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret

00000000000004ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ae:	7139                	addi	sp,sp,-64
 4b0:	fc06                	sd	ra,56(sp)
 4b2:	f822                	sd	s0,48(sp)
 4b4:	f426                	sd	s1,40(sp)
 4b6:	f04a                	sd	s2,32(sp)
 4b8:	ec4e                	sd	s3,24(sp)
 4ba:	0080                	addi	s0,sp,64
 4bc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4be:	c299                	beqz	a3,4c4 <printint+0x16>
 4c0:	0805c963          	bltz	a1,552 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c4:	2581                	sext.w	a1,a1
  neg = 0;
 4c6:	4881                	li	a7,0
 4c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ce:	2601                	sext.w	a2,a2
 4d0:	00000517          	auipc	a0,0x0
 4d4:	56050513          	addi	a0,a0,1376 # a30 <digits>
 4d8:	883a                	mv	a6,a4
 4da:	2705                	addiw	a4,a4,1
 4dc:	02c5f7bb          	remuw	a5,a1,a2
 4e0:	1782                	slli	a5,a5,0x20
 4e2:	9381                	srli	a5,a5,0x20
 4e4:	97aa                	add	a5,a5,a0
 4e6:	0007c783          	lbu	a5,0(a5)
 4ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ee:	0005879b          	sext.w	a5,a1
 4f2:	02c5d5bb          	divuw	a1,a1,a2
 4f6:	0685                	addi	a3,a3,1
 4f8:	fec7f0e3          	bgeu	a5,a2,4d8 <printint+0x2a>
  if(neg)
 4fc:	00088c63          	beqz	a7,514 <printint+0x66>
    buf[i++] = '-';
 500:	fd070793          	addi	a5,a4,-48
 504:	00878733          	add	a4,a5,s0
 508:	02d00793          	li	a5,45
 50c:	fef70823          	sb	a5,-16(a4)
 510:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 514:	02e05863          	blez	a4,544 <printint+0x96>
 518:	fc040793          	addi	a5,s0,-64
 51c:	00e78933          	add	s2,a5,a4
 520:	fff78993          	addi	s3,a5,-1
 524:	99ba                	add	s3,s3,a4
 526:	377d                	addiw	a4,a4,-1
 528:	1702                	slli	a4,a4,0x20
 52a:	9301                	srli	a4,a4,0x20
 52c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 530:	fff94583          	lbu	a1,-1(s2)
 534:	8526                	mv	a0,s1
 536:	00000097          	auipc	ra,0x0
 53a:	f56080e7          	jalr	-170(ra) # 48c <putc>
  while(--i >= 0)
 53e:	197d                	addi	s2,s2,-1
 540:	ff3918e3          	bne	s2,s3,530 <printint+0x82>
}
 544:	70e2                	ld	ra,56(sp)
 546:	7442                	ld	s0,48(sp)
 548:	74a2                	ld	s1,40(sp)
 54a:	7902                	ld	s2,32(sp)
 54c:	69e2                	ld	s3,24(sp)
 54e:	6121                	addi	sp,sp,64
 550:	8082                	ret
    x = -xx;
 552:	40b005bb          	negw	a1,a1
    neg = 1;
 556:	4885                	li	a7,1
    x = -xx;
 558:	bf85                	j	4c8 <printint+0x1a>

000000000000055a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55a:	7119                	addi	sp,sp,-128
 55c:	fc86                	sd	ra,120(sp)
 55e:	f8a2                	sd	s0,112(sp)
 560:	f4a6                	sd	s1,104(sp)
 562:	f0ca                	sd	s2,96(sp)
 564:	ecce                	sd	s3,88(sp)
 566:	e8d2                	sd	s4,80(sp)
 568:	e4d6                	sd	s5,72(sp)
 56a:	e0da                	sd	s6,64(sp)
 56c:	fc5e                	sd	s7,56(sp)
 56e:	f862                	sd	s8,48(sp)
 570:	f466                	sd	s9,40(sp)
 572:	f06a                	sd	s10,32(sp)
 574:	ec6e                	sd	s11,24(sp)
 576:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 578:	0005c903          	lbu	s2,0(a1)
 57c:	18090f63          	beqz	s2,71a <vprintf+0x1c0>
 580:	8aaa                	mv	s5,a0
 582:	8b32                	mv	s6,a2
 584:	00158493          	addi	s1,a1,1
  state = 0;
 588:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 58a:	02500a13          	li	s4,37
 58e:	4c55                	li	s8,21
 590:	00000c97          	auipc	s9,0x0
 594:	448c8c93          	addi	s9,s9,1096 # 9d8 <malloc+0x1ba>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 598:	02800d93          	li	s11,40
  putc(fd, 'x');
 59c:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 59e:	00000b97          	auipc	s7,0x0
 5a2:	492b8b93          	addi	s7,s7,1170 # a30 <digits>
 5a6:	a839                	j	5c4 <vprintf+0x6a>
        putc(fd, c);
 5a8:	85ca                	mv	a1,s2
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	ee0080e7          	jalr	-288(ra) # 48c <putc>
 5b4:	a019                	j	5ba <vprintf+0x60>
    } else if(state == '%'){
 5b6:	01498d63          	beq	s3,s4,5d0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 5ba:	0485                	addi	s1,s1,1
 5bc:	fff4c903          	lbu	s2,-1(s1)
 5c0:	14090d63          	beqz	s2,71a <vprintf+0x1c0>
    if(state == 0){
 5c4:	fe0999e3          	bnez	s3,5b6 <vprintf+0x5c>
      if(c == '%'){
 5c8:	ff4910e3          	bne	s2,s4,5a8 <vprintf+0x4e>
        state = '%';
 5cc:	89d2                	mv	s3,s4
 5ce:	b7f5                	j	5ba <vprintf+0x60>
      if(c == 'd'){
 5d0:	11490c63          	beq	s2,s4,6e8 <vprintf+0x18e>
 5d4:	f9d9079b          	addiw	a5,s2,-99
 5d8:	0ff7f793          	zext.b	a5,a5
 5dc:	10fc6e63          	bltu	s8,a5,6f8 <vprintf+0x19e>
 5e0:	f9d9079b          	addiw	a5,s2,-99
 5e4:	0ff7f713          	zext.b	a4,a5
 5e8:	10ec6863          	bltu	s8,a4,6f8 <vprintf+0x19e>
 5ec:	00271793          	slli	a5,a4,0x2
 5f0:	97e6                	add	a5,a5,s9
 5f2:	439c                	lw	a5,0(a5)
 5f4:	97e6                	add	a5,a5,s9
 5f6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000b2583          	lw	a1,0(s6)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	ea8080e7          	jalr	-344(ra) # 4ae <printint>
 60e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 610:	4981                	li	s3,0
 612:	b765                	j	5ba <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b0913          	addi	s2,s6,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000b2583          	lw	a1,0(s6)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e8c080e7          	jalr	-372(ra) # 4ae <printint>
 62a:	8b4a                	mv	s6,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b771                	j	5ba <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 630:	008b0913          	addi	s2,s6,8
 634:	4681                	li	a3,0
 636:	866a                	mv	a2,s10
 638:	000b2583          	lw	a1,0(s6)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e70080e7          	jalr	-400(ra) # 4ae <printint>
 646:	8b4a                	mv	s6,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf85                	j	5ba <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 64c:	008b0793          	addi	a5,s6,8
 650:	f8f43423          	sd	a5,-120(s0)
 654:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e2e080e7          	jalr	-466(ra) # 48c <putc>
  putc(fd, 'x');
 666:	07800593          	li	a1,120
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e20080e7          	jalr	-480(ra) # 48c <putc>
 674:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 676:	03c9d793          	srli	a5,s3,0x3c
 67a:	97de                	add	a5,a5,s7
 67c:	0007c583          	lbu	a1,0(a5)
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	e0a080e7          	jalr	-502(ra) # 48c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68a:	0992                	slli	s3,s3,0x4
 68c:	397d                	addiw	s2,s2,-1
 68e:	fe0914e3          	bnez	s2,676 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 692:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 696:	4981                	li	s3,0
 698:	b70d                	j	5ba <vprintf+0x60>
        s = va_arg(ap, char*);
 69a:	008b0913          	addi	s2,s6,8
 69e:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6a2:	02098163          	beqz	s3,6c4 <vprintf+0x16a>
        while(*s != 0){
 6a6:	0009c583          	lbu	a1,0(s3)
 6aa:	c5ad                	beqz	a1,714 <vprintf+0x1ba>
          putc(fd, *s);
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dde080e7          	jalr	-546(ra) # 48c <putc>
          s++;
 6b6:	0985                	addi	s3,s3,1
        while(*s != 0){
 6b8:	0009c583          	lbu	a1,0(s3)
 6bc:	f9e5                	bnez	a1,6ac <vprintf+0x152>
        s = va_arg(ap, char*);
 6be:	8b4a                	mv	s6,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bde5                	j	5ba <vprintf+0x60>
          s = "(null)";
 6c4:	00000997          	auipc	s3,0x0
 6c8:	30c98993          	addi	s3,s3,780 # 9d0 <malloc+0x1b2>
        while(*s != 0){
 6cc:	85ee                	mv	a1,s11
 6ce:	bff9                	j	6ac <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	000b4583          	lbu	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	db2080e7          	jalr	-590(ra) # 48c <putc>
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bdd1                	j	5ba <vprintf+0x60>
        putc(fd, c);
 6e8:	85d2                	mv	a1,s4
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	da0080e7          	jalr	-608(ra) # 48c <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b5d1                	j	5ba <vprintf+0x60>
        putc(fd, '%');
 6f8:	85d2                	mv	a1,s4
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	d90080e7          	jalr	-624(ra) # 48c <putc>
        putc(fd, c);
 704:	85ca                	mv	a1,s2
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	d84080e7          	jalr	-636(ra) # 48c <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	b565                	j	5ba <vprintf+0x60>
        s = va_arg(ap, char*);
 714:	8b4a                	mv	s6,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	b54d                	j	5ba <vprintf+0x60>
    }
  }
}
 71a:	70e6                	ld	ra,120(sp)
 71c:	7446                	ld	s0,112(sp)
 71e:	74a6                	ld	s1,104(sp)
 720:	7906                	ld	s2,96(sp)
 722:	69e6                	ld	s3,88(sp)
 724:	6a46                	ld	s4,80(sp)
 726:	6aa6                	ld	s5,72(sp)
 728:	6b06                	ld	s6,64(sp)
 72a:	7be2                	ld	s7,56(sp)
 72c:	7c42                	ld	s8,48(sp)
 72e:	7ca2                	ld	s9,40(sp)
 730:	7d02                	ld	s10,32(sp)
 732:	6de2                	ld	s11,24(sp)
 734:	6109                	addi	sp,sp,128
 736:	8082                	ret

0000000000000738 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 738:	715d                	addi	sp,sp,-80
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e010                	sd	a2,0(s0)
 742:	e414                	sd	a3,8(s0)
 744:	e818                	sd	a4,16(s0)
 746:	ec1c                	sd	a5,24(s0)
 748:	03043023          	sd	a6,32(s0)
 74c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 750:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 754:	8622                	mv	a2,s0
 756:	00000097          	auipc	ra,0x0
 75a:	e04080e7          	jalr	-508(ra) # 55a <vprintf>
}
 75e:	60e2                	ld	ra,24(sp)
 760:	6442                	ld	s0,16(sp)
 762:	6161                	addi	sp,sp,80
 764:	8082                	ret

0000000000000766 <printf>:

void
printf(const char *fmt, ...)
{
 766:	711d                	addi	sp,sp,-96
 768:	ec06                	sd	ra,24(sp)
 76a:	e822                	sd	s0,16(sp)
 76c:	1000                	addi	s0,sp,32
 76e:	e40c                	sd	a1,8(s0)
 770:	e810                	sd	a2,16(s0)
 772:	ec14                	sd	a3,24(s0)
 774:	f018                	sd	a4,32(s0)
 776:	f41c                	sd	a5,40(s0)
 778:	03043823          	sd	a6,48(s0)
 77c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 780:	00840613          	addi	a2,s0,8
 784:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 788:	85aa                	mv	a1,a0
 78a:	4505                	li	a0,1
 78c:	00000097          	auipc	ra,0x0
 790:	dce080e7          	jalr	-562(ra) # 55a <vprintf>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret

000000000000079c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79c:	1141                	addi	sp,sp,-16
 79e:	e422                	sd	s0,8(sp)
 7a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	00001797          	auipc	a5,0x1
 7aa:	86a7b783          	ld	a5,-1942(a5) # 1010 <freep>
 7ae:	a02d                	j	7d8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b0:	4618                	lw	a4,8(a2)
 7b2:	9f2d                	addw	a4,a4,a1
 7b4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	6398                	ld	a4,0(a5)
 7ba:	6310                	ld	a2,0(a4)
 7bc:	a83d                	j	7fa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7be:	ff852703          	lw	a4,-8(a0)
 7c2:	9f31                	addw	a4,a4,a2
 7c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c6:	ff053683          	ld	a3,-16(a0)
 7ca:	a091                	j	80e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	6398                	ld	a4,0(a5)
 7ce:	00e7e463          	bltu	a5,a4,7d6 <free+0x3a>
 7d2:	00e6ea63          	bltu	a3,a4,7e6 <free+0x4a>
{
 7d6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	fed7fae3          	bgeu	a5,a3,7cc <free+0x30>
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e6e463          	bltu	a3,a4,7e6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	fee7eae3          	bltu	a5,a4,7d6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7e6:	ff852583          	lw	a1,-8(a0)
 7ea:	6390                	ld	a2,0(a5)
 7ec:	02059813          	slli	a6,a1,0x20
 7f0:	01c85713          	srli	a4,a6,0x1c
 7f4:	9736                	add	a4,a4,a3
 7f6:	fae60de3          	beq	a2,a4,7b0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fe:	4790                	lw	a2,8(a5)
 800:	02061593          	slli	a1,a2,0x20
 804:	01c5d713          	srli	a4,a1,0x1c
 808:	973e                	add	a4,a4,a5
 80a:	fae68ae3          	beq	a3,a4,7be <free+0x22>
    p->s.ptr = bp->s.ptr;
 80e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 810:	00001717          	auipc	a4,0x1
 814:	80f73023          	sd	a5,-2048(a4) # 1010 <freep>
}
 818:	6422                	ld	s0,8(sp)
 81a:	0141                	addi	sp,sp,16
 81c:	8082                	ret

000000000000081e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81e:	7139                	addi	sp,sp,-64
 820:	fc06                	sd	ra,56(sp)
 822:	f822                	sd	s0,48(sp)
 824:	f426                	sd	s1,40(sp)
 826:	f04a                	sd	s2,32(sp)
 828:	ec4e                	sd	s3,24(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
 830:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	02051493          	slli	s1,a0,0x20
 836:	9081                	srli	s1,s1,0x20
 838:	04bd                	addi	s1,s1,15
 83a:	8091                	srli	s1,s1,0x4
 83c:	0014899b          	addiw	s3,s1,1
 840:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 842:	00000517          	auipc	a0,0x0
 846:	7ce53503          	ld	a0,1998(a0) # 1010 <freep>
 84a:	c515                	beqz	a0,876 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84e:	4798                	lw	a4,8(a5)
 850:	02977f63          	bgeu	a4,s1,88e <malloc+0x70>
 854:	8a4e                	mv	s4,s3
 856:	0009871b          	sext.w	a4,s3
 85a:	6685                	lui	a3,0x1
 85c:	00d77363          	bgeu	a4,a3,862 <malloc+0x44>
 860:	6a05                	lui	s4,0x1
 862:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 866:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86a:	00000917          	auipc	s2,0x0
 86e:	7a690913          	addi	s2,s2,1958 # 1010 <freep>
  if(p == (char*)-1)
 872:	5afd                	li	s5,-1
 874:	a895                	j	8e8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 876:	00000797          	auipc	a5,0x0
 87a:	7aa78793          	addi	a5,a5,1962 # 1020 <base>
 87e:	00000717          	auipc	a4,0x0
 882:	78f73923          	sd	a5,1938(a4) # 1010 <freep>
 886:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 888:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88c:	b7e1                	j	854 <malloc+0x36>
      if(p->s.size == nunits)
 88e:	02e48c63          	beq	s1,a4,8c6 <malloc+0xa8>
        p->s.size -= nunits;
 892:	4137073b          	subw	a4,a4,s3
 896:	c798                	sw	a4,8(a5)
        p += p->s.size;
 898:	02071693          	slli	a3,a4,0x20
 89c:	01c6d713          	srli	a4,a3,0x1c
 8a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a6:	00000717          	auipc	a4,0x0
 8aa:	76a73523          	sd	a0,1898(a4) # 1010 <freep>
      return (void*)(p + 1);
 8ae:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b2:	70e2                	ld	ra,56(sp)
 8b4:	7442                	ld	s0,48(sp)
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	7902                	ld	s2,32(sp)
 8ba:	69e2                	ld	s3,24(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	6121                	addi	sp,sp,64
 8c4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c6:	6398                	ld	a4,0(a5)
 8c8:	e118                	sd	a4,0(a0)
 8ca:	bff1                	j	8a6 <malloc+0x88>
  hp->s.size = nu;
 8cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d0:	0541                	addi	a0,a0,16
 8d2:	00000097          	auipc	ra,0x0
 8d6:	eca080e7          	jalr	-310(ra) # 79c <free>
  return freep;
 8da:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8de:	d971                	beqz	a0,8b2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	fa9775e3          	bgeu	a4,s1,88e <malloc+0x70>
    if(p == freep)
 8e8:	00093703          	ld	a4,0(s2)
 8ec:	853e                	mv	a0,a5
 8ee:	fef719e3          	bne	a4,a5,8e0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8f2:	8552                	mv	a0,s4
 8f4:	00000097          	auipc	ra,0x0
 8f8:	b70080e7          	jalr	-1168(ra) # 464 <sbrk>
  if(p == (char*)-1)
 8fc:	fd5518e3          	bne	a0,s5,8cc <malloc+0xae>
        return 0;
 900:	4501                	li	a0,0
 902:	bf45                	j	8b2 <malloc+0x94>
