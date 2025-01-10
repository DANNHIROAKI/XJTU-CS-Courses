# xv6-labs：lab 2

### 作业内容
#### 实验背景
在lab 1中，你使用系统调用编写了sleep和find实用程序。在本次实验中，你将向xv6添加一些新的系统调用，这将帮助你了解它们是如何工作的，并让你了解xv6内核的一些内部机制。

在开始编码之前，阅读xv6书籍的第2章，以及第4章的4.3和4.4节，以及相关的源文件：

+ 将用户空间的系统调用路由到内核的"存根"位于'user/usys.S'中，该文件在运行'make'时由'user/usys.pl'生成。声明位于'user/user.h'中。
+ 将系统调用路由到实现它的内核函数的内核空间代码位于'kernel/syscall.c'和'kernel/syscall.h'。
+ 与进程相关的代码在'kernel/proc.h'和'kernel/proc.c'中。

#### 实验内容：添加系统调用sysinfo （🍰🍰🍰）
在这个实验中，你需要添加一个系统调用，sysinfo，用于收集系统运行时的相关信息。这个系统调用接受一个参数，即指向一个结构体sysinfo的指针（参见'kernel/sysinfo.h'）。内核应填写这个结构体的字段：freemem字段应设置为空闲内存的字节数，nproc字段应设置为状态不是UNUSED的进程数量。

##### 提示
+ 在Makefile中的UPROGS中添加"$U/_sysinfotest"。
+ 运行'make qemu'；'user/sysinfotest.c'将无法编译。按照与之前任务相同的步骤添加系统调用'sysinfo'。要在'user/user.h'中声明'sysinfo()'的原型，需要预先声明'struct sysinfo'的存在：
```
struct sysinfo;
int sysinfo(struct sysinfo *);
```
解决了编译问题后，运行'sysinfotest'；它会执行失败，因为你尚未在内核中实现该系统调用。
+ 'sysinfo'需要将一个'struct sysinfo'传回用户空间；可以参考'kernel/sysfile.c'中的'sys_fstat()'和'kernel/file.c'中的'filestat()'，以了解如何使用'copyout()'来完成这一操作。
+ 为了收集空闲内存的数量，向'kernel/kalloc.c'添加一个函数。
+ 为了收集进程数量，向'kernel/proc.c'添加一个函数。

##### 结果自测
我们提供了一个名为sysinfotest的测试程序；如果它打印出"sysinfotest: OK"，则你完成了该实验。
