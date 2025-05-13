/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/unistd/unistd.h"
#include "../../include/sys/syscall.h"
#include "../../include/stdlib/stdlib.h"
#include "../../include/string/string.h"

/* Implementation of execve - execute program */
int nlibc_execve(const char* pathname, char* const argv[], char* const envp[]) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* pathname */
        "movq %2, %%rsi\n"    /* argv */
        "movq %3, %%rdx\n"    /* envp */
        "movq $0x200003B, %%rax\n"  /* execve syscall number on macOS */
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

    /* Try to execute with the name as is */
    int result = nlibc_execv(file, argv);
    
    /* If we get here, execv has failed */
    nlibc_free(argv);
    return result;
}

/* Implementation of execle - execute with environment */
int nlibc_execle(const char* pathname, const char* arg, ...) {
    /* Count the number of arguments */
    va_list args;
    va_start(args, arg);
    int argc = 1;  /* Start with 1 for the first arg */
    
    const char* current_arg;
    while ((current_arg = va_arg(args, const char*)) != NULL) {
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
    /* Try to execute with the name as is */
    return nlibc_execv(file, argv);
}

/* Sleep for a specified number of seconds */
unsigned nlibc_sleep(unsigned seconds) {
    struct timespec ts_req, ts_rem;
    ts_req.tv_sec = seconds;
    ts_req.tv_nsec = 0;
    
    int result;
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* ts_req */
        "movq %2, %%rsi\n"    /* ts_rem */
        "movq $0x20000E2, %%rax\n"  /* nanosleep syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (&ts_req), "r" (&ts_rem)
        : "rax", "rdi", "rsi"
    );
    
    if (result == 0) {
        return 0;
    } else if (ts_rem.tv_sec > 0) {
        return (unsigned)ts_rem.tv_sec;
    } else {
        return 0;
    }
}

/* Implementation of dup - duplicate a file descriptor */
int nlibc_dup(int oldfd) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* oldfd */
        "movq $0x2000015, %%rax\n" /* dup syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((long)oldfd)
        : "rax", "rdi"
    );
    
    return result;
}

/* Implementation of dup2 - duplicate a file descriptor to a specified descriptor */
int nlibc_dup2(int oldfd, int newfd) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* oldfd */
        "movq %2, %%rsi\n"         /* newfd */
        "movq $0x2000090, %%rax\n" /* dup2 syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" ((long)oldfd), "r" ((long)newfd)
        : "rax", "rdi", "rsi"
    );
    
    return result;
}

/* Implementation of getcwd - get current working directory */
char* nlibc_getcwd(char* buf, size_t size) {
    if (buf == NULL || size == 0) {
        return NULL;
    }
    
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* buf */
        "movq %2, %%rsi\n"         /* size */
        "movq $0x200003D, %%rax\n" /* getcwd syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (buf), "r" (size)
        : "rax", "rdi", "rsi"
    );
    
    if (result < 0) {
        return NULL;
    }
    
    return buf;
}

/* Implementation of link - create a hard link */
int nlibc_link(const char* oldpath, const char* newpath) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* oldpath */
        "movq %2, %%rsi\n"         /* newpath */
        "movq $0x2000009, %%rax\n" /* link syscall number on macOS */
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
        "movq %1, %%rdi\n"         /* target */
        "movq %2, %%rsi\n"         /* linkpath */
        "movq $0x2000057, %%rax\n" /* symlink syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (target), "r" (linkpath)
        : "rax", "rdi", "rsi"
    );
    
    return result;
}

/* Implementation of chown - change file owner and group */
int nlibc_chown(const char* pathname, uid_t owner, gid_t group) {
    int result;
    
    __asm__ volatile (
        "movq %1, %%rdi\n"         /* pathname */
        "movl %2, %%esi\n"         /* owner */
        "movl %3, %%edx\n"         /* group */
        "movq $0x2000010, %%rax\n" /* chown syscall number on macOS */
        "syscall\n"
        "movl %%eax, %0\n"
        : "=r" (result)
        : "r" (pathname), "r" ((int)owner), "r" ((int)group)
        : "rax", "rdi", "rsi", "rdx"
    );
    
    return result;
}
