#include "semaphore.h"
#include <stdio.h>

extern semaphore empty2;
extern semaphore full2;
extern char buffer2[SIZE2];

void put_process() {
    while(1) {
        P(&full2);  // 等待buffer2中有数据
        
        // 从buffer2取数并打印输出
        char data = buffer2[0]; 
        printf("Output: %c\n", data);

        V(&empty2); // 释放buffer2的位置
    }
}
