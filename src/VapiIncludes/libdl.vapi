[CCode (cheader_filename = "dlfcn.h")]
void* dlopen(string filename, int flag);

[CCode (cheader_filename = "dlfcn.h")]
string dlerror();

[CCode (cheader_filename = "dlfcn.h")]
void* dlsym(void *handle, string symbol);

[CCode (cheader_filename = "dlfcn.h")]
int dlclose(void *handle);