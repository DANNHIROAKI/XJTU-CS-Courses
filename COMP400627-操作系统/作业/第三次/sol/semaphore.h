#ifndef SEMAPHORE_H
#define SEMAPHORE_H

typedef struct {
    int value;
} semaphore;

// 初始化信号量
void init_semaphore(semaphore *s, int value);

// P操作
void P(semaphore *s);

// V操作
void V(semaphore *s);

#endif
