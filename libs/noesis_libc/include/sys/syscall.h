#ifndef NOESIS_SYSCALL_H
#define NOESIS_SYSCALL_H

/* macOS syscall numbers for x86_64 */

/* Process control */
#define SYS_exit          0x2000001
#define SYS_fork          0x2000002
#define SYS_read          0x2000003
#define SYS_write         0x2000004
#define SYS_open          0x2000005
#define SYS_close         0x2000006
#define SYS_wait4         0x2000007
#define SYS_link          0x2000009
#define SYS_unlink        0x200000A
#define SYS_chdir         0x200000C
#define SYS_fchdir        0x200000D
#define SYS_mknod         0x200000E
#define SYS_chmod         0x200000F
#define SYS_chown         0x2000010
#define SYS_getpid        0x2000014
#define SYS_setuid        0x2000017
#define SYS_getuid        0x2000018
#define SYS_geteuid       0x2000019
#define SYS_ptrace        0x200001A
#define SYS_recvmsg       0x200001B
#define SYS_sendmsg       0x200001C
#define SYS_recvfrom      0x200001D
#define SYS_accept        0x200001E
#define SYS_getpeername   0x200001F
#define SYS_getsockname   0x2000020
#define SYS_access        0x2000021
#define SYS_chflags       0x2000022
#define SYS_fchflags      0x2000023
#define SYS_sync          0x2000024
#define SYS_kill          0x2000025
#define SYS_getppid       0x2000027
#define SYS_dup           0x2000029
#define SYS_pipe          0x200002A
#define SYS_getegid       0x200002B
#define SYS_sigaction     0x200002E
#define SYS_getgid        0x200002F
#define SYS_sigprocmask   0x2000030
#define SYS_getlogin      0x2000033
#define SYS_setlogin      0x2000034
#define SYS_acct          0x2000035
#define SYS_sigpending    0x2000037
#define SYS_sigaltstack   0x2000038
#define SYS_ioctl         0x2000039
#define SYS_reboot        0x200003A

/* File operations */
#define SYS_lseek         0x200001C
#define SYS_truncate      0x200004C
#define SYS_ftruncate     0x200004D
#define SYS_mkdir         0x2000088
#define SYS_rmdir         0x2000089

/* Memory management */
#define SYS_mmap          0x20000C5
#define SYS_munmap        0x20000C6
#define SYS_mprotect      0x200004A
#define SYS_mincore       0x200004B
#define SYS_madvise       0x200004E
#define SYS_msync         0x2000065
#define SYS_mlock         0x2000081
#define SYS_munlock       0x2000082
#define SYS_mlockall      0x2000183
#define SYS_munlockall    0x2000184

/* Time operations */
#define SYS_gettimeofday  0x2000074
#define SYS_settimeofday  0x2000075
#define SYS_nanosleep     0x2000162

#endif /* NOESIS_SYSCALL_H */
