
bomb:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    $0x8,%rsp
    1008:	48 8b 05 d9 3f 00 00 	mov    0x3fd9(%rip),%rax        # 4fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   %rax,%rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   *%rax
    1016:	48 83 c4 08          	add    $0x8,%rsp
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 ca 3e 00 00    	push   0x3eca(%rip)        # 4ef0 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	f2 ff 25 cb 3e 00 00 	bnd jmp *0x3ecb(%rip)        # 4ef8 <_GLOBAL_OFFSET_TABLE_+0x10>
    102d:	0f 1f 00             	nopl   (%rax)
    1030:	f3 0f 1e fa          	endbr64 
    1034:	68 00 00 00 00       	push   $0x0
    1039:	f2 e9 e1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    103f:	90                   	nop
    1040:	f3 0f 1e fa          	endbr64 
    1044:	68 01 00 00 00       	push   $0x1
    1049:	f2 e9 d1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    104f:	90                   	nop
    1050:	f3 0f 1e fa          	endbr64 
    1054:	68 02 00 00 00       	push   $0x2
    1059:	f2 e9 c1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    105f:	90                   	nop
    1060:	f3 0f 1e fa          	endbr64 
    1064:	68 03 00 00 00       	push   $0x3
    1069:	f2 e9 b1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    106f:	90                   	nop
    1070:	f3 0f 1e fa          	endbr64 
    1074:	68 04 00 00 00       	push   $0x4
    1079:	f2 e9 a1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    107f:	90                   	nop
    1080:	f3 0f 1e fa          	endbr64 
    1084:	68 05 00 00 00       	push   $0x5
    1089:	f2 e9 91 ff ff ff    	bnd jmp 1020 <_init+0x20>
    108f:	90                   	nop
    1090:	f3 0f 1e fa          	endbr64 
    1094:	68 06 00 00 00       	push   $0x6
    1099:	f2 e9 81 ff ff ff    	bnd jmp 1020 <_init+0x20>
    109f:	90                   	nop
    10a0:	f3 0f 1e fa          	endbr64 
    10a4:	68 07 00 00 00       	push   $0x7
    10a9:	f2 e9 71 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10af:	90                   	nop
    10b0:	f3 0f 1e fa          	endbr64 
    10b4:	68 08 00 00 00       	push   $0x8
    10b9:	f2 e9 61 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10bf:	90                   	nop
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	68 09 00 00 00       	push   $0x9
    10c9:	f2 e9 51 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10cf:	90                   	nop
    10d0:	f3 0f 1e fa          	endbr64 
    10d4:	68 0a 00 00 00       	push   $0xa
    10d9:	f2 e9 41 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10df:	90                   	nop
    10e0:	f3 0f 1e fa          	endbr64 
    10e4:	68 0b 00 00 00       	push   $0xb
    10e9:	f2 e9 31 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10ef:	90                   	nop
    10f0:	f3 0f 1e fa          	endbr64 
    10f4:	68 0c 00 00 00       	push   $0xc
    10f9:	f2 e9 21 ff ff ff    	bnd jmp 1020 <_init+0x20>
    10ff:	90                   	nop
    1100:	f3 0f 1e fa          	endbr64 
    1104:	68 0d 00 00 00       	push   $0xd
    1109:	f2 e9 11 ff ff ff    	bnd jmp 1020 <_init+0x20>
    110f:	90                   	nop
    1110:	f3 0f 1e fa          	endbr64 
    1114:	68 0e 00 00 00       	push   $0xe
    1119:	f2 e9 01 ff ff ff    	bnd jmp 1020 <_init+0x20>
    111f:	90                   	nop
    1120:	f3 0f 1e fa          	endbr64 
    1124:	68 0f 00 00 00       	push   $0xf
    1129:	f2 e9 f1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    112f:	90                   	nop
    1130:	f3 0f 1e fa          	endbr64 
    1134:	68 10 00 00 00       	push   $0x10
    1139:	f2 e9 e1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    113f:	90                   	nop
    1140:	f3 0f 1e fa          	endbr64 
    1144:	68 11 00 00 00       	push   $0x11
    1149:	f2 e9 d1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    114f:	90                   	nop
    1150:	f3 0f 1e fa          	endbr64 
    1154:	68 12 00 00 00       	push   $0x12
    1159:	f2 e9 c1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    115f:	90                   	nop
    1160:	f3 0f 1e fa          	endbr64 
    1164:	68 13 00 00 00       	push   $0x13
    1169:	f2 e9 b1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    116f:	90                   	nop
    1170:	f3 0f 1e fa          	endbr64 
    1174:	68 14 00 00 00       	push   $0x14
    1179:	f2 e9 a1 fe ff ff    	bnd jmp 1020 <_init+0x20>
    117f:	90                   	nop
    1180:	f3 0f 1e fa          	endbr64 
    1184:	68 15 00 00 00       	push   $0x15
    1189:	f2 e9 91 fe ff ff    	bnd jmp 1020 <_init+0x20>
    118f:	90                   	nop
    1190:	f3 0f 1e fa          	endbr64 
    1194:	68 16 00 00 00       	push   $0x16
    1199:	f2 e9 81 fe ff ff    	bnd jmp 1020 <_init+0x20>
    119f:	90                   	nop
    11a0:	f3 0f 1e fa          	endbr64 
    11a4:	68 17 00 00 00       	push   $0x17
    11a9:	f2 e9 71 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11af:	90                   	nop
    11b0:	f3 0f 1e fa          	endbr64 
    11b4:	68 18 00 00 00       	push   $0x18
    11b9:	f2 e9 61 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11bf:	90                   	nop
    11c0:	f3 0f 1e fa          	endbr64 
    11c4:	68 19 00 00 00       	push   $0x19
    11c9:	f2 e9 51 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11cf:	90                   	nop
    11d0:	f3 0f 1e fa          	endbr64 
    11d4:	68 1a 00 00 00       	push   $0x1a
    11d9:	f2 e9 41 fe ff ff    	bnd jmp 1020 <_init+0x20>
    11df:	90                   	nop

Disassembly of section .plt.got:

00000000000011e0 <__cxa_finalize@plt>:
    11e0:	f3 0f 1e fa          	endbr64 
    11e4:	f2 ff 25 0d 3e 00 00 	bnd jmp *0x3e0d(%rip)        # 4ff8 <__cxa_finalize@GLIBC_2.2.5>
    11eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Disassembly of section .plt.sec:

00000000000011f0 <getenv@plt>:
    11f0:	f3 0f 1e fa          	endbr64 
    11f4:	f2 ff 25 05 3d 00 00 	bnd jmp *0x3d05(%rip)        # 4f00 <getenv@GLIBC_2.2.5>
    11fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001200 <__errno_location@plt>:
    1200:	f3 0f 1e fa          	endbr64 
    1204:	f2 ff 25 fd 3c 00 00 	bnd jmp *0x3cfd(%rip)        # 4f08 <__errno_location@GLIBC_2.2.5>
    120b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001210 <strcpy@plt>:
    1210:	f3 0f 1e fa          	endbr64 
    1214:	f2 ff 25 f5 3c 00 00 	bnd jmp *0x3cf5(%rip)        # 4f10 <strcpy@GLIBC_2.2.5>
    121b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001220 <puts@plt>:
    1220:	f3 0f 1e fa          	endbr64 
    1224:	f2 ff 25 ed 3c 00 00 	bnd jmp *0x3ced(%rip)        # 4f18 <puts@GLIBC_2.2.5>
    122b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001230 <write@plt>:
    1230:	f3 0f 1e fa          	endbr64 
    1234:	f2 ff 25 e5 3c 00 00 	bnd jmp *0x3ce5(%rip)        # 4f20 <write@GLIBC_2.2.5>
    123b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001240 <strlen@plt>:
    1240:	f3 0f 1e fa          	endbr64 
    1244:	f2 ff 25 dd 3c 00 00 	bnd jmp *0x3cdd(%rip)        # 4f28 <strlen@GLIBC_2.2.5>
    124b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001250 <__stack_chk_fail@plt>:
    1250:	f3 0f 1e fa          	endbr64 
    1254:	f2 ff 25 d5 3c 00 00 	bnd jmp *0x3cd5(%rip)        # 4f30 <__stack_chk_fail@GLIBC_2.4>
    125b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001260 <alarm@plt>:
    1260:	f3 0f 1e fa          	endbr64 
    1264:	f2 ff 25 cd 3c 00 00 	bnd jmp *0x3ccd(%rip)        # 4f38 <alarm@GLIBC_2.2.5>
    126b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001270 <close@plt>:
    1270:	f3 0f 1e fa          	endbr64 
    1274:	f2 ff 25 c5 3c 00 00 	bnd jmp *0x3cc5(%rip)        # 4f40 <close@GLIBC_2.2.5>
    127b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001280 <read@plt>:
    1280:	f3 0f 1e fa          	endbr64 
    1284:	f2 ff 25 bd 3c 00 00 	bnd jmp *0x3cbd(%rip)        # 4f48 <read@GLIBC_2.2.5>
    128b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001290 <fgets@plt>:
    1290:	f3 0f 1e fa          	endbr64 
    1294:	f2 ff 25 b5 3c 00 00 	bnd jmp *0x3cb5(%rip)        # 4f50 <fgets@GLIBC_2.2.5>
    129b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000012a0 <strcmp@plt>:
    12a0:	f3 0f 1e fa          	endbr64 
    12a4:	f2 ff 25 ad 3c 00 00 	bnd jmp *0x3cad(%rip)        # 4f58 <strcmp@GLIBC_2.2.5>
    12ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000012b0 <signal@plt>:
    12b0:	f3 0f 1e fa          	endbr64 
    12b4:	f2 ff 25 a5 3c 00 00 	bnd jmp *0x3ca5(%rip)        # 4f60 <signal@GLIBC_2.2.5>
    12bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000012c0 <gethostbyname@plt>:
    12c0:	f3 0f 1e fa          	endbr64 
    12c4:	f2 ff 25 9d 3c 00 00 	bnd jmp *0x3c9d(%rip)        # 4f68 <gethostbyname@GLIBC_2.2.5>
    12cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000012d0 <__memmove_chk@plt>:
    12d0:	f3 0f 1e fa          	endbr64 
    12d4:	f2 ff 25 95 3c 00 00 	bnd jmp *0x3c95(%rip)        # 4f70 <__memmove_chk@GLIBC_2.3.4>
    12db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000012e0 <strtol@plt>:
    12e0:	f3 0f 1e fa          	endbr64 
    12e4:	f2 ff 25 8d 3c 00 00 	bnd jmp *0x3c8d(%rip)        # 4f78 <strtol@GLIBC_2.2.5>
    12eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000012f0 <fflush@plt>:
    12f0:	f3 0f 1e fa          	endbr64 
    12f4:	f2 ff 25 85 3c 00 00 	bnd jmp *0x3c85(%rip)        # 4f80 <fflush@GLIBC_2.2.5>
    12fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001300 <__isoc99_sscanf@plt>:
    1300:	f3 0f 1e fa          	endbr64 
    1304:	f2 ff 25 7d 3c 00 00 	bnd jmp *0x3c7d(%rip)        # 4f88 <__isoc99_sscanf@GLIBC_2.7>
    130b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001310 <__printf_chk@plt>:
    1310:	f3 0f 1e fa          	endbr64 
    1314:	f2 ff 25 75 3c 00 00 	bnd jmp *0x3c75(%rip)        # 4f90 <__printf_chk@GLIBC_2.3.4>
    131b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001320 <fopen@plt>:
    1320:	f3 0f 1e fa          	endbr64 
    1324:	f2 ff 25 6d 3c 00 00 	bnd jmp *0x3c6d(%rip)        # 4f98 <fopen@GLIBC_2.2.5>
    132b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001330 <exit@plt>:
    1330:	f3 0f 1e fa          	endbr64 
    1334:	f2 ff 25 65 3c 00 00 	bnd jmp *0x3c65(%rip)        # 4fa0 <exit@GLIBC_2.2.5>
    133b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001340 <connect@plt>:
    1340:	f3 0f 1e fa          	endbr64 
    1344:	f2 ff 25 5d 3c 00 00 	bnd jmp *0x3c5d(%rip)        # 4fa8 <connect@GLIBC_2.2.5>
    134b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001350 <__fprintf_chk@plt>:
    1350:	f3 0f 1e fa          	endbr64 
    1354:	f2 ff 25 55 3c 00 00 	bnd jmp *0x3c55(%rip)        # 4fb0 <__fprintf_chk@GLIBC_2.3.4>
    135b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001360 <sleep@plt>:
    1360:	f3 0f 1e fa          	endbr64 
    1364:	f2 ff 25 4d 3c 00 00 	bnd jmp *0x3c4d(%rip)        # 4fb8 <sleep@GLIBC_2.2.5>
    136b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001370 <__ctype_b_loc@plt>:
    1370:	f3 0f 1e fa          	endbr64 
    1374:	f2 ff 25 45 3c 00 00 	bnd jmp *0x3c45(%rip)        # 4fc0 <__ctype_b_loc@GLIBC_2.3>
    137b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001380 <__sprintf_chk@plt>:
    1380:	f3 0f 1e fa          	endbr64 
    1384:	f2 ff 25 3d 3c 00 00 	bnd jmp *0x3c3d(%rip)        # 4fc8 <__sprintf_chk@GLIBC_2.3.4>
    138b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001390 <socket@plt>:
    1390:	f3 0f 1e fa          	endbr64 
    1394:	f2 ff 25 35 3c 00 00 	bnd jmp *0x3c35(%rip)        # 4fd0 <socket@GLIBC_2.2.5>
    139b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Disassembly of section .text:

00000000000013a0 <_start>:
    13a0:	f3 0f 1e fa          	endbr64 
    13a4:	31 ed                	xor    %ebp,%ebp
    13a6:	49 89 d1             	mov    %rdx,%r9
    13a9:	5e                   	pop    %rsi
    13aa:	48 89 e2             	mov    %rsp,%rdx
    13ad:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    13b1:	50                   	push   %rax
    13b2:	54                   	push   %rsp
    13b3:	45 31 c0             	xor    %r8d,%r8d
    13b6:	31 c9                	xor    %ecx,%ecx
    13b8:	48 8d 3d ca 00 00 00 	lea    0xca(%rip),%rdi        # 1489 <main>
    13bf:	ff 15 13 3c 00 00    	call   *0x3c13(%rip)        # 4fd8 <__libc_start_main@GLIBC_2.34>
    13c5:	f4                   	hlt    
    13c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    13cd:	00 00 00 

00000000000013d0 <deregister_tm_clones>:
    13d0:	48 8d 3d 89 42 00 00 	lea    0x4289(%rip),%rdi        # 5660 <stdout@GLIBC_2.2.5>
    13d7:	48 8d 05 82 42 00 00 	lea    0x4282(%rip),%rax        # 5660 <stdout@GLIBC_2.2.5>
    13de:	48 39 f8             	cmp    %rdi,%rax
    13e1:	74 15                	je     13f8 <deregister_tm_clones+0x28>
    13e3:	48 8b 05 f6 3b 00 00 	mov    0x3bf6(%rip),%rax        # 4fe0 <_ITM_deregisterTMCloneTable@Base>
    13ea:	48 85 c0             	test   %rax,%rax
    13ed:	74 09                	je     13f8 <deregister_tm_clones+0x28>
    13ef:	ff e0                	jmp    *%rax
    13f1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    13f8:	c3                   	ret    
    13f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001400 <register_tm_clones>:
    1400:	48 8d 3d 59 42 00 00 	lea    0x4259(%rip),%rdi        # 5660 <stdout@GLIBC_2.2.5>
    1407:	48 8d 35 52 42 00 00 	lea    0x4252(%rip),%rsi        # 5660 <stdout@GLIBC_2.2.5>
    140e:	48 29 fe             	sub    %rdi,%rsi
    1411:	48 89 f0             	mov    %rsi,%rax
    1414:	48 c1 ee 3f          	shr    $0x3f,%rsi
    1418:	48 c1 f8 03          	sar    $0x3,%rax
    141c:	48 01 c6             	add    %rax,%rsi
    141f:	48 d1 fe             	sar    %rsi
    1422:	74 14                	je     1438 <register_tm_clones+0x38>
    1424:	48 8b 05 c5 3b 00 00 	mov    0x3bc5(%rip),%rax        # 4ff0 <_ITM_registerTMCloneTable@Base>
    142b:	48 85 c0             	test   %rax,%rax
    142e:	74 08                	je     1438 <register_tm_clones+0x38>
    1430:	ff e0                	jmp    *%rax
    1432:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1438:	c3                   	ret    
    1439:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001440 <__do_global_dtors_aux>:
    1440:	f3 0f 1e fa          	endbr64 
    1444:	80 3d 3d 42 00 00 00 	cmpb   $0x0,0x423d(%rip)        # 5688 <completed.0>
    144b:	75 2b                	jne    1478 <__do_global_dtors_aux+0x38>
    144d:	55                   	push   %rbp
    144e:	48 83 3d a2 3b 00 00 	cmpq   $0x0,0x3ba2(%rip)        # 4ff8 <__cxa_finalize@GLIBC_2.2.5>
    1455:	00 
    1456:	48 89 e5             	mov    %rsp,%rbp
    1459:	74 0c                	je     1467 <__do_global_dtors_aux+0x27>
    145b:	48 8b 3d a6 3b 00 00 	mov    0x3ba6(%rip),%rdi        # 5008 <__dso_handle>
    1462:	e8 79 fd ff ff       	call   11e0 <__cxa_finalize@plt>
    1467:	e8 64 ff ff ff       	call   13d0 <deregister_tm_clones>
    146c:	c6 05 15 42 00 00 01 	movb   $0x1,0x4215(%rip)        # 5688 <completed.0>
    1473:	5d                   	pop    %rbp
    1474:	c3                   	ret    
    1475:	0f 1f 00             	nopl   (%rax)
    1478:	c3                   	ret    
    1479:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001480 <frame_dummy>:
    1480:	f3 0f 1e fa          	endbr64 
    1484:	e9 77 ff ff ff       	jmp    1400 <register_tm_clones>

0000000000001489 <main>:
    1489:	f3 0f 1e fa          	endbr64 
    148d:	53                   	push   %rbx
    148e:	83 ff 01             	cmp    $0x1,%edi
    1491:	0f 84 bc 00 00 00    	je     1553 <main+0xca>
    1497:	48 89 f3             	mov    %rsi,%rbx
    149a:	83 ff 02             	cmp    $0x2,%edi
    149d:	0f 85 e5 00 00 00    	jne    1588 <main+0xff>
    14a3:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
    14a7:	48 8d 35 56 1b 00 00 	lea    0x1b56(%rip),%rsi        # 3004 <_IO_stdin_used+0x4>
    14ae:	e8 6d fe ff ff       	call   1320 <fopen@plt>
    14b3:	48 89 05 d6 41 00 00 	mov    %rax,0x41d6(%rip)        # 5690 <infile>
    14ba:	48 85 c0             	test   %rax,%rax
    14bd:	0f 84 a3 00 00 00    	je     1566 <main+0xdd>
    14c3:	e8 16 07 00 00       	call   1bde <initialize_bomb>
    14c8:	48 8d 3d 71 1b 00 00 	lea    0x1b71(%rip),%rdi        # 3040 <_IO_stdin_used+0x40>
    14cf:	e8 4c fd ff ff       	call   1220 <puts@plt>
    14d4:	48 8d 3d a5 1b 00 00 	lea    0x1ba5(%rip),%rdi        # 3080 <_IO_stdin_used+0x80>
    14db:	e8 40 fd ff ff       	call   1220 <puts@plt>
    14e0:	e8 4a 08 00 00       	call   1d2f <read_line>
    14e5:	48 89 c7             	mov    %rax,%rdi
    14e8:	e8 be 00 00 00       	call   15ab <phase_1>
    14ed:	e8 91 09 00 00       	call   1e83 <phase_defused>
    14f2:	e8 38 08 00 00       	call   1d2f <read_line>
    14f7:	48 89 c7             	mov    %rax,%rdi
    14fa:	e8 d0 00 00 00       	call   15cf <phase_2>
    14ff:	e8 7f 09 00 00       	call   1e83 <phase_defused>
    1504:	e8 26 08 00 00       	call   1d2f <read_line>
    1509:	48 89 c7             	mov    %rax,%rdi
    150c:	e8 2c 01 00 00       	call   163d <phase_3>
    1511:	e8 6d 09 00 00       	call   1e83 <phase_defused>
    1516:	e8 14 08 00 00       	call   1d2f <read_line>
    151b:	48 89 c7             	mov    %rax,%rdi
    151e:	e8 dc 02 00 00       	call   17ff <phase_4>
    1523:	e8 5b 09 00 00       	call   1e83 <phase_defused>
    1528:	e8 02 08 00 00       	call   1d2f <read_line>
    152d:	48 89 c7             	mov    %rax,%rdi
    1530:	e8 43 03 00 00       	call   1878 <phase_5>
    1535:	e8 49 09 00 00       	call   1e83 <phase_defused>
    153a:	e8 f0 07 00 00       	call   1d2f <read_line>
    153f:	48 89 c7             	mov    %rax,%rdi
    1542:	e8 7d 03 00 00       	call   18c4 <phase_6>
    1547:	e8 37 09 00 00       	call   1e83 <phase_defused>
    154c:	b8 00 00 00 00       	mov    $0x0,%eax
    1551:	5b                   	pop    %rbx
    1552:	c3                   	ret    
    1553:	48 8b 05 16 41 00 00 	mov    0x4116(%rip),%rax        # 5670 <stdin@GLIBC_2.2.5>
    155a:	48 89 05 2f 41 00 00 	mov    %rax,0x412f(%rip)        # 5690 <infile>
    1561:	e9 5d ff ff ff       	jmp    14c3 <main+0x3a>
    1566:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
    156a:	48 8b 13             	mov    (%rbx),%rdx
    156d:	48 8d 35 92 1a 00 00 	lea    0x1a92(%rip),%rsi        # 3006 <_IO_stdin_used+0x6>
    1574:	bf 01 00 00 00       	mov    $0x1,%edi
    1579:	e8 92 fd ff ff       	call   1310 <__printf_chk@plt>
    157e:	bf 08 00 00 00       	mov    $0x8,%edi
    1583:	e8 a8 fd ff ff       	call   1330 <exit@plt>
    1588:	48 8b 16             	mov    (%rsi),%rdx
    158b:	48 8d 35 91 1a 00 00 	lea    0x1a91(%rip),%rsi        # 3023 <_IO_stdin_used+0x23>
    1592:	bf 01 00 00 00       	mov    $0x1,%edi
    1597:	b8 00 00 00 00       	mov    $0x0,%eax
    159c:	e8 6f fd ff ff       	call   1310 <__printf_chk@plt>
    15a1:	bf 08 00 00 00       	mov    $0x8,%edi
    15a6:	e8 85 fd ff ff       	call   1330 <exit@plt>

00000000000015ab <phase_1>:
    15ab:	f3 0f 1e fa          	endbr64 
    15af:	48 83 ec 08          	sub    $0x8,%rsp
    15b3:	48 8d 35 f6 1a 00 00 	lea    0x1af6(%rip),%rsi        # 30b0 <_IO_stdin_used+0xb0>
    15ba:	e8 bf 05 00 00       	call   1b7e <strings_not_equal>
    15bf:	85 c0                	test   %eax,%eax
    15c1:	75 05                	jne    15c8 <phase_1+0x1d>
    15c3:	48 83 c4 08          	add    $0x8,%rsp
    15c7:	c3                   	ret    
    15c8:	e8 c5 06 00 00       	call   1c92 <explode_bomb>
    15cd:	eb f4                	jmp    15c3 <phase_1+0x18>

00000000000015cf <phase_2>:
    15cf:	f3 0f 1e fa          	endbr64 
    15d3:	55                   	push   %rbp
    15d4:	53                   	push   %rbx
    15d5:	48 83 ec 28          	sub    $0x28,%rsp
    15d9:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    15e0:	00 00 
    15e2:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    15e7:	31 c0                	xor    %eax,%eax
    15e9:	48 89 e6             	mov    %rsp,%rsi
    15ec:	e8 f9 06 00 00       	call   1cea <read_six_numbers>
    15f1:	83 3c 24 01          	cmpl   $0x1,(%rsp)
    15f5:	75 0a                	jne    1601 <phase_2+0x32>
    15f7:	48 89 e3             	mov    %rsp,%rbx
    15fa:	48 8d 6c 24 14       	lea    0x14(%rsp),%rbp
    15ff:	eb 10                	jmp    1611 <phase_2+0x42>
    1601:	e8 8c 06 00 00       	call   1c92 <explode_bomb>
    1606:	eb ef                	jmp    15f7 <phase_2+0x28>
    1608:	48 83 c3 04          	add    $0x4,%rbx
    160c:	48 39 eb             	cmp    %rbp,%rbx
    160f:	74 10                	je     1621 <phase_2+0x52>
    1611:	8b 03                	mov    (%rbx),%eax
    1613:	01 c0                	add    %eax,%eax
    1615:	39 43 04             	cmp    %eax,0x4(%rbx)
    1618:	74 ee                	je     1608 <phase_2+0x39>
    161a:	e8 73 06 00 00       	call   1c92 <explode_bomb>
    161f:	eb e7                	jmp    1608 <phase_2+0x39>
    1621:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    1626:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
    162d:	00 00 
    162f:	75 07                	jne    1638 <phase_2+0x69>
    1631:	48 83 c4 28          	add    $0x28,%rsp
    1635:	5b                   	pop    %rbx
    1636:	5d                   	pop    %rbp
    1637:	c3                   	ret    
    1638:	e8 13 fc ff ff       	call   1250 <__stack_chk_fail@plt>

000000000000163d <phase_3>:
    163d:	f3 0f 1e fa          	endbr64 
    1641:	48 83 ec 28          	sub    $0x28,%rsp
    1645:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    164c:	00 00 
    164e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    1653:	31 c0                	xor    %eax,%eax
    1655:	48 8d 4c 24 0f       	lea    0xf(%rsp),%rcx
    165a:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
    165f:	4c 8d 44 24 14       	lea    0x14(%rsp),%r8
    1664:	48 8d 35 93 1a 00 00 	lea    0x1a93(%rip),%rsi        # 30fe <_IO_stdin_used+0xfe>
    166b:	e8 90 fc ff ff       	call   1300 <__isoc99_sscanf@plt>
    1670:	83 f8 02             	cmp    $0x2,%eax
    1673:	7e 20                	jle    1695 <phase_3+0x58>
    1675:	83 7c 24 10 07       	cmpl   $0x7,0x10(%rsp)
    167a:	0f 87 0d 01 00 00    	ja     178d <phase_3+0x150>
    1680:	8b 44 24 10          	mov    0x10(%rsp),%eax
    1684:	48 8d 15 95 1a 00 00 	lea    0x1a95(%rip),%rdx        # 3120 <_IO_stdin_used+0x120>
    168b:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
    168f:	48 01 d0             	add    %rdx,%rax
    1692:	3e ff e0             	notrack jmp *%rax
    1695:	e8 f8 05 00 00       	call   1c92 <explode_bomb>
    169a:	eb d9                	jmp    1675 <phase_3+0x38>
    169c:	b8 77 00 00 00       	mov    $0x77,%eax
    16a1:	81 7c 24 14 8b 01 00 	cmpl   $0x18b,0x14(%rsp)
    16a8:	00 
    16a9:	0f 84 e8 00 00 00    	je     1797 <phase_3+0x15a>
    16af:	e8 de 05 00 00       	call   1c92 <explode_bomb>
    16b4:	b8 77 00 00 00       	mov    $0x77,%eax
    16b9:	e9 d9 00 00 00       	jmp    1797 <phase_3+0x15a>
    16be:	b8 74 00 00 00       	mov    $0x74,%eax
    16c3:	81 7c 24 14 8c 00 00 	cmpl   $0x8c,0x14(%rsp)
    16ca:	00 
    16cb:	0f 84 c6 00 00 00    	je     1797 <phase_3+0x15a>
    16d1:	e8 bc 05 00 00       	call   1c92 <explode_bomb>
    16d6:	b8 74 00 00 00       	mov    $0x74,%eax
    16db:	e9 b7 00 00 00       	jmp    1797 <phase_3+0x15a>
    16e0:	b8 6e 00 00 00       	mov    $0x6e,%eax
    16e5:	81 7c 24 14 ce 00 00 	cmpl   $0xce,0x14(%rsp)
    16ec:	00 
    16ed:	0f 84 a4 00 00 00    	je     1797 <phase_3+0x15a>
    16f3:	e8 9a 05 00 00       	call   1c92 <explode_bomb>
    16f8:	b8 6e 00 00 00       	mov    $0x6e,%eax
    16fd:	e9 95 00 00 00       	jmp    1797 <phase_3+0x15a>
    1702:	b8 74 00 00 00       	mov    $0x74,%eax
    1707:	81 7c 24 14 c8 01 00 	cmpl   $0x1c8,0x14(%rsp)
    170e:	00 
    170f:	0f 84 82 00 00 00    	je     1797 <phase_3+0x15a>
    1715:	e8 78 05 00 00       	call   1c92 <explode_bomb>
    171a:	b8 74 00 00 00       	mov    $0x74,%eax
    171f:	eb 76                	jmp    1797 <phase_3+0x15a>
    1721:	b8 71 00 00 00       	mov    $0x71,%eax
    1726:	81 7c 24 14 72 01 00 	cmpl   $0x172,0x14(%rsp)
    172d:	00 
    172e:	74 67                	je     1797 <phase_3+0x15a>
    1730:	e8 5d 05 00 00       	call   1c92 <explode_bomb>
    1735:	b8 71 00 00 00       	mov    $0x71,%eax
    173a:	eb 5b                	jmp    1797 <phase_3+0x15a>
    173c:	b8 77 00 00 00       	mov    $0x77,%eax
    1741:	81 7c 24 14 68 03 00 	cmpl   $0x368,0x14(%rsp)
    1748:	00 
    1749:	74 4c                	je     1797 <phase_3+0x15a>
    174b:	e8 42 05 00 00       	call   1c92 <explode_bomb>
    1750:	b8 77 00 00 00       	mov    $0x77,%eax
    1755:	eb 40                	jmp    1797 <phase_3+0x15a>
    1757:	b8 6f 00 00 00       	mov    $0x6f,%eax
    175c:	81 7c 24 14 90 03 00 	cmpl   $0x390,0x14(%rsp)
    1763:	00 
    1764:	74 31                	je     1797 <phase_3+0x15a>
    1766:	e8 27 05 00 00       	call   1c92 <explode_bomb>
    176b:	b8 6f 00 00 00       	mov    $0x6f,%eax
    1770:	eb 25                	jmp    1797 <phase_3+0x15a>
    1772:	b8 74 00 00 00       	mov    $0x74,%eax
    1777:	81 7c 24 14 1a 02 00 	cmpl   $0x21a,0x14(%rsp)
    177e:	00 
    177f:	74 16                	je     1797 <phase_3+0x15a>
    1781:	e8 0c 05 00 00       	call   1c92 <explode_bomb>
    1786:	b8 74 00 00 00       	mov    $0x74,%eax
    178b:	eb 0a                	jmp    1797 <phase_3+0x15a>
    178d:	e8 00 05 00 00       	call   1c92 <explode_bomb>
    1792:	b8 6f 00 00 00       	mov    $0x6f,%eax
    1797:	38 44 24 0f          	cmp    %al,0xf(%rsp)
    179b:	75 15                	jne    17b2 <phase_3+0x175>
    179d:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    17a2:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
    17a9:	00 00 
    17ab:	75 0c                	jne    17b9 <phase_3+0x17c>
    17ad:	48 83 c4 28          	add    $0x28,%rsp
    17b1:	c3                   	ret    
    17b2:	e8 db 04 00 00       	call   1c92 <explode_bomb>
    17b7:	eb e4                	jmp    179d <phase_3+0x160>
    17b9:	e8 92 fa ff ff       	call   1250 <__stack_chk_fail@plt>

00000000000017be <func4>:
    17be:	f3 0f 1e fa          	endbr64 
    17c2:	48 83 ec 08          	sub    $0x8,%rsp
    17c6:	89 d0                	mov    %edx,%eax
    17c8:	29 f0                	sub    %esi,%eax
    17ca:	89 c1                	mov    %eax,%ecx
    17cc:	c1 e9 1f             	shr    $0x1f,%ecx
    17cf:	01 c1                	add    %eax,%ecx
    17d1:	d1 f9                	sar    %ecx
    17d3:	01 f1                	add    %esi,%ecx
    17d5:	39 f9                	cmp    %edi,%ecx
    17d7:	7f 0c                	jg     17e5 <func4+0x27>
    17d9:	b8 00 00 00 00       	mov    $0x0,%eax
    17de:	7c 11                	jl     17f1 <func4+0x33>
    17e0:	48 83 c4 08          	add    $0x8,%rsp
    17e4:	c3                   	ret    
    17e5:	8d 51 ff             	lea    -0x1(%rcx),%edx
    17e8:	e8 d1 ff ff ff       	call   17be <func4>
    17ed:	01 c0                	add    %eax,%eax
    17ef:	eb ef                	jmp    17e0 <func4+0x22>
    17f1:	8d 71 01             	lea    0x1(%rcx),%esi
    17f4:	e8 c5 ff ff ff       	call   17be <func4>
    17f9:	8d 44 00 01          	lea    0x1(%rax,%rax,1),%eax
    17fd:	eb e1                	jmp    17e0 <func4+0x22>

00000000000017ff <phase_4>:
    17ff:	f3 0f 1e fa          	endbr64 
    1803:	48 83 ec 18          	sub    $0x18,%rsp
    1807:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    180e:	00 00 
    1810:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    1815:	31 c0                	xor    %eax,%eax
    1817:	48 8d 4c 24 04       	lea    0x4(%rsp),%rcx
    181c:	48 89 e2             	mov    %rsp,%rdx
    181f:	48 8d 35 2a 1b 00 00 	lea    0x1b2a(%rip),%rsi        # 3350 <array.0+0x210>
    1826:	e8 d5 fa ff ff       	call   1300 <__isoc99_sscanf@plt>
    182b:	83 f8 02             	cmp    $0x2,%eax
    182e:	75 06                	jne    1836 <phase_4+0x37>
    1830:	83 3c 24 0e          	cmpl   $0xe,(%rsp)
    1834:	76 05                	jbe    183b <phase_4+0x3c>
    1836:	e8 57 04 00 00       	call   1c92 <explode_bomb>
    183b:	ba 0e 00 00 00       	mov    $0xe,%edx
    1840:	be 00 00 00 00       	mov    $0x0,%esi
    1845:	8b 3c 24             	mov    (%rsp),%edi
    1848:	e8 71 ff ff ff       	call   17be <func4>
    184d:	83 f8 03             	cmp    $0x3,%eax
    1850:	75 07                	jne    1859 <phase_4+0x5a>
    1852:	83 7c 24 04 03       	cmpl   $0x3,0x4(%rsp)
    1857:	74 05                	je     185e <phase_4+0x5f>
    1859:	e8 34 04 00 00       	call   1c92 <explode_bomb>
    185e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    1863:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
    186a:	00 00 
    186c:	75 05                	jne    1873 <phase_4+0x74>
    186e:	48 83 c4 18          	add    $0x18,%rsp
    1872:	c3                   	ret    
    1873:	e8 d8 f9 ff ff       	call   1250 <__stack_chk_fail@plt>

0000000000001878 <phase_5>:
    1878:	f3 0f 1e fa          	endbr64 
    187c:	53                   	push   %rbx
    187d:	48 89 fb             	mov    %rdi,%rbx
    1880:	e8 d8 02 00 00       	call   1b5d <string_length>
    1885:	83 f8 06             	cmp    $0x6,%eax
    1888:	75 2c                	jne    18b6 <phase_5+0x3e>
    188a:	48 89 d8             	mov    %rbx,%rax
    188d:	48 8d 7b 06          	lea    0x6(%rbx),%rdi
    1891:	b9 00 00 00 00       	mov    $0x0,%ecx
    1896:	48 8d 35 a3 18 00 00 	lea    0x18a3(%rip),%rsi        # 3140 <array.0>
    189d:	0f b6 10             	movzbl (%rax),%edx
    18a0:	83 e2 0f             	and    $0xf,%edx
    18a3:	03 0c 96             	add    (%rsi,%rdx,4),%ecx
    18a6:	48 83 c0 01          	add    $0x1,%rax
    18aa:	48 39 f8             	cmp    %rdi,%rax
    18ad:	75 ee                	jne    189d <phase_5+0x25>
    18af:	83 f9 40             	cmp    $0x40,%ecx
    18b2:	75 09                	jne    18bd <phase_5+0x45>
    18b4:	5b                   	pop    %rbx
    18b5:	c3                   	ret    
    18b6:	e8 d7 03 00 00       	call   1c92 <explode_bomb>
    18bb:	eb cd                	jmp    188a <phase_5+0x12>
    18bd:	e8 d0 03 00 00       	call   1c92 <explode_bomb>
    18c2:	eb f0                	jmp    18b4 <phase_5+0x3c>

00000000000018c4 <phase_6>:
    18c4:	f3 0f 1e fa          	endbr64 
    18c8:	41 57                	push   %r15
    18ca:	41 56                	push   %r14
    18cc:	41 55                	push   %r13
    18ce:	41 54                	push   %r12
    18d0:	55                   	push   %rbp
    18d1:	53                   	push   %rbx
    18d2:	48 83 ec 78          	sub    $0x78,%rsp
    18d6:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    18dd:	00 00 
    18df:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
    18e4:	31 c0                	xor    %eax,%eax
    18e6:	4c 8d 74 24 10       	lea    0x10(%rsp),%r14
    18eb:	4c 89 74 24 08       	mov    %r14,0x8(%rsp)
    18f0:	4c 89 f6             	mov    %r14,%rsi
    18f3:	e8 f2 03 00 00       	call   1cea <read_six_numbers>
    18f8:	4d 89 f4             	mov    %r14,%r12
    18fb:	41 bf 01 00 00 00    	mov    $0x1,%r15d
    1901:	4d 89 f5             	mov    %r14,%r13
    1904:	e9 c6 00 00 00       	jmp    19cf <phase_6+0x10b>
    1909:	e8 84 03 00 00       	call   1c92 <explode_bomb>
    190e:	e9 ce 00 00 00       	jmp    19e1 <phase_6+0x11d>
    1913:	48 83 c3 01          	add    $0x1,%rbx
    1917:	83 fb 05             	cmp    $0x5,%ebx
    191a:	0f 8f a7 00 00 00    	jg     19c7 <phase_6+0x103>
    1920:	41 8b 44 9d 00       	mov    0x0(%r13,%rbx,4),%eax
    1925:	39 45 00             	cmp    %eax,0x0(%rbp)
    1928:	75 e9                	jne    1913 <phase_6+0x4f>
    192a:	e8 63 03 00 00       	call   1c92 <explode_bomb>
    192f:	eb e2                	jmp    1913 <phase_6+0x4f>
    1931:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
    1936:	48 83 c2 18          	add    $0x18,%rdx
    193a:	b9 07 00 00 00       	mov    $0x7,%ecx
    193f:	89 c8                	mov    %ecx,%eax
    1941:	41 2b 04 24          	sub    (%r12),%eax
    1945:	41 89 04 24          	mov    %eax,(%r12)
    1949:	49 83 c4 04          	add    $0x4,%r12
    194d:	4c 39 e2             	cmp    %r12,%rdx
    1950:	75 ed                	jne    193f <phase_6+0x7b>
    1952:	be 00 00 00 00       	mov    $0x0,%esi
    1957:	8b 4c b4 10          	mov    0x10(%rsp,%rsi,4),%ecx
    195b:	b8 01 00 00 00       	mov    $0x1,%eax
    1960:	48 8d 15 a9 38 00 00 	lea    0x38a9(%rip),%rdx        # 5210 <node1>
    1967:	83 f9 01             	cmp    $0x1,%ecx
    196a:	7e 0b                	jle    1977 <phase_6+0xb3>
    196c:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    1970:	83 c0 01             	add    $0x1,%eax
    1973:	39 c8                	cmp    %ecx,%eax
    1975:	75 f5                	jne    196c <phase_6+0xa8>
    1977:	48 89 54 f4 30       	mov    %rdx,0x30(%rsp,%rsi,8)
    197c:	48 83 c6 01          	add    $0x1,%rsi
    1980:	48 83 fe 06          	cmp    $0x6,%rsi
    1984:	75 d1                	jne    1957 <phase_6+0x93>
    1986:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
    198b:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
    1990:	48 89 43 08          	mov    %rax,0x8(%rbx)
    1994:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
    1999:	48 89 50 08          	mov    %rdx,0x8(%rax)
    199d:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
    19a2:	48 89 42 08          	mov    %rax,0x8(%rdx)
    19a6:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
    19ab:	48 89 50 08          	mov    %rdx,0x8(%rax)
    19af:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
    19b4:	48 89 42 08          	mov    %rax,0x8(%rdx)
    19b8:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
    19bf:	00 
    19c0:	bd 05 00 00 00       	mov    $0x5,%ebp
    19c5:	eb 35                	jmp    19fc <phase_6+0x138>
    19c7:	49 83 c7 01          	add    $0x1,%r15
    19cb:	49 83 c6 04          	add    $0x4,%r14
    19cf:	4c 89 f5             	mov    %r14,%rbp
    19d2:	41 8b 06             	mov    (%r14),%eax
    19d5:	83 e8 01             	sub    $0x1,%eax
    19d8:	83 f8 05             	cmp    $0x5,%eax
    19db:	0f 87 28 ff ff ff    	ja     1909 <phase_6+0x45>
    19e1:	41 83 ff 05          	cmp    $0x5,%r15d
    19e5:	0f 8f 46 ff ff ff    	jg     1931 <phase_6+0x6d>
    19eb:	4c 89 fb             	mov    %r15,%rbx
    19ee:	e9 2d ff ff ff       	jmp    1920 <phase_6+0x5c>
    19f3:	48 8b 5b 08          	mov    0x8(%rbx),%rbx
    19f7:	83 ed 01             	sub    $0x1,%ebp
    19fa:	74 11                	je     1a0d <phase_6+0x149>
    19fc:	48 8b 43 08          	mov    0x8(%rbx),%rax
    1a00:	8b 00                	mov    (%rax),%eax
    1a02:	39 03                	cmp    %eax,(%rbx)
    1a04:	7d ed                	jge    19f3 <phase_6+0x12f>
    1a06:	e8 87 02 00 00       	call   1c92 <explode_bomb>
    1a0b:	eb e6                	jmp    19f3 <phase_6+0x12f>
    1a0d:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
    1a12:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
    1a19:	00 00 
    1a1b:	75 0f                	jne    1a2c <phase_6+0x168>
    1a1d:	48 83 c4 78          	add    $0x78,%rsp
    1a21:	5b                   	pop    %rbx
    1a22:	5d                   	pop    %rbp
    1a23:	41 5c                	pop    %r12
    1a25:	41 5d                	pop    %r13
    1a27:	41 5e                	pop    %r14
    1a29:	41 5f                	pop    %r15
    1a2b:	c3                   	ret    
    1a2c:	e8 1f f8 ff ff       	call   1250 <__stack_chk_fail@plt>

0000000000001a31 <fun7>:
    1a31:	f3 0f 1e fa          	endbr64 
    1a35:	48 85 ff             	test   %rdi,%rdi
    1a38:	74 32                	je     1a6c <fun7+0x3b>
    1a3a:	48 83 ec 08          	sub    $0x8,%rsp
    1a3e:	8b 17                	mov    (%rdi),%edx
    1a40:	39 f2                	cmp    %esi,%edx
    1a42:	7f 0c                	jg     1a50 <fun7+0x1f>
    1a44:	b8 00 00 00 00       	mov    $0x0,%eax
    1a49:	75 12                	jne    1a5d <fun7+0x2c>
    1a4b:	48 83 c4 08          	add    $0x8,%rsp
    1a4f:	c3                   	ret    
    1a50:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    1a54:	e8 d8 ff ff ff       	call   1a31 <fun7>
    1a59:	01 c0                	add    %eax,%eax
    1a5b:	eb ee                	jmp    1a4b <fun7+0x1a>
    1a5d:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
    1a61:	e8 cb ff ff ff       	call   1a31 <fun7>
    1a66:	8d 44 00 01          	lea    0x1(%rax,%rax,1),%eax
    1a6a:	eb df                	jmp    1a4b <fun7+0x1a>
    1a6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1a71:	c3                   	ret    

0000000000001a72 <secret_phase>:
    1a72:	f3 0f 1e fa          	endbr64 
    1a76:	53                   	push   %rbx
    1a77:	e8 b3 02 00 00       	call   1d2f <read_line>
    1a7c:	48 89 c7             	mov    %rax,%rdi
    1a7f:	ba 0a 00 00 00       	mov    $0xa,%edx
    1a84:	be 00 00 00 00       	mov    $0x0,%esi
    1a89:	e8 52 f8 ff ff       	call   12e0 <strtol@plt>
    1a8e:	89 c3                	mov    %eax,%ebx
    1a90:	83 e8 01             	sub    $0x1,%eax
    1a93:	3d e8 03 00 00       	cmp    $0x3e8,%eax
    1a98:	77 26                	ja     1ac0 <secret_phase+0x4e>
    1a9a:	89 de                	mov    %ebx,%esi
    1a9c:	48 8d 3d 8d 36 00 00 	lea    0x368d(%rip),%rdi        # 5130 <n1>
    1aa3:	e8 89 ff ff ff       	call   1a31 <fun7>
    1aa8:	83 f8 07             	cmp    $0x7,%eax
    1aab:	75 1a                	jne    1ac7 <secret_phase+0x55>
    1aad:	48 8d 3d 24 16 00 00 	lea    0x1624(%rip),%rdi        # 30d8 <_IO_stdin_used+0xd8>
    1ab4:	e8 67 f7 ff ff       	call   1220 <puts@plt>
    1ab9:	e8 c5 03 00 00       	call   1e83 <phase_defused>
    1abe:	5b                   	pop    %rbx
    1abf:	c3                   	ret    
    1ac0:	e8 cd 01 00 00       	call   1c92 <explode_bomb>
    1ac5:	eb d3                	jmp    1a9a <secret_phase+0x28>
    1ac7:	e8 c6 01 00 00       	call   1c92 <explode_bomb>
    1acc:	eb df                	jmp    1aad <secret_phase+0x3b>

0000000000001ace <sig_handler>:
    1ace:	f3 0f 1e fa          	endbr64 
    1ad2:	50                   	push   %rax
    1ad3:	58                   	pop    %rax
    1ad4:	48 83 ec 08          	sub    $0x8,%rsp
    1ad8:	48 8d 3d a1 16 00 00 	lea    0x16a1(%rip),%rdi        # 3180 <array.0+0x40>
    1adf:	e8 3c f7 ff ff       	call   1220 <puts@plt>
    1ae4:	bf 03 00 00 00       	mov    $0x3,%edi
    1ae9:	e8 72 f8 ff ff       	call   1360 <sleep@plt>
    1aee:	48 8d 35 25 18 00 00 	lea    0x1825(%rip),%rsi        # 331a <array.0+0x1da>
    1af5:	bf 01 00 00 00       	mov    $0x1,%edi
    1afa:	b8 00 00 00 00       	mov    $0x0,%eax
    1aff:	e8 0c f8 ff ff       	call   1310 <__printf_chk@plt>
    1b04:	48 8b 3d 55 3b 00 00 	mov    0x3b55(%rip),%rdi        # 5660 <stdout@GLIBC_2.2.5>
    1b0b:	e8 e0 f7 ff ff       	call   12f0 <fflush@plt>
    1b10:	bf 01 00 00 00       	mov    $0x1,%edi
    1b15:	e8 46 f8 ff ff       	call   1360 <sleep@plt>
    1b1a:	48 8d 3d 01 18 00 00 	lea    0x1801(%rip),%rdi        # 3322 <array.0+0x1e2>
    1b21:	e8 fa f6 ff ff       	call   1220 <puts@plt>
    1b26:	bf 10 00 00 00       	mov    $0x10,%edi
    1b2b:	e8 00 f8 ff ff       	call   1330 <exit@plt>

0000000000001b30 <invalid_phase>:
    1b30:	f3 0f 1e fa          	endbr64 
    1b34:	50                   	push   %rax
    1b35:	58                   	pop    %rax
    1b36:	48 83 ec 08          	sub    $0x8,%rsp
    1b3a:	48 89 fa             	mov    %rdi,%rdx
    1b3d:	48 8d 35 e6 17 00 00 	lea    0x17e6(%rip),%rsi        # 332a <array.0+0x1ea>
    1b44:	bf 01 00 00 00       	mov    $0x1,%edi
    1b49:	b8 00 00 00 00       	mov    $0x0,%eax
    1b4e:	e8 bd f7 ff ff       	call   1310 <__printf_chk@plt>
    1b53:	bf 08 00 00 00       	mov    $0x8,%edi
    1b58:	e8 d3 f7 ff ff       	call   1330 <exit@plt>

0000000000001b5d <string_length>:
    1b5d:	f3 0f 1e fa          	endbr64 
    1b61:	80 3f 00             	cmpb   $0x0,(%rdi)
    1b64:	74 12                	je     1b78 <string_length+0x1b>
    1b66:	b8 00 00 00 00       	mov    $0x0,%eax
    1b6b:	48 83 c7 01          	add    $0x1,%rdi
    1b6f:	83 c0 01             	add    $0x1,%eax
    1b72:	80 3f 00             	cmpb   $0x0,(%rdi)
    1b75:	75 f4                	jne    1b6b <string_length+0xe>
    1b77:	c3                   	ret    
    1b78:	b8 00 00 00 00       	mov    $0x0,%eax
    1b7d:	c3                   	ret    

#以下函数实现的功能是：比较两个字符串是否相等，相等则返回0，不相等则返回1
0000000000001b7e <strings_not_equal>:
    1b7e:	f3 0f 1e fa          	endbr64 
    1b82:	41 54                	push   %r12
    1b84:	55                   	push   %rbp
    1b85:	53                   	push   %rbx
    1b86:	48 89 fb             	mov    %rdi,%rbx
    1b89:	48 89 f5             	mov    %rsi,%rbp
    1b8c:	e8 cc ff ff ff       	call   1b5d <string_length>
    1b91:	41 89 c4             	mov    %eax,%r12d
    1b94:	48 89 ef             	mov    %rbp,%rdi
    1b97:	e8 c1 ff ff ff       	call   1b5d <string_length>
    1b9c:	89 c2                	mov    %eax,%edx
    1b9e:	b8 01 00 00 00       	mov    $0x1,%eax
    1ba3:	41 39 d4             	cmp    %edx,%r12d
    1ba6:	75 31                	jne    1bd9 <strings_not_equal+0x5b>
    1ba8:	0f b6 13             	movzbl (%rbx),%edx
    1bab:	84 d2                	test   %dl,%dl
    1bad:	74 1e                	je     1bcd <strings_not_equal+0x4f>
    1baf:	b8 00 00 00 00       	mov    $0x0,%eax
    1bb4:	38 54 05 00          	cmp    %dl,0x0(%rbp,%rax,1)
    1bb8:	75 1a                	jne    1bd4 <strings_not_equal+0x56>
    1bba:	48 83 c0 01          	add    $0x1,%rax
    1bbe:	0f b6 14 03          	movzbl (%rbx,%rax,1),%edx
    1bc2:	84 d2                	test   %dl,%dl
    1bc4:	75 ee                	jne    1bb4 <strings_not_equal+0x36>
    1bc6:	b8 00 00 00 00       	mov    $0x0,%eax
    1bcb:	eb 0c                	jmp    1bd9 <strings_not_equal+0x5b>
    1bcd:	b8 00 00 00 00       	mov    $0x0,%eax
    1bd2:	eb 05                	jmp    1bd9 <strings_not_equal+0x5b>
    1bd4:	b8 01 00 00 00       	mov    $0x1,%eax
    1bd9:	5b                   	pop    %rbx
    1bda:	5d                   	pop    %rbp
    1bdb:	41 5c                	pop    %r12
    1bdd:	c3                   	ret    

0000000000001bde <initialize_bomb>:
    1bde:	f3 0f 1e fa          	endbr64 
    1be2:	48 83 ec 08          	sub    $0x8,%rsp
    1be6:	48 8d 35 e1 fe ff ff 	lea    -0x11f(%rip),%rsi        # 1ace <sig_handler>
    1bed:	bf 02 00 00 00       	mov    $0x2,%edi
    1bf2:	e8 b9 f6 ff ff       	call   12b0 <signal@plt>
    1bf7:	48 83 c4 08          	add    $0x8,%rsp
    1bfb:	c3                   	ret    

0000000000001bfc <initialize_bomb_solve>:
    1bfc:	f3 0f 1e fa          	endbr64 
    1c00:	c3                   	ret    

0000000000001c01 <blank_line>:
    1c01:	f3 0f 1e fa          	endbr64 
    1c05:	55                   	push   %rbp
    1c06:	53                   	push   %rbx
    1c07:	48 83 ec 08          	sub    $0x8,%rsp
    1c0b:	48 89 fd             	mov    %rdi,%rbp
    1c0e:	0f b6 5d 00          	movzbl 0x0(%rbp),%ebx
    1c12:	84 db                	test   %bl,%bl
    1c14:	74 1e                	je     1c34 <blank_line+0x33>
    1c16:	e8 55 f7 ff ff       	call   1370 <__ctype_b_loc@plt>
    1c1b:	48 83 c5 01          	add    $0x1,%rbp
    1c1f:	48 0f be db          	movsbq %bl,%rbx
    1c23:	48 8b 00             	mov    (%rax),%rax
    1c26:	f6 44 58 01 20       	testb  $0x20,0x1(%rax,%rbx,2)
    1c2b:	75 e1                	jne    1c0e <blank_line+0xd>
    1c2d:	b8 00 00 00 00       	mov    $0x0,%eax
    1c32:	eb 05                	jmp    1c39 <blank_line+0x38>
    1c34:	b8 01 00 00 00       	mov    $0x1,%eax
    1c39:	48 83 c4 08          	add    $0x8,%rsp
    1c3d:	5b                   	pop    %rbx
    1c3e:	5d                   	pop    %rbp
    1c3f:	c3                   	ret    

0000000000001c40 <skip>:
    1c40:	f3 0f 1e fa          	endbr64 
    1c44:	55                   	push   %rbp
    1c45:	53                   	push   %rbx
    1c46:	48 83 ec 08          	sub    $0x8,%rsp
    1c4a:	48 8d 2d af 3a 00 00 	lea    0x3aaf(%rip),%rbp        # 5700 <input_strings>
    1c51:	48 63 05 9c 3a 00 00 	movslq 0x3a9c(%rip),%rax        # 56f4 <num_input_strings>
    1c58:	48 8d 3c 80          	lea    (%rax,%rax,4),%rdi
    1c5c:	48 c1 e7 04          	shl    $0x4,%rdi
    1c60:	48 01 ef             	add    %rbp,%rdi
    1c63:	48 8b 15 26 3a 00 00 	mov    0x3a26(%rip),%rdx        # 5690 <infile>
    1c6a:	be 50 00 00 00       	mov    $0x50,%esi
    1c6f:	e8 1c f6 ff ff       	call   1290 <fgets@plt>
    1c74:	48 89 c3             	mov    %rax,%rbx
    1c77:	48 85 c0             	test   %rax,%rax
    1c7a:	74 0c                	je     1c88 <skip+0x48>
    1c7c:	48 89 c7             	mov    %rax,%rdi
    1c7f:	e8 7d ff ff ff       	call   1c01 <blank_line>
    1c84:	85 c0                	test   %eax,%eax
    1c86:	75 c9                	jne    1c51 <skip+0x11>
    1c88:	48 89 d8             	mov    %rbx,%rax
    1c8b:	48 83 c4 08          	add    $0x8,%rsp
    1c8f:	5b                   	pop    %rbx
    1c90:	5d                   	pop    %rbp
    1c91:	c3                   	ret    

0000000000001c92 <explode_bomb>:
    1c92:	f3 0f 1e fa          	endbr64 
    1c96:	50                   	push   %rax
    1c97:	58                   	pop    %rax
    1c98:	48 83 ec 08          	sub    $0x8,%rsp
    1c9c:	48 8d 3d 98 16 00 00 	lea    0x1698(%rip),%rdi        # 333b <array.0+0x1fb>
    1ca3:	e8 78 f5 ff ff       	call   1220 <puts@plt>
    1ca8:	8b 15 46 3a 00 00    	mov    0x3a46(%rip),%edx        # 56f4 <num_input_strings>
    1cae:	48 8d 35 03 15 00 00 	lea    0x1503(%rip),%rsi        # 31b8 <array.0+0x78>
    1cb5:	bf 01 00 00 00       	mov    $0x1,%edi
    1cba:	b8 00 00 00 00       	mov    $0x0,%eax
    1cbf:	e8 4c f6 ff ff       	call   1310 <__printf_chk@plt>
    1cc4:	8b 15 26 3a 00 00    	mov    0x3a26(%rip),%edx        # 56f0 <score>
    1cca:	48 8d 35 0f 15 00 00 	lea    0x150f(%rip),%rsi        # 31e0 <array.0+0xa0>
    1cd1:	bf 01 00 00 00       	mov    $0x1,%edi
    1cd6:	b8 00 00 00 00       	mov    $0x0,%eax
    1cdb:	e8 30 f6 ff ff       	call   1310 <__printf_chk@plt>
    1ce0:	bf 08 00 00 00       	mov    $0x8,%edi
    1ce5:	e8 46 f6 ff ff       	call   1330 <exit@plt>

0000000000001cea <read_six_numbers>:
    1cea:	f3 0f 1e fa          	endbr64 
    1cee:	48 83 ec 08          	sub    $0x8,%rsp
    1cf2:	48 89 f2             	mov    %rsi,%rdx
    1cf5:	48 8d 4e 04          	lea    0x4(%rsi),%rcx
    1cf9:	48 8d 46 14          	lea    0x14(%rsi),%rax
    1cfd:	50                   	push   %rax
    1cfe:	48 8d 46 10          	lea    0x10(%rsi),%rax
    1d02:	50                   	push   %rax
    1d03:	4c 8d 4e 0c          	lea    0xc(%rsi),%r9
    1d07:	4c 8d 46 08          	lea    0x8(%rsi),%r8
    1d0b:	48 8d 35 32 16 00 00 	lea    0x1632(%rip),%rsi        # 3344 <array.0+0x204>
    1d12:	b8 00 00 00 00       	mov    $0x0,%eax
    1d17:	e8 e4 f5 ff ff       	call   1300 <__isoc99_sscanf@plt>
    1d1c:	48 83 c4 10          	add    $0x10,%rsp
    1d20:	83 f8 05             	cmp    $0x5,%eax
    1d23:	7e 05                	jle    1d2a <read_six_numbers+0x40>
    1d25:	48 83 c4 08          	add    $0x8,%rsp
    1d29:	c3                   	ret    
    1d2a:	e8 63 ff ff ff       	call   1c92 <explode_bomb>

0000000000001d2f <read_line>:
    1d2f:	f3 0f 1e fa          	endbr64 
    1d33:	55                   	push   %rbp
    1d34:	53                   	push   %rbx
    1d35:	48 83 ec 08          	sub    $0x8,%rsp
    1d39:	b8 00 00 00 00       	mov    $0x0,%eax
    1d3e:	e8 fd fe ff ff       	call   1c40 <skip>
    1d43:	48 85 c0             	test   %rax,%rax
    1d46:	74 5d                	je     1da5 <read_line+0x76>
    1d48:	8b 2d a6 39 00 00    	mov    0x39a6(%rip),%ebp        # 56f4 <num_input_strings>
    1d4e:	48 63 c5             	movslq %ebp,%rax
    1d51:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
    1d55:	48 c1 e3 04          	shl    $0x4,%rbx
    1d59:	48 8d 05 a0 39 00 00 	lea    0x39a0(%rip),%rax        # 5700 <input_strings>
    1d60:	48 01 c3             	add    %rax,%rbx
    1d63:	48 89 df             	mov    %rbx,%rdi
    1d66:	e8 d5 f4 ff ff       	call   1240 <strlen@plt>
    1d6b:	83 f8 4e             	cmp    $0x4e,%eax
    1d6e:	0f 8f c5 00 00 00    	jg     1e39 <read_line+0x10a>
    1d74:	83 e8 01             	sub    $0x1,%eax
    1d77:	48 98                	cltq   
    1d79:	48 63 d5             	movslq %ebp,%rdx
    1d7c:	48 8d 0c 92          	lea    (%rdx,%rdx,4),%rcx
    1d80:	48 c1 e1 04          	shl    $0x4,%rcx
    1d84:	48 8d 15 75 39 00 00 	lea    0x3975(%rip),%rdx        # 5700 <input_strings>
    1d8b:	48 01 ca             	add    %rcx,%rdx
    1d8e:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
    1d92:	83 c5 01             	add    $0x1,%ebp
    1d95:	89 2d 59 39 00 00    	mov    %ebp,0x3959(%rip)        # 56f4 <num_input_strings>
    1d9b:	48 89 d8             	mov    %rbx,%rax
    1d9e:	48 83 c4 08          	add    $0x8,%rsp
    1da2:	5b                   	pop    %rbx
    1da3:	5d                   	pop    %rbp
    1da4:	c3                   	ret    
    1da5:	48 8b 05 c4 38 00 00 	mov    0x38c4(%rip),%rax        # 5670 <stdin@GLIBC_2.2.5>
    1dac:	48 39 05 dd 38 00 00 	cmp    %rax,0x38dd(%rip)        # 5690 <infile>
    1db3:	74 1b                	je     1dd0 <read_line+0xa1>
    1db5:	48 8d 3d b8 15 00 00 	lea    0x15b8(%rip),%rdi        # 3374 <array.0+0x234>
    1dbc:	e8 2f f4 ff ff       	call   11f0 <getenv@plt>
    1dc1:	48 85 c0             	test   %rax,%rax
    1dc4:	74 3c                	je     1e02 <read_line+0xd3>
    1dc6:	bf 00 00 00 00       	mov    $0x0,%edi
    1dcb:	e8 60 f5 ff ff       	call   1330 <exit@plt>
    1dd0:	48 8d 3d 7f 15 00 00 	lea    0x157f(%rip),%rdi        # 3356 <array.0+0x216>
    1dd7:	e8 44 f4 ff ff       	call   1220 <puts@plt>
    1ddc:	8b 15 0e 39 00 00    	mov    0x390e(%rip),%edx        # 56f0 <score>
    1de2:	48 8d 35 27 14 00 00 	lea    0x1427(%rip),%rsi        # 3210 <array.0+0xd0>
    1de9:	bf 01 00 00 00       	mov    $0x1,%edi
    1dee:	b8 00 00 00 00       	mov    $0x0,%eax
    1df3:	e8 18 f5 ff ff       	call   1310 <__printf_chk@plt>
    1df8:	bf 08 00 00 00       	mov    $0x8,%edi
    1dfd:	e8 2e f5 ff ff       	call   1330 <exit@plt>
    1e02:	48 8b 05 67 38 00 00 	mov    0x3867(%rip),%rax        # 5670 <stdin@GLIBC_2.2.5>
    1e09:	48 89 05 80 38 00 00 	mov    %rax,0x3880(%rip)        # 5690 <infile>
    1e10:	b8 00 00 00 00       	mov    $0x0,%eax
    1e15:	e8 26 fe ff ff       	call   1c40 <skip>
    1e1a:	48 85 c0             	test   %rax,%rax
    1e1d:	0f 85 25 ff ff ff    	jne    1d48 <read_line+0x19>
    1e23:	48 8d 3d 2c 15 00 00 	lea    0x152c(%rip),%rdi        # 3356 <array.0+0x216>
    1e2a:	e8 f1 f3 ff ff       	call   1220 <puts@plt>
    1e2f:	bf 00 00 00 00       	mov    $0x0,%edi
    1e34:	e8 f7 f4 ff ff       	call   1330 <exit@plt>
    1e39:	48 8d 3d 3f 15 00 00 	lea    0x153f(%rip),%rdi        # 337f <array.0+0x23f>
    1e40:	e8 db f3 ff ff       	call   1220 <puts@plt>
    1e45:	8b 05 a9 38 00 00    	mov    0x38a9(%rip),%eax        # 56f4 <num_input_strings>
    1e4b:	8d 50 01             	lea    0x1(%rax),%edx
    1e4e:	89 15 a0 38 00 00    	mov    %edx,0x38a0(%rip)        # 56f4 <num_input_strings>
    1e54:	48 98                	cltq   
    1e56:	48 6b c0 50          	imul   $0x50,%rax,%rax
    1e5a:	48 8d 15 9f 38 00 00 	lea    0x389f(%rip),%rdx        # 5700 <input_strings>
    1e61:	48 be 2a 2a 2a 74 72 	movabs $0x636e7572742a2a2a,%rsi
    1e68:	75 6e 63 
    1e6b:	48 bf 61 74 65 64 2a 	movabs $0x2a2a2a64657461,%rdi
    1e72:	2a 2a 00 
    1e75:	48 89 34 02          	mov    %rsi,(%rdx,%rax,1)
    1e79:	48 89 7c 02 08       	mov    %rdi,0x8(%rdx,%rax,1)
    1e7e:	e8 0f fe ff ff       	call   1c92 <explode_bomb>

0000000000001e83 <phase_defused>:
    1e83:	f3 0f 1e fa          	endbr64 
    1e87:	48 83 ec 78          	sub    $0x78,%rsp
    1e8b:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    1e92:	00 00 
    1e94:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
    1e99:	31 c0                	xor    %eax,%eax
    1e9b:	8b 15 53 38 00 00    	mov    0x3853(%rip),%edx        # 56f4 <num_input_strings>
    1ea1:	83 fa 03             	cmp    $0x3,%edx
    1ea4:	7f 5b                	jg     1f01 <phase_defused+0x7e>
    1ea6:	83 05 43 38 00 00 1e 	addl   $0x1e,0x3843(%rip)        # 56f0 <score>
    1ead:	48 8d 35 e6 14 00 00 	lea    0x14e6(%rip),%rsi        # 339a <array.0+0x25a>
    1eb4:	bf 01 00 00 00       	mov    $0x1,%edi
    1eb9:	b8 00 00 00 00       	mov    $0x0,%eax
    1ebe:	e8 4d f4 ff ff       	call   1310 <__printf_chk@plt>
    1ec3:	8b 15 27 38 00 00    	mov    0x3827(%rip),%edx        # 56f0 <score>
    1ec9:	48 8d 35 40 13 00 00 	lea    0x1340(%rip),%rsi        # 3210 <array.0+0xd0>
    1ed0:	bf 01 00 00 00       	mov    $0x1,%edi
    1ed5:	b8 00 00 00 00       	mov    $0x0,%eax
    1eda:	e8 31 f4 ff ff       	call   1310 <__printf_chk@plt>
    1edf:	83 3d 0e 38 00 00 06 	cmpl   $0x6,0x380e(%rip)        # 56f4 <num_input_strings>
    1ee6:	74 27                	je     1f0f <phase_defused+0x8c>
    1ee8:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
    1eed:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
    1ef4:	00 00 
    1ef6:	0f 85 9e 00 00 00    	jne    1f9a <phase_defused+0x117>
    1efc:	48 83 c4 78          	add    $0x78,%rsp
    1f00:	c3                   	ret    
    1f01:	83 fa 04             	cmp    $0x4,%edx
    1f04:	75 a7                	jne    1ead <phase_defused+0x2a>
    1f06:	83 05 e3 37 00 00 0a 	addl   $0xa,0x37e3(%rip)        # 56f0 <score>
    1f0d:	eb 9e                	jmp    1ead <phase_defused+0x2a>
    1f0f:	48 8d 4c 24 0c       	lea    0xc(%rsp),%rcx
    1f14:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
    1f19:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
    1f1e:	48 8d 35 93 14 00 00 	lea    0x1493(%rip),%rsi        # 33b8 <array.0+0x278>
    1f25:	48 8d 3d c4 38 00 00 	lea    0x38c4(%rip),%rdi        # 57f0 <input_strings+0xf0>
    1f2c:	b8 00 00 00 00       	mov    $0x0,%eax
    1f31:	e8 ca f3 ff ff       	call   1300 <__isoc99_sscanf@plt>
    1f36:	83 f8 03             	cmp    $0x3,%eax
    1f39:	74 1a                	je     1f55 <phase_defused+0xd2>
    1f3b:	48 8d 3d ae 13 00 00 	lea    0x13ae(%rip),%rdi        # 32f0 <array.0+0x1b0>
    1f42:	e8 d9 f2 ff ff       	call   1220 <puts@plt>
    1f47:	48 8d 3d 7a 14 00 00 	lea    0x147a(%rip),%rdi        # 33c8 <array.0+0x288>
    1f4e:	e8 cd f2 ff ff       	call   1220 <puts@plt>
    1f53:	eb 93                	jmp    1ee8 <phase_defused+0x65>
    1f55:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
    1f5a:	48 8d 35 60 14 00 00 	lea    0x1460(%rip),%rsi        # 33c1 <array.0+0x281>
    1f61:	e8 18 fc ff ff       	call   1b7e <strings_not_equal>
    1f66:	85 c0                	test   %eax,%eax
    1f68:	75 d1                	jne    1f3b <phase_defused+0xb8>
    1f6a:	48 8d 3d c7 12 00 00 	lea    0x12c7(%rip),%rdi        # 3238 <array.0+0xf8>
    1f71:	e8 aa f2 ff ff       	call   1220 <puts@plt>
    1f76:	48 8d 3d e3 12 00 00 	lea    0x12e3(%rip),%rdi        # 3260 <array.0+0x120>
    1f7d:	e8 9e f2 ff ff       	call   1220 <puts@plt>
    1f82:	b8 00 00 00 00       	mov    $0x0,%eax
    1f87:	e8 e6 fa ff ff       	call   1a72 <secret_phase>
    1f8c:	48 8d 3d 05 13 00 00 	lea    0x1305(%rip),%rdi        # 3298 <array.0+0x158>
    1f93:	e8 88 f2 ff ff       	call   1220 <puts@plt>
    1f98:	eb a1                	jmp    1f3b <phase_defused+0xb8>
    1f9a:	e8 b1 f2 ff ff       	call   1250 <__stack_chk_fail@plt>

0000000000001f9f <sigalrm_handler>:
    1f9f:	f3 0f 1e fa          	endbr64 
    1fa3:	50                   	push   %rax
    1fa4:	58                   	pop    %rax
    1fa5:	48 83 ec 08          	sub    $0x8,%rsp
    1fa9:	b9 00 00 00 00       	mov    $0x0,%ecx
    1fae:	48 8d 15 8b 14 00 00 	lea    0x148b(%rip),%rdx        # 3440 <array.0+0x300>
    1fb5:	be 01 00 00 00       	mov    $0x1,%esi
    1fba:	48 8b 3d bf 36 00 00 	mov    0x36bf(%rip),%rdi        # 5680 <stderr@GLIBC_2.2.5>
    1fc1:	b8 00 00 00 00       	mov    $0x0,%eax
    1fc6:	e8 85 f3 ff ff       	call   1350 <__fprintf_chk@plt>
    1fcb:	bf 01 00 00 00       	mov    $0x1,%edi
    1fd0:	e8 5b f3 ff ff       	call   1330 <exit@plt>

0000000000001fd5 <rio_readlineb>:
    1fd5:	41 56                	push   %r14
    1fd7:	41 55                	push   %r13
    1fd9:	41 54                	push   %r12
    1fdb:	55                   	push   %rbp
    1fdc:	53                   	push   %rbx
    1fdd:	49 89 f4             	mov    %rsi,%r12
    1fe0:	48 83 fa 01          	cmp    $0x1,%rdx
    1fe4:	0f 86 92 00 00 00    	jbe    207c <rio_readlineb+0xa7>
    1fea:	48 89 fb             	mov    %rdi,%rbx
    1fed:	4c 8d 74 16 ff       	lea    -0x1(%rsi,%rdx,1),%r14
    1ff2:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    1ff8:	48 8d 6f 10          	lea    0x10(%rdi),%rbp
    1ffc:	eb 56                	jmp    2054 <rio_readlineb+0x7f>
    1ffe:	e8 fd f1 ff ff       	call   1200 <__errno_location@plt>
    2003:	83 38 04             	cmpl   $0x4,(%rax)
    2006:	75 55                	jne    205d <rio_readlineb+0x88>
    2008:	ba 00 20 00 00       	mov    $0x2000,%edx
    200d:	48 89 ee             	mov    %rbp,%rsi
    2010:	8b 3b                	mov    (%rbx),%edi
    2012:	e8 69 f2 ff ff       	call   1280 <read@plt>
    2017:	89 c2                	mov    %eax,%edx
    2019:	89 43 04             	mov    %eax,0x4(%rbx)
    201c:	85 c0                	test   %eax,%eax
    201e:	78 de                	js     1ffe <rio_readlineb+0x29>
    2020:	85 c0                	test   %eax,%eax
    2022:	74 42                	je     2066 <rio_readlineb+0x91>
    2024:	48 89 6b 08          	mov    %rbp,0x8(%rbx)
    2028:	48 8b 43 08          	mov    0x8(%rbx),%rax
    202c:	0f b6 08             	movzbl (%rax),%ecx
    202f:	48 83 c0 01          	add    $0x1,%rax
    2033:	48 89 43 08          	mov    %rax,0x8(%rbx)
    2037:	83 ea 01             	sub    $0x1,%edx
    203a:	89 53 04             	mov    %edx,0x4(%rbx)
    203d:	49 83 c4 01          	add    $0x1,%r12
    2041:	41 88 4c 24 ff       	mov    %cl,-0x1(%r12)
    2046:	80 f9 0a             	cmp    $0xa,%cl
    2049:	74 3c                	je     2087 <rio_readlineb+0xb2>
    204b:	41 83 c5 01          	add    $0x1,%r13d
    204f:	4d 39 f4             	cmp    %r14,%r12
    2052:	74 30                	je     2084 <rio_readlineb+0xaf>
    2054:	8b 53 04             	mov    0x4(%rbx),%edx
    2057:	85 d2                	test   %edx,%edx
    2059:	7e ad                	jle    2008 <rio_readlineb+0x33>
    205b:	eb cb                	jmp    2028 <rio_readlineb+0x53>
    205d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    2064:	eb 05                	jmp    206b <rio_readlineb+0x96>
    2066:	b8 00 00 00 00       	mov    $0x0,%eax
    206b:	85 c0                	test   %eax,%eax
    206d:	75 29                	jne    2098 <rio_readlineb+0xc3>
    206f:	b8 00 00 00 00       	mov    $0x0,%eax
    2074:	41 83 fd 01          	cmp    $0x1,%r13d
    2078:	75 0d                	jne    2087 <rio_readlineb+0xb2>
    207a:	eb 13                	jmp    208f <rio_readlineb+0xba>
    207c:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    2082:	eb 03                	jmp    2087 <rio_readlineb+0xb2>
    2084:	4d 89 f4             	mov    %r14,%r12
    2087:	41 c6 04 24 00       	movb   $0x0,(%r12)
    208c:	49 63 c5             	movslq %r13d,%rax
    208f:	5b                   	pop    %rbx
    2090:	5d                   	pop    %rbp
    2091:	41 5c                	pop    %r12
    2093:	41 5d                	pop    %r13
    2095:	41 5e                	pop    %r14
    2097:	c3                   	ret    
    2098:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    209f:	eb ee                	jmp    208f <rio_readlineb+0xba>

00000000000020a1 <submitr>:
    20a1:	f3 0f 1e fa          	endbr64 
    20a5:	41 57                	push   %r15
    20a7:	41 56                	push   %r14
    20a9:	41 55                	push   %r13
    20ab:	41 54                	push   %r12
    20ad:	55                   	push   %rbp
    20ae:	53                   	push   %rbx
    20af:	4c 8d 9c 24 00 60 ff 	lea    -0xa000(%rsp),%r11
    20b6:	ff 
    20b7:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
    20be:	48 83 0c 24 00       	orq    $0x0,(%rsp)
    20c3:	4c 39 dc             	cmp    %r11,%rsp
    20c6:	75 ef                	jne    20b7 <submitr+0x16>
    20c8:	48 83 ec 78          	sub    $0x78,%rsp
    20cc:	49 89 fd             	mov    %rdi,%r13
    20cf:	89 f5                	mov    %esi,%ebp
    20d1:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
    20d6:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
    20db:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
    20e0:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
    20e5:	48 8b 9c 24 b0 a0 00 	mov    0xa0b0(%rsp),%rbx
    20ec:	00 
    20ed:	4c 8b bc 24 b8 a0 00 	mov    0xa0b8(%rsp),%r15
    20f4:	00 
    20f5:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    20fc:	00 00 
    20fe:	48 89 84 24 68 a0 00 	mov    %rax,0xa068(%rsp)
    2105:	00 
    2106:	31 c0                	xor    %eax,%eax
    2108:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%rsp)
    210f:	00 
    2110:	ba 00 00 00 00       	mov    $0x0,%edx
    2115:	be 01 00 00 00       	mov    $0x1,%esi
    211a:	bf 02 00 00 00       	mov    $0x2,%edi
    211f:	e8 6c f2 ff ff       	call   1390 <socket@plt>
    2124:	85 c0                	test   %eax,%eax
    2126:	0f 88 12 01 00 00    	js     223e <submitr+0x19d>
    212c:	41 89 c4             	mov    %eax,%r12d
    212f:	4c 89 ef             	mov    %r13,%rdi
    2132:	e8 89 f1 ff ff       	call   12c0 <gethostbyname@plt>
    2137:	48 85 c0             	test   %rax,%rax
    213a:	0f 84 4e 01 00 00    	je     228e <submitr+0x1ed>
    2140:	4c 8d 6c 24 40       	lea    0x40(%rsp),%r13
    2145:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
    214c:	00 00 
    214e:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
    2155:	00 00 
    2157:	66 c7 44 24 40 02 00 	movw   $0x2,0x40(%rsp)
    215e:	48 63 50 14          	movslq 0x14(%rax),%rdx
    2162:	48 8b 40 18          	mov    0x18(%rax),%rax
    2166:	48 8d 7c 24 44       	lea    0x44(%rsp),%rdi
    216b:	b9 0c 00 00 00       	mov    $0xc,%ecx
    2170:	48 8b 30             	mov    (%rax),%rsi
    2173:	e8 58 f1 ff ff       	call   12d0 <__memmove_chk@plt>
    2178:	66 c1 c5 08          	rol    $0x8,%bp
    217c:	66 89 6c 24 42       	mov    %bp,0x42(%rsp)
    2181:	ba 10 00 00 00       	mov    $0x10,%edx
    2186:	4c 89 ee             	mov    %r13,%rsi
    2189:	44 89 e7             	mov    %r12d,%edi
    218c:	e8 af f1 ff ff       	call   1340 <connect@plt>
    2191:	85 c0                	test   %eax,%eax
    2193:	0f 88 60 01 00 00    	js     22f9 <submitr+0x258>
    2199:	48 89 df             	mov    %rbx,%rdi
    219c:	e8 9f f0 ff ff       	call   1240 <strlen@plt>
    21a1:	48 89 c5             	mov    %rax,%rbp
    21a4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
    21a9:	e8 92 f0 ff ff       	call   1240 <strlen@plt>
    21ae:	49 89 c6             	mov    %rax,%r14
    21b1:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
    21b6:	e8 85 f0 ff ff       	call   1240 <strlen@plt>
    21bb:	49 89 c5             	mov    %rax,%r13
    21be:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
    21c3:	e8 78 f0 ff ff       	call   1240 <strlen@plt>
    21c8:	48 89 c2             	mov    %rax,%rdx
    21cb:	4b 8d 84 2e 80 00 00 	lea    0x80(%r14,%r13,1),%rax
    21d2:	00 
    21d3:	48 01 d0             	add    %rdx,%rax
    21d6:	48 8d 54 6d 00       	lea    0x0(%rbp,%rbp,2),%rdx
    21db:	48 01 d0             	add    %rdx,%rax
    21de:	48 3d 00 20 00 00    	cmp    $0x2000,%rax
    21e4:	0f 87 6c 01 00 00    	ja     2356 <submitr+0x2b5>
    21ea:	48 8d 94 24 60 40 00 	lea    0x4060(%rsp),%rdx
    21f1:	00 
    21f2:	b9 00 04 00 00       	mov    $0x400,%ecx
    21f7:	b8 00 00 00 00       	mov    $0x0,%eax
    21fc:	48 89 d7             	mov    %rdx,%rdi
    21ff:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    2202:	48 89 df             	mov    %rbx,%rdi
    2205:	e8 36 f0 ff ff       	call   1240 <strlen@plt>
    220a:	85 c0                	test   %eax,%eax
    220c:	0f 84 07 05 00 00    	je     2719 <submitr+0x678>
    2212:	8d 40 ff             	lea    -0x1(%rax),%eax
    2215:	4c 8d 6c 03 01       	lea    0x1(%rbx,%rax,1),%r13
    221a:	48 8d ac 24 60 40 00 	lea    0x4060(%rsp),%rbp
    2221:	00 
    2222:	48 8d 84 24 60 80 00 	lea    0x8060(%rsp),%rax
    2229:	00 
    222a:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
    222f:	49 be d9 ff 00 00 00 	movabs $0x2000000000ffd9,%r14
    2236:	00 20 00 
    2239:	e9 a6 01 00 00       	jmp    23e4 <submitr+0x343>
    223e:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
    2245:	3a 20 43 
    2248:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
    224f:	20 75 6e 
    2252:	49 89 07             	mov    %rax,(%r15)
    2255:	49 89 57 08          	mov    %rdx,0x8(%r15)
    2259:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    2260:	74 6f 20 
    2263:	48 ba 63 72 65 61 74 	movabs $0x7320657461657263,%rdx
    226a:	65 20 73 
    226d:	49 89 47 10          	mov    %rax,0x10(%r15)
    2271:	49 89 57 18          	mov    %rdx,0x18(%r15)
    2275:	41 c7 47 20 6f 63 6b 	movl   $0x656b636f,0x20(%r15)
    227c:	65 
    227d:	66 41 c7 47 24 74 00 	movw   $0x74,0x24(%r15)
    2284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2289:	e9 03 03 00 00       	jmp    2591 <submitr+0x4f0>
    228e:	48 b8 45 72 72 6f 72 	movabs $0x44203a726f727245,%rax
    2295:	3a 20 44 
    2298:	48 ba 4e 53 20 69 73 	movabs $0x6e7520736920534e,%rdx
    229f:	20 75 6e 
    22a2:	49 89 07             	mov    %rax,(%r15)
    22a5:	49 89 57 08          	mov    %rdx,0x8(%r15)
    22a9:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    22b0:	74 6f 20 
    22b3:	48 ba 72 65 73 6f 6c 	movabs $0x2065766c6f736572,%rdx
    22ba:	76 65 20 
    22bd:	49 89 47 10          	mov    %rax,0x10(%r15)
    22c1:	49 89 57 18          	mov    %rdx,0x18(%r15)
    22c5:	48 b8 73 65 72 76 65 	movabs $0x6120726576726573,%rax
    22cc:	72 20 61 
    22cf:	49 89 47 20          	mov    %rax,0x20(%r15)
    22d3:	41 c7 47 28 64 64 72 	movl   $0x65726464,0x28(%r15)
    22da:	65 
    22db:	66 41 c7 47 2c 73 73 	movw   $0x7373,0x2c(%r15)
    22e2:	41 c6 47 2e 00       	movb   $0x0,0x2e(%r15)
    22e7:	44 89 e7             	mov    %r12d,%edi
    22ea:	e8 81 ef ff ff       	call   1270 <close@plt>
    22ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    22f4:	e9 98 02 00 00       	jmp    2591 <submitr+0x4f0>
    22f9:	48 b8 45 72 72 6f 72 	movabs $0x55203a726f727245,%rax
    2300:	3a 20 55 
    2303:	48 ba 6e 61 62 6c 65 	movabs $0x6f7420656c62616e,%rdx
    230a:	20 74 6f 
    230d:	49 89 07             	mov    %rax,(%r15)
    2310:	49 89 57 08          	mov    %rdx,0x8(%r15)
    2314:	48 b8 20 63 6f 6e 6e 	movabs $0x7463656e6e6f6320,%rax
    231b:	65 63 74 
    231e:	48 ba 20 74 6f 20 74 	movabs $0x20656874206f7420,%rdx
    2325:	68 65 20 
    2328:	49 89 47 10          	mov    %rax,0x10(%r15)
    232c:	49 89 57 18          	mov    %rdx,0x18(%r15)
    2330:	41 c7 47 20 73 65 72 	movl   $0x76726573,0x20(%r15)
    2337:	76 
    2338:	66 41 c7 47 24 65 72 	movw   $0x7265,0x24(%r15)
    233f:	41 c6 47 26 00       	movb   $0x0,0x26(%r15)
    2344:	44 89 e7             	mov    %r12d,%edi
    2347:	e8 24 ef ff ff       	call   1270 <close@plt>
    234c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2351:	e9 3b 02 00 00       	jmp    2591 <submitr+0x4f0>
    2356:	48 b8 45 72 72 6f 72 	movabs $0x52203a726f727245,%rax
    235d:	3a 20 52 
    2360:	48 ba 65 73 75 6c 74 	movabs $0x747320746c757365,%rdx
    2367:	20 73 74 
    236a:	49 89 07             	mov    %rax,(%r15)
    236d:	49 89 57 08          	mov    %rdx,0x8(%r15)
    2371:	48 b8 72 69 6e 67 20 	movabs $0x6f6f7420676e6972,%rax
    2378:	74 6f 6f 
    237b:	48 ba 20 6c 61 72 67 	movabs $0x202e656772616c20,%rdx
    2382:	65 2e 20 
    2385:	49 89 47 10          	mov    %rax,0x10(%r15)
    2389:	49 89 57 18          	mov    %rdx,0x18(%r15)
    238d:	48 b8 49 6e 63 72 65 	movabs $0x6573616572636e49,%rax
    2394:	61 73 65 
    2397:	48 ba 20 53 55 42 4d 	movabs $0x5254494d42555320,%rdx
    239e:	49 54 52 
    23a1:	49 89 47 20          	mov    %rax,0x20(%r15)
    23a5:	49 89 57 28          	mov    %rdx,0x28(%r15)
    23a9:	48 b8 5f 4d 41 58 42 	movabs $0x46554258414d5f,%rax
    23b0:	55 46 00 
    23b3:	49 89 47 30          	mov    %rax,0x30(%r15)
    23b7:	44 89 e7             	mov    %r12d,%edi
    23ba:	e8 b1 ee ff ff       	call   1270 <close@plt>
    23bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    23c4:	e9 c8 01 00 00       	jmp    2591 <submitr+0x4f0>
    23c9:	49 0f a3 c6          	bt     %rax,%r14
    23cd:	73 21                	jae    23f0 <submitr+0x34f>
    23cf:	44 88 45 00          	mov    %r8b,0x0(%rbp)
    23d3:	48 8d 6d 01          	lea    0x1(%rbp),%rbp
    23d7:	48 83 c3 01          	add    $0x1,%rbx
    23db:	4c 39 eb             	cmp    %r13,%rbx
    23de:	0f 84 35 03 00 00    	je     2719 <submitr+0x678>
    23e4:	44 0f b6 03          	movzbl (%rbx),%r8d
    23e8:	41 8d 40 d6          	lea    -0x2a(%r8),%eax
    23ec:	3c 35                	cmp    $0x35,%al
    23ee:	76 d9                	jbe    23c9 <submitr+0x328>
    23f0:	44 89 c0             	mov    %r8d,%eax
    23f3:	83 e0 df             	and    $0xffffffdf,%eax
    23f6:	83 e8 41             	sub    $0x41,%eax
    23f9:	3c 19                	cmp    $0x19,%al
    23fb:	76 d2                	jbe    23cf <submitr+0x32e>
    23fd:	41 80 f8 20          	cmp    $0x20,%r8b
    2401:	74 60                	je     2463 <submitr+0x3c2>
    2403:	41 8d 40 e0          	lea    -0x20(%r8),%eax
    2407:	3c 5f                	cmp    $0x5f,%al
    2409:	76 0a                	jbe    2415 <submitr+0x374>
    240b:	41 80 f8 09          	cmp    $0x9,%r8b
    240f:	0f 85 77 02 00 00    	jne    268c <submitr+0x5eb>
    2415:	45 0f b6 c0          	movzbl %r8b,%r8d
    2419:	48 8d 0d f6 10 00 00 	lea    0x10f6(%rip),%rcx        # 3516 <array.0+0x3d6>
    2420:	ba 08 00 00 00       	mov    $0x8,%edx
    2425:	be 01 00 00 00       	mov    $0x1,%esi
    242a:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
    242f:	b8 00 00 00 00       	mov    $0x0,%eax
    2434:	e8 47 ef ff ff       	call   1380 <__sprintf_chk@plt>
    2439:	0f b6 84 24 60 80 00 	movzbl 0x8060(%rsp),%eax
    2440:	00 
    2441:	88 45 00             	mov    %al,0x0(%rbp)
    2444:	0f b6 84 24 61 80 00 	movzbl 0x8061(%rsp),%eax
    244b:	00 
    244c:	88 45 01             	mov    %al,0x1(%rbp)
    244f:	0f b6 84 24 62 80 00 	movzbl 0x8062(%rsp),%eax
    2456:	00 
    2457:	88 45 02             	mov    %al,0x2(%rbp)
    245a:	48 8d 6d 03          	lea    0x3(%rbp),%rbp
    245e:	e9 74 ff ff ff       	jmp    23d7 <submitr+0x336>
    2463:	c6 45 00 2b          	movb   $0x2b,0x0(%rbp)
    2467:	48 8d 6d 01          	lea    0x1(%rbp),%rbp
    246b:	e9 67 ff ff ff       	jmp    23d7 <submitr+0x336>
    2470:	48 01 c5             	add    %rax,%rbp
    2473:	48 29 c3             	sub    %rax,%rbx
    2476:	0f 84 08 03 00 00    	je     2784 <submitr+0x6e3>
    247c:	48 89 da             	mov    %rbx,%rdx
    247f:	48 89 ee             	mov    %rbp,%rsi
    2482:	44 89 e7             	mov    %r12d,%edi
    2485:	e8 a6 ed ff ff       	call   1230 <write@plt>
    248a:	48 85 c0             	test   %rax,%rax
    248d:	7f e1                	jg     2470 <submitr+0x3cf>
    248f:	e8 6c ed ff ff       	call   1200 <__errno_location@plt>
    2494:	83 38 04             	cmpl   $0x4,(%rax)
    2497:	0f 85 90 01 00 00    	jne    262d <submitr+0x58c>
    249d:	4c 89 e8             	mov    %r13,%rax
    24a0:	eb ce                	jmp    2470 <submitr+0x3cf>
    24a2:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
    24a9:	3a 20 43 
    24ac:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
    24b3:	20 75 6e 
    24b6:	49 89 07             	mov    %rax,(%r15)
    24b9:	49 89 57 08          	mov    %rdx,0x8(%r15)
    24bd:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    24c4:	74 6f 20 
    24c7:	48 ba 72 65 61 64 20 	movabs $0x7269662064616572,%rdx
    24ce:	66 69 72 
    24d1:	49 89 47 10          	mov    %rax,0x10(%r15)
    24d5:	49 89 57 18          	mov    %rdx,0x18(%r15)
    24d9:	48 b8 73 74 20 68 65 	movabs $0x6564616568207473,%rax
    24e0:	61 64 65 
    24e3:	48 ba 72 20 66 72 6f 	movabs $0x73206d6f72662072,%rdx
    24ea:	6d 20 73 
    24ed:	49 89 47 20          	mov    %rax,0x20(%r15)
    24f1:	49 89 57 28          	mov    %rdx,0x28(%r15)
    24f5:	41 c7 47 30 65 72 76 	movl   $0x65767265,0x30(%r15)
    24fc:	65 
    24fd:	66 41 c7 47 34 72 00 	movw   $0x72,0x34(%r15)
    2504:	44 89 e7             	mov    %r12d,%edi
    2507:	e8 64 ed ff ff       	call   1270 <close@plt>
    250c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2511:	eb 7e                	jmp    2591 <submitr+0x4f0>
    2513:	4c 8d 8c 24 60 80 00 	lea    0x8060(%rsp),%r9
    251a:	00 
    251b:	48 8d 0d 46 0f 00 00 	lea    0xf46(%rip),%rcx        # 3468 <array.0+0x328>
    2522:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
    2529:	be 01 00 00 00       	mov    $0x1,%esi
    252e:	4c 89 ff             	mov    %r15,%rdi
    2531:	b8 00 00 00 00       	mov    $0x0,%eax
    2536:	e8 45 ee ff ff       	call   1380 <__sprintf_chk@plt>
    253b:	44 89 e7             	mov    %r12d,%edi
    253e:	e8 2d ed ff ff       	call   1270 <close@plt>
    2543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2548:	eb 47                	jmp    2591 <submitr+0x4f0>
    254a:	48 8d b4 24 60 20 00 	lea    0x2060(%rsp),%rsi
    2551:	00 
    2552:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
    2557:	ba 00 20 00 00       	mov    $0x2000,%edx
    255c:	e8 74 fa ff ff       	call   1fd5 <rio_readlineb>
    2561:	48 85 c0             	test   %rax,%rax
    2564:	7e 54                	jle    25ba <submitr+0x519>
    2566:	48 8d b4 24 60 20 00 	lea    0x2060(%rsp),%rsi
    256d:	00 
    256e:	4c 89 ff             	mov    %r15,%rdi
    2571:	e8 9a ec ff ff       	call   1210 <strcpy@plt>
    2576:	44 89 e7             	mov    %r12d,%edi
    2579:	e8 f2 ec ff ff       	call   1270 <close@plt>
    257e:	48 8d 35 ac 0f 00 00 	lea    0xfac(%rip),%rsi        # 3531 <array.0+0x3f1>
    2585:	4c 89 ff             	mov    %r15,%rdi
    2588:	e8 13 ed ff ff       	call   12a0 <strcmp@plt>
    258d:	f7 d8                	neg    %eax
    258f:	19 c0                	sbb    %eax,%eax
    2591:	48 8b 94 24 68 a0 00 	mov    0xa068(%rsp),%rdx
    2598:	00 
    2599:	64 48 2b 14 25 28 00 	sub    %fs:0x28,%rdx
    25a0:	00 00 
    25a2:	0f 85 f8 02 00 00    	jne    28a0 <submitr+0x7ff>
    25a8:	48 81 c4 78 a0 00 00 	add    $0xa078,%rsp
    25af:	5b                   	pop    %rbx
    25b0:	5d                   	pop    %rbp
    25b1:	41 5c                	pop    %r12
    25b3:	41 5d                	pop    %r13
    25b5:	41 5e                	pop    %r14
    25b7:	41 5f                	pop    %r15
    25b9:	c3                   	ret    
    25ba:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
    25c1:	3a 20 43 
    25c4:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
    25cb:	20 75 6e 
    25ce:	49 89 07             	mov    %rax,(%r15)
    25d1:	49 89 57 08          	mov    %rdx,0x8(%r15)
    25d5:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    25dc:	74 6f 20 
    25df:	48 ba 72 65 61 64 20 	movabs $0x6174732064616572,%rdx
    25e6:	73 74 61 
    25e9:	49 89 47 10          	mov    %rax,0x10(%r15)
    25ed:	49 89 57 18          	mov    %rdx,0x18(%r15)
    25f1:	48 b8 74 75 73 20 6d 	movabs $0x7373656d20737574,%rax
    25f8:	65 73 73 
    25fb:	48 ba 61 67 65 20 66 	movabs $0x6d6f726620656761,%rdx
    2602:	72 6f 6d 
    2605:	49 89 47 20          	mov    %rax,0x20(%r15)
    2609:	49 89 57 28          	mov    %rdx,0x28(%r15)
    260d:	48 b8 20 73 65 72 76 	movabs $0x72657672657320,%rax
    2614:	65 72 00 
    2617:	49 89 47 30          	mov    %rax,0x30(%r15)
    261b:	44 89 e7             	mov    %r12d,%edi
    261e:	e8 4d ec ff ff       	call   1270 <close@plt>
    2623:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2628:	e9 64 ff ff ff       	jmp    2591 <submitr+0x4f0>
    262d:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
    2634:	3a 20 43 
    2637:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
    263e:	20 75 6e 
    2641:	49 89 07             	mov    %rax,(%r15)
    2644:	49 89 57 08          	mov    %rdx,0x8(%r15)
    2648:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    264f:	74 6f 20 
    2652:	48 ba 77 72 69 74 65 	movabs $0x6f74206574697277,%rdx
    2659:	20 74 6f 
    265c:	49 89 47 10          	mov    %rax,0x10(%r15)
    2660:	49 89 57 18          	mov    %rdx,0x18(%r15)
    2664:	48 b8 20 74 68 65 20 	movabs $0x7265732065687420,%rax
    266b:	73 65 72 
    266e:	49 89 47 20          	mov    %rax,0x20(%r15)
    2672:	41 c7 47 28 76 65 72 	movl   $0x726576,0x28(%r15)
    2679:	00 
    267a:	44 89 e7             	mov    %r12d,%edi
    267d:	e8 ee eb ff ff       	call   1270 <close@plt>
    2682:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2687:	e9 05 ff ff ff       	jmp    2591 <submitr+0x4f0>
    268c:	48 b8 45 72 72 6f 72 	movabs $0x52203a726f727245,%rax
    2693:	3a 20 52 
    2696:	48 ba 65 73 75 6c 74 	movabs $0x747320746c757365,%rdx
    269d:	20 73 74 
    26a0:	49 89 07             	mov    %rax,(%r15)
    26a3:	49 89 57 08          	mov    %rdx,0x8(%r15)
    26a7:	48 b8 72 69 6e 67 20 	movabs $0x6e6f6320676e6972,%rax
    26ae:	63 6f 6e 
    26b1:	48 ba 74 61 69 6e 73 	movabs $0x6e6120736e696174,%rdx
    26b8:	20 61 6e 
    26bb:	49 89 47 10          	mov    %rax,0x10(%r15)
    26bf:	49 89 57 18          	mov    %rdx,0x18(%r15)
    26c3:	48 b8 20 69 6c 6c 65 	movabs $0x6c6167656c6c6920,%rax
    26ca:	67 61 6c 
    26cd:	48 ba 20 6f 72 20 75 	movabs $0x72706e7520726f20,%rdx
    26d4:	6e 70 72 
    26d7:	49 89 47 20          	mov    %rax,0x20(%r15)
    26db:	49 89 57 28          	mov    %rdx,0x28(%r15)
    26df:	48 b8 69 6e 74 61 62 	movabs $0x20656c6261746e69,%rax
    26e6:	6c 65 20 
    26e9:	48 ba 63 68 61 72 61 	movabs $0x6574636172616863,%rdx
    26f0:	63 74 65 
    26f3:	49 89 47 30          	mov    %rax,0x30(%r15)
    26f7:	49 89 57 38          	mov    %rdx,0x38(%r15)
    26fb:	66 41 c7 47 40 72 2e 	movw   $0x2e72,0x40(%r15)
    2702:	41 c6 47 42 00       	movb   $0x0,0x42(%r15)
    2707:	44 89 e7             	mov    %r12d,%edi
    270a:	e8 61 eb ff ff       	call   1270 <close@plt>
    270f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2714:	e9 78 fe ff ff       	jmp    2591 <submitr+0x4f0>
    2719:	48 8d 9c 24 60 20 00 	lea    0x2060(%rsp),%rbx
    2720:	00 
    2721:	48 83 ec 08          	sub    $0x8,%rsp
    2725:	48 8d 84 24 68 40 00 	lea    0x4068(%rsp),%rax
    272c:	00 
    272d:	50                   	push   %rax
    272e:	ff 74 24 28          	push   0x28(%rsp)
    2732:	ff 74 24 38          	push   0x38(%rsp)
    2736:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
    273b:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
    2740:	48 8d 0d 51 0d 00 00 	lea    0xd51(%rip),%rcx        # 3498 <array.0+0x358>
    2747:	ba 00 20 00 00       	mov    $0x2000,%edx
    274c:	be 01 00 00 00       	mov    $0x1,%esi
    2751:	48 89 df             	mov    %rbx,%rdi
    2754:	b8 00 00 00 00       	mov    $0x0,%eax
    2759:	e8 22 ec ff ff       	call   1380 <__sprintf_chk@plt>
    275e:	48 83 c4 20          	add    $0x20,%rsp
    2762:	48 89 df             	mov    %rbx,%rdi
    2765:	e8 d6 ea ff ff       	call   1240 <strlen@plt>
    276a:	48 89 c3             	mov    %rax,%rbx
    276d:	48 8d ac 24 60 20 00 	lea    0x2060(%rsp),%rbp
    2774:	00 
    2775:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    277b:	48 85 c0             	test   %rax,%rax
    277e:	0f 85 f8 fc ff ff    	jne    247c <submitr+0x3db>
    2784:	44 89 64 24 50       	mov    %r12d,0x50(%rsp)
    2789:	c7 44 24 54 00 00 00 	movl   $0x0,0x54(%rsp)
    2790:	00 
    2791:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
    2796:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
    279b:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
    27a0:	48 8d b4 24 60 20 00 	lea    0x2060(%rsp),%rsi
    27a7:	00 
    27a8:	ba 00 20 00 00       	mov    $0x2000,%edx
    27ad:	e8 23 f8 ff ff       	call   1fd5 <rio_readlineb>
    27b2:	48 85 c0             	test   %rax,%rax
    27b5:	0f 8e e7 fc ff ff    	jle    24a2 <submitr+0x401>
    27bb:	48 8d 4c 24 3c       	lea    0x3c(%rsp),%rcx
    27c0:	48 8d 94 24 60 60 00 	lea    0x6060(%rsp),%rdx
    27c7:	00 
    27c8:	48 8d bc 24 60 20 00 	lea    0x2060(%rsp),%rdi
    27cf:	00 
    27d0:	4c 8d 84 24 60 80 00 	lea    0x8060(%rsp),%r8
    27d7:	00 
    27d8:	48 8d 35 3e 0d 00 00 	lea    0xd3e(%rip),%rsi        # 351d <array.0+0x3dd>
    27df:	b8 00 00 00 00       	mov    $0x0,%eax
    27e4:	e8 17 eb ff ff       	call   1300 <__isoc99_sscanf@plt>
    27e9:	44 8b 44 24 3c       	mov    0x3c(%rsp),%r8d
    27ee:	41 81 f8 c8 00 00 00 	cmp    $0xc8,%r8d
    27f5:	0f 85 18 fd ff ff    	jne    2513 <submitr+0x472>
    27fb:	48 8d 1d 2c 0d 00 00 	lea    0xd2c(%rip),%rbx        # 352e <array.0+0x3ee>
    2802:	48 8d bc 24 60 20 00 	lea    0x2060(%rsp),%rdi
    2809:	00 
    280a:	48 89 de             	mov    %rbx,%rsi
    280d:	e8 8e ea ff ff       	call   12a0 <strcmp@plt>
    2812:	85 c0                	test   %eax,%eax
    2814:	0f 84 30 fd ff ff    	je     254a <submitr+0x4a9>
    281a:	48 8d b4 24 60 20 00 	lea    0x2060(%rsp),%rsi
    2821:	00 
    2822:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
    2827:	ba 00 20 00 00       	mov    $0x2000,%edx
    282c:	e8 a4 f7 ff ff       	call   1fd5 <rio_readlineb>
    2831:	48 85 c0             	test   %rax,%rax
    2834:	7f cc                	jg     2802 <submitr+0x761>
    2836:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
    283d:	3a 20 43 
    2840:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
    2847:	20 75 6e 
    284a:	49 89 07             	mov    %rax,(%r15)
    284d:	49 89 57 08          	mov    %rdx,0x8(%r15)
    2851:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    2858:	74 6f 20 
    285b:	48 ba 72 65 61 64 20 	movabs $0x6165682064616572,%rdx
    2862:	68 65 61 
    2865:	49 89 47 10          	mov    %rax,0x10(%r15)
    2869:	49 89 57 18          	mov    %rdx,0x18(%r15)
    286d:	48 b8 64 65 72 73 20 	movabs $0x6f72662073726564,%rax
    2874:	66 72 6f 
    2877:	48 ba 6d 20 73 65 72 	movabs $0x726576726573206d,%rdx
    287e:	76 65 72 
    2881:	49 89 47 20          	mov    %rax,0x20(%r15)
    2885:	49 89 57 28          	mov    %rdx,0x28(%r15)
    2889:	41 c6 47 30 00       	movb   $0x0,0x30(%r15)
    288e:	44 89 e7             	mov    %r12d,%edi
    2891:	e8 da e9 ff ff       	call   1270 <close@plt>
    2896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    289b:	e9 f1 fc ff ff       	jmp    2591 <submitr+0x4f0>
    28a0:	e8 ab e9 ff ff       	call   1250 <__stack_chk_fail@plt>

00000000000028a5 <init_timeout>:
    28a5:	f3 0f 1e fa          	endbr64 
    28a9:	85 ff                	test   %edi,%edi
    28ab:	75 01                	jne    28ae <init_timeout+0x9>
    28ad:	c3                   	ret    
    28ae:	53                   	push   %rbx
    28af:	89 fb                	mov    %edi,%ebx
    28b1:	48 8d 35 e7 f6 ff ff 	lea    -0x919(%rip),%rsi        # 1f9f <sigalrm_handler>
    28b8:	bf 0e 00 00 00       	mov    $0xe,%edi
    28bd:	e8 ee e9 ff ff       	call   12b0 <signal@plt>
    28c2:	85 db                	test   %ebx,%ebx
    28c4:	b8 00 00 00 00       	mov    $0x0,%eax
    28c9:	0f 49 c3             	cmovns %ebx,%eax
    28cc:	89 c7                	mov    %eax,%edi
    28ce:	e8 8d e9 ff ff       	call   1260 <alarm@plt>
    28d3:	5b                   	pop    %rbx
    28d4:	c3                   	ret    

00000000000028d5 <init_driver>:
    28d5:	f3 0f 1e fa          	endbr64 
    28d9:	41 54                	push   %r12
    28db:	55                   	push   %rbp
    28dc:	53                   	push   %rbx
    28dd:	48 83 ec 20          	sub    $0x20,%rsp
    28e1:	48 89 fd             	mov    %rdi,%rbp
    28e4:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    28eb:	00 00 
    28ed:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    28f2:	31 c0                	xor    %eax,%eax
    28f4:	be 01 00 00 00       	mov    $0x1,%esi
    28f9:	bf 0d 00 00 00       	mov    $0xd,%edi
    28fe:	e8 ad e9 ff ff       	call   12b0 <signal@plt>
    2903:	be 01 00 00 00       	mov    $0x1,%esi
    2908:	bf 1d 00 00 00       	mov    $0x1d,%edi
    290d:	e8 9e e9 ff ff       	call   12b0 <signal@plt>
    2912:	be 01 00 00 00       	mov    $0x1,%esi
    2917:	bf 1d 00 00 00       	mov    $0x1d,%edi
    291c:	e8 8f e9 ff ff       	call   12b0 <signal@plt>
    2921:	ba 00 00 00 00       	mov    $0x0,%edx
    2926:	be 01 00 00 00       	mov    $0x1,%esi
    292b:	bf 02 00 00 00       	mov    $0x2,%edi
    2930:	e8 5b ea ff ff       	call   1390 <socket@plt>
    2935:	85 c0                	test   %eax,%eax
    2937:	0f 88 9c 00 00 00    	js     29d9 <init_driver+0x104>
    293d:	89 c3                	mov    %eax,%ebx
    293f:	48 8d 3d ee 0b 00 00 	lea    0xbee(%rip),%rdi        # 3534 <array.0+0x3f4>
    2946:	e8 75 e9 ff ff       	call   12c0 <gethostbyname@plt>
    294b:	48 85 c0             	test   %rax,%rax
    294e:	0f 84 d1 00 00 00    	je     2a25 <init_driver+0x150>
    2954:	49 89 e4             	mov    %rsp,%r12
    2957:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
    295e:	00 
    295f:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
    2966:	00 00 
    2968:	66 c7 04 24 02 00    	movw   $0x2,(%rsp)
    296e:	48 63 50 14          	movslq 0x14(%rax),%rdx
    2972:	48 8b 40 18          	mov    0x18(%rax),%rax
    2976:	48 8d 7c 24 04       	lea    0x4(%rsp),%rdi
    297b:	b9 0c 00 00 00       	mov    $0xc,%ecx
    2980:	48 8b 30             	mov    (%rax),%rsi
    2983:	e8 48 e9 ff ff       	call   12d0 <__memmove_chk@plt>
    2988:	66 c7 44 24 02 3b 6e 	movw   $0x6e3b,0x2(%rsp)
    298f:	ba 10 00 00 00       	mov    $0x10,%edx
    2994:	4c 89 e6             	mov    %r12,%rsi
    2997:	89 df                	mov    %ebx,%edi
    2999:	e8 a2 e9 ff ff       	call   1340 <connect@plt>
    299e:	85 c0                	test   %eax,%eax
    29a0:	0f 88 e7 00 00 00    	js     2a8d <init_driver+0x1b8>
    29a6:	89 df                	mov    %ebx,%edi
    29a8:	e8 c3 e8 ff ff       	call   1270 <close@plt>
    29ad:	66 c7 45 00 4f 4b    	movw   $0x4b4f,0x0(%rbp)
    29b3:	c6 45 02 00          	movb   $0x0,0x2(%rbp)
    29b7:	b8 00 00 00 00       	mov    $0x0,%eax
    29bc:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    29c1:	64 48 2b 14 25 28 00 	sub    %fs:0x28,%rdx
    29c8:	00 00 
    29ca:	0f 85 f5 00 00 00    	jne    2ac5 <init_driver+0x1f0>
    29d0:	48 83 c4 20          	add    $0x20,%rsp
    29d4:	5b                   	pop    %rbx
    29d5:	5d                   	pop    %rbp
    29d6:	41 5c                	pop    %r12
    29d8:	c3                   	ret    
    29d9:	48 b8 45 72 72 6f 72 	movabs $0x43203a726f727245,%rax
    29e0:	3a 20 43 
    29e3:	48 ba 6c 69 65 6e 74 	movabs $0x6e7520746e65696c,%rdx
    29ea:	20 75 6e 
    29ed:	48 89 45 00          	mov    %rax,0x0(%rbp)
    29f1:	48 89 55 08          	mov    %rdx,0x8(%rbp)
    29f5:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    29fc:	74 6f 20 
    29ff:	48 ba 63 72 65 61 74 	movabs $0x7320657461657263,%rdx
    2a06:	65 20 73 
    2a09:	48 89 45 10          	mov    %rax,0x10(%rbp)
    2a0d:	48 89 55 18          	mov    %rdx,0x18(%rbp)
    2a11:	c7 45 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%rbp)
    2a18:	66 c7 45 24 74 00    	movw   $0x74,0x24(%rbp)
    2a1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2a23:	eb 97                	jmp    29bc <init_driver+0xe7>
    2a25:	48 b8 45 72 72 6f 72 	movabs $0x44203a726f727245,%rax
    2a2c:	3a 20 44 
    2a2f:	48 ba 4e 53 20 69 73 	movabs $0x6e7520736920534e,%rdx
    2a36:	20 75 6e 
    2a39:	48 89 45 00          	mov    %rax,0x0(%rbp)
    2a3d:	48 89 55 08          	mov    %rdx,0x8(%rbp)
    2a41:	48 b8 61 62 6c 65 20 	movabs $0x206f7420656c6261,%rax
    2a48:	74 6f 20 
    2a4b:	48 ba 72 65 73 6f 6c 	movabs $0x2065766c6f736572,%rdx
    2a52:	76 65 20 
    2a55:	48 89 45 10          	mov    %rax,0x10(%rbp)
    2a59:	48 89 55 18          	mov    %rdx,0x18(%rbp)
    2a5d:	48 b8 73 65 72 76 65 	movabs $0x6120726576726573,%rax
    2a64:	72 20 61 
    2a67:	48 89 45 20          	mov    %rax,0x20(%rbp)
    2a6b:	c7 45 28 64 64 72 65 	movl   $0x65726464,0x28(%rbp)
    2a72:	66 c7 45 2c 73 73    	movw   $0x7373,0x2c(%rbp)
    2a78:	c6 45 2e 00          	movb   $0x0,0x2e(%rbp)
    2a7c:	89 df                	mov    %ebx,%edi
    2a7e:	e8 ed e7 ff ff       	call   1270 <close@plt>
    2a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2a88:	e9 2f ff ff ff       	jmp    29bc <init_driver+0xe7>
    2a8d:	4c 8d 05 a0 0a 00 00 	lea    0xaa0(%rip),%r8        # 3534 <array.0+0x3f4>
    2a94:	48 8d 0d 55 0a 00 00 	lea    0xa55(%rip),%rcx        # 34f0 <array.0+0x3b0>
    2a9b:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
    2aa2:	be 01 00 00 00       	mov    $0x1,%esi
    2aa7:	48 89 ef             	mov    %rbp,%rdi
    2aaa:	b8 00 00 00 00       	mov    $0x0,%eax
    2aaf:	e8 cc e8 ff ff       	call   1380 <__sprintf_chk@plt>
    2ab4:	89 df                	mov    %ebx,%edi
    2ab6:	e8 b5 e7 ff ff       	call   1270 <close@plt>
    2abb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    2ac0:	e9 f7 fe ff ff       	jmp    29bc <init_driver+0xe7>
    2ac5:	e8 86 e7 ff ff       	call   1250 <__stack_chk_fail@plt>

0000000000002aca <driver_post>:
    2aca:	f3 0f 1e fa          	endbr64 
    2ace:	53                   	push   %rbx
    2acf:	4c 89 c3             	mov    %r8,%rbx
    2ad2:	85 c9                	test   %ecx,%ecx
    2ad4:	75 17                	jne    2aed <driver_post+0x23>
    2ad6:	48 85 ff             	test   %rdi,%rdi
    2ad9:	74 05                	je     2ae0 <driver_post+0x16>
    2adb:	80 3f 00             	cmpb   $0x0,(%rdi)
    2ade:	75 33                	jne    2b13 <driver_post+0x49>
    2ae0:	66 c7 03 4f 4b       	movw   $0x4b4f,(%rbx)
    2ae5:	c6 43 02 00          	movb   $0x0,0x2(%rbx)
    2ae9:	89 c8                	mov    %ecx,%eax
    2aeb:	5b                   	pop    %rbx
    2aec:	c3                   	ret    
    2aed:	48 8d 35 58 0a 00 00 	lea    0xa58(%rip),%rsi        # 354c <array.0+0x40c>
    2af4:	bf 01 00 00 00       	mov    $0x1,%edi
    2af9:	b8 00 00 00 00       	mov    $0x0,%eax
    2afe:	e8 0d e8 ff ff       	call   1310 <__printf_chk@plt>
    2b03:	66 c7 03 4f 4b       	movw   $0x4b4f,(%rbx)
    2b08:	c6 43 02 00          	movb   $0x0,0x2(%rbx)
    2b0c:	b8 00 00 00 00       	mov    $0x0,%eax
    2b11:	eb d8                	jmp    2aeb <driver_post+0x21>
    2b13:	41 50                	push   %r8
    2b15:	52                   	push   %rdx
    2b16:	4c 8d 0d 46 0a 00 00 	lea    0xa46(%rip),%r9        # 3563 <array.0+0x423>
    2b1d:	49 89 f0             	mov    %rsi,%r8
    2b20:	48 89 f9             	mov    %rdi,%rcx
    2b23:	48 8d 15 41 0a 00 00 	lea    0xa41(%rip),%rdx        # 356b <array.0+0x42b>
    2b2a:	be 6e 3b 00 00       	mov    $0x3b6e,%esi
    2b2f:	48 8d 3d fe 09 00 00 	lea    0x9fe(%rip),%rdi        # 3534 <array.0+0x3f4>
    2b36:	e8 66 f5 ff ff       	call   20a1 <submitr>
    2b3b:	48 83 c4 10          	add    $0x10,%rsp
    2b3f:	eb aa                	jmp    2aeb <driver_post+0x21>

Disassembly of section .fini:

0000000000002b44 <_fini>:
    2b44:	f3 0f 1e fa          	endbr64 
    2b48:	48 83 ec 08          	sub    $0x8,%rsp
    2b4c:	48 83 c4 08          	add    $0x8,%rsp
    2b50:	c3                   	ret    
