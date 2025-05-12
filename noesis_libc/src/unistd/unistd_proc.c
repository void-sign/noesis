/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/unistd/unistd.h"
#include "../../include/sys/syscall.h"

/* Implementation of fork - create a new process */
pid_t nlibc_fork(void) {
    pid_t result;
    
    __asm__ volatile (
        "movq $0x2000002, %%rax\n"  /* fork syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :
        : "rax"
    );
    
    return result;
}

/* Implementation of execve - execute program */
int nlibc_execve(const char* pathname, char* const argv[], char* const envp[]) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* pathname */
        "movq %2, %%rsi\n"    /* argv */
        "movq %3, %%rdx\n"    /* envp */
        "movq $0x200003b, %%rax\n"  /* execve syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pathname), "r" (argv), "r" (envp)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* Implementation of execl - execute with variable argument list */
int nlibc_execl(const char* pathname, const char* arg, ...) {
    /* Count the number of arguments */
    va_list args;
    va_start(args, arg);
    int argc = 1;  /* Start with 1 for the first arg */
    
    while (va_arg(args, const char*) != NULL) {
        argc++;
    }
    va_end(args);
    
    /* Allocate array for arguments */
    char** argv = (char**)nlibc_malloc((argc + 1) * sizeof(char*));
    if (!argv) {
        return -1;
    }
    
    /* Fill the array with argument pointers */
    argv[0] = (char*)arg;
    va_start(args, arg);
    for (int i = 1; i < argc; i++) {
        argv[i] = va_arg(args, char*);
    }
    va_end(args);
    argv[argc] = NULL;
    
    /* Execute the program */
    int result = nlibc_execve(pathname, argv, NULL);
    
    /* If we get here, execve has failed */
    nlibc_free(argv);
    return result;
}

/* Implementation of execv - execute with argument array */
int nlibc_execv(const char* pathname, char* const argv[]) {
    return nlibc_execve(pathname, argv, NULL);
}

/* Implementation of execlp - execute using PATH */
int nlibc_execlp(const char* file, const char* arg, ...) {
    /* This is a simplification - a proper implementation would search PATH */
    /* For now, just forward to execl */
    return nlibc_execl(file, arg);
}

/* Implementation of execle - execute with environment */
int nlibc_execle(const char* pathname, const char* arg, ...) {
    /* Count the number of arguments */
    va_list args;
    va_start(args, arg);
    int argc = 1;  /* Start with 1 for the first arg */
    
    while (va_arg(args, const char*) != NULL) {
        argc++;
    }
    
    /* The environment pointer is after the NULL that terminates the arg list */
    char* const* envp = va_arg(args, char* const*);
    va_end(args);
    
    /* Allocate array for arguments */
    char** argv = (char**)nlibc_malloc((argc + 1) * sizeof(char*));
    if (!argv) {
        return -1;
    }
    
    /* Fill the array with argument pointers */
    argv[0] = (char*)arg;
    va_start(args, arg);
    for (int i = 1; i < argc; i++) {
        argv[i] = va_arg(args, char*);
    }
    va_end(args);
    argv[argc] = NULL;
    
    /* Execute the program */
    int result = nlibc_execve(pathname, argv, envp);
    
    /* If we get here, execve has failed */
    nlibc_free(argv);
    return result;
}

/* Implementation of execvp - execute using PATH */
int nlibc_execvp(const char* file, char* const argv[]) {
    /* This is a simplification - a proper implementation would search PATH */
    /* For now, just forward to execv */
    return nlibc_execv(file, argv);
}

/* Implementation of getpid - get process ID */
pid_t nlibc_getpid(void) {
    pid_t result;
    
    __asm__ volatile (
        "movq $0x2000014, %%rax\n"  /* getpid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :
        : "rax"
    );
    
    return result;
}

/* Implementation of getppid - get parent process ID */
pid_t nlibc_getppid(void) {
    pid_t result;
    
    __asm__ volatile (
        "movq $0x2000011, %%rax\n"  /* getppid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :
        : "rax"
    );
    
    return result;
}

/* Implementation of pipe - create a pipe */
int nlibc_pipe(int pipefd[2]) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* pipefd */
        "movq $0x2000042, %%rax\n"  /* pipe syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pipefd)
        : "rax", "rdi"
    );
    
    return result;
}

/* Implementation of sleep - sleep for a number of seconds */
unsigned nlibc_sleep(unsigned seconds) {
    unsigned int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* seconds */
        "xorq %%rsi, %%rsi\n" /* nanoseconds = 0 */
        "movq $0x20000E2, %%rax\n"  /* nanosleep syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((unsigned long)seconds)
        : "rax", "rdi", "rsi"
    );
    
    return result;
}

/* Implementation of chown - change file owner and group */
int nlibc_chown(const char* pathname, uid_t owner, gid_t group) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* pathname */
        "movl %2, %%esi\n"    /* owner */
        "movl %3, %%edx\n"    /* group */
        "movq $0x2000010, %%rax\n"  /* chown syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pathname), "r" ((int)owner), "r" ((int)group)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}

/* Implementation of link - create a hard link */
int nlibc_link(const char* oldpath, const char* newpath) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* oldpath */
        "movq %2, %%rsi\n"    /* newpath */
        "movq $0x2000009, %%rax\n"  /* link syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (oldpath), "r" (newpath)
        : "rax", "rdi", "rsi"
    );
    
    return result;
}

/* Implementation of symlink - create a symbolic link */
int nlibc_symlink(const char* target, const char* linkpath) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* target */
        "movq %2, %%rsi\n"    /* linkpath */
        "movq $0x2000057, %%rax\n"  /* symlink syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (target), "r" (linkpath)
        : "rax", "rdi", "rsi"
    );
    
    return result;
}

/* Implementation of getuid - get user ID */
uid_t nlibc_getuid(void) {
    uid_t result;
    
    __asm__ volatile (
        "movq $0x2000018, %%rax\n"  /* getuid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :
        : "rax"
    );
    
    return result;
}

/* Implementation of geteuid - get effective user ID */
uid_t nlibc_geteuid(void) {
    uid_t result;
    
    __asm__ volatile (
        "movq $0x200001D, %%rax\n"  /* geteuid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :
        : "rax"
    );
    
    return result;
}

/* Implementation of getgid - get group ID */
gid_t nlibc_getgid(void) {
    gid_t result;
    
    __asm__ volatile (
        "movq $0x200001B, %%rax\n"  /* getgid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :
        : "rax"
    );
    
    return result;
}

/* Implementation of getegid - get effective group ID */
gid_t nlibc_getegid(void) {
    gid_t result;
    
    __asm__ volatile (
        "movq $0x200001F, %%rax\n"  /* getegid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        :
        : "rax"
    );
    
    return result;
}

/* Implementation of setuid - set user ID */
int nlibc_setuid(uid_t uid) {
    int result;
    
    __asm__ volatile (
        "movl %1, %%edi\n"    /* uid */
        "movq $0x2000017, %%rax\n"  /* setuid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((int)uid)
        : "rax", "rdi"
    );
    
    return result;
}

/* Implementation of setgid - set group ID */
int nlibc_setgid(gid_t gid) {
    int result;
    
    __asm__ volatile (
        "movl %1, %%edi\n"    /* gid */
        "movq $0x200001A, %%rax\n"  /* setgid syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((int)gid)
        : "rax", "rdi"
    );
    
    return result;
}
