using Posix;

delegate unowned string GetenvMethod(string key);

// remain invisible in the environ variables
// see also: Execve.execve and Execve.execvp
[Compact]
class EnvironModify
{
	// credit: http://haxelion.eu/article/LD_NOT_PRELOADED_FOR_REAL/
	// removes an env variable (unsetenv?)

	public static string Remove(string key)
	{
		int j = 0, i = 0;
		GetenvMethod getenv = (GetenvMethod) DLHandles.LIBC().GetMethod("getenv");
		string initialValue = getenv(key);

		if(initialValue == null)
			return initialValue;
			
		bool shouldReturn = true;

		for (i = 0; environ[i] != null; i++)
		{
			bool found = true;
			char curKey = 'a', curEnviron = 'a';
			for(j = 0; (curKey = key[j]) != '\0' && (curEnviron = environ[i][j]) != '\0'; j++)
			{ // is this silly?
				if(curKey != curEnviron)
				{
					found = false;
					break;
				}
			}

			if(found)
			{
				memset(environ[i], 0, strlen((string)environ[i]));
				shouldReturn = false;
				break;
			}
		}

		if(shouldReturn)
			return initialValue;

		for(j = i; environ[j] != null; j++)
		{
			if(environ[j] == null)
			{
				break;
			}
			
			environ[j] = environ[j + 1];
		}
		
		return initialValue;
	}

	// credit: http://haxelion.eu/article/LD_NOT_PRELOADED_FOR_REAL/
	// replaces/adds an env variable (putenv?)

	public static char** AddOrReplace(char** envp, string key, string value)
	{
		int i, j, keyLocation = -1, newEnvSize;
		char** newEnv;

		for(i = 0; envp[i] != null; i++)
		{
			if(strstr((string) envp[i], key) != null)
			{
				keyLocation = i;
			}
		}

		newEnvSize = i;

		//key doesn't exist, add instead
		if(keyLocation == -1)
		{
			keyLocation = newEnvSize;
			newEnvSize++;
		}

		newEnv = (char**) malloc((newEnvSize + 1) * sizeof(char*));

		for(j = 0; j < newEnvSize; j++)
		{
			if(j == keyLocation)
			{
				newEnv[j] = (char*)(key + "=" + value);
			}
			else
			{
				newEnv[j] = (char*) envp[j];
			}
		}

		newEnv[newEnvSize] = null;

		return newEnv;
	}
}