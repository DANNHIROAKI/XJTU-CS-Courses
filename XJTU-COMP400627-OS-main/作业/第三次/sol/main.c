#include "semaphore.h"
#include <stdio.h>
#include <pthread.h> // 假设使用POSIX线程

extern void get_process();
extern void copy_process();
extern void put_process();

semaphore empty1 = SIZE1;
semaphore full1 = 0;
semaphore empty2 = SIZE2;
semaphore full2 = 0;

char buffer1[SIZE1];
char buffer2[SIZE2];

int main() {
    pthread_t get_thread, copy_thread, put_thread;

    // 创建线程
    pthread_create(&get_thread, NULL, (void*)get_process, NULL);
    pthread_create(&copy_thread, NULL, (void*)copy_process, NULL);
    pthread_create(&put_thread, NULL, (void*)put_process, NULL);

    // 等待线程完成
    pthread_join(get_thread, NULL);
    pthread_join(copy_thread, NULL);
    pthread_join(put_thread, NULL);

    return 0;
}
