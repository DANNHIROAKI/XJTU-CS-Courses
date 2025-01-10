#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/fs.h"
#include "user/user.h"

int
main()
{
  char buf[BSIZE];
  int fd, i, sectors;

  fd = open("big.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    fprintf(2, "big: cannot open big.file for writing\n");
    exit(-1);
  }

  sectors = 0;
  while(1){
    *(int*)buf = sectors;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    sectors++;
	if (sectors % 100 == 0)
		fprintf(2, ".");
  }

  fprintf(1, "\nwrote %d sectors\n", sectors);

  close(fd);
  fd = open("big.file", O_RDONLY);
  if(fd < 0){
    fprintf(2, "big: cannot re-open big.file for reading\n");
    exit(-1);
  }
  for(i = 0; i < sectors; i++){
    int cc = read(fd, buf, sizeof(buf));
    if(cc <= 0){
      fprintf(2, "big: read error at sector %d\n", i);
      exit(-1);
    }
    if(*(int*)buf != i){
      fprintf(2, "big: read the wrong data (%d) for sector %d\n",
             *(int*)buf, i);
      exit(-1);
    }
  }
  if (sectors <= 268)
      fprintf(2, "bigfile: file is too small!\n");
  else
      fprintf(1, "done; ok\n"); 

  exit(0);
}