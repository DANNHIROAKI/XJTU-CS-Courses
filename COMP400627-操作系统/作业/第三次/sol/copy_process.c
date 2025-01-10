#include "semaphore.h"
#include <stdio.h>

extern semaphore empty1;
extern semaphore full1;
extern semaphore empty2;
extern semaphore full2;
extern char buffer1[SIZE1];
extern char buffer2[SIZE2];

void copy_process() {
    while(1) {
        P(&full1);  // 等待buffer1中有数据
        P(&empty2); // 等待buffer2有空位置

        // 从buffer1取数据
        char data = buffer1[0]; 
        // 假设处理数据就是将其转换为小写
        char processed_data = process_data(data);
        // 将处理后的数据放入buffer2的适当位置
        buffer2[full2.value] = processed_data;

        V(&empty1); // 释放buffer1的位置
        V(&full2);  // 增加buffer2中的数据项数
    }
}

char process_data(char data) {
    // 这里模拟处理数据的操作
    return data + 32; // 将大写字符转换为小写
}
