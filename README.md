## One Rootkit
- One Rootkit to rule them all, One Rootkit to find them,
- One Rootkit to bring them all and in the darkness bind them

Status: ***Experimental*** / Version: **v0.1**

---
**Features**

 1. Hidden directories and files (by gid or by name)
 2. Hidden processes (by gid)
 3. Crashes your system

**Todo**

 1. Write a C source code obfuscator so it looks like shit on attacked boxes
 2. Pretty much the whole rootkit.

**How the hell are you compiling this?**
This rootkit is written in Vala, a language which compiles to C. Therefore, we must first compile the Vala code to C, and then compile it or ship the C code to the box. This is made simple via bash scripts. If you obtained this rootkit from an attacker, you are most likely to have got the C code, which is not trivial to understand.

**How/why aren't you linking GObject?**
When we compile the C code, we are compiling against minimal headers provided by github.com/radare/posixvalac, which allows a minimal implementation of Vala headers and allows the code to run without linking GObject or GLib or any other nasty stuff. This again is simplified via bash scripts.

---

This was an experiment.
Vala might output inefficient code which might hamper performance and thus make the rkit easily detectable.

- I am not responsible for you using this in any environment on any box.
- I am not responsible for anything that you do with this rootkit.
- I am not responsible if you get caught doing stuff you shouldn't be with this rootkit.

---

### Credits:

 * Mephisto
 * Aurora - C code behind OneRootkit.GetFdProcLink
 * http://haxelion.eu/article/LD_NOT_PRELOADED_FOR_REAL/

