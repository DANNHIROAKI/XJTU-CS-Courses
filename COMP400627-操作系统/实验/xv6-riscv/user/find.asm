
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <noSpace>:
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

char* noSpace(char* dir)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
static char newDir[DIRSIZ + 1];
int space = 0;
int buf = 0;
char* p = dir + strlen(dir) - 1;
  10:	00000097          	auipc	ra,0x0
  14:	346080e7          	jalr	838(ra) # 356 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	17fd                	addi	a5,a5,-1
  20:	97a6                	add	a5,a5,s1
int space = 0;
  22:	4701                	li	a4,0
while (p >= dir && *p == ' ') {
  24:	02000613          	li	a2,32
  28:	0097ea63          	bltu	a5,s1,3c <noSpace+0x3c>
  2c:	0007c683          	lbu	a3,0(a5)
  30:	00c69663          	bne	a3,a2,3c <noSpace+0x3c>
++space;
  34:	2705                	addiw	a4,a4,1
--p;
  36:	17fd                	addi	a5,a5,-1
while (p >= dir && *p == ' ') {
  38:	fe97fae3          	bgeu	a5,s1,2c <noSpace+0x2c>
}
buf = DIRSIZ - space;
  3c:	4939                	li	s2,14
  3e:	40e9093b          	subw	s2,s2,a4
memmove(newDir, dir, buf);
  42:	00001997          	auipc	s3,0x1
  46:	fce98993          	addi	s3,s3,-50 # 1010 <newDir.0>
  4a:	864a                	mv	a2,s2
  4c:	85a6                	mv	a1,s1
  4e:	854e                	mv	a0,s3
  50:	00000097          	auipc	ra,0x0
  54:	478080e7          	jalr	1144(ra) # 4c8 <memmove>
newDir[buf] = 0;
  58:	994e                	add	s2,s2,s3
  5a:	00090023          	sb	zero,0(s2)
return newDir;
}
  5e:	854e                	mv	a0,s3
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret

000000000000006e <find>:

void find(char* dir, char* name)
{
  6e:	d8010113          	addi	sp,sp,-640
  72:	26113c23          	sd	ra,632(sp)
  76:	26813823          	sd	s0,624(sp)
  7a:	26913423          	sd	s1,616(sp)
  7e:	27213023          	sd	s2,608(sp)
  82:	25313c23          	sd	s3,600(sp)
  86:	25413823          	sd	s4,592(sp)
  8a:	25513423          	sd	s5,584(sp)
  8e:	25613023          	sd	s6,576(sp)
  92:	23713c23          	sd	s7,568(sp)
  96:	23813823          	sd	s8,560(sp)
  9a:	0500                	addi	s0,sp,640
  9c:	89aa                	mv	s3,a0
  9e:	892e                	mv	s2,a1
char buf[512], *p;
int fd;
struct dirent de;
struct stat st;

fd = open(dir, 0);
  a0:	4581                	li	a1,0
  a2:	00000097          	auipc	ra,0x0
  a6:	518080e7          	jalr	1304(ra) # 5ba <open>
if (fd < 0) {
  aa:	06054463          	bltz	a0,112 <find+0xa4>
  ae:	84aa                	mv	s1,a0
fprintf(2, "find: cannot open %s\n", dir);
return;
}

if (fstat(fd, &st) < 0) {
  b0:	d8840593          	addi	a1,s0,-632
  b4:	00000097          	auipc	ra,0x0
  b8:	51e080e7          	jalr	1310(ra) # 5d2 <fstat>
  bc:	06054663          	bltz	a0,128 <find+0xba>
fprintf(2, "find: cannot fstat %s\n", dir);
close(fd);
return;
}

if (st.type == T_DEVICE || st.type == T_FILE) {
  c0:	d9041783          	lh	a5,-624(s0)
  c4:	ffe7871b          	addiw	a4,a5,-2
  c8:	1742                	slli	a4,a4,0x30
  ca:	9341                	srli	a4,a4,0x30
  cc:	4685                	li	a3,1
  ce:	06e6fd63          	bgeu	a3,a4,148 <find+0xda>
printf("find: not a directory value!\n");
close(fd);
} else if (st.type == T_DIR) {
  d2:	2781                	sext.w	a5,a5
  d4:	4705                	li	a4,1
  d6:	08e78763          	beq	a5,a4,164 <find+0xf6>
               break;
       }
   }
}
}
close(fd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	4c6080e7          	jalr	1222(ra) # 5a2 <close>
}
  e4:	27813083          	ld	ra,632(sp)
  e8:	27013403          	ld	s0,624(sp)
  ec:	26813483          	ld	s1,616(sp)
  f0:	26013903          	ld	s2,608(sp)
  f4:	25813983          	ld	s3,600(sp)
  f8:	25013a03          	ld	s4,592(sp)
  fc:	24813a83          	ld	s5,584(sp)
 100:	24013b03          	ld	s6,576(sp)
 104:	23813b83          	ld	s7,568(sp)
 108:	23013c03          	ld	s8,560(sp)
 10c:	28010113          	addi	sp,sp,640
 110:	8082                	ret
fprintf(2, "find: cannot open %s\n", dir);
 112:	864e                	mv	a2,s3
 114:	00001597          	auipc	a1,0x1
 118:	99c58593          	addi	a1,a1,-1636 # ab0 <malloc+0xf4>
 11c:	4509                	li	a0,2
 11e:	00000097          	auipc	ra,0x0
 122:	7b8080e7          	jalr	1976(ra) # 8d6 <fprintf>
return;
 126:	bf7d                	j	e4 <find+0x76>
fprintf(2, "find: cannot fstat %s\n", dir);
 128:	864e                	mv	a2,s3
 12a:	00001597          	auipc	a1,0x1
 12e:	99e58593          	addi	a1,a1,-1634 # ac8 <malloc+0x10c>
 132:	4509                	li	a0,2
 134:	00000097          	auipc	ra,0x0
 138:	7a2080e7          	jalr	1954(ra) # 8d6 <fprintf>
close(fd);
 13c:	8526                	mv	a0,s1
 13e:	00000097          	auipc	ra,0x0
 142:	464080e7          	jalr	1124(ra) # 5a2 <close>
return;
 146:	bf79                	j	e4 <find+0x76>
printf("find: not a directory value!\n");
 148:	00001517          	auipc	a0,0x1
 14c:	99850513          	addi	a0,a0,-1640 # ae0 <malloc+0x124>
 150:	00000097          	auipc	ra,0x0
 154:	7b4080e7          	jalr	1972(ra) # 904 <printf>
close(fd);
 158:	8526                	mv	a0,s1
 15a:	00000097          	auipc	ra,0x0
 15e:	448080e7          	jalr	1096(ra) # 5a2 <close>
 162:	bfa5                	j	da <find+0x6c>
if (strlen(dir) + 1 + DIRSIZ + 1 > sizeof buf) {
 164:	854e                	mv	a0,s3
 166:	00000097          	auipc	ra,0x0
 16a:	1f0080e7          	jalr	496(ra) # 356 <strlen>
 16e:	2541                	addiw	a0,a0,16
 170:	20000793          	li	a5,512
 174:	00a7fb63          	bgeu	a5,a0,18a <find+0x11c>
   printf("ls: path too long\n");
 178:	00001517          	auipc	a0,0x1
 17c:	98850513          	addi	a0,a0,-1656 # b00 <malloc+0x144>
 180:	00000097          	auipc	ra,0x0
 184:	784080e7          	jalr	1924(ra) # 904 <printf>
 188:	bf89                	j	da <find+0x6c>
   strcpy(buf, dir);
 18a:	85ce                	mv	a1,s3
 18c:	db040513          	addi	a0,s0,-592
 190:	00000097          	auipc	ra,0x0
 194:	17e080e7          	jalr	382(ra) # 30e <strcpy>
   p = buf + strlen(buf);
 198:	db040513          	addi	a0,s0,-592
 19c:	00000097          	auipc	ra,0x0
 1a0:	1ba080e7          	jalr	442(ra) # 356 <strlen>
 1a4:	1502                	slli	a0,a0,0x20
 1a6:	9101                	srli	a0,a0,0x20
 1a8:	db040793          	addi	a5,s0,-592
 1ac:	00a789b3          	add	s3,a5,a0
   *p++ = '/';
 1b0:	00198b13          	addi	s6,s3,1
 1b4:	02f00793          	li	a5,47
 1b8:	00f98023          	sb	a5,0(s3)
   for (int readBytes = read(fd, &de, sizeof(de)); readBytes == sizeof de; readBytes = read(fd, &de, sizeof(de))) {
 1bc:	4641                	li	a2,16
 1be:	da040593          	addi	a1,s0,-608
 1c2:	8526                	mv	a0,s1
 1c4:	00000097          	auipc	ra,0x0
 1c8:	3ce080e7          	jalr	974(ra) # 592 <read>
 1cc:	47c1                	li	a5,16
 1ce:	f0f516e3          	bne	a0,a5,da <find+0x6c>
       if (strcmp(".", noSpace(de.name)) == 0 || strcmp("..", noSpace(de.name)) == 0) {
 1d2:	00001a17          	auipc	s4,0x1
 1d6:	946a0a13          	addi	s4,s4,-1722 # b18 <malloc+0x15c>
 1da:	00001a97          	auipc	s5,0x1
 1de:	946a8a93          	addi	s5,s5,-1722 # b20 <malloc+0x164>
       switch (st.type) {
 1e2:	4b85                	li	s7,1
                   printf("%s\n", buf);
 1e4:	00001c17          	auipc	s8,0x1
 1e8:	95cc0c13          	addi	s8,s8,-1700 # b40 <malloc+0x184>
 1ec:	a835                	j	228 <find+0x1ba>
           printf("find: cannot stat '%s'\n", buf);
 1ee:	db040593          	addi	a1,s0,-592
 1f2:	00001517          	auipc	a0,0x1
 1f6:	93650513          	addi	a0,a0,-1738 # b28 <malloc+0x16c>
 1fa:	00000097          	auipc	ra,0x0
 1fe:	70a080e7          	jalr	1802(ra) # 904 <printf>
           continue;
 202:	a801                	j	212 <find+0x1a4>
               find(buf, name);
 204:	85ca                	mv	a1,s2
 206:	db040513          	addi	a0,s0,-592
 20a:	00000097          	auipc	ra,0x0
 20e:	e64080e7          	jalr	-412(ra) # 6e <find>
   for (int readBytes = read(fd, &de, sizeof(de)); readBytes == sizeof de; readBytes = read(fd, &de, sizeof(de))) {
 212:	4641                	li	a2,16
 214:	da040593          	addi	a1,s0,-608
 218:	8526                	mv	a0,s1
 21a:	00000097          	auipc	ra,0x0
 21e:	378080e7          	jalr	888(ra) # 592 <read>
 222:	47c1                	li	a5,16
 224:	eaf51be3          	bne	a0,a5,da <find+0x6c>
       if (de.inum == 0)
 228:	da045783          	lhu	a5,-608(s0)
 22c:	d3fd                	beqz	a5,212 <find+0x1a4>
       if (strcmp(".", noSpace(de.name)) == 0 || strcmp("..", noSpace(de.name)) == 0) {
 22e:	da240513          	addi	a0,s0,-606
 232:	00000097          	auipc	ra,0x0
 236:	dce080e7          	jalr	-562(ra) # 0 <noSpace>
 23a:	85aa                	mv	a1,a0
 23c:	8552                	mv	a0,s4
 23e:	00000097          	auipc	ra,0x0
 242:	0ec080e7          	jalr	236(ra) # 32a <strcmp>
 246:	d571                	beqz	a0,212 <find+0x1a4>
 248:	da240513          	addi	a0,s0,-606
 24c:	00000097          	auipc	ra,0x0
 250:	db4080e7          	jalr	-588(ra) # 0 <noSpace>
 254:	85aa                	mv	a1,a0
 256:	8556                	mv	a0,s5
 258:	00000097          	auipc	ra,0x0
 25c:	0d2080e7          	jalr	210(ra) # 32a <strcmp>
 260:	d94d                	beqz	a0,212 <find+0x1a4>
       memmove(p, de.name, DIRSIZ);
 262:	4639                	li	a2,14
 264:	da240593          	addi	a1,s0,-606
 268:	855a                	mv	a0,s6
 26a:	00000097          	auipc	ra,0x0
 26e:	25e080e7          	jalr	606(ra) # 4c8 <memmove>
       p[DIRSIZ] = 0;
 272:	000987a3          	sb	zero,15(s3)
       if (stat(buf, &st) < 0) {
 276:	d8840593          	addi	a1,s0,-632
 27a:	db040513          	addi	a0,s0,-592
 27e:	00000097          	auipc	ra,0x0
 282:	1bc080e7          	jalr	444(ra) # 43a <stat>
 286:	f60544e3          	bltz	a0,1ee <find+0x180>
       switch (st.type) {
 28a:	d9041783          	lh	a5,-624(s0)
 28e:	f7778be3          	beq	a5,s7,204 <find+0x196>
               if (strcmp(name, noSpace(de.name)) == 0) {
 292:	da240513          	addi	a0,s0,-606
 296:	00000097          	auipc	ra,0x0
 29a:	d6a080e7          	jalr	-662(ra) # 0 <noSpace>
 29e:	85aa                	mv	a1,a0
 2a0:	854a                	mv	a0,s2
 2a2:	00000097          	auipc	ra,0x0
 2a6:	088080e7          	jalr	136(ra) # 32a <strcmp>
 2aa:	f525                	bnez	a0,212 <find+0x1a4>
                   printf("%s\n", buf);
 2ac:	db040593          	addi	a1,s0,-592
 2b0:	8562                	mv	a0,s8
 2b2:	00000097          	auipc	ra,0x0
 2b6:	652080e7          	jalr	1618(ra) # 904 <printf>
 2ba:	bfa1                	j	212 <find+0x1a4>

00000000000002bc <main>:

int main(int argc, char* argv[])
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
switch (argc) {
 2c4:	470d                	li	a4,3
 2c6:	00e50f63          	beq	a0,a4,2e4 <main+0x28>
case 3:
   find(argv[1], argv[2]);
   break;
default:
   printf("Wrong directory or file name!\n");
 2ca:	00001517          	auipc	a0,0x1
 2ce:	87e50513          	addi	a0,a0,-1922 # b48 <malloc+0x18c>
 2d2:	00000097          	auipc	ra,0x0
 2d6:	632080e7          	jalr	1586(ra) # 904 <printf>
   break;
}
exit(0);
 2da:	4501                	li	a0,0
 2dc:	00000097          	auipc	ra,0x0
 2e0:	29e080e7          	jalr	670(ra) # 57a <exit>
 2e4:	87ae                	mv	a5,a1
   find(argv[1], argv[2]);
 2e6:	698c                	ld	a1,16(a1)
 2e8:	6788                	ld	a0,8(a5)
 2ea:	00000097          	auipc	ra,0x0
 2ee:	d84080e7          	jalr	-636(ra) # 6e <find>
   break;
 2f2:	b7e5                	j	2da <main+0x1e>

00000000000002f4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2fc:	00000097          	auipc	ra,0x0
 300:	fc0080e7          	jalr	-64(ra) # 2bc <main>
  exit(0);
 304:	4501                	li	a0,0
 306:	00000097          	auipc	ra,0x0
 30a:	274080e7          	jalr	628(ra) # 57a <exit>

000000000000030e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 314:	87aa                	mv	a5,a0
 316:	0585                	addi	a1,a1,1
 318:	0785                	addi	a5,a5,1
 31a:	fff5c703          	lbu	a4,-1(a1)
 31e:	fee78fa3          	sb	a4,-1(a5)
 322:	fb75                	bnez	a4,316 <strcpy+0x8>
    ;
  return os;
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e422                	sd	s0,8(sp)
 32e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 330:	00054783          	lbu	a5,0(a0)
 334:	cb91                	beqz	a5,348 <strcmp+0x1e>
 336:	0005c703          	lbu	a4,0(a1)
 33a:	00f71763          	bne	a4,a5,348 <strcmp+0x1e>
    p++, q++;
 33e:	0505                	addi	a0,a0,1
 340:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 342:	00054783          	lbu	a5,0(a0)
 346:	fbe5                	bnez	a5,336 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 348:	0005c503          	lbu	a0,0(a1)
}
 34c:	40a7853b          	subw	a0,a5,a0
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <strlen>:

uint
strlen(const char *s)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 35c:	00054783          	lbu	a5,0(a0)
 360:	cf91                	beqz	a5,37c <strlen+0x26>
 362:	0505                	addi	a0,a0,1
 364:	87aa                	mv	a5,a0
 366:	4685                	li	a3,1
 368:	9e89                	subw	a3,a3,a0
 36a:	00f6853b          	addw	a0,a3,a5
 36e:	0785                	addi	a5,a5,1
 370:	fff7c703          	lbu	a4,-1(a5)
 374:	fb7d                	bnez	a4,36a <strlen+0x14>
    ;
  return n;
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
  for(n = 0; s[n]; n++)
 37c:	4501                	li	a0,0
 37e:	bfe5                	j	376 <strlen+0x20>

0000000000000380 <memset>:

void*
memset(void *dst, int c, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 386:	ca19                	beqz	a2,39c <memset+0x1c>
 388:	87aa                	mv	a5,a0
 38a:	1602                	slli	a2,a2,0x20
 38c:	9201                	srli	a2,a2,0x20
 38e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 392:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 396:	0785                	addi	a5,a5,1
 398:	fee79de3          	bne	a5,a4,392 <memset+0x12>
  }
  return dst;
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <strchr>:

char*
strchr(const char *s, char c)
{
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e422                	sd	s0,8(sp)
 3a6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3a8:	00054783          	lbu	a5,0(a0)
 3ac:	cb99                	beqz	a5,3c2 <strchr+0x20>
    if(*s == c)
 3ae:	00f58763          	beq	a1,a5,3bc <strchr+0x1a>
  for(; *s; s++)
 3b2:	0505                	addi	a0,a0,1
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	fbfd                	bnez	a5,3ae <strchr+0xc>
      return (char*)s;
  return 0;
 3ba:	4501                	li	a0,0
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
  return 0;
 3c2:	4501                	li	a0,0
 3c4:	bfe5                	j	3bc <strchr+0x1a>

00000000000003c6 <gets>:

char*
gets(char *buf, int max)
{
 3c6:	711d                	addi	sp,sp,-96
 3c8:	ec86                	sd	ra,88(sp)
 3ca:	e8a2                	sd	s0,80(sp)
 3cc:	e4a6                	sd	s1,72(sp)
 3ce:	e0ca                	sd	s2,64(sp)
 3d0:	fc4e                	sd	s3,56(sp)
 3d2:	f852                	sd	s4,48(sp)
 3d4:	f456                	sd	s5,40(sp)
 3d6:	f05a                	sd	s6,32(sp)
 3d8:	ec5e                	sd	s7,24(sp)
 3da:	1080                	addi	s0,sp,96
 3dc:	8baa                	mv	s7,a0
 3de:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e0:	892a                	mv	s2,a0
 3e2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e4:	4aa9                	li	s5,10
 3e6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3e8:	89a6                	mv	s3,s1
 3ea:	2485                	addiw	s1,s1,1
 3ec:	0344d863          	bge	s1,s4,41c <gets+0x56>
    cc = read(0, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	faf40593          	addi	a1,s0,-81
 3f6:	4501                	li	a0,0
 3f8:	00000097          	auipc	ra,0x0
 3fc:	19a080e7          	jalr	410(ra) # 592 <read>
    if(cc < 1)
 400:	00a05e63          	blez	a0,41c <gets+0x56>
    buf[i++] = c;
 404:	faf44783          	lbu	a5,-81(s0)
 408:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 40c:	01578763          	beq	a5,s5,41a <gets+0x54>
 410:	0905                	addi	s2,s2,1
 412:	fd679be3          	bne	a5,s6,3e8 <gets+0x22>
  for(i=0; i+1 < max; ){
 416:	89a6                	mv	s3,s1
 418:	a011                	j	41c <gets+0x56>
 41a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 41c:	99de                	add	s3,s3,s7
 41e:	00098023          	sb	zero,0(s3)
  return buf;
}
 422:	855e                	mv	a0,s7
 424:	60e6                	ld	ra,88(sp)
 426:	6446                	ld	s0,80(sp)
 428:	64a6                	ld	s1,72(sp)
 42a:	6906                	ld	s2,64(sp)
 42c:	79e2                	ld	s3,56(sp)
 42e:	7a42                	ld	s4,48(sp)
 430:	7aa2                	ld	s5,40(sp)
 432:	7b02                	ld	s6,32(sp)
 434:	6be2                	ld	s7,24(sp)
 436:	6125                	addi	sp,sp,96
 438:	8082                	ret

000000000000043a <stat>:

int
stat(const char *n, struct stat *st)
{
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	e426                	sd	s1,8(sp)
 442:	e04a                	sd	s2,0(sp)
 444:	1000                	addi	s0,sp,32
 446:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 448:	4581                	li	a1,0
 44a:	00000097          	auipc	ra,0x0
 44e:	170080e7          	jalr	368(ra) # 5ba <open>
  if(fd < 0)
 452:	02054563          	bltz	a0,47c <stat+0x42>
 456:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 458:	85ca                	mv	a1,s2
 45a:	00000097          	auipc	ra,0x0
 45e:	178080e7          	jalr	376(ra) # 5d2 <fstat>
 462:	892a                	mv	s2,a0
  close(fd);
 464:	8526                	mv	a0,s1
 466:	00000097          	auipc	ra,0x0
 46a:	13c080e7          	jalr	316(ra) # 5a2 <close>
  return r;
}
 46e:	854a                	mv	a0,s2
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	64a2                	ld	s1,8(sp)
 476:	6902                	ld	s2,0(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret
    return -1;
 47c:	597d                	li	s2,-1
 47e:	bfc5                	j	46e <stat+0x34>

0000000000000480 <atoi>:

int
atoi(const char *s)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 486:	00054683          	lbu	a3,0(a0)
 48a:	fd06879b          	addiw	a5,a3,-48
 48e:	0ff7f793          	zext.b	a5,a5
 492:	4625                	li	a2,9
 494:	02f66863          	bltu	a2,a5,4c4 <atoi+0x44>
 498:	872a                	mv	a4,a0
  n = 0;
 49a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 49c:	0705                	addi	a4,a4,1
 49e:	0025179b          	slliw	a5,a0,0x2
 4a2:	9fa9                	addw	a5,a5,a0
 4a4:	0017979b          	slliw	a5,a5,0x1
 4a8:	9fb5                	addw	a5,a5,a3
 4aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4ae:	00074683          	lbu	a3,0(a4)
 4b2:	fd06879b          	addiw	a5,a3,-48
 4b6:	0ff7f793          	zext.b	a5,a5
 4ba:	fef671e3          	bgeu	a2,a5,49c <atoi+0x1c>
  return n;
}
 4be:	6422                	ld	s0,8(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret
  n = 0;
 4c4:	4501                	li	a0,0
 4c6:	bfe5                	j	4be <atoi+0x3e>

00000000000004c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e422                	sd	s0,8(sp)
 4cc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ce:	02b57463          	bgeu	a0,a1,4f6 <memmove+0x2e>
    while(n-- > 0)
 4d2:	00c05f63          	blez	a2,4f0 <memmove+0x28>
 4d6:	1602                	slli	a2,a2,0x20
 4d8:	9201                	srli	a2,a2,0x20
 4da:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4de:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e0:	0585                	addi	a1,a1,1
 4e2:	0705                	addi	a4,a4,1
 4e4:	fff5c683          	lbu	a3,-1(a1)
 4e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ec:	fee79ae3          	bne	a5,a4,4e0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret
    dst += n;
 4f6:	00c50733          	add	a4,a0,a2
    src += n;
 4fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4fc:	fec05ae3          	blez	a2,4f0 <memmove+0x28>
 500:	fff6079b          	addiw	a5,a2,-1
 504:	1782                	slli	a5,a5,0x20
 506:	9381                	srli	a5,a5,0x20
 508:	fff7c793          	not	a5,a5
 50c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 50e:	15fd                	addi	a1,a1,-1
 510:	177d                	addi	a4,a4,-1
 512:	0005c683          	lbu	a3,0(a1)
 516:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 51a:	fee79ae3          	bne	a5,a4,50e <memmove+0x46>
 51e:	bfc9                	j	4f0 <memmove+0x28>

0000000000000520 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 520:	1141                	addi	sp,sp,-16
 522:	e422                	sd	s0,8(sp)
 524:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 526:	ca05                	beqz	a2,556 <memcmp+0x36>
 528:	fff6069b          	addiw	a3,a2,-1
 52c:	1682                	slli	a3,a3,0x20
 52e:	9281                	srli	a3,a3,0x20
 530:	0685                	addi	a3,a3,1
 532:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 534:	00054783          	lbu	a5,0(a0)
 538:	0005c703          	lbu	a4,0(a1)
 53c:	00e79863          	bne	a5,a4,54c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 540:	0505                	addi	a0,a0,1
    p2++;
 542:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 544:	fed518e3          	bne	a0,a3,534 <memcmp+0x14>
  }
  return 0;
 548:	4501                	li	a0,0
 54a:	a019                	j	550 <memcmp+0x30>
      return *p1 - *p2;
 54c:	40e7853b          	subw	a0,a5,a4
}
 550:	6422                	ld	s0,8(sp)
 552:	0141                	addi	sp,sp,16
 554:	8082                	ret
  return 0;
 556:	4501                	li	a0,0
 558:	bfe5                	j	550 <memcmp+0x30>

000000000000055a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 55a:	1141                	addi	sp,sp,-16
 55c:	e406                	sd	ra,8(sp)
 55e:	e022                	sd	s0,0(sp)
 560:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 562:	00000097          	auipc	ra,0x0
 566:	f66080e7          	jalr	-154(ra) # 4c8 <memmove>
}
 56a:	60a2                	ld	ra,8(sp)
 56c:	6402                	ld	s0,0(sp)
 56e:	0141                	addi	sp,sp,16
 570:	8082                	ret

0000000000000572 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 572:	4885                	li	a7,1
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <exit>:
.global exit
exit:
 li a7, SYS_exit
 57a:	4889                	li	a7,2
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <wait>:
.global wait
wait:
 li a7, SYS_wait
 582:	488d                	li	a7,3
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 58a:	4891                	li	a7,4
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <read>:
.global read
read:
 li a7, SYS_read
 592:	4895                	li	a7,5
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <write>:
.global write
write:
 li a7, SYS_write
 59a:	48c1                	li	a7,16
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <close>:
.global close
close:
 li a7, SYS_close
 5a2:	48d5                	li	a7,21
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 5aa:	4899                	li	a7,6
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b2:	489d                	li	a7,7
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <open>:
.global open
open:
 li a7, SYS_open
 5ba:	48bd                	li	a7,15
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c2:	48c5                	li	a7,17
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ca:	48c9                	li	a7,18
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d2:	48a1                	li	a7,8
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <link>:
.global link
link:
 li a7, SYS_link
 5da:	48cd                	li	a7,19
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e2:	48d1                	li	a7,20
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ea:	48a5                	li	a7,9
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f2:	48a9                	li	a7,10
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5fa:	48ad                	li	a7,11
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 602:	48b1                	li	a7,12
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 60a:	48b5                	li	a7,13
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 612:	48b9                	li	a7,14
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 61a:	48d9                	li	a7,22
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 622:	48dd                	li	a7,23
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62a:	1101                	addi	sp,sp,-32
 62c:	ec06                	sd	ra,24(sp)
 62e:	e822                	sd	s0,16(sp)
 630:	1000                	addi	s0,sp,32
 632:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 636:	4605                	li	a2,1
 638:	fef40593          	addi	a1,s0,-17
 63c:	00000097          	auipc	ra,0x0
 640:	f5e080e7          	jalr	-162(ra) # 59a <write>
}
 644:	60e2                	ld	ra,24(sp)
 646:	6442                	ld	s0,16(sp)
 648:	6105                	addi	sp,sp,32
 64a:	8082                	ret

000000000000064c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64c:	7139                	addi	sp,sp,-64
 64e:	fc06                	sd	ra,56(sp)
 650:	f822                	sd	s0,48(sp)
 652:	f426                	sd	s1,40(sp)
 654:	f04a                	sd	s2,32(sp)
 656:	ec4e                	sd	s3,24(sp)
 658:	0080                	addi	s0,sp,64
 65a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65c:	c299                	beqz	a3,662 <printint+0x16>
 65e:	0805c963          	bltz	a1,6f0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 662:	2581                	sext.w	a1,a1
  neg = 0;
 664:	4881                	li	a7,0
 666:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 66c:	2601                	sext.w	a2,a2
 66e:	00000517          	auipc	a0,0x0
 672:	55a50513          	addi	a0,a0,1370 # bc8 <digits>
 676:	883a                	mv	a6,a4
 678:	2705                	addiw	a4,a4,1
 67a:	02c5f7bb          	remuw	a5,a1,a2
 67e:	1782                	slli	a5,a5,0x20
 680:	9381                	srli	a5,a5,0x20
 682:	97aa                	add	a5,a5,a0
 684:	0007c783          	lbu	a5,0(a5)
 688:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 68c:	0005879b          	sext.w	a5,a1
 690:	02c5d5bb          	divuw	a1,a1,a2
 694:	0685                	addi	a3,a3,1
 696:	fec7f0e3          	bgeu	a5,a2,676 <printint+0x2a>
  if(neg)
 69a:	00088c63          	beqz	a7,6b2 <printint+0x66>
    buf[i++] = '-';
 69e:	fd070793          	addi	a5,a4,-48
 6a2:	00878733          	add	a4,a5,s0
 6a6:	02d00793          	li	a5,45
 6aa:	fef70823          	sb	a5,-16(a4)
 6ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b2:	02e05863          	blez	a4,6e2 <printint+0x96>
 6b6:	fc040793          	addi	a5,s0,-64
 6ba:	00e78933          	add	s2,a5,a4
 6be:	fff78993          	addi	s3,a5,-1
 6c2:	99ba                	add	s3,s3,a4
 6c4:	377d                	addiw	a4,a4,-1
 6c6:	1702                	slli	a4,a4,0x20
 6c8:	9301                	srli	a4,a4,0x20
 6ca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ce:	fff94583          	lbu	a1,-1(s2)
 6d2:	8526                	mv	a0,s1
 6d4:	00000097          	auipc	ra,0x0
 6d8:	f56080e7          	jalr	-170(ra) # 62a <putc>
  while(--i >= 0)
 6dc:	197d                	addi	s2,s2,-1
 6de:	ff3918e3          	bne	s2,s3,6ce <printint+0x82>
}
 6e2:	70e2                	ld	ra,56(sp)
 6e4:	7442                	ld	s0,48(sp)
 6e6:	74a2                	ld	s1,40(sp)
 6e8:	7902                	ld	s2,32(sp)
 6ea:	69e2                	ld	s3,24(sp)
 6ec:	6121                	addi	sp,sp,64
 6ee:	8082                	ret
    x = -xx;
 6f0:	40b005bb          	negw	a1,a1
    neg = 1;
 6f4:	4885                	li	a7,1
    x = -xx;
 6f6:	bf85                	j	666 <printint+0x1a>

00000000000006f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6f8:	7119                	addi	sp,sp,-128
 6fa:	fc86                	sd	ra,120(sp)
 6fc:	f8a2                	sd	s0,112(sp)
 6fe:	f4a6                	sd	s1,104(sp)
 700:	f0ca                	sd	s2,96(sp)
 702:	ecce                	sd	s3,88(sp)
 704:	e8d2                	sd	s4,80(sp)
 706:	e4d6                	sd	s5,72(sp)
 708:	e0da                	sd	s6,64(sp)
 70a:	fc5e                	sd	s7,56(sp)
 70c:	f862                	sd	s8,48(sp)
 70e:	f466                	sd	s9,40(sp)
 710:	f06a                	sd	s10,32(sp)
 712:	ec6e                	sd	s11,24(sp)
 714:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 716:	0005c903          	lbu	s2,0(a1)
 71a:	18090f63          	beqz	s2,8b8 <vprintf+0x1c0>
 71e:	8aaa                	mv	s5,a0
 720:	8b32                	mv	s6,a2
 722:	00158493          	addi	s1,a1,1
  state = 0;
 726:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 728:	02500a13          	li	s4,37
 72c:	4c55                	li	s8,21
 72e:	00000c97          	auipc	s9,0x0
 732:	442c8c93          	addi	s9,s9,1090 # b70 <malloc+0x1b4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 736:	02800d93          	li	s11,40
  putc(fd, 'x');
 73a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73c:	00000b97          	auipc	s7,0x0
 740:	48cb8b93          	addi	s7,s7,1164 # bc8 <digits>
 744:	a839                	j	762 <vprintf+0x6a>
        putc(fd, c);
 746:	85ca                	mv	a1,s2
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	ee0080e7          	jalr	-288(ra) # 62a <putc>
 752:	a019                	j	758 <vprintf+0x60>
    } else if(state == '%'){
 754:	01498d63          	beq	s3,s4,76e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 758:	0485                	addi	s1,s1,1
 75a:	fff4c903          	lbu	s2,-1(s1)
 75e:	14090d63          	beqz	s2,8b8 <vprintf+0x1c0>
    if(state == 0){
 762:	fe0999e3          	bnez	s3,754 <vprintf+0x5c>
      if(c == '%'){
 766:	ff4910e3          	bne	s2,s4,746 <vprintf+0x4e>
        state = '%';
 76a:	89d2                	mv	s3,s4
 76c:	b7f5                	j	758 <vprintf+0x60>
      if(c == 'd'){
 76e:	11490c63          	beq	s2,s4,886 <vprintf+0x18e>
 772:	f9d9079b          	addiw	a5,s2,-99
 776:	0ff7f793          	zext.b	a5,a5
 77a:	10fc6e63          	bltu	s8,a5,896 <vprintf+0x19e>
 77e:	f9d9079b          	addiw	a5,s2,-99
 782:	0ff7f713          	zext.b	a4,a5
 786:	10ec6863          	bltu	s8,a4,896 <vprintf+0x19e>
 78a:	00271793          	slli	a5,a4,0x2
 78e:	97e6                	add	a5,a5,s9
 790:	439c                	lw	a5,0(a5)
 792:	97e6                	add	a5,a5,s9
 794:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 796:	008b0913          	addi	s2,s6,8
 79a:	4685                	li	a3,1
 79c:	4629                	li	a2,10
 79e:	000b2583          	lw	a1,0(s6)
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	ea8080e7          	jalr	-344(ra) # 64c <printint>
 7ac:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b765                	j	758 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b2:	008b0913          	addi	s2,s6,8
 7b6:	4681                	li	a3,0
 7b8:	4629                	li	a2,10
 7ba:	000b2583          	lw	a1,0(s6)
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e8c080e7          	jalr	-372(ra) # 64c <printint>
 7c8:	8b4a                	mv	s6,s2
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b771                	j	758 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ce:	008b0913          	addi	s2,s6,8
 7d2:	4681                	li	a3,0
 7d4:	866a                	mv	a2,s10
 7d6:	000b2583          	lw	a1,0(s6)
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e70080e7          	jalr	-400(ra) # 64c <printint>
 7e4:	8b4a                	mv	s6,s2
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bf85                	j	758 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7ea:	008b0793          	addi	a5,s6,8
 7ee:	f8f43423          	sd	a5,-120(s0)
 7f2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7f6:	03000593          	li	a1,48
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	e2e080e7          	jalr	-466(ra) # 62a <putc>
  putc(fd, 'x');
 804:	07800593          	li	a1,120
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	e20080e7          	jalr	-480(ra) # 62a <putc>
 812:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 814:	03c9d793          	srli	a5,s3,0x3c
 818:	97de                	add	a5,a5,s7
 81a:	0007c583          	lbu	a1,0(a5)
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	e0a080e7          	jalr	-502(ra) # 62a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 828:	0992                	slli	s3,s3,0x4
 82a:	397d                	addiw	s2,s2,-1
 82c:	fe0914e3          	bnez	s2,814 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 830:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 834:	4981                	li	s3,0
 836:	b70d                	j	758 <vprintf+0x60>
        s = va_arg(ap, char*);
 838:	008b0913          	addi	s2,s6,8
 83c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 840:	02098163          	beqz	s3,862 <vprintf+0x16a>
        while(*s != 0){
 844:	0009c583          	lbu	a1,0(s3)
 848:	c5ad                	beqz	a1,8b2 <vprintf+0x1ba>
          putc(fd, *s);
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	dde080e7          	jalr	-546(ra) # 62a <putc>
          s++;
 854:	0985                	addi	s3,s3,1
        while(*s != 0){
 856:	0009c583          	lbu	a1,0(s3)
 85a:	f9e5                	bnez	a1,84a <vprintf+0x152>
        s = va_arg(ap, char*);
 85c:	8b4a                	mv	s6,s2
      state = 0;
 85e:	4981                	li	s3,0
 860:	bde5                	j	758 <vprintf+0x60>
          s = "(null)";
 862:	00000997          	auipc	s3,0x0
 866:	30698993          	addi	s3,s3,774 # b68 <malloc+0x1ac>
        while(*s != 0){
 86a:	85ee                	mv	a1,s11
 86c:	bff9                	j	84a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 86e:	008b0913          	addi	s2,s6,8
 872:	000b4583          	lbu	a1,0(s6)
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	db2080e7          	jalr	-590(ra) # 62a <putc>
 880:	8b4a                	mv	s6,s2
      state = 0;
 882:	4981                	li	s3,0
 884:	bdd1                	j	758 <vprintf+0x60>
        putc(fd, c);
 886:	85d2                	mv	a1,s4
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	da0080e7          	jalr	-608(ra) # 62a <putc>
      state = 0;
 892:	4981                	li	s3,0
 894:	b5d1                	j	758 <vprintf+0x60>
        putc(fd, '%');
 896:	85d2                	mv	a1,s4
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	d90080e7          	jalr	-624(ra) # 62a <putc>
        putc(fd, c);
 8a2:	85ca                	mv	a1,s2
 8a4:	8556                	mv	a0,s5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	d84080e7          	jalr	-636(ra) # 62a <putc>
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	b565                	j	758 <vprintf+0x60>
        s = va_arg(ap, char*);
 8b2:	8b4a                	mv	s6,s2
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	b54d                	j	758 <vprintf+0x60>
    }
  }
}
 8b8:	70e6                	ld	ra,120(sp)
 8ba:	7446                	ld	s0,112(sp)
 8bc:	74a6                	ld	s1,104(sp)
 8be:	7906                	ld	s2,96(sp)
 8c0:	69e6                	ld	s3,88(sp)
 8c2:	6a46                	ld	s4,80(sp)
 8c4:	6aa6                	ld	s5,72(sp)
 8c6:	6b06                	ld	s6,64(sp)
 8c8:	7be2                	ld	s7,56(sp)
 8ca:	7c42                	ld	s8,48(sp)
 8cc:	7ca2                	ld	s9,40(sp)
 8ce:	7d02                	ld	s10,32(sp)
 8d0:	6de2                	ld	s11,24(sp)
 8d2:	6109                	addi	sp,sp,128
 8d4:	8082                	ret

00000000000008d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d6:	715d                	addi	sp,sp,-80
 8d8:	ec06                	sd	ra,24(sp)
 8da:	e822                	sd	s0,16(sp)
 8dc:	1000                	addi	s0,sp,32
 8de:	e010                	sd	a2,0(s0)
 8e0:	e414                	sd	a3,8(s0)
 8e2:	e818                	sd	a4,16(s0)
 8e4:	ec1c                	sd	a5,24(s0)
 8e6:	03043023          	sd	a6,32(s0)
 8ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f2:	8622                	mv	a2,s0
 8f4:	00000097          	auipc	ra,0x0
 8f8:	e04080e7          	jalr	-508(ra) # 6f8 <vprintf>
}
 8fc:	60e2                	ld	ra,24(sp)
 8fe:	6442                	ld	s0,16(sp)
 900:	6161                	addi	sp,sp,80
 902:	8082                	ret

0000000000000904 <printf>:

void
printf(const char *fmt, ...)
{
 904:	711d                	addi	sp,sp,-96
 906:	ec06                	sd	ra,24(sp)
 908:	e822                	sd	s0,16(sp)
 90a:	1000                	addi	s0,sp,32
 90c:	e40c                	sd	a1,8(s0)
 90e:	e810                	sd	a2,16(s0)
 910:	ec14                	sd	a3,24(s0)
 912:	f018                	sd	a4,32(s0)
 914:	f41c                	sd	a5,40(s0)
 916:	03043823          	sd	a6,48(s0)
 91a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	00840613          	addi	a2,s0,8
 922:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 926:	85aa                	mv	a1,a0
 928:	4505                	li	a0,1
 92a:	00000097          	auipc	ra,0x0
 92e:	dce080e7          	jalr	-562(ra) # 6f8 <vprintf>
}
 932:	60e2                	ld	ra,24(sp)
 934:	6442                	ld	s0,16(sp)
 936:	6125                	addi	sp,sp,96
 938:	8082                	ret

000000000000093a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93a:	1141                	addi	sp,sp,-16
 93c:	e422                	sd	s0,8(sp)
 93e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 940:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	00000797          	auipc	a5,0x0
 948:	6bc7b783          	ld	a5,1724(a5) # 1000 <freep>
 94c:	a02d                	j	976 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 94e:	4618                	lw	a4,8(a2)
 950:	9f2d                	addw	a4,a4,a1
 952:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 956:	6398                	ld	a4,0(a5)
 958:	6310                	ld	a2,0(a4)
 95a:	a83d                	j	998 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 95c:	ff852703          	lw	a4,-8(a0)
 960:	9f31                	addw	a4,a4,a2
 962:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 964:	ff053683          	ld	a3,-16(a0)
 968:	a091                	j	9ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96a:	6398                	ld	a4,0(a5)
 96c:	00e7e463          	bltu	a5,a4,974 <free+0x3a>
 970:	00e6ea63          	bltu	a3,a4,984 <free+0x4a>
{
 974:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 976:	fed7fae3          	bgeu	a5,a3,96a <free+0x30>
 97a:	6398                	ld	a4,0(a5)
 97c:	00e6e463          	bltu	a3,a4,984 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	fee7eae3          	bltu	a5,a4,974 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 984:	ff852583          	lw	a1,-8(a0)
 988:	6390                	ld	a2,0(a5)
 98a:	02059813          	slli	a6,a1,0x20
 98e:	01c85713          	srli	a4,a6,0x1c
 992:	9736                	add	a4,a4,a3
 994:	fae60de3          	beq	a2,a4,94e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 998:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 99c:	4790                	lw	a2,8(a5)
 99e:	02061593          	slli	a1,a2,0x20
 9a2:	01c5d713          	srli	a4,a1,0x1c
 9a6:	973e                	add	a4,a4,a5
 9a8:	fae68ae3          	beq	a3,a4,95c <free+0x22>
    p->s.ptr = bp->s.ptr;
 9ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ae:	00000717          	auipc	a4,0x0
 9b2:	64f73923          	sd	a5,1618(a4) # 1000 <freep>
}
 9b6:	6422                	ld	s0,8(sp)
 9b8:	0141                	addi	sp,sp,16
 9ba:	8082                	ret

00000000000009bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9bc:	7139                	addi	sp,sp,-64
 9be:	fc06                	sd	ra,56(sp)
 9c0:	f822                	sd	s0,48(sp)
 9c2:	f426                	sd	s1,40(sp)
 9c4:	f04a                	sd	s2,32(sp)
 9c6:	ec4e                	sd	s3,24(sp)
 9c8:	e852                	sd	s4,16(sp)
 9ca:	e456                	sd	s5,8(sp)
 9cc:	e05a                	sd	s6,0(sp)
 9ce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d0:	02051493          	slli	s1,a0,0x20
 9d4:	9081                	srli	s1,s1,0x20
 9d6:	04bd                	addi	s1,s1,15
 9d8:	8091                	srli	s1,s1,0x4
 9da:	0014899b          	addiw	s3,s1,1
 9de:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e0:	00000517          	auipc	a0,0x0
 9e4:	62053503          	ld	a0,1568(a0) # 1000 <freep>
 9e8:	c515                	beqz	a0,a14 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ec:	4798                	lw	a4,8(a5)
 9ee:	02977f63          	bgeu	a4,s1,a2c <malloc+0x70>
 9f2:	8a4e                	mv	s4,s3
 9f4:	0009871b          	sext.w	a4,s3
 9f8:	6685                	lui	a3,0x1
 9fa:	00d77363          	bgeu	a4,a3,a00 <malloc+0x44>
 9fe:	6a05                	lui	s4,0x1
 a00:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a04:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a08:	00000917          	auipc	s2,0x0
 a0c:	5f890913          	addi	s2,s2,1528 # 1000 <freep>
  if(p == (char*)-1)
 a10:	5afd                	li	s5,-1
 a12:	a895                	j	a86 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a14:	00000797          	auipc	a5,0x0
 a18:	60c78793          	addi	a5,a5,1548 # 1020 <base>
 a1c:	00000717          	auipc	a4,0x0
 a20:	5ef73223          	sd	a5,1508(a4) # 1000 <freep>
 a24:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a26:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a2a:	b7e1                	j	9f2 <malloc+0x36>
      if(p->s.size == nunits)
 a2c:	02e48c63          	beq	s1,a4,a64 <malloc+0xa8>
        p->s.size -= nunits;
 a30:	4137073b          	subw	a4,a4,s3
 a34:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a36:	02071693          	slli	a3,a4,0x20
 a3a:	01c6d713          	srli	a4,a3,0x1c
 a3e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a40:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a44:	00000717          	auipc	a4,0x0
 a48:	5aa73e23          	sd	a0,1468(a4) # 1000 <freep>
      return (void*)(p + 1);
 a4c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a50:	70e2                	ld	ra,56(sp)
 a52:	7442                	ld	s0,48(sp)
 a54:	74a2                	ld	s1,40(sp)
 a56:	7902                	ld	s2,32(sp)
 a58:	69e2                	ld	s3,24(sp)
 a5a:	6a42                	ld	s4,16(sp)
 a5c:	6aa2                	ld	s5,8(sp)
 a5e:	6b02                	ld	s6,0(sp)
 a60:	6121                	addi	sp,sp,64
 a62:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a64:	6398                	ld	a4,0(a5)
 a66:	e118                	sd	a4,0(a0)
 a68:	bff1                	j	a44 <malloc+0x88>
  hp->s.size = nu;
 a6a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a6e:	0541                	addi	a0,a0,16
 a70:	00000097          	auipc	ra,0x0
 a74:	eca080e7          	jalr	-310(ra) # 93a <free>
  return freep;
 a78:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a7c:	d971                	beqz	a0,a50 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a80:	4798                	lw	a4,8(a5)
 a82:	fa9775e3          	bgeu	a4,s1,a2c <malloc+0x70>
    if(p == freep)
 a86:	00093703          	ld	a4,0(s2)
 a8a:	853e                	mv	a0,a5
 a8c:	fef719e3          	bne	a4,a5,a7e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a90:	8552                	mv	a0,s4
 a92:	00000097          	auipc	ra,0x0
 a96:	b70080e7          	jalr	-1168(ra) # 602 <sbrk>
  if(p == (char*)-1)
 a9a:	fd5518e3          	bne	a0,s5,a6a <malloc+0xae>
        return 0;
 a9e:	4501                	li	a0,0
 aa0:	bf45                	j	a50 <malloc+0x94>
