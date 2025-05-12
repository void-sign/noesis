#ifndef NOESIS_UNISTD_H
#define NOESIS_UNISTD_H

#include "../noesis_types.h"

/* Standard file descriptors */
#define STDIN_FILENO  0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

/* File access constants */
#define F_OK 0 /* Test for existence */
#define X_OK 1 /* Test for execute permission */
#define W_OK 2 /* Test for write permission */
#define R_OK 4 /* Test for read permission */

/* Constants for lockf() function */
#define F_ULOCK 0 /* Unlock a previously locked region */
#define F_LOCK  1 /* Lock a region for exclusive use */
#define F_TLOCK 2 /* Test and lock a region for exclusive use */
#define F_TEST  3 /* Test a region for other processes locks */

/* System call functions */
ssize_t nlibc_read(int fd, void* buf, size_t count);
ssize_t nlibc_write(int fd, const void* buf, size_t count);
int nlibc_close(int fd);
off_t nlibc_lseek(int fd, off_t offset, int whence);
int nlibc_access(const char* pathname, int mode);
int nlibc_unlink(const char* pathname);
int nlibc_rmdir(const char* pathname);
int nlibc_chdir(const char* path);
char* nlibc_getcwd(char* buf, size_t size);
int nlibc_dup(int oldfd);
int nlibc_dup2(int oldfd, int newfd);
void nlibc_exit(int status);

/* Process control functions */
pid_t nlibc_fork(void);
int nlibc_execve(const char* pathname, char* const argv[], char* const envp[]);
int nlibc_execl(const char* pathname, const char* arg, ...);
int nlibc_execlp(const char* file, const char* arg, ...);
int nlibc_execle(const char* pathname, const char* arg, ...);
int nlibc_execv(const char* pathname, char* const argv[]);
int nlibc_execvp(const char* file, char* const argv[]);
pid_t nlibc_getpid(void);
pid_t nlibc_getppid(void);
int nlibc_pipe(int pipefd[2]);
unsigned nlibc_sleep(unsigned seconds);
int nlibc_chown(const char* pathname, uid_t owner, gid_t group);
int nlibc_link(const char* oldpath, const char* newpath);
int nlibc_symlink(const char* target, const char* linkpath);

/* User/group ID functions */
uid_t nlibc_getuid(void);
uid_t nlibc_geteuid(void);
gid_t nlibc_getgid(void);
gid_t nlibc_getegid(void);
int nlibc_setuid(uid_t uid);
int nlibc_setgid(gid_t gid);

/* Types are defined in noesis_types.h */

#endif /* NOESIS_UNISTD_H */
