# xv6-labs

### 作业内容
#### 操作系统实验作业
本次操作系统实验作业主要包含四个实验，分别为实现简单Shell命令（Utility）、增加系统调用（System calls）、探索内存页表（Page tables）、增加文件系统支持大文件的功能（File system）。

每个实验作业的具体内容在该仓库对应的文件夹下**lab_1, lab_2, lab_3, lab_4**，作业分别标识出了难度等级(🍰数量)可供大家参考，每个实验作业包含四个大块，实验背景，实验内容，提示，结果自测，请大家在完成每次实验作业时认真阅读相关内容。

##### 实验环境准备
本次实验采用xv6-一个用来教学的简单的操作系统，xv6源码地址https://gitee.com/xjtu-osv/xv6-riscv.git  ，该仓库的README有对xv6的简单介绍，本次采用riscv版本的xv6，所需的系统说明材料见本仓库的References文件夹下的文件，列表如下：
+ xv6-book.pdf xv6操作系统手册
+ The RISC-V Instruction Set Manual-Unprivileged ISA.pdf， RISC-V非特权指令手册
+ The RISC-V Instruction Set Manual-Privileged Architecture.pdf  RISC-V特权指令手册
+ riscv-calling.pdf  RISC-V架构下的编译器调用约定
+ ritchie*.pdf unix系统的扩展阅读材料
+ git-cheat-sheet.pdf  git常用操作手册
+ gdb-cheat-sheet.pdf  gdb常用操作手册


实验环境采用docker容器形式，支持x86和arm64。docker安装参见https://docs.docker.com/get-docker/ 。docker安装完成后，将xv6源码仓库clone到本地，执行以下命令启动容器环境。

x86的机器使用命令 `docker run -it -v ${xv6-riscv-clone-path}:/home/osv/xv6-riscv --name xv6-labs xjtuosv/xv6-labs:amd64`

arm的机器使用命令`docker run -it -v ${xv6-riscv-clone-path}:/home/osv/xv6-riscv --name xv6-labs xjtuosv/xv6-labs:arm64`

假设clone到本地的路径是`/home/xjtu/xv6-riscv`，则执行`docker run -it -v /home/xjtu/xv6-riscv:/home/osv/xv6-riscv --name xv6-labs xjtuosv/xv6-labs:amd64`启动容器。

进入容器后检查环境是否正确，执行以下命令查看其输出是否正常
``` 
$ qemu-system-riscv64 --version
QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.14)
...

$ riscv64-linux-gnu-gcc --version
riscv64-linux-gnu-gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
...
```

正确配置实验环境后，使用命令`make qemu` 编译启动xv6, 输出以下内容则正确启动xv6
```
xv6 kernel is booting

hart 2 starting
hart 1 starting
init: starting sh
$
```

##### 提示
+ 确保你理解C语言和指针。Kernighan和Ritchie的书籍《C程序设计语言（第二版）》对C语言进行了简明扼要的描述。查看一些示例代码，确保你理解它们为什么会产生这些结果。
有一些常见的指针习惯用法需要特别注意：
	+ 如果有`int *p = (int*)100`，那么`(int)p + 1`和`(int)(p + 1)`是不同的值：第一个是101，而第二个是104。在将整数添加到指针时，如第二种情况中，整数会隐式乘以指针所指对象的大小。
	+ `p[i]`与`*(p+i)`相同，表示p指向的内存中的第`i`个对象。
	+ `&p[i]`与`(p+i)`相同，表示p指向的内存中的第i个对象的地址。

	尽管大多数C程序不需要在指针和整数之间进行类型转换，但操作系统实现时会经常用到。当你看到涉及内存地址的加法时，要仔细判断是整数加法还是指针加法。

+ 如果你已完成了一部分实验，可以通过git提交代码来暂存你的进展。如果以后出现问题，你可以回滚到检查点，逐步前进。要了解更多关于Git的信息，查看[Git用户手册](http://www.kernel.org/pub/software/scm/git/docs/user-manual.html)。

+ 如果你打印了大量输出，你希望对这些输出进行搜索；一种方法是在'script'中运行'make qemu'（在你的机器上运行'man script'），它会将所有控制台输出记录到一个文件中，然后你可以进行搜索。不要忘记退出'script'。

+ 添加打印语句通常是一个简单好用的调试方法，但有时我们需要能够单步执行一些汇编代码或检查堆栈上的变量。要在xv6中使用gdb，可以在一个窗口中运行'make qemu-gdb'，在另一个窗口中运行gdb-multiarch（或riscv64-linux-gnu-gdb）。设置一个断点，然后按'c'（继续），xv6将运行到命中断点为止。如果你启动gdb并看到类似'warning: File ".../.gdbinit" auto-loading has been declined'的警告时，按照警告中的建议，编辑~/.gdbinit，添加"add-auto-load-safe-path..."。
可以通过`docker exec -it xv6-labs bash`开启新的窗口来运行gdb-multiarch,对xv6进行调试。

+ 如果你想查看编译器为xv6内核生成的汇编代码，或查找特定内核地址处的指令是什么，查看文件'kernel/kernel.asm'，它在编译内核时由Makefile生成。 （Makefile还为所有用户程序生成.asm文件。）

+ 如果内核引发了意外故障（例如，使用无效的内存地址），它将打印一个错误消息，其中包含崩溃点的程序计数器（"sepc"）。你可以搜索'kernel.asm'以找到包含该程序计数器的函数，或者你可以运行'addr2line -e kernel/kernel pc-value'（运行'man addr2line'以获取详细信息）。如果你想要获取回溯信息，请使用gdb重新启动：在一个窗口中运行'make qemu-gdb'，在另一个窗口中运行gdb（'b panic'）后，按'c'（继续）。当内核命中断点时，输入'bt'以获取回溯信息。

+ 如果你的内核挂起，可能是由于死锁引起的，你可以使用gdb找出它挂在哪里。在一个窗口中运行'make qemu-gdb'，在另一个窗口中运行gdb（riscv64-linux-gnu-gdb），然后按'c'（继续）。当内核似乎挂起时，在qemu-gdb窗口中按Ctrl-C，并输入'bt'以获取回溯信息。

+ qemu有一个"monitor"可以让你查询模拟机的状态。你可以通过键入control-a c（"c"表示控制台）来访问它。一个特别有用的监视命令是'info mem'，用于打印页表。你可能需要使用'cpu'命令选择info mem查看的核心，或者你可以启动qemu，使用'make CPUS=1 qemu'来使只有一个核心。

### 截止时间
北京时间2023年12月2日00:00

### 提交要求
+ 问答类题目请在空白文档中书写答案，文档可以以markdown（推荐）、word、pdf等格式提交
+ 编程实现类题目，请自建文件夹，将相关题目涉及的源码文件放在同一个文件夹中提交代码
+ 每次实验作业完成后，提交git diff后的patch文件，基线为fork时仓库的最新commit。

### 使用说明

+ 请自行Fork每次作业的仓库到自己账号下，本地完成作业内容后提交到自己的远程仓库
+ git的基本操作请自行通过网络学习
