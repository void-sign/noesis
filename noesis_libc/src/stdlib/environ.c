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
