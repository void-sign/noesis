/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/unistd/unistd.h"
#include "../../include/sys/syscall.h"

/* Read from a file descriptor */
ssize_t nlibc_read(int fd, void* buf, size_t count) {
    ssize_t result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* fd */
        "movq %2, %%rsi\n"         /* buf */
        "movq %3, %%rdx\n"         /* count */
        "movq $0x2000003, %%rax\n" /* read syscall number on macOS */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (result)
        : "r" ((long)fd), "r" (buf), "r" (count)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* Write to a file descriptor */
ssize_t nlibc_write(int fd, const void* buf, size_t count) {
    ssize_t result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* fd */
        "movq %2, %%rsi\n"         /* buf */
        "movq %3, %%rdx\n"         /* count */
        "movq $0x2000004, %%rax\n" /* write syscall number on macOS */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (result)
        : "r" ((long)fd), "r" (buf), "r" (count)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* Close a file descriptor */
int nlibc_close(int fd) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* fd */
        "movq $0x2000006, %%rax\n" /* close syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((long)fd)
        : "rax", "rdi"
    );
    
    return result;
}

/* Reposition read/write file offset */
off_t nlibc_lseek(int fd, off_t offset, int whence) {
    off_t result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* fd */
        "movq %2, %%rsi\n"         /* offset */
        "movl %3, %%edx\n"         /* whence */
        "movq $0x20000C7, %%rax\n" /* lseek syscall number on macOS */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (result)
        : "r" ((long)fd), "r" (offset), "r" (whence)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* Check user's permissions for a file */
int nlibc_access(const char* pathname, int mode) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* pathname */
        "movl %2, %%esi\n"         /* mode */
        "movq $0x2000021, %%rax\n" /* access syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pathname), "r" (mode)
        : "rax", "rdi", "rsi"
    );
    
    return result;
}

/* Delete a name and possibly the file it refers to */
int nlibc_unlink(const char* pathname) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* pathname */
        "movq $0x200000A, %%rax\n" /* unlink syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pathname)
        : "rax", "rdi"
    );
    
    return result;
}

/* Delete a directory */
int nlibc_rmdir(const char* pathname) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* pathname */
        "movq $0x2000089, %%rax\n" /* rmdir syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pathname)
        : "rax", "rdi"
    );
    
    return result;
}

/* Change working directory */
int nlibc_chdir(const char* path) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* path */
        "movq $0x200000C, %%rax\n" /* chdir syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (path)
        : "rax", "rdi"
    );
    
    return result;
}

/* Get process ID */
pid_t nlibc_getpid(void) {
    pid_t result;
    
    __asm__ volatile (
        "movq $0x2000014, %%rax\n" /* getpid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :: "rax"
    );
    
    return result;
}

/* Get parent process ID */
pid_t nlibc_getppid(void) {
    pid_t result;
    
    __asm__ volatile (
        "movq $0x2000027, %%rax\n" /* getppid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :: "rax"
    );
    
    return result;
}

/* Create a child process */
pid_t nlibc_fork(void) {
    pid_t result;
    
    __asm__ volatile (
        "movq $0x2000002, %%rax\n" /* fork syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :: "rax"
    );
    
    return result;
}

/* Create pipe */
int nlibc_pipe(int pipefd[2]) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* pipefd */
        "movq $0x200002A, %%rax\n" /* pipe syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pipefd)
        : "rax", "rdi"
    );
    
    return result;
}

/* Terminate the calling process */
void nlibc_exit(int status) {
    __asm__ volatile (
        "movq %0, %%rdi\n"         /* status */
        "movq $0x2000001, %%rax\n" /* exit syscall number on macOS */
        "syscall\n"
        :
        : "r" ((long)status)
        : "rax", "rdi"
    );
    
    /* Should not reach here */
    while (1) {}
}

/* Get user ID */
uid_t nlibc_getuid(void) {
    uid_t result;
    
    __asm__ volatile (
        "movq $0x2000018, %%rax\n" /* getuid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :: "rax"
    );
    
    return result;
}

/* Get effective user ID */
uid_t nlibc_geteuid(void) {
    uid_t result;
    
    __asm__ volatile (
        "movq $0x2000019, %%rax\n" /* geteuid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :: "rax"
    );
    
    return result;
}

/* Get group ID */
gid_t nlibc_getgid(void) {
    gid_t result;
    
    __asm__ volatile (
        "movq $0x200002F, %%rax\n" /* getgid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :: "rax"
    );
    
    return result;
}

/* Get effective group ID */
gid_t nlibc_getegid(void) {
    gid_t result;
    
    __asm__ volatile (
        "movq $0x200002B, %%rax\n" /* getegid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :: "rax"
    );
    
    return result;
}

/* Set user ID */
int nlibc_setuid(uid_t uid) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* uid */
        "movq $0x2000017, %%rax\n" /* setuid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((long)uid)
        : "rax", "rdi"
    );
    
    return result;
}

/* Set group ID */
int nlibc_setgid(gid_t gid) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* gid */
        "movq $0x200002E, %%rax\n" /* setgid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((long)gid)
        : "rax", "rdi"
    );
    
    return result;
}
