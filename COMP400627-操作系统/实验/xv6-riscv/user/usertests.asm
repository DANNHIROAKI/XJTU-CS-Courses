
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bf4080e7          	jalr	-1036(ra) # 5c04 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	be2080e7          	jalr	-1054(ra) # 5c04 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0b250513          	addi	a0,a0,178 # 60f0 <malloc+0xea>
      46:	00006097          	auipc	ra,0x6
      4a:	f08080e7          	jalr	-248(ra) # 5f4e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b74080e7          	jalr	-1164(ra) # 5bc4 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	09050513          	addi	a0,a0,144 # 6110 <malloc+0x10a>
      88:	00006097          	auipc	ra,0x6
      8c:	ec6080e7          	jalr	-314(ra) # 5f4e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b32080e7          	jalr	-1230(ra) # 5bc4 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	08050513          	addi	a0,a0,128 # 6128 <malloc+0x122>
      b0:	00006097          	auipc	ra,0x6
      b4:	b54080e7          	jalr	-1196(ra) # 5c04 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b30080e7          	jalr	-1232(ra) # 5bec <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	08250513          	addi	a0,a0,130 # 6148 <malloc+0x142>
      ce:	00006097          	auipc	ra,0x6
      d2:	b36080e7          	jalr	-1226(ra) # 5c04 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	04a50513          	addi	a0,a0,74 # 6130 <malloc+0x12a>
      ee:	00006097          	auipc	ra,0x6
      f2:	e60080e7          	jalr	-416(ra) # 5f4e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	acc080e7          	jalr	-1332(ra) # 5bc4 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	05650513          	addi	a0,a0,86 # 6158 <malloc+0x152>
     10a:	00006097          	auipc	ra,0x6
     10e:	e44080e7          	jalr	-444(ra) # 5f4e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	ab0080e7          	jalr	-1360(ra) # 5bc4 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	05450513          	addi	a0,a0,84 # 6180 <malloc+0x17a>
     134:	00006097          	auipc	ra,0x6
     138:	ae0080e7          	jalr	-1312(ra) # 5c14 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	04050513          	addi	a0,a0,64 # 6180 <malloc+0x17a>
     148:	00006097          	auipc	ra,0x6
     14c:	abc080e7          	jalr	-1348(ra) # 5c04 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	03c58593          	addi	a1,a1,60 # 6190 <malloc+0x18a>
     15c:	00006097          	auipc	ra,0x6
     160:	a88080e7          	jalr	-1400(ra) # 5be4 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	01850513          	addi	a0,a0,24 # 6180 <malloc+0x17a>
     170:	00006097          	auipc	ra,0x6
     174:	a94080e7          	jalr	-1388(ra) # 5c04 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	01c58593          	addi	a1,a1,28 # 6198 <malloc+0x192>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a5e080e7          	jalr	-1442(ra) # 5be4 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fec50513          	addi	a0,a0,-20 # 6180 <malloc+0x17a>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a78080e7          	jalr	-1416(ra) # 5c14 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a46080e7          	jalr	-1466(ra) # 5bec <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a3c080e7          	jalr	-1476(ra) # 5bec <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	fd650513          	addi	a0,a0,-42 # 61a0 <malloc+0x19a>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d7c080e7          	jalr	-644(ra) # 5f4e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9e8080e7          	jalr	-1560(ra) # 5bc4 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9f4080e7          	jalr	-1548(ra) # 5c04 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9d4080e7          	jalr	-1580(ra) # 5bec <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9ce080e7          	jalr	-1586(ra) # 5c14 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f4c50513          	addi	a0,a0,-180 # 61c8 <malloc+0x1c2>
     284:	00006097          	auipc	ra,0x6
     288:	990080e7          	jalr	-1648(ra) # 5c14 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f38a8a93          	addi	s5,s5,-200 # 61c8 <malloc+0x1c2>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	958080e7          	jalr	-1704(ra) # 5c04 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	926080e7          	jalr	-1754(ra) # 5be4 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	912080e7          	jalr	-1774(ra) # 5be4 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	90c080e7          	jalr	-1780(ra) # 5bec <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	92a080e7          	jalr	-1750(ra) # 5c14 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	ec650513          	addi	a0,a0,-314 # 61d8 <malloc+0x1d2>
     31a:	00006097          	auipc	ra,0x6
     31e:	c34080e7          	jalr	-972(ra) # 5f4e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8a0080e7          	jalr	-1888(ra) # 5bc4 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	ec450513          	addi	a0,a0,-316 # 61f8 <malloc+0x1f2>
     33c:	00006097          	auipc	ra,0x6
     340:	c12080e7          	jalr	-1006(ra) # 5f4e <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	87e080e7          	jalr	-1922(ra) # 5bc4 <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	eb250513          	addi	a0,a0,-334 # 6210 <malloc+0x20a>
     366:	00006097          	auipc	ra,0x6
     36a:	8ae080e7          	jalr	-1874(ra) # 5c14 <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	e9e98993          	addi	s3,s3,-354 # 6210 <malloc+0x20a>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	87e080e7          	jalr	-1922(ra) # 5c04 <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	84c080e7          	jalr	-1972(ra) # 5be4 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	84a080e7          	jalr	-1974(ra) # 5bec <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	868080e7          	jalr	-1944(ra) # 5c14 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e5250513          	addi	a0,a0,-430 # 6210 <malloc+0x20a>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	83e080e7          	jalr	-1986(ra) # 5c04 <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	dc258593          	addi	a1,a1,-574 # 6198 <malloc+0x192>
     3de:	00006097          	auipc	ra,0x6
     3e2:	806080e7          	jalr	-2042(ra) # 5be4 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e4450513          	addi	a0,a0,-444 # 6230 <malloc+0x22a>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b5a080e7          	jalr	-1190(ra) # 5f4e <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	7c6080e7          	jalr	1990(ra) # 5bc4 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	e1250513          	addi	a0,a0,-494 # 6218 <malloc+0x212>
     40e:	00006097          	auipc	ra,0x6
     412:	b40080e7          	jalr	-1216(ra) # 5f4e <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	7ac080e7          	jalr	1964(ra) # 5bc4 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	df850513          	addi	a0,a0,-520 # 6218 <malloc+0x212>
     428:	00006097          	auipc	ra,0x6
     42c:	b26080e7          	jalr	-1242(ra) # 5f4e <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	792080e7          	jalr	1938(ra) # 5bc4 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	7b0080e7          	jalr	1968(ra) # 5bec <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	dcc50513          	addi	a0,a0,-564 # 6210 <malloc+0x20a>
     44c:	00005097          	auipc	ra,0x5
     450:	7c8080e7          	jalr	1992(ra) # 5c14 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	76e080e7          	jalr	1902(ra) # 5bc4 <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	76a080e7          	jalr	1898(ra) # 5c14 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	74a080e7          	jalr	1866(ra) # 5c04 <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	726080e7          	jalr	1830(ra) # 5bec <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	702080e7          	jalr	1794(ra) # 5c14 <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	cf0a0a13          	addi	s4,s4,-784 # 6240 <malloc+0x23a>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	6a2080e7          	jalr	1698(ra) # 5c04 <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	670080e7          	jalr	1648(ra) # 5be4 <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	66a080e7          	jalr	1642(ra) # 5bec <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	688080e7          	jalr	1672(ra) # 5c14 <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	64a080e7          	jalr	1610(ra) # 5be4 <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	62a080e7          	jalr	1578(ra) # 5bd4 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	626080e7          	jalr	1574(ra) # 5be4 <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	61e080e7          	jalr	1566(ra) # 5bec <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	612080e7          	jalr	1554(ra) # 5bec <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c4c50513          	addi	a0,a0,-948 # 6248 <malloc+0x242>
     604:	00006097          	auipc	ra,0x6
     608:	94a080e7          	jalr	-1718(ra) # 5f4e <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	5b6080e7          	jalr	1462(ra) # 5bc4 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c4650513          	addi	a0,a0,-954 # 6260 <malloc+0x25a>
     622:	00006097          	auipc	ra,0x6
     626:	92c080e7          	jalr	-1748(ra) # 5f4e <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	598080e7          	jalr	1432(ra) # 5bc4 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	c5850513          	addi	a0,a0,-936 # 6290 <malloc+0x28a>
     640:	00006097          	auipc	ra,0x6
     644:	90e080e7          	jalr	-1778(ra) # 5f4e <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	57a080e7          	jalr	1402(ra) # 5bc4 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	c6e50513          	addi	a0,a0,-914 # 62c0 <malloc+0x2ba>
     65a:	00006097          	auipc	ra,0x6
     65e:	8f4080e7          	jalr	-1804(ra) # 5f4e <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	560080e7          	jalr	1376(ra) # 5bc4 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	c6050513          	addi	a0,a0,-928 # 62d0 <malloc+0x2ca>
     678:	00006097          	auipc	ra,0x6
     67c:	8d6080e7          	jalr	-1834(ra) # 5f4e <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	542080e7          	jalr	1346(ra) # 5bc4 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	c52a0a13          	addi	s4,s4,-942 # 6300 <malloc+0x2fa>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	ae2a8a93          	addi	s5,s5,-1310 # 6198 <malloc+0x192>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	53e080e7          	jalr	1342(ra) # 5c04 <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	504080e7          	jalr	1284(ra) # 5bdc <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	506080e7          	jalr	1286(ra) # 5bec <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	4e2080e7          	jalr	1250(ra) # 5bd4 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	4de080e7          	jalr	1246(ra) # 5be4 <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	4c0080e7          	jalr	1216(ra) # 5bdc <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	4c0080e7          	jalr	1216(ra) # 5bec <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	4b4080e7          	jalr	1204(ra) # 5bec <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	bac50513          	addi	a0,a0,-1108 # 6308 <malloc+0x302>
     764:	00005097          	auipc	ra,0x5
     768:	7ea080e7          	jalr	2026(ra) # 5f4e <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	456080e7          	jalr	1110(ra) # 5bc4 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	ba650513          	addi	a0,a0,-1114 # 6320 <malloc+0x31a>
     782:	00005097          	auipc	ra,0x5
     786:	7cc080e7          	jalr	1996(ra) # 5f4e <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	438080e7          	jalr	1080(ra) # 5bc4 <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	b2c50513          	addi	a0,a0,-1236 # 62c0 <malloc+0x2ba>
     79c:	00005097          	auipc	ra,0x5
     7a0:	7b2080e7          	jalr	1970(ra) # 5f4e <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	41e080e7          	jalr	1054(ra) # 5bc4 <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	ba250513          	addi	a0,a0,-1118 # 6350 <malloc+0x34a>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	798080e7          	jalr	1944(ra) # 5f4e <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	404080e7          	jalr	1028(ra) # 5bc4 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	b9c50513          	addi	a0,a0,-1124 # 6368 <malloc+0x362>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	77a080e7          	jalr	1914(ra) # 5f4e <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	3e6080e7          	jalr	998(ra) # 5bc4 <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	98650513          	addi	a0,a0,-1658 # 6180 <malloc+0x17a>
     802:	00005097          	auipc	ra,0x5
     806:	412080e7          	jalr	1042(ra) # 5c14 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	97250513          	addi	a0,a0,-1678 # 6180 <malloc+0x17a>
     816:	00005097          	auipc	ra,0x5
     81a:	3ee080e7          	jalr	1006(ra) # 5c04 <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	96e58593          	addi	a1,a1,-1682 # 6190 <malloc+0x18a>
     82a:	00005097          	auipc	ra,0x5
     82e:	3ba080e7          	jalr	954(ra) # 5be4 <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	3b8080e7          	jalr	952(ra) # 5bec <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	94250513          	addi	a0,a0,-1726 # 6180 <malloc+0x17a>
     846:	00005097          	auipc	ra,0x5
     84a:	3be080e7          	jalr	958(ra) # 5c04 <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	384080e7          	jalr	900(ra) # 5bdc <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	91650513          	addi	a0,a0,-1770 # 6180 <malloc+0x17a>
     872:	00005097          	auipc	ra,0x5
     876:	392080e7          	jalr	914(ra) # 5c04 <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	90250513          	addi	a0,a0,-1790 # 6180 <malloc+0x17a>
     886:	00005097          	auipc	ra,0x5
     88a:	37e080e7          	jalr	894(ra) # 5c04 <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	344080e7          	jalr	836(ra) # 5bdc <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	32e080e7          	jalr	814(ra) # 5bdc <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	b3c58593          	addi	a1,a1,-1220 # 63f8 <malloc+0x3f2>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	31e080e7          	jalr	798(ra) # 5be4 <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	304080e7          	jalr	772(ra) # 5bdc <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	2ec080e7          	jalr	748(ra) # 5bdc <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	88250513          	addi	a0,a0,-1918 # 6180 <malloc+0x17a>
     906:	00005097          	auipc	ra,0x5
     90a:	30e080e7          	jalr	782(ra) # 5c14 <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	2dc080e7          	jalr	732(ra) # 5bec <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	2d2080e7          	jalr	722(ra) # 5bec <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	2c8080e7          	jalr	712(ra) # 5bec <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	a5650513          	addi	a0,a0,-1450 # 6398 <malloc+0x392>
     94a:	00005097          	auipc	ra,0x5
     94e:	604080e7          	jalr	1540(ra) # 5f4e <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	270080e7          	jalr	624(ra) # 5bc4 <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	a5a50513          	addi	a0,a0,-1446 # 63b8 <malloc+0x3b2>
     966:	00005097          	auipc	ra,0x5
     96a:	5e8080e7          	jalr	1512(ra) # 5f4e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	a5650513          	addi	a0,a0,-1450 # 63c8 <malloc+0x3c2>
     97a:	00005097          	auipc	ra,0x5
     97e:	5d4080e7          	jalr	1492(ra) # 5f4e <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	240080e7          	jalr	576(ra) # 5bc4 <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	a5a50513          	addi	a0,a0,-1446 # 63e8 <malloc+0x3e2>
     996:	00005097          	auipc	ra,0x5
     99a:	5b8080e7          	jalr	1464(ra) # 5f4e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	a2650513          	addi	a0,a0,-1498 # 63c8 <malloc+0x3c2>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	5a4080e7          	jalr	1444(ra) # 5f4e <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	210080e7          	jalr	528(ra) # 5bc4 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	a4050513          	addi	a0,a0,-1472 # 6400 <malloc+0x3fa>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	586080e7          	jalr	1414(ra) # 5f4e <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	1f2080e7          	jalr	498(ra) # 5bc4 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	a4250513          	addi	a0,a0,-1470 # 6420 <malloc+0x41a>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	568080e7          	jalr	1384(ra) # 5f4e <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	1d4080e7          	jalr	468(ra) # 5bc4 <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	a2e50513          	addi	a0,a0,-1490 # 6440 <malloc+0x43a>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	1ea080e7          	jalr	490(ra) # 5c04 <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	a3e98993          	addi	s3,s3,-1474 # 6468 <malloc+0x462>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	a6ea8a93          	addi	s5,s5,-1426 # 64a0 <malloc+0x49a>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	1a0080e7          	jalr	416(ra) # 5be4 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	18c080e7          	jalr	396(ra) # 5be4 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	17e080e7          	jalr	382(ra) # 5bec <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	9c850513          	addi	a0,a0,-1592 # 6440 <malloc+0x43a>
     a80:	00005097          	auipc	ra,0x5
     a84:	184080e7          	jalr	388(ra) # 5c04 <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1e658593          	addi	a1,a1,486 # cc78 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	142080e7          	jalr	322(ra) # 5bdc <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	140080e7          	jalr	320(ra) # 5bec <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	98c50513          	addi	a0,a0,-1652 # 6440 <malloc+0x43a>
     abc:	00005097          	auipc	ra,0x5
     ac0:	158080e7          	jalr	344(ra) # 5c14 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	96a50513          	addi	a0,a0,-1686 # 6448 <malloc+0x442>
     ae6:	00005097          	auipc	ra,0x5
     aea:	468080e7          	jalr	1128(ra) # 5f4e <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	0d4080e7          	jalr	212(ra) # 5bc4 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	97c50513          	addi	a0,a0,-1668 # 6478 <malloc+0x472>
     b04:	00005097          	auipc	ra,0x5
     b08:	44a080e7          	jalr	1098(ra) # 5f4e <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	0b6080e7          	jalr	182(ra) # 5bc4 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	99650513          	addi	a0,a0,-1642 # 64b0 <malloc+0x4aa>
     b22:	00005097          	auipc	ra,0x5
     b26:	42c080e7          	jalr	1068(ra) # 5f4e <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	098080e7          	jalr	152(ra) # 5bc4 <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	9a250513          	addi	a0,a0,-1630 # 64d8 <malloc+0x4d2>
     b3e:	00005097          	auipc	ra,0x5
     b42:	410080e7          	jalr	1040(ra) # 5f4e <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	07c080e7          	jalr	124(ra) # 5bc4 <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	9a650513          	addi	a0,a0,-1626 # 64f8 <malloc+0x4f2>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	3f4080e7          	jalr	1012(ra) # 5f4e <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	060080e7          	jalr	96(ra) # 5bc4 <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	9a250513          	addi	a0,a0,-1630 # 6510 <malloc+0x50a>
     b76:	00005097          	auipc	ra,0x5
     b7a:	3d8080e7          	jalr	984(ra) # 5f4e <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	044080e7          	jalr	68(ra) # 5bc4 <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	99050513          	addi	a0,a0,-1648 # 6530 <malloc+0x52a>
     ba8:	00005097          	auipc	ra,0x5
     bac:	05c080e7          	jalr	92(ra) # 5c04 <open>
  if(fd < 0){
     bb0:	08054563          	bltz	a0,c3a <writebig+0xb2>
     bb4:	89aa                	mv	s3,a0
     bb6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb8:	0000c917          	auipc	s2,0xc
     bbc:	0c090913          	addi	s2,s2,192 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bc0:	6a41                	lui	s4,0x10
     bc2:	10ba0a13          	addi	s4,s4,267 # 1010b <base+0x493>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	012080e7          	jalr	18(ra) # 5be4 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3e>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	002080e7          	jalr	2(ra) # 5bec <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	93c50513          	addi	a0,a0,-1732 # 6530 <malloc+0x52a>
     bfc:	00005097          	auipc	ra,0x5
     c00:	008080e7          	jalr	8(ra) # 5c04 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000c917          	auipc	s2,0xc
     c0c:	07090913          	addi	s2,s2,112 # cc78 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	fc0080e7          	jalr	-64(ra) # 5bdc <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x108>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x160>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17e>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	8fc50513          	addi	a0,a0,-1796 # 6538 <malloc+0x532>
     c44:	00005097          	auipc	ra,0x5
     c48:	30a080e7          	jalr	778(ra) # 5f4e <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	f76080e7          	jalr	-138(ra) # 5bc4 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	8fe50513          	addi	a0,a0,-1794 # 6558 <malloc+0x552>
     c62:	00005097          	auipc	ra,0x5
     c66:	2ec080e7          	jalr	748(ra) # 5f4e <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	f58080e7          	jalr	-168(ra) # 5bc4 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	90a50513          	addi	a0,a0,-1782 # 6580 <malloc+0x57a>
     c7e:	00005097          	auipc	ra,0x5
     c82:	2d0080e7          	jalr	720(ra) # 5f4e <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	f3c080e7          	jalr	-196(ra) # 5bc4 <exit>
      if(n == MAXFILE - 1){
     c90:	67c1                	lui	a5,0x10
     c92:	10a78793          	addi	a5,a5,266 # 1010a <base+0x492>
     c96:	02f48a63          	beq	s1,a5,cca <writebig+0x142>
  close(fd);
     c9a:	854e                	mv	a0,s3
     c9c:	00005097          	auipc	ra,0x5
     ca0:	f50080e7          	jalr	-176(ra) # 5bec <close>
  if(unlink("big") < 0){
     ca4:	00006517          	auipc	a0,0x6
     ca8:	88c50513          	addi	a0,a0,-1908 # 6530 <malloc+0x52a>
     cac:	00005097          	auipc	ra,0x5
     cb0:	f68080e7          	jalr	-152(ra) # 5c14 <unlink>
     cb4:	06054863          	bltz	a0,d24 <writebig+0x19c>
}
     cb8:	70e2                	ld	ra,56(sp)
     cba:	7442                	ld	s0,48(sp)
     cbc:	74a2                	ld	s1,40(sp)
     cbe:	7902                	ld	s2,32(sp)
     cc0:	69e2                	ld	s3,24(sp)
     cc2:	6a42                	ld	s4,16(sp)
     cc4:	6aa2                	ld	s5,8(sp)
     cc6:	6121                	addi	sp,sp,64
     cc8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cca:	863e                	mv	a2,a5
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	8d250513          	addi	a0,a0,-1838 # 65a0 <malloc+0x59a>
     cd6:	00005097          	auipc	ra,0x5
     cda:	278080e7          	jalr	632(ra) # 5f4e <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	ee4080e7          	jalr	-284(ra) # 5bc4 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	8dc50513          	addi	a0,a0,-1828 # 65c8 <malloc+0x5c2>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	25a080e7          	jalr	602(ra) # 5f4e <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	ec6080e7          	jalr	-314(ra) # 5bc4 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	8d650513          	addi	a0,a0,-1834 # 65e0 <malloc+0x5da>
     d12:	00005097          	auipc	ra,0x5
     d16:	23c080e7          	jalr	572(ra) # 5f4e <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	ea8080e7          	jalr	-344(ra) # 5bc4 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	8e250513          	addi	a0,a0,-1822 # 6608 <malloc+0x602>
     d2e:	00005097          	auipc	ra,0x5
     d32:	220080e7          	jalr	544(ra) # 5f4e <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	e8c080e7          	jalr	-372(ra) # 5bc4 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	8cc50513          	addi	a0,a0,-1844 # 6620 <malloc+0x61a>
     d5c:	00005097          	auipc	ra,0x5
     d60:	ea8080e7          	jalr	-344(ra) # 5c04 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	8e458593          	addi	a1,a1,-1820 # 6650 <malloc+0x64a>
     d74:	00005097          	auipc	ra,0x5
     d78:	e70080e7          	jalr	-400(ra) # 5be4 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	e6e080e7          	jalr	-402(ra) # 5bec <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	89850513          	addi	a0,a0,-1896 # 6620 <malloc+0x61a>
     d90:	00005097          	auipc	ra,0x5
     d94:	e74080e7          	jalr	-396(ra) # 5c04 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	88250513          	addi	a0,a0,-1918 # 6620 <malloc+0x61a>
     da6:	00005097          	auipc	ra,0x5
     daa:	e6e080e7          	jalr	-402(ra) # 5c14 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	86c50513          	addi	a0,a0,-1940 # 6620 <malloc+0x61a>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	e48080e7          	jalr	-440(ra) # 5c04 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	8d058593          	addi	a1,a1,-1840 # 6698 <malloc+0x692>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e14080e7          	jalr	-492(ra) # 5be4 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e12080e7          	jalr	-494(ra) # 5bec <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000c597          	auipc	a1,0xc
     de8:	e9458593          	addi	a1,a1,-364 # cc78 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	dee080e7          	jalr	-530(ra) # 5bdc <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000c717          	auipc	a4,0xc
     e00:	e7c74703          	lbu	a4,-388(a4) # cc78 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000c597          	auipc	a1,0xc
     e12:	e6a58593          	addi	a1,a1,-406 # cc78 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	dcc080e7          	jalr	-564(ra) # 5be4 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	dc4080e7          	jalr	-572(ra) # 5bec <close>
  unlink("unlinkread");
     e30:	00005517          	auipc	a0,0x5
     e34:	7f050513          	addi	a0,a0,2032 # 6620 <malloc+0x61a>
     e38:	00005097          	auipc	ra,0x5
     e3c:	ddc080e7          	jalr	-548(ra) # 5c14 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00005517          	auipc	a0,0x5
     e54:	7e050513          	addi	a0,a0,2016 # 6630 <malloc+0x62a>
     e58:	00005097          	auipc	ra,0x5
     e5c:	0f6080e7          	jalr	246(ra) # 5f4e <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	d62080e7          	jalr	-670(ra) # 5bc4 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00005517          	auipc	a0,0x5
     e70:	7ec50513          	addi	a0,a0,2028 # 6658 <malloc+0x652>
     e74:	00005097          	auipc	ra,0x5
     e78:	0da080e7          	jalr	218(ra) # 5f4e <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	d46080e7          	jalr	-698(ra) # 5bc4 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00005517          	auipc	a0,0x5
     e8c:	7f050513          	addi	a0,a0,2032 # 6678 <malloc+0x672>
     e90:	00005097          	auipc	ra,0x5
     e94:	0be080e7          	jalr	190(ra) # 5f4e <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	d2a080e7          	jalr	-726(ra) # 5bc4 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00005517          	auipc	a0,0x5
     ea8:	7fc50513          	addi	a0,a0,2044 # 66a0 <malloc+0x69a>
     eac:	00005097          	auipc	ra,0x5
     eb0:	0a2080e7          	jalr	162(ra) # 5f4e <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d0e080e7          	jalr	-754(ra) # 5bc4 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	80050513          	addi	a0,a0,-2048 # 66c0 <malloc+0x6ba>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	086080e7          	jalr	134(ra) # 5f4e <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	cf2080e7          	jalr	-782(ra) # 5bc4 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	80450513          	addi	a0,a0,-2044 # 66e0 <malloc+0x6da>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	06a080e7          	jalr	106(ra) # 5f4e <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	cd6080e7          	jalr	-810(ra) # 5bc4 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00005517          	auipc	a0,0x5
     f08:	7fc50513          	addi	a0,a0,2044 # 6700 <malloc+0x6fa>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d08080e7          	jalr	-760(ra) # 5c14 <unlink>
  unlink("lf2");
     f14:	00005517          	auipc	a0,0x5
     f18:	7f450513          	addi	a0,a0,2036 # 6708 <malloc+0x702>
     f1c:	00005097          	auipc	ra,0x5
     f20:	cf8080e7          	jalr	-776(ra) # 5c14 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00005517          	auipc	a0,0x5
     f2c:	7d850513          	addi	a0,a0,2008 # 6700 <malloc+0x6fa>
     f30:	00005097          	auipc	ra,0x5
     f34:	cd4080e7          	jalr	-812(ra) # 5c04 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	71058593          	addi	a1,a1,1808 # 6650 <malloc+0x64a>
     f48:	00005097          	auipc	ra,0x5
     f4c:	c9c080e7          	jalr	-868(ra) # 5be4 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	c94080e7          	jalr	-876(ra) # 5bec <close>
  if(link("lf1", "lf2") < 0){
     f60:	00005597          	auipc	a1,0x5
     f64:	7a858593          	addi	a1,a1,1960 # 6708 <malloc+0x702>
     f68:	00005517          	auipc	a0,0x5
     f6c:	79850513          	addi	a0,a0,1944 # 6700 <malloc+0x6fa>
     f70:	00005097          	auipc	ra,0x5
     f74:	cb4080e7          	jalr	-844(ra) # 5c24 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	78450513          	addi	a0,a0,1924 # 6700 <malloc+0x6fa>
     f84:	00005097          	auipc	ra,0x5
     f88:	c90080e7          	jalr	-880(ra) # 5c14 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	77250513          	addi	a0,a0,1906 # 6700 <malloc+0x6fa>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c6e080e7          	jalr	-914(ra) # 5c04 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	76450513          	addi	a0,a0,1892 # 6708 <malloc+0x702>
     fac:	00005097          	auipc	ra,0x5
     fb0:	c58080e7          	jalr	-936(ra) # 5c04 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000c597          	auipc	a1,0xc
     fc0:	cbc58593          	addi	a1,a1,-836 # cc78 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c18080e7          	jalr	-1000(ra) # 5bdc <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c18080e7          	jalr	-1000(ra) # 5bec <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	72c58593          	addi	a1,a1,1836 # 6708 <malloc+0x702>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c3e080e7          	jalr	-962(ra) # 5c24 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	71650513          	addi	a0,a0,1814 # 6708 <malloc+0x702>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c1a080e7          	jalr	-998(ra) # 5c14 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	6fe58593          	addi	a1,a1,1790 # 6700 <malloc+0x6fa>
    100a:	00005517          	auipc	a0,0x5
    100e:	6fe50513          	addi	a0,a0,1790 # 6708 <malloc+0x702>
    1012:	00005097          	auipc	ra,0x5
    1016:	c12080e7          	jalr	-1006(ra) # 5c24 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	6e258593          	addi	a1,a1,1762 # 6700 <malloc+0x6fa>
    1026:	00005517          	auipc	a0,0x5
    102a:	7ea50513          	addi	a0,a0,2026 # 6810 <malloc+0x80a>
    102e:	00005097          	auipc	ra,0x5
    1032:	bf6080e7          	jalr	-1034(ra) # 5c24 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	6c850513          	addi	a0,a0,1736 # 6710 <malloc+0x70a>
    1050:	00005097          	auipc	ra,0x5
    1054:	efe080e7          	jalr	-258(ra) # 5f4e <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	b6a080e7          	jalr	-1174(ra) # 5bc4 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	6c450513          	addi	a0,a0,1732 # 6728 <malloc+0x722>
    106c:	00005097          	auipc	ra,0x5
    1070:	ee2080e7          	jalr	-286(ra) # 5f4e <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	b4e080e7          	jalr	-1202(ra) # 5bc4 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	6c050513          	addi	a0,a0,1728 # 6740 <malloc+0x73a>
    1088:	00005097          	auipc	ra,0x5
    108c:	ec6080e7          	jalr	-314(ra) # 5f4e <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b32080e7          	jalr	-1230(ra) # 5bc4 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	6c450513          	addi	a0,a0,1732 # 6760 <malloc+0x75a>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	eaa080e7          	jalr	-342(ra) # 5f4e <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b16080e7          	jalr	-1258(ra) # 5bc4 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	6d850513          	addi	a0,a0,1752 # 6790 <malloc+0x78a>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	e8e080e7          	jalr	-370(ra) # 5f4e <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	afa080e7          	jalr	-1286(ra) # 5bc4 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	6d450513          	addi	a0,a0,1748 # 67a8 <malloc+0x7a2>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	e72080e7          	jalr	-398(ra) # 5f4e <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	ade080e7          	jalr	-1314(ra) # 5bc4 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	6d050513          	addi	a0,a0,1744 # 67c0 <malloc+0x7ba>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	e56080e7          	jalr	-426(ra) # 5f4e <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	ac2080e7          	jalr	-1342(ra) # 5bc4 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	6dc50513          	addi	a0,a0,1756 # 67e8 <malloc+0x7e2>
    1114:	00005097          	auipc	ra,0x5
    1118:	e3a080e7          	jalr	-454(ra) # 5f4e <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	aa6080e7          	jalr	-1370(ra) # 5bc4 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	6f050513          	addi	a0,a0,1776 # 6818 <malloc+0x812>
    1130:	00005097          	auipc	ra,0x5
    1134:	e1e080e7          	jalr	-482(ra) # 5f4e <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	a8a080e7          	jalr	-1398(ra) # 5bc4 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	6de98993          	addi	s3,s3,1758 # 6838 <malloc+0x832>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	ab6080e7          	jalr	-1354(ra) # 5c24 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	6b250513          	addi	a0,a0,1714 # 6848 <malloc+0x842>
    119e:	00005097          	auipc	ra,0x5
    11a2:	db0080e7          	jalr	-592(ra) # 5f4e <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a1c080e7          	jalr	-1508(ra) # 5bc4 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	6a250513          	addi	a0,a0,1698 # 6868 <malloc+0x862>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a46080e7          	jalr	-1466(ra) # 5c14 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	68e50513          	addi	a0,a0,1678 # 6868 <malloc+0x862>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	a22080e7          	jalr	-1502(ra) # 5c04 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	9fe080e7          	jalr	-1538(ra) # 5bec <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	66ca0a13          	addi	s4,s4,1644 # 6868 <malloc+0x862>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9571b          	sraiw	a4,s2,0x1f
    1210:	01a7571b          	srliw	a4,a4,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	9e8080e7          	jalr	-1560(ra) # 5c24 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	61a50513          	addi	a0,a0,1562 # 6868 <malloc+0x862>
    1256:	00005097          	auipc	ra,0x5
    125a:	9be080e7          	jalr	-1602(ra) # 5c14 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d71b          	sraiw	a4,s1,0x1f
    126e:	01a7571b          	srliw	a4,a4,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	97c080e7          	jalr	-1668(ra) # 5c14 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	5b250513          	addi	a0,a0,1458 # 6870 <malloc+0x86a>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	c88080e7          	jalr	-888(ra) # 5f4e <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	8f4080e7          	jalr	-1804(ra) # 5bc4 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	5b250513          	addi	a0,a0,1458 # 6890 <malloc+0x88a>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	c68080e7          	jalr	-920(ra) # 5f4e <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	8d4080e7          	jalr	-1836(ra) # 5bc4 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	5b650513          	addi	a0,a0,1462 # 68b0 <malloc+0x8aa>
    1302:	00005097          	auipc	ra,0x5
    1306:	c4c080e7          	jalr	-948(ra) # 5f4e <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	8b8080e7          	jalr	-1864(ra) # 5bc4 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00008497          	auipc	s1,0x8
    1326:	cde48493          	addi	s1,s1,-802 # 9000 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	8cc080e7          	jalr	-1844(ra) # 5bfc <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	89a080e7          	jalr	-1894(ra) # 5bd4 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	880080e7          	jalr	-1920(ra) # 5bc4 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	dc298993          	addi	s3,s3,-574 # 6128 <malloc+0x122>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	880080e7          	jalr	-1920(ra) # 5bfc <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	83a080e7          	jalr	-1990(ra) # 5bc4 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	85c080e7          	jalr	-1956(ra) # 5c14 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	836080e7          	jalr	-1994(ra) # 5c04 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	842080e7          	jalr	-1982(ra) # 5c24 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	71878793          	addi	a5,a5,1816 # 7b08 <malloc+0x1b02>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00004097          	auipc	ra,0x4
    140c:	7f4080e7          	jalr	2036(ra) # 5bfc <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00004097          	auipc	ra,0x4
    141a:	7a6080e7          	jalr	1958(ra) # 5bbc <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00008797          	auipc	a5,0x8
    142a:	13a78793          	addi	a5,a5,314 # 9560 <big.0>
    142e:	00009697          	auipc	a3,0x9
    1432:	13268693          	addi	a3,a3,306 # a560 <big.0+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	00009797          	auipc	a5,0x9
    1448:	10078e23          	sb	zero,284(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	0fc78793          	addi	a5,a5,252 # 8548 <malloc+0x2542>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	cb850513          	addi	a0,a0,-840 # 6128 <malloc+0x122>
    1478:	00004097          	auipc	ra,0x4
    147c:	784080e7          	jalr	1924(ra) # 5bfc <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	4d050513          	addi	a0,a0,1232 # 6958 <malloc+0x952>
    1490:	00005097          	auipc	ra,0x5
    1494:	abe080e7          	jalr	-1346(ra) # 5f4e <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	72a080e7          	jalr	1834(ra) # 5bc4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	42850513          	addi	a0,a0,1064 # 68d0 <malloc+0x8ca>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	a9e080e7          	jalr	-1378(ra) # 5f4e <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	70a080e7          	jalr	1802(ra) # 5bc4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	42850513          	addi	a0,a0,1064 # 68f0 <malloc+0x8ea>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	a7e080e7          	jalr	-1410(ra) # 5f4e <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	6ea080e7          	jalr	1770(ra) # 5bc4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	42650513          	addi	a0,a0,1062 # 6910 <malloc+0x90a>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	a5c080e7          	jalr	-1444(ra) # 5f4e <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	6c8080e7          	jalr	1736(ra) # 5bc4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	42e50513          	addi	a0,a0,1070 # 6938 <malloc+0x932>
    1512:	00005097          	auipc	ra,0x5
    1516:	a3c080e7          	jalr	-1476(ra) # 5f4e <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	6a8080e7          	jalr	1704(ra) # 5bc4 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	89450513          	addi	a0,a0,-1900 # 6db8 <malloc+0xdb2>
    152c:	00005097          	auipc	ra,0x5
    1530:	a22080e7          	jalr	-1502(ra) # 5f4e <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	68e080e7          	jalr	1678(ra) # 5bc4 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	682080e7          	jalr	1666(ra) # 5bc4 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	67a080e7          	jalr	1658(ra) # 5bcc <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	41250513          	addi	a0,a0,1042 # 6980 <malloc+0x97a>
    1576:	00005097          	auipc	ra,0x5
    157a:	9d8080e7          	jalr	-1576(ra) # 5f4e <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	644080e7          	jalr	1604(ra) # 5bc4 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e8ca                	sd	s2,80(sp)
    1592:	e4ce                	sd	s3,72(sp)
    1594:	e0d2                	sd	s4,64(sp)
    1596:	fc56                	sd	s5,56(sp)
    1598:	1880                	addi	s0,sp,112
    159a:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159c:	60100593          	li	a1,1537
    15a0:	00005517          	auipc	a0,0x5
    15a4:	be050513          	addi	a0,a0,-1056 # 6180 <malloc+0x17a>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	65c080e7          	jalr	1628(ra) # 5c04 <open>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	63c080e7          	jalr	1596(ra) # 5bec <close>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	604080e7          	jalr	1540(ra) # 5bbc <fork>
  if(pid < 0){
    15c0:	08054063          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15c4:	e969                	bnez	a0,1696 <truncate3+0x10e>
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	bb6a0a13          	addi	s4,s4,-1098 # 6180 <malloc+0x17a>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	40ea8a93          	addi	s5,s5,1038 # 69e0 <malloc+0x9da>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	626080e7          	jalr	1574(ra) # 5c04 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054a63          	bltz	a0,165c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	5f4080e7          	jalr	1524(ra) # 5be4 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	06f51f63          	bne	a0,a5,1678 <truncate3+0xf0>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	5ec080e7          	jalr	1516(ra) # 5bec <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	5f8080e7          	jalr	1528(ra) # 5c04 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	5be080e7          	jalr	1470(ra) # 5bdc <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	5c4080e7          	jalr	1476(ra) # 5bec <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	58c080e7          	jalr	1420(ra) # 5bc4 <exit>
    printf("%s: fork failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	36e50513          	addi	a0,a0,878 # 69b0 <malloc+0x9aa>
    164a:	00005097          	auipc	ra,0x5
    164e:	904080e7          	jalr	-1788(ra) # 5f4e <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	570080e7          	jalr	1392(ra) # 5bc4 <exit>
        printf("%s: open failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	36a50513          	addi	a0,a0,874 # 69c8 <malloc+0x9c2>
    1666:	00005097          	auipc	ra,0x5
    166a:	8e8080e7          	jalr	-1816(ra) # 5f4e <printf>
        exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	554080e7          	jalr	1364(ra) # 5bc4 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1678:	862a                	mv	a2,a0
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	37450513          	addi	a0,a0,884 # 69f0 <malloc+0x9ea>
    1684:	00005097          	auipc	ra,0x5
    1688:	8ca080e7          	jalr	-1846(ra) # 5f4e <printf>
        exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	536080e7          	jalr	1334(ra) # 5bc4 <exit>
    1696:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    169a:	00005a17          	auipc	s4,0x5
    169e:	ae6a0a13          	addi	s4,s4,-1306 # 6180 <malloc+0x17a>
    int n = write(fd, "xxx", 3);
    16a2:	00005a97          	auipc	s5,0x5
    16a6:	36ea8a93          	addi	s5,s5,878 # 6a10 <malloc+0xa0a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	60100593          	li	a1,1537
    16ae:	8552                	mv	a0,s4
    16b0:	00004097          	auipc	ra,0x4
    16b4:	554080e7          	jalr	1364(ra) # 5c04 <open>
    16b8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ba:	04054763          	bltz	a0,1708 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16be:	460d                	li	a2,3
    16c0:	85d6                	mv	a1,s5
    16c2:	00004097          	auipc	ra,0x4
    16c6:	522080e7          	jalr	1314(ra) # 5be4 <write>
    if(n != 3){
    16ca:	478d                	li	a5,3
    16cc:	04f51c63          	bne	a0,a5,1724 <truncate3+0x19c>
    close(fd);
    16d0:	8526                	mv	a0,s1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	51a080e7          	jalr	1306(ra) # 5bec <close>
  for(int i = 0; i < 150; i++){
    16da:	39fd                	addiw	s3,s3,-1
    16dc:	fc0997e3          	bnez	s3,16aa <truncate3+0x122>
  wait(&xstatus);
    16e0:	fbc40513          	addi	a0,s0,-68
    16e4:	00004097          	auipc	ra,0x4
    16e8:	4e8080e7          	jalr	1256(ra) # 5bcc <wait>
  unlink("truncfile");
    16ec:	00005517          	auipc	a0,0x5
    16f0:	a9450513          	addi	a0,a0,-1388 # 6180 <malloc+0x17a>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	520080e7          	jalr	1312(ra) # 5c14 <unlink>
  exit(xstatus);
    16fc:	fbc42503          	lw	a0,-68(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	4c4080e7          	jalr	1220(ra) # 5bc4 <exit>
      printf("%s: open failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	2be50513          	addi	a0,a0,702 # 69c8 <malloc+0x9c2>
    1712:	00005097          	auipc	ra,0x5
    1716:	83c080e7          	jalr	-1988(ra) # 5f4e <printf>
      exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	4a8080e7          	jalr	1192(ra) # 5bc4 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1724:	862a                	mv	a2,a0
    1726:	85ca                	mv	a1,s2
    1728:	00005517          	auipc	a0,0x5
    172c:	2f050513          	addi	a0,a0,752 # 6a18 <malloc+0xa12>
    1730:	00005097          	auipc	ra,0x5
    1734:	81e080e7          	jalr	-2018(ra) # 5f4e <printf>
      exit(1);
    1738:	4505                	li	a0,1
    173a:	00004097          	auipc	ra,0x4
    173e:	48a080e7          	jalr	1162(ra) # 5bc4 <exit>

0000000000001742 <exectest>:
{
    1742:	715d                	addi	sp,sp,-80
    1744:	e486                	sd	ra,72(sp)
    1746:	e0a2                	sd	s0,64(sp)
    1748:	fc26                	sd	s1,56(sp)
    174a:	f84a                	sd	s2,48(sp)
    174c:	0880                	addi	s0,sp,80
    174e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1750:	00005797          	auipc	a5,0x5
    1754:	9d878793          	addi	a5,a5,-1576 # 6128 <malloc+0x122>
    1758:	fcf43023          	sd	a5,-64(s0)
    175c:	00005797          	auipc	a5,0x5
    1760:	2dc78793          	addi	a5,a5,732 # 6a38 <malloc+0xa32>
    1764:	fcf43423          	sd	a5,-56(s0)
    1768:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176c:	00005517          	auipc	a0,0x5
    1770:	2d450513          	addi	a0,a0,724 # 6a40 <malloc+0xa3a>
    1774:	00004097          	auipc	ra,0x4
    1778:	4a0080e7          	jalr	1184(ra) # 5c14 <unlink>
  pid = fork();
    177c:	00004097          	auipc	ra,0x4
    1780:	440080e7          	jalr	1088(ra) # 5bbc <fork>
  if(pid < 0) {
    1784:	04054663          	bltz	a0,17d0 <exectest+0x8e>
    1788:	84aa                	mv	s1,a0
  if(pid == 0) {
    178a:	e959                	bnez	a0,1820 <exectest+0xde>
    close(1);
    178c:	4505                	li	a0,1
    178e:	00004097          	auipc	ra,0x4
    1792:	45e080e7          	jalr	1118(ra) # 5bec <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1796:	20100593          	li	a1,513
    179a:	00005517          	auipc	a0,0x5
    179e:	2a650513          	addi	a0,a0,678 # 6a40 <malloc+0xa3a>
    17a2:	00004097          	auipc	ra,0x4
    17a6:	462080e7          	jalr	1122(ra) # 5c04 <open>
    if(fd < 0) {
    17aa:	04054163          	bltz	a0,17ec <exectest+0xaa>
    if(fd != 1) {
    17ae:	4785                	li	a5,1
    17b0:	04f50c63          	beq	a0,a5,1808 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b4:	85ca                	mv	a1,s2
    17b6:	00005517          	auipc	a0,0x5
    17ba:	2aa50513          	addi	a0,a0,682 # 6a60 <malloc+0xa5a>
    17be:	00004097          	auipc	ra,0x4
    17c2:	790080e7          	jalr	1936(ra) # 5f4e <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	00004097          	auipc	ra,0x4
    17cc:	3fc080e7          	jalr	1020(ra) # 5bc4 <exit>
     printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	1de50513          	addi	a0,a0,478 # 69b0 <malloc+0x9aa>
    17da:	00004097          	auipc	ra,0x4
    17de:	774080e7          	jalr	1908(ra) # 5f4e <printf>
     exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	3e0080e7          	jalr	992(ra) # 5bc4 <exit>
      printf("%s: create failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	25a50513          	addi	a0,a0,602 # 6a48 <malloc+0xa42>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	758080e7          	jalr	1880(ra) # 5f4e <printf>
      exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	3c4080e7          	jalr	964(ra) # 5bc4 <exit>
    if(exec("echo", echoargv) < 0){
    1808:	fc040593          	addi	a1,s0,-64
    180c:	00005517          	auipc	a0,0x5
    1810:	91c50513          	addi	a0,a0,-1764 # 6128 <malloc+0x122>
    1814:	00004097          	auipc	ra,0x4
    1818:	3e8080e7          	jalr	1000(ra) # 5bfc <exec>
    181c:	02054163          	bltz	a0,183e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1820:	fdc40513          	addi	a0,s0,-36
    1824:	00004097          	auipc	ra,0x4
    1828:	3a8080e7          	jalr	936(ra) # 5bcc <wait>
    182c:	02951763          	bne	a0,s1,185a <exectest+0x118>
  if(xstatus != 0)
    1830:	fdc42503          	lw	a0,-36(s0)
    1834:	cd0d                	beqz	a0,186e <exectest+0x12c>
    exit(xstatus);
    1836:	00004097          	auipc	ra,0x4
    183a:	38e080e7          	jalr	910(ra) # 5bc4 <exit>
      printf("%s: exec echo failed\n", s);
    183e:	85ca                	mv	a1,s2
    1840:	00005517          	auipc	a0,0x5
    1844:	23050513          	addi	a0,a0,560 # 6a70 <malloc+0xa6a>
    1848:	00004097          	auipc	ra,0x4
    184c:	706080e7          	jalr	1798(ra) # 5f4e <printf>
      exit(1);
    1850:	4505                	li	a0,1
    1852:	00004097          	auipc	ra,0x4
    1856:	372080e7          	jalr	882(ra) # 5bc4 <exit>
    printf("%s: wait failed!\n", s);
    185a:	85ca                	mv	a1,s2
    185c:	00005517          	auipc	a0,0x5
    1860:	22c50513          	addi	a0,a0,556 # 6a88 <malloc+0xa82>
    1864:	00004097          	auipc	ra,0x4
    1868:	6ea080e7          	jalr	1770(ra) # 5f4e <printf>
    186c:	b7d1                	j	1830 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186e:	4581                	li	a1,0
    1870:	00005517          	auipc	a0,0x5
    1874:	1d050513          	addi	a0,a0,464 # 6a40 <malloc+0xa3a>
    1878:	00004097          	auipc	ra,0x4
    187c:	38c080e7          	jalr	908(ra) # 5c04 <open>
  if(fd < 0) {
    1880:	02054a63          	bltz	a0,18b4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1884:	4609                	li	a2,2
    1886:	fb840593          	addi	a1,s0,-72
    188a:	00004097          	auipc	ra,0x4
    188e:	352080e7          	jalr	850(ra) # 5bdc <read>
    1892:	4789                	li	a5,2
    1894:	02f50e63          	beq	a0,a5,18d0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1898:	85ca                	mv	a1,s2
    189a:	00005517          	auipc	a0,0x5
    189e:	c5e50513          	addi	a0,a0,-930 # 64f8 <malloc+0x4f2>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	6ac080e7          	jalr	1708(ra) # 5f4e <printf>
    exit(1);
    18aa:	4505                	li	a0,1
    18ac:	00004097          	auipc	ra,0x4
    18b0:	318080e7          	jalr	792(ra) # 5bc4 <exit>
    printf("%s: open failed\n", s);
    18b4:	85ca                	mv	a1,s2
    18b6:	00005517          	auipc	a0,0x5
    18ba:	11250513          	addi	a0,a0,274 # 69c8 <malloc+0x9c2>
    18be:	00004097          	auipc	ra,0x4
    18c2:	690080e7          	jalr	1680(ra) # 5f4e <printf>
    exit(1);
    18c6:	4505                	li	a0,1
    18c8:	00004097          	auipc	ra,0x4
    18cc:	2fc080e7          	jalr	764(ra) # 5bc4 <exit>
  unlink("echo-ok");
    18d0:	00005517          	auipc	a0,0x5
    18d4:	17050513          	addi	a0,a0,368 # 6a40 <malloc+0xa3a>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	33c080e7          	jalr	828(ra) # 5c14 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e0:	fb844703          	lbu	a4,-72(s0)
    18e4:	04f00793          	li	a5,79
    18e8:	00f71863          	bne	a4,a5,18f8 <exectest+0x1b6>
    18ec:	fb944703          	lbu	a4,-71(s0)
    18f0:	04b00793          	li	a5,75
    18f4:	02f70063          	beq	a4,a5,1914 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f8:	85ca                	mv	a1,s2
    18fa:	00005517          	auipc	a0,0x5
    18fe:	1a650513          	addi	a0,a0,422 # 6aa0 <malloc+0xa9a>
    1902:	00004097          	auipc	ra,0x4
    1906:	64c080e7          	jalr	1612(ra) # 5f4e <printf>
    exit(1);
    190a:	4505                	li	a0,1
    190c:	00004097          	auipc	ra,0x4
    1910:	2b8080e7          	jalr	696(ra) # 5bc4 <exit>
    exit(0);
    1914:	4501                	li	a0,0
    1916:	00004097          	auipc	ra,0x4
    191a:	2ae080e7          	jalr	686(ra) # 5bc4 <exit>

000000000000191e <pipe1>:
{
    191e:	711d                	addi	sp,sp,-96
    1920:	ec86                	sd	ra,88(sp)
    1922:	e8a2                	sd	s0,80(sp)
    1924:	e4a6                	sd	s1,72(sp)
    1926:	e0ca                	sd	s2,64(sp)
    1928:	fc4e                	sd	s3,56(sp)
    192a:	f852                	sd	s4,48(sp)
    192c:	f456                	sd	s5,40(sp)
    192e:	f05a                	sd	s6,32(sp)
    1930:	ec5e                	sd	s7,24(sp)
    1932:	1080                	addi	s0,sp,96
    1934:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1936:	fa840513          	addi	a0,s0,-88
    193a:	00004097          	auipc	ra,0x4
    193e:	29a080e7          	jalr	666(ra) # 5bd4 <pipe>
    1942:	e93d                	bnez	a0,19b8 <pipe1+0x9a>
    1944:	84aa                	mv	s1,a0
  pid = fork();
    1946:	00004097          	auipc	ra,0x4
    194a:	276080e7          	jalr	630(ra) # 5bbc <fork>
    194e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1950:	c151                	beqz	a0,19d4 <pipe1+0xb6>
  } else if(pid > 0){
    1952:	16a05d63          	blez	a0,1acc <pipe1+0x1ae>
    close(fds[1]);
    1956:	fac42503          	lw	a0,-84(s0)
    195a:	00004097          	auipc	ra,0x4
    195e:	292080e7          	jalr	658(ra) # 5bec <close>
    total = 0;
    1962:	8a26                	mv	s4,s1
    cc = 1;
    1964:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1966:	0000ba97          	auipc	s5,0xb
    196a:	312a8a93          	addi	s5,s5,786 # cc78 <buf>
      if(cc > sizeof(buf))
    196e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1970:	864e                	mv	a2,s3
    1972:	85d6                	mv	a1,s5
    1974:	fa842503          	lw	a0,-88(s0)
    1978:	00004097          	auipc	ra,0x4
    197c:	264080e7          	jalr	612(ra) # 5bdc <read>
    1980:	10a05163          	blez	a0,1a82 <pipe1+0x164>
      for(i = 0; i < n; i++){
    1984:	0000b717          	auipc	a4,0xb
    1988:	2f470713          	addi	a4,a4,756 # cc78 <buf>
    198c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1990:	00074683          	lbu	a3,0(a4)
    1994:	0ff4f793          	zext.b	a5,s1
    1998:	2485                	addiw	s1,s1,1
    199a:	0cf69063          	bne	a3,a5,1a5a <pipe1+0x13c>
      for(i = 0; i < n; i++){
    199e:	0705                	addi	a4,a4,1
    19a0:	fec498e3          	bne	s1,a2,1990 <pipe1+0x72>
      total += n;
    19a4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a8:	0019979b          	slliw	a5,s3,0x1
    19ac:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b0:	fd3b70e3          	bgeu	s6,s3,1970 <pipe1+0x52>
        cc = sizeof(buf);
    19b4:	89da                	mv	s3,s6
    19b6:	bf6d                	j	1970 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19b8:	85ca                	mv	a1,s2
    19ba:	00005517          	auipc	a0,0x5
    19be:	0fe50513          	addi	a0,a0,254 # 6ab8 <malloc+0xab2>
    19c2:	00004097          	auipc	ra,0x4
    19c6:	58c080e7          	jalr	1420(ra) # 5f4e <printf>
    exit(1);
    19ca:	4505                	li	a0,1
    19cc:	00004097          	auipc	ra,0x4
    19d0:	1f8080e7          	jalr	504(ra) # 5bc4 <exit>
    close(fds[0]);
    19d4:	fa842503          	lw	a0,-88(s0)
    19d8:	00004097          	auipc	ra,0x4
    19dc:	214080e7          	jalr	532(ra) # 5bec <close>
    for(n = 0; n < N; n++){
    19e0:	0000bb17          	auipc	s6,0xb
    19e4:	298b0b13          	addi	s6,s6,664 # cc78 <buf>
    19e8:	416004bb          	negw	s1,s6
    19ec:	0ff4f493          	zext.b	s1,s1
    19f0:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f4:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f6:	6a85                	lui	s5,0x1
    19f8:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    19fc:	87da                	mv	a5,s6
        buf[i] = seq++;
    19fe:	0097873b          	addw	a4,a5,s1
    1a02:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a06:	0785                	addi	a5,a5,1
    1a08:	fef99be3          	bne	s3,a5,19fe <pipe1+0xe0>
        buf[i] = seq++;
    1a0c:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a10:	40900613          	li	a2,1033
    1a14:	85de                	mv	a1,s7
    1a16:	fac42503          	lw	a0,-84(s0)
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	1ca080e7          	jalr	458(ra) # 5be4 <write>
    1a22:	40900793          	li	a5,1033
    1a26:	00f51c63          	bne	a0,a5,1a3e <pipe1+0x120>
    for(n = 0; n < N; n++){
    1a2a:	24a5                	addiw	s1,s1,9
    1a2c:	0ff4f493          	zext.b	s1,s1
    1a30:	fd5a16e3          	bne	s4,s5,19fc <pipe1+0xde>
    exit(0);
    1a34:	4501                	li	a0,0
    1a36:	00004097          	auipc	ra,0x4
    1a3a:	18e080e7          	jalr	398(ra) # 5bc4 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a3e:	85ca                	mv	a1,s2
    1a40:	00005517          	auipc	a0,0x5
    1a44:	09050513          	addi	a0,a0,144 # 6ad0 <malloc+0xaca>
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	506080e7          	jalr	1286(ra) # 5f4e <printf>
        exit(1);
    1a50:	4505                	li	a0,1
    1a52:	00004097          	auipc	ra,0x4
    1a56:	172080e7          	jalr	370(ra) # 5bc4 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a5a:	85ca                	mv	a1,s2
    1a5c:	00005517          	auipc	a0,0x5
    1a60:	08c50513          	addi	a0,a0,140 # 6ae8 <malloc+0xae2>
    1a64:	00004097          	auipc	ra,0x4
    1a68:	4ea080e7          	jalr	1258(ra) # 5f4e <printf>
}
    1a6c:	60e6                	ld	ra,88(sp)
    1a6e:	6446                	ld	s0,80(sp)
    1a70:	64a6                	ld	s1,72(sp)
    1a72:	6906                	ld	s2,64(sp)
    1a74:	79e2                	ld	s3,56(sp)
    1a76:	7a42                	ld	s4,48(sp)
    1a78:	7aa2                	ld	s5,40(sp)
    1a7a:	7b02                	ld	s6,32(sp)
    1a7c:	6be2                	ld	s7,24(sp)
    1a7e:	6125                	addi	sp,sp,96
    1a80:	8082                	ret
    if(total != N * SZ){
    1a82:	6785                	lui	a5,0x1
    1a84:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1a88:	02fa0063          	beq	s4,a5,1aa8 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8c:	85d2                	mv	a1,s4
    1a8e:	00005517          	auipc	a0,0x5
    1a92:	07250513          	addi	a0,a0,114 # 6b00 <malloc+0xafa>
    1a96:	00004097          	auipc	ra,0x4
    1a9a:	4b8080e7          	jalr	1208(ra) # 5f4e <printf>
      exit(1);
    1a9e:	4505                	li	a0,1
    1aa0:	00004097          	auipc	ra,0x4
    1aa4:	124080e7          	jalr	292(ra) # 5bc4 <exit>
    close(fds[0]);
    1aa8:	fa842503          	lw	a0,-88(s0)
    1aac:	00004097          	auipc	ra,0x4
    1ab0:	140080e7          	jalr	320(ra) # 5bec <close>
    wait(&xstatus);
    1ab4:	fa440513          	addi	a0,s0,-92
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	114080e7          	jalr	276(ra) # 5bcc <wait>
    exit(xstatus);
    1ac0:	fa442503          	lw	a0,-92(s0)
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	100080e7          	jalr	256(ra) # 5bc4 <exit>
    printf("%s: fork() failed\n", s);
    1acc:	85ca                	mv	a1,s2
    1ace:	00005517          	auipc	a0,0x5
    1ad2:	05250513          	addi	a0,a0,82 # 6b20 <malloc+0xb1a>
    1ad6:	00004097          	auipc	ra,0x4
    1ada:	478080e7          	jalr	1144(ra) # 5f4e <printf>
    exit(1);
    1ade:	4505                	li	a0,1
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	0e4080e7          	jalr	228(ra) # 5bc4 <exit>

0000000000001ae8 <exitwait>:
{
    1ae8:	7139                	addi	sp,sp,-64
    1aea:	fc06                	sd	ra,56(sp)
    1aec:	f822                	sd	s0,48(sp)
    1aee:	f426                	sd	s1,40(sp)
    1af0:	f04a                	sd	s2,32(sp)
    1af2:	ec4e                	sd	s3,24(sp)
    1af4:	e852                	sd	s4,16(sp)
    1af6:	0080                	addi	s0,sp,64
    1af8:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1afa:	4901                	li	s2,0
    1afc:	06400993          	li	s3,100
    pid = fork();
    1b00:	00004097          	auipc	ra,0x4
    1b04:	0bc080e7          	jalr	188(ra) # 5bbc <fork>
    1b08:	84aa                	mv	s1,a0
    if(pid < 0){
    1b0a:	02054a63          	bltz	a0,1b3e <exitwait+0x56>
    if(pid){
    1b0e:	c151                	beqz	a0,1b92 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b10:	fcc40513          	addi	a0,s0,-52
    1b14:	00004097          	auipc	ra,0x4
    1b18:	0b8080e7          	jalr	184(ra) # 5bcc <wait>
    1b1c:	02951f63          	bne	a0,s1,1b5a <exitwait+0x72>
      if(i != xstate) {
    1b20:	fcc42783          	lw	a5,-52(s0)
    1b24:	05279963          	bne	a5,s2,1b76 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b28:	2905                	addiw	s2,s2,1
    1b2a:	fd391be3          	bne	s2,s3,1b00 <exitwait+0x18>
}
    1b2e:	70e2                	ld	ra,56(sp)
    1b30:	7442                	ld	s0,48(sp)
    1b32:	74a2                	ld	s1,40(sp)
    1b34:	7902                	ld	s2,32(sp)
    1b36:	69e2                	ld	s3,24(sp)
    1b38:	6a42                	ld	s4,16(sp)
    1b3a:	6121                	addi	sp,sp,64
    1b3c:	8082                	ret
      printf("%s: fork failed\n", s);
    1b3e:	85d2                	mv	a1,s4
    1b40:	00005517          	auipc	a0,0x5
    1b44:	e7050513          	addi	a0,a0,-400 # 69b0 <malloc+0x9aa>
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	406080e7          	jalr	1030(ra) # 5f4e <printf>
      exit(1);
    1b50:	4505                	li	a0,1
    1b52:	00004097          	auipc	ra,0x4
    1b56:	072080e7          	jalr	114(ra) # 5bc4 <exit>
        printf("%s: wait wrong pid\n", s);
    1b5a:	85d2                	mv	a1,s4
    1b5c:	00005517          	auipc	a0,0x5
    1b60:	fdc50513          	addi	a0,a0,-36 # 6b38 <malloc+0xb32>
    1b64:	00004097          	auipc	ra,0x4
    1b68:	3ea080e7          	jalr	1002(ra) # 5f4e <printf>
        exit(1);
    1b6c:	4505                	li	a0,1
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	056080e7          	jalr	86(ra) # 5bc4 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b76:	85d2                	mv	a1,s4
    1b78:	00005517          	auipc	a0,0x5
    1b7c:	fd850513          	addi	a0,a0,-40 # 6b50 <malloc+0xb4a>
    1b80:	00004097          	auipc	ra,0x4
    1b84:	3ce080e7          	jalr	974(ra) # 5f4e <printf>
        exit(1);
    1b88:	4505                	li	a0,1
    1b8a:	00004097          	auipc	ra,0x4
    1b8e:	03a080e7          	jalr	58(ra) # 5bc4 <exit>
      exit(i);
    1b92:	854a                	mv	a0,s2
    1b94:	00004097          	auipc	ra,0x4
    1b98:	030080e7          	jalr	48(ra) # 5bc4 <exit>

0000000000001b9c <twochildren>:
{
    1b9c:	1101                	addi	sp,sp,-32
    1b9e:	ec06                	sd	ra,24(sp)
    1ba0:	e822                	sd	s0,16(sp)
    1ba2:	e426                	sd	s1,8(sp)
    1ba4:	e04a                	sd	s2,0(sp)
    1ba6:	1000                	addi	s0,sp,32
    1ba8:	892a                	mv	s2,a0
    1baa:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	00e080e7          	jalr	14(ra) # 5bbc <fork>
    if(pid1 < 0){
    1bb6:	02054c63          	bltz	a0,1bee <twochildren+0x52>
    if(pid1 == 0){
    1bba:	c921                	beqz	a0,1c0a <twochildren+0x6e>
      int pid2 = fork();
    1bbc:	00004097          	auipc	ra,0x4
    1bc0:	000080e7          	jalr	ra # 5bbc <fork>
      if(pid2 < 0){
    1bc4:	04054763          	bltz	a0,1c12 <twochildren+0x76>
      if(pid2 == 0){
    1bc8:	c13d                	beqz	a0,1c2e <twochildren+0x92>
        wait(0);
    1bca:	4501                	li	a0,0
    1bcc:	00004097          	auipc	ra,0x4
    1bd0:	000080e7          	jalr	ra # 5bcc <wait>
        wait(0);
    1bd4:	4501                	li	a0,0
    1bd6:	00004097          	auipc	ra,0x4
    1bda:	ff6080e7          	jalr	-10(ra) # 5bcc <wait>
  for(int i = 0; i < 1000; i++){
    1bde:	34fd                	addiw	s1,s1,-1
    1be0:	f4f9                	bnez	s1,1bae <twochildren+0x12>
}
    1be2:	60e2                	ld	ra,24(sp)
    1be4:	6442                	ld	s0,16(sp)
    1be6:	64a2                	ld	s1,8(sp)
    1be8:	6902                	ld	s2,0(sp)
    1bea:	6105                	addi	sp,sp,32
    1bec:	8082                	ret
      printf("%s: fork failed\n", s);
    1bee:	85ca                	mv	a1,s2
    1bf0:	00005517          	auipc	a0,0x5
    1bf4:	dc050513          	addi	a0,a0,-576 # 69b0 <malloc+0x9aa>
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	356080e7          	jalr	854(ra) # 5f4e <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	00004097          	auipc	ra,0x4
    1c06:	fc2080e7          	jalr	-62(ra) # 5bc4 <exit>
      exit(0);
    1c0a:	00004097          	auipc	ra,0x4
    1c0e:	fba080e7          	jalr	-70(ra) # 5bc4 <exit>
        printf("%s: fork failed\n", s);
    1c12:	85ca                	mv	a1,s2
    1c14:	00005517          	auipc	a0,0x5
    1c18:	d9c50513          	addi	a0,a0,-612 # 69b0 <malloc+0x9aa>
    1c1c:	00004097          	auipc	ra,0x4
    1c20:	332080e7          	jalr	818(ra) # 5f4e <printf>
        exit(1);
    1c24:	4505                	li	a0,1
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	f9e080e7          	jalr	-98(ra) # 5bc4 <exit>
        exit(0);
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	f96080e7          	jalr	-106(ra) # 5bc4 <exit>

0000000000001c36 <forkfork>:
{
    1c36:	7179                	addi	sp,sp,-48
    1c38:	f406                	sd	ra,40(sp)
    1c3a:	f022                	sd	s0,32(sp)
    1c3c:	ec26                	sd	s1,24(sp)
    1c3e:	1800                	addi	s0,sp,48
    1c40:	84aa                	mv	s1,a0
    int pid = fork();
    1c42:	00004097          	auipc	ra,0x4
    1c46:	f7a080e7          	jalr	-134(ra) # 5bbc <fork>
    if(pid < 0){
    1c4a:	04054163          	bltz	a0,1c8c <forkfork+0x56>
    if(pid == 0){
    1c4e:	cd29                	beqz	a0,1ca8 <forkfork+0x72>
    int pid = fork();
    1c50:	00004097          	auipc	ra,0x4
    1c54:	f6c080e7          	jalr	-148(ra) # 5bbc <fork>
    if(pid < 0){
    1c58:	02054a63          	bltz	a0,1c8c <forkfork+0x56>
    if(pid == 0){
    1c5c:	c531                	beqz	a0,1ca8 <forkfork+0x72>
    wait(&xstatus);
    1c5e:	fdc40513          	addi	a0,s0,-36
    1c62:	00004097          	auipc	ra,0x4
    1c66:	f6a080e7          	jalr	-150(ra) # 5bcc <wait>
    if(xstatus != 0) {
    1c6a:	fdc42783          	lw	a5,-36(s0)
    1c6e:	ebbd                	bnez	a5,1ce4 <forkfork+0xae>
    wait(&xstatus);
    1c70:	fdc40513          	addi	a0,s0,-36
    1c74:	00004097          	auipc	ra,0x4
    1c78:	f58080e7          	jalr	-168(ra) # 5bcc <wait>
    if(xstatus != 0) {
    1c7c:	fdc42783          	lw	a5,-36(s0)
    1c80:	e3b5                	bnez	a5,1ce4 <forkfork+0xae>
}
    1c82:	70a2                	ld	ra,40(sp)
    1c84:	7402                	ld	s0,32(sp)
    1c86:	64e2                	ld	s1,24(sp)
    1c88:	6145                	addi	sp,sp,48
    1c8a:	8082                	ret
      printf("%s: fork failed", s);
    1c8c:	85a6                	mv	a1,s1
    1c8e:	00005517          	auipc	a0,0x5
    1c92:	ee250513          	addi	a0,a0,-286 # 6b70 <malloc+0xb6a>
    1c96:	00004097          	auipc	ra,0x4
    1c9a:	2b8080e7          	jalr	696(ra) # 5f4e <printf>
      exit(1);
    1c9e:	4505                	li	a0,1
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	f24080e7          	jalr	-220(ra) # 5bc4 <exit>
{
    1ca8:	0c800493          	li	s1,200
        int pid1 = fork();
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	f10080e7          	jalr	-240(ra) # 5bbc <fork>
        if(pid1 < 0){
    1cb4:	00054f63          	bltz	a0,1cd2 <forkfork+0x9c>
        if(pid1 == 0){
    1cb8:	c115                	beqz	a0,1cdc <forkfork+0xa6>
        wait(0);
    1cba:	4501                	li	a0,0
    1cbc:	00004097          	auipc	ra,0x4
    1cc0:	f10080e7          	jalr	-240(ra) # 5bcc <wait>
      for(int j = 0; j < 200; j++){
    1cc4:	34fd                	addiw	s1,s1,-1
    1cc6:	f0fd                	bnez	s1,1cac <forkfork+0x76>
      exit(0);
    1cc8:	4501                	li	a0,0
    1cca:	00004097          	auipc	ra,0x4
    1cce:	efa080e7          	jalr	-262(ra) # 5bc4 <exit>
          exit(1);
    1cd2:	4505                	li	a0,1
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	ef0080e7          	jalr	-272(ra) # 5bc4 <exit>
          exit(0);
    1cdc:	00004097          	auipc	ra,0x4
    1ce0:	ee8080e7          	jalr	-280(ra) # 5bc4 <exit>
      printf("%s: fork in child failed", s);
    1ce4:	85a6                	mv	a1,s1
    1ce6:	00005517          	auipc	a0,0x5
    1cea:	e9a50513          	addi	a0,a0,-358 # 6b80 <malloc+0xb7a>
    1cee:	00004097          	auipc	ra,0x4
    1cf2:	260080e7          	jalr	608(ra) # 5f4e <printf>
      exit(1);
    1cf6:	4505                	li	a0,1
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	ecc080e7          	jalr	-308(ra) # 5bc4 <exit>

0000000000001d00 <reparent2>:
{
    1d00:	1101                	addi	sp,sp,-32
    1d02:	ec06                	sd	ra,24(sp)
    1d04:	e822                	sd	s0,16(sp)
    1d06:	e426                	sd	s1,8(sp)
    1d08:	1000                	addi	s0,sp,32
    1d0a:	32000493          	li	s1,800
    int pid1 = fork();
    1d0e:	00004097          	auipc	ra,0x4
    1d12:	eae080e7          	jalr	-338(ra) # 5bbc <fork>
    if(pid1 < 0){
    1d16:	00054f63          	bltz	a0,1d34 <reparent2+0x34>
    if(pid1 == 0){
    1d1a:	c915                	beqz	a0,1d4e <reparent2+0x4e>
    wait(0);
    1d1c:	4501                	li	a0,0
    1d1e:	00004097          	auipc	ra,0x4
    1d22:	eae080e7          	jalr	-338(ra) # 5bcc <wait>
  for(int i = 0; i < 800; i++){
    1d26:	34fd                	addiw	s1,s1,-1
    1d28:	f0fd                	bnez	s1,1d0e <reparent2+0xe>
  exit(0);
    1d2a:	4501                	li	a0,0
    1d2c:	00004097          	auipc	ra,0x4
    1d30:	e98080e7          	jalr	-360(ra) # 5bc4 <exit>
      printf("fork failed\n");
    1d34:	00005517          	auipc	a0,0x5
    1d38:	08450513          	addi	a0,a0,132 # 6db8 <malloc+0xdb2>
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	212080e7          	jalr	530(ra) # 5f4e <printf>
      exit(1);
    1d44:	4505                	li	a0,1
    1d46:	00004097          	auipc	ra,0x4
    1d4a:	e7e080e7          	jalr	-386(ra) # 5bc4 <exit>
      fork();
    1d4e:	00004097          	auipc	ra,0x4
    1d52:	e6e080e7          	jalr	-402(ra) # 5bbc <fork>
      fork();
    1d56:	00004097          	auipc	ra,0x4
    1d5a:	e66080e7          	jalr	-410(ra) # 5bbc <fork>
      exit(0);
    1d5e:	4501                	li	a0,0
    1d60:	00004097          	auipc	ra,0x4
    1d64:	e64080e7          	jalr	-412(ra) # 5bc4 <exit>

0000000000001d68 <createdelete>:
{
    1d68:	7175                	addi	sp,sp,-144
    1d6a:	e506                	sd	ra,136(sp)
    1d6c:	e122                	sd	s0,128(sp)
    1d6e:	fca6                	sd	s1,120(sp)
    1d70:	f8ca                	sd	s2,112(sp)
    1d72:	f4ce                	sd	s3,104(sp)
    1d74:	f0d2                	sd	s4,96(sp)
    1d76:	ecd6                	sd	s5,88(sp)
    1d78:	e8da                	sd	s6,80(sp)
    1d7a:	e4de                	sd	s7,72(sp)
    1d7c:	e0e2                	sd	s8,64(sp)
    1d7e:	fc66                	sd	s9,56(sp)
    1d80:	0900                	addi	s0,sp,144
    1d82:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d84:	4901                	li	s2,0
    1d86:	4991                	li	s3,4
    pid = fork();
    1d88:	00004097          	auipc	ra,0x4
    1d8c:	e34080e7          	jalr	-460(ra) # 5bbc <fork>
    1d90:	84aa                	mv	s1,a0
    if(pid < 0){
    1d92:	02054f63          	bltz	a0,1dd0 <createdelete+0x68>
    if(pid == 0){
    1d96:	c939                	beqz	a0,1dec <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d98:	2905                	addiw	s2,s2,1
    1d9a:	ff3917e3          	bne	s2,s3,1d88 <createdelete+0x20>
    1d9e:	4491                	li	s1,4
    wait(&xstatus);
    1da0:	f7c40513          	addi	a0,s0,-132
    1da4:	00004097          	auipc	ra,0x4
    1da8:	e28080e7          	jalr	-472(ra) # 5bcc <wait>
    if(xstatus != 0)
    1dac:	f7c42903          	lw	s2,-132(s0)
    1db0:	0e091263          	bnez	s2,1e94 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1db4:	34fd                	addiw	s1,s1,-1
    1db6:	f4ed                	bnez	s1,1da0 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1db8:	f8040123          	sb	zero,-126(s0)
    1dbc:	03000993          	li	s3,48
    1dc0:	5a7d                	li	s4,-1
    1dc2:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dc6:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dc8:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dca:	07400a93          	li	s5,116
    1dce:	a29d                	j	1f34 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd0:	85e6                	mv	a1,s9
    1dd2:	00005517          	auipc	a0,0x5
    1dd6:	fe650513          	addi	a0,a0,-26 # 6db8 <malloc+0xdb2>
    1dda:	00004097          	auipc	ra,0x4
    1dde:	174080e7          	jalr	372(ra) # 5f4e <printf>
      exit(1);
    1de2:	4505                	li	a0,1
    1de4:	00004097          	auipc	ra,0x4
    1de8:	de0080e7          	jalr	-544(ra) # 5bc4 <exit>
      name[0] = 'p' + pi;
    1dec:	0709091b          	addiw	s2,s2,112
    1df0:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df4:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1df8:	4951                	li	s2,20
    1dfa:	a015                	j	1e1e <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfc:	85e6                	mv	a1,s9
    1dfe:	00005517          	auipc	a0,0x5
    1e02:	c4a50513          	addi	a0,a0,-950 # 6a48 <malloc+0xa42>
    1e06:	00004097          	auipc	ra,0x4
    1e0a:	148080e7          	jalr	328(ra) # 5f4e <printf>
          exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	00004097          	auipc	ra,0x4
    1e14:	db4080e7          	jalr	-588(ra) # 5bc4 <exit>
      for(i = 0; i < N; i++){
    1e18:	2485                	addiw	s1,s1,1
    1e1a:	07248863          	beq	s1,s2,1e8a <createdelete+0x122>
        name[1] = '0' + i;
    1e1e:	0304879b          	addiw	a5,s1,48
    1e22:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e26:	20200593          	li	a1,514
    1e2a:	f8040513          	addi	a0,s0,-128
    1e2e:	00004097          	auipc	ra,0x4
    1e32:	dd6080e7          	jalr	-554(ra) # 5c04 <open>
        if(fd < 0){
    1e36:	fc0543e3          	bltz	a0,1dfc <createdelete+0x94>
        close(fd);
    1e3a:	00004097          	auipc	ra,0x4
    1e3e:	db2080e7          	jalr	-590(ra) # 5bec <close>
        if(i > 0 && (i % 2 ) == 0){
    1e42:	fc905be3          	blez	s1,1e18 <createdelete+0xb0>
    1e46:	0014f793          	andi	a5,s1,1
    1e4a:	f7f9                	bnez	a5,1e18 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4c:	01f4d79b          	srliw	a5,s1,0x1f
    1e50:	9fa5                	addw	a5,a5,s1
    1e52:	4017d79b          	sraiw	a5,a5,0x1
    1e56:	0307879b          	addiw	a5,a5,48
    1e5a:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e5e:	f8040513          	addi	a0,s0,-128
    1e62:	00004097          	auipc	ra,0x4
    1e66:	db2080e7          	jalr	-590(ra) # 5c14 <unlink>
    1e6a:	fa0557e3          	bgez	a0,1e18 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e6e:	85e6                	mv	a1,s9
    1e70:	00005517          	auipc	a0,0x5
    1e74:	d3050513          	addi	a0,a0,-720 # 6ba0 <malloc+0xb9a>
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	0d6080e7          	jalr	214(ra) # 5f4e <printf>
            exit(1);
    1e80:	4505                	li	a0,1
    1e82:	00004097          	auipc	ra,0x4
    1e86:	d42080e7          	jalr	-702(ra) # 5bc4 <exit>
      exit(0);
    1e8a:	4501                	li	a0,0
    1e8c:	00004097          	auipc	ra,0x4
    1e90:	d38080e7          	jalr	-712(ra) # 5bc4 <exit>
      exit(1);
    1e94:	4505                	li	a0,1
    1e96:	00004097          	auipc	ra,0x4
    1e9a:	d2e080e7          	jalr	-722(ra) # 5bc4 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1e9e:	f8040613          	addi	a2,s0,-128
    1ea2:	85e6                	mv	a1,s9
    1ea4:	00005517          	auipc	a0,0x5
    1ea8:	d1450513          	addi	a0,a0,-748 # 6bb8 <malloc+0xbb2>
    1eac:	00004097          	auipc	ra,0x4
    1eb0:	0a2080e7          	jalr	162(ra) # 5f4e <printf>
        exit(1);
    1eb4:	4505                	li	a0,1
    1eb6:	00004097          	auipc	ra,0x4
    1eba:	d0e080e7          	jalr	-754(ra) # 5bc4 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ebe:	054b7163          	bgeu	s6,s4,1f00 <createdelete+0x198>
      if(fd >= 0)
    1ec2:	02055a63          	bgez	a0,1ef6 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ec6:	2485                	addiw	s1,s1,1
    1ec8:	0ff4f493          	zext.b	s1,s1
    1ecc:	05548c63          	beq	s1,s5,1f24 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed0:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed4:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ed8:	4581                	li	a1,0
    1eda:	f8040513          	addi	a0,s0,-128
    1ede:	00004097          	auipc	ra,0x4
    1ee2:	d26080e7          	jalr	-730(ra) # 5c04 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ee6:	00090463          	beqz	s2,1eee <createdelete+0x186>
    1eea:	fd2bdae3          	bge	s7,s2,1ebe <createdelete+0x156>
    1eee:	fa0548e3          	bltz	a0,1e9e <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef2:	014b7963          	bgeu	s6,s4,1f04 <createdelete+0x19c>
        close(fd);
    1ef6:	00004097          	auipc	ra,0x4
    1efa:	cf6080e7          	jalr	-778(ra) # 5bec <close>
    1efe:	b7e1                	j	1ec6 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f00:	fc0543e3          	bltz	a0,1ec6 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f04:	f8040613          	addi	a2,s0,-128
    1f08:	85e6                	mv	a1,s9
    1f0a:	00005517          	auipc	a0,0x5
    1f0e:	cd650513          	addi	a0,a0,-810 # 6be0 <malloc+0xbda>
    1f12:	00004097          	auipc	ra,0x4
    1f16:	03c080e7          	jalr	60(ra) # 5f4e <printf>
        exit(1);
    1f1a:	4505                	li	a0,1
    1f1c:	00004097          	auipc	ra,0x4
    1f20:	ca8080e7          	jalr	-856(ra) # 5bc4 <exit>
  for(i = 0; i < N; i++){
    1f24:	2905                	addiw	s2,s2,1
    1f26:	2a05                	addiw	s4,s4,1
    1f28:	2985                	addiw	s3,s3,1
    1f2a:	0ff9f993          	zext.b	s3,s3
    1f2e:	47d1                	li	a5,20
    1f30:	02f90a63          	beq	s2,a5,1f64 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f34:	84e2                	mv	s1,s8
    1f36:	bf69                	j	1ed0 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f38:	2905                	addiw	s2,s2,1
    1f3a:	0ff97913          	zext.b	s2,s2
    1f3e:	2985                	addiw	s3,s3,1
    1f40:	0ff9f993          	zext.b	s3,s3
    1f44:	03490863          	beq	s2,s4,1f74 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f48:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f4a:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f4e:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f52:	f8040513          	addi	a0,s0,-128
    1f56:	00004097          	auipc	ra,0x4
    1f5a:	cbe080e7          	jalr	-834(ra) # 5c14 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f5e:	34fd                	addiw	s1,s1,-1
    1f60:	f4ed                	bnez	s1,1f4a <createdelete+0x1e2>
    1f62:	bfd9                	j	1f38 <createdelete+0x1d0>
    1f64:	03000993          	li	s3,48
    1f68:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6c:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f6e:	08400a13          	li	s4,132
    1f72:	bfd9                	j	1f48 <createdelete+0x1e0>
}
    1f74:	60aa                	ld	ra,136(sp)
    1f76:	640a                	ld	s0,128(sp)
    1f78:	74e6                	ld	s1,120(sp)
    1f7a:	7946                	ld	s2,112(sp)
    1f7c:	79a6                	ld	s3,104(sp)
    1f7e:	7a06                	ld	s4,96(sp)
    1f80:	6ae6                	ld	s5,88(sp)
    1f82:	6b46                	ld	s6,80(sp)
    1f84:	6ba6                	ld	s7,72(sp)
    1f86:	6c06                	ld	s8,64(sp)
    1f88:	7ce2                	ld	s9,56(sp)
    1f8a:	6149                	addi	sp,sp,144
    1f8c:	8082                	ret

0000000000001f8e <linkunlink>:
{
    1f8e:	711d                	addi	sp,sp,-96
    1f90:	ec86                	sd	ra,88(sp)
    1f92:	e8a2                	sd	s0,80(sp)
    1f94:	e4a6                	sd	s1,72(sp)
    1f96:	e0ca                	sd	s2,64(sp)
    1f98:	fc4e                	sd	s3,56(sp)
    1f9a:	f852                	sd	s4,48(sp)
    1f9c:	f456                	sd	s5,40(sp)
    1f9e:	f05a                	sd	s6,32(sp)
    1fa0:	ec5e                	sd	s7,24(sp)
    1fa2:	e862                	sd	s8,16(sp)
    1fa4:	e466                	sd	s9,8(sp)
    1fa6:	1080                	addi	s0,sp,96
    1fa8:	84aa                	mv	s1,a0
  unlink("x");
    1faa:	00004517          	auipc	a0,0x4
    1fae:	1ee50513          	addi	a0,a0,494 # 6198 <malloc+0x192>
    1fb2:	00004097          	auipc	ra,0x4
    1fb6:	c62080e7          	jalr	-926(ra) # 5c14 <unlink>
  pid = fork();
    1fba:	00004097          	auipc	ra,0x4
    1fbe:	c02080e7          	jalr	-1022(ra) # 5bbc <fork>
  if(pid < 0){
    1fc2:	02054b63          	bltz	a0,1ff8 <linkunlink+0x6a>
    1fc6:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fc8:	4c85                	li	s9,1
    1fca:	e119                	bnez	a0,1fd0 <linkunlink+0x42>
    1fcc:	06100c93          	li	s9,97
    1fd0:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd4:	41c659b7          	lui	s3,0x41c65
    1fd8:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1fdc:	690d                	lui	s2,0x3
    1fde:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0x19>
    if((x % 3) == 0){
    1fe2:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fe4:	4b05                	li	s6,1
      unlink("x");
    1fe6:	00004a97          	auipc	s5,0x4
    1fea:	1b2a8a93          	addi	s5,s5,434 # 6198 <malloc+0x192>
      link("cat", "x");
    1fee:	00005b97          	auipc	s7,0x5
    1ff2:	c1ab8b93          	addi	s7,s7,-998 # 6c08 <malloc+0xc02>
    1ff6:	a825                	j	202e <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ff8:	85a6                	mv	a1,s1
    1ffa:	00005517          	auipc	a0,0x5
    1ffe:	9b650513          	addi	a0,a0,-1610 # 69b0 <malloc+0x9aa>
    2002:	00004097          	auipc	ra,0x4
    2006:	f4c080e7          	jalr	-180(ra) # 5f4e <printf>
    exit(1);
    200a:	4505                	li	a0,1
    200c:	00004097          	auipc	ra,0x4
    2010:	bb8080e7          	jalr	-1096(ra) # 5bc4 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2014:	20200593          	li	a1,514
    2018:	8556                	mv	a0,s5
    201a:	00004097          	auipc	ra,0x4
    201e:	bea080e7          	jalr	-1046(ra) # 5c04 <open>
    2022:	00004097          	auipc	ra,0x4
    2026:	bca080e7          	jalr	-1078(ra) # 5bec <close>
  for(i = 0; i < 100; i++){
    202a:	34fd                	addiw	s1,s1,-1
    202c:	c88d                	beqz	s1,205e <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    202e:	033c87bb          	mulw	a5,s9,s3
    2032:	012787bb          	addw	a5,a5,s2
    2036:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    203a:	0347f7bb          	remuw	a5,a5,s4
    203e:	dbf9                	beqz	a5,2014 <linkunlink+0x86>
    } else if((x % 3) == 1){
    2040:	01678863          	beq	a5,s6,2050 <linkunlink+0xc2>
      unlink("x");
    2044:	8556                	mv	a0,s5
    2046:	00004097          	auipc	ra,0x4
    204a:	bce080e7          	jalr	-1074(ra) # 5c14 <unlink>
    204e:	bff1                	j	202a <linkunlink+0x9c>
      link("cat", "x");
    2050:	85d6                	mv	a1,s5
    2052:	855e                	mv	a0,s7
    2054:	00004097          	auipc	ra,0x4
    2058:	bd0080e7          	jalr	-1072(ra) # 5c24 <link>
    205c:	b7f9                	j	202a <linkunlink+0x9c>
  if(pid)
    205e:	020c0463          	beqz	s8,2086 <linkunlink+0xf8>
    wait(0);
    2062:	4501                	li	a0,0
    2064:	00004097          	auipc	ra,0x4
    2068:	b68080e7          	jalr	-1176(ra) # 5bcc <wait>
}
    206c:	60e6                	ld	ra,88(sp)
    206e:	6446                	ld	s0,80(sp)
    2070:	64a6                	ld	s1,72(sp)
    2072:	6906                	ld	s2,64(sp)
    2074:	79e2                	ld	s3,56(sp)
    2076:	7a42                	ld	s4,48(sp)
    2078:	7aa2                	ld	s5,40(sp)
    207a:	7b02                	ld	s6,32(sp)
    207c:	6be2                	ld	s7,24(sp)
    207e:	6c42                	ld	s8,16(sp)
    2080:	6ca2                	ld	s9,8(sp)
    2082:	6125                	addi	sp,sp,96
    2084:	8082                	ret
    exit(0);
    2086:	4501                	li	a0,0
    2088:	00004097          	auipc	ra,0x4
    208c:	b3c080e7          	jalr	-1220(ra) # 5bc4 <exit>

0000000000002090 <forktest>:
{
    2090:	7179                	addi	sp,sp,-48
    2092:	f406                	sd	ra,40(sp)
    2094:	f022                	sd	s0,32(sp)
    2096:	ec26                	sd	s1,24(sp)
    2098:	e84a                	sd	s2,16(sp)
    209a:	e44e                	sd	s3,8(sp)
    209c:	1800                	addi	s0,sp,48
    209e:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20a0:	4481                	li	s1,0
    20a2:	3e800913          	li	s2,1000
    pid = fork();
    20a6:	00004097          	auipc	ra,0x4
    20aa:	b16080e7          	jalr	-1258(ra) # 5bbc <fork>
    if(pid < 0)
    20ae:	02054863          	bltz	a0,20de <forktest+0x4e>
    if(pid == 0)
    20b2:	c115                	beqz	a0,20d6 <forktest+0x46>
  for(n=0; n<N; n++){
    20b4:	2485                	addiw	s1,s1,1
    20b6:	ff2498e3          	bne	s1,s2,20a6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20ba:	85ce                	mv	a1,s3
    20bc:	00005517          	auipc	a0,0x5
    20c0:	b6c50513          	addi	a0,a0,-1172 # 6c28 <malloc+0xc22>
    20c4:	00004097          	auipc	ra,0x4
    20c8:	e8a080e7          	jalr	-374(ra) # 5f4e <printf>
    exit(1);
    20cc:	4505                	li	a0,1
    20ce:	00004097          	auipc	ra,0x4
    20d2:	af6080e7          	jalr	-1290(ra) # 5bc4 <exit>
      exit(0);
    20d6:	00004097          	auipc	ra,0x4
    20da:	aee080e7          	jalr	-1298(ra) # 5bc4 <exit>
  if (n == 0) {
    20de:	cc9d                	beqz	s1,211c <forktest+0x8c>
  if(n == N){
    20e0:	3e800793          	li	a5,1000
    20e4:	fcf48be3          	beq	s1,a5,20ba <forktest+0x2a>
  for(; n > 0; n--){
    20e8:	00905b63          	blez	s1,20fe <forktest+0x6e>
    if(wait(0) < 0){
    20ec:	4501                	li	a0,0
    20ee:	00004097          	auipc	ra,0x4
    20f2:	ade080e7          	jalr	-1314(ra) # 5bcc <wait>
    20f6:	04054163          	bltz	a0,2138 <forktest+0xa8>
  for(; n > 0; n--){
    20fa:	34fd                	addiw	s1,s1,-1
    20fc:	f8e5                	bnez	s1,20ec <forktest+0x5c>
  if(wait(0) != -1){
    20fe:	4501                	li	a0,0
    2100:	00004097          	auipc	ra,0x4
    2104:	acc080e7          	jalr	-1332(ra) # 5bcc <wait>
    2108:	57fd                	li	a5,-1
    210a:	04f51563          	bne	a0,a5,2154 <forktest+0xc4>
}
    210e:	70a2                	ld	ra,40(sp)
    2110:	7402                	ld	s0,32(sp)
    2112:	64e2                	ld	s1,24(sp)
    2114:	6942                	ld	s2,16(sp)
    2116:	69a2                	ld	s3,8(sp)
    2118:	6145                	addi	sp,sp,48
    211a:	8082                	ret
    printf("%s: no fork at all!\n", s);
    211c:	85ce                	mv	a1,s3
    211e:	00005517          	auipc	a0,0x5
    2122:	af250513          	addi	a0,a0,-1294 # 6c10 <malloc+0xc0a>
    2126:	00004097          	auipc	ra,0x4
    212a:	e28080e7          	jalr	-472(ra) # 5f4e <printf>
    exit(1);
    212e:	4505                	li	a0,1
    2130:	00004097          	auipc	ra,0x4
    2134:	a94080e7          	jalr	-1388(ra) # 5bc4 <exit>
      printf("%s: wait stopped early\n", s);
    2138:	85ce                	mv	a1,s3
    213a:	00005517          	auipc	a0,0x5
    213e:	b1650513          	addi	a0,a0,-1258 # 6c50 <malloc+0xc4a>
    2142:	00004097          	auipc	ra,0x4
    2146:	e0c080e7          	jalr	-500(ra) # 5f4e <printf>
      exit(1);
    214a:	4505                	li	a0,1
    214c:	00004097          	auipc	ra,0x4
    2150:	a78080e7          	jalr	-1416(ra) # 5bc4 <exit>
    printf("%s: wait got too many\n", s);
    2154:	85ce                	mv	a1,s3
    2156:	00005517          	auipc	a0,0x5
    215a:	b1250513          	addi	a0,a0,-1262 # 6c68 <malloc+0xc62>
    215e:	00004097          	auipc	ra,0x4
    2162:	df0080e7          	jalr	-528(ra) # 5f4e <printf>
    exit(1);
    2166:	4505                	li	a0,1
    2168:	00004097          	auipc	ra,0x4
    216c:	a5c080e7          	jalr	-1444(ra) # 5bc4 <exit>

0000000000002170 <kernmem>:
{
    2170:	715d                	addi	sp,sp,-80
    2172:	e486                	sd	ra,72(sp)
    2174:	e0a2                	sd	s0,64(sp)
    2176:	fc26                	sd	s1,56(sp)
    2178:	f84a                	sd	s2,48(sp)
    217a:	f44e                	sd	s3,40(sp)
    217c:	f052                	sd	s4,32(sp)
    217e:	ec56                	sd	s5,24(sp)
    2180:	0880                	addi	s0,sp,80
    2182:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2184:	4485                	li	s1,1
    2186:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2188:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218a:	69b1                	lui	s3,0xc
    218c:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    2190:	1003d937          	lui	s2,0x1003d
    2194:	090e                	slli	s2,s2,0x3
    2196:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    219a:	00004097          	auipc	ra,0x4
    219e:	a22080e7          	jalr	-1502(ra) # 5bbc <fork>
    if(pid < 0){
    21a2:	02054963          	bltz	a0,21d4 <kernmem+0x64>
    if(pid == 0){
    21a6:	c529                	beqz	a0,21f0 <kernmem+0x80>
    wait(&xstatus);
    21a8:	fbc40513          	addi	a0,s0,-68
    21ac:	00004097          	auipc	ra,0x4
    21b0:	a20080e7          	jalr	-1504(ra) # 5bcc <wait>
    if(xstatus != -1)  // did kernel kill child?
    21b4:	fbc42783          	lw	a5,-68(s0)
    21b8:	05579d63          	bne	a5,s5,2212 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21bc:	94ce                	add	s1,s1,s3
    21be:	fd249ee3          	bne	s1,s2,219a <kernmem+0x2a>
}
    21c2:	60a6                	ld	ra,72(sp)
    21c4:	6406                	ld	s0,64(sp)
    21c6:	74e2                	ld	s1,56(sp)
    21c8:	7942                	ld	s2,48(sp)
    21ca:	79a2                	ld	s3,40(sp)
    21cc:	7a02                	ld	s4,32(sp)
    21ce:	6ae2                	ld	s5,24(sp)
    21d0:	6161                	addi	sp,sp,80
    21d2:	8082                	ret
      printf("%s: fork failed\n", s);
    21d4:	85d2                	mv	a1,s4
    21d6:	00004517          	auipc	a0,0x4
    21da:	7da50513          	addi	a0,a0,2010 # 69b0 <malloc+0x9aa>
    21de:	00004097          	auipc	ra,0x4
    21e2:	d70080e7          	jalr	-656(ra) # 5f4e <printf>
      exit(1);
    21e6:	4505                	li	a0,1
    21e8:	00004097          	auipc	ra,0x4
    21ec:	9dc080e7          	jalr	-1572(ra) # 5bc4 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f0:	0004c683          	lbu	a3,0(s1)
    21f4:	8626                	mv	a2,s1
    21f6:	85d2                	mv	a1,s4
    21f8:	00005517          	auipc	a0,0x5
    21fc:	a8850513          	addi	a0,a0,-1400 # 6c80 <malloc+0xc7a>
    2200:	00004097          	auipc	ra,0x4
    2204:	d4e080e7          	jalr	-690(ra) # 5f4e <printf>
      exit(1);
    2208:	4505                	li	a0,1
    220a:	00004097          	auipc	ra,0x4
    220e:	9ba080e7          	jalr	-1606(ra) # 5bc4 <exit>
      exit(1);
    2212:	4505                	li	a0,1
    2214:	00004097          	auipc	ra,0x4
    2218:	9b0080e7          	jalr	-1616(ra) # 5bc4 <exit>

000000000000221c <MAXVAplus>:
{
    221c:	7179                	addi	sp,sp,-48
    221e:	f406                	sd	ra,40(sp)
    2220:	f022                	sd	s0,32(sp)
    2222:	ec26                	sd	s1,24(sp)
    2224:	e84a                	sd	s2,16(sp)
    2226:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2228:	4785                	li	a5,1
    222a:	179a                	slli	a5,a5,0x26
    222c:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2230:	fd843783          	ld	a5,-40(s0)
    2234:	cf85                	beqz	a5,226c <MAXVAplus+0x50>
    2236:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2238:	54fd                	li	s1,-1
    pid = fork();
    223a:	00004097          	auipc	ra,0x4
    223e:	982080e7          	jalr	-1662(ra) # 5bbc <fork>
    if(pid < 0){
    2242:	02054b63          	bltz	a0,2278 <MAXVAplus+0x5c>
    if(pid == 0){
    2246:	c539                	beqz	a0,2294 <MAXVAplus+0x78>
    wait(&xstatus);
    2248:	fd440513          	addi	a0,s0,-44
    224c:	00004097          	auipc	ra,0x4
    2250:	980080e7          	jalr	-1664(ra) # 5bcc <wait>
    if(xstatus != -1)  // did kernel kill child?
    2254:	fd442783          	lw	a5,-44(s0)
    2258:	06979463          	bne	a5,s1,22c0 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    225c:	fd843783          	ld	a5,-40(s0)
    2260:	0786                	slli	a5,a5,0x1
    2262:	fcf43c23          	sd	a5,-40(s0)
    2266:	fd843783          	ld	a5,-40(s0)
    226a:	fbe1                	bnez	a5,223a <MAXVAplus+0x1e>
}
    226c:	70a2                	ld	ra,40(sp)
    226e:	7402                	ld	s0,32(sp)
    2270:	64e2                	ld	s1,24(sp)
    2272:	6942                	ld	s2,16(sp)
    2274:	6145                	addi	sp,sp,48
    2276:	8082                	ret
      printf("%s: fork failed\n", s);
    2278:	85ca                	mv	a1,s2
    227a:	00004517          	auipc	a0,0x4
    227e:	73650513          	addi	a0,a0,1846 # 69b0 <malloc+0x9aa>
    2282:	00004097          	auipc	ra,0x4
    2286:	ccc080e7          	jalr	-820(ra) # 5f4e <printf>
      exit(1);
    228a:	4505                	li	a0,1
    228c:	00004097          	auipc	ra,0x4
    2290:	938080e7          	jalr	-1736(ra) # 5bc4 <exit>
      *(char*)a = 99;
    2294:	fd843783          	ld	a5,-40(s0)
    2298:	06300713          	li	a4,99
    229c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22a0:	fd843603          	ld	a2,-40(s0)
    22a4:	85ca                	mv	a1,s2
    22a6:	00005517          	auipc	a0,0x5
    22aa:	9fa50513          	addi	a0,a0,-1542 # 6ca0 <malloc+0xc9a>
    22ae:	00004097          	auipc	ra,0x4
    22b2:	ca0080e7          	jalr	-864(ra) # 5f4e <printf>
      exit(1);
    22b6:	4505                	li	a0,1
    22b8:	00004097          	auipc	ra,0x4
    22bc:	90c080e7          	jalr	-1780(ra) # 5bc4 <exit>
      exit(1);
    22c0:	4505                	li	a0,1
    22c2:	00004097          	auipc	ra,0x4
    22c6:	902080e7          	jalr	-1790(ra) # 5bc4 <exit>

00000000000022ca <bigargtest>:
{
    22ca:	7179                	addi	sp,sp,-48
    22cc:	f406                	sd	ra,40(sp)
    22ce:	f022                	sd	s0,32(sp)
    22d0:	ec26                	sd	s1,24(sp)
    22d2:	1800                	addi	s0,sp,48
    22d4:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22d6:	00005517          	auipc	a0,0x5
    22da:	9e250513          	addi	a0,a0,-1566 # 6cb8 <malloc+0xcb2>
    22de:	00004097          	auipc	ra,0x4
    22e2:	936080e7          	jalr	-1738(ra) # 5c14 <unlink>
  pid = fork();
    22e6:	00004097          	auipc	ra,0x4
    22ea:	8d6080e7          	jalr	-1834(ra) # 5bbc <fork>
  if(pid == 0){
    22ee:	c121                	beqz	a0,232e <bigargtest+0x64>
  } else if(pid < 0){
    22f0:	0a054063          	bltz	a0,2390 <bigargtest+0xc6>
  wait(&xstatus);
    22f4:	fdc40513          	addi	a0,s0,-36
    22f8:	00004097          	auipc	ra,0x4
    22fc:	8d4080e7          	jalr	-1836(ra) # 5bcc <wait>
  if(xstatus != 0)
    2300:	fdc42503          	lw	a0,-36(s0)
    2304:	e545                	bnez	a0,23ac <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2306:	4581                	li	a1,0
    2308:	00005517          	auipc	a0,0x5
    230c:	9b050513          	addi	a0,a0,-1616 # 6cb8 <malloc+0xcb2>
    2310:	00004097          	auipc	ra,0x4
    2314:	8f4080e7          	jalr	-1804(ra) # 5c04 <open>
  if(fd < 0){
    2318:	08054e63          	bltz	a0,23b4 <bigargtest+0xea>
  close(fd);
    231c:	00004097          	auipc	ra,0x4
    2320:	8d0080e7          	jalr	-1840(ra) # 5bec <close>
}
    2324:	70a2                	ld	ra,40(sp)
    2326:	7402                	ld	s0,32(sp)
    2328:	64e2                	ld	s1,24(sp)
    232a:	6145                	addi	sp,sp,48
    232c:	8082                	ret
    232e:	00007797          	auipc	a5,0x7
    2332:	13278793          	addi	a5,a5,306 # 9460 <args.1>
    2336:	00007697          	auipc	a3,0x7
    233a:	22268693          	addi	a3,a3,546 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    233e:	00005717          	auipc	a4,0x5
    2342:	98a70713          	addi	a4,a4,-1654 # 6cc8 <malloc+0xcc2>
    2346:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2348:	07a1                	addi	a5,a5,8
    234a:	fed79ee3          	bne	a5,a3,2346 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    234e:	00007597          	auipc	a1,0x7
    2352:	11258593          	addi	a1,a1,274 # 9460 <args.1>
    2356:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    235a:	00004517          	auipc	a0,0x4
    235e:	dce50513          	addi	a0,a0,-562 # 6128 <malloc+0x122>
    2362:	00004097          	auipc	ra,0x4
    2366:	89a080e7          	jalr	-1894(ra) # 5bfc <exec>
    fd = open("bigarg-ok", O_CREATE);
    236a:	20000593          	li	a1,512
    236e:	00005517          	auipc	a0,0x5
    2372:	94a50513          	addi	a0,a0,-1718 # 6cb8 <malloc+0xcb2>
    2376:	00004097          	auipc	ra,0x4
    237a:	88e080e7          	jalr	-1906(ra) # 5c04 <open>
    close(fd);
    237e:	00004097          	auipc	ra,0x4
    2382:	86e080e7          	jalr	-1938(ra) # 5bec <close>
    exit(0);
    2386:	4501                	li	a0,0
    2388:	00004097          	auipc	ra,0x4
    238c:	83c080e7          	jalr	-1988(ra) # 5bc4 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2390:	85a6                	mv	a1,s1
    2392:	00005517          	auipc	a0,0x5
    2396:	a1650513          	addi	a0,a0,-1514 # 6da8 <malloc+0xda2>
    239a:	00004097          	auipc	ra,0x4
    239e:	bb4080e7          	jalr	-1100(ra) # 5f4e <printf>
    exit(1);
    23a2:	4505                	li	a0,1
    23a4:	00004097          	auipc	ra,0x4
    23a8:	820080e7          	jalr	-2016(ra) # 5bc4 <exit>
    exit(xstatus);
    23ac:	00004097          	auipc	ra,0x4
    23b0:	818080e7          	jalr	-2024(ra) # 5bc4 <exit>
    printf("%s: bigarg test failed!\n", s);
    23b4:	85a6                	mv	a1,s1
    23b6:	00005517          	auipc	a0,0x5
    23ba:	a1250513          	addi	a0,a0,-1518 # 6dc8 <malloc+0xdc2>
    23be:	00004097          	auipc	ra,0x4
    23c2:	b90080e7          	jalr	-1136(ra) # 5f4e <printf>
    exit(1);
    23c6:	4505                	li	a0,1
    23c8:	00003097          	auipc	ra,0x3
    23cc:	7fc080e7          	jalr	2044(ra) # 5bc4 <exit>

00000000000023d0 <stacktest>:
{
    23d0:	7179                	addi	sp,sp,-48
    23d2:	f406                	sd	ra,40(sp)
    23d4:	f022                	sd	s0,32(sp)
    23d6:	ec26                	sd	s1,24(sp)
    23d8:	1800                	addi	s0,sp,48
    23da:	84aa                	mv	s1,a0
  pid = fork();
    23dc:	00003097          	auipc	ra,0x3
    23e0:	7e0080e7          	jalr	2016(ra) # 5bbc <fork>
  if(pid == 0) {
    23e4:	c115                	beqz	a0,2408 <stacktest+0x38>
  } else if(pid < 0){
    23e6:	04054463          	bltz	a0,242e <stacktest+0x5e>
  wait(&xstatus);
    23ea:	fdc40513          	addi	a0,s0,-36
    23ee:	00003097          	auipc	ra,0x3
    23f2:	7de080e7          	jalr	2014(ra) # 5bcc <wait>
  if(xstatus == -1)  // kernel killed child?
    23f6:	fdc42503          	lw	a0,-36(s0)
    23fa:	57fd                	li	a5,-1
    23fc:	04f50763          	beq	a0,a5,244a <stacktest+0x7a>
    exit(xstatus);
    2400:	00003097          	auipc	ra,0x3
    2404:	7c4080e7          	jalr	1988(ra) # 5bc4 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2408:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    240a:	77fd                	lui	a5,0xfffff
    240c:	97ba                	add	a5,a5,a4
    240e:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2412:	85a6                	mv	a1,s1
    2414:	00005517          	auipc	a0,0x5
    2418:	9d450513          	addi	a0,a0,-1580 # 6de8 <malloc+0xde2>
    241c:	00004097          	auipc	ra,0x4
    2420:	b32080e7          	jalr	-1230(ra) # 5f4e <printf>
    exit(1);
    2424:	4505                	li	a0,1
    2426:	00003097          	auipc	ra,0x3
    242a:	79e080e7          	jalr	1950(ra) # 5bc4 <exit>
    printf("%s: fork failed\n", s);
    242e:	85a6                	mv	a1,s1
    2430:	00004517          	auipc	a0,0x4
    2434:	58050513          	addi	a0,a0,1408 # 69b0 <malloc+0x9aa>
    2438:	00004097          	auipc	ra,0x4
    243c:	b16080e7          	jalr	-1258(ra) # 5f4e <printf>
    exit(1);
    2440:	4505                	li	a0,1
    2442:	00003097          	auipc	ra,0x3
    2446:	782080e7          	jalr	1922(ra) # 5bc4 <exit>
    exit(0);
    244a:	4501                	li	a0,0
    244c:	00003097          	auipc	ra,0x3
    2450:	778080e7          	jalr	1912(ra) # 5bc4 <exit>

0000000000002454 <textwrite>:
{
    2454:	7179                	addi	sp,sp,-48
    2456:	f406                	sd	ra,40(sp)
    2458:	f022                	sd	s0,32(sp)
    245a:	ec26                	sd	s1,24(sp)
    245c:	1800                	addi	s0,sp,48
    245e:	84aa                	mv	s1,a0
  pid = fork();
    2460:	00003097          	auipc	ra,0x3
    2464:	75c080e7          	jalr	1884(ra) # 5bbc <fork>
  if(pid == 0) {
    2468:	c115                	beqz	a0,248c <textwrite+0x38>
  } else if(pid < 0){
    246a:	02054963          	bltz	a0,249c <textwrite+0x48>
  wait(&xstatus);
    246e:	fdc40513          	addi	a0,s0,-36
    2472:	00003097          	auipc	ra,0x3
    2476:	75a080e7          	jalr	1882(ra) # 5bcc <wait>
  if(xstatus == -1)  // kernel killed child?
    247a:	fdc42503          	lw	a0,-36(s0)
    247e:	57fd                	li	a5,-1
    2480:	02f50c63          	beq	a0,a5,24b8 <textwrite+0x64>
    exit(xstatus);
    2484:	00003097          	auipc	ra,0x3
    2488:	740080e7          	jalr	1856(ra) # 5bc4 <exit>
    *addr = 10;
    248c:	47a9                	li	a5,10
    248e:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	00003097          	auipc	ra,0x3
    2498:	730080e7          	jalr	1840(ra) # 5bc4 <exit>
    printf("%s: fork failed\n", s);
    249c:	85a6                	mv	a1,s1
    249e:	00004517          	auipc	a0,0x4
    24a2:	51250513          	addi	a0,a0,1298 # 69b0 <malloc+0x9aa>
    24a6:	00004097          	auipc	ra,0x4
    24aa:	aa8080e7          	jalr	-1368(ra) # 5f4e <printf>
    exit(1);
    24ae:	4505                	li	a0,1
    24b0:	00003097          	auipc	ra,0x3
    24b4:	714080e7          	jalr	1812(ra) # 5bc4 <exit>
    exit(0);
    24b8:	4501                	li	a0,0
    24ba:	00003097          	auipc	ra,0x3
    24be:	70a080e7          	jalr	1802(ra) # 5bc4 <exit>

00000000000024c2 <manywrites>:
{
    24c2:	711d                	addi	sp,sp,-96
    24c4:	ec86                	sd	ra,88(sp)
    24c6:	e8a2                	sd	s0,80(sp)
    24c8:	e4a6                	sd	s1,72(sp)
    24ca:	e0ca                	sd	s2,64(sp)
    24cc:	fc4e                	sd	s3,56(sp)
    24ce:	f852                	sd	s4,48(sp)
    24d0:	f456                	sd	s5,40(sp)
    24d2:	f05a                	sd	s6,32(sp)
    24d4:	ec5e                	sd	s7,24(sp)
    24d6:	1080                	addi	s0,sp,96
    24d8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24da:	4981                	li	s3,0
    24dc:	4911                	li	s2,4
    int pid = fork();
    24de:	00003097          	auipc	ra,0x3
    24e2:	6de080e7          	jalr	1758(ra) # 5bbc <fork>
    24e6:	84aa                	mv	s1,a0
    if(pid < 0){
    24e8:	02054963          	bltz	a0,251a <manywrites+0x58>
    if(pid == 0){
    24ec:	c521                	beqz	a0,2534 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24ee:	2985                	addiw	s3,s3,1
    24f0:	ff2997e3          	bne	s3,s2,24de <manywrites+0x1c>
    24f4:	4491                	li	s1,4
    int st = 0;
    24f6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24fa:	fa840513          	addi	a0,s0,-88
    24fe:	00003097          	auipc	ra,0x3
    2502:	6ce080e7          	jalr	1742(ra) # 5bcc <wait>
    if(st != 0)
    2506:	fa842503          	lw	a0,-88(s0)
    250a:	ed6d                	bnez	a0,2604 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    250c:	34fd                	addiw	s1,s1,-1
    250e:	f4e5                	bnez	s1,24f6 <manywrites+0x34>
  exit(0);
    2510:	4501                	li	a0,0
    2512:	00003097          	auipc	ra,0x3
    2516:	6b2080e7          	jalr	1714(ra) # 5bc4 <exit>
      printf("fork failed\n");
    251a:	00005517          	auipc	a0,0x5
    251e:	89e50513          	addi	a0,a0,-1890 # 6db8 <malloc+0xdb2>
    2522:	00004097          	auipc	ra,0x4
    2526:	a2c080e7          	jalr	-1492(ra) # 5f4e <printf>
      exit(1);
    252a:	4505                	li	a0,1
    252c:	00003097          	auipc	ra,0x3
    2530:	698080e7          	jalr	1688(ra) # 5bc4 <exit>
      name[0] = 'b';
    2534:	06200793          	li	a5,98
    2538:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    253c:	0619879b          	addiw	a5,s3,97
    2540:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2544:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2548:	fa840513          	addi	a0,s0,-88
    254c:	00003097          	auipc	ra,0x3
    2550:	6c8080e7          	jalr	1736(ra) # 5c14 <unlink>
    2554:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2556:	0000ab17          	auipc	s6,0xa
    255a:	722b0b13          	addi	s6,s6,1826 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    255e:	8a26                	mv	s4,s1
    2560:	0209ce63          	bltz	s3,259c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2564:	20200593          	li	a1,514
    2568:	fa840513          	addi	a0,s0,-88
    256c:	00003097          	auipc	ra,0x3
    2570:	698080e7          	jalr	1688(ra) # 5c04 <open>
    2574:	892a                	mv	s2,a0
          if(fd < 0){
    2576:	04054763          	bltz	a0,25c4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    257a:	660d                	lui	a2,0x3
    257c:	85da                	mv	a1,s6
    257e:	00003097          	auipc	ra,0x3
    2582:	666080e7          	jalr	1638(ra) # 5be4 <write>
          if(cc != sz){
    2586:	678d                	lui	a5,0x3
    2588:	04f51e63          	bne	a0,a5,25e4 <manywrites+0x122>
          close(fd);
    258c:	854a                	mv	a0,s2
    258e:	00003097          	auipc	ra,0x3
    2592:	65e080e7          	jalr	1630(ra) # 5bec <close>
        for(int i = 0; i < ci+1; i++){
    2596:	2a05                	addiw	s4,s4,1
    2598:	fd49d6e3          	bge	s3,s4,2564 <manywrites+0xa2>
        unlink(name);
    259c:	fa840513          	addi	a0,s0,-88
    25a0:	00003097          	auipc	ra,0x3
    25a4:	674080e7          	jalr	1652(ra) # 5c14 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25a8:	3bfd                	addiw	s7,s7,-1
    25aa:	fa0b9ae3          	bnez	s7,255e <manywrites+0x9c>
      unlink(name);
    25ae:	fa840513          	addi	a0,s0,-88
    25b2:	00003097          	auipc	ra,0x3
    25b6:	662080e7          	jalr	1634(ra) # 5c14 <unlink>
      exit(0);
    25ba:	4501                	li	a0,0
    25bc:	00003097          	auipc	ra,0x3
    25c0:	608080e7          	jalr	1544(ra) # 5bc4 <exit>
            printf("%s: cannot create %s\n", s, name);
    25c4:	fa840613          	addi	a2,s0,-88
    25c8:	85d6                	mv	a1,s5
    25ca:	00005517          	auipc	a0,0x5
    25ce:	84650513          	addi	a0,a0,-1978 # 6e10 <malloc+0xe0a>
    25d2:	00004097          	auipc	ra,0x4
    25d6:	97c080e7          	jalr	-1668(ra) # 5f4e <printf>
            exit(1);
    25da:	4505                	li	a0,1
    25dc:	00003097          	auipc	ra,0x3
    25e0:	5e8080e7          	jalr	1512(ra) # 5bc4 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25e4:	86aa                	mv	a3,a0
    25e6:	660d                	lui	a2,0x3
    25e8:	85d6                	mv	a1,s5
    25ea:	00004517          	auipc	a0,0x4
    25ee:	c0e50513          	addi	a0,a0,-1010 # 61f8 <malloc+0x1f2>
    25f2:	00004097          	auipc	ra,0x4
    25f6:	95c080e7          	jalr	-1700(ra) # 5f4e <printf>
            exit(1);
    25fa:	4505                	li	a0,1
    25fc:	00003097          	auipc	ra,0x3
    2600:	5c8080e7          	jalr	1480(ra) # 5bc4 <exit>
      exit(st);
    2604:	00003097          	auipc	ra,0x3
    2608:	5c0080e7          	jalr	1472(ra) # 5bc4 <exit>

000000000000260c <copyinstr3>:
{
    260c:	7179                	addi	sp,sp,-48
    260e:	f406                	sd	ra,40(sp)
    2610:	f022                	sd	s0,32(sp)
    2612:	ec26                	sd	s1,24(sp)
    2614:	1800                	addi	s0,sp,48
  sbrk(8192);
    2616:	6509                	lui	a0,0x2
    2618:	00003097          	auipc	ra,0x3
    261c:	634080e7          	jalr	1588(ra) # 5c4c <sbrk>
  uint64 top = (uint64) sbrk(0);
    2620:	4501                	li	a0,0
    2622:	00003097          	auipc	ra,0x3
    2626:	62a080e7          	jalr	1578(ra) # 5c4c <sbrk>
  if((top % PGSIZE) != 0){
    262a:	03451793          	slli	a5,a0,0x34
    262e:	e3c9                	bnez	a5,26b0 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2630:	4501                	li	a0,0
    2632:	00003097          	auipc	ra,0x3
    2636:	61a080e7          	jalr	1562(ra) # 5c4c <sbrk>
  if(top % PGSIZE){
    263a:	03451793          	slli	a5,a0,0x34
    263e:	e3d9                	bnez	a5,26c4 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2640:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x71>
  *b = 'x';
    2644:	07800793          	li	a5,120
    2648:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    264c:	8526                	mv	a0,s1
    264e:	00003097          	auipc	ra,0x3
    2652:	5c6080e7          	jalr	1478(ra) # 5c14 <unlink>
  if(ret != -1){
    2656:	57fd                	li	a5,-1
    2658:	08f51363          	bne	a0,a5,26de <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    265c:	20100593          	li	a1,513
    2660:	8526                	mv	a0,s1
    2662:	00003097          	auipc	ra,0x3
    2666:	5a2080e7          	jalr	1442(ra) # 5c04 <open>
  if(fd != -1){
    266a:	57fd                	li	a5,-1
    266c:	08f51863          	bne	a0,a5,26fc <copyinstr3+0xf0>
  ret = link(b, b);
    2670:	85a6                	mv	a1,s1
    2672:	8526                	mv	a0,s1
    2674:	00003097          	auipc	ra,0x3
    2678:	5b0080e7          	jalr	1456(ra) # 5c24 <link>
  if(ret != -1){
    267c:	57fd                	li	a5,-1
    267e:	08f51e63          	bne	a0,a5,271a <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2682:	00005797          	auipc	a5,0x5
    2686:	48678793          	addi	a5,a5,1158 # 7b08 <malloc+0x1b02>
    268a:	fcf43823          	sd	a5,-48(s0)
    268e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2692:	fd040593          	addi	a1,s0,-48
    2696:	8526                	mv	a0,s1
    2698:	00003097          	auipc	ra,0x3
    269c:	564080e7          	jalr	1380(ra) # 5bfc <exec>
  if(ret != -1){
    26a0:	57fd                	li	a5,-1
    26a2:	08f51c63          	bne	a0,a5,273a <copyinstr3+0x12e>
}
    26a6:	70a2                	ld	ra,40(sp)
    26a8:	7402                	ld	s0,32(sp)
    26aa:	64e2                	ld	s1,24(sp)
    26ac:	6145                	addi	sp,sp,48
    26ae:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26b0:	0347d513          	srli	a0,a5,0x34
    26b4:	6785                	lui	a5,0x1
    26b6:	40a7853b          	subw	a0,a5,a0
    26ba:	00003097          	auipc	ra,0x3
    26be:	592080e7          	jalr	1426(ra) # 5c4c <sbrk>
    26c2:	b7bd                	j	2630 <copyinstr3+0x24>
    printf("oops\n");
    26c4:	00004517          	auipc	a0,0x4
    26c8:	76450513          	addi	a0,a0,1892 # 6e28 <malloc+0xe22>
    26cc:	00004097          	auipc	ra,0x4
    26d0:	882080e7          	jalr	-1918(ra) # 5f4e <printf>
    exit(1);
    26d4:	4505                	li	a0,1
    26d6:	00003097          	auipc	ra,0x3
    26da:	4ee080e7          	jalr	1262(ra) # 5bc4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26de:	862a                	mv	a2,a0
    26e0:	85a6                	mv	a1,s1
    26e2:	00004517          	auipc	a0,0x4
    26e6:	1ee50513          	addi	a0,a0,494 # 68d0 <malloc+0x8ca>
    26ea:	00004097          	auipc	ra,0x4
    26ee:	864080e7          	jalr	-1948(ra) # 5f4e <printf>
    exit(1);
    26f2:	4505                	li	a0,1
    26f4:	00003097          	auipc	ra,0x3
    26f8:	4d0080e7          	jalr	1232(ra) # 5bc4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26fc:	862a                	mv	a2,a0
    26fe:	85a6                	mv	a1,s1
    2700:	00004517          	auipc	a0,0x4
    2704:	1f050513          	addi	a0,a0,496 # 68f0 <malloc+0x8ea>
    2708:	00004097          	auipc	ra,0x4
    270c:	846080e7          	jalr	-1978(ra) # 5f4e <printf>
    exit(1);
    2710:	4505                	li	a0,1
    2712:	00003097          	auipc	ra,0x3
    2716:	4b2080e7          	jalr	1202(ra) # 5bc4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    271a:	86aa                	mv	a3,a0
    271c:	8626                	mv	a2,s1
    271e:	85a6                	mv	a1,s1
    2720:	00004517          	auipc	a0,0x4
    2724:	1f050513          	addi	a0,a0,496 # 6910 <malloc+0x90a>
    2728:	00004097          	auipc	ra,0x4
    272c:	826080e7          	jalr	-2010(ra) # 5f4e <printf>
    exit(1);
    2730:	4505                	li	a0,1
    2732:	00003097          	auipc	ra,0x3
    2736:	492080e7          	jalr	1170(ra) # 5bc4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    273a:	567d                	li	a2,-1
    273c:	85a6                	mv	a1,s1
    273e:	00004517          	auipc	a0,0x4
    2742:	1fa50513          	addi	a0,a0,506 # 6938 <malloc+0x932>
    2746:	00004097          	auipc	ra,0x4
    274a:	808080e7          	jalr	-2040(ra) # 5f4e <printf>
    exit(1);
    274e:	4505                	li	a0,1
    2750:	00003097          	auipc	ra,0x3
    2754:	474080e7          	jalr	1140(ra) # 5bc4 <exit>

0000000000002758 <rwsbrk>:
{
    2758:	1101                	addi	sp,sp,-32
    275a:	ec06                	sd	ra,24(sp)
    275c:	e822                	sd	s0,16(sp)
    275e:	e426                	sd	s1,8(sp)
    2760:	e04a                	sd	s2,0(sp)
    2762:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2764:	6509                	lui	a0,0x2
    2766:	00003097          	auipc	ra,0x3
    276a:	4e6080e7          	jalr	1254(ra) # 5c4c <sbrk>
  if(a == 0xffffffffffffffffLL) {
    276e:	57fd                	li	a5,-1
    2770:	06f50263          	beq	a0,a5,27d4 <rwsbrk+0x7c>
    2774:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2776:	7579                	lui	a0,0xffffe
    2778:	00003097          	auipc	ra,0x3
    277c:	4d4080e7          	jalr	1236(ra) # 5c4c <sbrk>
    2780:	57fd                	li	a5,-1
    2782:	06f50663          	beq	a0,a5,27ee <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2786:	20100593          	li	a1,513
    278a:	00004517          	auipc	a0,0x4
    278e:	6de50513          	addi	a0,a0,1758 # 6e68 <malloc+0xe62>
    2792:	00003097          	auipc	ra,0x3
    2796:	472080e7          	jalr	1138(ra) # 5c04 <open>
    279a:	892a                	mv	s2,a0
  if(fd < 0){
    279c:	06054663          	bltz	a0,2808 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    27a0:	6785                	lui	a5,0x1
    27a2:	94be                	add	s1,s1,a5
    27a4:	40000613          	li	a2,1024
    27a8:	85a6                	mv	a1,s1
    27aa:	00003097          	auipc	ra,0x3
    27ae:	43a080e7          	jalr	1082(ra) # 5be4 <write>
    27b2:	862a                	mv	a2,a0
  if(n >= 0){
    27b4:	06054763          	bltz	a0,2822 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27b8:	85a6                	mv	a1,s1
    27ba:	00004517          	auipc	a0,0x4
    27be:	6ce50513          	addi	a0,a0,1742 # 6e88 <malloc+0xe82>
    27c2:	00003097          	auipc	ra,0x3
    27c6:	78c080e7          	jalr	1932(ra) # 5f4e <printf>
    exit(1);
    27ca:	4505                	li	a0,1
    27cc:	00003097          	auipc	ra,0x3
    27d0:	3f8080e7          	jalr	1016(ra) # 5bc4 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27d4:	00004517          	auipc	a0,0x4
    27d8:	65c50513          	addi	a0,a0,1628 # 6e30 <malloc+0xe2a>
    27dc:	00003097          	auipc	ra,0x3
    27e0:	772080e7          	jalr	1906(ra) # 5f4e <printf>
    exit(1);
    27e4:	4505                	li	a0,1
    27e6:	00003097          	auipc	ra,0x3
    27ea:	3de080e7          	jalr	990(ra) # 5bc4 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27ee:	00004517          	auipc	a0,0x4
    27f2:	65a50513          	addi	a0,a0,1626 # 6e48 <malloc+0xe42>
    27f6:	00003097          	auipc	ra,0x3
    27fa:	758080e7          	jalr	1880(ra) # 5f4e <printf>
    exit(1);
    27fe:	4505                	li	a0,1
    2800:	00003097          	auipc	ra,0x3
    2804:	3c4080e7          	jalr	964(ra) # 5bc4 <exit>
    printf("open(rwsbrk) failed\n");
    2808:	00004517          	auipc	a0,0x4
    280c:	66850513          	addi	a0,a0,1640 # 6e70 <malloc+0xe6a>
    2810:	00003097          	auipc	ra,0x3
    2814:	73e080e7          	jalr	1854(ra) # 5f4e <printf>
    exit(1);
    2818:	4505                	li	a0,1
    281a:	00003097          	auipc	ra,0x3
    281e:	3aa080e7          	jalr	938(ra) # 5bc4 <exit>
  close(fd);
    2822:	854a                	mv	a0,s2
    2824:	00003097          	auipc	ra,0x3
    2828:	3c8080e7          	jalr	968(ra) # 5bec <close>
  unlink("rwsbrk");
    282c:	00004517          	auipc	a0,0x4
    2830:	63c50513          	addi	a0,a0,1596 # 6e68 <malloc+0xe62>
    2834:	00003097          	auipc	ra,0x3
    2838:	3e0080e7          	jalr	992(ra) # 5c14 <unlink>
  fd = open("README", O_RDONLY);
    283c:	4581                	li	a1,0
    283e:	00004517          	auipc	a0,0x4
    2842:	ac250513          	addi	a0,a0,-1342 # 6300 <malloc+0x2fa>
    2846:	00003097          	auipc	ra,0x3
    284a:	3be080e7          	jalr	958(ra) # 5c04 <open>
    284e:	892a                	mv	s2,a0
  if(fd < 0){
    2850:	02054963          	bltz	a0,2882 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2854:	4629                	li	a2,10
    2856:	85a6                	mv	a1,s1
    2858:	00003097          	auipc	ra,0x3
    285c:	384080e7          	jalr	900(ra) # 5bdc <read>
    2860:	862a                	mv	a2,a0
  if(n >= 0){
    2862:	02054d63          	bltz	a0,289c <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2866:	85a6                	mv	a1,s1
    2868:	00004517          	auipc	a0,0x4
    286c:	65050513          	addi	a0,a0,1616 # 6eb8 <malloc+0xeb2>
    2870:	00003097          	auipc	ra,0x3
    2874:	6de080e7          	jalr	1758(ra) # 5f4e <printf>
    exit(1);
    2878:	4505                	li	a0,1
    287a:	00003097          	auipc	ra,0x3
    287e:	34a080e7          	jalr	842(ra) # 5bc4 <exit>
    printf("open(rwsbrk) failed\n");
    2882:	00004517          	auipc	a0,0x4
    2886:	5ee50513          	addi	a0,a0,1518 # 6e70 <malloc+0xe6a>
    288a:	00003097          	auipc	ra,0x3
    288e:	6c4080e7          	jalr	1732(ra) # 5f4e <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	00003097          	auipc	ra,0x3
    2898:	330080e7          	jalr	816(ra) # 5bc4 <exit>
  close(fd);
    289c:	854a                	mv	a0,s2
    289e:	00003097          	auipc	ra,0x3
    28a2:	34e080e7          	jalr	846(ra) # 5bec <close>
  exit(0);
    28a6:	4501                	li	a0,0
    28a8:	00003097          	auipc	ra,0x3
    28ac:	31c080e7          	jalr	796(ra) # 5bc4 <exit>

00000000000028b0 <sbrkbasic>:
{
    28b0:	7139                	addi	sp,sp,-64
    28b2:	fc06                	sd	ra,56(sp)
    28b4:	f822                	sd	s0,48(sp)
    28b6:	f426                	sd	s1,40(sp)
    28b8:	f04a                	sd	s2,32(sp)
    28ba:	ec4e                	sd	s3,24(sp)
    28bc:	e852                	sd	s4,16(sp)
    28be:	0080                	addi	s0,sp,64
    28c0:	8a2a                	mv	s4,a0
  pid = fork();
    28c2:	00003097          	auipc	ra,0x3
    28c6:	2fa080e7          	jalr	762(ra) # 5bbc <fork>
  if(pid < 0){
    28ca:	02054c63          	bltz	a0,2902 <sbrkbasic+0x52>
  if(pid == 0){
    28ce:	ed21                	bnez	a0,2926 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28d0:	40000537          	lui	a0,0x40000
    28d4:	00003097          	auipc	ra,0x3
    28d8:	378080e7          	jalr	888(ra) # 5c4c <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28dc:	57fd                	li	a5,-1
    28de:	02f50f63          	beq	a0,a5,291c <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28e2:	400007b7          	lui	a5,0x40000
    28e6:	97aa                	add	a5,a5,a0
      *b = 99;
    28e8:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28ec:	6705                	lui	a4,0x1
      *b = 99;
    28ee:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f2:	953a                	add	a0,a0,a4
    28f4:	fef51de3          	bne	a0,a5,28ee <sbrkbasic+0x3e>
    exit(1);
    28f8:	4505                	li	a0,1
    28fa:	00003097          	auipc	ra,0x3
    28fe:	2ca080e7          	jalr	714(ra) # 5bc4 <exit>
    printf("fork failed in sbrkbasic\n");
    2902:	00004517          	auipc	a0,0x4
    2906:	5de50513          	addi	a0,a0,1502 # 6ee0 <malloc+0xeda>
    290a:	00003097          	auipc	ra,0x3
    290e:	644080e7          	jalr	1604(ra) # 5f4e <printf>
    exit(1);
    2912:	4505                	li	a0,1
    2914:	00003097          	auipc	ra,0x3
    2918:	2b0080e7          	jalr	688(ra) # 5bc4 <exit>
      exit(0);
    291c:	4501                	li	a0,0
    291e:	00003097          	auipc	ra,0x3
    2922:	2a6080e7          	jalr	678(ra) # 5bc4 <exit>
  wait(&xstatus);
    2926:	fcc40513          	addi	a0,s0,-52
    292a:	00003097          	auipc	ra,0x3
    292e:	2a2080e7          	jalr	674(ra) # 5bcc <wait>
  if(xstatus == 1){
    2932:	fcc42703          	lw	a4,-52(s0)
    2936:	4785                	li	a5,1
    2938:	00f70d63          	beq	a4,a5,2952 <sbrkbasic+0xa2>
  a = sbrk(0);
    293c:	4501                	li	a0,0
    293e:	00003097          	auipc	ra,0x3
    2942:	30e080e7          	jalr	782(ra) # 5c4c <sbrk>
    2946:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2948:	4901                	li	s2,0
    294a:	6985                	lui	s3,0x1
    294c:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3c>
    2950:	a005                	j	2970 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2952:	85d2                	mv	a1,s4
    2954:	00004517          	auipc	a0,0x4
    2958:	5ac50513          	addi	a0,a0,1452 # 6f00 <malloc+0xefa>
    295c:	00003097          	auipc	ra,0x3
    2960:	5f2080e7          	jalr	1522(ra) # 5f4e <printf>
    exit(1);
    2964:	4505                	li	a0,1
    2966:	00003097          	auipc	ra,0x3
    296a:	25e080e7          	jalr	606(ra) # 5bc4 <exit>
    a = b + 1;
    296e:	84be                	mv	s1,a5
    b = sbrk(1);
    2970:	4505                	li	a0,1
    2972:	00003097          	auipc	ra,0x3
    2976:	2da080e7          	jalr	730(ra) # 5c4c <sbrk>
    if(b != a){
    297a:	04951c63          	bne	a0,s1,29d2 <sbrkbasic+0x122>
    *b = 1;
    297e:	4785                	li	a5,1
    2980:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2984:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2988:	2905                	addiw	s2,s2,1
    298a:	ff3912e3          	bne	s2,s3,296e <sbrkbasic+0xbe>
  pid = fork();
    298e:	00003097          	auipc	ra,0x3
    2992:	22e080e7          	jalr	558(ra) # 5bbc <fork>
    2996:	892a                	mv	s2,a0
  if(pid < 0){
    2998:	04054e63          	bltz	a0,29f4 <sbrkbasic+0x144>
  c = sbrk(1);
    299c:	4505                	li	a0,1
    299e:	00003097          	auipc	ra,0x3
    29a2:	2ae080e7          	jalr	686(ra) # 5c4c <sbrk>
  c = sbrk(1);
    29a6:	4505                	li	a0,1
    29a8:	00003097          	auipc	ra,0x3
    29ac:	2a4080e7          	jalr	676(ra) # 5c4c <sbrk>
  if(c != a + 1){
    29b0:	0489                	addi	s1,s1,2
    29b2:	04a48f63          	beq	s1,a0,2a10 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29b6:	85d2                	mv	a1,s4
    29b8:	00004517          	auipc	a0,0x4
    29bc:	5a850513          	addi	a0,a0,1448 # 6f60 <malloc+0xf5a>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	58e080e7          	jalr	1422(ra) # 5f4e <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	1fa080e7          	jalr	506(ra) # 5bc4 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29d2:	872a                	mv	a4,a0
    29d4:	86a6                	mv	a3,s1
    29d6:	864a                	mv	a2,s2
    29d8:	85d2                	mv	a1,s4
    29da:	00004517          	auipc	a0,0x4
    29de:	54650513          	addi	a0,a0,1350 # 6f20 <malloc+0xf1a>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	56c080e7          	jalr	1388(ra) # 5f4e <printf>
      exit(1);
    29ea:	4505                	li	a0,1
    29ec:	00003097          	auipc	ra,0x3
    29f0:	1d8080e7          	jalr	472(ra) # 5bc4 <exit>
    printf("%s: sbrk test fork failed\n", s);
    29f4:	85d2                	mv	a1,s4
    29f6:	00004517          	auipc	a0,0x4
    29fa:	54a50513          	addi	a0,a0,1354 # 6f40 <malloc+0xf3a>
    29fe:	00003097          	auipc	ra,0x3
    2a02:	550080e7          	jalr	1360(ra) # 5f4e <printf>
    exit(1);
    2a06:	4505                	li	a0,1
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	1bc080e7          	jalr	444(ra) # 5bc4 <exit>
  if(pid == 0)
    2a10:	00091763          	bnez	s2,2a1e <sbrkbasic+0x16e>
    exit(0);
    2a14:	4501                	li	a0,0
    2a16:	00003097          	auipc	ra,0x3
    2a1a:	1ae080e7          	jalr	430(ra) # 5bc4 <exit>
  wait(&xstatus);
    2a1e:	fcc40513          	addi	a0,s0,-52
    2a22:	00003097          	auipc	ra,0x3
    2a26:	1aa080e7          	jalr	426(ra) # 5bcc <wait>
  exit(xstatus);
    2a2a:	fcc42503          	lw	a0,-52(s0)
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	196080e7          	jalr	406(ra) # 5bc4 <exit>

0000000000002a36 <sbrkmuch>:
{
    2a36:	7179                	addi	sp,sp,-48
    2a38:	f406                	sd	ra,40(sp)
    2a3a:	f022                	sd	s0,32(sp)
    2a3c:	ec26                	sd	s1,24(sp)
    2a3e:	e84a                	sd	s2,16(sp)
    2a40:	e44e                	sd	s3,8(sp)
    2a42:	e052                	sd	s4,0(sp)
    2a44:	1800                	addi	s0,sp,48
    2a46:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a48:	4501                	li	a0,0
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	202080e7          	jalr	514(ra) # 5c4c <sbrk>
    2a52:	892a                	mv	s2,a0
  a = sbrk(0);
    2a54:	4501                	li	a0,0
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	1f6080e7          	jalr	502(ra) # 5c4c <sbrk>
    2a5e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a60:	06400537          	lui	a0,0x6400
    2a64:	9d05                	subw	a0,a0,s1
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	1e6080e7          	jalr	486(ra) # 5c4c <sbrk>
  if (p != a) {
    2a6e:	0ca49863          	bne	s1,a0,2b3e <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a72:	4501                	li	a0,0
    2a74:	00003097          	auipc	ra,0x3
    2a78:	1d8080e7          	jalr	472(ra) # 5c4c <sbrk>
    2a7c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a7e:	00a4f963          	bgeu	s1,a0,2a90 <sbrkmuch+0x5a>
    *pp = 1;
    2a82:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a84:	6705                	lui	a4,0x1
    *pp = 1;
    2a86:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a8a:	94ba                	add	s1,s1,a4
    2a8c:	fef4ede3          	bltu	s1,a5,2a86 <sbrkmuch+0x50>
  *lastaddr = 99;
    2a90:	064007b7          	lui	a5,0x6400
    2a94:	06300713          	li	a4,99
    2a98:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2a9c:	4501                	li	a0,0
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	1ae080e7          	jalr	430(ra) # 5c4c <sbrk>
    2aa6:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2aa8:	757d                	lui	a0,0xfffff
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	1a2080e7          	jalr	418(ra) # 5c4c <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ab2:	57fd                	li	a5,-1
    2ab4:	0af50363          	beq	a0,a5,2b5a <sbrkmuch+0x124>
  c = sbrk(0);
    2ab8:	4501                	li	a0,0
    2aba:	00003097          	auipc	ra,0x3
    2abe:	192080e7          	jalr	402(ra) # 5c4c <sbrk>
  if(c != a - PGSIZE){
    2ac2:	77fd                	lui	a5,0xfffff
    2ac4:	97a6                	add	a5,a5,s1
    2ac6:	0af51863          	bne	a0,a5,2b76 <sbrkmuch+0x140>
  a = sbrk(0);
    2aca:	4501                	li	a0,0
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	180080e7          	jalr	384(ra) # 5c4c <sbrk>
    2ad4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2ad6:	6505                	lui	a0,0x1
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	174080e7          	jalr	372(ra) # 5c4c <sbrk>
    2ae0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2ae2:	0aa49a63          	bne	s1,a0,2b96 <sbrkmuch+0x160>
    2ae6:	4501                	li	a0,0
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	164080e7          	jalr	356(ra) # 5c4c <sbrk>
    2af0:	6785                	lui	a5,0x1
    2af2:	97a6                	add	a5,a5,s1
    2af4:	0af51163          	bne	a0,a5,2b96 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2af8:	064007b7          	lui	a5,0x6400
    2afc:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b00:	06300793          	li	a5,99
    2b04:	0af70963          	beq	a4,a5,2bb6 <sbrkmuch+0x180>
  a = sbrk(0);
    2b08:	4501                	li	a0,0
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	142080e7          	jalr	322(ra) # 5c4c <sbrk>
    2b12:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b14:	4501                	li	a0,0
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	136080e7          	jalr	310(ra) # 5c4c <sbrk>
    2b1e:	40a9053b          	subw	a0,s2,a0
    2b22:	00003097          	auipc	ra,0x3
    2b26:	12a080e7          	jalr	298(ra) # 5c4c <sbrk>
  if(c != a){
    2b2a:	0aa49463          	bne	s1,a0,2bd2 <sbrkmuch+0x19c>
}
    2b2e:	70a2                	ld	ra,40(sp)
    2b30:	7402                	ld	s0,32(sp)
    2b32:	64e2                	ld	s1,24(sp)
    2b34:	6942                	ld	s2,16(sp)
    2b36:	69a2                	ld	s3,8(sp)
    2b38:	6a02                	ld	s4,0(sp)
    2b3a:	6145                	addi	sp,sp,48
    2b3c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b3e:	85ce                	mv	a1,s3
    2b40:	00004517          	auipc	a0,0x4
    2b44:	44050513          	addi	a0,a0,1088 # 6f80 <malloc+0xf7a>
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	406080e7          	jalr	1030(ra) # 5f4e <printf>
    exit(1);
    2b50:	4505                	li	a0,1
    2b52:	00003097          	auipc	ra,0x3
    2b56:	072080e7          	jalr	114(ra) # 5bc4 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b5a:	85ce                	mv	a1,s3
    2b5c:	00004517          	auipc	a0,0x4
    2b60:	46c50513          	addi	a0,a0,1132 # 6fc8 <malloc+0xfc2>
    2b64:	00003097          	auipc	ra,0x3
    2b68:	3ea080e7          	jalr	1002(ra) # 5f4e <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	056080e7          	jalr	86(ra) # 5bc4 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b76:	86aa                	mv	a3,a0
    2b78:	8626                	mv	a2,s1
    2b7a:	85ce                	mv	a1,s3
    2b7c:	00004517          	auipc	a0,0x4
    2b80:	46c50513          	addi	a0,a0,1132 # 6fe8 <malloc+0xfe2>
    2b84:	00003097          	auipc	ra,0x3
    2b88:	3ca080e7          	jalr	970(ra) # 5f4e <printf>
    exit(1);
    2b8c:	4505                	li	a0,1
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	036080e7          	jalr	54(ra) # 5bc4 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b96:	86d2                	mv	a3,s4
    2b98:	8626                	mv	a2,s1
    2b9a:	85ce                	mv	a1,s3
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	48c50513          	addi	a0,a0,1164 # 7028 <malloc+0x1022>
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	3aa080e7          	jalr	938(ra) # 5f4e <printf>
    exit(1);
    2bac:	4505                	li	a0,1
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	016080e7          	jalr	22(ra) # 5bc4 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bb6:	85ce                	mv	a1,s3
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	4a050513          	addi	a0,a0,1184 # 7058 <malloc+0x1052>
    2bc0:	00003097          	auipc	ra,0x3
    2bc4:	38e080e7          	jalr	910(ra) # 5f4e <printf>
    exit(1);
    2bc8:	4505                	li	a0,1
    2bca:	00003097          	auipc	ra,0x3
    2bce:	ffa080e7          	jalr	-6(ra) # 5bc4 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bd2:	86aa                	mv	a3,a0
    2bd4:	8626                	mv	a2,s1
    2bd6:	85ce                	mv	a1,s3
    2bd8:	00004517          	auipc	a0,0x4
    2bdc:	4b850513          	addi	a0,a0,1208 # 7090 <malloc+0x108a>
    2be0:	00003097          	auipc	ra,0x3
    2be4:	36e080e7          	jalr	878(ra) # 5f4e <printf>
    exit(1);
    2be8:	4505                	li	a0,1
    2bea:	00003097          	auipc	ra,0x3
    2bee:	fda080e7          	jalr	-38(ra) # 5bc4 <exit>

0000000000002bf2 <sbrkarg>:
{
    2bf2:	7179                	addi	sp,sp,-48
    2bf4:	f406                	sd	ra,40(sp)
    2bf6:	f022                	sd	s0,32(sp)
    2bf8:	ec26                	sd	s1,24(sp)
    2bfa:	e84a                	sd	s2,16(sp)
    2bfc:	e44e                	sd	s3,8(sp)
    2bfe:	1800                	addi	s0,sp,48
    2c00:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c02:	6505                	lui	a0,0x1
    2c04:	00003097          	auipc	ra,0x3
    2c08:	048080e7          	jalr	72(ra) # 5c4c <sbrk>
    2c0c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c0e:	20100593          	li	a1,513
    2c12:	00004517          	auipc	a0,0x4
    2c16:	4a650513          	addi	a0,a0,1190 # 70b8 <malloc+0x10b2>
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	fea080e7          	jalr	-22(ra) # 5c04 <open>
    2c22:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c24:	00004517          	auipc	a0,0x4
    2c28:	49450513          	addi	a0,a0,1172 # 70b8 <malloc+0x10b2>
    2c2c:	00003097          	auipc	ra,0x3
    2c30:	fe8080e7          	jalr	-24(ra) # 5c14 <unlink>
  if(fd < 0)  {
    2c34:	0404c163          	bltz	s1,2c76 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c38:	6605                	lui	a2,0x1
    2c3a:	85ca                	mv	a1,s2
    2c3c:	8526                	mv	a0,s1
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	fa6080e7          	jalr	-90(ra) # 5be4 <write>
    2c46:	04054663          	bltz	a0,2c92 <sbrkarg+0xa0>
  close(fd);
    2c4a:	8526                	mv	a0,s1
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	fa0080e7          	jalr	-96(ra) # 5bec <close>
  a = sbrk(PGSIZE);
    2c54:	6505                	lui	a0,0x1
    2c56:	00003097          	auipc	ra,0x3
    2c5a:	ff6080e7          	jalr	-10(ra) # 5c4c <sbrk>
  if(pipe((int *) a) != 0){
    2c5e:	00003097          	auipc	ra,0x3
    2c62:	f76080e7          	jalr	-138(ra) # 5bd4 <pipe>
    2c66:	e521                	bnez	a0,2cae <sbrkarg+0xbc>
}
    2c68:	70a2                	ld	ra,40(sp)
    2c6a:	7402                	ld	s0,32(sp)
    2c6c:	64e2                	ld	s1,24(sp)
    2c6e:	6942                	ld	s2,16(sp)
    2c70:	69a2                	ld	s3,8(sp)
    2c72:	6145                	addi	sp,sp,48
    2c74:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c76:	85ce                	mv	a1,s3
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	44850513          	addi	a0,a0,1096 # 70c0 <malloc+0x10ba>
    2c80:	00003097          	auipc	ra,0x3
    2c84:	2ce080e7          	jalr	718(ra) # 5f4e <printf>
    exit(1);
    2c88:	4505                	li	a0,1
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	f3a080e7          	jalr	-198(ra) # 5bc4 <exit>
    printf("%s: write sbrk failed\n", s);
    2c92:	85ce                	mv	a1,s3
    2c94:	00004517          	auipc	a0,0x4
    2c98:	44450513          	addi	a0,a0,1092 # 70d8 <malloc+0x10d2>
    2c9c:	00003097          	auipc	ra,0x3
    2ca0:	2b2080e7          	jalr	690(ra) # 5f4e <printf>
    exit(1);
    2ca4:	4505                	li	a0,1
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	f1e080e7          	jalr	-226(ra) # 5bc4 <exit>
    printf("%s: pipe() failed\n", s);
    2cae:	85ce                	mv	a1,s3
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	e0850513          	addi	a0,a0,-504 # 6ab8 <malloc+0xab2>
    2cb8:	00003097          	auipc	ra,0x3
    2cbc:	296080e7          	jalr	662(ra) # 5f4e <printf>
    exit(1);
    2cc0:	4505                	li	a0,1
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	f02080e7          	jalr	-254(ra) # 5bc4 <exit>

0000000000002cca <argptest>:
{
    2cca:	1101                	addi	sp,sp,-32
    2ccc:	ec06                	sd	ra,24(sp)
    2cce:	e822                	sd	s0,16(sp)
    2cd0:	e426                	sd	s1,8(sp)
    2cd2:	e04a                	sd	s2,0(sp)
    2cd4:	1000                	addi	s0,sp,32
    2cd6:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cd8:	4581                	li	a1,0
    2cda:	00004517          	auipc	a0,0x4
    2cde:	41650513          	addi	a0,a0,1046 # 70f0 <malloc+0x10ea>
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	f22080e7          	jalr	-222(ra) # 5c04 <open>
  if (fd < 0) {
    2cea:	02054b63          	bltz	a0,2d20 <argptest+0x56>
    2cee:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cf0:	4501                	li	a0,0
    2cf2:	00003097          	auipc	ra,0x3
    2cf6:	f5a080e7          	jalr	-166(ra) # 5c4c <sbrk>
    2cfa:	567d                	li	a2,-1
    2cfc:	fff50593          	addi	a1,a0,-1
    2d00:	8526                	mv	a0,s1
    2d02:	00003097          	auipc	ra,0x3
    2d06:	eda080e7          	jalr	-294(ra) # 5bdc <read>
  close(fd);
    2d0a:	8526                	mv	a0,s1
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	ee0080e7          	jalr	-288(ra) # 5bec <close>
}
    2d14:	60e2                	ld	ra,24(sp)
    2d16:	6442                	ld	s0,16(sp)
    2d18:	64a2                	ld	s1,8(sp)
    2d1a:	6902                	ld	s2,0(sp)
    2d1c:	6105                	addi	sp,sp,32
    2d1e:	8082                	ret
    printf("%s: open failed\n", s);
    2d20:	85ca                	mv	a1,s2
    2d22:	00004517          	auipc	a0,0x4
    2d26:	ca650513          	addi	a0,a0,-858 # 69c8 <malloc+0x9c2>
    2d2a:	00003097          	auipc	ra,0x3
    2d2e:	224080e7          	jalr	548(ra) # 5f4e <printf>
    exit(1);
    2d32:	4505                	li	a0,1
    2d34:	00003097          	auipc	ra,0x3
    2d38:	e90080e7          	jalr	-368(ra) # 5bc4 <exit>

0000000000002d3c <sbrkbugs>:
{
    2d3c:	1141                	addi	sp,sp,-16
    2d3e:	e406                	sd	ra,8(sp)
    2d40:	e022                	sd	s0,0(sp)
    2d42:	0800                	addi	s0,sp,16
  int pid = fork();
    2d44:	00003097          	auipc	ra,0x3
    2d48:	e78080e7          	jalr	-392(ra) # 5bbc <fork>
  if(pid < 0){
    2d4c:	02054263          	bltz	a0,2d70 <sbrkbugs+0x34>
  if(pid == 0){
    2d50:	ed0d                	bnez	a0,2d8a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d52:	00003097          	auipc	ra,0x3
    2d56:	efa080e7          	jalr	-262(ra) # 5c4c <sbrk>
    sbrk(-sz);
    2d5a:	40a0053b          	negw	a0,a0
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	eee080e7          	jalr	-274(ra) # 5c4c <sbrk>
    exit(0);
    2d66:	4501                	li	a0,0
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	e5c080e7          	jalr	-420(ra) # 5bc4 <exit>
    printf("fork failed\n");
    2d70:	00004517          	auipc	a0,0x4
    2d74:	04850513          	addi	a0,a0,72 # 6db8 <malloc+0xdb2>
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	1d6080e7          	jalr	470(ra) # 5f4e <printf>
    exit(1);
    2d80:	4505                	li	a0,1
    2d82:	00003097          	auipc	ra,0x3
    2d86:	e42080e7          	jalr	-446(ra) # 5bc4 <exit>
  wait(0);
    2d8a:	4501                	li	a0,0
    2d8c:	00003097          	auipc	ra,0x3
    2d90:	e40080e7          	jalr	-448(ra) # 5bcc <wait>
  pid = fork();
    2d94:	00003097          	auipc	ra,0x3
    2d98:	e28080e7          	jalr	-472(ra) # 5bbc <fork>
  if(pid < 0){
    2d9c:	02054563          	bltz	a0,2dc6 <sbrkbugs+0x8a>
  if(pid == 0){
    2da0:	e121                	bnez	a0,2de0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2da2:	00003097          	auipc	ra,0x3
    2da6:	eaa080e7          	jalr	-342(ra) # 5c4c <sbrk>
    sbrk(-(sz - 3500));
    2daa:	6785                	lui	a5,0x1
    2dac:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6c>
    2db0:	40a7853b          	subw	a0,a5,a0
    2db4:	00003097          	auipc	ra,0x3
    2db8:	e98080e7          	jalr	-360(ra) # 5c4c <sbrk>
    exit(0);
    2dbc:	4501                	li	a0,0
    2dbe:	00003097          	auipc	ra,0x3
    2dc2:	e06080e7          	jalr	-506(ra) # 5bc4 <exit>
    printf("fork failed\n");
    2dc6:	00004517          	auipc	a0,0x4
    2dca:	ff250513          	addi	a0,a0,-14 # 6db8 <malloc+0xdb2>
    2dce:	00003097          	auipc	ra,0x3
    2dd2:	180080e7          	jalr	384(ra) # 5f4e <printf>
    exit(1);
    2dd6:	4505                	li	a0,1
    2dd8:	00003097          	auipc	ra,0x3
    2ddc:	dec080e7          	jalr	-532(ra) # 5bc4 <exit>
  wait(0);
    2de0:	4501                	li	a0,0
    2de2:	00003097          	auipc	ra,0x3
    2de6:	dea080e7          	jalr	-534(ra) # 5bcc <wait>
  pid = fork();
    2dea:	00003097          	auipc	ra,0x3
    2dee:	dd2080e7          	jalr	-558(ra) # 5bbc <fork>
  if(pid < 0){
    2df2:	02054a63          	bltz	a0,2e26 <sbrkbugs+0xea>
  if(pid == 0){
    2df6:	e529                	bnez	a0,2e40 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	e54080e7          	jalr	-428(ra) # 5c4c <sbrk>
    2e00:	67ad                	lui	a5,0xb
    2e02:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2e06:	40a7853b          	subw	a0,a5,a0
    2e0a:	00003097          	auipc	ra,0x3
    2e0e:	e42080e7          	jalr	-446(ra) # 5c4c <sbrk>
    sbrk(-10);
    2e12:	5559                	li	a0,-10
    2e14:	00003097          	auipc	ra,0x3
    2e18:	e38080e7          	jalr	-456(ra) # 5c4c <sbrk>
    exit(0);
    2e1c:	4501                	li	a0,0
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	da6080e7          	jalr	-602(ra) # 5bc4 <exit>
    printf("fork failed\n");
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	f9250513          	addi	a0,a0,-110 # 6db8 <malloc+0xdb2>
    2e2e:	00003097          	auipc	ra,0x3
    2e32:	120080e7          	jalr	288(ra) # 5f4e <printf>
    exit(1);
    2e36:	4505                	li	a0,1
    2e38:	00003097          	auipc	ra,0x3
    2e3c:	d8c080e7          	jalr	-628(ra) # 5bc4 <exit>
  wait(0);
    2e40:	4501                	li	a0,0
    2e42:	00003097          	auipc	ra,0x3
    2e46:	d8a080e7          	jalr	-630(ra) # 5bcc <wait>
  exit(0);
    2e4a:	4501                	li	a0,0
    2e4c:	00003097          	auipc	ra,0x3
    2e50:	d78080e7          	jalr	-648(ra) # 5bc4 <exit>

0000000000002e54 <sbrklast>:
{
    2e54:	7179                	addi	sp,sp,-48
    2e56:	f406                	sd	ra,40(sp)
    2e58:	f022                	sd	s0,32(sp)
    2e5a:	ec26                	sd	s1,24(sp)
    2e5c:	e84a                	sd	s2,16(sp)
    2e5e:	e44e                	sd	s3,8(sp)
    2e60:	e052                	sd	s4,0(sp)
    2e62:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e64:	4501                	li	a0,0
    2e66:	00003097          	auipc	ra,0x3
    2e6a:	de6080e7          	jalr	-538(ra) # 5c4c <sbrk>
  if((top % 4096) != 0)
    2e6e:	03451793          	slli	a5,a0,0x34
    2e72:	ebd9                	bnez	a5,2f08 <sbrklast+0xb4>
  sbrk(4096);
    2e74:	6505                	lui	a0,0x1
    2e76:	00003097          	auipc	ra,0x3
    2e7a:	dd6080e7          	jalr	-554(ra) # 5c4c <sbrk>
  sbrk(10);
    2e7e:	4529                	li	a0,10
    2e80:	00003097          	auipc	ra,0x3
    2e84:	dcc080e7          	jalr	-564(ra) # 5c4c <sbrk>
  sbrk(-20);
    2e88:	5531                	li	a0,-20
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	dc2080e7          	jalr	-574(ra) # 5c4c <sbrk>
  top = (uint64) sbrk(0);
    2e92:	4501                	li	a0,0
    2e94:	00003097          	auipc	ra,0x3
    2e98:	db8080e7          	jalr	-584(ra) # 5c4c <sbrk>
    2e9c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2e9e:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2ea2:	07800a13          	li	s4,120
    2ea6:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2eaa:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eae:	20200593          	li	a1,514
    2eb2:	854a                	mv	a0,s2
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	d50080e7          	jalr	-688(ra) # 5c04 <open>
    2ebc:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ebe:	4605                	li	a2,1
    2ec0:	85ca                	mv	a1,s2
    2ec2:	00003097          	auipc	ra,0x3
    2ec6:	d22080e7          	jalr	-734(ra) # 5be4 <write>
  close(fd);
    2eca:	854e                	mv	a0,s3
    2ecc:	00003097          	auipc	ra,0x3
    2ed0:	d20080e7          	jalr	-736(ra) # 5bec <close>
  fd = open(p, O_RDWR);
    2ed4:	4589                	li	a1,2
    2ed6:	854a                	mv	a0,s2
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	d2c080e7          	jalr	-724(ra) # 5c04 <open>
  p[0] = '\0';
    2ee0:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ee4:	4605                	li	a2,1
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00003097          	auipc	ra,0x3
    2eec:	cf4080e7          	jalr	-780(ra) # 5bdc <read>
  if(p[0] != 'x')
    2ef0:	fc04c783          	lbu	a5,-64(s1)
    2ef4:	03479463          	bne	a5,s4,2f1c <sbrklast+0xc8>
}
    2ef8:	70a2                	ld	ra,40(sp)
    2efa:	7402                	ld	s0,32(sp)
    2efc:	64e2                	ld	s1,24(sp)
    2efe:	6942                	ld	s2,16(sp)
    2f00:	69a2                	ld	s3,8(sp)
    2f02:	6a02                	ld	s4,0(sp)
    2f04:	6145                	addi	sp,sp,48
    2f06:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f08:	0347d513          	srli	a0,a5,0x34
    2f0c:	6785                	lui	a5,0x1
    2f0e:	40a7853b          	subw	a0,a5,a0
    2f12:	00003097          	auipc	ra,0x3
    2f16:	d3a080e7          	jalr	-710(ra) # 5c4c <sbrk>
    2f1a:	bfa9                	j	2e74 <sbrklast+0x20>
    exit(1);
    2f1c:	4505                	li	a0,1
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	ca6080e7          	jalr	-858(ra) # 5bc4 <exit>

0000000000002f26 <sbrk8000>:
{
    2f26:	1141                	addi	sp,sp,-16
    2f28:	e406                	sd	ra,8(sp)
    2f2a:	e022                	sd	s0,0(sp)
    2f2c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f2e:	80000537          	lui	a0,0x80000
    2f32:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f34:	00003097          	auipc	ra,0x3
    2f38:	d18080e7          	jalr	-744(ra) # 5c4c <sbrk>
  volatile char *top = sbrk(0);
    2f3c:	4501                	li	a0,0
    2f3e:	00003097          	auipc	ra,0x3
    2f42:	d0e080e7          	jalr	-754(ra) # 5c4c <sbrk>
  *(top-1) = *(top-1) + 1;
    2f46:	fff54783          	lbu	a5,-1(a0)
    2f4a:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10b>
    2f4c:	0ff7f793          	zext.b	a5,a5
    2f50:	fef50fa3          	sb	a5,-1(a0)
}
    2f54:	60a2                	ld	ra,8(sp)
    2f56:	6402                	ld	s0,0(sp)
    2f58:	0141                	addi	sp,sp,16
    2f5a:	8082                	ret

0000000000002f5c <execout>:
{
    2f5c:	715d                	addi	sp,sp,-80
    2f5e:	e486                	sd	ra,72(sp)
    2f60:	e0a2                	sd	s0,64(sp)
    2f62:	fc26                	sd	s1,56(sp)
    2f64:	f84a                	sd	s2,48(sp)
    2f66:	f44e                	sd	s3,40(sp)
    2f68:	f052                	sd	s4,32(sp)
    2f6a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f6c:	4901                	li	s2,0
    2f6e:	49bd                	li	s3,15
    int pid = fork();
    2f70:	00003097          	auipc	ra,0x3
    2f74:	c4c080e7          	jalr	-948(ra) # 5bbc <fork>
    2f78:	84aa                	mv	s1,a0
    if(pid < 0){
    2f7a:	02054063          	bltz	a0,2f9a <execout+0x3e>
    } else if(pid == 0){
    2f7e:	c91d                	beqz	a0,2fb4 <execout+0x58>
      wait((int*)0);
    2f80:	4501                	li	a0,0
    2f82:	00003097          	auipc	ra,0x3
    2f86:	c4a080e7          	jalr	-950(ra) # 5bcc <wait>
  for(int avail = 0; avail < 15; avail++){
    2f8a:	2905                	addiw	s2,s2,1
    2f8c:	ff3912e3          	bne	s2,s3,2f70 <execout+0x14>
  exit(0);
    2f90:	4501                	li	a0,0
    2f92:	00003097          	auipc	ra,0x3
    2f96:	c32080e7          	jalr	-974(ra) # 5bc4 <exit>
      printf("fork failed\n");
    2f9a:	00004517          	auipc	a0,0x4
    2f9e:	e1e50513          	addi	a0,a0,-482 # 6db8 <malloc+0xdb2>
    2fa2:	00003097          	auipc	ra,0x3
    2fa6:	fac080e7          	jalr	-84(ra) # 5f4e <printf>
      exit(1);
    2faa:	4505                	li	a0,1
    2fac:	00003097          	auipc	ra,0x3
    2fb0:	c18080e7          	jalr	-1000(ra) # 5bc4 <exit>
        if(a == 0xffffffffffffffffLL)
    2fb4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fb6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fb8:	6505                	lui	a0,0x1
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	c92080e7          	jalr	-878(ra) # 5c4c <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fc2:	01350763          	beq	a0,s3,2fd0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fc6:	6785                	lui	a5,0x1
    2fc8:	97aa                	add	a5,a5,a0
    2fca:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x109>
      while(1){
    2fce:	b7ed                	j	2fb8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fd0:	01205a63          	blez	s2,2fe4 <execout+0x88>
        sbrk(-4096);
    2fd4:	757d                	lui	a0,0xfffff
    2fd6:	00003097          	auipc	ra,0x3
    2fda:	c76080e7          	jalr	-906(ra) # 5c4c <sbrk>
      for(int i = 0; i < avail; i++)
    2fde:	2485                	addiw	s1,s1,1
    2fe0:	ff249ae3          	bne	s1,s2,2fd4 <execout+0x78>
      close(1);
    2fe4:	4505                	li	a0,1
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	c06080e7          	jalr	-1018(ra) # 5bec <close>
      char *args[] = { "echo", "x", 0 };
    2fee:	00003517          	auipc	a0,0x3
    2ff2:	13a50513          	addi	a0,a0,314 # 6128 <malloc+0x122>
    2ff6:	faa43c23          	sd	a0,-72(s0)
    2ffa:	00003797          	auipc	a5,0x3
    2ffe:	19e78793          	addi	a5,a5,414 # 6198 <malloc+0x192>
    3002:	fcf43023          	sd	a5,-64(s0)
    3006:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    300a:	fb840593          	addi	a1,s0,-72
    300e:	00003097          	auipc	ra,0x3
    3012:	bee080e7          	jalr	-1042(ra) # 5bfc <exec>
      exit(0);
    3016:	4501                	li	a0,0
    3018:	00003097          	auipc	ra,0x3
    301c:	bac080e7          	jalr	-1108(ra) # 5bc4 <exit>

0000000000003020 <fourteen>:
{
    3020:	1101                	addi	sp,sp,-32
    3022:	ec06                	sd	ra,24(sp)
    3024:	e822                	sd	s0,16(sp)
    3026:	e426                	sd	s1,8(sp)
    3028:	1000                	addi	s0,sp,32
    302a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    302c:	00004517          	auipc	a0,0x4
    3030:	29c50513          	addi	a0,a0,668 # 72c8 <malloc+0x12c2>
    3034:	00003097          	auipc	ra,0x3
    3038:	bf8080e7          	jalr	-1032(ra) # 5c2c <mkdir>
    303c:	e165                	bnez	a0,311c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    303e:	00004517          	auipc	a0,0x4
    3042:	0e250513          	addi	a0,a0,226 # 7120 <malloc+0x111a>
    3046:	00003097          	auipc	ra,0x3
    304a:	be6080e7          	jalr	-1050(ra) # 5c2c <mkdir>
    304e:	e56d                	bnez	a0,3138 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3050:	20000593          	li	a1,512
    3054:	00004517          	auipc	a0,0x4
    3058:	12450513          	addi	a0,a0,292 # 7178 <malloc+0x1172>
    305c:	00003097          	auipc	ra,0x3
    3060:	ba8080e7          	jalr	-1112(ra) # 5c04 <open>
  if(fd < 0){
    3064:	0e054863          	bltz	a0,3154 <fourteen+0x134>
  close(fd);
    3068:	00003097          	auipc	ra,0x3
    306c:	b84080e7          	jalr	-1148(ra) # 5bec <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3070:	4581                	li	a1,0
    3072:	00004517          	auipc	a0,0x4
    3076:	17e50513          	addi	a0,a0,382 # 71f0 <malloc+0x11ea>
    307a:	00003097          	auipc	ra,0x3
    307e:	b8a080e7          	jalr	-1142(ra) # 5c04 <open>
  if(fd < 0){
    3082:	0e054763          	bltz	a0,3170 <fourteen+0x150>
  close(fd);
    3086:	00003097          	auipc	ra,0x3
    308a:	b66080e7          	jalr	-1178(ra) # 5bec <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    308e:	00004517          	auipc	a0,0x4
    3092:	1d250513          	addi	a0,a0,466 # 7260 <malloc+0x125a>
    3096:	00003097          	auipc	ra,0x3
    309a:	b96080e7          	jalr	-1130(ra) # 5c2c <mkdir>
    309e:	c57d                	beqz	a0,318c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30a0:	00004517          	auipc	a0,0x4
    30a4:	21850513          	addi	a0,a0,536 # 72b8 <malloc+0x12b2>
    30a8:	00003097          	auipc	ra,0x3
    30ac:	b84080e7          	jalr	-1148(ra) # 5c2c <mkdir>
    30b0:	cd65                	beqz	a0,31a8 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30b2:	00004517          	auipc	a0,0x4
    30b6:	20650513          	addi	a0,a0,518 # 72b8 <malloc+0x12b2>
    30ba:	00003097          	auipc	ra,0x3
    30be:	b5a080e7          	jalr	-1190(ra) # 5c14 <unlink>
  unlink("12345678901234/12345678901234");
    30c2:	00004517          	auipc	a0,0x4
    30c6:	19e50513          	addi	a0,a0,414 # 7260 <malloc+0x125a>
    30ca:	00003097          	auipc	ra,0x3
    30ce:	b4a080e7          	jalr	-1206(ra) # 5c14 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30d2:	00004517          	auipc	a0,0x4
    30d6:	11e50513          	addi	a0,a0,286 # 71f0 <malloc+0x11ea>
    30da:	00003097          	auipc	ra,0x3
    30de:	b3a080e7          	jalr	-1222(ra) # 5c14 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30e2:	00004517          	auipc	a0,0x4
    30e6:	09650513          	addi	a0,a0,150 # 7178 <malloc+0x1172>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	b2a080e7          	jalr	-1238(ra) # 5c14 <unlink>
  unlink("12345678901234/123456789012345");
    30f2:	00004517          	auipc	a0,0x4
    30f6:	02e50513          	addi	a0,a0,46 # 7120 <malloc+0x111a>
    30fa:	00003097          	auipc	ra,0x3
    30fe:	b1a080e7          	jalr	-1254(ra) # 5c14 <unlink>
  unlink("12345678901234");
    3102:	00004517          	auipc	a0,0x4
    3106:	1c650513          	addi	a0,a0,454 # 72c8 <malloc+0x12c2>
    310a:	00003097          	auipc	ra,0x3
    310e:	b0a080e7          	jalr	-1270(ra) # 5c14 <unlink>
}
    3112:	60e2                	ld	ra,24(sp)
    3114:	6442                	ld	s0,16(sp)
    3116:	64a2                	ld	s1,8(sp)
    3118:	6105                	addi	sp,sp,32
    311a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    311c:	85a6                	mv	a1,s1
    311e:	00004517          	auipc	a0,0x4
    3122:	fda50513          	addi	a0,a0,-38 # 70f8 <malloc+0x10f2>
    3126:	00003097          	auipc	ra,0x3
    312a:	e28080e7          	jalr	-472(ra) # 5f4e <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	00003097          	auipc	ra,0x3
    3134:	a94080e7          	jalr	-1388(ra) # 5bc4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3138:	85a6                	mv	a1,s1
    313a:	00004517          	auipc	a0,0x4
    313e:	00650513          	addi	a0,a0,6 # 7140 <malloc+0x113a>
    3142:	00003097          	auipc	ra,0x3
    3146:	e0c080e7          	jalr	-500(ra) # 5f4e <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	00003097          	auipc	ra,0x3
    3150:	a78080e7          	jalr	-1416(ra) # 5bc4 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3154:	85a6                	mv	a1,s1
    3156:	00004517          	auipc	a0,0x4
    315a:	05250513          	addi	a0,a0,82 # 71a8 <malloc+0x11a2>
    315e:	00003097          	auipc	ra,0x3
    3162:	df0080e7          	jalr	-528(ra) # 5f4e <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	00003097          	auipc	ra,0x3
    316c:	a5c080e7          	jalr	-1444(ra) # 5bc4 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3170:	85a6                	mv	a1,s1
    3172:	00004517          	auipc	a0,0x4
    3176:	0ae50513          	addi	a0,a0,174 # 7220 <malloc+0x121a>
    317a:	00003097          	auipc	ra,0x3
    317e:	dd4080e7          	jalr	-556(ra) # 5f4e <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00003097          	auipc	ra,0x3
    3188:	a40080e7          	jalr	-1472(ra) # 5bc4 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    318c:	85a6                	mv	a1,s1
    318e:	00004517          	auipc	a0,0x4
    3192:	0f250513          	addi	a0,a0,242 # 7280 <malloc+0x127a>
    3196:	00003097          	auipc	ra,0x3
    319a:	db8080e7          	jalr	-584(ra) # 5f4e <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00003097          	auipc	ra,0x3
    31a4:	a24080e7          	jalr	-1500(ra) # 5bc4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31a8:	85a6                	mv	a1,s1
    31aa:	00004517          	auipc	a0,0x4
    31ae:	12e50513          	addi	a0,a0,302 # 72d8 <malloc+0x12d2>
    31b2:	00003097          	auipc	ra,0x3
    31b6:	d9c080e7          	jalr	-612(ra) # 5f4e <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	00003097          	auipc	ra,0x3
    31c0:	a08080e7          	jalr	-1528(ra) # 5bc4 <exit>

00000000000031c4 <diskfull>:
{
    31c4:	b9010113          	addi	sp,sp,-1136
    31c8:	46113423          	sd	ra,1128(sp)
    31cc:	46813023          	sd	s0,1120(sp)
    31d0:	44913c23          	sd	s1,1112(sp)
    31d4:	45213823          	sd	s2,1104(sp)
    31d8:	45313423          	sd	s3,1096(sp)
    31dc:	45413023          	sd	s4,1088(sp)
    31e0:	43513c23          	sd	s5,1080(sp)
    31e4:	43613823          	sd	s6,1072(sp)
    31e8:	43713423          	sd	s7,1064(sp)
    31ec:	43813023          	sd	s8,1056(sp)
    31f0:	47010413          	addi	s0,sp,1136
    31f4:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    31f6:	00004517          	auipc	a0,0x4
    31fa:	11a50513          	addi	a0,a0,282 # 7310 <malloc+0x130a>
    31fe:	00003097          	auipc	ra,0x3
    3202:	a16080e7          	jalr	-1514(ra) # 5c14 <unlink>
  for(fi = 0; done == 0; fi++){
    3206:	4a01                	li	s4,0
    name[0] = 'b';
    3208:	06200b93          	li	s7,98
    name[1] = 'i';
    320c:	06900b13          	li	s6,105
    name[2] = 'g';
    3210:	06700a93          	li	s5,103
    3214:	69c1                	lui	s3,0x10
    3216:	10b98993          	addi	s3,s3,267 # 1010b <base+0x493>
    321a:	aabd                	j	3398 <diskfull+0x1d4>
      printf("%s: could not create file %s\n", s, name);
    321c:	b9040613          	addi	a2,s0,-1136
    3220:	85e2                	mv	a1,s8
    3222:	00004517          	auipc	a0,0x4
    3226:	0fe50513          	addi	a0,a0,254 # 7320 <malloc+0x131a>
    322a:	00003097          	auipc	ra,0x3
    322e:	d24080e7          	jalr	-732(ra) # 5f4e <printf>
      break;
    3232:	a821                	j	324a <diskfull+0x86>
        close(fd);
    3234:	854a                	mv	a0,s2
    3236:	00003097          	auipc	ra,0x3
    323a:	9b6080e7          	jalr	-1610(ra) # 5bec <close>
    close(fd);
    323e:	854a                	mv	a0,s2
    3240:	00003097          	auipc	ra,0x3
    3244:	9ac080e7          	jalr	-1620(ra) # 5bec <close>
  for(fi = 0; done == 0; fi++){
    3248:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    324a:	4481                	li	s1,0
    name[0] = 'z';
    324c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3250:	08000993          	li	s3,128
    name[0] = 'z';
    3254:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3258:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    325c:	41f4d71b          	sraiw	a4,s1,0x1f
    3260:	01b7571b          	srliw	a4,a4,0x1b
    3264:	009707bb          	addw	a5,a4,s1
    3268:	4057d69b          	sraiw	a3,a5,0x5
    326c:	0306869b          	addiw	a3,a3,48
    3270:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3274:	8bfd                	andi	a5,a5,31
    3276:	9f99                	subw	a5,a5,a4
    3278:	0307879b          	addiw	a5,a5,48
    327c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3280:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3284:	bb040513          	addi	a0,s0,-1104
    3288:	00003097          	auipc	ra,0x3
    328c:	98c080e7          	jalr	-1652(ra) # 5c14 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3290:	60200593          	li	a1,1538
    3294:	bb040513          	addi	a0,s0,-1104
    3298:	00003097          	auipc	ra,0x3
    329c:	96c080e7          	jalr	-1684(ra) # 5c04 <open>
    if(fd < 0)
    32a0:	00054963          	bltz	a0,32b2 <diskfull+0xee>
    close(fd);
    32a4:	00003097          	auipc	ra,0x3
    32a8:	948080e7          	jalr	-1720(ra) # 5bec <close>
  for(int i = 0; i < nzz; i++){
    32ac:	2485                	addiw	s1,s1,1
    32ae:	fb3493e3          	bne	s1,s3,3254 <diskfull+0x90>
  if(mkdir("diskfulldir") == 0)
    32b2:	00004517          	auipc	a0,0x4
    32b6:	05e50513          	addi	a0,a0,94 # 7310 <malloc+0x130a>
    32ba:	00003097          	auipc	ra,0x3
    32be:	972080e7          	jalr	-1678(ra) # 5c2c <mkdir>
    32c2:	12050963          	beqz	a0,33f4 <diskfull+0x230>
  unlink("diskfulldir");
    32c6:	00004517          	auipc	a0,0x4
    32ca:	04a50513          	addi	a0,a0,74 # 7310 <malloc+0x130a>
    32ce:	00003097          	auipc	ra,0x3
    32d2:	946080e7          	jalr	-1722(ra) # 5c14 <unlink>
  for(int i = 0; i < nzz; i++){
    32d6:	4481                	li	s1,0
    name[0] = 'z';
    32d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32dc:	08000993          	li	s3,128
    name[0] = 'z';
    32e0:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32e4:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32e8:	41f4d71b          	sraiw	a4,s1,0x1f
    32ec:	01b7571b          	srliw	a4,a4,0x1b
    32f0:	009707bb          	addw	a5,a4,s1
    32f4:	4057d69b          	sraiw	a3,a5,0x5
    32f8:	0306869b          	addiw	a3,a3,48
    32fc:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3300:	8bfd                	andi	a5,a5,31
    3302:	9f99                	subw	a5,a5,a4
    3304:	0307879b          	addiw	a5,a5,48
    3308:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    330c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3310:	bb040513          	addi	a0,s0,-1104
    3314:	00003097          	auipc	ra,0x3
    3318:	900080e7          	jalr	-1792(ra) # 5c14 <unlink>
  for(int i = 0; i < nzz; i++){
    331c:	2485                	addiw	s1,s1,1
    331e:	fd3491e3          	bne	s1,s3,32e0 <diskfull+0x11c>
  for(int i = 0; i < fi; i++){
    3322:	03405e63          	blez	s4,335e <diskfull+0x19a>
    3326:	4481                	li	s1,0
    name[0] = 'b';
    3328:	06200a93          	li	s5,98
    name[1] = 'i';
    332c:	06900993          	li	s3,105
    name[2] = 'g';
    3330:	06700913          	li	s2,103
    name[0] = 'b';
    3334:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3338:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    333c:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3340:	0304879b          	addiw	a5,s1,48
    3344:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3348:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    334c:	bb040513          	addi	a0,s0,-1104
    3350:	00003097          	auipc	ra,0x3
    3354:	8c4080e7          	jalr	-1852(ra) # 5c14 <unlink>
  for(int i = 0; i < fi; i++){
    3358:	2485                	addiw	s1,s1,1
    335a:	fd449de3          	bne	s1,s4,3334 <diskfull+0x170>
}
    335e:	46813083          	ld	ra,1128(sp)
    3362:	46013403          	ld	s0,1120(sp)
    3366:	45813483          	ld	s1,1112(sp)
    336a:	45013903          	ld	s2,1104(sp)
    336e:	44813983          	ld	s3,1096(sp)
    3372:	44013a03          	ld	s4,1088(sp)
    3376:	43813a83          	ld	s5,1080(sp)
    337a:	43013b03          	ld	s6,1072(sp)
    337e:	42813b83          	ld	s7,1064(sp)
    3382:	42013c03          	ld	s8,1056(sp)
    3386:	47010113          	addi	sp,sp,1136
    338a:	8082                	ret
    close(fd);
    338c:	854a                	mv	a0,s2
    338e:	00003097          	auipc	ra,0x3
    3392:	85e080e7          	jalr	-1954(ra) # 5bec <close>
  for(fi = 0; done == 0; fi++){
    3396:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    3398:	b9740823          	sb	s7,-1136(s0)
    name[1] = 'i';
    339c:	b96408a3          	sb	s6,-1135(s0)
    name[2] = 'g';
    33a0:	b9540923          	sb	s5,-1134(s0)
    name[3] = '0' + fi;
    33a4:	030a079b          	addiw	a5,s4,48
    33a8:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33ac:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33b0:	b9040513          	addi	a0,s0,-1136
    33b4:	00003097          	auipc	ra,0x3
    33b8:	860080e7          	jalr	-1952(ra) # 5c14 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33bc:	60200593          	li	a1,1538
    33c0:	b9040513          	addi	a0,s0,-1136
    33c4:	00003097          	auipc	ra,0x3
    33c8:	840080e7          	jalr	-1984(ra) # 5c04 <open>
    33cc:	892a                	mv	s2,a0
    if(fd < 0){
    33ce:	e40547e3          	bltz	a0,321c <diskfull+0x58>
    33d2:	84ce                	mv	s1,s3
      if(write(fd, buf, BSIZE) != BSIZE){
    33d4:	40000613          	li	a2,1024
    33d8:	bb040593          	addi	a1,s0,-1104
    33dc:	854a                	mv	a0,s2
    33de:	00003097          	auipc	ra,0x3
    33e2:	806080e7          	jalr	-2042(ra) # 5be4 <write>
    33e6:	40000793          	li	a5,1024
    33ea:	e4f515e3          	bne	a0,a5,3234 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    33ee:	34fd                	addiw	s1,s1,-1
    33f0:	f0f5                	bnez	s1,33d4 <diskfull+0x210>
    33f2:	bf69                	j	338c <diskfull+0x1c8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33f4:	00004517          	auipc	a0,0x4
    33f8:	f4c50513          	addi	a0,a0,-180 # 7340 <malloc+0x133a>
    33fc:	00003097          	auipc	ra,0x3
    3400:	b52080e7          	jalr	-1198(ra) # 5f4e <printf>
    3404:	b5c9                	j	32c6 <diskfull+0x102>

0000000000003406 <iputtest>:
{
    3406:	1101                	addi	sp,sp,-32
    3408:	ec06                	sd	ra,24(sp)
    340a:	e822                	sd	s0,16(sp)
    340c:	e426                	sd	s1,8(sp)
    340e:	1000                	addi	s0,sp,32
    3410:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3412:	00004517          	auipc	a0,0x4
    3416:	f5e50513          	addi	a0,a0,-162 # 7370 <malloc+0x136a>
    341a:	00003097          	auipc	ra,0x3
    341e:	812080e7          	jalr	-2030(ra) # 5c2c <mkdir>
    3422:	04054563          	bltz	a0,346c <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3426:	00004517          	auipc	a0,0x4
    342a:	f4a50513          	addi	a0,a0,-182 # 7370 <malloc+0x136a>
    342e:	00003097          	auipc	ra,0x3
    3432:	806080e7          	jalr	-2042(ra) # 5c34 <chdir>
    3436:	04054963          	bltz	a0,3488 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    343a:	00004517          	auipc	a0,0x4
    343e:	f7650513          	addi	a0,a0,-138 # 73b0 <malloc+0x13aa>
    3442:	00002097          	auipc	ra,0x2
    3446:	7d2080e7          	jalr	2002(ra) # 5c14 <unlink>
    344a:	04054d63          	bltz	a0,34a4 <iputtest+0x9e>
  if(chdir("/") < 0){
    344e:	00004517          	auipc	a0,0x4
    3452:	f9250513          	addi	a0,a0,-110 # 73e0 <malloc+0x13da>
    3456:	00002097          	auipc	ra,0x2
    345a:	7de080e7          	jalr	2014(ra) # 5c34 <chdir>
    345e:	06054163          	bltz	a0,34c0 <iputtest+0xba>
}
    3462:	60e2                	ld	ra,24(sp)
    3464:	6442                	ld	s0,16(sp)
    3466:	64a2                	ld	s1,8(sp)
    3468:	6105                	addi	sp,sp,32
    346a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    346c:	85a6                	mv	a1,s1
    346e:	00004517          	auipc	a0,0x4
    3472:	f0a50513          	addi	a0,a0,-246 # 7378 <malloc+0x1372>
    3476:	00003097          	auipc	ra,0x3
    347a:	ad8080e7          	jalr	-1320(ra) # 5f4e <printf>
    exit(1);
    347e:	4505                	li	a0,1
    3480:	00002097          	auipc	ra,0x2
    3484:	744080e7          	jalr	1860(ra) # 5bc4 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3488:	85a6                	mv	a1,s1
    348a:	00004517          	auipc	a0,0x4
    348e:	f0650513          	addi	a0,a0,-250 # 7390 <malloc+0x138a>
    3492:	00003097          	auipc	ra,0x3
    3496:	abc080e7          	jalr	-1348(ra) # 5f4e <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	00002097          	auipc	ra,0x2
    34a0:	728080e7          	jalr	1832(ra) # 5bc4 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34a4:	85a6                	mv	a1,s1
    34a6:	00004517          	auipc	a0,0x4
    34aa:	f1a50513          	addi	a0,a0,-230 # 73c0 <malloc+0x13ba>
    34ae:	00003097          	auipc	ra,0x3
    34b2:	aa0080e7          	jalr	-1376(ra) # 5f4e <printf>
    exit(1);
    34b6:	4505                	li	a0,1
    34b8:	00002097          	auipc	ra,0x2
    34bc:	70c080e7          	jalr	1804(ra) # 5bc4 <exit>
    printf("%s: chdir / failed\n", s);
    34c0:	85a6                	mv	a1,s1
    34c2:	00004517          	auipc	a0,0x4
    34c6:	f2650513          	addi	a0,a0,-218 # 73e8 <malloc+0x13e2>
    34ca:	00003097          	auipc	ra,0x3
    34ce:	a84080e7          	jalr	-1404(ra) # 5f4e <printf>
    exit(1);
    34d2:	4505                	li	a0,1
    34d4:	00002097          	auipc	ra,0x2
    34d8:	6f0080e7          	jalr	1776(ra) # 5bc4 <exit>

00000000000034dc <exitiputtest>:
{
    34dc:	7179                	addi	sp,sp,-48
    34de:	f406                	sd	ra,40(sp)
    34e0:	f022                	sd	s0,32(sp)
    34e2:	ec26                	sd	s1,24(sp)
    34e4:	1800                	addi	s0,sp,48
    34e6:	84aa                	mv	s1,a0
  pid = fork();
    34e8:	00002097          	auipc	ra,0x2
    34ec:	6d4080e7          	jalr	1748(ra) # 5bbc <fork>
  if(pid < 0){
    34f0:	04054663          	bltz	a0,353c <exitiputtest+0x60>
  if(pid == 0){
    34f4:	ed45                	bnez	a0,35ac <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34f6:	00004517          	auipc	a0,0x4
    34fa:	e7a50513          	addi	a0,a0,-390 # 7370 <malloc+0x136a>
    34fe:	00002097          	auipc	ra,0x2
    3502:	72e080e7          	jalr	1838(ra) # 5c2c <mkdir>
    3506:	04054963          	bltz	a0,3558 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    350a:	00004517          	auipc	a0,0x4
    350e:	e6650513          	addi	a0,a0,-410 # 7370 <malloc+0x136a>
    3512:	00002097          	auipc	ra,0x2
    3516:	722080e7          	jalr	1826(ra) # 5c34 <chdir>
    351a:	04054d63          	bltz	a0,3574 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    351e:	00004517          	auipc	a0,0x4
    3522:	e9250513          	addi	a0,a0,-366 # 73b0 <malloc+0x13aa>
    3526:	00002097          	auipc	ra,0x2
    352a:	6ee080e7          	jalr	1774(ra) # 5c14 <unlink>
    352e:	06054163          	bltz	a0,3590 <exitiputtest+0xb4>
    exit(0);
    3532:	4501                	li	a0,0
    3534:	00002097          	auipc	ra,0x2
    3538:	690080e7          	jalr	1680(ra) # 5bc4 <exit>
    printf("%s: fork failed\n", s);
    353c:	85a6                	mv	a1,s1
    353e:	00003517          	auipc	a0,0x3
    3542:	47250513          	addi	a0,a0,1138 # 69b0 <malloc+0x9aa>
    3546:	00003097          	auipc	ra,0x3
    354a:	a08080e7          	jalr	-1528(ra) # 5f4e <printf>
    exit(1);
    354e:	4505                	li	a0,1
    3550:	00002097          	auipc	ra,0x2
    3554:	674080e7          	jalr	1652(ra) # 5bc4 <exit>
      printf("%s: mkdir failed\n", s);
    3558:	85a6                	mv	a1,s1
    355a:	00004517          	auipc	a0,0x4
    355e:	e1e50513          	addi	a0,a0,-482 # 7378 <malloc+0x1372>
    3562:	00003097          	auipc	ra,0x3
    3566:	9ec080e7          	jalr	-1556(ra) # 5f4e <printf>
      exit(1);
    356a:	4505                	li	a0,1
    356c:	00002097          	auipc	ra,0x2
    3570:	658080e7          	jalr	1624(ra) # 5bc4 <exit>
      printf("%s: child chdir failed\n", s);
    3574:	85a6                	mv	a1,s1
    3576:	00004517          	auipc	a0,0x4
    357a:	e8a50513          	addi	a0,a0,-374 # 7400 <malloc+0x13fa>
    357e:	00003097          	auipc	ra,0x3
    3582:	9d0080e7          	jalr	-1584(ra) # 5f4e <printf>
      exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	63c080e7          	jalr	1596(ra) # 5bc4 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3590:	85a6                	mv	a1,s1
    3592:	00004517          	auipc	a0,0x4
    3596:	e2e50513          	addi	a0,a0,-466 # 73c0 <malloc+0x13ba>
    359a:	00003097          	auipc	ra,0x3
    359e:	9b4080e7          	jalr	-1612(ra) # 5f4e <printf>
      exit(1);
    35a2:	4505                	li	a0,1
    35a4:	00002097          	auipc	ra,0x2
    35a8:	620080e7          	jalr	1568(ra) # 5bc4 <exit>
  wait(&xstatus);
    35ac:	fdc40513          	addi	a0,s0,-36
    35b0:	00002097          	auipc	ra,0x2
    35b4:	61c080e7          	jalr	1564(ra) # 5bcc <wait>
  exit(xstatus);
    35b8:	fdc42503          	lw	a0,-36(s0)
    35bc:	00002097          	auipc	ra,0x2
    35c0:	608080e7          	jalr	1544(ra) # 5bc4 <exit>

00000000000035c4 <dirtest>:
{
    35c4:	1101                	addi	sp,sp,-32
    35c6:	ec06                	sd	ra,24(sp)
    35c8:	e822                	sd	s0,16(sp)
    35ca:	e426                	sd	s1,8(sp)
    35cc:	1000                	addi	s0,sp,32
    35ce:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35d0:	00004517          	auipc	a0,0x4
    35d4:	e4850513          	addi	a0,a0,-440 # 7418 <malloc+0x1412>
    35d8:	00002097          	auipc	ra,0x2
    35dc:	654080e7          	jalr	1620(ra) # 5c2c <mkdir>
    35e0:	04054563          	bltz	a0,362a <dirtest+0x66>
  if(chdir("dir0") < 0){
    35e4:	00004517          	auipc	a0,0x4
    35e8:	e3450513          	addi	a0,a0,-460 # 7418 <malloc+0x1412>
    35ec:	00002097          	auipc	ra,0x2
    35f0:	648080e7          	jalr	1608(ra) # 5c34 <chdir>
    35f4:	04054963          	bltz	a0,3646 <dirtest+0x82>
  if(chdir("..") < 0){
    35f8:	00004517          	auipc	a0,0x4
    35fc:	e4050513          	addi	a0,a0,-448 # 7438 <malloc+0x1432>
    3600:	00002097          	auipc	ra,0x2
    3604:	634080e7          	jalr	1588(ra) # 5c34 <chdir>
    3608:	04054d63          	bltz	a0,3662 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    360c:	00004517          	auipc	a0,0x4
    3610:	e0c50513          	addi	a0,a0,-500 # 7418 <malloc+0x1412>
    3614:	00002097          	auipc	ra,0x2
    3618:	600080e7          	jalr	1536(ra) # 5c14 <unlink>
    361c:	06054163          	bltz	a0,367e <dirtest+0xba>
}
    3620:	60e2                	ld	ra,24(sp)
    3622:	6442                	ld	s0,16(sp)
    3624:	64a2                	ld	s1,8(sp)
    3626:	6105                	addi	sp,sp,32
    3628:	8082                	ret
    printf("%s: mkdir failed\n", s);
    362a:	85a6                	mv	a1,s1
    362c:	00004517          	auipc	a0,0x4
    3630:	d4c50513          	addi	a0,a0,-692 # 7378 <malloc+0x1372>
    3634:	00003097          	auipc	ra,0x3
    3638:	91a080e7          	jalr	-1766(ra) # 5f4e <printf>
    exit(1);
    363c:	4505                	li	a0,1
    363e:	00002097          	auipc	ra,0x2
    3642:	586080e7          	jalr	1414(ra) # 5bc4 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3646:	85a6                	mv	a1,s1
    3648:	00004517          	auipc	a0,0x4
    364c:	dd850513          	addi	a0,a0,-552 # 7420 <malloc+0x141a>
    3650:	00003097          	auipc	ra,0x3
    3654:	8fe080e7          	jalr	-1794(ra) # 5f4e <printf>
    exit(1);
    3658:	4505                	li	a0,1
    365a:	00002097          	auipc	ra,0x2
    365e:	56a080e7          	jalr	1386(ra) # 5bc4 <exit>
    printf("%s: chdir .. failed\n", s);
    3662:	85a6                	mv	a1,s1
    3664:	00004517          	auipc	a0,0x4
    3668:	ddc50513          	addi	a0,a0,-548 # 7440 <malloc+0x143a>
    366c:	00003097          	auipc	ra,0x3
    3670:	8e2080e7          	jalr	-1822(ra) # 5f4e <printf>
    exit(1);
    3674:	4505                	li	a0,1
    3676:	00002097          	auipc	ra,0x2
    367a:	54e080e7          	jalr	1358(ra) # 5bc4 <exit>
    printf("%s: unlink dir0 failed\n", s);
    367e:	85a6                	mv	a1,s1
    3680:	00004517          	auipc	a0,0x4
    3684:	dd850513          	addi	a0,a0,-552 # 7458 <malloc+0x1452>
    3688:	00003097          	auipc	ra,0x3
    368c:	8c6080e7          	jalr	-1850(ra) # 5f4e <printf>
    exit(1);
    3690:	4505                	li	a0,1
    3692:	00002097          	auipc	ra,0x2
    3696:	532080e7          	jalr	1330(ra) # 5bc4 <exit>

000000000000369a <subdir>:
{
    369a:	1101                	addi	sp,sp,-32
    369c:	ec06                	sd	ra,24(sp)
    369e:	e822                	sd	s0,16(sp)
    36a0:	e426                	sd	s1,8(sp)
    36a2:	e04a                	sd	s2,0(sp)
    36a4:	1000                	addi	s0,sp,32
    36a6:	892a                	mv	s2,a0
  unlink("ff");
    36a8:	00004517          	auipc	a0,0x4
    36ac:	ef850513          	addi	a0,a0,-264 # 75a0 <malloc+0x159a>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	564080e7          	jalr	1380(ra) # 5c14 <unlink>
  if(mkdir("dd") != 0){
    36b8:	00004517          	auipc	a0,0x4
    36bc:	db850513          	addi	a0,a0,-584 # 7470 <malloc+0x146a>
    36c0:	00002097          	auipc	ra,0x2
    36c4:	56c080e7          	jalr	1388(ra) # 5c2c <mkdir>
    36c8:	38051663          	bnez	a0,3a54 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36cc:	20200593          	li	a1,514
    36d0:	00004517          	auipc	a0,0x4
    36d4:	dc050513          	addi	a0,a0,-576 # 7490 <malloc+0x148a>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	52c080e7          	jalr	1324(ra) # 5c04 <open>
    36e0:	84aa                	mv	s1,a0
  if(fd < 0){
    36e2:	38054763          	bltz	a0,3a70 <subdir+0x3d6>
  write(fd, "ff", 2);
    36e6:	4609                	li	a2,2
    36e8:	00004597          	auipc	a1,0x4
    36ec:	eb858593          	addi	a1,a1,-328 # 75a0 <malloc+0x159a>
    36f0:	00002097          	auipc	ra,0x2
    36f4:	4f4080e7          	jalr	1268(ra) # 5be4 <write>
  close(fd);
    36f8:	8526                	mv	a0,s1
    36fa:	00002097          	auipc	ra,0x2
    36fe:	4f2080e7          	jalr	1266(ra) # 5bec <close>
  if(unlink("dd") >= 0){
    3702:	00004517          	auipc	a0,0x4
    3706:	d6e50513          	addi	a0,a0,-658 # 7470 <malloc+0x146a>
    370a:	00002097          	auipc	ra,0x2
    370e:	50a080e7          	jalr	1290(ra) # 5c14 <unlink>
    3712:	36055d63          	bgez	a0,3a8c <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3716:	00004517          	auipc	a0,0x4
    371a:	dd250513          	addi	a0,a0,-558 # 74e8 <malloc+0x14e2>
    371e:	00002097          	auipc	ra,0x2
    3722:	50e080e7          	jalr	1294(ra) # 5c2c <mkdir>
    3726:	38051163          	bnez	a0,3aa8 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    372a:	20200593          	li	a1,514
    372e:	00004517          	auipc	a0,0x4
    3732:	de250513          	addi	a0,a0,-542 # 7510 <malloc+0x150a>
    3736:	00002097          	auipc	ra,0x2
    373a:	4ce080e7          	jalr	1230(ra) # 5c04 <open>
    373e:	84aa                	mv	s1,a0
  if(fd < 0){
    3740:	38054263          	bltz	a0,3ac4 <subdir+0x42a>
  write(fd, "FF", 2);
    3744:	4609                	li	a2,2
    3746:	00004597          	auipc	a1,0x4
    374a:	dfa58593          	addi	a1,a1,-518 # 7540 <malloc+0x153a>
    374e:	00002097          	auipc	ra,0x2
    3752:	496080e7          	jalr	1174(ra) # 5be4 <write>
  close(fd);
    3756:	8526                	mv	a0,s1
    3758:	00002097          	auipc	ra,0x2
    375c:	494080e7          	jalr	1172(ra) # 5bec <close>
  fd = open("dd/dd/../ff", 0);
    3760:	4581                	li	a1,0
    3762:	00004517          	auipc	a0,0x4
    3766:	de650513          	addi	a0,a0,-538 # 7548 <malloc+0x1542>
    376a:	00002097          	auipc	ra,0x2
    376e:	49a080e7          	jalr	1178(ra) # 5c04 <open>
    3772:	84aa                	mv	s1,a0
  if(fd < 0){
    3774:	36054663          	bltz	a0,3ae0 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3778:	660d                	lui	a2,0x3
    377a:	00009597          	auipc	a1,0x9
    377e:	4fe58593          	addi	a1,a1,1278 # cc78 <buf>
    3782:	00002097          	auipc	ra,0x2
    3786:	45a080e7          	jalr	1114(ra) # 5bdc <read>
  if(cc != 2 || buf[0] != 'f'){
    378a:	4789                	li	a5,2
    378c:	36f51863          	bne	a0,a5,3afc <subdir+0x462>
    3790:	00009717          	auipc	a4,0x9
    3794:	4e874703          	lbu	a4,1256(a4) # cc78 <buf>
    3798:	06600793          	li	a5,102
    379c:	36f71063          	bne	a4,a5,3afc <subdir+0x462>
  close(fd);
    37a0:	8526                	mv	a0,s1
    37a2:	00002097          	auipc	ra,0x2
    37a6:	44a080e7          	jalr	1098(ra) # 5bec <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37aa:	00004597          	auipc	a1,0x4
    37ae:	dee58593          	addi	a1,a1,-530 # 7598 <malloc+0x1592>
    37b2:	00004517          	auipc	a0,0x4
    37b6:	d5e50513          	addi	a0,a0,-674 # 7510 <malloc+0x150a>
    37ba:	00002097          	auipc	ra,0x2
    37be:	46a080e7          	jalr	1130(ra) # 5c24 <link>
    37c2:	34051b63          	bnez	a0,3b18 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37c6:	00004517          	auipc	a0,0x4
    37ca:	d4a50513          	addi	a0,a0,-694 # 7510 <malloc+0x150a>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	446080e7          	jalr	1094(ra) # 5c14 <unlink>
    37d6:	34051f63          	bnez	a0,3b34 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37da:	4581                	li	a1,0
    37dc:	00004517          	auipc	a0,0x4
    37e0:	d3450513          	addi	a0,a0,-716 # 7510 <malloc+0x150a>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	420080e7          	jalr	1056(ra) # 5c04 <open>
    37ec:	36055263          	bgez	a0,3b50 <subdir+0x4b6>
  if(chdir("dd") != 0){
    37f0:	00004517          	auipc	a0,0x4
    37f4:	c8050513          	addi	a0,a0,-896 # 7470 <malloc+0x146a>
    37f8:	00002097          	auipc	ra,0x2
    37fc:	43c080e7          	jalr	1084(ra) # 5c34 <chdir>
    3800:	36051663          	bnez	a0,3b6c <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3804:	00004517          	auipc	a0,0x4
    3808:	e2c50513          	addi	a0,a0,-468 # 7630 <malloc+0x162a>
    380c:	00002097          	auipc	ra,0x2
    3810:	428080e7          	jalr	1064(ra) # 5c34 <chdir>
    3814:	36051a63          	bnez	a0,3b88 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3818:	00004517          	auipc	a0,0x4
    381c:	e4850513          	addi	a0,a0,-440 # 7660 <malloc+0x165a>
    3820:	00002097          	auipc	ra,0x2
    3824:	414080e7          	jalr	1044(ra) # 5c34 <chdir>
    3828:	36051e63          	bnez	a0,3ba4 <subdir+0x50a>
  if(chdir("./..") != 0){
    382c:	00004517          	auipc	a0,0x4
    3830:	e6450513          	addi	a0,a0,-412 # 7690 <malloc+0x168a>
    3834:	00002097          	auipc	ra,0x2
    3838:	400080e7          	jalr	1024(ra) # 5c34 <chdir>
    383c:	38051263          	bnez	a0,3bc0 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3840:	4581                	li	a1,0
    3842:	00004517          	auipc	a0,0x4
    3846:	d5650513          	addi	a0,a0,-682 # 7598 <malloc+0x1592>
    384a:	00002097          	auipc	ra,0x2
    384e:	3ba080e7          	jalr	954(ra) # 5c04 <open>
    3852:	84aa                	mv	s1,a0
  if(fd < 0){
    3854:	38054463          	bltz	a0,3bdc <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3858:	660d                	lui	a2,0x3
    385a:	00009597          	auipc	a1,0x9
    385e:	41e58593          	addi	a1,a1,1054 # cc78 <buf>
    3862:	00002097          	auipc	ra,0x2
    3866:	37a080e7          	jalr	890(ra) # 5bdc <read>
    386a:	4789                	li	a5,2
    386c:	38f51663          	bne	a0,a5,3bf8 <subdir+0x55e>
  close(fd);
    3870:	8526                	mv	a0,s1
    3872:	00002097          	auipc	ra,0x2
    3876:	37a080e7          	jalr	890(ra) # 5bec <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    387a:	4581                	li	a1,0
    387c:	00004517          	auipc	a0,0x4
    3880:	c9450513          	addi	a0,a0,-876 # 7510 <malloc+0x150a>
    3884:	00002097          	auipc	ra,0x2
    3888:	380080e7          	jalr	896(ra) # 5c04 <open>
    388c:	38055463          	bgez	a0,3c14 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3890:	20200593          	li	a1,514
    3894:	00004517          	auipc	a0,0x4
    3898:	e8c50513          	addi	a0,a0,-372 # 7720 <malloc+0x171a>
    389c:	00002097          	auipc	ra,0x2
    38a0:	368080e7          	jalr	872(ra) # 5c04 <open>
    38a4:	38055663          	bgez	a0,3c30 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38a8:	20200593          	li	a1,514
    38ac:	00004517          	auipc	a0,0x4
    38b0:	ea450513          	addi	a0,a0,-348 # 7750 <malloc+0x174a>
    38b4:	00002097          	auipc	ra,0x2
    38b8:	350080e7          	jalr	848(ra) # 5c04 <open>
    38bc:	38055863          	bgez	a0,3c4c <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38c0:	20000593          	li	a1,512
    38c4:	00004517          	auipc	a0,0x4
    38c8:	bac50513          	addi	a0,a0,-1108 # 7470 <malloc+0x146a>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	338080e7          	jalr	824(ra) # 5c04 <open>
    38d4:	38055a63          	bgez	a0,3c68 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38d8:	4589                	li	a1,2
    38da:	00004517          	auipc	a0,0x4
    38de:	b9650513          	addi	a0,a0,-1130 # 7470 <malloc+0x146a>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	322080e7          	jalr	802(ra) # 5c04 <open>
    38ea:	38055d63          	bgez	a0,3c84 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38ee:	4585                	li	a1,1
    38f0:	00004517          	auipc	a0,0x4
    38f4:	b8050513          	addi	a0,a0,-1152 # 7470 <malloc+0x146a>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	30c080e7          	jalr	780(ra) # 5c04 <open>
    3900:	3a055063          	bgez	a0,3ca0 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3904:	00004597          	auipc	a1,0x4
    3908:	edc58593          	addi	a1,a1,-292 # 77e0 <malloc+0x17da>
    390c:	00004517          	auipc	a0,0x4
    3910:	e1450513          	addi	a0,a0,-492 # 7720 <malloc+0x171a>
    3914:	00002097          	auipc	ra,0x2
    3918:	310080e7          	jalr	784(ra) # 5c24 <link>
    391c:	3a050063          	beqz	a0,3cbc <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3920:	00004597          	auipc	a1,0x4
    3924:	ec058593          	addi	a1,a1,-320 # 77e0 <malloc+0x17da>
    3928:	00004517          	auipc	a0,0x4
    392c:	e2850513          	addi	a0,a0,-472 # 7750 <malloc+0x174a>
    3930:	00002097          	auipc	ra,0x2
    3934:	2f4080e7          	jalr	756(ra) # 5c24 <link>
    3938:	3a050063          	beqz	a0,3cd8 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    393c:	00004597          	auipc	a1,0x4
    3940:	c5c58593          	addi	a1,a1,-932 # 7598 <malloc+0x1592>
    3944:	00004517          	auipc	a0,0x4
    3948:	b4c50513          	addi	a0,a0,-1204 # 7490 <malloc+0x148a>
    394c:	00002097          	auipc	ra,0x2
    3950:	2d8080e7          	jalr	728(ra) # 5c24 <link>
    3954:	3a050063          	beqz	a0,3cf4 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3958:	00004517          	auipc	a0,0x4
    395c:	dc850513          	addi	a0,a0,-568 # 7720 <malloc+0x171a>
    3960:	00002097          	auipc	ra,0x2
    3964:	2cc080e7          	jalr	716(ra) # 5c2c <mkdir>
    3968:	3a050463          	beqz	a0,3d10 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    396c:	00004517          	auipc	a0,0x4
    3970:	de450513          	addi	a0,a0,-540 # 7750 <malloc+0x174a>
    3974:	00002097          	auipc	ra,0x2
    3978:	2b8080e7          	jalr	696(ra) # 5c2c <mkdir>
    397c:	3a050863          	beqz	a0,3d2c <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3980:	00004517          	auipc	a0,0x4
    3984:	c1850513          	addi	a0,a0,-1000 # 7598 <malloc+0x1592>
    3988:	00002097          	auipc	ra,0x2
    398c:	2a4080e7          	jalr	676(ra) # 5c2c <mkdir>
    3990:	3a050c63          	beqz	a0,3d48 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3994:	00004517          	auipc	a0,0x4
    3998:	dbc50513          	addi	a0,a0,-580 # 7750 <malloc+0x174a>
    399c:	00002097          	auipc	ra,0x2
    39a0:	278080e7          	jalr	632(ra) # 5c14 <unlink>
    39a4:	3c050063          	beqz	a0,3d64 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39a8:	00004517          	auipc	a0,0x4
    39ac:	d7850513          	addi	a0,a0,-648 # 7720 <malloc+0x171a>
    39b0:	00002097          	auipc	ra,0x2
    39b4:	264080e7          	jalr	612(ra) # 5c14 <unlink>
    39b8:	3c050463          	beqz	a0,3d80 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39bc:	00004517          	auipc	a0,0x4
    39c0:	ad450513          	addi	a0,a0,-1324 # 7490 <malloc+0x148a>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	270080e7          	jalr	624(ra) # 5c34 <chdir>
    39cc:	3c050863          	beqz	a0,3d9c <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39d0:	00004517          	auipc	a0,0x4
    39d4:	f6050513          	addi	a0,a0,-160 # 7930 <malloc+0x192a>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	25c080e7          	jalr	604(ra) # 5c34 <chdir>
    39e0:	3c050c63          	beqz	a0,3db8 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39e4:	00004517          	auipc	a0,0x4
    39e8:	bb450513          	addi	a0,a0,-1100 # 7598 <malloc+0x1592>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	228080e7          	jalr	552(ra) # 5c14 <unlink>
    39f4:	3e051063          	bnez	a0,3dd4 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39f8:	00004517          	auipc	a0,0x4
    39fc:	a9850513          	addi	a0,a0,-1384 # 7490 <malloc+0x148a>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	214080e7          	jalr	532(ra) # 5c14 <unlink>
    3a08:	3e051463          	bnez	a0,3df0 <subdir+0x756>
  if(unlink("dd") == 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	a6450513          	addi	a0,a0,-1436 # 7470 <malloc+0x146a>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	200080e7          	jalr	512(ra) # 5c14 <unlink>
    3a1c:	3e050863          	beqz	a0,3e0c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	f8050513          	addi	a0,a0,-128 # 79a0 <malloc+0x199a>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	1ec080e7          	jalr	492(ra) # 5c14 <unlink>
    3a30:	3e054c63          	bltz	a0,3e28 <subdir+0x78e>
  if(unlink("dd") < 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	a3c50513          	addi	a0,a0,-1476 # 7470 <malloc+0x146a>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	1d8080e7          	jalr	472(ra) # 5c14 <unlink>
    3a44:	40054063          	bltz	a0,3e44 <subdir+0x7aa>
}
    3a48:	60e2                	ld	ra,24(sp)
    3a4a:	6442                	ld	s0,16(sp)
    3a4c:	64a2                	ld	s1,8(sp)
    3a4e:	6902                	ld	s2,0(sp)
    3a50:	6105                	addi	sp,sp,32
    3a52:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a54:	85ca                	mv	a1,s2
    3a56:	00004517          	auipc	a0,0x4
    3a5a:	a2250513          	addi	a0,a0,-1502 # 7478 <malloc+0x1472>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	4f0080e7          	jalr	1264(ra) # 5f4e <printf>
    exit(1);
    3a66:	4505                	li	a0,1
    3a68:	00002097          	auipc	ra,0x2
    3a6c:	15c080e7          	jalr	348(ra) # 5bc4 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a70:	85ca                	mv	a1,s2
    3a72:	00004517          	auipc	a0,0x4
    3a76:	a2650513          	addi	a0,a0,-1498 # 7498 <malloc+0x1492>
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	4d4080e7          	jalr	1236(ra) # 5f4e <printf>
    exit(1);
    3a82:	4505                	li	a0,1
    3a84:	00002097          	auipc	ra,0x2
    3a88:	140080e7          	jalr	320(ra) # 5bc4 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a8c:	85ca                	mv	a1,s2
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	a2a50513          	addi	a0,a0,-1494 # 74b8 <malloc+0x14b2>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	4b8080e7          	jalr	1208(ra) # 5f4e <printf>
    exit(1);
    3a9e:	4505                	li	a0,1
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	124080e7          	jalr	292(ra) # 5bc4 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3aa8:	85ca                	mv	a1,s2
    3aaa:	00004517          	auipc	a0,0x4
    3aae:	a4650513          	addi	a0,a0,-1466 # 74f0 <malloc+0x14ea>
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	49c080e7          	jalr	1180(ra) # 5f4e <printf>
    exit(1);
    3aba:	4505                	li	a0,1
    3abc:	00002097          	auipc	ra,0x2
    3ac0:	108080e7          	jalr	264(ra) # 5bc4 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ac4:	85ca                	mv	a1,s2
    3ac6:	00004517          	auipc	a0,0x4
    3aca:	a5a50513          	addi	a0,a0,-1446 # 7520 <malloc+0x151a>
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	480080e7          	jalr	1152(ra) # 5f4e <printf>
    exit(1);
    3ad6:	4505                	li	a0,1
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	0ec080e7          	jalr	236(ra) # 5bc4 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3ae0:	85ca                	mv	a1,s2
    3ae2:	00004517          	auipc	a0,0x4
    3ae6:	a7650513          	addi	a0,a0,-1418 # 7558 <malloc+0x1552>
    3aea:	00002097          	auipc	ra,0x2
    3aee:	464080e7          	jalr	1124(ra) # 5f4e <printf>
    exit(1);
    3af2:	4505                	li	a0,1
    3af4:	00002097          	auipc	ra,0x2
    3af8:	0d0080e7          	jalr	208(ra) # 5bc4 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3afc:	85ca                	mv	a1,s2
    3afe:	00004517          	auipc	a0,0x4
    3b02:	a7a50513          	addi	a0,a0,-1414 # 7578 <malloc+0x1572>
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	448080e7          	jalr	1096(ra) # 5f4e <printf>
    exit(1);
    3b0e:	4505                	li	a0,1
    3b10:	00002097          	auipc	ra,0x2
    3b14:	0b4080e7          	jalr	180(ra) # 5bc4 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b18:	85ca                	mv	a1,s2
    3b1a:	00004517          	auipc	a0,0x4
    3b1e:	a8e50513          	addi	a0,a0,-1394 # 75a8 <malloc+0x15a2>
    3b22:	00002097          	auipc	ra,0x2
    3b26:	42c080e7          	jalr	1068(ra) # 5f4e <printf>
    exit(1);
    3b2a:	4505                	li	a0,1
    3b2c:	00002097          	auipc	ra,0x2
    3b30:	098080e7          	jalr	152(ra) # 5bc4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b34:	85ca                	mv	a1,s2
    3b36:	00004517          	auipc	a0,0x4
    3b3a:	a9a50513          	addi	a0,a0,-1382 # 75d0 <malloc+0x15ca>
    3b3e:	00002097          	auipc	ra,0x2
    3b42:	410080e7          	jalr	1040(ra) # 5f4e <printf>
    exit(1);
    3b46:	4505                	li	a0,1
    3b48:	00002097          	auipc	ra,0x2
    3b4c:	07c080e7          	jalr	124(ra) # 5bc4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b50:	85ca                	mv	a1,s2
    3b52:	00004517          	auipc	a0,0x4
    3b56:	a9e50513          	addi	a0,a0,-1378 # 75f0 <malloc+0x15ea>
    3b5a:	00002097          	auipc	ra,0x2
    3b5e:	3f4080e7          	jalr	1012(ra) # 5f4e <printf>
    exit(1);
    3b62:	4505                	li	a0,1
    3b64:	00002097          	auipc	ra,0x2
    3b68:	060080e7          	jalr	96(ra) # 5bc4 <exit>
    printf("%s: chdir dd failed\n", s);
    3b6c:	85ca                	mv	a1,s2
    3b6e:	00004517          	auipc	a0,0x4
    3b72:	aaa50513          	addi	a0,a0,-1366 # 7618 <malloc+0x1612>
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	3d8080e7          	jalr	984(ra) # 5f4e <printf>
    exit(1);
    3b7e:	4505                	li	a0,1
    3b80:	00002097          	auipc	ra,0x2
    3b84:	044080e7          	jalr	68(ra) # 5bc4 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b88:	85ca                	mv	a1,s2
    3b8a:	00004517          	auipc	a0,0x4
    3b8e:	ab650513          	addi	a0,a0,-1354 # 7640 <malloc+0x163a>
    3b92:	00002097          	auipc	ra,0x2
    3b96:	3bc080e7          	jalr	956(ra) # 5f4e <printf>
    exit(1);
    3b9a:	4505                	li	a0,1
    3b9c:	00002097          	auipc	ra,0x2
    3ba0:	028080e7          	jalr	40(ra) # 5bc4 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3ba4:	85ca                	mv	a1,s2
    3ba6:	00004517          	auipc	a0,0x4
    3baa:	aca50513          	addi	a0,a0,-1334 # 7670 <malloc+0x166a>
    3bae:	00002097          	auipc	ra,0x2
    3bb2:	3a0080e7          	jalr	928(ra) # 5f4e <printf>
    exit(1);
    3bb6:	4505                	li	a0,1
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	00c080e7          	jalr	12(ra) # 5bc4 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bc0:	85ca                	mv	a1,s2
    3bc2:	00004517          	auipc	a0,0x4
    3bc6:	ad650513          	addi	a0,a0,-1322 # 7698 <malloc+0x1692>
    3bca:	00002097          	auipc	ra,0x2
    3bce:	384080e7          	jalr	900(ra) # 5f4e <printf>
    exit(1);
    3bd2:	4505                	li	a0,1
    3bd4:	00002097          	auipc	ra,0x2
    3bd8:	ff0080e7          	jalr	-16(ra) # 5bc4 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bdc:	85ca                	mv	a1,s2
    3bde:	00004517          	auipc	a0,0x4
    3be2:	ad250513          	addi	a0,a0,-1326 # 76b0 <malloc+0x16aa>
    3be6:	00002097          	auipc	ra,0x2
    3bea:	368080e7          	jalr	872(ra) # 5f4e <printf>
    exit(1);
    3bee:	4505                	li	a0,1
    3bf0:	00002097          	auipc	ra,0x2
    3bf4:	fd4080e7          	jalr	-44(ra) # 5bc4 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bf8:	85ca                	mv	a1,s2
    3bfa:	00004517          	auipc	a0,0x4
    3bfe:	ad650513          	addi	a0,a0,-1322 # 76d0 <malloc+0x16ca>
    3c02:	00002097          	auipc	ra,0x2
    3c06:	34c080e7          	jalr	844(ra) # 5f4e <printf>
    exit(1);
    3c0a:	4505                	li	a0,1
    3c0c:	00002097          	auipc	ra,0x2
    3c10:	fb8080e7          	jalr	-72(ra) # 5bc4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c14:	85ca                	mv	a1,s2
    3c16:	00004517          	auipc	a0,0x4
    3c1a:	ada50513          	addi	a0,a0,-1318 # 76f0 <malloc+0x16ea>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	330080e7          	jalr	816(ra) # 5f4e <printf>
    exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	f9c080e7          	jalr	-100(ra) # 5bc4 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c30:	85ca                	mv	a1,s2
    3c32:	00004517          	auipc	a0,0x4
    3c36:	afe50513          	addi	a0,a0,-1282 # 7730 <malloc+0x172a>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	314080e7          	jalr	788(ra) # 5f4e <printf>
    exit(1);
    3c42:	4505                	li	a0,1
    3c44:	00002097          	auipc	ra,0x2
    3c48:	f80080e7          	jalr	-128(ra) # 5bc4 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c4c:	85ca                	mv	a1,s2
    3c4e:	00004517          	auipc	a0,0x4
    3c52:	b1250513          	addi	a0,a0,-1262 # 7760 <malloc+0x175a>
    3c56:	00002097          	auipc	ra,0x2
    3c5a:	2f8080e7          	jalr	760(ra) # 5f4e <printf>
    exit(1);
    3c5e:	4505                	li	a0,1
    3c60:	00002097          	auipc	ra,0x2
    3c64:	f64080e7          	jalr	-156(ra) # 5bc4 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c68:	85ca                	mv	a1,s2
    3c6a:	00004517          	auipc	a0,0x4
    3c6e:	b1650513          	addi	a0,a0,-1258 # 7780 <malloc+0x177a>
    3c72:	00002097          	auipc	ra,0x2
    3c76:	2dc080e7          	jalr	732(ra) # 5f4e <printf>
    exit(1);
    3c7a:	4505                	li	a0,1
    3c7c:	00002097          	auipc	ra,0x2
    3c80:	f48080e7          	jalr	-184(ra) # 5bc4 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c84:	85ca                	mv	a1,s2
    3c86:	00004517          	auipc	a0,0x4
    3c8a:	b1a50513          	addi	a0,a0,-1254 # 77a0 <malloc+0x179a>
    3c8e:	00002097          	auipc	ra,0x2
    3c92:	2c0080e7          	jalr	704(ra) # 5f4e <printf>
    exit(1);
    3c96:	4505                	li	a0,1
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	f2c080e7          	jalr	-212(ra) # 5bc4 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3ca0:	85ca                	mv	a1,s2
    3ca2:	00004517          	auipc	a0,0x4
    3ca6:	b1e50513          	addi	a0,a0,-1250 # 77c0 <malloc+0x17ba>
    3caa:	00002097          	auipc	ra,0x2
    3cae:	2a4080e7          	jalr	676(ra) # 5f4e <printf>
    exit(1);
    3cb2:	4505                	li	a0,1
    3cb4:	00002097          	auipc	ra,0x2
    3cb8:	f10080e7          	jalr	-240(ra) # 5bc4 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cbc:	85ca                	mv	a1,s2
    3cbe:	00004517          	auipc	a0,0x4
    3cc2:	b3250513          	addi	a0,a0,-1230 # 77f0 <malloc+0x17ea>
    3cc6:	00002097          	auipc	ra,0x2
    3cca:	288080e7          	jalr	648(ra) # 5f4e <printf>
    exit(1);
    3cce:	4505                	li	a0,1
    3cd0:	00002097          	auipc	ra,0x2
    3cd4:	ef4080e7          	jalr	-268(ra) # 5bc4 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cd8:	85ca                	mv	a1,s2
    3cda:	00004517          	auipc	a0,0x4
    3cde:	b3e50513          	addi	a0,a0,-1218 # 7818 <malloc+0x1812>
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	26c080e7          	jalr	620(ra) # 5f4e <printf>
    exit(1);
    3cea:	4505                	li	a0,1
    3cec:	00002097          	auipc	ra,0x2
    3cf0:	ed8080e7          	jalr	-296(ra) # 5bc4 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cf4:	85ca                	mv	a1,s2
    3cf6:	00004517          	auipc	a0,0x4
    3cfa:	b4a50513          	addi	a0,a0,-1206 # 7840 <malloc+0x183a>
    3cfe:	00002097          	auipc	ra,0x2
    3d02:	250080e7          	jalr	592(ra) # 5f4e <printf>
    exit(1);
    3d06:	4505                	li	a0,1
    3d08:	00002097          	auipc	ra,0x2
    3d0c:	ebc080e7          	jalr	-324(ra) # 5bc4 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d10:	85ca                	mv	a1,s2
    3d12:	00004517          	auipc	a0,0x4
    3d16:	b5650513          	addi	a0,a0,-1194 # 7868 <malloc+0x1862>
    3d1a:	00002097          	auipc	ra,0x2
    3d1e:	234080e7          	jalr	564(ra) # 5f4e <printf>
    exit(1);
    3d22:	4505                	li	a0,1
    3d24:	00002097          	auipc	ra,0x2
    3d28:	ea0080e7          	jalr	-352(ra) # 5bc4 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d2c:	85ca                	mv	a1,s2
    3d2e:	00004517          	auipc	a0,0x4
    3d32:	b5a50513          	addi	a0,a0,-1190 # 7888 <malloc+0x1882>
    3d36:	00002097          	auipc	ra,0x2
    3d3a:	218080e7          	jalr	536(ra) # 5f4e <printf>
    exit(1);
    3d3e:	4505                	li	a0,1
    3d40:	00002097          	auipc	ra,0x2
    3d44:	e84080e7          	jalr	-380(ra) # 5bc4 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d48:	85ca                	mv	a1,s2
    3d4a:	00004517          	auipc	a0,0x4
    3d4e:	b5e50513          	addi	a0,a0,-1186 # 78a8 <malloc+0x18a2>
    3d52:	00002097          	auipc	ra,0x2
    3d56:	1fc080e7          	jalr	508(ra) # 5f4e <printf>
    exit(1);
    3d5a:	4505                	li	a0,1
    3d5c:	00002097          	auipc	ra,0x2
    3d60:	e68080e7          	jalr	-408(ra) # 5bc4 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d64:	85ca                	mv	a1,s2
    3d66:	00004517          	auipc	a0,0x4
    3d6a:	b6a50513          	addi	a0,a0,-1174 # 78d0 <malloc+0x18ca>
    3d6e:	00002097          	auipc	ra,0x2
    3d72:	1e0080e7          	jalr	480(ra) # 5f4e <printf>
    exit(1);
    3d76:	4505                	li	a0,1
    3d78:	00002097          	auipc	ra,0x2
    3d7c:	e4c080e7          	jalr	-436(ra) # 5bc4 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d80:	85ca                	mv	a1,s2
    3d82:	00004517          	auipc	a0,0x4
    3d86:	b6e50513          	addi	a0,a0,-1170 # 78f0 <malloc+0x18ea>
    3d8a:	00002097          	auipc	ra,0x2
    3d8e:	1c4080e7          	jalr	452(ra) # 5f4e <printf>
    exit(1);
    3d92:	4505                	li	a0,1
    3d94:	00002097          	auipc	ra,0x2
    3d98:	e30080e7          	jalr	-464(ra) # 5bc4 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3d9c:	85ca                	mv	a1,s2
    3d9e:	00004517          	auipc	a0,0x4
    3da2:	b7250513          	addi	a0,a0,-1166 # 7910 <malloc+0x190a>
    3da6:	00002097          	auipc	ra,0x2
    3daa:	1a8080e7          	jalr	424(ra) # 5f4e <printf>
    exit(1);
    3dae:	4505                	li	a0,1
    3db0:	00002097          	auipc	ra,0x2
    3db4:	e14080e7          	jalr	-492(ra) # 5bc4 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3db8:	85ca                	mv	a1,s2
    3dba:	00004517          	auipc	a0,0x4
    3dbe:	b7e50513          	addi	a0,a0,-1154 # 7938 <malloc+0x1932>
    3dc2:	00002097          	auipc	ra,0x2
    3dc6:	18c080e7          	jalr	396(ra) # 5f4e <printf>
    exit(1);
    3dca:	4505                	li	a0,1
    3dcc:	00002097          	auipc	ra,0x2
    3dd0:	df8080e7          	jalr	-520(ra) # 5bc4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dd4:	85ca                	mv	a1,s2
    3dd6:	00003517          	auipc	a0,0x3
    3dda:	7fa50513          	addi	a0,a0,2042 # 75d0 <malloc+0x15ca>
    3dde:	00002097          	auipc	ra,0x2
    3de2:	170080e7          	jalr	368(ra) # 5f4e <printf>
    exit(1);
    3de6:	4505                	li	a0,1
    3de8:	00002097          	auipc	ra,0x2
    3dec:	ddc080e7          	jalr	-548(ra) # 5bc4 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3df0:	85ca                	mv	a1,s2
    3df2:	00004517          	auipc	a0,0x4
    3df6:	b6650513          	addi	a0,a0,-1178 # 7958 <malloc+0x1952>
    3dfa:	00002097          	auipc	ra,0x2
    3dfe:	154080e7          	jalr	340(ra) # 5f4e <printf>
    exit(1);
    3e02:	4505                	li	a0,1
    3e04:	00002097          	auipc	ra,0x2
    3e08:	dc0080e7          	jalr	-576(ra) # 5bc4 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e0c:	85ca                	mv	a1,s2
    3e0e:	00004517          	auipc	a0,0x4
    3e12:	b6a50513          	addi	a0,a0,-1174 # 7978 <malloc+0x1972>
    3e16:	00002097          	auipc	ra,0x2
    3e1a:	138080e7          	jalr	312(ra) # 5f4e <printf>
    exit(1);
    3e1e:	4505                	li	a0,1
    3e20:	00002097          	auipc	ra,0x2
    3e24:	da4080e7          	jalr	-604(ra) # 5bc4 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e28:	85ca                	mv	a1,s2
    3e2a:	00004517          	auipc	a0,0x4
    3e2e:	b7e50513          	addi	a0,a0,-1154 # 79a8 <malloc+0x19a2>
    3e32:	00002097          	auipc	ra,0x2
    3e36:	11c080e7          	jalr	284(ra) # 5f4e <printf>
    exit(1);
    3e3a:	4505                	li	a0,1
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	d88080e7          	jalr	-632(ra) # 5bc4 <exit>
    printf("%s: unlink dd failed\n", s);
    3e44:	85ca                	mv	a1,s2
    3e46:	00004517          	auipc	a0,0x4
    3e4a:	b8250513          	addi	a0,a0,-1150 # 79c8 <malloc+0x19c2>
    3e4e:	00002097          	auipc	ra,0x2
    3e52:	100080e7          	jalr	256(ra) # 5f4e <printf>
    exit(1);
    3e56:	4505                	li	a0,1
    3e58:	00002097          	auipc	ra,0x2
    3e5c:	d6c080e7          	jalr	-660(ra) # 5bc4 <exit>

0000000000003e60 <rmdot>:
{
    3e60:	1101                	addi	sp,sp,-32
    3e62:	ec06                	sd	ra,24(sp)
    3e64:	e822                	sd	s0,16(sp)
    3e66:	e426                	sd	s1,8(sp)
    3e68:	1000                	addi	s0,sp,32
    3e6a:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e6c:	00004517          	auipc	a0,0x4
    3e70:	b7450513          	addi	a0,a0,-1164 # 79e0 <malloc+0x19da>
    3e74:	00002097          	auipc	ra,0x2
    3e78:	db8080e7          	jalr	-584(ra) # 5c2c <mkdir>
    3e7c:	e549                	bnez	a0,3f06 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e7e:	00004517          	auipc	a0,0x4
    3e82:	b6250513          	addi	a0,a0,-1182 # 79e0 <malloc+0x19da>
    3e86:	00002097          	auipc	ra,0x2
    3e8a:	dae080e7          	jalr	-594(ra) # 5c34 <chdir>
    3e8e:	e951                	bnez	a0,3f22 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e90:	00003517          	auipc	a0,0x3
    3e94:	98050513          	addi	a0,a0,-1664 # 6810 <malloc+0x80a>
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	d7c080e7          	jalr	-644(ra) # 5c14 <unlink>
    3ea0:	cd59                	beqz	a0,3f3e <rmdot+0xde>
  if(unlink("..") == 0){
    3ea2:	00003517          	auipc	a0,0x3
    3ea6:	59650513          	addi	a0,a0,1430 # 7438 <malloc+0x1432>
    3eaa:	00002097          	auipc	ra,0x2
    3eae:	d6a080e7          	jalr	-662(ra) # 5c14 <unlink>
    3eb2:	c545                	beqz	a0,3f5a <rmdot+0xfa>
  if(chdir("/") != 0){
    3eb4:	00003517          	auipc	a0,0x3
    3eb8:	52c50513          	addi	a0,a0,1324 # 73e0 <malloc+0x13da>
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	d78080e7          	jalr	-648(ra) # 5c34 <chdir>
    3ec4:	e94d                	bnez	a0,3f76 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ec6:	00004517          	auipc	a0,0x4
    3eca:	b8250513          	addi	a0,a0,-1150 # 7a48 <malloc+0x1a42>
    3ece:	00002097          	auipc	ra,0x2
    3ed2:	d46080e7          	jalr	-698(ra) # 5c14 <unlink>
    3ed6:	cd55                	beqz	a0,3f92 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3ed8:	00004517          	auipc	a0,0x4
    3edc:	b9850513          	addi	a0,a0,-1128 # 7a70 <malloc+0x1a6a>
    3ee0:	00002097          	auipc	ra,0x2
    3ee4:	d34080e7          	jalr	-716(ra) # 5c14 <unlink>
    3ee8:	c179                	beqz	a0,3fae <rmdot+0x14e>
  if(unlink("dots") != 0){
    3eea:	00004517          	auipc	a0,0x4
    3eee:	af650513          	addi	a0,a0,-1290 # 79e0 <malloc+0x19da>
    3ef2:	00002097          	auipc	ra,0x2
    3ef6:	d22080e7          	jalr	-734(ra) # 5c14 <unlink>
    3efa:	e961                	bnez	a0,3fca <rmdot+0x16a>
}
    3efc:	60e2                	ld	ra,24(sp)
    3efe:	6442                	ld	s0,16(sp)
    3f00:	64a2                	ld	s1,8(sp)
    3f02:	6105                	addi	sp,sp,32
    3f04:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f06:	85a6                	mv	a1,s1
    3f08:	00004517          	auipc	a0,0x4
    3f0c:	ae050513          	addi	a0,a0,-1312 # 79e8 <malloc+0x19e2>
    3f10:	00002097          	auipc	ra,0x2
    3f14:	03e080e7          	jalr	62(ra) # 5f4e <printf>
    exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	caa080e7          	jalr	-854(ra) # 5bc4 <exit>
    printf("%s: chdir dots failed\n", s);
    3f22:	85a6                	mv	a1,s1
    3f24:	00004517          	auipc	a0,0x4
    3f28:	adc50513          	addi	a0,a0,-1316 # 7a00 <malloc+0x19fa>
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	022080e7          	jalr	34(ra) # 5f4e <printf>
    exit(1);
    3f34:	4505                	li	a0,1
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	c8e080e7          	jalr	-882(ra) # 5bc4 <exit>
    printf("%s: rm . worked!\n", s);
    3f3e:	85a6                	mv	a1,s1
    3f40:	00004517          	auipc	a0,0x4
    3f44:	ad850513          	addi	a0,a0,-1320 # 7a18 <malloc+0x1a12>
    3f48:	00002097          	auipc	ra,0x2
    3f4c:	006080e7          	jalr	6(ra) # 5f4e <printf>
    exit(1);
    3f50:	4505                	li	a0,1
    3f52:	00002097          	auipc	ra,0x2
    3f56:	c72080e7          	jalr	-910(ra) # 5bc4 <exit>
    printf("%s: rm .. worked!\n", s);
    3f5a:	85a6                	mv	a1,s1
    3f5c:	00004517          	auipc	a0,0x4
    3f60:	ad450513          	addi	a0,a0,-1324 # 7a30 <malloc+0x1a2a>
    3f64:	00002097          	auipc	ra,0x2
    3f68:	fea080e7          	jalr	-22(ra) # 5f4e <printf>
    exit(1);
    3f6c:	4505                	li	a0,1
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	c56080e7          	jalr	-938(ra) # 5bc4 <exit>
    printf("%s: chdir / failed\n", s);
    3f76:	85a6                	mv	a1,s1
    3f78:	00003517          	auipc	a0,0x3
    3f7c:	47050513          	addi	a0,a0,1136 # 73e8 <malloc+0x13e2>
    3f80:	00002097          	auipc	ra,0x2
    3f84:	fce080e7          	jalr	-50(ra) # 5f4e <printf>
    exit(1);
    3f88:	4505                	li	a0,1
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	c3a080e7          	jalr	-966(ra) # 5bc4 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f92:	85a6                	mv	a1,s1
    3f94:	00004517          	auipc	a0,0x4
    3f98:	abc50513          	addi	a0,a0,-1348 # 7a50 <malloc+0x1a4a>
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	fb2080e7          	jalr	-78(ra) # 5f4e <printf>
    exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	c1e080e7          	jalr	-994(ra) # 5bc4 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fae:	85a6                	mv	a1,s1
    3fb0:	00004517          	auipc	a0,0x4
    3fb4:	ac850513          	addi	a0,a0,-1336 # 7a78 <malloc+0x1a72>
    3fb8:	00002097          	auipc	ra,0x2
    3fbc:	f96080e7          	jalr	-106(ra) # 5f4e <printf>
    exit(1);
    3fc0:	4505                	li	a0,1
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	c02080e7          	jalr	-1022(ra) # 5bc4 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fca:	85a6                	mv	a1,s1
    3fcc:	00004517          	auipc	a0,0x4
    3fd0:	acc50513          	addi	a0,a0,-1332 # 7a98 <malloc+0x1a92>
    3fd4:	00002097          	auipc	ra,0x2
    3fd8:	f7a080e7          	jalr	-134(ra) # 5f4e <printf>
    exit(1);
    3fdc:	4505                	li	a0,1
    3fde:	00002097          	auipc	ra,0x2
    3fe2:	be6080e7          	jalr	-1050(ra) # 5bc4 <exit>

0000000000003fe6 <dirfile>:
{
    3fe6:	1101                	addi	sp,sp,-32
    3fe8:	ec06                	sd	ra,24(sp)
    3fea:	e822                	sd	s0,16(sp)
    3fec:	e426                	sd	s1,8(sp)
    3fee:	e04a                	sd	s2,0(sp)
    3ff0:	1000                	addi	s0,sp,32
    3ff2:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3ff4:	20000593          	li	a1,512
    3ff8:	00004517          	auipc	a0,0x4
    3ffc:	ac050513          	addi	a0,a0,-1344 # 7ab8 <malloc+0x1ab2>
    4000:	00002097          	auipc	ra,0x2
    4004:	c04080e7          	jalr	-1020(ra) # 5c04 <open>
  if(fd < 0){
    4008:	0e054d63          	bltz	a0,4102 <dirfile+0x11c>
  close(fd);
    400c:	00002097          	auipc	ra,0x2
    4010:	be0080e7          	jalr	-1056(ra) # 5bec <close>
  if(chdir("dirfile") == 0){
    4014:	00004517          	auipc	a0,0x4
    4018:	aa450513          	addi	a0,a0,-1372 # 7ab8 <malloc+0x1ab2>
    401c:	00002097          	auipc	ra,0x2
    4020:	c18080e7          	jalr	-1000(ra) # 5c34 <chdir>
    4024:	cd6d                	beqz	a0,411e <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4026:	4581                	li	a1,0
    4028:	00004517          	auipc	a0,0x4
    402c:	ad850513          	addi	a0,a0,-1320 # 7b00 <malloc+0x1afa>
    4030:	00002097          	auipc	ra,0x2
    4034:	bd4080e7          	jalr	-1068(ra) # 5c04 <open>
  if(fd >= 0){
    4038:	10055163          	bgez	a0,413a <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    403c:	20000593          	li	a1,512
    4040:	00004517          	auipc	a0,0x4
    4044:	ac050513          	addi	a0,a0,-1344 # 7b00 <malloc+0x1afa>
    4048:	00002097          	auipc	ra,0x2
    404c:	bbc080e7          	jalr	-1092(ra) # 5c04 <open>
  if(fd >= 0){
    4050:	10055363          	bgez	a0,4156 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4054:	00004517          	auipc	a0,0x4
    4058:	aac50513          	addi	a0,a0,-1364 # 7b00 <malloc+0x1afa>
    405c:	00002097          	auipc	ra,0x2
    4060:	bd0080e7          	jalr	-1072(ra) # 5c2c <mkdir>
    4064:	10050763          	beqz	a0,4172 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4068:	00004517          	auipc	a0,0x4
    406c:	a9850513          	addi	a0,a0,-1384 # 7b00 <malloc+0x1afa>
    4070:	00002097          	auipc	ra,0x2
    4074:	ba4080e7          	jalr	-1116(ra) # 5c14 <unlink>
    4078:	10050b63          	beqz	a0,418e <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    407c:	00004597          	auipc	a1,0x4
    4080:	a8458593          	addi	a1,a1,-1404 # 7b00 <malloc+0x1afa>
    4084:	00002517          	auipc	a0,0x2
    4088:	27c50513          	addi	a0,a0,636 # 6300 <malloc+0x2fa>
    408c:	00002097          	auipc	ra,0x2
    4090:	b98080e7          	jalr	-1128(ra) # 5c24 <link>
    4094:	10050b63          	beqz	a0,41aa <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    4098:	00004517          	auipc	a0,0x4
    409c:	a2050513          	addi	a0,a0,-1504 # 7ab8 <malloc+0x1ab2>
    40a0:	00002097          	auipc	ra,0x2
    40a4:	b74080e7          	jalr	-1164(ra) # 5c14 <unlink>
    40a8:	10051f63          	bnez	a0,41c6 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40ac:	4589                	li	a1,2
    40ae:	00002517          	auipc	a0,0x2
    40b2:	76250513          	addi	a0,a0,1890 # 6810 <malloc+0x80a>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	b4e080e7          	jalr	-1202(ra) # 5c04 <open>
  if(fd >= 0){
    40be:	12055263          	bgez	a0,41e2 <dirfile+0x1fc>
  fd = open(".", 0);
    40c2:	4581                	li	a1,0
    40c4:	00002517          	auipc	a0,0x2
    40c8:	74c50513          	addi	a0,a0,1868 # 6810 <malloc+0x80a>
    40cc:	00002097          	auipc	ra,0x2
    40d0:	b38080e7          	jalr	-1224(ra) # 5c04 <open>
    40d4:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40d6:	4605                	li	a2,1
    40d8:	00002597          	auipc	a1,0x2
    40dc:	0c058593          	addi	a1,a1,192 # 6198 <malloc+0x192>
    40e0:	00002097          	auipc	ra,0x2
    40e4:	b04080e7          	jalr	-1276(ra) # 5be4 <write>
    40e8:	10a04b63          	bgtz	a0,41fe <dirfile+0x218>
  close(fd);
    40ec:	8526                	mv	a0,s1
    40ee:	00002097          	auipc	ra,0x2
    40f2:	afe080e7          	jalr	-1282(ra) # 5bec <close>
}
    40f6:	60e2                	ld	ra,24(sp)
    40f8:	6442                	ld	s0,16(sp)
    40fa:	64a2                	ld	s1,8(sp)
    40fc:	6902                	ld	s2,0(sp)
    40fe:	6105                	addi	sp,sp,32
    4100:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4102:	85ca                	mv	a1,s2
    4104:	00004517          	auipc	a0,0x4
    4108:	9bc50513          	addi	a0,a0,-1604 # 7ac0 <malloc+0x1aba>
    410c:	00002097          	auipc	ra,0x2
    4110:	e42080e7          	jalr	-446(ra) # 5f4e <printf>
    exit(1);
    4114:	4505                	li	a0,1
    4116:	00002097          	auipc	ra,0x2
    411a:	aae080e7          	jalr	-1362(ra) # 5bc4 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    411e:	85ca                	mv	a1,s2
    4120:	00004517          	auipc	a0,0x4
    4124:	9c050513          	addi	a0,a0,-1600 # 7ae0 <malloc+0x1ada>
    4128:	00002097          	auipc	ra,0x2
    412c:	e26080e7          	jalr	-474(ra) # 5f4e <printf>
    exit(1);
    4130:	4505                	li	a0,1
    4132:	00002097          	auipc	ra,0x2
    4136:	a92080e7          	jalr	-1390(ra) # 5bc4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    413a:	85ca                	mv	a1,s2
    413c:	00004517          	auipc	a0,0x4
    4140:	9d450513          	addi	a0,a0,-1580 # 7b10 <malloc+0x1b0a>
    4144:	00002097          	auipc	ra,0x2
    4148:	e0a080e7          	jalr	-502(ra) # 5f4e <printf>
    exit(1);
    414c:	4505                	li	a0,1
    414e:	00002097          	auipc	ra,0x2
    4152:	a76080e7          	jalr	-1418(ra) # 5bc4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4156:	85ca                	mv	a1,s2
    4158:	00004517          	auipc	a0,0x4
    415c:	9b850513          	addi	a0,a0,-1608 # 7b10 <malloc+0x1b0a>
    4160:	00002097          	auipc	ra,0x2
    4164:	dee080e7          	jalr	-530(ra) # 5f4e <printf>
    exit(1);
    4168:	4505                	li	a0,1
    416a:	00002097          	auipc	ra,0x2
    416e:	a5a080e7          	jalr	-1446(ra) # 5bc4 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4172:	85ca                	mv	a1,s2
    4174:	00004517          	auipc	a0,0x4
    4178:	9c450513          	addi	a0,a0,-1596 # 7b38 <malloc+0x1b32>
    417c:	00002097          	auipc	ra,0x2
    4180:	dd2080e7          	jalr	-558(ra) # 5f4e <printf>
    exit(1);
    4184:	4505                	li	a0,1
    4186:	00002097          	auipc	ra,0x2
    418a:	a3e080e7          	jalr	-1474(ra) # 5bc4 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    418e:	85ca                	mv	a1,s2
    4190:	00004517          	auipc	a0,0x4
    4194:	9d050513          	addi	a0,a0,-1584 # 7b60 <malloc+0x1b5a>
    4198:	00002097          	auipc	ra,0x2
    419c:	db6080e7          	jalr	-586(ra) # 5f4e <printf>
    exit(1);
    41a0:	4505                	li	a0,1
    41a2:	00002097          	auipc	ra,0x2
    41a6:	a22080e7          	jalr	-1502(ra) # 5bc4 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41aa:	85ca                	mv	a1,s2
    41ac:	00004517          	auipc	a0,0x4
    41b0:	9dc50513          	addi	a0,a0,-1572 # 7b88 <malloc+0x1b82>
    41b4:	00002097          	auipc	ra,0x2
    41b8:	d9a080e7          	jalr	-614(ra) # 5f4e <printf>
    exit(1);
    41bc:	4505                	li	a0,1
    41be:	00002097          	auipc	ra,0x2
    41c2:	a06080e7          	jalr	-1530(ra) # 5bc4 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41c6:	85ca                	mv	a1,s2
    41c8:	00004517          	auipc	a0,0x4
    41cc:	9e850513          	addi	a0,a0,-1560 # 7bb0 <malloc+0x1baa>
    41d0:	00002097          	auipc	ra,0x2
    41d4:	d7e080e7          	jalr	-642(ra) # 5f4e <printf>
    exit(1);
    41d8:	4505                	li	a0,1
    41da:	00002097          	auipc	ra,0x2
    41de:	9ea080e7          	jalr	-1558(ra) # 5bc4 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41e2:	85ca                	mv	a1,s2
    41e4:	00004517          	auipc	a0,0x4
    41e8:	9ec50513          	addi	a0,a0,-1556 # 7bd0 <malloc+0x1bca>
    41ec:	00002097          	auipc	ra,0x2
    41f0:	d62080e7          	jalr	-670(ra) # 5f4e <printf>
    exit(1);
    41f4:	4505                	li	a0,1
    41f6:	00002097          	auipc	ra,0x2
    41fa:	9ce080e7          	jalr	-1586(ra) # 5bc4 <exit>
    printf("%s: write . succeeded!\n", s);
    41fe:	85ca                	mv	a1,s2
    4200:	00004517          	auipc	a0,0x4
    4204:	9f850513          	addi	a0,a0,-1544 # 7bf8 <malloc+0x1bf2>
    4208:	00002097          	auipc	ra,0x2
    420c:	d46080e7          	jalr	-698(ra) # 5f4e <printf>
    exit(1);
    4210:	4505                	li	a0,1
    4212:	00002097          	auipc	ra,0x2
    4216:	9b2080e7          	jalr	-1614(ra) # 5bc4 <exit>

000000000000421a <iref>:
{
    421a:	7139                	addi	sp,sp,-64
    421c:	fc06                	sd	ra,56(sp)
    421e:	f822                	sd	s0,48(sp)
    4220:	f426                	sd	s1,40(sp)
    4222:	f04a                	sd	s2,32(sp)
    4224:	ec4e                	sd	s3,24(sp)
    4226:	e852                	sd	s4,16(sp)
    4228:	e456                	sd	s5,8(sp)
    422a:	e05a                	sd	s6,0(sp)
    422c:	0080                	addi	s0,sp,64
    422e:	8b2a                	mv	s6,a0
    4230:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4234:	00004a17          	auipc	s4,0x4
    4238:	9dca0a13          	addi	s4,s4,-1572 # 7c10 <malloc+0x1c0a>
    mkdir("");
    423c:	00003497          	auipc	s1,0x3
    4240:	4dc48493          	addi	s1,s1,1244 # 7718 <malloc+0x1712>
    link("README", "");
    4244:	00002a97          	auipc	s5,0x2
    4248:	0bca8a93          	addi	s5,s5,188 # 6300 <malloc+0x2fa>
    fd = open("xx", O_CREATE);
    424c:	00004997          	auipc	s3,0x4
    4250:	8bc98993          	addi	s3,s3,-1860 # 7b08 <malloc+0x1b02>
    4254:	a891                	j	42a8 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4256:	85da                	mv	a1,s6
    4258:	00004517          	auipc	a0,0x4
    425c:	9c050513          	addi	a0,a0,-1600 # 7c18 <malloc+0x1c12>
    4260:	00002097          	auipc	ra,0x2
    4264:	cee080e7          	jalr	-786(ra) # 5f4e <printf>
      exit(1);
    4268:	4505                	li	a0,1
    426a:	00002097          	auipc	ra,0x2
    426e:	95a080e7          	jalr	-1702(ra) # 5bc4 <exit>
      printf("%s: chdir irefd failed\n", s);
    4272:	85da                	mv	a1,s6
    4274:	00004517          	auipc	a0,0x4
    4278:	9bc50513          	addi	a0,a0,-1604 # 7c30 <malloc+0x1c2a>
    427c:	00002097          	auipc	ra,0x2
    4280:	cd2080e7          	jalr	-814(ra) # 5f4e <printf>
      exit(1);
    4284:	4505                	li	a0,1
    4286:	00002097          	auipc	ra,0x2
    428a:	93e080e7          	jalr	-1730(ra) # 5bc4 <exit>
      close(fd);
    428e:	00002097          	auipc	ra,0x2
    4292:	95e080e7          	jalr	-1698(ra) # 5bec <close>
    4296:	a889                	j	42e8 <iref+0xce>
    unlink("xx");
    4298:	854e                	mv	a0,s3
    429a:	00002097          	auipc	ra,0x2
    429e:	97a080e7          	jalr	-1670(ra) # 5c14 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42a2:	397d                	addiw	s2,s2,-1
    42a4:	06090063          	beqz	s2,4304 <iref+0xea>
    if(mkdir("irefd") != 0){
    42a8:	8552                	mv	a0,s4
    42aa:	00002097          	auipc	ra,0x2
    42ae:	982080e7          	jalr	-1662(ra) # 5c2c <mkdir>
    42b2:	f155                	bnez	a0,4256 <iref+0x3c>
    if(chdir("irefd") != 0){
    42b4:	8552                	mv	a0,s4
    42b6:	00002097          	auipc	ra,0x2
    42ba:	97e080e7          	jalr	-1666(ra) # 5c34 <chdir>
    42be:	f955                	bnez	a0,4272 <iref+0x58>
    mkdir("");
    42c0:	8526                	mv	a0,s1
    42c2:	00002097          	auipc	ra,0x2
    42c6:	96a080e7          	jalr	-1686(ra) # 5c2c <mkdir>
    link("README", "");
    42ca:	85a6                	mv	a1,s1
    42cc:	8556                	mv	a0,s5
    42ce:	00002097          	auipc	ra,0x2
    42d2:	956080e7          	jalr	-1706(ra) # 5c24 <link>
    fd = open("", O_CREATE);
    42d6:	20000593          	li	a1,512
    42da:	8526                	mv	a0,s1
    42dc:	00002097          	auipc	ra,0x2
    42e0:	928080e7          	jalr	-1752(ra) # 5c04 <open>
    if(fd >= 0)
    42e4:	fa0555e3          	bgez	a0,428e <iref+0x74>
    fd = open("xx", O_CREATE);
    42e8:	20000593          	li	a1,512
    42ec:	854e                	mv	a0,s3
    42ee:	00002097          	auipc	ra,0x2
    42f2:	916080e7          	jalr	-1770(ra) # 5c04 <open>
    if(fd >= 0)
    42f6:	fa0541e3          	bltz	a0,4298 <iref+0x7e>
      close(fd);
    42fa:	00002097          	auipc	ra,0x2
    42fe:	8f2080e7          	jalr	-1806(ra) # 5bec <close>
    4302:	bf59                	j	4298 <iref+0x7e>
    4304:	03300493          	li	s1,51
    chdir("..");
    4308:	00003997          	auipc	s3,0x3
    430c:	13098993          	addi	s3,s3,304 # 7438 <malloc+0x1432>
    unlink("irefd");
    4310:	00004917          	auipc	s2,0x4
    4314:	90090913          	addi	s2,s2,-1792 # 7c10 <malloc+0x1c0a>
    chdir("..");
    4318:	854e                	mv	a0,s3
    431a:	00002097          	auipc	ra,0x2
    431e:	91a080e7          	jalr	-1766(ra) # 5c34 <chdir>
    unlink("irefd");
    4322:	854a                	mv	a0,s2
    4324:	00002097          	auipc	ra,0x2
    4328:	8f0080e7          	jalr	-1808(ra) # 5c14 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    432c:	34fd                	addiw	s1,s1,-1
    432e:	f4ed                	bnez	s1,4318 <iref+0xfe>
  chdir("/");
    4330:	00003517          	auipc	a0,0x3
    4334:	0b050513          	addi	a0,a0,176 # 73e0 <malloc+0x13da>
    4338:	00002097          	auipc	ra,0x2
    433c:	8fc080e7          	jalr	-1796(ra) # 5c34 <chdir>
}
    4340:	70e2                	ld	ra,56(sp)
    4342:	7442                	ld	s0,48(sp)
    4344:	74a2                	ld	s1,40(sp)
    4346:	7902                	ld	s2,32(sp)
    4348:	69e2                	ld	s3,24(sp)
    434a:	6a42                	ld	s4,16(sp)
    434c:	6aa2                	ld	s5,8(sp)
    434e:	6b02                	ld	s6,0(sp)
    4350:	6121                	addi	sp,sp,64
    4352:	8082                	ret

0000000000004354 <openiputtest>:
{
    4354:	7179                	addi	sp,sp,-48
    4356:	f406                	sd	ra,40(sp)
    4358:	f022                	sd	s0,32(sp)
    435a:	ec26                	sd	s1,24(sp)
    435c:	1800                	addi	s0,sp,48
    435e:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4360:	00004517          	auipc	a0,0x4
    4364:	8e850513          	addi	a0,a0,-1816 # 7c48 <malloc+0x1c42>
    4368:	00002097          	auipc	ra,0x2
    436c:	8c4080e7          	jalr	-1852(ra) # 5c2c <mkdir>
    4370:	04054263          	bltz	a0,43b4 <openiputtest+0x60>
  pid = fork();
    4374:	00002097          	auipc	ra,0x2
    4378:	848080e7          	jalr	-1976(ra) # 5bbc <fork>
  if(pid < 0){
    437c:	04054a63          	bltz	a0,43d0 <openiputtest+0x7c>
  if(pid == 0){
    4380:	e93d                	bnez	a0,43f6 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4382:	4589                	li	a1,2
    4384:	00004517          	auipc	a0,0x4
    4388:	8c450513          	addi	a0,a0,-1852 # 7c48 <malloc+0x1c42>
    438c:	00002097          	auipc	ra,0x2
    4390:	878080e7          	jalr	-1928(ra) # 5c04 <open>
    if(fd >= 0){
    4394:	04054c63          	bltz	a0,43ec <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    4398:	85a6                	mv	a1,s1
    439a:	00004517          	auipc	a0,0x4
    439e:	8ce50513          	addi	a0,a0,-1842 # 7c68 <malloc+0x1c62>
    43a2:	00002097          	auipc	ra,0x2
    43a6:	bac080e7          	jalr	-1108(ra) # 5f4e <printf>
      exit(1);
    43aa:	4505                	li	a0,1
    43ac:	00002097          	auipc	ra,0x2
    43b0:	818080e7          	jalr	-2024(ra) # 5bc4 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43b4:	85a6                	mv	a1,s1
    43b6:	00004517          	auipc	a0,0x4
    43ba:	89a50513          	addi	a0,a0,-1894 # 7c50 <malloc+0x1c4a>
    43be:	00002097          	auipc	ra,0x2
    43c2:	b90080e7          	jalr	-1136(ra) # 5f4e <printf>
    exit(1);
    43c6:	4505                	li	a0,1
    43c8:	00001097          	auipc	ra,0x1
    43cc:	7fc080e7          	jalr	2044(ra) # 5bc4 <exit>
    printf("%s: fork failed\n", s);
    43d0:	85a6                	mv	a1,s1
    43d2:	00002517          	auipc	a0,0x2
    43d6:	5de50513          	addi	a0,a0,1502 # 69b0 <malloc+0x9aa>
    43da:	00002097          	auipc	ra,0x2
    43de:	b74080e7          	jalr	-1164(ra) # 5f4e <printf>
    exit(1);
    43e2:	4505                	li	a0,1
    43e4:	00001097          	auipc	ra,0x1
    43e8:	7e0080e7          	jalr	2016(ra) # 5bc4 <exit>
    exit(0);
    43ec:	4501                	li	a0,0
    43ee:	00001097          	auipc	ra,0x1
    43f2:	7d6080e7          	jalr	2006(ra) # 5bc4 <exit>
  sleep(1);
    43f6:	4505                	li	a0,1
    43f8:	00002097          	auipc	ra,0x2
    43fc:	85c080e7          	jalr	-1956(ra) # 5c54 <sleep>
  if(unlink("oidir") != 0){
    4400:	00004517          	auipc	a0,0x4
    4404:	84850513          	addi	a0,a0,-1976 # 7c48 <malloc+0x1c42>
    4408:	00002097          	auipc	ra,0x2
    440c:	80c080e7          	jalr	-2036(ra) # 5c14 <unlink>
    4410:	cd19                	beqz	a0,442e <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4412:	85a6                	mv	a1,s1
    4414:	00002517          	auipc	a0,0x2
    4418:	78c50513          	addi	a0,a0,1932 # 6ba0 <malloc+0xb9a>
    441c:	00002097          	auipc	ra,0x2
    4420:	b32080e7          	jalr	-1230(ra) # 5f4e <printf>
    exit(1);
    4424:	4505                	li	a0,1
    4426:	00001097          	auipc	ra,0x1
    442a:	79e080e7          	jalr	1950(ra) # 5bc4 <exit>
  wait(&xstatus);
    442e:	fdc40513          	addi	a0,s0,-36
    4432:	00001097          	auipc	ra,0x1
    4436:	79a080e7          	jalr	1946(ra) # 5bcc <wait>
  exit(xstatus);
    443a:	fdc42503          	lw	a0,-36(s0)
    443e:	00001097          	auipc	ra,0x1
    4442:	786080e7          	jalr	1926(ra) # 5bc4 <exit>

0000000000004446 <forkforkfork>:
{
    4446:	1101                	addi	sp,sp,-32
    4448:	ec06                	sd	ra,24(sp)
    444a:	e822                	sd	s0,16(sp)
    444c:	e426                	sd	s1,8(sp)
    444e:	1000                	addi	s0,sp,32
    4450:	84aa                	mv	s1,a0
  unlink("stopforking");
    4452:	00004517          	auipc	a0,0x4
    4456:	83e50513          	addi	a0,a0,-1986 # 7c90 <malloc+0x1c8a>
    445a:	00001097          	auipc	ra,0x1
    445e:	7ba080e7          	jalr	1978(ra) # 5c14 <unlink>
  int pid = fork();
    4462:	00001097          	auipc	ra,0x1
    4466:	75a080e7          	jalr	1882(ra) # 5bbc <fork>
  if(pid < 0){
    446a:	04054563          	bltz	a0,44b4 <forkforkfork+0x6e>
  if(pid == 0){
    446e:	c12d                	beqz	a0,44d0 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4470:	4551                	li	a0,20
    4472:	00001097          	auipc	ra,0x1
    4476:	7e2080e7          	jalr	2018(ra) # 5c54 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    447a:	20200593          	li	a1,514
    447e:	00004517          	auipc	a0,0x4
    4482:	81250513          	addi	a0,a0,-2030 # 7c90 <malloc+0x1c8a>
    4486:	00001097          	auipc	ra,0x1
    448a:	77e080e7          	jalr	1918(ra) # 5c04 <open>
    448e:	00001097          	auipc	ra,0x1
    4492:	75e080e7          	jalr	1886(ra) # 5bec <close>
  wait(0);
    4496:	4501                	li	a0,0
    4498:	00001097          	auipc	ra,0x1
    449c:	734080e7          	jalr	1844(ra) # 5bcc <wait>
  sleep(10); // one second
    44a0:	4529                	li	a0,10
    44a2:	00001097          	auipc	ra,0x1
    44a6:	7b2080e7          	jalr	1970(ra) # 5c54 <sleep>
}
    44aa:	60e2                	ld	ra,24(sp)
    44ac:	6442                	ld	s0,16(sp)
    44ae:	64a2                	ld	s1,8(sp)
    44b0:	6105                	addi	sp,sp,32
    44b2:	8082                	ret
    printf("%s: fork failed", s);
    44b4:	85a6                	mv	a1,s1
    44b6:	00002517          	auipc	a0,0x2
    44ba:	6ba50513          	addi	a0,a0,1722 # 6b70 <malloc+0xb6a>
    44be:	00002097          	auipc	ra,0x2
    44c2:	a90080e7          	jalr	-1392(ra) # 5f4e <printf>
    exit(1);
    44c6:	4505                	li	a0,1
    44c8:	00001097          	auipc	ra,0x1
    44cc:	6fc080e7          	jalr	1788(ra) # 5bc4 <exit>
      int fd = open("stopforking", 0);
    44d0:	00003497          	auipc	s1,0x3
    44d4:	7c048493          	addi	s1,s1,1984 # 7c90 <malloc+0x1c8a>
    44d8:	4581                	li	a1,0
    44da:	8526                	mv	a0,s1
    44dc:	00001097          	auipc	ra,0x1
    44e0:	728080e7          	jalr	1832(ra) # 5c04 <open>
      if(fd >= 0){
    44e4:	02055463          	bgez	a0,450c <forkforkfork+0xc6>
      if(fork() < 0){
    44e8:	00001097          	auipc	ra,0x1
    44ec:	6d4080e7          	jalr	1748(ra) # 5bbc <fork>
    44f0:	fe0554e3          	bgez	a0,44d8 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44f4:	20200593          	li	a1,514
    44f8:	8526                	mv	a0,s1
    44fa:	00001097          	auipc	ra,0x1
    44fe:	70a080e7          	jalr	1802(ra) # 5c04 <open>
    4502:	00001097          	auipc	ra,0x1
    4506:	6ea080e7          	jalr	1770(ra) # 5bec <close>
    450a:	b7f9                	j	44d8 <forkforkfork+0x92>
        exit(0);
    450c:	4501                	li	a0,0
    450e:	00001097          	auipc	ra,0x1
    4512:	6b6080e7          	jalr	1718(ra) # 5bc4 <exit>

0000000000004516 <killstatus>:
{
    4516:	7139                	addi	sp,sp,-64
    4518:	fc06                	sd	ra,56(sp)
    451a:	f822                	sd	s0,48(sp)
    451c:	f426                	sd	s1,40(sp)
    451e:	f04a                	sd	s2,32(sp)
    4520:	ec4e                	sd	s3,24(sp)
    4522:	e852                	sd	s4,16(sp)
    4524:	0080                	addi	s0,sp,64
    4526:	8a2a                	mv	s4,a0
    4528:	06400913          	li	s2,100
    if(xst != -1) {
    452c:	59fd                	li	s3,-1
    int pid1 = fork();
    452e:	00001097          	auipc	ra,0x1
    4532:	68e080e7          	jalr	1678(ra) # 5bbc <fork>
    4536:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4538:	02054f63          	bltz	a0,4576 <killstatus+0x60>
    if(pid1 == 0){
    453c:	c939                	beqz	a0,4592 <killstatus+0x7c>
    sleep(1);
    453e:	4505                	li	a0,1
    4540:	00001097          	auipc	ra,0x1
    4544:	714080e7          	jalr	1812(ra) # 5c54 <sleep>
    kill(pid1);
    4548:	8526                	mv	a0,s1
    454a:	00001097          	auipc	ra,0x1
    454e:	6aa080e7          	jalr	1706(ra) # 5bf4 <kill>
    wait(&xst);
    4552:	fcc40513          	addi	a0,s0,-52
    4556:	00001097          	auipc	ra,0x1
    455a:	676080e7          	jalr	1654(ra) # 5bcc <wait>
    if(xst != -1) {
    455e:	fcc42783          	lw	a5,-52(s0)
    4562:	03379d63          	bne	a5,s3,459c <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4566:	397d                	addiw	s2,s2,-1
    4568:	fc0913e3          	bnez	s2,452e <killstatus+0x18>
  exit(0);
    456c:	4501                	li	a0,0
    456e:	00001097          	auipc	ra,0x1
    4572:	656080e7          	jalr	1622(ra) # 5bc4 <exit>
      printf("%s: fork failed\n", s);
    4576:	85d2                	mv	a1,s4
    4578:	00002517          	auipc	a0,0x2
    457c:	43850513          	addi	a0,a0,1080 # 69b0 <malloc+0x9aa>
    4580:	00002097          	auipc	ra,0x2
    4584:	9ce080e7          	jalr	-1586(ra) # 5f4e <printf>
      exit(1);
    4588:	4505                	li	a0,1
    458a:	00001097          	auipc	ra,0x1
    458e:	63a080e7          	jalr	1594(ra) # 5bc4 <exit>
        getpid();
    4592:	00001097          	auipc	ra,0x1
    4596:	6b2080e7          	jalr	1714(ra) # 5c44 <getpid>
      while(1) {
    459a:	bfe5                	j	4592 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    459c:	85d2                	mv	a1,s4
    459e:	00003517          	auipc	a0,0x3
    45a2:	70250513          	addi	a0,a0,1794 # 7ca0 <malloc+0x1c9a>
    45a6:	00002097          	auipc	ra,0x2
    45aa:	9a8080e7          	jalr	-1624(ra) # 5f4e <printf>
       exit(1);
    45ae:	4505                	li	a0,1
    45b0:	00001097          	auipc	ra,0x1
    45b4:	614080e7          	jalr	1556(ra) # 5bc4 <exit>

00000000000045b8 <preempt>:
{
    45b8:	7139                	addi	sp,sp,-64
    45ba:	fc06                	sd	ra,56(sp)
    45bc:	f822                	sd	s0,48(sp)
    45be:	f426                	sd	s1,40(sp)
    45c0:	f04a                	sd	s2,32(sp)
    45c2:	ec4e                	sd	s3,24(sp)
    45c4:	e852                	sd	s4,16(sp)
    45c6:	0080                	addi	s0,sp,64
    45c8:	892a                	mv	s2,a0
  pid1 = fork();
    45ca:	00001097          	auipc	ra,0x1
    45ce:	5f2080e7          	jalr	1522(ra) # 5bbc <fork>
  if(pid1 < 0) {
    45d2:	00054563          	bltz	a0,45dc <preempt+0x24>
    45d6:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45d8:	e105                	bnez	a0,45f8 <preempt+0x40>
    for(;;)
    45da:	a001                	j	45da <preempt+0x22>
    printf("%s: fork failed", s);
    45dc:	85ca                	mv	a1,s2
    45de:	00002517          	auipc	a0,0x2
    45e2:	59250513          	addi	a0,a0,1426 # 6b70 <malloc+0xb6a>
    45e6:	00002097          	auipc	ra,0x2
    45ea:	968080e7          	jalr	-1688(ra) # 5f4e <printf>
    exit(1);
    45ee:	4505                	li	a0,1
    45f0:	00001097          	auipc	ra,0x1
    45f4:	5d4080e7          	jalr	1492(ra) # 5bc4 <exit>
  pid2 = fork();
    45f8:	00001097          	auipc	ra,0x1
    45fc:	5c4080e7          	jalr	1476(ra) # 5bbc <fork>
    4600:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4602:	00054463          	bltz	a0,460a <preempt+0x52>
  if(pid2 == 0)
    4606:	e105                	bnez	a0,4626 <preempt+0x6e>
    for(;;)
    4608:	a001                	j	4608 <preempt+0x50>
    printf("%s: fork failed\n", s);
    460a:	85ca                	mv	a1,s2
    460c:	00002517          	auipc	a0,0x2
    4610:	3a450513          	addi	a0,a0,932 # 69b0 <malloc+0x9aa>
    4614:	00002097          	auipc	ra,0x2
    4618:	93a080e7          	jalr	-1734(ra) # 5f4e <printf>
    exit(1);
    461c:	4505                	li	a0,1
    461e:	00001097          	auipc	ra,0x1
    4622:	5a6080e7          	jalr	1446(ra) # 5bc4 <exit>
  pipe(pfds);
    4626:	fc840513          	addi	a0,s0,-56
    462a:	00001097          	auipc	ra,0x1
    462e:	5aa080e7          	jalr	1450(ra) # 5bd4 <pipe>
  pid3 = fork();
    4632:	00001097          	auipc	ra,0x1
    4636:	58a080e7          	jalr	1418(ra) # 5bbc <fork>
    463a:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    463c:	02054e63          	bltz	a0,4678 <preempt+0xc0>
  if(pid3 == 0){
    4640:	e525                	bnez	a0,46a8 <preempt+0xf0>
    close(pfds[0]);
    4642:	fc842503          	lw	a0,-56(s0)
    4646:	00001097          	auipc	ra,0x1
    464a:	5a6080e7          	jalr	1446(ra) # 5bec <close>
    if(write(pfds[1], "x", 1) != 1)
    464e:	4605                	li	a2,1
    4650:	00002597          	auipc	a1,0x2
    4654:	b4858593          	addi	a1,a1,-1208 # 6198 <malloc+0x192>
    4658:	fcc42503          	lw	a0,-52(s0)
    465c:	00001097          	auipc	ra,0x1
    4660:	588080e7          	jalr	1416(ra) # 5be4 <write>
    4664:	4785                	li	a5,1
    4666:	02f51763          	bne	a0,a5,4694 <preempt+0xdc>
    close(pfds[1]);
    466a:	fcc42503          	lw	a0,-52(s0)
    466e:	00001097          	auipc	ra,0x1
    4672:	57e080e7          	jalr	1406(ra) # 5bec <close>
    for(;;)
    4676:	a001                	j	4676 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4678:	85ca                	mv	a1,s2
    467a:	00002517          	auipc	a0,0x2
    467e:	33650513          	addi	a0,a0,822 # 69b0 <malloc+0x9aa>
    4682:	00002097          	auipc	ra,0x2
    4686:	8cc080e7          	jalr	-1844(ra) # 5f4e <printf>
     exit(1);
    468a:	4505                	li	a0,1
    468c:	00001097          	auipc	ra,0x1
    4690:	538080e7          	jalr	1336(ra) # 5bc4 <exit>
      printf("%s: preempt write error", s);
    4694:	85ca                	mv	a1,s2
    4696:	00003517          	auipc	a0,0x3
    469a:	62a50513          	addi	a0,a0,1578 # 7cc0 <malloc+0x1cba>
    469e:	00002097          	auipc	ra,0x2
    46a2:	8b0080e7          	jalr	-1872(ra) # 5f4e <printf>
    46a6:	b7d1                	j	466a <preempt+0xb2>
  close(pfds[1]);
    46a8:	fcc42503          	lw	a0,-52(s0)
    46ac:	00001097          	auipc	ra,0x1
    46b0:	540080e7          	jalr	1344(ra) # 5bec <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46b4:	660d                	lui	a2,0x3
    46b6:	00008597          	auipc	a1,0x8
    46ba:	5c258593          	addi	a1,a1,1474 # cc78 <buf>
    46be:	fc842503          	lw	a0,-56(s0)
    46c2:	00001097          	auipc	ra,0x1
    46c6:	51a080e7          	jalr	1306(ra) # 5bdc <read>
    46ca:	4785                	li	a5,1
    46cc:	02f50363          	beq	a0,a5,46f2 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46d0:	85ca                	mv	a1,s2
    46d2:	00003517          	auipc	a0,0x3
    46d6:	60650513          	addi	a0,a0,1542 # 7cd8 <malloc+0x1cd2>
    46da:	00002097          	auipc	ra,0x2
    46de:	874080e7          	jalr	-1932(ra) # 5f4e <printf>
}
    46e2:	70e2                	ld	ra,56(sp)
    46e4:	7442                	ld	s0,48(sp)
    46e6:	74a2                	ld	s1,40(sp)
    46e8:	7902                	ld	s2,32(sp)
    46ea:	69e2                	ld	s3,24(sp)
    46ec:	6a42                	ld	s4,16(sp)
    46ee:	6121                	addi	sp,sp,64
    46f0:	8082                	ret
  close(pfds[0]);
    46f2:	fc842503          	lw	a0,-56(s0)
    46f6:	00001097          	auipc	ra,0x1
    46fa:	4f6080e7          	jalr	1270(ra) # 5bec <close>
  printf("kill... ");
    46fe:	00003517          	auipc	a0,0x3
    4702:	5f250513          	addi	a0,a0,1522 # 7cf0 <malloc+0x1cea>
    4706:	00002097          	auipc	ra,0x2
    470a:	848080e7          	jalr	-1976(ra) # 5f4e <printf>
  kill(pid1);
    470e:	8526                	mv	a0,s1
    4710:	00001097          	auipc	ra,0x1
    4714:	4e4080e7          	jalr	1252(ra) # 5bf4 <kill>
  kill(pid2);
    4718:	854e                	mv	a0,s3
    471a:	00001097          	auipc	ra,0x1
    471e:	4da080e7          	jalr	1242(ra) # 5bf4 <kill>
  kill(pid3);
    4722:	8552                	mv	a0,s4
    4724:	00001097          	auipc	ra,0x1
    4728:	4d0080e7          	jalr	1232(ra) # 5bf4 <kill>
  printf("wait... ");
    472c:	00003517          	auipc	a0,0x3
    4730:	5d450513          	addi	a0,a0,1492 # 7d00 <malloc+0x1cfa>
    4734:	00002097          	auipc	ra,0x2
    4738:	81a080e7          	jalr	-2022(ra) # 5f4e <printf>
  wait(0);
    473c:	4501                	li	a0,0
    473e:	00001097          	auipc	ra,0x1
    4742:	48e080e7          	jalr	1166(ra) # 5bcc <wait>
  wait(0);
    4746:	4501                	li	a0,0
    4748:	00001097          	auipc	ra,0x1
    474c:	484080e7          	jalr	1156(ra) # 5bcc <wait>
  wait(0);
    4750:	4501                	li	a0,0
    4752:	00001097          	auipc	ra,0x1
    4756:	47a080e7          	jalr	1146(ra) # 5bcc <wait>
    475a:	b761                	j	46e2 <preempt+0x12a>

000000000000475c <reparent>:
{
    475c:	7179                	addi	sp,sp,-48
    475e:	f406                	sd	ra,40(sp)
    4760:	f022                	sd	s0,32(sp)
    4762:	ec26                	sd	s1,24(sp)
    4764:	e84a                	sd	s2,16(sp)
    4766:	e44e                	sd	s3,8(sp)
    4768:	e052                	sd	s4,0(sp)
    476a:	1800                	addi	s0,sp,48
    476c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    476e:	00001097          	auipc	ra,0x1
    4772:	4d6080e7          	jalr	1238(ra) # 5c44 <getpid>
    4776:	8a2a                	mv	s4,a0
    4778:	0c800913          	li	s2,200
    int pid = fork();
    477c:	00001097          	auipc	ra,0x1
    4780:	440080e7          	jalr	1088(ra) # 5bbc <fork>
    4784:	84aa                	mv	s1,a0
    if(pid < 0){
    4786:	02054263          	bltz	a0,47aa <reparent+0x4e>
    if(pid){
    478a:	cd21                	beqz	a0,47e2 <reparent+0x86>
      if(wait(0) != pid){
    478c:	4501                	li	a0,0
    478e:	00001097          	auipc	ra,0x1
    4792:	43e080e7          	jalr	1086(ra) # 5bcc <wait>
    4796:	02951863          	bne	a0,s1,47c6 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    479a:	397d                	addiw	s2,s2,-1
    479c:	fe0910e3          	bnez	s2,477c <reparent+0x20>
  exit(0);
    47a0:	4501                	li	a0,0
    47a2:	00001097          	auipc	ra,0x1
    47a6:	422080e7          	jalr	1058(ra) # 5bc4 <exit>
      printf("%s: fork failed\n", s);
    47aa:	85ce                	mv	a1,s3
    47ac:	00002517          	auipc	a0,0x2
    47b0:	20450513          	addi	a0,a0,516 # 69b0 <malloc+0x9aa>
    47b4:	00001097          	auipc	ra,0x1
    47b8:	79a080e7          	jalr	1946(ra) # 5f4e <printf>
      exit(1);
    47bc:	4505                	li	a0,1
    47be:	00001097          	auipc	ra,0x1
    47c2:	406080e7          	jalr	1030(ra) # 5bc4 <exit>
        printf("%s: wait wrong pid\n", s);
    47c6:	85ce                	mv	a1,s3
    47c8:	00002517          	auipc	a0,0x2
    47cc:	37050513          	addi	a0,a0,880 # 6b38 <malloc+0xb32>
    47d0:	00001097          	auipc	ra,0x1
    47d4:	77e080e7          	jalr	1918(ra) # 5f4e <printf>
        exit(1);
    47d8:	4505                	li	a0,1
    47da:	00001097          	auipc	ra,0x1
    47de:	3ea080e7          	jalr	1002(ra) # 5bc4 <exit>
      int pid2 = fork();
    47e2:	00001097          	auipc	ra,0x1
    47e6:	3da080e7          	jalr	986(ra) # 5bbc <fork>
      if(pid2 < 0){
    47ea:	00054763          	bltz	a0,47f8 <reparent+0x9c>
      exit(0);
    47ee:	4501                	li	a0,0
    47f0:	00001097          	auipc	ra,0x1
    47f4:	3d4080e7          	jalr	980(ra) # 5bc4 <exit>
        kill(master_pid);
    47f8:	8552                	mv	a0,s4
    47fa:	00001097          	auipc	ra,0x1
    47fe:	3fa080e7          	jalr	1018(ra) # 5bf4 <kill>
        exit(1);
    4802:	4505                	li	a0,1
    4804:	00001097          	auipc	ra,0x1
    4808:	3c0080e7          	jalr	960(ra) # 5bc4 <exit>

000000000000480c <sbrkfail>:
{
    480c:	7119                	addi	sp,sp,-128
    480e:	fc86                	sd	ra,120(sp)
    4810:	f8a2                	sd	s0,112(sp)
    4812:	f4a6                	sd	s1,104(sp)
    4814:	f0ca                	sd	s2,96(sp)
    4816:	ecce                	sd	s3,88(sp)
    4818:	e8d2                	sd	s4,80(sp)
    481a:	e4d6                	sd	s5,72(sp)
    481c:	0100                	addi	s0,sp,128
    481e:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4820:	fb040513          	addi	a0,s0,-80
    4824:	00001097          	auipc	ra,0x1
    4828:	3b0080e7          	jalr	944(ra) # 5bd4 <pipe>
    482c:	e901                	bnez	a0,483c <sbrkfail+0x30>
    482e:	f8040493          	addi	s1,s0,-128
    4832:	fa840993          	addi	s3,s0,-88
    4836:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4838:	5a7d                	li	s4,-1
    483a:	a085                	j	489a <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    483c:	85d6                	mv	a1,s5
    483e:	00002517          	auipc	a0,0x2
    4842:	27a50513          	addi	a0,a0,634 # 6ab8 <malloc+0xab2>
    4846:	00001097          	auipc	ra,0x1
    484a:	708080e7          	jalr	1800(ra) # 5f4e <printf>
    exit(1);
    484e:	4505                	li	a0,1
    4850:	00001097          	auipc	ra,0x1
    4854:	374080e7          	jalr	884(ra) # 5bc4 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4858:	00001097          	auipc	ra,0x1
    485c:	3f4080e7          	jalr	1012(ra) # 5c4c <sbrk>
    4860:	064007b7          	lui	a5,0x6400
    4864:	40a7853b          	subw	a0,a5,a0
    4868:	00001097          	auipc	ra,0x1
    486c:	3e4080e7          	jalr	996(ra) # 5c4c <sbrk>
      write(fds[1], "x", 1);
    4870:	4605                	li	a2,1
    4872:	00002597          	auipc	a1,0x2
    4876:	92658593          	addi	a1,a1,-1754 # 6198 <malloc+0x192>
    487a:	fb442503          	lw	a0,-76(s0)
    487e:	00001097          	auipc	ra,0x1
    4882:	366080e7          	jalr	870(ra) # 5be4 <write>
      for(;;) sleep(1000);
    4886:	3e800513          	li	a0,1000
    488a:	00001097          	auipc	ra,0x1
    488e:	3ca080e7          	jalr	970(ra) # 5c54 <sleep>
    4892:	bfd5                	j	4886 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4894:	0911                	addi	s2,s2,4
    4896:	03390563          	beq	s2,s3,48c0 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    489a:	00001097          	auipc	ra,0x1
    489e:	322080e7          	jalr	802(ra) # 5bbc <fork>
    48a2:	00a92023          	sw	a0,0(s2)
    48a6:	d94d                	beqz	a0,4858 <sbrkfail+0x4c>
    if(pids[i] != -1)
    48a8:	ff4506e3          	beq	a0,s4,4894 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48ac:	4605                	li	a2,1
    48ae:	faf40593          	addi	a1,s0,-81
    48b2:	fb042503          	lw	a0,-80(s0)
    48b6:	00001097          	auipc	ra,0x1
    48ba:	326080e7          	jalr	806(ra) # 5bdc <read>
    48be:	bfd9                	j	4894 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48c0:	6505                	lui	a0,0x1
    48c2:	00001097          	auipc	ra,0x1
    48c6:	38a080e7          	jalr	906(ra) # 5c4c <sbrk>
    48ca:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48cc:	597d                	li	s2,-1
    48ce:	a021                	j	48d6 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48d0:	0491                	addi	s1,s1,4
    48d2:	01348f63          	beq	s1,s3,48f0 <sbrkfail+0xe4>
    if(pids[i] == -1)
    48d6:	4088                	lw	a0,0(s1)
    48d8:	ff250ce3          	beq	a0,s2,48d0 <sbrkfail+0xc4>
    kill(pids[i]);
    48dc:	00001097          	auipc	ra,0x1
    48e0:	318080e7          	jalr	792(ra) # 5bf4 <kill>
    wait(0);
    48e4:	4501                	li	a0,0
    48e6:	00001097          	auipc	ra,0x1
    48ea:	2e6080e7          	jalr	742(ra) # 5bcc <wait>
    48ee:	b7cd                	j	48d0 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    48f0:	57fd                	li	a5,-1
    48f2:	04fa0163          	beq	s4,a5,4934 <sbrkfail+0x128>
  pid = fork();
    48f6:	00001097          	auipc	ra,0x1
    48fa:	2c6080e7          	jalr	710(ra) # 5bbc <fork>
    48fe:	84aa                	mv	s1,a0
  if(pid < 0){
    4900:	04054863          	bltz	a0,4950 <sbrkfail+0x144>
  if(pid == 0){
    4904:	c525                	beqz	a0,496c <sbrkfail+0x160>
  wait(&xstatus);
    4906:	fbc40513          	addi	a0,s0,-68
    490a:	00001097          	auipc	ra,0x1
    490e:	2c2080e7          	jalr	706(ra) # 5bcc <wait>
  if(xstatus != -1 && xstatus != 2)
    4912:	fbc42783          	lw	a5,-68(s0)
    4916:	577d                	li	a4,-1
    4918:	00e78563          	beq	a5,a4,4922 <sbrkfail+0x116>
    491c:	4709                	li	a4,2
    491e:	08e79d63          	bne	a5,a4,49b8 <sbrkfail+0x1ac>
}
    4922:	70e6                	ld	ra,120(sp)
    4924:	7446                	ld	s0,112(sp)
    4926:	74a6                	ld	s1,104(sp)
    4928:	7906                	ld	s2,96(sp)
    492a:	69e6                	ld	s3,88(sp)
    492c:	6a46                	ld	s4,80(sp)
    492e:	6aa6                	ld	s5,72(sp)
    4930:	6109                	addi	sp,sp,128
    4932:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4934:	85d6                	mv	a1,s5
    4936:	00003517          	auipc	a0,0x3
    493a:	3da50513          	addi	a0,a0,986 # 7d10 <malloc+0x1d0a>
    493e:	00001097          	auipc	ra,0x1
    4942:	610080e7          	jalr	1552(ra) # 5f4e <printf>
    exit(1);
    4946:	4505                	li	a0,1
    4948:	00001097          	auipc	ra,0x1
    494c:	27c080e7          	jalr	636(ra) # 5bc4 <exit>
    printf("%s: fork failed\n", s);
    4950:	85d6                	mv	a1,s5
    4952:	00002517          	auipc	a0,0x2
    4956:	05e50513          	addi	a0,a0,94 # 69b0 <malloc+0x9aa>
    495a:	00001097          	auipc	ra,0x1
    495e:	5f4080e7          	jalr	1524(ra) # 5f4e <printf>
    exit(1);
    4962:	4505                	li	a0,1
    4964:	00001097          	auipc	ra,0x1
    4968:	260080e7          	jalr	608(ra) # 5bc4 <exit>
    a = sbrk(0);
    496c:	4501                	li	a0,0
    496e:	00001097          	auipc	ra,0x1
    4972:	2de080e7          	jalr	734(ra) # 5c4c <sbrk>
    4976:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4978:	3e800537          	lui	a0,0x3e800
    497c:	00001097          	auipc	ra,0x1
    4980:	2d0080e7          	jalr	720(ra) # 5c4c <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4984:	87ca                	mv	a5,s2
    4986:	3e800737          	lui	a4,0x3e800
    498a:	993a                	add	s2,s2,a4
    498c:	6705                	lui	a4,0x1
      n += *(a+i);
    498e:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4992:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4994:	97ba                	add	a5,a5,a4
    4996:	ff279ce3          	bne	a5,s2,498e <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    499a:	8626                	mv	a2,s1
    499c:	85d6                	mv	a1,s5
    499e:	00003517          	auipc	a0,0x3
    49a2:	39250513          	addi	a0,a0,914 # 7d30 <malloc+0x1d2a>
    49a6:	00001097          	auipc	ra,0x1
    49aa:	5a8080e7          	jalr	1448(ra) # 5f4e <printf>
    exit(1);
    49ae:	4505                	li	a0,1
    49b0:	00001097          	auipc	ra,0x1
    49b4:	214080e7          	jalr	532(ra) # 5bc4 <exit>
    exit(1);
    49b8:	4505                	li	a0,1
    49ba:	00001097          	auipc	ra,0x1
    49be:	20a080e7          	jalr	522(ra) # 5bc4 <exit>

00000000000049c2 <mem>:
{
    49c2:	7139                	addi	sp,sp,-64
    49c4:	fc06                	sd	ra,56(sp)
    49c6:	f822                	sd	s0,48(sp)
    49c8:	f426                	sd	s1,40(sp)
    49ca:	f04a                	sd	s2,32(sp)
    49cc:	ec4e                	sd	s3,24(sp)
    49ce:	0080                	addi	s0,sp,64
    49d0:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49d2:	00001097          	auipc	ra,0x1
    49d6:	1ea080e7          	jalr	490(ra) # 5bbc <fork>
    m1 = 0;
    49da:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49dc:	6909                	lui	s2,0x2
    49de:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x105>
  if((pid = fork()) == 0){
    49e2:	c115                	beqz	a0,4a06 <mem+0x44>
    wait(&xstatus);
    49e4:	fcc40513          	addi	a0,s0,-52
    49e8:	00001097          	auipc	ra,0x1
    49ec:	1e4080e7          	jalr	484(ra) # 5bcc <wait>
    if(xstatus == -1){
    49f0:	fcc42503          	lw	a0,-52(s0)
    49f4:	57fd                	li	a5,-1
    49f6:	06f50363          	beq	a0,a5,4a5c <mem+0x9a>
    exit(xstatus);
    49fa:	00001097          	auipc	ra,0x1
    49fe:	1ca080e7          	jalr	458(ra) # 5bc4 <exit>
      *(char**)m2 = m1;
    4a02:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a04:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a06:	854a                	mv	a0,s2
    4a08:	00001097          	auipc	ra,0x1
    4a0c:	5fe080e7          	jalr	1534(ra) # 6006 <malloc>
    4a10:	f96d                	bnez	a0,4a02 <mem+0x40>
    while(m1){
    4a12:	c881                	beqz	s1,4a22 <mem+0x60>
      m2 = *(char**)m1;
    4a14:	8526                	mv	a0,s1
    4a16:	6084                	ld	s1,0(s1)
      free(m1);
    4a18:	00001097          	auipc	ra,0x1
    4a1c:	56c080e7          	jalr	1388(ra) # 5f84 <free>
    while(m1){
    4a20:	f8f5                	bnez	s1,4a14 <mem+0x52>
    m1 = malloc(1024*20);
    4a22:	6515                	lui	a0,0x5
    4a24:	00001097          	auipc	ra,0x1
    4a28:	5e2080e7          	jalr	1506(ra) # 6006 <malloc>
    if(m1 == 0){
    4a2c:	c911                	beqz	a0,4a40 <mem+0x7e>
    free(m1);
    4a2e:	00001097          	auipc	ra,0x1
    4a32:	556080e7          	jalr	1366(ra) # 5f84 <free>
    exit(0);
    4a36:	4501                	li	a0,0
    4a38:	00001097          	auipc	ra,0x1
    4a3c:	18c080e7          	jalr	396(ra) # 5bc4 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a40:	85ce                	mv	a1,s3
    4a42:	00003517          	auipc	a0,0x3
    4a46:	31e50513          	addi	a0,a0,798 # 7d60 <malloc+0x1d5a>
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	504080e7          	jalr	1284(ra) # 5f4e <printf>
      exit(1);
    4a52:	4505                	li	a0,1
    4a54:	00001097          	auipc	ra,0x1
    4a58:	170080e7          	jalr	368(ra) # 5bc4 <exit>
      exit(0);
    4a5c:	4501                	li	a0,0
    4a5e:	00001097          	auipc	ra,0x1
    4a62:	166080e7          	jalr	358(ra) # 5bc4 <exit>

0000000000004a66 <sharedfd>:
{
    4a66:	7159                	addi	sp,sp,-112
    4a68:	f486                	sd	ra,104(sp)
    4a6a:	f0a2                	sd	s0,96(sp)
    4a6c:	eca6                	sd	s1,88(sp)
    4a6e:	e8ca                	sd	s2,80(sp)
    4a70:	e4ce                	sd	s3,72(sp)
    4a72:	e0d2                	sd	s4,64(sp)
    4a74:	fc56                	sd	s5,56(sp)
    4a76:	f85a                	sd	s6,48(sp)
    4a78:	f45e                	sd	s7,40(sp)
    4a7a:	1880                	addi	s0,sp,112
    4a7c:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a7e:	00003517          	auipc	a0,0x3
    4a82:	30250513          	addi	a0,a0,770 # 7d80 <malloc+0x1d7a>
    4a86:	00001097          	auipc	ra,0x1
    4a8a:	18e080e7          	jalr	398(ra) # 5c14 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a8e:	20200593          	li	a1,514
    4a92:	00003517          	auipc	a0,0x3
    4a96:	2ee50513          	addi	a0,a0,750 # 7d80 <malloc+0x1d7a>
    4a9a:	00001097          	auipc	ra,0x1
    4a9e:	16a080e7          	jalr	362(ra) # 5c04 <open>
  if(fd < 0){
    4aa2:	04054a63          	bltz	a0,4af6 <sharedfd+0x90>
    4aa6:	892a                	mv	s2,a0
  pid = fork();
    4aa8:	00001097          	auipc	ra,0x1
    4aac:	114080e7          	jalr	276(ra) # 5bbc <fork>
    4ab0:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4ab2:	06300593          	li	a1,99
    4ab6:	c119                	beqz	a0,4abc <sharedfd+0x56>
    4ab8:	07000593          	li	a1,112
    4abc:	4629                	li	a2,10
    4abe:	fa040513          	addi	a0,s0,-96
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	f08080e7          	jalr	-248(ra) # 59ca <memset>
    4aca:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4ace:	4629                	li	a2,10
    4ad0:	fa040593          	addi	a1,s0,-96
    4ad4:	854a                	mv	a0,s2
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	10e080e7          	jalr	270(ra) # 5be4 <write>
    4ade:	47a9                	li	a5,10
    4ae0:	02f51963          	bne	a0,a5,4b12 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4ae4:	34fd                	addiw	s1,s1,-1
    4ae6:	f4e5                	bnez	s1,4ace <sharedfd+0x68>
  if(pid == 0) {
    4ae8:	04099363          	bnez	s3,4b2e <sharedfd+0xc8>
    exit(0);
    4aec:	4501                	li	a0,0
    4aee:	00001097          	auipc	ra,0x1
    4af2:	0d6080e7          	jalr	214(ra) # 5bc4 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4af6:	85d2                	mv	a1,s4
    4af8:	00003517          	auipc	a0,0x3
    4afc:	29850513          	addi	a0,a0,664 # 7d90 <malloc+0x1d8a>
    4b00:	00001097          	auipc	ra,0x1
    4b04:	44e080e7          	jalr	1102(ra) # 5f4e <printf>
    exit(1);
    4b08:	4505                	li	a0,1
    4b0a:	00001097          	auipc	ra,0x1
    4b0e:	0ba080e7          	jalr	186(ra) # 5bc4 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b12:	85d2                	mv	a1,s4
    4b14:	00003517          	auipc	a0,0x3
    4b18:	2a450513          	addi	a0,a0,676 # 7db8 <malloc+0x1db2>
    4b1c:	00001097          	auipc	ra,0x1
    4b20:	432080e7          	jalr	1074(ra) # 5f4e <printf>
      exit(1);
    4b24:	4505                	li	a0,1
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	09e080e7          	jalr	158(ra) # 5bc4 <exit>
    wait(&xstatus);
    4b2e:	f9c40513          	addi	a0,s0,-100
    4b32:	00001097          	auipc	ra,0x1
    4b36:	09a080e7          	jalr	154(ra) # 5bcc <wait>
    if(xstatus != 0)
    4b3a:	f9c42983          	lw	s3,-100(s0)
    4b3e:	00098763          	beqz	s3,4b4c <sharedfd+0xe6>
      exit(xstatus);
    4b42:	854e                	mv	a0,s3
    4b44:	00001097          	auipc	ra,0x1
    4b48:	080080e7          	jalr	128(ra) # 5bc4 <exit>
  close(fd);
    4b4c:	854a                	mv	a0,s2
    4b4e:	00001097          	auipc	ra,0x1
    4b52:	09e080e7          	jalr	158(ra) # 5bec <close>
  fd = open("sharedfd", 0);
    4b56:	4581                	li	a1,0
    4b58:	00003517          	auipc	a0,0x3
    4b5c:	22850513          	addi	a0,a0,552 # 7d80 <malloc+0x1d7a>
    4b60:	00001097          	auipc	ra,0x1
    4b64:	0a4080e7          	jalr	164(ra) # 5c04 <open>
    4b68:	8baa                	mv	s7,a0
  nc = np = 0;
    4b6a:	8ace                	mv	s5,s3
  if(fd < 0){
    4b6c:	02054563          	bltz	a0,4b96 <sharedfd+0x130>
    4b70:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b74:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b78:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b7c:	4629                	li	a2,10
    4b7e:	fa040593          	addi	a1,s0,-96
    4b82:	855e                	mv	a0,s7
    4b84:	00001097          	auipc	ra,0x1
    4b88:	058080e7          	jalr	88(ra) # 5bdc <read>
    4b8c:	02a05f63          	blez	a0,4bca <sharedfd+0x164>
    4b90:	fa040793          	addi	a5,s0,-96
    4b94:	a01d                	j	4bba <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b96:	85d2                	mv	a1,s4
    4b98:	00003517          	auipc	a0,0x3
    4b9c:	24050513          	addi	a0,a0,576 # 7dd8 <malloc+0x1dd2>
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	3ae080e7          	jalr	942(ra) # 5f4e <printf>
    exit(1);
    4ba8:	4505                	li	a0,1
    4baa:	00001097          	auipc	ra,0x1
    4bae:	01a080e7          	jalr	26(ra) # 5bc4 <exit>
        nc++;
    4bb2:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bb4:	0785                	addi	a5,a5,1
    4bb6:	fd2783e3          	beq	a5,s2,4b7c <sharedfd+0x116>
      if(buf[i] == 'c')
    4bba:	0007c703          	lbu	a4,0(a5)
    4bbe:	fe970ae3          	beq	a4,s1,4bb2 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bc2:	ff6719e3          	bne	a4,s6,4bb4 <sharedfd+0x14e>
        np++;
    4bc6:	2a85                	addiw	s5,s5,1
    4bc8:	b7f5                	j	4bb4 <sharedfd+0x14e>
  close(fd);
    4bca:	855e                	mv	a0,s7
    4bcc:	00001097          	auipc	ra,0x1
    4bd0:	020080e7          	jalr	32(ra) # 5bec <close>
  unlink("sharedfd");
    4bd4:	00003517          	auipc	a0,0x3
    4bd8:	1ac50513          	addi	a0,a0,428 # 7d80 <malloc+0x1d7a>
    4bdc:	00001097          	auipc	ra,0x1
    4be0:	038080e7          	jalr	56(ra) # 5c14 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4be4:	6789                	lui	a5,0x2
    4be6:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x104>
    4bea:	00f99763          	bne	s3,a5,4bf8 <sharedfd+0x192>
    4bee:	6789                	lui	a5,0x2
    4bf0:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x104>
    4bf4:	02fa8063          	beq	s5,a5,4c14 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4bf8:	85d2                	mv	a1,s4
    4bfa:	00003517          	auipc	a0,0x3
    4bfe:	20650513          	addi	a0,a0,518 # 7e00 <malloc+0x1dfa>
    4c02:	00001097          	auipc	ra,0x1
    4c06:	34c080e7          	jalr	844(ra) # 5f4e <printf>
    exit(1);
    4c0a:	4505                	li	a0,1
    4c0c:	00001097          	auipc	ra,0x1
    4c10:	fb8080e7          	jalr	-72(ra) # 5bc4 <exit>
    exit(0);
    4c14:	4501                	li	a0,0
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	fae080e7          	jalr	-82(ra) # 5bc4 <exit>

0000000000004c1e <fourfiles>:
{
    4c1e:	7171                	addi	sp,sp,-176
    4c20:	f506                	sd	ra,168(sp)
    4c22:	f122                	sd	s0,160(sp)
    4c24:	ed26                	sd	s1,152(sp)
    4c26:	e94a                	sd	s2,144(sp)
    4c28:	e54e                	sd	s3,136(sp)
    4c2a:	e152                	sd	s4,128(sp)
    4c2c:	fcd6                	sd	s5,120(sp)
    4c2e:	f8da                	sd	s6,112(sp)
    4c30:	f4de                	sd	s7,104(sp)
    4c32:	f0e2                	sd	s8,96(sp)
    4c34:	ece6                	sd	s9,88(sp)
    4c36:	e8ea                	sd	s10,80(sp)
    4c38:	e4ee                	sd	s11,72(sp)
    4c3a:	1900                	addi	s0,sp,176
    4c3c:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c40:	00003797          	auipc	a5,0x3
    4c44:	1d878793          	addi	a5,a5,472 # 7e18 <malloc+0x1e12>
    4c48:	f6f43823          	sd	a5,-144(s0)
    4c4c:	00003797          	auipc	a5,0x3
    4c50:	1d478793          	addi	a5,a5,468 # 7e20 <malloc+0x1e1a>
    4c54:	f6f43c23          	sd	a5,-136(s0)
    4c58:	00003797          	auipc	a5,0x3
    4c5c:	1d078793          	addi	a5,a5,464 # 7e28 <malloc+0x1e22>
    4c60:	f8f43023          	sd	a5,-128(s0)
    4c64:	00003797          	auipc	a5,0x3
    4c68:	1cc78793          	addi	a5,a5,460 # 7e30 <malloc+0x1e2a>
    4c6c:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c70:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c74:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4c76:	4481                	li	s1,0
    4c78:	4a11                	li	s4,4
    fname = names[pi];
    4c7a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c7e:	854e                	mv	a0,s3
    4c80:	00001097          	auipc	ra,0x1
    4c84:	f94080e7          	jalr	-108(ra) # 5c14 <unlink>
    pid = fork();
    4c88:	00001097          	auipc	ra,0x1
    4c8c:	f34080e7          	jalr	-204(ra) # 5bbc <fork>
    if(pid < 0){
    4c90:	04054463          	bltz	a0,4cd8 <fourfiles+0xba>
    if(pid == 0){
    4c94:	c12d                	beqz	a0,4cf6 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4c96:	2485                	addiw	s1,s1,1
    4c98:	0921                	addi	s2,s2,8
    4c9a:	ff4490e3          	bne	s1,s4,4c7a <fourfiles+0x5c>
    4c9e:	4491                	li	s1,4
    wait(&xstatus);
    4ca0:	f6c40513          	addi	a0,s0,-148
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	f28080e7          	jalr	-216(ra) # 5bcc <wait>
    if(xstatus != 0)
    4cac:	f6c42b03          	lw	s6,-148(s0)
    4cb0:	0c0b1e63          	bnez	s6,4d8c <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4cb4:	34fd                	addiw	s1,s1,-1
    4cb6:	f4ed                	bnez	s1,4ca0 <fourfiles+0x82>
    4cb8:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cbc:	00008a17          	auipc	s4,0x8
    4cc0:	fbca0a13          	addi	s4,s4,-68 # cc78 <buf>
    4cc4:	00008a97          	auipc	s5,0x8
    4cc8:	fb5a8a93          	addi	s5,s5,-75 # cc79 <buf+0x1>
    if(total != N*SZ){
    4ccc:	6d85                	lui	s11,0x1
    4cce:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x2e>
  for(i = 0; i < NCHILD; i++){
    4cd2:	03400d13          	li	s10,52
    4cd6:	aa1d                	j	4e0c <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4cd8:	f5843583          	ld	a1,-168(s0)
    4cdc:	00002517          	auipc	a0,0x2
    4ce0:	0dc50513          	addi	a0,a0,220 # 6db8 <malloc+0xdb2>
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	26a080e7          	jalr	618(ra) # 5f4e <printf>
      exit(1);
    4cec:	4505                	li	a0,1
    4cee:	00001097          	auipc	ra,0x1
    4cf2:	ed6080e7          	jalr	-298(ra) # 5bc4 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cf6:	20200593          	li	a1,514
    4cfa:	854e                	mv	a0,s3
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	f08080e7          	jalr	-248(ra) # 5c04 <open>
    4d04:	892a                	mv	s2,a0
      if(fd < 0){
    4d06:	04054763          	bltz	a0,4d54 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4d0a:	1f400613          	li	a2,500
    4d0e:	0304859b          	addiw	a1,s1,48
    4d12:	00008517          	auipc	a0,0x8
    4d16:	f6650513          	addi	a0,a0,-154 # cc78 <buf>
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	cb0080e7          	jalr	-848(ra) # 59ca <memset>
    4d22:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d24:	00008997          	auipc	s3,0x8
    4d28:	f5498993          	addi	s3,s3,-172 # cc78 <buf>
    4d2c:	1f400613          	li	a2,500
    4d30:	85ce                	mv	a1,s3
    4d32:	854a                	mv	a0,s2
    4d34:	00001097          	auipc	ra,0x1
    4d38:	eb0080e7          	jalr	-336(ra) # 5be4 <write>
    4d3c:	85aa                	mv	a1,a0
    4d3e:	1f400793          	li	a5,500
    4d42:	02f51863          	bne	a0,a5,4d72 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4d46:	34fd                	addiw	s1,s1,-1
    4d48:	f0f5                	bnez	s1,4d2c <fourfiles+0x10e>
      exit(0);
    4d4a:	4501                	li	a0,0
    4d4c:	00001097          	auipc	ra,0x1
    4d50:	e78080e7          	jalr	-392(ra) # 5bc4 <exit>
        printf("create failed\n", s);
    4d54:	f5843583          	ld	a1,-168(s0)
    4d58:	00003517          	auipc	a0,0x3
    4d5c:	0e050513          	addi	a0,a0,224 # 7e38 <malloc+0x1e32>
    4d60:	00001097          	auipc	ra,0x1
    4d64:	1ee080e7          	jalr	494(ra) # 5f4e <printf>
        exit(1);
    4d68:	4505                	li	a0,1
    4d6a:	00001097          	auipc	ra,0x1
    4d6e:	e5a080e7          	jalr	-422(ra) # 5bc4 <exit>
          printf("write failed %d\n", n);
    4d72:	00003517          	auipc	a0,0x3
    4d76:	0d650513          	addi	a0,a0,214 # 7e48 <malloc+0x1e42>
    4d7a:	00001097          	auipc	ra,0x1
    4d7e:	1d4080e7          	jalr	468(ra) # 5f4e <printf>
          exit(1);
    4d82:	4505                	li	a0,1
    4d84:	00001097          	auipc	ra,0x1
    4d88:	e40080e7          	jalr	-448(ra) # 5bc4 <exit>
      exit(xstatus);
    4d8c:	855a                	mv	a0,s6
    4d8e:	00001097          	auipc	ra,0x1
    4d92:	e36080e7          	jalr	-458(ra) # 5bc4 <exit>
          printf("wrong char\n", s);
    4d96:	f5843583          	ld	a1,-168(s0)
    4d9a:	00003517          	auipc	a0,0x3
    4d9e:	0c650513          	addi	a0,a0,198 # 7e60 <malloc+0x1e5a>
    4da2:	00001097          	auipc	ra,0x1
    4da6:	1ac080e7          	jalr	428(ra) # 5f4e <printf>
          exit(1);
    4daa:	4505                	li	a0,1
    4dac:	00001097          	auipc	ra,0x1
    4db0:	e18080e7          	jalr	-488(ra) # 5bc4 <exit>
      total += n;
    4db4:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4db8:	660d                	lui	a2,0x3
    4dba:	85d2                	mv	a1,s4
    4dbc:	854e                	mv	a0,s3
    4dbe:	00001097          	auipc	ra,0x1
    4dc2:	e1e080e7          	jalr	-482(ra) # 5bdc <read>
    4dc6:	02a05363          	blez	a0,4dec <fourfiles+0x1ce>
    4dca:	00008797          	auipc	a5,0x8
    4dce:	eae78793          	addi	a5,a5,-338 # cc78 <buf>
    4dd2:	fff5069b          	addiw	a3,a0,-1
    4dd6:	1682                	slli	a3,a3,0x20
    4dd8:	9281                	srli	a3,a3,0x20
    4dda:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4ddc:	0007c703          	lbu	a4,0(a5)
    4de0:	fa971be3          	bne	a4,s1,4d96 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4de4:	0785                	addi	a5,a5,1
    4de6:	fed79be3          	bne	a5,a3,4ddc <fourfiles+0x1be>
    4dea:	b7e9                	j	4db4 <fourfiles+0x196>
    close(fd);
    4dec:	854e                	mv	a0,s3
    4dee:	00001097          	auipc	ra,0x1
    4df2:	dfe080e7          	jalr	-514(ra) # 5bec <close>
    if(total != N*SZ){
    4df6:	03b91863          	bne	s2,s11,4e26 <fourfiles+0x208>
    unlink(fname);
    4dfa:	8566                	mv	a0,s9
    4dfc:	00001097          	auipc	ra,0x1
    4e00:	e18080e7          	jalr	-488(ra) # 5c14 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e04:	0c21                	addi	s8,s8,8
    4e06:	2b85                	addiw	s7,s7,1
    4e08:	03ab8d63          	beq	s7,s10,4e42 <fourfiles+0x224>
    fname = names[i];
    4e0c:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4e10:	4581                	li	a1,0
    4e12:	8566                	mv	a0,s9
    4e14:	00001097          	auipc	ra,0x1
    4e18:	df0080e7          	jalr	-528(ra) # 5c04 <open>
    4e1c:	89aa                	mv	s3,a0
    total = 0;
    4e1e:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4e20:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e24:	bf51                	j	4db8 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4e26:	85ca                	mv	a1,s2
    4e28:	00003517          	auipc	a0,0x3
    4e2c:	04850513          	addi	a0,a0,72 # 7e70 <malloc+0x1e6a>
    4e30:	00001097          	auipc	ra,0x1
    4e34:	11e080e7          	jalr	286(ra) # 5f4e <printf>
      exit(1);
    4e38:	4505                	li	a0,1
    4e3a:	00001097          	auipc	ra,0x1
    4e3e:	d8a080e7          	jalr	-630(ra) # 5bc4 <exit>
}
    4e42:	70aa                	ld	ra,168(sp)
    4e44:	740a                	ld	s0,160(sp)
    4e46:	64ea                	ld	s1,152(sp)
    4e48:	694a                	ld	s2,144(sp)
    4e4a:	69aa                	ld	s3,136(sp)
    4e4c:	6a0a                	ld	s4,128(sp)
    4e4e:	7ae6                	ld	s5,120(sp)
    4e50:	7b46                	ld	s6,112(sp)
    4e52:	7ba6                	ld	s7,104(sp)
    4e54:	7c06                	ld	s8,96(sp)
    4e56:	6ce6                	ld	s9,88(sp)
    4e58:	6d46                	ld	s10,80(sp)
    4e5a:	6da6                	ld	s11,72(sp)
    4e5c:	614d                	addi	sp,sp,176
    4e5e:	8082                	ret

0000000000004e60 <concreate>:
{
    4e60:	7135                	addi	sp,sp,-160
    4e62:	ed06                	sd	ra,152(sp)
    4e64:	e922                	sd	s0,144(sp)
    4e66:	e526                	sd	s1,136(sp)
    4e68:	e14a                	sd	s2,128(sp)
    4e6a:	fcce                	sd	s3,120(sp)
    4e6c:	f8d2                	sd	s4,112(sp)
    4e6e:	f4d6                	sd	s5,104(sp)
    4e70:	f0da                	sd	s6,96(sp)
    4e72:	ecde                	sd	s7,88(sp)
    4e74:	1100                	addi	s0,sp,160
    4e76:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e78:	04300793          	li	a5,67
    4e7c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e80:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e84:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e86:	4b0d                	li	s6,3
    4e88:	4a85                	li	s5,1
      link("C0", file);
    4e8a:	00003b97          	auipc	s7,0x3
    4e8e:	ffeb8b93          	addi	s7,s7,-2 # 7e88 <malloc+0x1e82>
  for(i = 0; i < N; i++){
    4e92:	02800a13          	li	s4,40
    4e96:	acc9                	j	5168 <concreate+0x308>
      link("C0", file);
    4e98:	fa840593          	addi	a1,s0,-88
    4e9c:	855e                	mv	a0,s7
    4e9e:	00001097          	auipc	ra,0x1
    4ea2:	d86080e7          	jalr	-634(ra) # 5c24 <link>
    if(pid == 0) {
    4ea6:	a465                	j	514e <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4ea8:	4795                	li	a5,5
    4eaa:	02f9693b          	remw	s2,s2,a5
    4eae:	4785                	li	a5,1
    4eb0:	02f90b63          	beq	s2,a5,4ee6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eb4:	20200593          	li	a1,514
    4eb8:	fa840513          	addi	a0,s0,-88
    4ebc:	00001097          	auipc	ra,0x1
    4ec0:	d48080e7          	jalr	-696(ra) # 5c04 <open>
      if(fd < 0){
    4ec4:	26055c63          	bgez	a0,513c <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4ec8:	fa840593          	addi	a1,s0,-88
    4ecc:	00003517          	auipc	a0,0x3
    4ed0:	fc450513          	addi	a0,a0,-60 # 7e90 <malloc+0x1e8a>
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	07a080e7          	jalr	122(ra) # 5f4e <printf>
        exit(1);
    4edc:	4505                	li	a0,1
    4ede:	00001097          	auipc	ra,0x1
    4ee2:	ce6080e7          	jalr	-794(ra) # 5bc4 <exit>
      link("C0", file);
    4ee6:	fa840593          	addi	a1,s0,-88
    4eea:	00003517          	auipc	a0,0x3
    4eee:	f9e50513          	addi	a0,a0,-98 # 7e88 <malloc+0x1e82>
    4ef2:	00001097          	auipc	ra,0x1
    4ef6:	d32080e7          	jalr	-718(ra) # 5c24 <link>
      exit(0);
    4efa:	4501                	li	a0,0
    4efc:	00001097          	auipc	ra,0x1
    4f00:	cc8080e7          	jalr	-824(ra) # 5bc4 <exit>
        exit(1);
    4f04:	4505                	li	a0,1
    4f06:	00001097          	auipc	ra,0x1
    4f0a:	cbe080e7          	jalr	-834(ra) # 5bc4 <exit>
  memset(fa, 0, sizeof(fa));
    4f0e:	02800613          	li	a2,40
    4f12:	4581                	li	a1,0
    4f14:	f8040513          	addi	a0,s0,-128
    4f18:	00001097          	auipc	ra,0x1
    4f1c:	ab2080e7          	jalr	-1358(ra) # 59ca <memset>
  fd = open(".", 0);
    4f20:	4581                	li	a1,0
    4f22:	00002517          	auipc	a0,0x2
    4f26:	8ee50513          	addi	a0,a0,-1810 # 6810 <malloc+0x80a>
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	cda080e7          	jalr	-806(ra) # 5c04 <open>
    4f32:	892a                	mv	s2,a0
  n = 0;
    4f34:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f36:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f3a:	02700b13          	li	s6,39
      fa[i] = 1;
    4f3e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f40:	4641                	li	a2,16
    4f42:	f7040593          	addi	a1,s0,-144
    4f46:	854a                	mv	a0,s2
    4f48:	00001097          	auipc	ra,0x1
    4f4c:	c94080e7          	jalr	-876(ra) # 5bdc <read>
    4f50:	08a05263          	blez	a0,4fd4 <concreate+0x174>
    if(de.inum == 0)
    4f54:	f7045783          	lhu	a5,-144(s0)
    4f58:	d7e5                	beqz	a5,4f40 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f5a:	f7244783          	lbu	a5,-142(s0)
    4f5e:	ff4791e3          	bne	a5,s4,4f40 <concreate+0xe0>
    4f62:	f7444783          	lbu	a5,-140(s0)
    4f66:	ffe9                	bnez	a5,4f40 <concreate+0xe0>
      i = de.name[1] - '0';
    4f68:	f7344783          	lbu	a5,-141(s0)
    4f6c:	fd07879b          	addiw	a5,a5,-48
    4f70:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f74:	02eb6063          	bltu	s6,a4,4f94 <concreate+0x134>
      if(fa[i]){
    4f78:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xba>
    4f7c:	97a2                	add	a5,a5,s0
    4f7e:	fd07c783          	lbu	a5,-48(a5)
    4f82:	eb8d                	bnez	a5,4fb4 <concreate+0x154>
      fa[i] = 1;
    4f84:	fb070793          	addi	a5,a4,-80
    4f88:	00878733          	add	a4,a5,s0
    4f8c:	fd770823          	sb	s7,-48(a4)
      n++;
    4f90:	2a85                	addiw	s5,s5,1
    4f92:	b77d                	j	4f40 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f94:	f7240613          	addi	a2,s0,-142
    4f98:	85ce                	mv	a1,s3
    4f9a:	00003517          	auipc	a0,0x3
    4f9e:	f1650513          	addi	a0,a0,-234 # 7eb0 <malloc+0x1eaa>
    4fa2:	00001097          	auipc	ra,0x1
    4fa6:	fac080e7          	jalr	-84(ra) # 5f4e <printf>
        exit(1);
    4faa:	4505                	li	a0,1
    4fac:	00001097          	auipc	ra,0x1
    4fb0:	c18080e7          	jalr	-1000(ra) # 5bc4 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fb4:	f7240613          	addi	a2,s0,-142
    4fb8:	85ce                	mv	a1,s3
    4fba:	00003517          	auipc	a0,0x3
    4fbe:	f1650513          	addi	a0,a0,-234 # 7ed0 <malloc+0x1eca>
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	f8c080e7          	jalr	-116(ra) # 5f4e <printf>
        exit(1);
    4fca:	4505                	li	a0,1
    4fcc:	00001097          	auipc	ra,0x1
    4fd0:	bf8080e7          	jalr	-1032(ra) # 5bc4 <exit>
  close(fd);
    4fd4:	854a                	mv	a0,s2
    4fd6:	00001097          	auipc	ra,0x1
    4fda:	c16080e7          	jalr	-1002(ra) # 5bec <close>
  if(n != N){
    4fde:	02800793          	li	a5,40
    4fe2:	00fa9763          	bne	s5,a5,4ff0 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4fe6:	4a8d                	li	s5,3
    4fe8:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fea:	02800a13          	li	s4,40
    4fee:	a8c9                	j	50c0 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ff0:	85ce                	mv	a1,s3
    4ff2:	00003517          	auipc	a0,0x3
    4ff6:	f0650513          	addi	a0,a0,-250 # 7ef8 <malloc+0x1ef2>
    4ffa:	00001097          	auipc	ra,0x1
    4ffe:	f54080e7          	jalr	-172(ra) # 5f4e <printf>
    exit(1);
    5002:	4505                	li	a0,1
    5004:	00001097          	auipc	ra,0x1
    5008:	bc0080e7          	jalr	-1088(ra) # 5bc4 <exit>
      printf("%s: fork failed\n", s);
    500c:	85ce                	mv	a1,s3
    500e:	00002517          	auipc	a0,0x2
    5012:	9a250513          	addi	a0,a0,-1630 # 69b0 <malloc+0x9aa>
    5016:	00001097          	auipc	ra,0x1
    501a:	f38080e7          	jalr	-200(ra) # 5f4e <printf>
      exit(1);
    501e:	4505                	li	a0,1
    5020:	00001097          	auipc	ra,0x1
    5024:	ba4080e7          	jalr	-1116(ra) # 5bc4 <exit>
      close(open(file, 0));
    5028:	4581                	li	a1,0
    502a:	fa840513          	addi	a0,s0,-88
    502e:	00001097          	auipc	ra,0x1
    5032:	bd6080e7          	jalr	-1066(ra) # 5c04 <open>
    5036:	00001097          	auipc	ra,0x1
    503a:	bb6080e7          	jalr	-1098(ra) # 5bec <close>
      close(open(file, 0));
    503e:	4581                	li	a1,0
    5040:	fa840513          	addi	a0,s0,-88
    5044:	00001097          	auipc	ra,0x1
    5048:	bc0080e7          	jalr	-1088(ra) # 5c04 <open>
    504c:	00001097          	auipc	ra,0x1
    5050:	ba0080e7          	jalr	-1120(ra) # 5bec <close>
      close(open(file, 0));
    5054:	4581                	li	a1,0
    5056:	fa840513          	addi	a0,s0,-88
    505a:	00001097          	auipc	ra,0x1
    505e:	baa080e7          	jalr	-1110(ra) # 5c04 <open>
    5062:	00001097          	auipc	ra,0x1
    5066:	b8a080e7          	jalr	-1142(ra) # 5bec <close>
      close(open(file, 0));
    506a:	4581                	li	a1,0
    506c:	fa840513          	addi	a0,s0,-88
    5070:	00001097          	auipc	ra,0x1
    5074:	b94080e7          	jalr	-1132(ra) # 5c04 <open>
    5078:	00001097          	auipc	ra,0x1
    507c:	b74080e7          	jalr	-1164(ra) # 5bec <close>
      close(open(file, 0));
    5080:	4581                	li	a1,0
    5082:	fa840513          	addi	a0,s0,-88
    5086:	00001097          	auipc	ra,0x1
    508a:	b7e080e7          	jalr	-1154(ra) # 5c04 <open>
    508e:	00001097          	auipc	ra,0x1
    5092:	b5e080e7          	jalr	-1186(ra) # 5bec <close>
      close(open(file, 0));
    5096:	4581                	li	a1,0
    5098:	fa840513          	addi	a0,s0,-88
    509c:	00001097          	auipc	ra,0x1
    50a0:	b68080e7          	jalr	-1176(ra) # 5c04 <open>
    50a4:	00001097          	auipc	ra,0x1
    50a8:	b48080e7          	jalr	-1208(ra) # 5bec <close>
    if(pid == 0)
    50ac:	08090363          	beqz	s2,5132 <concreate+0x2d2>
      wait(0);
    50b0:	4501                	li	a0,0
    50b2:	00001097          	auipc	ra,0x1
    50b6:	b1a080e7          	jalr	-1254(ra) # 5bcc <wait>
  for(i = 0; i < N; i++){
    50ba:	2485                	addiw	s1,s1,1
    50bc:	0f448563          	beq	s1,s4,51a6 <concreate+0x346>
    file[1] = '0' + i;
    50c0:	0304879b          	addiw	a5,s1,48
    50c4:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50c8:	00001097          	auipc	ra,0x1
    50cc:	af4080e7          	jalr	-1292(ra) # 5bbc <fork>
    50d0:	892a                	mv	s2,a0
    if(pid < 0){
    50d2:	f2054de3          	bltz	a0,500c <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    50d6:	0354e73b          	remw	a4,s1,s5
    50da:	00a767b3          	or	a5,a4,a0
    50de:	2781                	sext.w	a5,a5
    50e0:	d7a1                	beqz	a5,5028 <concreate+0x1c8>
    50e2:	01671363          	bne	a4,s6,50e8 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    50e6:	f129                	bnez	a0,5028 <concreate+0x1c8>
      unlink(file);
    50e8:	fa840513          	addi	a0,s0,-88
    50ec:	00001097          	auipc	ra,0x1
    50f0:	b28080e7          	jalr	-1240(ra) # 5c14 <unlink>
      unlink(file);
    50f4:	fa840513          	addi	a0,s0,-88
    50f8:	00001097          	auipc	ra,0x1
    50fc:	b1c080e7          	jalr	-1252(ra) # 5c14 <unlink>
      unlink(file);
    5100:	fa840513          	addi	a0,s0,-88
    5104:	00001097          	auipc	ra,0x1
    5108:	b10080e7          	jalr	-1264(ra) # 5c14 <unlink>
      unlink(file);
    510c:	fa840513          	addi	a0,s0,-88
    5110:	00001097          	auipc	ra,0x1
    5114:	b04080e7          	jalr	-1276(ra) # 5c14 <unlink>
      unlink(file);
    5118:	fa840513          	addi	a0,s0,-88
    511c:	00001097          	auipc	ra,0x1
    5120:	af8080e7          	jalr	-1288(ra) # 5c14 <unlink>
      unlink(file);
    5124:	fa840513          	addi	a0,s0,-88
    5128:	00001097          	auipc	ra,0x1
    512c:	aec080e7          	jalr	-1300(ra) # 5c14 <unlink>
    5130:	bfb5                	j	50ac <concreate+0x24c>
      exit(0);
    5132:	4501                	li	a0,0
    5134:	00001097          	auipc	ra,0x1
    5138:	a90080e7          	jalr	-1392(ra) # 5bc4 <exit>
      close(fd);
    513c:	00001097          	auipc	ra,0x1
    5140:	ab0080e7          	jalr	-1360(ra) # 5bec <close>
    if(pid == 0) {
    5144:	bb5d                	j	4efa <concreate+0x9a>
      close(fd);
    5146:	00001097          	auipc	ra,0x1
    514a:	aa6080e7          	jalr	-1370(ra) # 5bec <close>
      wait(&xstatus);
    514e:	f6c40513          	addi	a0,s0,-148
    5152:	00001097          	auipc	ra,0x1
    5156:	a7a080e7          	jalr	-1414(ra) # 5bcc <wait>
      if(xstatus != 0)
    515a:	f6c42483          	lw	s1,-148(s0)
    515e:	da0493e3          	bnez	s1,4f04 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5162:	2905                	addiw	s2,s2,1
    5164:	db4905e3          	beq	s2,s4,4f0e <concreate+0xae>
    file[1] = '0' + i;
    5168:	0309079b          	addiw	a5,s2,48
    516c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5170:	fa840513          	addi	a0,s0,-88
    5174:	00001097          	auipc	ra,0x1
    5178:	aa0080e7          	jalr	-1376(ra) # 5c14 <unlink>
    pid = fork();
    517c:	00001097          	auipc	ra,0x1
    5180:	a40080e7          	jalr	-1472(ra) # 5bbc <fork>
    if(pid && (i % 3) == 1){
    5184:	d20502e3          	beqz	a0,4ea8 <concreate+0x48>
    5188:	036967bb          	remw	a5,s2,s6
    518c:	d15786e3          	beq	a5,s5,4e98 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5190:	20200593          	li	a1,514
    5194:	fa840513          	addi	a0,s0,-88
    5198:	00001097          	auipc	ra,0x1
    519c:	a6c080e7          	jalr	-1428(ra) # 5c04 <open>
      if(fd < 0){
    51a0:	fa0553e3          	bgez	a0,5146 <concreate+0x2e6>
    51a4:	b315                	j	4ec8 <concreate+0x68>
}
    51a6:	60ea                	ld	ra,152(sp)
    51a8:	644a                	ld	s0,144(sp)
    51aa:	64aa                	ld	s1,136(sp)
    51ac:	690a                	ld	s2,128(sp)
    51ae:	79e6                	ld	s3,120(sp)
    51b0:	7a46                	ld	s4,112(sp)
    51b2:	7aa6                	ld	s5,104(sp)
    51b4:	7b06                	ld	s6,96(sp)
    51b6:	6be6                	ld	s7,88(sp)
    51b8:	610d                	addi	sp,sp,160
    51ba:	8082                	ret

00000000000051bc <bigfile>:
{
    51bc:	7139                	addi	sp,sp,-64
    51be:	fc06                	sd	ra,56(sp)
    51c0:	f822                	sd	s0,48(sp)
    51c2:	f426                	sd	s1,40(sp)
    51c4:	f04a                	sd	s2,32(sp)
    51c6:	ec4e                	sd	s3,24(sp)
    51c8:	e852                	sd	s4,16(sp)
    51ca:	e456                	sd	s5,8(sp)
    51cc:	0080                	addi	s0,sp,64
    51ce:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51d0:	00003517          	auipc	a0,0x3
    51d4:	d6050513          	addi	a0,a0,-672 # 7f30 <malloc+0x1f2a>
    51d8:	00001097          	auipc	ra,0x1
    51dc:	a3c080e7          	jalr	-1476(ra) # 5c14 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51e0:	20200593          	li	a1,514
    51e4:	00003517          	auipc	a0,0x3
    51e8:	d4c50513          	addi	a0,a0,-692 # 7f30 <malloc+0x1f2a>
    51ec:	00001097          	auipc	ra,0x1
    51f0:	a18080e7          	jalr	-1512(ra) # 5c04 <open>
    51f4:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51f6:	4481                	li	s1,0
    memset(buf, i, SZ);
    51f8:	00008917          	auipc	s2,0x8
    51fc:	a8090913          	addi	s2,s2,-1408 # cc78 <buf>
  for(i = 0; i < N; i++){
    5200:	4a51                	li	s4,20
  if(fd < 0){
    5202:	0a054063          	bltz	a0,52a2 <bigfile+0xe6>
    memset(buf, i, SZ);
    5206:	25800613          	li	a2,600
    520a:	85a6                	mv	a1,s1
    520c:	854a                	mv	a0,s2
    520e:	00000097          	auipc	ra,0x0
    5212:	7bc080e7          	jalr	1980(ra) # 59ca <memset>
    if(write(fd, buf, SZ) != SZ){
    5216:	25800613          	li	a2,600
    521a:	85ca                	mv	a1,s2
    521c:	854e                	mv	a0,s3
    521e:	00001097          	auipc	ra,0x1
    5222:	9c6080e7          	jalr	-1594(ra) # 5be4 <write>
    5226:	25800793          	li	a5,600
    522a:	08f51a63          	bne	a0,a5,52be <bigfile+0x102>
  for(i = 0; i < N; i++){
    522e:	2485                	addiw	s1,s1,1
    5230:	fd449be3          	bne	s1,s4,5206 <bigfile+0x4a>
  close(fd);
    5234:	854e                	mv	a0,s3
    5236:	00001097          	auipc	ra,0x1
    523a:	9b6080e7          	jalr	-1610(ra) # 5bec <close>
  fd = open("bigfile.dat", 0);
    523e:	4581                	li	a1,0
    5240:	00003517          	auipc	a0,0x3
    5244:	cf050513          	addi	a0,a0,-784 # 7f30 <malloc+0x1f2a>
    5248:	00001097          	auipc	ra,0x1
    524c:	9bc080e7          	jalr	-1604(ra) # 5c04 <open>
    5250:	8a2a                	mv	s4,a0
  total = 0;
    5252:	4981                	li	s3,0
  for(i = 0; ; i++){
    5254:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5256:	00008917          	auipc	s2,0x8
    525a:	a2290913          	addi	s2,s2,-1502 # cc78 <buf>
  if(fd < 0){
    525e:	06054e63          	bltz	a0,52da <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5262:	12c00613          	li	a2,300
    5266:	85ca                	mv	a1,s2
    5268:	8552                	mv	a0,s4
    526a:	00001097          	auipc	ra,0x1
    526e:	972080e7          	jalr	-1678(ra) # 5bdc <read>
    if(cc < 0){
    5272:	08054263          	bltz	a0,52f6 <bigfile+0x13a>
    if(cc == 0)
    5276:	c971                	beqz	a0,534a <bigfile+0x18e>
    if(cc != SZ/2){
    5278:	12c00793          	li	a5,300
    527c:	08f51b63          	bne	a0,a5,5312 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5280:	01f4d79b          	srliw	a5,s1,0x1f
    5284:	9fa5                	addw	a5,a5,s1
    5286:	4017d79b          	sraiw	a5,a5,0x1
    528a:	00094703          	lbu	a4,0(s2)
    528e:	0af71063          	bne	a4,a5,532e <bigfile+0x172>
    5292:	12b94703          	lbu	a4,299(s2)
    5296:	08f71c63          	bne	a4,a5,532e <bigfile+0x172>
    total += cc;
    529a:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    529e:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52a0:	b7c9                	j	5262 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52a2:	85d6                	mv	a1,s5
    52a4:	00003517          	auipc	a0,0x3
    52a8:	c9c50513          	addi	a0,a0,-868 # 7f40 <malloc+0x1f3a>
    52ac:	00001097          	auipc	ra,0x1
    52b0:	ca2080e7          	jalr	-862(ra) # 5f4e <printf>
    exit(1);
    52b4:	4505                	li	a0,1
    52b6:	00001097          	auipc	ra,0x1
    52ba:	90e080e7          	jalr	-1778(ra) # 5bc4 <exit>
      printf("%s: write bigfile failed\n", s);
    52be:	85d6                	mv	a1,s5
    52c0:	00003517          	auipc	a0,0x3
    52c4:	ca050513          	addi	a0,a0,-864 # 7f60 <malloc+0x1f5a>
    52c8:	00001097          	auipc	ra,0x1
    52cc:	c86080e7          	jalr	-890(ra) # 5f4e <printf>
      exit(1);
    52d0:	4505                	li	a0,1
    52d2:	00001097          	auipc	ra,0x1
    52d6:	8f2080e7          	jalr	-1806(ra) # 5bc4 <exit>
    printf("%s: cannot open bigfile\n", s);
    52da:	85d6                	mv	a1,s5
    52dc:	00003517          	auipc	a0,0x3
    52e0:	ca450513          	addi	a0,a0,-860 # 7f80 <malloc+0x1f7a>
    52e4:	00001097          	auipc	ra,0x1
    52e8:	c6a080e7          	jalr	-918(ra) # 5f4e <printf>
    exit(1);
    52ec:	4505                	li	a0,1
    52ee:	00001097          	auipc	ra,0x1
    52f2:	8d6080e7          	jalr	-1834(ra) # 5bc4 <exit>
      printf("%s: read bigfile failed\n", s);
    52f6:	85d6                	mv	a1,s5
    52f8:	00003517          	auipc	a0,0x3
    52fc:	ca850513          	addi	a0,a0,-856 # 7fa0 <malloc+0x1f9a>
    5300:	00001097          	auipc	ra,0x1
    5304:	c4e080e7          	jalr	-946(ra) # 5f4e <printf>
      exit(1);
    5308:	4505                	li	a0,1
    530a:	00001097          	auipc	ra,0x1
    530e:	8ba080e7          	jalr	-1862(ra) # 5bc4 <exit>
      printf("%s: short read bigfile\n", s);
    5312:	85d6                	mv	a1,s5
    5314:	00003517          	auipc	a0,0x3
    5318:	cac50513          	addi	a0,a0,-852 # 7fc0 <malloc+0x1fba>
    531c:	00001097          	auipc	ra,0x1
    5320:	c32080e7          	jalr	-974(ra) # 5f4e <printf>
      exit(1);
    5324:	4505                	li	a0,1
    5326:	00001097          	auipc	ra,0x1
    532a:	89e080e7          	jalr	-1890(ra) # 5bc4 <exit>
      printf("%s: read bigfile wrong data\n", s);
    532e:	85d6                	mv	a1,s5
    5330:	00003517          	auipc	a0,0x3
    5334:	ca850513          	addi	a0,a0,-856 # 7fd8 <malloc+0x1fd2>
    5338:	00001097          	auipc	ra,0x1
    533c:	c16080e7          	jalr	-1002(ra) # 5f4e <printf>
      exit(1);
    5340:	4505                	li	a0,1
    5342:	00001097          	auipc	ra,0x1
    5346:	882080e7          	jalr	-1918(ra) # 5bc4 <exit>
  close(fd);
    534a:	8552                	mv	a0,s4
    534c:	00001097          	auipc	ra,0x1
    5350:	8a0080e7          	jalr	-1888(ra) # 5bec <close>
  if(total != N*SZ){
    5354:	678d                	lui	a5,0x3
    5356:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x8c>
    535a:	02f99363          	bne	s3,a5,5380 <bigfile+0x1c4>
  unlink("bigfile.dat");
    535e:	00003517          	auipc	a0,0x3
    5362:	bd250513          	addi	a0,a0,-1070 # 7f30 <malloc+0x1f2a>
    5366:	00001097          	auipc	ra,0x1
    536a:	8ae080e7          	jalr	-1874(ra) # 5c14 <unlink>
}
    536e:	70e2                	ld	ra,56(sp)
    5370:	7442                	ld	s0,48(sp)
    5372:	74a2                	ld	s1,40(sp)
    5374:	7902                	ld	s2,32(sp)
    5376:	69e2                	ld	s3,24(sp)
    5378:	6a42                	ld	s4,16(sp)
    537a:	6aa2                	ld	s5,8(sp)
    537c:	6121                	addi	sp,sp,64
    537e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5380:	85d6                	mv	a1,s5
    5382:	00003517          	auipc	a0,0x3
    5386:	c7650513          	addi	a0,a0,-906 # 7ff8 <malloc+0x1ff2>
    538a:	00001097          	auipc	ra,0x1
    538e:	bc4080e7          	jalr	-1084(ra) # 5f4e <printf>
    exit(1);
    5392:	4505                	li	a0,1
    5394:	00001097          	auipc	ra,0x1
    5398:	830080e7          	jalr	-2000(ra) # 5bc4 <exit>

000000000000539c <fsfull>:
{
    539c:	7171                	addi	sp,sp,-176
    539e:	f506                	sd	ra,168(sp)
    53a0:	f122                	sd	s0,160(sp)
    53a2:	ed26                	sd	s1,152(sp)
    53a4:	e94a                	sd	s2,144(sp)
    53a6:	e54e                	sd	s3,136(sp)
    53a8:	e152                	sd	s4,128(sp)
    53aa:	fcd6                	sd	s5,120(sp)
    53ac:	f8da                	sd	s6,112(sp)
    53ae:	f4de                	sd	s7,104(sp)
    53b0:	f0e2                	sd	s8,96(sp)
    53b2:	ece6                	sd	s9,88(sp)
    53b4:	e8ea                	sd	s10,80(sp)
    53b6:	e4ee                	sd	s11,72(sp)
    53b8:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53ba:	00003517          	auipc	a0,0x3
    53be:	c5e50513          	addi	a0,a0,-930 # 8018 <malloc+0x2012>
    53c2:	00001097          	auipc	ra,0x1
    53c6:	b8c080e7          	jalr	-1140(ra) # 5f4e <printf>
  for(nfiles = 0; ; nfiles++){
    53ca:	4481                	li	s1,0
    name[0] = 'f';
    53cc:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53d0:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53d4:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53d8:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53da:	00003c97          	auipc	s9,0x3
    53de:	c4ec8c93          	addi	s9,s9,-946 # 8028 <malloc+0x2022>
    int total = 0;
    53e2:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    53e4:	00008a17          	auipc	s4,0x8
    53e8:	894a0a13          	addi	s4,s4,-1900 # cc78 <buf>
    name[0] = 'f';
    53ec:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    53f0:	0384c7bb          	divw	a5,s1,s8
    53f4:	0307879b          	addiw	a5,a5,48
    53f8:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53fc:	0384e7bb          	remw	a5,s1,s8
    5400:	0377c7bb          	divw	a5,a5,s7
    5404:	0307879b          	addiw	a5,a5,48
    5408:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    540c:	0374e7bb          	remw	a5,s1,s7
    5410:	0367c7bb          	divw	a5,a5,s6
    5414:	0307879b          	addiw	a5,a5,48
    5418:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    541c:	0364e7bb          	remw	a5,s1,s6
    5420:	0307879b          	addiw	a5,a5,48
    5424:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5428:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    542c:	f5040593          	addi	a1,s0,-176
    5430:	8566                	mv	a0,s9
    5432:	00001097          	auipc	ra,0x1
    5436:	b1c080e7          	jalr	-1252(ra) # 5f4e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    543a:	20200593          	li	a1,514
    543e:	f5040513          	addi	a0,s0,-176
    5442:	00000097          	auipc	ra,0x0
    5446:	7c2080e7          	jalr	1986(ra) # 5c04 <open>
    544a:	892a                	mv	s2,a0
    if(fd < 0){
    544c:	0a055663          	bgez	a0,54f8 <fsfull+0x15c>
      printf("open %s failed\n", name);
    5450:	f5040593          	addi	a1,s0,-176
    5454:	00003517          	auipc	a0,0x3
    5458:	be450513          	addi	a0,a0,-1052 # 8038 <malloc+0x2032>
    545c:	00001097          	auipc	ra,0x1
    5460:	af2080e7          	jalr	-1294(ra) # 5f4e <printf>
  while(nfiles >= 0){
    5464:	0604c363          	bltz	s1,54ca <fsfull+0x12e>
    name[0] = 'f';
    5468:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    546c:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5470:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5474:	4929                	li	s2,10
  while(nfiles >= 0){
    5476:	5afd                	li	s5,-1
    name[0] = 'f';
    5478:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    547c:	0344c7bb          	divw	a5,s1,s4
    5480:	0307879b          	addiw	a5,a5,48
    5484:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5488:	0344e7bb          	remw	a5,s1,s4
    548c:	0337c7bb          	divw	a5,a5,s3
    5490:	0307879b          	addiw	a5,a5,48
    5494:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5498:	0334e7bb          	remw	a5,s1,s3
    549c:	0327c7bb          	divw	a5,a5,s2
    54a0:	0307879b          	addiw	a5,a5,48
    54a4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54a8:	0324e7bb          	remw	a5,s1,s2
    54ac:	0307879b          	addiw	a5,a5,48
    54b0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54b4:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54b8:	f5040513          	addi	a0,s0,-176
    54bc:	00000097          	auipc	ra,0x0
    54c0:	758080e7          	jalr	1880(ra) # 5c14 <unlink>
    nfiles--;
    54c4:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54c6:	fb5499e3          	bne	s1,s5,5478 <fsfull+0xdc>
  printf("fsfull test finished\n");
    54ca:	00003517          	auipc	a0,0x3
    54ce:	b8e50513          	addi	a0,a0,-1138 # 8058 <malloc+0x2052>
    54d2:	00001097          	auipc	ra,0x1
    54d6:	a7c080e7          	jalr	-1412(ra) # 5f4e <printf>
}
    54da:	70aa                	ld	ra,168(sp)
    54dc:	740a                	ld	s0,160(sp)
    54de:	64ea                	ld	s1,152(sp)
    54e0:	694a                	ld	s2,144(sp)
    54e2:	69aa                	ld	s3,136(sp)
    54e4:	6a0a                	ld	s4,128(sp)
    54e6:	7ae6                	ld	s5,120(sp)
    54e8:	7b46                	ld	s6,112(sp)
    54ea:	7ba6                	ld	s7,104(sp)
    54ec:	7c06                	ld	s8,96(sp)
    54ee:	6ce6                	ld	s9,88(sp)
    54f0:	6d46                	ld	s10,80(sp)
    54f2:	6da6                	ld	s11,72(sp)
    54f4:	614d                	addi	sp,sp,176
    54f6:	8082                	ret
    int total = 0;
    54f8:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    54fa:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    54fe:	40000613          	li	a2,1024
    5502:	85d2                	mv	a1,s4
    5504:	854a                	mv	a0,s2
    5506:	00000097          	auipc	ra,0x0
    550a:	6de080e7          	jalr	1758(ra) # 5be4 <write>
      if(cc < BSIZE)
    550e:	00aad563          	bge	s5,a0,5518 <fsfull+0x17c>
      total += cc;
    5512:	00a989bb          	addw	s3,s3,a0
    while(1){
    5516:	b7e5                	j	54fe <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5518:	85ce                	mv	a1,s3
    551a:	00003517          	auipc	a0,0x3
    551e:	b2e50513          	addi	a0,a0,-1234 # 8048 <malloc+0x2042>
    5522:	00001097          	auipc	ra,0x1
    5526:	a2c080e7          	jalr	-1492(ra) # 5f4e <printf>
    close(fd);
    552a:	854a                	mv	a0,s2
    552c:	00000097          	auipc	ra,0x0
    5530:	6c0080e7          	jalr	1728(ra) # 5bec <close>
    if(total == 0)
    5534:	f20988e3          	beqz	s3,5464 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5538:	2485                	addiw	s1,s1,1
    553a:	bd4d                	j	53ec <fsfull+0x50>

000000000000553c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    553c:	7179                	addi	sp,sp,-48
    553e:	f406                	sd	ra,40(sp)
    5540:	f022                	sd	s0,32(sp)
    5542:	ec26                	sd	s1,24(sp)
    5544:	e84a                	sd	s2,16(sp)
    5546:	1800                	addi	s0,sp,48
    5548:	84aa                	mv	s1,a0
    554a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554c:	00003517          	auipc	a0,0x3
    5550:	b2450513          	addi	a0,a0,-1244 # 8070 <malloc+0x206a>
    5554:	00001097          	auipc	ra,0x1
    5558:	9fa080e7          	jalr	-1542(ra) # 5f4e <printf>
  if((pid = fork()) < 0) {
    555c:	00000097          	auipc	ra,0x0
    5560:	660080e7          	jalr	1632(ra) # 5bbc <fork>
    5564:	02054e63          	bltz	a0,55a0 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5568:	c929                	beqz	a0,55ba <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    556a:	fdc40513          	addi	a0,s0,-36
    556e:	00000097          	auipc	ra,0x0
    5572:	65e080e7          	jalr	1630(ra) # 5bcc <wait>
    if(xstatus != 0) 
    5576:	fdc42783          	lw	a5,-36(s0)
    557a:	c7b9                	beqz	a5,55c8 <run+0x8c>
      printf("FAILED\n");
    557c:	00003517          	auipc	a0,0x3
    5580:	b1c50513          	addi	a0,a0,-1252 # 8098 <malloc+0x2092>
    5584:	00001097          	auipc	ra,0x1
    5588:	9ca080e7          	jalr	-1590(ra) # 5f4e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5590:	00153513          	seqz	a0,a0
    5594:	70a2                	ld	ra,40(sp)
    5596:	7402                	ld	s0,32(sp)
    5598:	64e2                	ld	s1,24(sp)
    559a:	6942                	ld	s2,16(sp)
    559c:	6145                	addi	sp,sp,48
    559e:	8082                	ret
    printf("runtest: fork error\n");
    55a0:	00003517          	auipc	a0,0x3
    55a4:	ae050513          	addi	a0,a0,-1312 # 8080 <malloc+0x207a>
    55a8:	00001097          	auipc	ra,0x1
    55ac:	9a6080e7          	jalr	-1626(ra) # 5f4e <printf>
    exit(1);
    55b0:	4505                	li	a0,1
    55b2:	00000097          	auipc	ra,0x0
    55b6:	612080e7          	jalr	1554(ra) # 5bc4 <exit>
    f(s);
    55ba:	854a                	mv	a0,s2
    55bc:	9482                	jalr	s1
    exit(0);
    55be:	4501                	li	a0,0
    55c0:	00000097          	auipc	ra,0x0
    55c4:	604080e7          	jalr	1540(ra) # 5bc4 <exit>
      printf("OK\n");
    55c8:	00003517          	auipc	a0,0x3
    55cc:	ad850513          	addi	a0,a0,-1320 # 80a0 <malloc+0x209a>
    55d0:	00001097          	auipc	ra,0x1
    55d4:	97e080e7          	jalr	-1666(ra) # 5f4e <printf>
    55d8:	bf55                	j	558c <run+0x50>

00000000000055da <runtests>:

int
runtests(struct test *tests, char *justone) {
    55da:	1101                	addi	sp,sp,-32
    55dc:	ec06                	sd	ra,24(sp)
    55de:	e822                	sd	s0,16(sp)
    55e0:	e426                	sd	s1,8(sp)
    55e2:	e04a                	sd	s2,0(sp)
    55e4:	1000                	addi	s0,sp,32
    55e6:	84aa                	mv	s1,a0
    55e8:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55ea:	6508                	ld	a0,8(a0)
    55ec:	ed09                	bnez	a0,5606 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55ee:	4501                	li	a0,0
    55f0:	a82d                	j	562a <runtests+0x50>
      if(!run(t->f, t->s)){
    55f2:	648c                	ld	a1,8(s1)
    55f4:	6088                	ld	a0,0(s1)
    55f6:	00000097          	auipc	ra,0x0
    55fa:	f46080e7          	jalr	-186(ra) # 553c <run>
    55fe:	cd09                	beqz	a0,5618 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5600:	04c1                	addi	s1,s1,16
    5602:	6488                	ld	a0,8(s1)
    5604:	c11d                	beqz	a0,562a <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5606:	fe0906e3          	beqz	s2,55f2 <runtests+0x18>
    560a:	85ca                	mv	a1,s2
    560c:	00000097          	auipc	ra,0x0
    5610:	368080e7          	jalr	872(ra) # 5974 <strcmp>
    5614:	f575                	bnez	a0,5600 <runtests+0x26>
    5616:	bff1                	j	55f2 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5618:	00003517          	auipc	a0,0x3
    561c:	a9050513          	addi	a0,a0,-1392 # 80a8 <malloc+0x20a2>
    5620:	00001097          	auipc	ra,0x1
    5624:	92e080e7          	jalr	-1746(ra) # 5f4e <printf>
        return 1;
    5628:	4505                	li	a0,1
}
    562a:	60e2                	ld	ra,24(sp)
    562c:	6442                	ld	s0,16(sp)
    562e:	64a2                	ld	s1,8(sp)
    5630:	6902                	ld	s2,0(sp)
    5632:	6105                	addi	sp,sp,32
    5634:	8082                	ret

0000000000005636 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5636:	7139                	addi	sp,sp,-64
    5638:	fc06                	sd	ra,56(sp)
    563a:	f822                	sd	s0,48(sp)
    563c:	f426                	sd	s1,40(sp)
    563e:	f04a                	sd	s2,32(sp)
    5640:	ec4e                	sd	s3,24(sp)
    5642:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5644:	fc840513          	addi	a0,s0,-56
    5648:	00000097          	auipc	ra,0x0
    564c:	58c080e7          	jalr	1420(ra) # 5bd4 <pipe>
    5650:	06054763          	bltz	a0,56be <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5654:	00000097          	auipc	ra,0x0
    5658:	568080e7          	jalr	1384(ra) # 5bbc <fork>

  if(pid < 0){
    565c:	06054e63          	bltz	a0,56d8 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5660:	ed51                	bnez	a0,56fc <countfree+0xc6>
    close(fds[0]);
    5662:	fc842503          	lw	a0,-56(s0)
    5666:	00000097          	auipc	ra,0x0
    566a:	586080e7          	jalr	1414(ra) # 5bec <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    566e:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5670:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5672:	00001997          	auipc	s3,0x1
    5676:	b2698993          	addi	s3,s3,-1242 # 6198 <malloc+0x192>
      uint64 a = (uint64) sbrk(4096);
    567a:	6505                	lui	a0,0x1
    567c:	00000097          	auipc	ra,0x0
    5680:	5d0080e7          	jalr	1488(ra) # 5c4c <sbrk>
      if(a == 0xffffffffffffffff){
    5684:	07250763          	beq	a0,s2,56f2 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5688:	6785                	lui	a5,0x1
    568a:	97aa                	add	a5,a5,a0
    568c:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5690:	8626                	mv	a2,s1
    5692:	85ce                	mv	a1,s3
    5694:	fcc42503          	lw	a0,-52(s0)
    5698:	00000097          	auipc	ra,0x0
    569c:	54c080e7          	jalr	1356(ra) # 5be4 <write>
    56a0:	fc950de3          	beq	a0,s1,567a <countfree+0x44>
        printf("write() failed in countfree()\n");
    56a4:	00003517          	auipc	a0,0x3
    56a8:	a5c50513          	addi	a0,a0,-1444 # 8100 <malloc+0x20fa>
    56ac:	00001097          	auipc	ra,0x1
    56b0:	8a2080e7          	jalr	-1886(ra) # 5f4e <printf>
        exit(1);
    56b4:	4505                	li	a0,1
    56b6:	00000097          	auipc	ra,0x0
    56ba:	50e080e7          	jalr	1294(ra) # 5bc4 <exit>
    printf("pipe() failed in countfree()\n");
    56be:	00003517          	auipc	a0,0x3
    56c2:	a0250513          	addi	a0,a0,-1534 # 80c0 <malloc+0x20ba>
    56c6:	00001097          	auipc	ra,0x1
    56ca:	888080e7          	jalr	-1912(ra) # 5f4e <printf>
    exit(1);
    56ce:	4505                	li	a0,1
    56d0:	00000097          	auipc	ra,0x0
    56d4:	4f4080e7          	jalr	1268(ra) # 5bc4 <exit>
    printf("fork failed in countfree()\n");
    56d8:	00003517          	auipc	a0,0x3
    56dc:	a0850513          	addi	a0,a0,-1528 # 80e0 <malloc+0x20da>
    56e0:	00001097          	auipc	ra,0x1
    56e4:	86e080e7          	jalr	-1938(ra) # 5f4e <printf>
    exit(1);
    56e8:	4505                	li	a0,1
    56ea:	00000097          	auipc	ra,0x0
    56ee:	4da080e7          	jalr	1242(ra) # 5bc4 <exit>
      }
    }

    exit(0);
    56f2:	4501                	li	a0,0
    56f4:	00000097          	auipc	ra,0x0
    56f8:	4d0080e7          	jalr	1232(ra) # 5bc4 <exit>
  }

  close(fds[1]);
    56fc:	fcc42503          	lw	a0,-52(s0)
    5700:	00000097          	auipc	ra,0x0
    5704:	4ec080e7          	jalr	1260(ra) # 5bec <close>

  int n = 0;
    5708:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    570a:	4605                	li	a2,1
    570c:	fc740593          	addi	a1,s0,-57
    5710:	fc842503          	lw	a0,-56(s0)
    5714:	00000097          	auipc	ra,0x0
    5718:	4c8080e7          	jalr	1224(ra) # 5bdc <read>
    if(cc < 0){
    571c:	00054563          	bltz	a0,5726 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5720:	c105                	beqz	a0,5740 <countfree+0x10a>
      break;
    n += 1;
    5722:	2485                	addiw	s1,s1,1
  while(1){
    5724:	b7dd                	j	570a <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5726:	00003517          	auipc	a0,0x3
    572a:	9fa50513          	addi	a0,a0,-1542 # 8120 <malloc+0x211a>
    572e:	00001097          	auipc	ra,0x1
    5732:	820080e7          	jalr	-2016(ra) # 5f4e <printf>
      exit(1);
    5736:	4505                	li	a0,1
    5738:	00000097          	auipc	ra,0x0
    573c:	48c080e7          	jalr	1164(ra) # 5bc4 <exit>
  }

  close(fds[0]);
    5740:	fc842503          	lw	a0,-56(s0)
    5744:	00000097          	auipc	ra,0x0
    5748:	4a8080e7          	jalr	1192(ra) # 5bec <close>
  wait((int*)0);
    574c:	4501                	li	a0,0
    574e:	00000097          	auipc	ra,0x0
    5752:	47e080e7          	jalr	1150(ra) # 5bcc <wait>
  
  return n;
}
    5756:	8526                	mv	a0,s1
    5758:	70e2                	ld	ra,56(sp)
    575a:	7442                	ld	s0,48(sp)
    575c:	74a2                	ld	s1,40(sp)
    575e:	7902                	ld	s2,32(sp)
    5760:	69e2                	ld	s3,24(sp)
    5762:	6121                	addi	sp,sp,64
    5764:	8082                	ret

0000000000005766 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5766:	711d                	addi	sp,sp,-96
    5768:	ec86                	sd	ra,88(sp)
    576a:	e8a2                	sd	s0,80(sp)
    576c:	e4a6                	sd	s1,72(sp)
    576e:	e0ca                	sd	s2,64(sp)
    5770:	fc4e                	sd	s3,56(sp)
    5772:	f852                	sd	s4,48(sp)
    5774:	f456                	sd	s5,40(sp)
    5776:	f05a                	sd	s6,32(sp)
    5778:	ec5e                	sd	s7,24(sp)
    577a:	e862                	sd	s8,16(sp)
    577c:	e466                	sd	s9,8(sp)
    577e:	e06a                	sd	s10,0(sp)
    5780:	1080                	addi	s0,sp,96
    5782:	8a2a                	mv	s4,a0
    5784:	89ae                	mv	s3,a1
    5786:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    5788:	00003b97          	auipc	s7,0x3
    578c:	9b8b8b93          	addi	s7,s7,-1608 # 8140 <malloc+0x213a>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5790:	00004b17          	auipc	s6,0x4
    5794:	880b0b13          	addi	s6,s6,-1920 # 9010 <quicktests>
      if(continuous != 2) {
    5798:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    579a:	00003c97          	auipc	s9,0x3
    579e:	9dec8c93          	addi	s9,s9,-1570 # 8178 <malloc+0x2172>
      if (runtests(slowtests, justone)) {
    57a2:	00004c17          	auipc	s8,0x4
    57a6:	c3ec0c13          	addi	s8,s8,-962 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57aa:	00003d17          	auipc	s10,0x3
    57ae:	9aed0d13          	addi	s10,s10,-1618 # 8158 <malloc+0x2152>
    57b2:	a839                	j	57d0 <drivetests+0x6a>
    57b4:	856a                	mv	a0,s10
    57b6:	00000097          	auipc	ra,0x0
    57ba:	798080e7          	jalr	1944(ra) # 5f4e <printf>
    57be:	a081                	j	57fe <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57c0:	00000097          	auipc	ra,0x0
    57c4:	e76080e7          	jalr	-394(ra) # 5636 <countfree>
    57c8:	06954263          	blt	a0,s1,582c <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57cc:	06098f63          	beqz	s3,584a <drivetests+0xe4>
    printf("usertests starting\n");
    57d0:	855e                	mv	a0,s7
    57d2:	00000097          	auipc	ra,0x0
    57d6:	77c080e7          	jalr	1916(ra) # 5f4e <printf>
    int free0 = countfree();
    57da:	00000097          	auipc	ra,0x0
    57de:	e5c080e7          	jalr	-420(ra) # 5636 <countfree>
    57e2:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57e4:	85ca                	mv	a1,s2
    57e6:	855a                	mv	a0,s6
    57e8:	00000097          	auipc	ra,0x0
    57ec:	df2080e7          	jalr	-526(ra) # 55da <runtests>
    57f0:	c119                	beqz	a0,57f6 <drivetests+0x90>
      if(continuous != 2) {
    57f2:	05599863          	bne	s3,s5,5842 <drivetests+0xdc>
    if(!quick) {
    57f6:	fc0a15e3          	bnez	s4,57c0 <drivetests+0x5a>
      if (justone == 0)
    57fa:	fa090de3          	beqz	s2,57b4 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    57fe:	85ca                	mv	a1,s2
    5800:	8562                	mv	a0,s8
    5802:	00000097          	auipc	ra,0x0
    5806:	dd8080e7          	jalr	-552(ra) # 55da <runtests>
    580a:	d95d                	beqz	a0,57c0 <drivetests+0x5a>
        if(continuous != 2) {
    580c:	03599d63          	bne	s3,s5,5846 <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    5810:	00000097          	auipc	ra,0x0
    5814:	e26080e7          	jalr	-474(ra) # 5636 <countfree>
    5818:	fa955ae3          	bge	a0,s1,57cc <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    581c:	8626                	mv	a2,s1
    581e:	85aa                	mv	a1,a0
    5820:	8566                	mv	a0,s9
    5822:	00000097          	auipc	ra,0x0
    5826:	72c080e7          	jalr	1836(ra) # 5f4e <printf>
      if(continuous != 2) {
    582a:	b75d                	j	57d0 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    582c:	8626                	mv	a2,s1
    582e:	85aa                	mv	a1,a0
    5830:	8566                	mv	a0,s9
    5832:	00000097          	auipc	ra,0x0
    5836:	71c080e7          	jalr	1820(ra) # 5f4e <printf>
      if(continuous != 2) {
    583a:	f9598be3          	beq	s3,s5,57d0 <drivetests+0x6a>
        return 1;
    583e:	4505                	li	a0,1
    5840:	a031                	j	584c <drivetests+0xe6>
        return 1;
    5842:	4505                	li	a0,1
    5844:	a021                	j	584c <drivetests+0xe6>
          return 1;
    5846:	4505                	li	a0,1
    5848:	a011                	j	584c <drivetests+0xe6>
  return 0;
    584a:	854e                	mv	a0,s3
}
    584c:	60e6                	ld	ra,88(sp)
    584e:	6446                	ld	s0,80(sp)
    5850:	64a6                	ld	s1,72(sp)
    5852:	6906                	ld	s2,64(sp)
    5854:	79e2                	ld	s3,56(sp)
    5856:	7a42                	ld	s4,48(sp)
    5858:	7aa2                	ld	s5,40(sp)
    585a:	7b02                	ld	s6,32(sp)
    585c:	6be2                	ld	s7,24(sp)
    585e:	6c42                	ld	s8,16(sp)
    5860:	6ca2                	ld	s9,8(sp)
    5862:	6d02                	ld	s10,0(sp)
    5864:	6125                	addi	sp,sp,96
    5866:	8082                	ret

0000000000005868 <main>:

int
main(int argc, char *argv[])
{
    5868:	1101                	addi	sp,sp,-32
    586a:	ec06                	sd	ra,24(sp)
    586c:	e822                	sd	s0,16(sp)
    586e:	e426                	sd	s1,8(sp)
    5870:	e04a                	sd	s2,0(sp)
    5872:	1000                	addi	s0,sp,32
    5874:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5876:	4789                	li	a5,2
    5878:	02f50263          	beq	a0,a5,589c <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    587c:	4785                	li	a5,1
    587e:	06a7cd63          	blt	a5,a0,58f8 <main+0x90>
  char *justone = 0;
    5882:	4601                	li	a2,0
  int quick = 0;
    5884:	4501                	li	a0,0
  int continuous = 0;
    5886:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5888:	00000097          	auipc	ra,0x0
    588c:	ede080e7          	jalr	-290(ra) # 5766 <drivetests>
    5890:	c951                	beqz	a0,5924 <main+0xbc>
    exit(1);
    5892:	4505                	li	a0,1
    5894:	00000097          	auipc	ra,0x0
    5898:	330080e7          	jalr	816(ra) # 5bc4 <exit>
    589c:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    589e:	00003597          	auipc	a1,0x3
    58a2:	90a58593          	addi	a1,a1,-1782 # 81a8 <malloc+0x21a2>
    58a6:	00893503          	ld	a0,8(s2)
    58aa:	00000097          	auipc	ra,0x0
    58ae:	0ca080e7          	jalr	202(ra) # 5974 <strcmp>
    58b2:	85aa                	mv	a1,a0
    58b4:	cd39                	beqz	a0,5912 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58b6:	00003597          	auipc	a1,0x3
    58ba:	94a58593          	addi	a1,a1,-1718 # 8200 <malloc+0x21fa>
    58be:	00893503          	ld	a0,8(s2)
    58c2:	00000097          	auipc	ra,0x0
    58c6:	0b2080e7          	jalr	178(ra) # 5974 <strcmp>
    58ca:	c931                	beqz	a0,591e <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58cc:	00003597          	auipc	a1,0x3
    58d0:	92c58593          	addi	a1,a1,-1748 # 81f8 <malloc+0x21f2>
    58d4:	00893503          	ld	a0,8(s2)
    58d8:	00000097          	auipc	ra,0x0
    58dc:	09c080e7          	jalr	156(ra) # 5974 <strcmp>
    58e0:	cd05                	beqz	a0,5918 <main+0xb0>
  } else if(argc == 2 && argv[1][0] != '-'){
    58e2:	00893603          	ld	a2,8(s2)
    58e6:	00064703          	lbu	a4,0(a2) # 3000 <execout+0xa4>
    58ea:	02d00793          	li	a5,45
    58ee:	00f70563          	beq	a4,a5,58f8 <main+0x90>
  int quick = 0;
    58f2:	4501                	li	a0,0
  int continuous = 0;
    58f4:	4581                	li	a1,0
    58f6:	bf49                	j	5888 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58f8:	00003517          	auipc	a0,0x3
    58fc:	8b850513          	addi	a0,a0,-1864 # 81b0 <malloc+0x21aa>
    5900:	00000097          	auipc	ra,0x0
    5904:	64e080e7          	jalr	1614(ra) # 5f4e <printf>
    exit(1);
    5908:	4505                	li	a0,1
    590a:	00000097          	auipc	ra,0x0
    590e:	2ba080e7          	jalr	698(ra) # 5bc4 <exit>
  char *justone = 0;
    5912:	4601                	li	a2,0
    quick = 1;
    5914:	4505                	li	a0,1
    5916:	bf8d                	j	5888 <main+0x20>
    continuous = 2;
    5918:	85a6                	mv	a1,s1
  char *justone = 0;
    591a:	4601                	li	a2,0
    591c:	b7b5                	j	5888 <main+0x20>
    591e:	4601                	li	a2,0
    continuous = 1;
    5920:	4585                	li	a1,1
    5922:	b79d                	j	5888 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5924:	00003517          	auipc	a0,0x3
    5928:	8bc50513          	addi	a0,a0,-1860 # 81e0 <malloc+0x21da>
    592c:	00000097          	auipc	ra,0x0
    5930:	622080e7          	jalr	1570(ra) # 5f4e <printf>
  exit(0);
    5934:	4501                	li	a0,0
    5936:	00000097          	auipc	ra,0x0
    593a:	28e080e7          	jalr	654(ra) # 5bc4 <exit>

000000000000593e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    593e:	1141                	addi	sp,sp,-16
    5940:	e406                	sd	ra,8(sp)
    5942:	e022                	sd	s0,0(sp)
    5944:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5946:	00000097          	auipc	ra,0x0
    594a:	f22080e7          	jalr	-222(ra) # 5868 <main>
  exit(0);
    594e:	4501                	li	a0,0
    5950:	00000097          	auipc	ra,0x0
    5954:	274080e7          	jalr	628(ra) # 5bc4 <exit>

0000000000005958 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5958:	1141                	addi	sp,sp,-16
    595a:	e422                	sd	s0,8(sp)
    595c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    595e:	87aa                	mv	a5,a0
    5960:	0585                	addi	a1,a1,1
    5962:	0785                	addi	a5,a5,1
    5964:	fff5c703          	lbu	a4,-1(a1)
    5968:	fee78fa3          	sb	a4,-1(a5)
    596c:	fb75                	bnez	a4,5960 <strcpy+0x8>
    ;
  return os;
}
    596e:	6422                	ld	s0,8(sp)
    5970:	0141                	addi	sp,sp,16
    5972:	8082                	ret

0000000000005974 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5974:	1141                	addi	sp,sp,-16
    5976:	e422                	sd	s0,8(sp)
    5978:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    597a:	00054783          	lbu	a5,0(a0)
    597e:	cb91                	beqz	a5,5992 <strcmp+0x1e>
    5980:	0005c703          	lbu	a4,0(a1)
    5984:	00f71763          	bne	a4,a5,5992 <strcmp+0x1e>
    p++, q++;
    5988:	0505                	addi	a0,a0,1
    598a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    598c:	00054783          	lbu	a5,0(a0)
    5990:	fbe5                	bnez	a5,5980 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5992:	0005c503          	lbu	a0,0(a1)
}
    5996:	40a7853b          	subw	a0,a5,a0
    599a:	6422                	ld	s0,8(sp)
    599c:	0141                	addi	sp,sp,16
    599e:	8082                	ret

00000000000059a0 <strlen>:

uint
strlen(const char *s)
{
    59a0:	1141                	addi	sp,sp,-16
    59a2:	e422                	sd	s0,8(sp)
    59a4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59a6:	00054783          	lbu	a5,0(a0)
    59aa:	cf91                	beqz	a5,59c6 <strlen+0x26>
    59ac:	0505                	addi	a0,a0,1
    59ae:	87aa                	mv	a5,a0
    59b0:	4685                	li	a3,1
    59b2:	9e89                	subw	a3,a3,a0
    59b4:	00f6853b          	addw	a0,a3,a5
    59b8:	0785                	addi	a5,a5,1
    59ba:	fff7c703          	lbu	a4,-1(a5)
    59be:	fb7d                	bnez	a4,59b4 <strlen+0x14>
    ;
  return n;
}
    59c0:	6422                	ld	s0,8(sp)
    59c2:	0141                	addi	sp,sp,16
    59c4:	8082                	ret
  for(n = 0; s[n]; n++)
    59c6:	4501                	li	a0,0
    59c8:	bfe5                	j	59c0 <strlen+0x20>

00000000000059ca <memset>:

void*
memset(void *dst, int c, uint n)
{
    59ca:	1141                	addi	sp,sp,-16
    59cc:	e422                	sd	s0,8(sp)
    59ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59d0:	ca19                	beqz	a2,59e6 <memset+0x1c>
    59d2:	87aa                	mv	a5,a0
    59d4:	1602                	slli	a2,a2,0x20
    59d6:	9201                	srli	a2,a2,0x20
    59d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59e0:	0785                	addi	a5,a5,1
    59e2:	fee79de3          	bne	a5,a4,59dc <memset+0x12>
  }
  return dst;
}
    59e6:	6422                	ld	s0,8(sp)
    59e8:	0141                	addi	sp,sp,16
    59ea:	8082                	ret

00000000000059ec <strchr>:

char*
strchr(const char *s, char c)
{
    59ec:	1141                	addi	sp,sp,-16
    59ee:	e422                	sd	s0,8(sp)
    59f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59f2:	00054783          	lbu	a5,0(a0)
    59f6:	cb99                	beqz	a5,5a0c <strchr+0x20>
    if(*s == c)
    59f8:	00f58763          	beq	a1,a5,5a06 <strchr+0x1a>
  for(; *s; s++)
    59fc:	0505                	addi	a0,a0,1
    59fe:	00054783          	lbu	a5,0(a0)
    5a02:	fbfd                	bnez	a5,59f8 <strchr+0xc>
      return (char*)s;
  return 0;
    5a04:	4501                	li	a0,0
}
    5a06:	6422                	ld	s0,8(sp)
    5a08:	0141                	addi	sp,sp,16
    5a0a:	8082                	ret
  return 0;
    5a0c:	4501                	li	a0,0
    5a0e:	bfe5                	j	5a06 <strchr+0x1a>

0000000000005a10 <gets>:

char*
gets(char *buf, int max)
{
    5a10:	711d                	addi	sp,sp,-96
    5a12:	ec86                	sd	ra,88(sp)
    5a14:	e8a2                	sd	s0,80(sp)
    5a16:	e4a6                	sd	s1,72(sp)
    5a18:	e0ca                	sd	s2,64(sp)
    5a1a:	fc4e                	sd	s3,56(sp)
    5a1c:	f852                	sd	s4,48(sp)
    5a1e:	f456                	sd	s5,40(sp)
    5a20:	f05a                	sd	s6,32(sp)
    5a22:	ec5e                	sd	s7,24(sp)
    5a24:	1080                	addi	s0,sp,96
    5a26:	8baa                	mv	s7,a0
    5a28:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a2a:	892a                	mv	s2,a0
    5a2c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a2e:	4aa9                	li	s5,10
    5a30:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a32:	89a6                	mv	s3,s1
    5a34:	2485                	addiw	s1,s1,1
    5a36:	0344d863          	bge	s1,s4,5a66 <gets+0x56>
    cc = read(0, &c, 1);
    5a3a:	4605                	li	a2,1
    5a3c:	faf40593          	addi	a1,s0,-81
    5a40:	4501                	li	a0,0
    5a42:	00000097          	auipc	ra,0x0
    5a46:	19a080e7          	jalr	410(ra) # 5bdc <read>
    if(cc < 1)
    5a4a:	00a05e63          	blez	a0,5a66 <gets+0x56>
    buf[i++] = c;
    5a4e:	faf44783          	lbu	a5,-81(s0)
    5a52:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a56:	01578763          	beq	a5,s5,5a64 <gets+0x54>
    5a5a:	0905                	addi	s2,s2,1
    5a5c:	fd679be3          	bne	a5,s6,5a32 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a60:	89a6                	mv	s3,s1
    5a62:	a011                	j	5a66 <gets+0x56>
    5a64:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a66:	99de                	add	s3,s3,s7
    5a68:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a6c:	855e                	mv	a0,s7
    5a6e:	60e6                	ld	ra,88(sp)
    5a70:	6446                	ld	s0,80(sp)
    5a72:	64a6                	ld	s1,72(sp)
    5a74:	6906                	ld	s2,64(sp)
    5a76:	79e2                	ld	s3,56(sp)
    5a78:	7a42                	ld	s4,48(sp)
    5a7a:	7aa2                	ld	s5,40(sp)
    5a7c:	7b02                	ld	s6,32(sp)
    5a7e:	6be2                	ld	s7,24(sp)
    5a80:	6125                	addi	sp,sp,96
    5a82:	8082                	ret

0000000000005a84 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a84:	1101                	addi	sp,sp,-32
    5a86:	ec06                	sd	ra,24(sp)
    5a88:	e822                	sd	s0,16(sp)
    5a8a:	e426                	sd	s1,8(sp)
    5a8c:	e04a                	sd	s2,0(sp)
    5a8e:	1000                	addi	s0,sp,32
    5a90:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a92:	4581                	li	a1,0
    5a94:	00000097          	auipc	ra,0x0
    5a98:	170080e7          	jalr	368(ra) # 5c04 <open>
  if(fd < 0)
    5a9c:	02054563          	bltz	a0,5ac6 <stat+0x42>
    5aa0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5aa2:	85ca                	mv	a1,s2
    5aa4:	00000097          	auipc	ra,0x0
    5aa8:	178080e7          	jalr	376(ra) # 5c1c <fstat>
    5aac:	892a                	mv	s2,a0
  close(fd);
    5aae:	8526                	mv	a0,s1
    5ab0:	00000097          	auipc	ra,0x0
    5ab4:	13c080e7          	jalr	316(ra) # 5bec <close>
  return r;
}
    5ab8:	854a                	mv	a0,s2
    5aba:	60e2                	ld	ra,24(sp)
    5abc:	6442                	ld	s0,16(sp)
    5abe:	64a2                	ld	s1,8(sp)
    5ac0:	6902                	ld	s2,0(sp)
    5ac2:	6105                	addi	sp,sp,32
    5ac4:	8082                	ret
    return -1;
    5ac6:	597d                	li	s2,-1
    5ac8:	bfc5                	j	5ab8 <stat+0x34>

0000000000005aca <atoi>:

int
atoi(const char *s)
{
    5aca:	1141                	addi	sp,sp,-16
    5acc:	e422                	sd	s0,8(sp)
    5ace:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ad0:	00054683          	lbu	a3,0(a0)
    5ad4:	fd06879b          	addiw	a5,a3,-48
    5ad8:	0ff7f793          	zext.b	a5,a5
    5adc:	4625                	li	a2,9
    5ade:	02f66863          	bltu	a2,a5,5b0e <atoi+0x44>
    5ae2:	872a                	mv	a4,a0
  n = 0;
    5ae4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ae6:	0705                	addi	a4,a4,1
    5ae8:	0025179b          	slliw	a5,a0,0x2
    5aec:	9fa9                	addw	a5,a5,a0
    5aee:	0017979b          	slliw	a5,a5,0x1
    5af2:	9fb5                	addw	a5,a5,a3
    5af4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5af8:	00074683          	lbu	a3,0(a4)
    5afc:	fd06879b          	addiw	a5,a3,-48
    5b00:	0ff7f793          	zext.b	a5,a5
    5b04:	fef671e3          	bgeu	a2,a5,5ae6 <atoi+0x1c>
  return n;
}
    5b08:	6422                	ld	s0,8(sp)
    5b0a:	0141                	addi	sp,sp,16
    5b0c:	8082                	ret
  n = 0;
    5b0e:	4501                	li	a0,0
    5b10:	bfe5                	j	5b08 <atoi+0x3e>

0000000000005b12 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b12:	1141                	addi	sp,sp,-16
    5b14:	e422                	sd	s0,8(sp)
    5b16:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b18:	02b57463          	bgeu	a0,a1,5b40 <memmove+0x2e>
    while(n-- > 0)
    5b1c:	00c05f63          	blez	a2,5b3a <memmove+0x28>
    5b20:	1602                	slli	a2,a2,0x20
    5b22:	9201                	srli	a2,a2,0x20
    5b24:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b28:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b2a:	0585                	addi	a1,a1,1
    5b2c:	0705                	addi	a4,a4,1
    5b2e:	fff5c683          	lbu	a3,-1(a1)
    5b32:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b36:	fee79ae3          	bne	a5,a4,5b2a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b3a:	6422                	ld	s0,8(sp)
    5b3c:	0141                	addi	sp,sp,16
    5b3e:	8082                	ret
    dst += n;
    5b40:	00c50733          	add	a4,a0,a2
    src += n;
    5b44:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b46:	fec05ae3          	blez	a2,5b3a <memmove+0x28>
    5b4a:	fff6079b          	addiw	a5,a2,-1
    5b4e:	1782                	slli	a5,a5,0x20
    5b50:	9381                	srli	a5,a5,0x20
    5b52:	fff7c793          	not	a5,a5
    5b56:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b58:	15fd                	addi	a1,a1,-1
    5b5a:	177d                	addi	a4,a4,-1
    5b5c:	0005c683          	lbu	a3,0(a1)
    5b60:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b64:	fee79ae3          	bne	a5,a4,5b58 <memmove+0x46>
    5b68:	bfc9                	j	5b3a <memmove+0x28>

0000000000005b6a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b6a:	1141                	addi	sp,sp,-16
    5b6c:	e422                	sd	s0,8(sp)
    5b6e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b70:	ca05                	beqz	a2,5ba0 <memcmp+0x36>
    5b72:	fff6069b          	addiw	a3,a2,-1
    5b76:	1682                	slli	a3,a3,0x20
    5b78:	9281                	srli	a3,a3,0x20
    5b7a:	0685                	addi	a3,a3,1
    5b7c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b7e:	00054783          	lbu	a5,0(a0)
    5b82:	0005c703          	lbu	a4,0(a1)
    5b86:	00e79863          	bne	a5,a4,5b96 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b8a:	0505                	addi	a0,a0,1
    p2++;
    5b8c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b8e:	fed518e3          	bne	a0,a3,5b7e <memcmp+0x14>
  }
  return 0;
    5b92:	4501                	li	a0,0
    5b94:	a019                	j	5b9a <memcmp+0x30>
      return *p1 - *p2;
    5b96:	40e7853b          	subw	a0,a5,a4
}
    5b9a:	6422                	ld	s0,8(sp)
    5b9c:	0141                	addi	sp,sp,16
    5b9e:	8082                	ret
  return 0;
    5ba0:	4501                	li	a0,0
    5ba2:	bfe5                	j	5b9a <memcmp+0x30>

0000000000005ba4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5ba4:	1141                	addi	sp,sp,-16
    5ba6:	e406                	sd	ra,8(sp)
    5ba8:	e022                	sd	s0,0(sp)
    5baa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bac:	00000097          	auipc	ra,0x0
    5bb0:	f66080e7          	jalr	-154(ra) # 5b12 <memmove>
}
    5bb4:	60a2                	ld	ra,8(sp)
    5bb6:	6402                	ld	s0,0(sp)
    5bb8:	0141                	addi	sp,sp,16
    5bba:	8082                	ret

0000000000005bbc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bbc:	4885                	li	a7,1
 ecall
    5bbe:	00000073          	ecall
 ret
    5bc2:	8082                	ret

0000000000005bc4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bc4:	4889                	li	a7,2
 ecall
    5bc6:	00000073          	ecall
 ret
    5bca:	8082                	ret

0000000000005bcc <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bcc:	488d                	li	a7,3
 ecall
    5bce:	00000073          	ecall
 ret
    5bd2:	8082                	ret

0000000000005bd4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bd4:	4891                	li	a7,4
 ecall
    5bd6:	00000073          	ecall
 ret
    5bda:	8082                	ret

0000000000005bdc <read>:
.global read
read:
 li a7, SYS_read
    5bdc:	4895                	li	a7,5
 ecall
    5bde:	00000073          	ecall
 ret
    5be2:	8082                	ret

0000000000005be4 <write>:
.global write
write:
 li a7, SYS_write
    5be4:	48c1                	li	a7,16
 ecall
    5be6:	00000073          	ecall
 ret
    5bea:	8082                	ret

0000000000005bec <close>:
.global close
close:
 li a7, SYS_close
    5bec:	48d5                	li	a7,21
 ecall
    5bee:	00000073          	ecall
 ret
    5bf2:	8082                	ret

0000000000005bf4 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bf4:	4899                	li	a7,6
 ecall
    5bf6:	00000073          	ecall
 ret
    5bfa:	8082                	ret

0000000000005bfc <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bfc:	489d                	li	a7,7
 ecall
    5bfe:	00000073          	ecall
 ret
    5c02:	8082                	ret

0000000000005c04 <open>:
.global open
open:
 li a7, SYS_open
    5c04:	48bd                	li	a7,15
 ecall
    5c06:	00000073          	ecall
 ret
    5c0a:	8082                	ret

0000000000005c0c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c0c:	48c5                	li	a7,17
 ecall
    5c0e:	00000073          	ecall
 ret
    5c12:	8082                	ret

0000000000005c14 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c14:	48c9                	li	a7,18
 ecall
    5c16:	00000073          	ecall
 ret
    5c1a:	8082                	ret

0000000000005c1c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c1c:	48a1                	li	a7,8
 ecall
    5c1e:	00000073          	ecall
 ret
    5c22:	8082                	ret

0000000000005c24 <link>:
.global link
link:
 li a7, SYS_link
    5c24:	48cd                	li	a7,19
 ecall
    5c26:	00000073          	ecall
 ret
    5c2a:	8082                	ret

0000000000005c2c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c2c:	48d1                	li	a7,20
 ecall
    5c2e:	00000073          	ecall
 ret
    5c32:	8082                	ret

0000000000005c34 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c34:	48a5                	li	a7,9
 ecall
    5c36:	00000073          	ecall
 ret
    5c3a:	8082                	ret

0000000000005c3c <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c3c:	48a9                	li	a7,10
 ecall
    5c3e:	00000073          	ecall
 ret
    5c42:	8082                	ret

0000000000005c44 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c44:	48ad                	li	a7,11
 ecall
    5c46:	00000073          	ecall
 ret
    5c4a:	8082                	ret

0000000000005c4c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c4c:	48b1                	li	a7,12
 ecall
    5c4e:	00000073          	ecall
 ret
    5c52:	8082                	ret

0000000000005c54 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c54:	48b5                	li	a7,13
 ecall
    5c56:	00000073          	ecall
 ret
    5c5a:	8082                	ret

0000000000005c5c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c5c:	48b9                	li	a7,14
 ecall
    5c5e:	00000073          	ecall
 ret
    5c62:	8082                	ret

0000000000005c64 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
    5c64:	48d9                	li	a7,22
 ecall
    5c66:	00000073          	ecall
 ret
    5c6a:	8082                	ret

0000000000005c6c <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
    5c6c:	48dd                	li	a7,23
 ecall
    5c6e:	00000073          	ecall
 ret
    5c72:	8082                	ret

0000000000005c74 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c74:	1101                	addi	sp,sp,-32
    5c76:	ec06                	sd	ra,24(sp)
    5c78:	e822                	sd	s0,16(sp)
    5c7a:	1000                	addi	s0,sp,32
    5c7c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c80:	4605                	li	a2,1
    5c82:	fef40593          	addi	a1,s0,-17
    5c86:	00000097          	auipc	ra,0x0
    5c8a:	f5e080e7          	jalr	-162(ra) # 5be4 <write>
}
    5c8e:	60e2                	ld	ra,24(sp)
    5c90:	6442                	ld	s0,16(sp)
    5c92:	6105                	addi	sp,sp,32
    5c94:	8082                	ret

0000000000005c96 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c96:	7139                	addi	sp,sp,-64
    5c98:	fc06                	sd	ra,56(sp)
    5c9a:	f822                	sd	s0,48(sp)
    5c9c:	f426                	sd	s1,40(sp)
    5c9e:	f04a                	sd	s2,32(sp)
    5ca0:	ec4e                	sd	s3,24(sp)
    5ca2:	0080                	addi	s0,sp,64
    5ca4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5ca6:	c299                	beqz	a3,5cac <printint+0x16>
    5ca8:	0805c963          	bltz	a1,5d3a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cac:	2581                	sext.w	a1,a1
  neg = 0;
    5cae:	4881                	li	a7,0
    5cb0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cb4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cb6:	2601                	sext.w	a2,a2
    5cb8:	00003517          	auipc	a0,0x3
    5cbc:	91050513          	addi	a0,a0,-1776 # 85c8 <digits>
    5cc0:	883a                	mv	a6,a4
    5cc2:	2705                	addiw	a4,a4,1
    5cc4:	02c5f7bb          	remuw	a5,a1,a2
    5cc8:	1782                	slli	a5,a5,0x20
    5cca:	9381                	srli	a5,a5,0x20
    5ccc:	97aa                	add	a5,a5,a0
    5cce:	0007c783          	lbu	a5,0(a5)
    5cd2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cd6:	0005879b          	sext.w	a5,a1
    5cda:	02c5d5bb          	divuw	a1,a1,a2
    5cde:	0685                	addi	a3,a3,1
    5ce0:	fec7f0e3          	bgeu	a5,a2,5cc0 <printint+0x2a>
  if(neg)
    5ce4:	00088c63          	beqz	a7,5cfc <printint+0x66>
    buf[i++] = '-';
    5ce8:	fd070793          	addi	a5,a4,-48
    5cec:	00878733          	add	a4,a5,s0
    5cf0:	02d00793          	li	a5,45
    5cf4:	fef70823          	sb	a5,-16(a4)
    5cf8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5cfc:	02e05863          	blez	a4,5d2c <printint+0x96>
    5d00:	fc040793          	addi	a5,s0,-64
    5d04:	00e78933          	add	s2,a5,a4
    5d08:	fff78993          	addi	s3,a5,-1
    5d0c:	99ba                	add	s3,s3,a4
    5d0e:	377d                	addiw	a4,a4,-1
    5d10:	1702                	slli	a4,a4,0x20
    5d12:	9301                	srli	a4,a4,0x20
    5d14:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d18:	fff94583          	lbu	a1,-1(s2)
    5d1c:	8526                	mv	a0,s1
    5d1e:	00000097          	auipc	ra,0x0
    5d22:	f56080e7          	jalr	-170(ra) # 5c74 <putc>
  while(--i >= 0)
    5d26:	197d                	addi	s2,s2,-1
    5d28:	ff3918e3          	bne	s2,s3,5d18 <printint+0x82>
}
    5d2c:	70e2                	ld	ra,56(sp)
    5d2e:	7442                	ld	s0,48(sp)
    5d30:	74a2                	ld	s1,40(sp)
    5d32:	7902                	ld	s2,32(sp)
    5d34:	69e2                	ld	s3,24(sp)
    5d36:	6121                	addi	sp,sp,64
    5d38:	8082                	ret
    x = -xx;
    5d3a:	40b005bb          	negw	a1,a1
    neg = 1;
    5d3e:	4885                	li	a7,1
    x = -xx;
    5d40:	bf85                	j	5cb0 <printint+0x1a>

0000000000005d42 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d42:	7119                	addi	sp,sp,-128
    5d44:	fc86                	sd	ra,120(sp)
    5d46:	f8a2                	sd	s0,112(sp)
    5d48:	f4a6                	sd	s1,104(sp)
    5d4a:	f0ca                	sd	s2,96(sp)
    5d4c:	ecce                	sd	s3,88(sp)
    5d4e:	e8d2                	sd	s4,80(sp)
    5d50:	e4d6                	sd	s5,72(sp)
    5d52:	e0da                	sd	s6,64(sp)
    5d54:	fc5e                	sd	s7,56(sp)
    5d56:	f862                	sd	s8,48(sp)
    5d58:	f466                	sd	s9,40(sp)
    5d5a:	f06a                	sd	s10,32(sp)
    5d5c:	ec6e                	sd	s11,24(sp)
    5d5e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d60:	0005c903          	lbu	s2,0(a1)
    5d64:	18090f63          	beqz	s2,5f02 <vprintf+0x1c0>
    5d68:	8aaa                	mv	s5,a0
    5d6a:	8b32                	mv	s6,a2
    5d6c:	00158493          	addi	s1,a1,1
  state = 0;
    5d70:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d72:	02500a13          	li	s4,37
    5d76:	4c55                	li	s8,21
    5d78:	00002c97          	auipc	s9,0x2
    5d7c:	7f8c8c93          	addi	s9,s9,2040 # 8570 <malloc+0x256a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    5d80:	02800d93          	li	s11,40
  putc(fd, 'x');
    5d84:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d86:	00003b97          	auipc	s7,0x3
    5d8a:	842b8b93          	addi	s7,s7,-1982 # 85c8 <digits>
    5d8e:	a839                	j	5dac <vprintf+0x6a>
        putc(fd, c);
    5d90:	85ca                	mv	a1,s2
    5d92:	8556                	mv	a0,s5
    5d94:	00000097          	auipc	ra,0x0
    5d98:	ee0080e7          	jalr	-288(ra) # 5c74 <putc>
    5d9c:	a019                	j	5da2 <vprintf+0x60>
    } else if(state == '%'){
    5d9e:	01498d63          	beq	s3,s4,5db8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5da2:	0485                	addi	s1,s1,1
    5da4:	fff4c903          	lbu	s2,-1(s1)
    5da8:	14090d63          	beqz	s2,5f02 <vprintf+0x1c0>
    if(state == 0){
    5dac:	fe0999e3          	bnez	s3,5d9e <vprintf+0x5c>
      if(c == '%'){
    5db0:	ff4910e3          	bne	s2,s4,5d90 <vprintf+0x4e>
        state = '%';
    5db4:	89d2                	mv	s3,s4
    5db6:	b7f5                	j	5da2 <vprintf+0x60>
      if(c == 'd'){
    5db8:	11490c63          	beq	s2,s4,5ed0 <vprintf+0x18e>
    5dbc:	f9d9079b          	addiw	a5,s2,-99
    5dc0:	0ff7f793          	zext.b	a5,a5
    5dc4:	10fc6e63          	bltu	s8,a5,5ee0 <vprintf+0x19e>
    5dc8:	f9d9079b          	addiw	a5,s2,-99
    5dcc:	0ff7f713          	zext.b	a4,a5
    5dd0:	10ec6863          	bltu	s8,a4,5ee0 <vprintf+0x19e>
    5dd4:	00271793          	slli	a5,a4,0x2
    5dd8:	97e6                	add	a5,a5,s9
    5dda:	439c                	lw	a5,0(a5)
    5ddc:	97e6                	add	a5,a5,s9
    5dde:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5de0:	008b0913          	addi	s2,s6,8
    5de4:	4685                	li	a3,1
    5de6:	4629                	li	a2,10
    5de8:	000b2583          	lw	a1,0(s6)
    5dec:	8556                	mv	a0,s5
    5dee:	00000097          	auipc	ra,0x0
    5df2:	ea8080e7          	jalr	-344(ra) # 5c96 <printint>
    5df6:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5df8:	4981                	li	s3,0
    5dfa:	b765                	j	5da2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dfc:	008b0913          	addi	s2,s6,8
    5e00:	4681                	li	a3,0
    5e02:	4629                	li	a2,10
    5e04:	000b2583          	lw	a1,0(s6)
    5e08:	8556                	mv	a0,s5
    5e0a:	00000097          	auipc	ra,0x0
    5e0e:	e8c080e7          	jalr	-372(ra) # 5c96 <printint>
    5e12:	8b4a                	mv	s6,s2
      state = 0;
    5e14:	4981                	li	s3,0
    5e16:	b771                	j	5da2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e18:	008b0913          	addi	s2,s6,8
    5e1c:	4681                	li	a3,0
    5e1e:	866a                	mv	a2,s10
    5e20:	000b2583          	lw	a1,0(s6)
    5e24:	8556                	mv	a0,s5
    5e26:	00000097          	auipc	ra,0x0
    5e2a:	e70080e7          	jalr	-400(ra) # 5c96 <printint>
    5e2e:	8b4a                	mv	s6,s2
      state = 0;
    5e30:	4981                	li	s3,0
    5e32:	bf85                	j	5da2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e34:	008b0793          	addi	a5,s6,8
    5e38:	f8f43423          	sd	a5,-120(s0)
    5e3c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e40:	03000593          	li	a1,48
    5e44:	8556                	mv	a0,s5
    5e46:	00000097          	auipc	ra,0x0
    5e4a:	e2e080e7          	jalr	-466(ra) # 5c74 <putc>
  putc(fd, 'x');
    5e4e:	07800593          	li	a1,120
    5e52:	8556                	mv	a0,s5
    5e54:	00000097          	auipc	ra,0x0
    5e58:	e20080e7          	jalr	-480(ra) # 5c74 <putc>
    5e5c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e5e:	03c9d793          	srli	a5,s3,0x3c
    5e62:	97de                	add	a5,a5,s7
    5e64:	0007c583          	lbu	a1,0(a5)
    5e68:	8556                	mv	a0,s5
    5e6a:	00000097          	auipc	ra,0x0
    5e6e:	e0a080e7          	jalr	-502(ra) # 5c74 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e72:	0992                	slli	s3,s3,0x4
    5e74:	397d                	addiw	s2,s2,-1
    5e76:	fe0914e3          	bnez	s2,5e5e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5e7a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5e7e:	4981                	li	s3,0
    5e80:	b70d                	j	5da2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5e82:	008b0913          	addi	s2,s6,8
    5e86:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5e8a:	02098163          	beqz	s3,5eac <vprintf+0x16a>
        while(*s != 0){
    5e8e:	0009c583          	lbu	a1,0(s3)
    5e92:	c5ad                	beqz	a1,5efc <vprintf+0x1ba>
          putc(fd, *s);
    5e94:	8556                	mv	a0,s5
    5e96:	00000097          	auipc	ra,0x0
    5e9a:	dde080e7          	jalr	-546(ra) # 5c74 <putc>
          s++;
    5e9e:	0985                	addi	s3,s3,1
        while(*s != 0){
    5ea0:	0009c583          	lbu	a1,0(s3)
    5ea4:	f9e5                	bnez	a1,5e94 <vprintf+0x152>
        s = va_arg(ap, char*);
    5ea6:	8b4a                	mv	s6,s2
      state = 0;
    5ea8:	4981                	li	s3,0
    5eaa:	bde5                	j	5da2 <vprintf+0x60>
          s = "(null)";
    5eac:	00002997          	auipc	s3,0x2
    5eb0:	6bc98993          	addi	s3,s3,1724 # 8568 <malloc+0x2562>
        while(*s != 0){
    5eb4:	85ee                	mv	a1,s11
    5eb6:	bff9                	j	5e94 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5eb8:	008b0913          	addi	s2,s6,8
    5ebc:	000b4583          	lbu	a1,0(s6)
    5ec0:	8556                	mv	a0,s5
    5ec2:	00000097          	auipc	ra,0x0
    5ec6:	db2080e7          	jalr	-590(ra) # 5c74 <putc>
    5eca:	8b4a                	mv	s6,s2
      state = 0;
    5ecc:	4981                	li	s3,0
    5ece:	bdd1                	j	5da2 <vprintf+0x60>
        putc(fd, c);
    5ed0:	85d2                	mv	a1,s4
    5ed2:	8556                	mv	a0,s5
    5ed4:	00000097          	auipc	ra,0x0
    5ed8:	da0080e7          	jalr	-608(ra) # 5c74 <putc>
      state = 0;
    5edc:	4981                	li	s3,0
    5ede:	b5d1                	j	5da2 <vprintf+0x60>
        putc(fd, '%');
    5ee0:	85d2                	mv	a1,s4
    5ee2:	8556                	mv	a0,s5
    5ee4:	00000097          	auipc	ra,0x0
    5ee8:	d90080e7          	jalr	-624(ra) # 5c74 <putc>
        putc(fd, c);
    5eec:	85ca                	mv	a1,s2
    5eee:	8556                	mv	a0,s5
    5ef0:	00000097          	auipc	ra,0x0
    5ef4:	d84080e7          	jalr	-636(ra) # 5c74 <putc>
      state = 0;
    5ef8:	4981                	li	s3,0
    5efa:	b565                	j	5da2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5efc:	8b4a                	mv	s6,s2
      state = 0;
    5efe:	4981                	li	s3,0
    5f00:	b54d                	j	5da2 <vprintf+0x60>
    }
  }
}
    5f02:	70e6                	ld	ra,120(sp)
    5f04:	7446                	ld	s0,112(sp)
    5f06:	74a6                	ld	s1,104(sp)
    5f08:	7906                	ld	s2,96(sp)
    5f0a:	69e6                	ld	s3,88(sp)
    5f0c:	6a46                	ld	s4,80(sp)
    5f0e:	6aa6                	ld	s5,72(sp)
    5f10:	6b06                	ld	s6,64(sp)
    5f12:	7be2                	ld	s7,56(sp)
    5f14:	7c42                	ld	s8,48(sp)
    5f16:	7ca2                	ld	s9,40(sp)
    5f18:	7d02                	ld	s10,32(sp)
    5f1a:	6de2                	ld	s11,24(sp)
    5f1c:	6109                	addi	sp,sp,128
    5f1e:	8082                	ret

0000000000005f20 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f20:	715d                	addi	sp,sp,-80
    5f22:	ec06                	sd	ra,24(sp)
    5f24:	e822                	sd	s0,16(sp)
    5f26:	1000                	addi	s0,sp,32
    5f28:	e010                	sd	a2,0(s0)
    5f2a:	e414                	sd	a3,8(s0)
    5f2c:	e818                	sd	a4,16(s0)
    5f2e:	ec1c                	sd	a5,24(s0)
    5f30:	03043023          	sd	a6,32(s0)
    5f34:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f38:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f3c:	8622                	mv	a2,s0
    5f3e:	00000097          	auipc	ra,0x0
    5f42:	e04080e7          	jalr	-508(ra) # 5d42 <vprintf>
}
    5f46:	60e2                	ld	ra,24(sp)
    5f48:	6442                	ld	s0,16(sp)
    5f4a:	6161                	addi	sp,sp,80
    5f4c:	8082                	ret

0000000000005f4e <printf>:

void
printf(const char *fmt, ...)
{
    5f4e:	711d                	addi	sp,sp,-96
    5f50:	ec06                	sd	ra,24(sp)
    5f52:	e822                	sd	s0,16(sp)
    5f54:	1000                	addi	s0,sp,32
    5f56:	e40c                	sd	a1,8(s0)
    5f58:	e810                	sd	a2,16(s0)
    5f5a:	ec14                	sd	a3,24(s0)
    5f5c:	f018                	sd	a4,32(s0)
    5f5e:	f41c                	sd	a5,40(s0)
    5f60:	03043823          	sd	a6,48(s0)
    5f64:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f68:	00840613          	addi	a2,s0,8
    5f6c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f70:	85aa                	mv	a1,a0
    5f72:	4505                	li	a0,1
    5f74:	00000097          	auipc	ra,0x0
    5f78:	dce080e7          	jalr	-562(ra) # 5d42 <vprintf>
}
    5f7c:	60e2                	ld	ra,24(sp)
    5f7e:	6442                	ld	s0,16(sp)
    5f80:	6125                	addi	sp,sp,96
    5f82:	8082                	ret

0000000000005f84 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f84:	1141                	addi	sp,sp,-16
    5f86:	e422                	sd	s0,8(sp)
    5f88:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f8a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f8e:	00003797          	auipc	a5,0x3
    5f92:	4c27b783          	ld	a5,1218(a5) # 9450 <freep>
    5f96:	a02d                	j	5fc0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f98:	4618                	lw	a4,8(a2)
    5f9a:	9f2d                	addw	a4,a4,a1
    5f9c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fa0:	6398                	ld	a4,0(a5)
    5fa2:	6310                	ld	a2,0(a4)
    5fa4:	a83d                	j	5fe2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fa6:	ff852703          	lw	a4,-8(a0)
    5faa:	9f31                	addw	a4,a4,a2
    5fac:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5fae:	ff053683          	ld	a3,-16(a0)
    5fb2:	a091                	j	5ff6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fb4:	6398                	ld	a4,0(a5)
    5fb6:	00e7e463          	bltu	a5,a4,5fbe <free+0x3a>
    5fba:	00e6ea63          	bltu	a3,a4,5fce <free+0x4a>
{
    5fbe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fc0:	fed7fae3          	bgeu	a5,a3,5fb4 <free+0x30>
    5fc4:	6398                	ld	a4,0(a5)
    5fc6:	00e6e463          	bltu	a3,a4,5fce <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fca:	fee7eae3          	bltu	a5,a4,5fbe <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5fce:	ff852583          	lw	a1,-8(a0)
    5fd2:	6390                	ld	a2,0(a5)
    5fd4:	02059813          	slli	a6,a1,0x20
    5fd8:	01c85713          	srli	a4,a6,0x1c
    5fdc:	9736                	add	a4,a4,a3
    5fde:	fae60de3          	beq	a2,a4,5f98 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5fe2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5fe6:	4790                	lw	a2,8(a5)
    5fe8:	02061593          	slli	a1,a2,0x20
    5fec:	01c5d713          	srli	a4,a1,0x1c
    5ff0:	973e                	add	a4,a4,a5
    5ff2:	fae68ae3          	beq	a3,a4,5fa6 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5ff6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5ff8:	00003717          	auipc	a4,0x3
    5ffc:	44f73c23          	sd	a5,1112(a4) # 9450 <freep>
}
    6000:	6422                	ld	s0,8(sp)
    6002:	0141                	addi	sp,sp,16
    6004:	8082                	ret

0000000000006006 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6006:	7139                	addi	sp,sp,-64
    6008:	fc06                	sd	ra,56(sp)
    600a:	f822                	sd	s0,48(sp)
    600c:	f426                	sd	s1,40(sp)
    600e:	f04a                	sd	s2,32(sp)
    6010:	ec4e                	sd	s3,24(sp)
    6012:	e852                	sd	s4,16(sp)
    6014:	e456                	sd	s5,8(sp)
    6016:	e05a                	sd	s6,0(sp)
    6018:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    601a:	02051493          	slli	s1,a0,0x20
    601e:	9081                	srli	s1,s1,0x20
    6020:	04bd                	addi	s1,s1,15
    6022:	8091                	srli	s1,s1,0x4
    6024:	0014899b          	addiw	s3,s1,1
    6028:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    602a:	00003517          	auipc	a0,0x3
    602e:	42653503          	ld	a0,1062(a0) # 9450 <freep>
    6032:	c515                	beqz	a0,605e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6034:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6036:	4798                	lw	a4,8(a5)
    6038:	02977f63          	bgeu	a4,s1,6076 <malloc+0x70>
    603c:	8a4e                	mv	s4,s3
    603e:	0009871b          	sext.w	a4,s3
    6042:	6685                	lui	a3,0x1
    6044:	00d77363          	bgeu	a4,a3,604a <malloc+0x44>
    6048:	6a05                	lui	s4,0x1
    604a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    604e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6052:	00003917          	auipc	s2,0x3
    6056:	3fe90913          	addi	s2,s2,1022 # 9450 <freep>
  if(p == (char*)-1)
    605a:	5afd                	li	s5,-1
    605c:	a895                	j	60d0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    605e:	0000a797          	auipc	a5,0xa
    6062:	c1a78793          	addi	a5,a5,-998 # fc78 <base>
    6066:	00003717          	auipc	a4,0x3
    606a:	3ef73523          	sd	a5,1002(a4) # 9450 <freep>
    606e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6070:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6074:	b7e1                	j	603c <malloc+0x36>
      if(p->s.size == nunits)
    6076:	02e48c63          	beq	s1,a4,60ae <malloc+0xa8>
        p->s.size -= nunits;
    607a:	4137073b          	subw	a4,a4,s3
    607e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6080:	02071693          	slli	a3,a4,0x20
    6084:	01c6d713          	srli	a4,a3,0x1c
    6088:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    608a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    608e:	00003717          	auipc	a4,0x3
    6092:	3ca73123          	sd	a0,962(a4) # 9450 <freep>
      return (void*)(p + 1);
    6096:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    609a:	70e2                	ld	ra,56(sp)
    609c:	7442                	ld	s0,48(sp)
    609e:	74a2                	ld	s1,40(sp)
    60a0:	7902                	ld	s2,32(sp)
    60a2:	69e2                	ld	s3,24(sp)
    60a4:	6a42                	ld	s4,16(sp)
    60a6:	6aa2                	ld	s5,8(sp)
    60a8:	6b02                	ld	s6,0(sp)
    60aa:	6121                	addi	sp,sp,64
    60ac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60ae:	6398                	ld	a4,0(a5)
    60b0:	e118                	sd	a4,0(a0)
    60b2:	bff1                	j	608e <malloc+0x88>
  hp->s.size = nu;
    60b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60b8:	0541                	addi	a0,a0,16
    60ba:	00000097          	auipc	ra,0x0
    60be:	eca080e7          	jalr	-310(ra) # 5f84 <free>
  return freep;
    60c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60c6:	d971                	beqz	a0,609a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60ca:	4798                	lw	a4,8(a5)
    60cc:	fa9775e3          	bgeu	a4,s1,6076 <malloc+0x70>
    if(p == freep)
    60d0:	00093703          	ld	a4,0(s2)
    60d4:	853e                	mv	a0,a5
    60d6:	fef719e3          	bne	a4,a5,60c8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    60da:	8552                	mv	a0,s4
    60dc:	00000097          	auipc	ra,0x0
    60e0:	b70080e7          	jalr	-1168(ra) # 5c4c <sbrk>
  if(p == (char*)-1)
    60e4:	fd5518e3          	bne	a0,s5,60b4 <malloc+0xae>
        return 0;
    60e8:	4501                	li	a0,0
    60ea:	bf45                	j	609a <malloc+0x94>
