#include "semaphore.h"
#include <stdio.h>
#include <stdlib.h>

void init_semaphore(semaphore *s, int value) {
    s->value = value;
}

void P(semaphore *s) {
    while (s->value <= 0);  // 自旋等待
    s->value--;
}

void V(semaphore *s) {
    s->value++;
}
