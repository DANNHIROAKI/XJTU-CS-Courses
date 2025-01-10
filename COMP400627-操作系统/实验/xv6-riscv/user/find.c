#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"

char* noSpace(char* dir)
{
static char newDir[DIRSIZ + 1];
int space = 0;
int buf = 0;
char* p = dir + strlen(dir) - 1;
while (p >= dir && *p == ' ') {
++space;
--p;
}
buf = DIRSIZ - space;
memmove(newDir, dir, buf);
newDir[buf] = 0;
return newDir;
}

void find(char* dir, char* name)
{
char buf[512], *p;
int fd;
struct dirent de;
struct stat st;

fd = open(dir, 0);
if (fd < 0) {
fprintf(2, "find: cannot open %s\n", dir);
return;
}

if (fstat(fd, &st) < 0) {
fprintf(2, "find: cannot fstat %s\n", dir);
close(fd);
return;
}

if (st.type == T_DEVICE || st.type == T_FILE) {
printf("find: not a directory value!\n");
close(fd);
} else if (st.type == T_DIR) {
if (strlen(dir) + 1 + DIRSIZ + 1 > sizeof buf) {
   printf("ls: path too long\n");
} else {
   strcpy(buf, dir);
   p = buf + strlen(buf);
   *p++ = '/';
   for (int readBytes = read(fd, &de, sizeof(de)); readBytes == sizeof de; readBytes = read(fd, &de, sizeof(de))) {
       if (de.inum == 0)
           continue;
       if (strcmp(".", noSpace(de.name)) == 0 || strcmp("..", noSpace(de.name)) == 0) {
           continue;
       }
       memmove(p, de.name, DIRSIZ);
       p[DIRSIZ] = 0;
       if (stat(buf, &st) < 0) {
           printf("find: cannot stat '%s'\n", buf);
           continue;
       }
       switch (st.type) {
           case T_DIR:
               find(buf, name);
               break;
           default:
               if (strcmp(name, noSpace(de.name)) == 0) {
                   printf("%s\n", buf);
               }
               break;
       }
   }
}
}
close(fd);
}

int main(int argc, char* argv[])
{
switch (argc) {
case 3:
   find(argv[1], argv[2]);
   break;
default:
   printf("Wrong directory or file name!\n");
   break;
}
exit(0);
}