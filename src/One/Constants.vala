using Posix;

public static int STAT_VER = 0; //_STAT_VER_LINUX 
								// this was 3 when checked the src?
public static int PATH_MAX = 4096;

[Compact]
public class LibDL
{
	public static void* RTLD_DEFAULT = ((void *) 0);
	public static void* RTLD_NEXT = (((void *) (0-1)));
	public static int RTLD_LAZY = 0x0001;
}