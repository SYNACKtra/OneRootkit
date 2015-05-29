/*
Credit:

http://haxelion.eu/article/LD_NOT_PRELOADED_FOR_REAL/
*/

#include <stdio.h>

// This will resolve at linking time
extern char **environ;

int main()
{
    long i, j;
    char env[] = "LD_PRELOAD";
    // Go through all environment strings, the end of the array 
    // is marked by a null pointer.
    for(i = 0; environ[i]; i++)
    {
        // Check is the string begins by LD_PRELOAD
        // I said NO CALL not even to strstr
        for(j = 0; env[j] != '\0' && environ[i][j] != '\0'; j++)
            if(env[j] != environ[i][j])
                break;
        // If the complete chain was found
        if(env[j] == '\0')
        {
            printf("detected");
            return 1;
        }
    }
    printf("not detected");
    return 0;
}
