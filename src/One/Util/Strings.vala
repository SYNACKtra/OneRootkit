using Posix;

[Compact]
public class Strings
{
	//this is not as much cancer now, but could probably be improved
	//TODO: METHOD NAMES ARENT FOLLOWING OUR STANDARD, WHY??

	public static bool starts_with(string target, string value)
	{
		if(value.length > target.length)
		{
			return false;
		}

		string start = Strings.substring(target, 0, value.length);

		if(Strings.equal(start, value))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	public static string[] split(char* target, string delimiter)
	{
		GLib.List<string> result = new GLib.List<string>();

		char* target_split = strdup((string)target);
		unowned char* lasts;

		char* token = strtok_r((string)target_split, delimiter, out lasts);

		while(token != null)
		{
			result.append((string)token);
			//this is NOT how you use strtok_r, could have consequences
			token = strtok_r((string)lasts, delimiter, out lasts);
		}

		int i = 0;
		string[] output = new string[result.length()];
		foreach(string s in result)
		{
			output[i] = s;
			i++;
		}

		return output;
	}

	public static string substring(string target, int start, int end)
	{
		int length = (end - start);
		string result = (string) malloc(length + 1);
		memset(result, 0, length + 1);
		strncpy(result, (string)(((char*)target)+start), length);
		return (string) result;
	}

	public static bool equal(string str1, string str2)
	{
		return Posix.strcmp(str1, str2) == 0;
	}

	public static string fromInteger(int input)
	{
		char[16] buf = new char[16];
		memset(buf, 0, 16);
		snprintf(buf, 15, "%d", input);
		return (string)buf;
	}
}