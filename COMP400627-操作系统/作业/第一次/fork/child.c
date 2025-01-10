#include<stdio.h>       // 包含标准输入输出库
#include<unistd.h>      // 包含UNIX标准函数定义，例如fork()
#include<sys/types.h>   // 包含定义数据类型的头文件，例如pid_t
#include<sys/wait.h>    // 包含wait()函数

// 常量
#define CHILD_PROGRAM "./hatecode" // 定义要在子进程中执行的程序名

// 函数声明
void parent_behavior();    // 父进程行为函数
void child_behavior();     // 子进程行为函数

int main() 
{
    pid_t processID = fork();  // 创建一个子进程，并将返回的进程ID赋值给processID

    switch (processID)         // 根据fork()的返回值进行判断
    {
        case -1:               // fork失败
            perror("Failed to fork process");  // 打印错误信息
            return 1;          // 返回错误代码

        case 0:                // fork成功，并且这是子进程
            child_behavior();  // 执行子进程行为函数
            break;             // 退出switch结构

        default:               // fork成功，并且这是父进程
            parent_behavior(); // 执行父进程行为函数
            wait(NULL);        // 等待子进程结束
            break;             // 退出switch结构
    }

    return 0;  // 主函数正常退出
}

// 父进程行为函数定义
void parent_behavior() 
{
    printf("Papa loves to code.\n");      // 打印信息
    printf("Mama loves to code, too.\n");  // 打印信息
}

// 子进程行为函数定义
void child_behavior() 
{
    printf("While their child hates to code.\n"); // 打印信息
    char *programArgs[] = {CHILD_PROGRAM, NULL};  // 定义要执行的程序及其参数
    execvp(programArgs[0], programArgs);          // 使用execvp()执行程序
}

