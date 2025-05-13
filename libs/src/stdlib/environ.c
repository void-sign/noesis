#include "../../include/stdlib/stdlib.h"
#include "../../include/sys/syscall.h"

/* Constants for exit status codes */
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

/* Structure for atexit functions */
typedef struct atexit_entry {
    void (*func)(void);
    struct atexit_entry* next;
} atexit_entry_t;

/* Global variables */
static atexit_entry_t* atexit_funcs = NULL;
static int atexit_count = 0;
static const int MAX_ATEXIT_FUNCS = 32;

/* Register a function to be called on exit */
int nlibc_atexit(void (*func)(void)) {
    if (func == NULL || atexit_count >= MAX_ATEXIT_FUNCS) {
        return -1;
    }
    
    atexit_entry_t* entry = (atexit_entry_t*)nlibc_malloc(sizeof(atexit_entry_t));
    if (entry == NULL) {
        return -1;
    }
    
    entry->func = func;
    entry->next = atexit_funcs;
    atexit_funcs = entry;
    atexit_count++;
    
    return 0;
}

/* Exit the program with a status code */
void nlibc_exit(int status) {
    /* Call all registered atexit functions in reverse order */
    while (atexit_funcs != NULL) {
        atexit_entry_t* entry = atexit_funcs;
        atexit_funcs = atexit_funcs->next;
        
        if (entry->func != NULL) {
            entry->func();
        }
        
        nlibc_free(entry);
    }
    
    /* Use the syscall to exit */
    __asm__ volatile (
        "movl $60, %%eax\n"   /* syscall: exit */
        "movl %0, %%edi\n"    /* status code */
        "syscall\n"
        :
        : "r" (status)
        : "eax", "edi"
    );
    
    /* Should not reach here */
    while(1) {}
}

/* Abort the program */
void nlibc_abort(void) {
    /* Use the syscall to send SIGABRT signal (6) to self */
    __asm__ volatile (
        "movl $62, %%eax\n"   /* syscall: kill */
        "movl $0, %%edi\n"    /* pid: self (0) */
        "movl $6, %%esi\n"    /* signal: SIGABRT (6) */
        "syscall\n"
        :
        :
        : "eax", "edi", "esi"
    );
    
    /* In case the syscall fails, force exit */
    nlibc_exit(128 + 6);
    
    /* Should not reach here */
    while(1) {}
}

/* Get environment variable value */
char* nlibc_getenv(const char* name) {
    /* This is a stub implementation since we don't have access to environment variables */
    /* In a real implementation, we would access the environ array */
    (void)name; /* Suppress unused parameter warning */
    return NULL;
}

/* Execute a shell command */
int nlibc_system(const char* command) {
    /* This is a stub implementation since we don't have process spawning capabilities */
    /* In a real implementation, we would use fork + execve + waitpid */
    if (command == NULL) {
        /* Return non-zero if a command processor is available */
        return 0; /* Indicate no command processor is available */
    }
    return -1; /* Indicate failure */
}

/* Quick exit implementation */
static void (*quick_exit_funcs[32])(void);
static int quick_exit_count = 0;

/* Register a function to be called on quick_exit */
int nlibc_at_quick_exit(void (*func)(void)) {
    if (func == NULL || quick_exit_count >= 32) {
        return -1;
    }
    
    quick_exit_funcs[quick_exit_count++] = func;
    return 0;
}

/* Exit the program without calling atexit handlers */
void nlibc_quick_exit(int status) {
    /* Call all registered at_quick_exit functions in reverse order */
    for (int i = quick_exit_count - 1; i >= 0; i--) {
        if (quick_exit_funcs[i] != NULL) {
            quick_exit_funcs[i]();
        }
    }
    
    /* Call _Exit to terminate immediately */
    nlibc_exit(status);
}

/* Set an environment variable directly from a string "NAME=value" */
int nlibc_putenv(char* string) {
    if (string == NULL || !nlibc_strchr(string, '=')) {
        return -1;
    }
    
    /* Extract the name part */
    char* name_end = nlibc_strchr(string, '=');
    size_t name_len = name_end - string;
    
    /* Create a temporary buffer for the name */
    char name_buf[256];
    if (name_len >= sizeof(name_buf)) {
        return -1; /* Name too long */
    }
    
    /* Copy the name part */
    nlibc_strncpy(name_buf, string, name_len);
    name_buf[name_len] = '\0';
    
    /* Set the environment variable */
    return nlibc_setenv(name_buf, name_end + 1, 1);
}
