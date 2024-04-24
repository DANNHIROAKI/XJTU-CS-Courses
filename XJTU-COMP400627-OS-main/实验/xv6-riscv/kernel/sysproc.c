#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64 sys_sysinfo(void)
{
uint64 si_addr;
argaddr(0, &si_addr);

struct sysinfo systeminfo;
systeminfo.freemem = freememcnt();
systeminfo.nproc = proccnt();

struct proc* p = myproc();

int copyResult = copyout(p->pagetable, si_addr, (char*)&systeminfo, sizeof(systeminfo));
switch (copyResult) {
 case -1:
   return -1;
 default:
   return 0;
}
}

int sys_pgaccess(void) {
 uint64 va;
 int page;
 uint64 ua;
 argaddr(0, &va);
 argint(1, &page);
 argaddr(2, &ua);

 const int MAX_PAGE_LIMIT = 1024; 
 if (page > MAX_PAGE_LIMIT) {
     return -1;
 }

 uint64 mask = 0;
 struct proc* p = myproc();
 int i = 0;
 while (i < page) {
     pte_t* pte = walk(p->pagetable, va + i * PGSIZE, 0);
     if (pte == 0) {
         return -1; // 页不存在时返回错误
     }
     switch (PTE_FLAGS(*pte) & PTE_A) {
         case PTE_A:
             mask |= (1L << i);
             *pte &= ~PTE_A; // 清除访问位
             break;
         default:
             break;
     }
     i++;
 }

 if (copyout(p->pagetable, ua, (char*)&mask, sizeof(mask)) < 0) {
     return -1; // 复制失败时返回错误
 }
 return 0;
}