#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
switch (argc) {
case 2:
// 当参数数量正确时
int time = atoi(argv[1]);
if (sleep(time) != 0) {
   printf("Error!\n");
}
break;

default:
// 当参数数量不正确时
printf("You should input sleep times!\n");
}

exit(0);
}