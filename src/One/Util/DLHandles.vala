using Posix;

[Compact]
public class DLHandles
{
	private static DLHandle libcHandle = null;

	public static unowned DLHandle LIBC()
	{
		if(libcHandle == null)
			libcHandle = new DLHandle("libc.so.6");

		return libcHandle;
	}

	public static unowned DLHandle PAM()
	{
		if(libcHandle == null)
			libcHandle = new DLHandle("libpam.so.0");

		return libcHandle;
	}
}

[Compact]
public class DLHandle
{
	public void* dlHandle = null;
	public unowned DLHandleMethod ListHead = null;

	public DLHandle(string library)
	{
		this.dlHandle = dlopen(library, LibDL.RTLD_LAZY);
	}

	public void* GetMethod(string methodName)
	{
		unowned DLHandleMethod current = this.ListHead;
		unowned DLHandleMethod prev = this.ListHead;

		// traverse the linked list for a value
		while(current != null)
		{
			if(Strings.equal(methodName, (string)current.Name))
			{
				return current.Method;
			}

			prev = current;
			if(current.Next != null)
				current = current.Next;
			else
				break;
		}

		// create /fresh/ method pointer
		DLHandleMethod* storedMethodPointer = (DLHandleMethod*) new DLHandleMethod(); // hack to make sure storedMethod doesn't get free()'d
		unowned DLHandleMethod storedMethod = (DLHandleMethod) storedMethodPointer;

		// set values of our new method
		storedMethod.Name = strdup(methodName);
		storedMethod.Method = dlsym(this.dlHandle, methodName);
		storedMethod.Next = null;

		if(prev != null)
		{
			prev.Next = storedMethod;
		}
		else
		{
			this.ListHead = storedMethod;
		}

		return storedMethod.Method;
	}
}

// if it wasn't 3AM, this would be a struct
[Compact]
public class DLHandleMethod
{
	public string Name;
	public void* Method;
	public unowned DLHandleMethod Next;
}