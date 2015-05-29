[CCode (cprefix = "", lower_case_cprefix = "")]
namespace Posix
{
	[CCode (cheader_filename = "bits/stat.h", cname = "struct stat64", has_type_id = false)]
	public struct Stat64
	{
		public dev_t st_dev;
		public ino_t st_ino;
		public mode_t st_mode;
		public nlink_t st_nlink;
		public uid_t st_uid;
		public gid_t st_gid;
		public dev_t st_rdev;
		public size_t st_size;
		public timespec st_atim;
		public time_t st_atime;
		public timespec st_mtim;
		public time_t st_mtime;
		public timespec st_ctim;
		public time_t st_ctime;
		public blksize_t st_blksize;
		public blkcnt_t st_blocks;
	}

	[Compact]
	[CCode (cname = "struct dirent64", cheader_filename = "dirent.h", has_type_id = false)]
	public class DirEnt64
	{
		//these should probably use ino64_t etc but who cares
		public ino_t d_ino;
		public off_t d_off;
		public ushort d_reclen;
		public char d_type;
		public char d_name[256];
	}
}