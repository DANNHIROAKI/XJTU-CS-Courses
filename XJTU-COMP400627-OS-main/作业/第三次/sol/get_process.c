#include "semaphore.h"
#include <stdio.h>

extern semaphore empty1;
extern semaphore full1;
extern char buffer1[SIZE1]; // 假设buffer1是一个字符数组

void get_process() {
    while(1) {
        P(&empty1);  // 等待buffer1有空位置
        
        // 假设从读卡机读取数据是一个字符
        char data = read_from_card_machine(); 
        // 将数据放入buffer1的适当位置
        buffer1[full1.value] = data;

        V(&full1);  // 增加buffer1中的数据项数
    }
}

char read_from_card_machine() {
    // 这里模拟从读卡机读取数据的操作
    return 'A'; // 例如，每次返回字符'A'
}
