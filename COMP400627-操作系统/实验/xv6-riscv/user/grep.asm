
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	0880                	addi	s0,sp,80
 130:	89aa                	mv	s3,a0
 132:	8b2e                	mv	s6,a1
  m = 0;
 134:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 136:	3ff00b93          	li	s7,1023
 13a:	00001a97          	auipc	s5,0x1
 13e:	ed6a8a93          	addi	s5,s5,-298 # 1010 <buf>
 142:	a0a1                	j	18a <grep+0x70>
      p = q+1;
 144:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 148:	45a9                	li	a1,10
 14a:	854a                	mv	a0,s2
 14c:	00000097          	auipc	ra,0x0
 150:	200080e7          	jalr	512(ra) # 34c <strchr>
 154:	84aa                	mv	s1,a0
 156:	c905                	beqz	a0,186 <grep+0x6c>
      *q = 0;
 158:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15c:	85ca                	mv	a1,s2
 15e:	854e                	mv	a0,s3
 160:	00000097          	auipc	ra,0x0
 164:	f6c080e7          	jalr	-148(ra) # cc <match>
 168:	dd71                	beqz	a0,144 <grep+0x2a>
        *q = '\n';
 16a:	47a9                	li	a5,10
 16c:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 170:	00148613          	addi	a2,s1,1
 174:	4126063b          	subw	a2,a2,s2
 178:	85ca                	mv	a1,s2
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	3c8080e7          	jalr	968(ra) # 544 <write>
 184:	b7c1                	j	144 <grep+0x2a>
    if(m > 0){
 186:	03404563          	bgtz	s4,1b0 <grep+0x96>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18a:	414b863b          	subw	a2,s7,s4
 18e:	014a85b3          	add	a1,s5,s4
 192:	855a                	mv	a0,s6
 194:	00000097          	auipc	ra,0x0
 198:	3a8080e7          	jalr	936(ra) # 53c <read>
 19c:	02a05663          	blez	a0,1c8 <grep+0xae>
    m += n;
 1a0:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1a4:	014a87b3          	add	a5,s5,s4
 1a8:	00078023          	sb	zero,0(a5)
    p = buf;
 1ac:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1ae:	bf69                	j	148 <grep+0x2e>
      m -= p - buf;
 1b0:	415907b3          	sub	a5,s2,s5
 1b4:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1b8:	8652                	mv	a2,s4
 1ba:	85ca                	mv	a1,s2
 1bc:	8556                	mv	a0,s5
 1be:	00000097          	auipc	ra,0x0
 1c2:	2b4080e7          	jalr	692(ra) # 472 <memmove>
 1c6:	b7d1                	j	18a <grep+0x70>
}
 1c8:	60a6                	ld	ra,72(sp)
 1ca:	6406                	ld	s0,64(sp)
 1cc:	74e2                	ld	s1,56(sp)
 1ce:	7942                	ld	s2,48(sp)
 1d0:	79a2                	ld	s3,40(sp)
 1d2:	7a02                	ld	s4,32(sp)
 1d4:	6ae2                	ld	s5,24(sp)
 1d6:	6b42                	ld	s6,16(sp)
 1d8:	6ba2                	ld	s7,8(sp)
 1da:	6161                	addi	sp,sp,80
 1dc:	8082                	ret

00000000000001de <main>:
{
 1de:	7139                	addi	sp,sp,-64
 1e0:	fc06                	sd	ra,56(sp)
 1e2:	f822                	sd	s0,48(sp)
 1e4:	f426                	sd	s1,40(sp)
 1e6:	f04a                	sd	s2,32(sp)
 1e8:	ec4e                	sd	s3,24(sp)
 1ea:	e852                	sd	s4,16(sp)
 1ec:	e456                	sd	s5,8(sp)
 1ee:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1f0:	4785                	li	a5,1
 1f2:	04a7de63          	bge	a5,a0,24e <main+0x70>
  pattern = argv[1];
 1f6:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1fa:	4789                	li	a5,2
 1fc:	06a7d763          	bge	a5,a0,26a <main+0x8c>
 200:	01058913          	addi	s2,a1,16
 204:	ffd5099b          	addiw	s3,a0,-3
 208:	02099793          	slli	a5,s3,0x20
 20c:	01d7d993          	srli	s3,a5,0x1d
 210:	05e1                	addi	a1,a1,24
 212:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 214:	4581                	li	a1,0
 216:	00093503          	ld	a0,0(s2)
 21a:	00000097          	auipc	ra,0x0
 21e:	34a080e7          	jalr	842(ra) # 564 <open>
 222:	84aa                	mv	s1,a0
 224:	04054e63          	bltz	a0,280 <main+0xa2>
    grep(pattern, fd);
 228:	85aa                	mv	a1,a0
 22a:	8552                	mv	a0,s4
 22c:	00000097          	auipc	ra,0x0
 230:	eee080e7          	jalr	-274(ra) # 11a <grep>
    close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	316080e7          	jalr	790(ra) # 54c <close>
  for(i = 2; i < argc; i++){
 23e:	0921                	addi	s2,s2,8
 240:	fd391ae3          	bne	s2,s3,214 <main+0x36>
  exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	2de080e7          	jalr	734(ra) # 524 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 24e:	00001597          	auipc	a1,0x1
 252:	80258593          	addi	a1,a1,-2046 # a50 <malloc+0xea>
 256:	4509                	li	a0,2
 258:	00000097          	auipc	ra,0x0
 25c:	628080e7          	jalr	1576(ra) # 880 <fprintf>
    exit(1);
 260:	4505                	li	a0,1
 262:	00000097          	auipc	ra,0x0
 266:	2c2080e7          	jalr	706(ra) # 524 <exit>
    grep(pattern, 0);
 26a:	4581                	li	a1,0
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	eac080e7          	jalr	-340(ra) # 11a <grep>
    exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	2ac080e7          	jalr	684(ra) # 524 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 280:	00093583          	ld	a1,0(s2)
 284:	00000517          	auipc	a0,0x0
 288:	7ec50513          	addi	a0,a0,2028 # a70 <malloc+0x10a>
 28c:	00000097          	auipc	ra,0x0
 290:	622080e7          	jalr	1570(ra) # 8ae <printf>
      exit(1);
 294:	4505                	li	a0,1
 296:	00000097          	auipc	ra,0x0
 29a:	28e080e7          	jalr	654(ra) # 524 <exit>

000000000000029e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2a6:	00000097          	auipc	ra,0x0
 2aa:	f38080e7          	jalr	-200(ra) # 1de <main>
  exit(0);
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	274080e7          	jalr	628(ra) # 524 <exit>

00000000000002b8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2be:	87aa                	mv	a5,a0
 2c0:	0585                	addi	a1,a1,1
 2c2:	0785                	addi	a5,a5,1
 2c4:	fff5c703          	lbu	a4,-1(a1)
 2c8:	fee78fa3          	sb	a4,-1(a5)
 2cc:	fb75                	bnez	a4,2c0 <strcpy+0x8>
    ;
  return os;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2da:	00054783          	lbu	a5,0(a0)
 2de:	cb91                	beqz	a5,2f2 <strcmp+0x1e>
 2e0:	0005c703          	lbu	a4,0(a1)
 2e4:	00f71763          	bne	a4,a5,2f2 <strcmp+0x1e>
    p++, q++;
 2e8:	0505                	addi	a0,a0,1
 2ea:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	fbe5                	bnez	a5,2e0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2f2:	0005c503          	lbu	a0,0(a1)
}
 2f6:	40a7853b          	subw	a0,a5,a0
 2fa:	6422                	ld	s0,8(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <strlen>:

uint
strlen(const char *s)
{
 300:	1141                	addi	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cf91                	beqz	a5,326 <strlen+0x26>
 30c:	0505                	addi	a0,a0,1
 30e:	87aa                	mv	a5,a0
 310:	4685                	li	a3,1
 312:	9e89                	subw	a3,a3,a0
 314:	00f6853b          	addw	a0,a3,a5
 318:	0785                	addi	a5,a5,1
 31a:	fff7c703          	lbu	a4,-1(a5)
 31e:	fb7d                	bnez	a4,314 <strlen+0x14>
    ;
  return n;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  for(n = 0; s[n]; n++)
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <strlen+0x20>

000000000000032a <memset>:

void*
memset(void *dst, int c, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 330:	ca19                	beqz	a2,346 <memset+0x1c>
 332:	87aa                	mv	a5,a0
 334:	1602                	slli	a2,a2,0x20
 336:	9201                	srli	a2,a2,0x20
 338:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 33c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 340:	0785                	addi	a5,a5,1
 342:	fee79de3          	bne	a5,a4,33c <memset+0x12>
  }
  return dst;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <strchr>:

char*
strchr(const char *s, char c)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  for(; *s; s++)
 352:	00054783          	lbu	a5,0(a0)
 356:	cb99                	beqz	a5,36c <strchr+0x20>
    if(*s == c)
 358:	00f58763          	beq	a1,a5,366 <strchr+0x1a>
  for(; *s; s++)
 35c:	0505                	addi	a0,a0,1
 35e:	00054783          	lbu	a5,0(a0)
 362:	fbfd                	bnez	a5,358 <strchr+0xc>
      return (char*)s;
  return 0;
 364:	4501                	li	a0,0
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfe5                	j	366 <strchr+0x1a>

0000000000000370 <gets>:

char*
gets(char *buf, int max)
{
 370:	711d                	addi	sp,sp,-96
 372:	ec86                	sd	ra,88(sp)
 374:	e8a2                	sd	s0,80(sp)
 376:	e4a6                	sd	s1,72(sp)
 378:	e0ca                	sd	s2,64(sp)
 37a:	fc4e                	sd	s3,56(sp)
 37c:	f852                	sd	s4,48(sp)
 37e:	f456                	sd	s5,40(sp)
 380:	f05a                	sd	s6,32(sp)
 382:	ec5e                	sd	s7,24(sp)
 384:	1080                	addi	s0,sp,96
 386:	8baa                	mv	s7,a0
 388:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38a:	892a                	mv	s2,a0
 38c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 38e:	4aa9                	li	s5,10
 390:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 392:	89a6                	mv	s3,s1
 394:	2485                	addiw	s1,s1,1
 396:	0344d863          	bge	s1,s4,3c6 <gets+0x56>
    cc = read(0, &c, 1);
 39a:	4605                	li	a2,1
 39c:	faf40593          	addi	a1,s0,-81
 3a0:	4501                	li	a0,0
 3a2:	00000097          	auipc	ra,0x0
 3a6:	19a080e7          	jalr	410(ra) # 53c <read>
    if(cc < 1)
 3aa:	00a05e63          	blez	a0,3c6 <gets+0x56>
    buf[i++] = c;
 3ae:	faf44783          	lbu	a5,-81(s0)
 3b2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b6:	01578763          	beq	a5,s5,3c4 <gets+0x54>
 3ba:	0905                	addi	s2,s2,1
 3bc:	fd679be3          	bne	a5,s6,392 <gets+0x22>
  for(i=0; i+1 < max; ){
 3c0:	89a6                	mv	s3,s1
 3c2:	a011                	j	3c6 <gets+0x56>
 3c4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3c6:	99de                	add	s3,s3,s7
 3c8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3cc:	855e                	mv	a0,s7
 3ce:	60e6                	ld	ra,88(sp)
 3d0:	6446                	ld	s0,80(sp)
 3d2:	64a6                	ld	s1,72(sp)
 3d4:	6906                	ld	s2,64(sp)
 3d6:	79e2                	ld	s3,56(sp)
 3d8:	7a42                	ld	s4,48(sp)
 3da:	7aa2                	ld	s5,40(sp)
 3dc:	7b02                	ld	s6,32(sp)
 3de:	6be2                	ld	s7,24(sp)
 3e0:	6125                	addi	sp,sp,96
 3e2:	8082                	ret

00000000000003e4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	e426                	sd	s1,8(sp)
 3ec:	e04a                	sd	s2,0(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f2:	4581                	li	a1,0
 3f4:	00000097          	auipc	ra,0x0
 3f8:	170080e7          	jalr	368(ra) # 564 <open>
  if(fd < 0)
 3fc:	02054563          	bltz	a0,426 <stat+0x42>
 400:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 402:	85ca                	mv	a1,s2
 404:	00000097          	auipc	ra,0x0
 408:	178080e7          	jalr	376(ra) # 57c <fstat>
 40c:	892a                	mv	s2,a0
  close(fd);
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	13c080e7          	jalr	316(ra) # 54c <close>
  return r;
}
 418:	854a                	mv	a0,s2
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	64a2                	ld	s1,8(sp)
 420:	6902                	ld	s2,0(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret
    return -1;
 426:	597d                	li	s2,-1
 428:	bfc5                	j	418 <stat+0x34>

000000000000042a <atoi>:

int
atoi(const char *s)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 430:	00054683          	lbu	a3,0(a0)
 434:	fd06879b          	addiw	a5,a3,-48
 438:	0ff7f793          	zext.b	a5,a5
 43c:	4625                	li	a2,9
 43e:	02f66863          	bltu	a2,a5,46e <atoi+0x44>
 442:	872a                	mv	a4,a0
  n = 0;
 444:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 446:	0705                	addi	a4,a4,1
 448:	0025179b          	slliw	a5,a0,0x2
 44c:	9fa9                	addw	a5,a5,a0
 44e:	0017979b          	slliw	a5,a5,0x1
 452:	9fb5                	addw	a5,a5,a3
 454:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 458:	00074683          	lbu	a3,0(a4)
 45c:	fd06879b          	addiw	a5,a3,-48
 460:	0ff7f793          	zext.b	a5,a5
 464:	fef671e3          	bgeu	a2,a5,446 <atoi+0x1c>
  return n;
}
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
  n = 0;
 46e:	4501                	li	a0,0
 470:	bfe5                	j	468 <atoi+0x3e>

0000000000000472 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 472:	1141                	addi	sp,sp,-16
 474:	e422                	sd	s0,8(sp)
 476:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 478:	02b57463          	bgeu	a0,a1,4a0 <memmove+0x2e>
    while(n-- > 0)
 47c:	00c05f63          	blez	a2,49a <memmove+0x28>
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 488:	872a                	mv	a4,a0
      *dst++ = *src++;
 48a:	0585                	addi	a1,a1,1
 48c:	0705                	addi	a4,a4,1
 48e:	fff5c683          	lbu	a3,-1(a1)
 492:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 496:	fee79ae3          	bne	a5,a4,48a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49a:	6422                	ld	s0,8(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret
    dst += n;
 4a0:	00c50733          	add	a4,a0,a2
    src += n;
 4a4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a6:	fec05ae3          	blez	a2,49a <memmove+0x28>
 4aa:	fff6079b          	addiw	a5,a2,-1
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	fff7c793          	not	a5,a5
 4b6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b8:	15fd                	addi	a1,a1,-1
 4ba:	177d                	addi	a4,a4,-1
 4bc:	0005c683          	lbu	a3,0(a1)
 4c0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c4:	fee79ae3          	bne	a5,a4,4b8 <memmove+0x46>
 4c8:	bfc9                	j	49a <memmove+0x28>

00000000000004ca <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d0:	ca05                	beqz	a2,500 <memcmp+0x36>
 4d2:	fff6069b          	addiw	a3,a2,-1
 4d6:	1682                	slli	a3,a3,0x20
 4d8:	9281                	srli	a3,a3,0x20
 4da:	0685                	addi	a3,a3,1
 4dc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4de:	00054783          	lbu	a5,0(a0)
 4e2:	0005c703          	lbu	a4,0(a1)
 4e6:	00e79863          	bne	a5,a4,4f6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4ea:	0505                	addi	a0,a0,1
    p2++;
 4ec:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ee:	fed518e3          	bne	a0,a3,4de <memcmp+0x14>
  }
  return 0;
 4f2:	4501                	li	a0,0
 4f4:	a019                	j	4fa <memcmp+0x30>
      return *p1 - *p2;
 4f6:	40e7853b          	subw	a0,a5,a4
}
 4fa:	6422                	ld	s0,8(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret
  return 0;
 500:	4501                	li	a0,0
 502:	bfe5                	j	4fa <memcmp+0x30>

0000000000000504 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 504:	1141                	addi	sp,sp,-16
 506:	e406                	sd	ra,8(sp)
 508:	e022                	sd	s0,0(sp)
 50a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 50c:	00000097          	auipc	ra,0x0
 510:	f66080e7          	jalr	-154(ra) # 472 <memmove>
}
 514:	60a2                	ld	ra,8(sp)
 516:	6402                	ld	s0,0(sp)
 518:	0141                	addi	sp,sp,16
 51a:	8082                	ret

000000000000051c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 51c:	4885                	li	a7,1
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <exit>:
.global exit
exit:
 li a7, SYS_exit
 524:	4889                	li	a7,2
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <wait>:
.global wait
wait:
 li a7, SYS_wait
 52c:	488d                	li	a7,3
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 534:	4891                	li	a7,4
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <read>:
.global read
read:
 li a7, SYS_read
 53c:	4895                	li	a7,5
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <write>:
.global write
write:
 li a7, SYS_write
 544:	48c1                	li	a7,16
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <close>:
.global close
close:
 li a7, SYS_close
 54c:	48d5                	li	a7,21
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <kill>:
.global kill
kill:
 li a7, SYS_kill
 554:	4899                	li	a7,6
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <exec>:
.global exec
exec:
 li a7, SYS_exec
 55c:	489d                	li	a7,7
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <open>:
.global open
open:
 li a7, SYS_open
 564:	48bd                	li	a7,15
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 56c:	48c5                	li	a7,17
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 574:	48c9                	li	a7,18
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 57c:	48a1                	li	a7,8
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <link>:
.global link
link:
 li a7, SYS_link
 584:	48cd                	li	a7,19
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 58c:	48d1                	li	a7,20
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 594:	48a5                	li	a7,9
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <dup>:
.global dup
dup:
 li a7, SYS_dup
 59c:	48a9                	li	a7,10
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5a4:	48ad                	li	a7,11
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ac:	48b1                	li	a7,12
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5b4:	48b5                	li	a7,13
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5bc:	48b9                	li	a7,14
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5c4:	48d9                	li	a7,22
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 5cc:	48dd                	li	a7,23
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d4:	1101                	addi	sp,sp,-32
 5d6:	ec06                	sd	ra,24(sp)
 5d8:	e822                	sd	s0,16(sp)
 5da:	1000                	addi	s0,sp,32
 5dc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e0:	4605                	li	a2,1
 5e2:	fef40593          	addi	a1,s0,-17
 5e6:	00000097          	auipc	ra,0x0
 5ea:	f5e080e7          	jalr	-162(ra) # 544 <write>
}
 5ee:	60e2                	ld	ra,24(sp)
 5f0:	6442                	ld	s0,16(sp)
 5f2:	6105                	addi	sp,sp,32
 5f4:	8082                	ret

00000000000005f6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f6:	7139                	addi	sp,sp,-64
 5f8:	fc06                	sd	ra,56(sp)
 5fa:	f822                	sd	s0,48(sp)
 5fc:	f426                	sd	s1,40(sp)
 5fe:	f04a                	sd	s2,32(sp)
 600:	ec4e                	sd	s3,24(sp)
 602:	0080                	addi	s0,sp,64
 604:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 606:	c299                	beqz	a3,60c <printint+0x16>
 608:	0805c963          	bltz	a1,69a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 60c:	2581                	sext.w	a1,a1
  neg = 0;
 60e:	4881                	li	a7,0
 610:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 614:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 616:	2601                	sext.w	a2,a2
 618:	00000517          	auipc	a0,0x0
 61c:	4d050513          	addi	a0,a0,1232 # ae8 <digits>
 620:	883a                	mv	a6,a4
 622:	2705                	addiw	a4,a4,1
 624:	02c5f7bb          	remuw	a5,a1,a2
 628:	1782                	slli	a5,a5,0x20
 62a:	9381                	srli	a5,a5,0x20
 62c:	97aa                	add	a5,a5,a0
 62e:	0007c783          	lbu	a5,0(a5)
 632:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 636:	0005879b          	sext.w	a5,a1
 63a:	02c5d5bb          	divuw	a1,a1,a2
 63e:	0685                	addi	a3,a3,1
 640:	fec7f0e3          	bgeu	a5,a2,620 <printint+0x2a>
  if(neg)
 644:	00088c63          	beqz	a7,65c <printint+0x66>
    buf[i++] = '-';
 648:	fd070793          	addi	a5,a4,-48
 64c:	00878733          	add	a4,a5,s0
 650:	02d00793          	li	a5,45
 654:	fef70823          	sb	a5,-16(a4)
 658:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 65c:	02e05863          	blez	a4,68c <printint+0x96>
 660:	fc040793          	addi	a5,s0,-64
 664:	00e78933          	add	s2,a5,a4
 668:	fff78993          	addi	s3,a5,-1
 66c:	99ba                	add	s3,s3,a4
 66e:	377d                	addiw	a4,a4,-1
 670:	1702                	slli	a4,a4,0x20
 672:	9301                	srli	a4,a4,0x20
 674:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 678:	fff94583          	lbu	a1,-1(s2)
 67c:	8526                	mv	a0,s1
 67e:	00000097          	auipc	ra,0x0
 682:	f56080e7          	jalr	-170(ra) # 5d4 <putc>
  while(--i >= 0)
 686:	197d                	addi	s2,s2,-1
 688:	ff3918e3          	bne	s2,s3,678 <printint+0x82>
}
 68c:	70e2                	ld	ra,56(sp)
 68e:	7442                	ld	s0,48(sp)
 690:	74a2                	ld	s1,40(sp)
 692:	7902                	ld	s2,32(sp)
 694:	69e2                	ld	s3,24(sp)
 696:	6121                	addi	sp,sp,64
 698:	8082                	ret
    x = -xx;
 69a:	40b005bb          	negw	a1,a1
    neg = 1;
 69e:	4885                	li	a7,1
    x = -xx;
 6a0:	bf85                	j	610 <printint+0x1a>

00000000000006a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a2:	7119                	addi	sp,sp,-128
 6a4:	fc86                	sd	ra,120(sp)
 6a6:	f8a2                	sd	s0,112(sp)
 6a8:	f4a6                	sd	s1,104(sp)
 6aa:	f0ca                	sd	s2,96(sp)
 6ac:	ecce                	sd	s3,88(sp)
 6ae:	e8d2                	sd	s4,80(sp)
 6b0:	e4d6                	sd	s5,72(sp)
 6b2:	e0da                	sd	s6,64(sp)
 6b4:	fc5e                	sd	s7,56(sp)
 6b6:	f862                	sd	s8,48(sp)
 6b8:	f466                	sd	s9,40(sp)
 6ba:	f06a                	sd	s10,32(sp)
 6bc:	ec6e                	sd	s11,24(sp)
 6be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6c0:	0005c903          	lbu	s2,0(a1)
 6c4:	18090f63          	beqz	s2,862 <vprintf+0x1c0>
 6c8:	8aaa                	mv	s5,a0
 6ca:	8b32                	mv	s6,a2
 6cc:	00158493          	addi	s1,a1,1
  state = 0;
 6d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6d2:	02500a13          	li	s4,37
 6d6:	4c55                	li	s8,21
 6d8:	00000c97          	auipc	s9,0x0
 6dc:	3b8c8c93          	addi	s9,s9,952 # a90 <malloc+0x12a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e0:	02800d93          	li	s11,40
  putc(fd, 'x');
 6e4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e6:	00000b97          	auipc	s7,0x0
 6ea:	402b8b93          	addi	s7,s7,1026 # ae8 <digits>
 6ee:	a839                	j	70c <vprintf+0x6a>
        putc(fd, c);
 6f0:	85ca                	mv	a1,s2
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	ee0080e7          	jalr	-288(ra) # 5d4 <putc>
 6fc:	a019                	j	702 <vprintf+0x60>
    } else if(state == '%'){
 6fe:	01498d63          	beq	s3,s4,718 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 702:	0485                	addi	s1,s1,1
 704:	fff4c903          	lbu	s2,-1(s1)
 708:	14090d63          	beqz	s2,862 <vprintf+0x1c0>
    if(state == 0){
 70c:	fe0999e3          	bnez	s3,6fe <vprintf+0x5c>
      if(c == '%'){
 710:	ff4910e3          	bne	s2,s4,6f0 <vprintf+0x4e>
        state = '%';
 714:	89d2                	mv	s3,s4
 716:	b7f5                	j	702 <vprintf+0x60>
      if(c == 'd'){
 718:	11490c63          	beq	s2,s4,830 <vprintf+0x18e>
 71c:	f9d9079b          	addiw	a5,s2,-99
 720:	0ff7f793          	zext.b	a5,a5
 724:	10fc6e63          	bltu	s8,a5,840 <vprintf+0x19e>
 728:	f9d9079b          	addiw	a5,s2,-99
 72c:	0ff7f713          	zext.b	a4,a5
 730:	10ec6863          	bltu	s8,a4,840 <vprintf+0x19e>
 734:	00271793          	slli	a5,a4,0x2
 738:	97e6                	add	a5,a5,s9
 73a:	439c                	lw	a5,0(a5)
 73c:	97e6                	add	a5,a5,s9
 73e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 740:	008b0913          	addi	s2,s6,8
 744:	4685                	li	a3,1
 746:	4629                	li	a2,10
 748:	000b2583          	lw	a1,0(s6)
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	ea8080e7          	jalr	-344(ra) # 5f6 <printint>
 756:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 758:	4981                	li	s3,0
 75a:	b765                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75c:	008b0913          	addi	s2,s6,8
 760:	4681                	li	a3,0
 762:	4629                	li	a2,10
 764:	000b2583          	lw	a1,0(s6)
 768:	8556                	mv	a0,s5
 76a:	00000097          	auipc	ra,0x0
 76e:	e8c080e7          	jalr	-372(ra) # 5f6 <printint>
 772:	8b4a                	mv	s6,s2
      state = 0;
 774:	4981                	li	s3,0
 776:	b771                	j	702 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 778:	008b0913          	addi	s2,s6,8
 77c:	4681                	li	a3,0
 77e:	866a                	mv	a2,s10
 780:	000b2583          	lw	a1,0(s6)
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	e70080e7          	jalr	-400(ra) # 5f6 <printint>
 78e:	8b4a                	mv	s6,s2
      state = 0;
 790:	4981                	li	s3,0
 792:	bf85                	j	702 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 794:	008b0793          	addi	a5,s6,8
 798:	f8f43423          	sd	a5,-120(s0)
 79c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7a0:	03000593          	li	a1,48
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e2e080e7          	jalr	-466(ra) # 5d4 <putc>
  putc(fd, 'x');
 7ae:	07800593          	li	a1,120
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e20080e7          	jalr	-480(ra) # 5d4 <putc>
 7bc:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7be:	03c9d793          	srli	a5,s3,0x3c
 7c2:	97de                	add	a5,a5,s7
 7c4:	0007c583          	lbu	a1,0(a5)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e0a080e7          	jalr	-502(ra) # 5d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d2:	0992                	slli	s3,s3,0x4
 7d4:	397d                	addiw	s2,s2,-1
 7d6:	fe0914e3          	bnez	s2,7be <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7da:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b70d                	j	702 <vprintf+0x60>
        s = va_arg(ap, char*);
 7e2:	008b0913          	addi	s2,s6,8
 7e6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7ea:	02098163          	beqz	s3,80c <vprintf+0x16a>
        while(*s != 0){
 7ee:	0009c583          	lbu	a1,0(s3)
 7f2:	c5ad                	beqz	a1,85c <vprintf+0x1ba>
          putc(fd, *s);
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	dde080e7          	jalr	-546(ra) # 5d4 <putc>
          s++;
 7fe:	0985                	addi	s3,s3,1
        while(*s != 0){
 800:	0009c583          	lbu	a1,0(s3)
 804:	f9e5                	bnez	a1,7f4 <vprintf+0x152>
        s = va_arg(ap, char*);
 806:	8b4a                	mv	s6,s2
      state = 0;
 808:	4981                	li	s3,0
 80a:	bde5                	j	702 <vprintf+0x60>
          s = "(null)";
 80c:	00000997          	auipc	s3,0x0
 810:	27c98993          	addi	s3,s3,636 # a88 <malloc+0x122>
        while(*s != 0){
 814:	85ee                	mv	a1,s11
 816:	bff9                	j	7f4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 818:	008b0913          	addi	s2,s6,8
 81c:	000b4583          	lbu	a1,0(s6)
 820:	8556                	mv	a0,s5
 822:	00000097          	auipc	ra,0x0
 826:	db2080e7          	jalr	-590(ra) # 5d4 <putc>
 82a:	8b4a                	mv	s6,s2
      state = 0;
 82c:	4981                	li	s3,0
 82e:	bdd1                	j	702 <vprintf+0x60>
        putc(fd, c);
 830:	85d2                	mv	a1,s4
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	da0080e7          	jalr	-608(ra) # 5d4 <putc>
      state = 0;
 83c:	4981                	li	s3,0
 83e:	b5d1                	j	702 <vprintf+0x60>
        putc(fd, '%');
 840:	85d2                	mv	a1,s4
 842:	8556                	mv	a0,s5
 844:	00000097          	auipc	ra,0x0
 848:	d90080e7          	jalr	-624(ra) # 5d4 <putc>
        putc(fd, c);
 84c:	85ca                	mv	a1,s2
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	d84080e7          	jalr	-636(ra) # 5d4 <putc>
      state = 0;
 858:	4981                	li	s3,0
 85a:	b565                	j	702 <vprintf+0x60>
        s = va_arg(ap, char*);
 85c:	8b4a                	mv	s6,s2
      state = 0;
 85e:	4981                	li	s3,0
 860:	b54d                	j	702 <vprintf+0x60>
    }
  }
}
 862:	70e6                	ld	ra,120(sp)
 864:	7446                	ld	s0,112(sp)
 866:	74a6                	ld	s1,104(sp)
 868:	7906                	ld	s2,96(sp)
 86a:	69e6                	ld	s3,88(sp)
 86c:	6a46                	ld	s4,80(sp)
 86e:	6aa6                	ld	s5,72(sp)
 870:	6b06                	ld	s6,64(sp)
 872:	7be2                	ld	s7,56(sp)
 874:	7c42                	ld	s8,48(sp)
 876:	7ca2                	ld	s9,40(sp)
 878:	7d02                	ld	s10,32(sp)
 87a:	6de2                	ld	s11,24(sp)
 87c:	6109                	addi	sp,sp,128
 87e:	8082                	ret

0000000000000880 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 880:	715d                	addi	sp,sp,-80
 882:	ec06                	sd	ra,24(sp)
 884:	e822                	sd	s0,16(sp)
 886:	1000                	addi	s0,sp,32
 888:	e010                	sd	a2,0(s0)
 88a:	e414                	sd	a3,8(s0)
 88c:	e818                	sd	a4,16(s0)
 88e:	ec1c                	sd	a5,24(s0)
 890:	03043023          	sd	a6,32(s0)
 894:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 898:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 89c:	8622                	mv	a2,s0
 89e:	00000097          	auipc	ra,0x0
 8a2:	e04080e7          	jalr	-508(ra) # 6a2 <vprintf>
}
 8a6:	60e2                	ld	ra,24(sp)
 8a8:	6442                	ld	s0,16(sp)
 8aa:	6161                	addi	sp,sp,80
 8ac:	8082                	ret

00000000000008ae <printf>:

void
printf(const char *fmt, ...)
{
 8ae:	711d                	addi	sp,sp,-96
 8b0:	ec06                	sd	ra,24(sp)
 8b2:	e822                	sd	s0,16(sp)
 8b4:	1000                	addi	s0,sp,32
 8b6:	e40c                	sd	a1,8(s0)
 8b8:	e810                	sd	a2,16(s0)
 8ba:	ec14                	sd	a3,24(s0)
 8bc:	f018                	sd	a4,32(s0)
 8be:	f41c                	sd	a5,40(s0)
 8c0:	03043823          	sd	a6,48(s0)
 8c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c8:	00840613          	addi	a2,s0,8
 8cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d0:	85aa                	mv	a1,a0
 8d2:	4505                	li	a0,1
 8d4:	00000097          	auipc	ra,0x0
 8d8:	dce080e7          	jalr	-562(ra) # 6a2 <vprintf>
}
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6442                	ld	s0,16(sp)
 8e0:	6125                	addi	sp,sp,96
 8e2:	8082                	ret

00000000000008e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e4:	1141                	addi	sp,sp,-16
 8e6:	e422                	sd	s0,8(sp)
 8e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	00000797          	auipc	a5,0x0
 8f2:	7127b783          	ld	a5,1810(a5) # 1000 <freep>
 8f6:	a02d                	j	920 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f8:	4618                	lw	a4,8(a2)
 8fa:	9f2d                	addw	a4,a4,a1
 8fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	6310                	ld	a2,0(a4)
 904:	a83d                	j	942 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 906:	ff852703          	lw	a4,-8(a0)
 90a:	9f31                	addw	a4,a4,a2
 90c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 90e:	ff053683          	ld	a3,-16(a0)
 912:	a091                	j	956 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	6398                	ld	a4,0(a5)
 916:	00e7e463          	bltu	a5,a4,91e <free+0x3a>
 91a:	00e6ea63          	bltu	a3,a4,92e <free+0x4a>
{
 91e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 920:	fed7fae3          	bgeu	a5,a3,914 <free+0x30>
 924:	6398                	ld	a4,0(a5)
 926:	00e6e463          	bltu	a3,a4,92e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	fee7eae3          	bltu	a5,a4,91e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 92e:	ff852583          	lw	a1,-8(a0)
 932:	6390                	ld	a2,0(a5)
 934:	02059813          	slli	a6,a1,0x20
 938:	01c85713          	srli	a4,a6,0x1c
 93c:	9736                	add	a4,a4,a3
 93e:	fae60de3          	beq	a2,a4,8f8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 942:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 946:	4790                	lw	a2,8(a5)
 948:	02061593          	slli	a1,a2,0x20
 94c:	01c5d713          	srli	a4,a1,0x1c
 950:	973e                	add	a4,a4,a5
 952:	fae68ae3          	beq	a3,a4,906 <free+0x22>
    p->s.ptr = bp->s.ptr;
 956:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
}
 960:	6422                	ld	s0,8(sp)
 962:	0141                	addi	sp,sp,16
 964:	8082                	ret

0000000000000966 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 966:	7139                	addi	sp,sp,-64
 968:	fc06                	sd	ra,56(sp)
 96a:	f822                	sd	s0,48(sp)
 96c:	f426                	sd	s1,40(sp)
 96e:	f04a                	sd	s2,32(sp)
 970:	ec4e                	sd	s3,24(sp)
 972:	e852                	sd	s4,16(sp)
 974:	e456                	sd	s5,8(sp)
 976:	e05a                	sd	s6,0(sp)
 978:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97a:	02051493          	slli	s1,a0,0x20
 97e:	9081                	srli	s1,s1,0x20
 980:	04bd                	addi	s1,s1,15
 982:	8091                	srli	s1,s1,0x4
 984:	0014899b          	addiw	s3,s1,1
 988:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 98a:	00000517          	auipc	a0,0x0
 98e:	67653503          	ld	a0,1654(a0) # 1000 <freep>
 992:	c515                	beqz	a0,9be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 994:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 996:	4798                	lw	a4,8(a5)
 998:	02977f63          	bgeu	a4,s1,9d6 <malloc+0x70>
 99c:	8a4e                	mv	s4,s3
 99e:	0009871b          	sext.w	a4,s3
 9a2:	6685                	lui	a3,0x1
 9a4:	00d77363          	bgeu	a4,a3,9aa <malloc+0x44>
 9a8:	6a05                	lui	s4,0x1
 9aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b2:	00000917          	auipc	s2,0x0
 9b6:	64e90913          	addi	s2,s2,1614 # 1000 <freep>
  if(p == (char*)-1)
 9ba:	5afd                	li	s5,-1
 9bc:	a895                	j	a30 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9be:	00001797          	auipc	a5,0x1
 9c2:	a5278793          	addi	a5,a5,-1454 # 1410 <base>
 9c6:	00000717          	auipc	a4,0x0
 9ca:	62f73d23          	sd	a5,1594(a4) # 1000 <freep>
 9ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d4:	b7e1                	j	99c <malloc+0x36>
      if(p->s.size == nunits)
 9d6:	02e48c63          	beq	s1,a4,a0e <malloc+0xa8>
        p->s.size -= nunits;
 9da:	4137073b          	subw	a4,a4,s3
 9de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e0:	02071693          	slli	a3,a4,0x20
 9e4:	01c6d713          	srli	a4,a3,0x1c
 9e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ee:	00000717          	auipc	a4,0x0
 9f2:	60a73923          	sd	a0,1554(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9fa:	70e2                	ld	ra,56(sp)
 9fc:	7442                	ld	s0,48(sp)
 9fe:	74a2                	ld	s1,40(sp)
 a00:	7902                	ld	s2,32(sp)
 a02:	69e2                	ld	s3,24(sp)
 a04:	6a42                	ld	s4,16(sp)
 a06:	6aa2                	ld	s5,8(sp)
 a08:	6b02                	ld	s6,0(sp)
 a0a:	6121                	addi	sp,sp,64
 a0c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a0e:	6398                	ld	a4,0(a5)
 a10:	e118                	sd	a4,0(a0)
 a12:	bff1                	j	9ee <malloc+0x88>
  hp->s.size = nu;
 a14:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a18:	0541                	addi	a0,a0,16
 a1a:	00000097          	auipc	ra,0x0
 a1e:	eca080e7          	jalr	-310(ra) # 8e4 <free>
  return freep;
 a22:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a26:	d971                	beqz	a0,9fa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a2a:	4798                	lw	a4,8(a5)
 a2c:	fa9775e3          	bgeu	a4,s1,9d6 <malloc+0x70>
    if(p == freep)
 a30:	00093703          	ld	a4,0(s2)
 a34:	853e                	mv	a0,a5
 a36:	fef719e3          	bne	a4,a5,a28 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a3a:	8552                	mv	a0,s4
 a3c:	00000097          	auipc	ra,0x0
 a40:	b70080e7          	jalr	-1168(ra) # 5ac <sbrk>
  if(p == (char*)-1)
 a44:	fd5518e3          	bne	a0,s5,a14 <malloc+0xae>
        return 0;
 a48:	4501                	li	a0,0
 a4a:	bf45                	j	9fa <malloc+0x94>
