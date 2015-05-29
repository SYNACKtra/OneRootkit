using Posix;

delegate unowned int ExecveMethod(string filename, char** argv, char** envp);
delegate unowned int ExecvpMethod(string filename, char** argv);

// the exec* branch of functions use execve...
public static int execve(string filename, char** argv, char** envp)
{
	ExecveMethod oldExecve = (ExecveMethod) DLHandles.LIBC().GetMethod("execve");

	bool normalExec = false;

	for(int i = 0; envp[i] != null; i++)
	{
		if(strstr((string) envp[i], "LD_TRACE_LOADED_OBJECTS") != null)
			normalExec = true;
		else if(strstr((string) envp[i], "LD_DEBUG") != null)
			normalExec = true;
	}

	char** newEnv = EnvironModify.AddOrReplace(envp, "LD_PRELOAD", Init_LDPRELOAD);

	int result = oldExecve(filename, argv, newEnv);
	free(newEnv);
	return result;
}

// ..except this special snowflake, who wants to use __execve
public static int execvp(string filename, char** argv)
{
	ExecvpMethod oldExecvp = (ExecvpMethod) DLHandles.LIBC().GetMethod("execvp");
	char** newEnv = EnvironModify.AddOrReplace(environ, "LD_PRELOAD", Init_LDPRELOAD);
	char** prevEnviron = environ;

	// onekit uses confuse, it's super effective
	environ = newEnv;
	int result = oldExecvp(filename, argv);
	environ = prevEnviron;

	free(newEnv);
	return result;
}