# xv6-labs

## 0. 环境配置

> :one:xv6源码配置：从https://gitee.com/xjtu-osv/xv6-riscv.git下载解压后，生成路径：
>
> ```terminal
> C:\Users\Administrator\Desktop\Lab\xv6-riscv-riscv
> ```
>
> :two:docker容器配置：按照https://docs.docker.com/get-docker/指引下载并安装即可
>
> :three:初次启动容器环境
>
> 1. 启动容器
>
> ```terminal
> PS C:\Users\Administrator\Desktop> docker run -it -v C:\Users\Administrator\Desktop\Lab\xv6-riscv-riscv:/home/osv/xv6-riscv --name xv6-labs xjtuosv/xv6-labs:amd64
> Unable to find image 'xjtuosv/xv6-labs:amd64' locally
> ........
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> osv@9fa911d4a918:~/xv6-riscv$
> ```
>
> 2. 检查环境是否正确
>
> ```terminal
> $ qemu-system-riscv64 --version
> QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.14)
> ...
> 
> $ riscv64-linux-gnu-gcc --version
> riscv64-linux-gnu-gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
> ...
> ```
>
> 3. 编译
>
> ```terminal
> osv@9fa911d4a918:~/xv6-riscv$ make qemu
> riscv64-linux-gnu-gcc    -c -o kernel/entry.o kernel/entry.S
> ........
> xv6 kernel is booting
> 
> hart 2 starting
> hart 1 starting
> init: starting sh
> $
> ```
>
> :four:重启容器指令
>
> ```terminal
> 1.执行容器: docker exec -it xv6-labs /bin/bash
> 2.目前正在运行的进程: ps aux | grep qemu
> 3.杀死正在占用的进程: kill xxx (xxx是299或者298或者300对应的进程号)
> 4.如有必要清除文件系统: make clean
> 5.重新编译: make qemu
> ```
>
> 按Ctrl+Z退出

## 1. Lab1

> ### 1.1. 改动代码
>
> > :one:在`\user`目录下加入`sleep.c`
> >
> > ```C
> > #include "kernel/types.h"
> > #include "user/user.h"
> > 
> > int main(int argc, char *argv[])
> > {
> > switch (argc) {
> > case 2:
> >   // 当参数数量正确时
> >   int time = atoi(argv[1]);
> >   if (sleep(time) != 0) {
> >       printf("Error!\n");
> >   }
> >   break;
> > 
> > default:
> >   // 当参数数量不正确时
> >   printf("You should input sleep times!\n");
> > }
> > 
> > exit(0);
> > }
> > ```
> >
> > :two:在`\user`目录下加入`find.c`
> >
> > ```C
> > #include "kernel/types.h"
> > #include "kernel/stat.h"
> > #include "kernel/fs.h"
> > #include "user/user.h"
> > 
> > char* noSpace(char* dir)
> > {
> > static char newDir[DIRSIZ + 1];
> > int space = 0;
> > int buf = 0;
> > char* p = dir + strlen(dir) - 1;
> > while (p >= dir && *p == ' ') {
> >   ++space;
> >   --p;
> > }
> > buf = DIRSIZ - space;
> > memmove(newDir, dir, buf);
> > newDir[buf] = 0;
> > return newDir;
> > }
> > 
> > void find(char* dir, char* name)
> > {
> > char buf[512], *p;
> > int fd;
> > struct dirent de;
> > struct stat st;
> > 
> > fd = open(dir, 0);
> > if (fd < 0) {
> >   fprintf(2, "find: cannot open %s\n", dir);
> >   return;
> > }
> > 
> > if (fstat(fd, &st) < 0) {
> >   fprintf(2, "find: cannot fstat %s\n", dir);
> >   close(fd);
> >   return;
> > }
> > 
> > if (st.type == T_DEVICE || st.type == T_FILE) {
> >   printf("find: not a directory value!\n");
> >   close(fd);
> > } else if (st.type == T_DIR) {
> >   if (strlen(dir) + 1 + DIRSIZ + 1 > sizeof buf) {
> >       printf("ls: path too long\n");
> >   } else {
> >       strcpy(buf, dir);
> >       p = buf + strlen(buf);
> >       *p++ = '/';
> >       for (int readBytes = read(fd, &de, sizeof(de)); readBytes == sizeof de; readBytes = read(fd, &de, sizeof(de))) {
> >           if (de.inum == 0)
> >               continue;
> >           if (strcmp(".", noSpace(de.name)) == 0 || strcmp("..", noSpace(de.name)) == 0) {
> >               continue;
> >           }
> >           memmove(p, de.name, DIRSIZ);
> >           p[DIRSIZ] = 0;
> >           if (stat(buf, &st) < 0) {
> >               printf("find: cannot stat '%s'\n", buf);
> >               continue;
> >           }
> >           switch (st.type) {
> >               case T_DIR:
> >                   find(buf, name);
> >                   break;
> >               default:
> >                   if (strcmp(name, noSpace(de.name)) == 0) {
> >                       printf("%s\n", buf);
> >                   }
> >                   break;
> >           }
> >       }
> >   }
> > }
> > close(fd);
> > }
> > 
> > int main(int argc, char* argv[])
> > {
> > switch (argc) {
> >   case 3:
> >       find(argv[1], argv[2]);
> >       break;
> >   default:
> >       printf("Wrong directory or file name!\n");
> >       break;
> > }
> > exit(0);
> > }
> > ```
> >
> > :three:对`Makefile`的修改：在UPROGS中加入
> >
> > ```txt
> > $U/_sleep\
> > $U/_find\
> > ```
>
> ### 1.2. 运行结果
>
> > ```terminal
> > PS C:\Users\Administrator> docker exec -it xv6-labs /bin/bash
> > osv@9fa911d4a918:~/xv6-riscv$ ps aux | grep qemu
> > osv       2126  0.4  0.0   3396  2484 pts/10   S+   17:55   0:00 make qemu
> > osv       2563  291  1.0 1703576 162632 pts/10 Sl+  17:56   0:46 qemu-system-
> > ............
> > osv@9fa911d4a918:~/xv6-riscv$ kill 2563
> > osv@9fa911d4a918:~/xv6-riscv$ make qemu
> > ............
> > xv6 kernel is booting
> > 
> > hart 1 starting
> > hart 2 starting
> > init: starting sh
> > $ sleep 10
> > (无任何输出持续一小会）
> > $
> > ```
> >
> > ```terminal
> > PS C:\Users\Administrator> docker exec -it xv6-labs /bin/bash
> > osv@9fa911d4a918:~/xv6-riscv$ ps aux | grep qemu
> > osv       2584  0.1  0.0   3548  2544 pts/11   S+   17:56   0:00 make qemu
> > osv       2596  301  1.0 1713856 165116 pts/11 Sl+  17:56   5:22 qemu-system-
> > ............
> > osv@9fa911d4a918:~/xv6-riscv$ kill 2596
> > osv@9fa911d4a918:~/xv6-riscv$ make clean
> > ............
> > osv@9fa911d4a918:~/xv6-riscv$ make qemu
> > riscv64-linux-gnu-gcc    -c -o kernel/entry.o kernel/entry.S
> > ............
> > xv6 kernel is booting
> > 
> > hart 2 starting
> > hart 1 starting
> > init: starting sh
> > $ echo > b
> > $ mkdir a
> > $ echo > a/b
> > $ mkdir a/aa
> > $ echo > a/aa/b
> > $ find . b
> > ./b
> > ./a/b
> > ./a/aa/b
> > $
> > ```

## 2. Lab2

> ### 2.1. 代码及修改
>
> > #### 2.1.1. `Makefile`的修改
> >
> > > 在UPROGS中加入
> > >
> > > ```txt
> > > $U/_sysinfotest\
> > > ```
> >
> > #### 2.1.2. `user`目录下的修改
> >
> > > :one:`user.h`：在`//system call`下加入
> > >
> > > ```C
> > > struct sysinfo;
> > > int sysinfo(struct sysinfo*);
> > > ```
> > >
> > > :two:`usys.l`：在末尾加入
> > >
> > > ```C
> > > entry("sysinfo");
> > > ```
> >
> > #### 2.1.3. `kernel`目录下的修改
> >
> > > :one:`syscall.c`
> > >
> > > 在一长串`extern uint64 sys_XXX(void)`后加入
> > >
> > > ```C++
> > > extern uint64 sys_sysinfo(void);
> > > ```
> > >
> > > 在一长串`[SYS_XXX] sys_XXX,`加入
> > >
> > > ```C
> > > [SYS_sysinfo] sys_sysinfo,
> > > ```
> > >
> > > :two:`syscall.h`：末尾加入以下语句
> > >
> > > ```C
> > > #define SYS_sysinfo  22
> > > ```
> > >
> > > :three:`kalloc.c`还有`porc.c`
> > >
> > > 在`kalloc.c`中加入代码
> > >
> > > ```C
> > > uint64 freememcnt(void)
> > > {
> > >   struct run* r;
> > >   uint64 freemem = 0;
> > >   acquire(&kmem.lock);
> > >   r = kmem.freelist;
> > >   while(r)
> > >   {
> > >     freemem++;
> > >     r = r->next;
> > >   }
> > >   release(&kmem.lock);
> > >   return freemem*4096;
> > > }
> > > ```
> > >
> > > 在`porc.c`中加入代码
> > >
> > > ```C
> > > int proccnt(void)
> > > {
> > >   int nproc = 0;
> > >   struct proc* p;
> > >   for (p=proc;p<&proc[NPROC];p++)
> > >   {
> > >     if (p->state != UNUSED)
> > >     {
> > >       nproc++;
> > >     }
> > >   }
> > >   return nproc;
> > > }
> > > ```
> > >
> > > :four:`defs.h`：加入两个函数的声明
> > >
> > > ```C
> > > // kalloc.c
> > > uint64          freememcnt(void);
> > > // proc.c
> > > int             proccnt(void);
> > > ```
> > >
> > > :five:`sysproc.c`：
> > >
> > > 加入头文件
> > >
> > > ```C
> > > #include "sysinfo.h"
> > > ```
> > >
> > > 末尾加入函数
> > >
> > > ```C
> > > uint64 sys_sysinfo(void)
> > > {
> > >   uint64 si_addr;
> > >   argaddr(0, &si_addr);
> > > 
> > >   struct sysinfo systeminfo;
> > >   systeminfo.freemem = freememcnt();
> > >   systeminfo.nproc = proccnt();
> > > 
> > >   struct proc* p = myproc();
> > > 
> > >   int copyResult = copyout(p->pagetable, si_addr, (char*)&systeminfo, sizeof(systeminfo));
> > >   switch (copyResult) {
> > >     case -1:
> > >       return -1;
> > >     default:
> > >       return 0;
> > >   }
> > > }
> > > ```
> > >
>
> ### 2.2. 运行结果
>
> > ```terminal
> > PS C:\Users\Administrator> docker exec -it xv6-labs /bin/bash
> > osv@9fa911d4a918:~/xv6-riscv$ ps aux | grep qemu
> > osv       3091  0.1  0.0   3548  2800 pts/13   S+   18:43   0:00 make qemu
> > osv       3241  300  1.0 1697408 162680 pts/13 Sl+  18:43  10:16 qemu-system-
> > ............
> > osv@9fa911d4a918:~/xv6-riscv$ kill 3241
> > osv@9fa911d4a918:~/xv6-riscv$ make qemu
> > ............
> > xv6 kernel is booting
> > 
> > hart 2 starting
> > hart 1 starting
> > init: starting sh
> > $ sysinfotest
> > sysinfotest: start
> > sysinfotest: OK
> > $
> > ```

## 3. Lab3

> ### 3.1. 代码及修改
>
> > #### 3.1.1. `Makefile`的修改
> >
> > > 在UPROGS中加入
> > >
> > > ```txt
> > > $U/_pgtbltest\
> > > ```
> >
> > #### 3.1.2. `user`目录下的修改
> >
> > > :one:`user.h`：在`//system call`下加入
> > >
> > > ```C
> > > int pgaccess(void* baseVirtualAddr, int pageNum, void* userAddr);
> > > ```
> > >
> > > :two:`usys.l`：在末尾加入
> > >
> > > ```C
> > > entry("pgaccess");
> > > ```
> >
> > #### 3.1.3. `kernel`目录下的修改
> >
> > > :one:`syscall.c`
> > >
> > > 在一长串`extern uint64 sys_XXX(void)`后加入
> > >
> > > ```C++
> > > extern uint64 sys_pgaccess(void);
> > > ```
> > >
> > > 在一长串`[SYS_XXX] sys_XXX,`加入
> > >
> > > ```C
> > > [SYS_pgaccess] sys_pgaccess,
> > > ```
> > >
> > > :two:`syscall.h`的修改：末尾加入以下语句
> > >
> > > ```C
> > > #define SYS_pgaccess  23
> > > ```
> > >
> > > :three:`vm.c`：末尾增加函数
> > >
> > > ```C
> > > static int depth=0;
> > > 
> > > void vmprint(pagetable_t pt)
> > > {
> > >     if (depth == 0)
> > >     {
> > >         printf("page table %p\n", (uint64)pt);
> > >     }
> > > 
> > >     int i = 0;
> > >     while (i < 512)
> > >     {
> > >         pte_t pte = pt[i];
> > >         switch (pte & PTE_V)
> > >         {
> > >             case 1:  // 当 pte & PTE_V 为真
> > >                 {
> > >                     int j = 0;
> > >                     while (j < depth)
> > >                     {
> > >                         printf(".. ");
> > >                         j++;
> > >                     }
> > >                     printf("..%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
> > >                 }
> > >                 if (!(pte & (PTE_R | PTE_W | PTE_X)))
> > >                 {
> > >                     depth++;
> > >                     uint64 pa = PTE2PA(pte);
> > >                     vmprint((pagetable_t)pa);
> > >                     depth--;
> > >                 }
> > >                 break;
> > >             default:
> > >                 break;
> > >         }
> > >         i++;
> > >     }
> > > }
> > > ```
> > >
> > > :four:`defs.h`：加入两个函数的声明
> > >
> > > ```C
> > > // vm.c
> > > void            vmprint(pagetable_t);
> > > ```
> > >
> > > :five:`sysproc.c`
> > >
> > > 末尾加入函数
> > >
> > > ```C
> > > int sys_pgaccess(void) {
> > >  uint64 va;
> > > int page;
> > >  uint64 ua;
> > > argaddr(0, &va);
> > >  argint(1, &page);
> > >  argaddr(2, &ua);
> > >    
> > >     const int MAX_PAGE_LIMIT = 1024; 
> > >     if (page > MAX_PAGE_LIMIT) {
> > >         return -1;
> > >     }
> > >    
> > >  uint64 mask = 0;
> > >     struct proc* p = myproc();
> > >     int i = 0;
> > >     while (i < page) {
> > >         pte_t* pte = walk(p->pagetable, va + i * PGSIZE, 0);
> > >      if (pte == 0) {
> > >             return -1; // 页不存在时返回错误
> > >         }
> > >         switch (PTE_FLAGS(*pte) & PTE_A) {
> > >             case PTE_A:
> > >                 mask |= (1L << i);
> > >                 *pte &= ~PTE_A; // 清除访问位
> > >                 break;
> > >             default:
> > >                 break;
> > >         }
> > >         i++;
> > >     }
> > >    
> > >     if (copyout(p->pagetable, ua, (char*)&mask, sizeof(mask)) < 0) {
> > >         return -1; // 复制失败时返回错误
> > >     }
> > >     return 0;
> > >    }
> > > ```
> > >    
> > >    :six:`exec.c`：在130行左右加入
> > >    
> > >    ```C
> > > proc_freepagetable(oldpagetable, oldsz);
> > > 
> > >//130行加入这个if语句
> > > if (p->pid == 1) 
> > >{
> > >  vmprint(p->pagetable);
> > >   }
> > > 
> > >   return argc; // this ends up in a0, the first argument to main(argc, argv)
> > >   
> > >   ```
> > >    
> > >   :seven:`riscv.h`：346行后加入
> > > 
> > >   ```C
> > > #define PTE_A (1L << 6)
> > > ```
> 
> ### 3.2. 运行结果
> 
> > ```C++
> > PS C:\Users\Administrator> docker exec -it xv6-labs /bin/bash
> > osv@9fa911d4a918:~/xv6-riscv$ ps aux | grep qemu
>> osv       7130  0.0  0.0   3404  2476 pts/24   S+   20:10   0:00 make qemu
> > osv       7579  298  1.0 1709752 166800 pts/24 Sl+  20:10   7:27 qemu-system-
>> ............
> > osv@9fa911d4a918:~/xv6-riscv$ kill 7579
> > osv@9fa911d4a918:~/xv6-riscv$ make clean
> > ............
> > osv@9fa911d4a918:~/xv6-riscv$ make qemu
> > ............
> > xv6 kernel is booting
> > 
> > hart 2 starting
> > hart 1 starting
> > page table 0x0000000087f6c000
> > ..0: pte 0x0000000021fda001 pa 0x0000000087f68000
> > .. ..0: pte 0x0000000021fd9c01 pa 0x0000000087f67000
> > .. .. ..0: pte 0x0000000021fda41b pa 0x0000000087f69000
> > .. .. ..1: pte 0x0000000021fd9817 pa 0x0000000087f66000
> > .. .. ..2: pte 0x0000000021fd9407 pa 0x0000000087f65000
> > .. .. ..3: pte 0x0000000021fd9017 pa 0x0000000087f64000
> > ..255: pte 0x0000000021fdac01 pa 0x0000000087f6b000
> > .. ..511: pte 0x0000000021fda801 pa 0x0000000087f6a000
> > .. .. ..510: pte 0x0000000021fdd007 pa 0x0000000087f74000
> > .. .. ..511: pte 0x0000000020001c0b pa 0x0000000080007000
> > init: starting sh
> > $ pgtbltest
> > pgaccess_test starting
> > pgaccess_test: OK
> > pgtbltest: all tests succeeded
> > $
> > ```

## 4. Lab4

> 别忘了在`Makefile`中加入
>
> ```txt
> $U/_bigfile\
> ```
>
> ### 4.1. 修改及代码(全在内核文件夹)
>
> >:one:`file.h`：第29行改成
> >
> >```C
> >uint addrs[NDIRECT+2];
> >```
> >
> >:two:`fs.c`：
> >
> >修改`bmap`函数
> >
> >```C
> >static uint bmap(struct inode* ip, uint bn) {
> >    uint addr, * a;
> >    struct buf* bp;
> >
> >    switch (bn < NDIRECT) {
> >        case 1:
> >            addr = ip->addrs[bn];
> >            switch (addr) {
> >                case 0:
> >                    ip->addrs[bn] = addr = balloc(ip->dev);
> >                    break;
> >            }
> >            return addr;
> >    }
> >    bn -= NDIRECT;
> >
> >    switch (bn < NINDIRECT) {
> >        case 1:
> >            addr = ip->addrs[NDIRECT];
> >            switch (addr) {
> >                case 0:
> >                    ip->addrs[NDIRECT] = addr = balloc(ip->dev);
> >                    break;
> >            }
> >            bp = bread(ip->dev, addr);
> >            a = (uint*)bp->data;
> >            addr = a[bn];
> >            switch (addr) {
> >                case 0:
> >                    a[bn] = addr = balloc(ip->dev);
> >                    log_write(bp);
> >                    break;
> >            }
> >            brelse(bp);
> >            return addr;
> >    }
> >    bn -= NINDIRECT;
> >
> >    switch (bn < NDUOINDIRECT) {
> >        case 1:
> >            addr = ip->addrs[NDIRECT + 1];
> >            switch (addr) {
> >                case 0:
> >                    ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
> >                    break;
> >            }
> >            bp = bread(ip->dev, addr);
> >            a = (uint*)bp->data;
> >            addr = a[bn / NINDIRECT];
> >            switch (addr) {
> >                case 0:
> >                    a[bn / NINDIRECT] = addr = balloc(ip->dev);
> >                    log_write(bp);
> >                    break;
> >            }
> >            brelse(bp);
> >            bp = bread(ip->dev, addr);
> >            a = (uint*)bp->data;
> >            addr = a[bn % NINDIRECT];
> >            switch (addr) {
> >                case 0:
> >                    a[bn % NINDIRECT] = addr = balloc(ip->dev);
> >                    log_write(bp);
> >                    break;
> >            }
> >            brelse(bp);
> >            return addr;
> >    }
> >
> >    panic("bmap: out of range");
> >}
> >
> >```
> >
> >修改`itrunc`函数
> >
> >```C
> >void itrunc(struct inode *ip) {
> >    int i, j, k;
> >    struct buf *bp, *bp2;
> >    uint *a, *a2;
> >
> >    i = 0;
> >    while(i < NDIRECT) {
> >        switch(ip->addrs[i]) {
> >            case 0:
> >                break;
> >            default:
> >                bfree(ip->dev, ip->addrs[i]);
> >                ip->addrs[i] = 0;
> >        }
> >        i++;
> >    }
> >
> >    if(ip->addrs[NDIRECT]) {
> >        bp = bread(ip->dev, ip->addrs[NDIRECT]);
> >        a = (uint*)bp->data;
> >        j = 0;
> >        while(j < NINDIRECT) {
> >            if(a[j])
> >                bfree(ip->dev, a[j]);
> >            j++;
> >        }
> >        brelse(bp);
> >        bfree(ip->dev, ip->addrs[NDIRECT]);
> >        ip->addrs[NDIRECT] = 0;
> >    }
> >
> >    // lab_4
> >    if(ip->addrs[NDIRECT+1]) {
> >        bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
> >        a = (uint*)bp->data;
> >        for(j = 0; j < NINDIRECT; ++j) {
> >            if(a[j]) {
> >                bp2 = bread(ip->dev, a[j]);
> >                a2 = (uint*)bp2->data;
> >                for(k = 0; k < NINDIRECT; ++k) {
> >                    if(a2[k])
> >                        bfree(ip->dev, a2[k]);
> >                }
> >                brelse(bp2);
> >                bfree(ip->dev, a[j]);
> >                a[j] = 0;
> >            }
> >        }
> >        brelse(bp);
> >        bfree(ip->dev, ip->addrs[NDIRECT+1]);
> >        ip->addrs[NDIRECT+1] = 0;
> >    }
> >
> >    ip->size = 0;
> >    iupdate(ip);
> >}
> >```
> >
> >:three:`fs.h`
> >
> >```C
> >#define NDIRECT 12
> >#define NINDIRECT (BSIZE / sizeof(uint))
> >#define MAXFILE (NDIRECT + NINDIRECT)
> >
> >//修改为
> >#define NDIRECT 11
> >#define NINDIRECT (BSIZE / sizeof(uint))
> >#define NDUOINDIRECT (NINDIRECT*NINDIRECT)
> >#define MAXFILE (NDIRECT + NINDIRECT + NDUOINDIRECT)
> >```
> >
> >```C
> >uint addrs[NDIRECT+1];
> >//修改为
> >uint addrs[NDIRECT+2];
> >```
> >
> >:four:`param.h`
> >
> >```C
> >#define FSSIZE       2000  
> >//修改为
> >#define FSSIZE       200000  
> >```
> >
>
> ### 4.2. 运行结果
>
> > ```terminal
> > PS C:\Users\Administrator\Desktop> docker exec -it xv6-labs /bin/bash
> > osv@bfa92b6a4f2d:~/xv6-riscv$ ps aux | grep qemu
> > osv       1409  0.0  0.0   3404  2380 pts/3    S+   13:52   0:00 make qemu
> > osv       1858  300  1.0 1709752 170644 pts/3  Sl+  13:52  23:18 qemu-system-
> > ............
> > osv@bfa92b6a4f2d:~/xv6-riscv$ kill 1858
> > osv@bfa92b6a4f2d:~/xv6-riscv$ make clean
> > ............
> > osv@bfa92b6a4f2d:~/xv6-riscv$ make qemu
> > ............
> > nmeta 70 (boot, super, log blocks 30 inode blocks 13, bitmap blocks 25) blocks 199930 total 200000
> > (这一步要等很长时间，别急)
> > ............
> > xv6 kernel is booting
> > 
> > hart 2 starting
> > hart 1 starting
> > meta 70 (boot, super, log blocks 30 inode blocks 13, bitmap blocks 25) blocks 199930 total 200000page table 0x0000000087f6c000
> > ..0: pte 0x0000000021fda001 pa 0x0000000087f68000
> > .. ..0: pte 0x0000000021fd9c01 pa 0x0000000087f67000
> > .. .. ..0: pte 0x0000000021fda41b pa 0x0000000087f69000
> > .. .. ..1: pte 0x0000000021fd9817 pa 0x0000000087f66000
> > .. .. ..2: pte 0x0000000021fd9407 pa 0x0000000087f65000
> > .. .. ..3: pte 0x0000000021fd9017 pa 0x0000000087f64000
> > ..255: pte 0x0000000021fdac01 pa 0x0000000087f6b000
> > .. ..511: pte 0x0000000021fda801 pa 0x0000000087f6a000
> > .. .. ..510: pte 0x0000000021fdd007 pa 0x0000000087f74000
> > .. .. ..511: pte 0x0000000020001c0b pa 0x0000000080007000
> > init: starting sh
> > $ bigfile
> > syntax
> > $ exec gfile failed
> > $ bigfile
> > ..................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
> > wrote 65803 sectors
> > done; ok
> > $
> > ```

## X.Git提交

> ```terminal
> PS C:\Users\Administrator\Desktop\Lab> git clone https://gitee.com/dann-hiroaki/xv6-riscv
> Cloning into 'xv6-riscv'...
> remote: Enumerating objects: 7254, done.
> remote: Counting objects: 100% (7254/7254), done.
> remote: Compressing objects: 100% (3421/3421), done.
> remote: Total 7254 (delta 3825), reused 7254 (delta 3825), pack-reused 0R
> Receiving objects: 100% (7254/7254), 17.29 MiB | 3.56 MiB/s, done.
> Resolving deltas: 100% (3825/3825), done.
> PS C:\Users\Administrator\Desktop\Lab> cd xv6-riscv
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git add .
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git commit -m "Lab1"
> [riscv e47fb96] Lab1
>  3 files changed, 113 insertions(+)
>  create mode 100644 user/find.c
>  create mode 100644 user/sleep.c
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git format-patch -1 HEAD
> 0001-Lab1.patch
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git add .
> warning: LF will be replaced by CRLF in 0001-Lab1.patch.
> The file will have its original line endings in your working directory
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git commit -m "Lab2"
> [riscv 195d028] Lab2
>  10 files changed, 235 insertions(+), 22 deletions(-)
>  create mode 100644 0001-Lab1.patch
>  rewrite kernel/syscall.h (95%)
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git format-patch -1 HEAD
> 0001-Lab2.patch
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git add .
> warning: LF will be replaced by CRLF in 0001-Lab2.patch.
> The file will have its original line endings in your working directory
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git commit -m "Lab3"
> [riscv b0007c5] Lab3
>  11 files changed, 502 insertions(+), 23 deletions(-)
>  create mode 100644 0001-Lab2.patch
>  rewrite kernel/syscall.h (95%)
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git format-patch -1 HEAD
> 0001-Lab3.patch
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git add .
> warning: LF will be replaced by CRLF in 0001-Lab3.patch.
> The file will have its original line endings in your working directory
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git commit -m "Lab4"
> [riscv 57407a8] Lab4
>  6 files changed, 788 insertions(+), 68 deletions(-)
>  create mode 100644 0001-Lab3.patch
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv> git format-patch -1 HEAD
> 0001-Lab4.patch
> PS C:\Users\Administrator\Desktop\Lab\xv6-riscv>
> ```
>
> <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231202142239998.png" alt="image-20231202142239998" style="zoom:50%;" /> 

