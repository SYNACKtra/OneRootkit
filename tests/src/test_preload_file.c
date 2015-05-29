/*
This probably isn't being tested properly.

Credit:

http://haxelion.eu/article/LD_NOT_PRELOADED_FOR_REAL/
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>

int main()
{
    if(open("/etc/ld.so.preload", O_RDONLY) > 0)
    {
        printf("detected");
        return 1;
    }
    else
    {
        printf("not detected");
        return 0;
    }
}
