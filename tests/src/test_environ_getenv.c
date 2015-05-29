#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>

int main()
{
    if(getenv("LD_PRELOAD"))
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
