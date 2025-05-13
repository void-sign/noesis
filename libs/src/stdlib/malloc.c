#include "../../include/stdlib/stdlib.h"
#include "../../include/sys/syscall.h"

/* Internal memory block header structure */
typedef struct mem_block_header {
    size_t size;                      /* Size of the allocated block */
    unsigned char is_free;            /* Flag to indicate if the block is free */
    struct mem_block_header* next;    /* Pointer to the next block */
} mem_block_header_t;

/* Global variables for memory management */
static mem_block_header_t* g_head = NULL;
static size_t g_total_allocated = 0;
static size_t g_page_size = 4096;     /* Default page size */

/* Forward declarations of helper functions */
static mem_block_header_t* find_free_block(mem_block_header_t** last, size_t size);
static mem_block_header_t* request_space(mem_block_header_t* last, size_t size);
static void split_block(mem_block_header_t* block, size_t size);
static void merge_free_blocks(void);

/* Wrapper for the mmap system call */
static void* sys_mmap(void* addr, size_t length, int prot, int flags, int fd, size_t offset) {
    void* result;
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* addr */
        "movq %2, %%rsi\n"    /* length */
        "movl %3, %%edx\n"    /* prot */
        "movl %4, %%r10d\n"   /* flags */
        "movl %5, %%r8d\n"    /* fd */
        "movq %6, %%r9\n"     /* offset */
        "movq $0x20000C5, %%rax\n" /* macOS mmap syscall */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (result)
        : "r" (addr), "r" (length), "r" (prot), "r" (flags), "r" (fd), "r" (offset)
        : "rax", "rdi", "rsi", "rdx", "r10", "r8", "r9", "memory"
    );
    return result;
}

/* Wrapper for the munmap system call */
static int sys_munmap(void* addr, size_t length) {
    long result;
    __asm__ volatile (
        "movq %1, %%rdi\n"    /* addr */
        "movq %2, %%rsi\n"    /* length */
        "movq $0x20000C6, %%rax\n" /* macOS munmap syscall */
        "syscall\n"
        "movq %%rax, %0\n"
        : "=r" (result)
        : "r" (addr), "r" (length)
        : "rax", "rdi", "rsi", "memory"
    );
    return (int)result;
}

/* Find a free block of sufficient size */
static mem_block_header_t* find_free_block(mem_block_header_t** last, size_t size) {
    mem_block_header_t* current = g_head;
    while (current && !(current->is_free && current->size >= size)) {
        *last = current;
        current = current->next;
    }
    return current;
}

/* Request more memory from the operating system */
static mem_block_header_t* request_space(mem_block_header_t* last, size_t size) {
    size_t total_size = size + sizeof(mem_block_header_t);
    size_t alloc_size = ((total_size + g_page_size - 1) / g_page_size) * g_page_size;
    
    /* Use mmap to allocate memory */
    mem_block_header_t* block = sys_mmap(
        NULL,                   /* Let the OS decide the address */
        alloc_size,             /* Size to allocate */
        3,                      /* PROT_READ | PROT_WRITE */
        0x1002,                 /* MAP_PRIVATE | MAP_ANON */
        -1,                     /* fd: not used */
        0                       /* offset: not used */
    );
    
    if (block == (void*)-1) {
        return NULL;  /* mmap failed */
    }
    
    block->size = alloc_size - sizeof(mem_block_header_t);
    block->is_free = 0;
    block->next = NULL;
    
    g_total_allocated += alloc_size;
    
    if (last) {  /* If not the first block */
        last->next = block;
    }
    
    return block;
}

/* Split a block if it's too large */
static void split_block(mem_block_header_t* block, size_t size) {
    /* Only split if the remaining size is large enough for a new block */
    if (block->size >= size + sizeof(mem_block_header_t) + 16) {
        mem_block_header_t* new_block = (mem_block_header_t*)((char*)block + sizeof(mem_block_header_t) + size);
        new_block->size = block->size - size - sizeof(mem_block_header_t);
        new_block->is_free = 1;
        new_block->next = block->next;
        
        block->size = size;
        block->next = new_block;
    }
}

/* Merge adjacent free blocks */
static void merge_free_blocks(void) {
    mem_block_header_t* current = g_head;
    
    while (current && current->next) {
        if (current->is_free && current->next->is_free) {
            current->size += current->next->size + sizeof(mem_block_header_t);
            current->next = current->next->next;
        } else {
            current = current->next;
        }
    }
}

/* Align size to 16 bytes (common alignment for most architectures) */
static size_t align_size(size_t size) {
    return (size + 15) & ~15;
}

/* Implementation of malloc */
void* nlibc_malloc(size_t size) {
    if (size == 0) return NULL;
    
    size_t aligned_size = align_size(size);
    mem_block_header_t *block, *last = NULL;
    
    /* Try to find a free block */
    if ((block = find_free_block(&last, aligned_size))) {
        block->is_free = 0;
        split_block(block, aligned_size);
        return (void*)((char*)block + sizeof(mem_block_header_t));
    }
    
    /* No free block found, request a new one */
    block = request_space(last, aligned_size);
    if (!block) return NULL;
    
    /* If this is the first block, set it as the head */
    if (!g_head) g_head = block;
    
    return (void*)((char*)block + sizeof(mem_block_header_t));
}

/* Implementation of free */
void nlibc_free(void* ptr) {
    if (!ptr) return;
    
    /* Get the block header */
    mem_block_header_t* block = (mem_block_header_t*)((char*)ptr - sizeof(mem_block_header_t));
    
    /* Mark the block as free */
    block->is_free = 1;
    
    /* Merge adjacent free blocks */
    merge_free_blocks();
}

/* Implementation of calloc */
void* nlibc_calloc(size_t nmemb, size_t size) {
    size_t total_size;
    
    /* Check for multiplication overflow */
    if (size && nmemb > (size_t)-1 / size) return NULL;
    
    total_size = nmemb * size;
    void* ptr = nlibc_malloc(total_size);
    
    if (ptr) {
        /* Zero out the allocated memory */
        char* p = ptr;
        for (size_t i = 0; i < total_size; i++) {
            p[i] = 0;
        }
    }
    
    return ptr;
}

/* Implementation of realloc */
void* nlibc_realloc(void* ptr, size_t size) {
    if (!ptr) return nlibc_malloc(size);
    if (size == 0) {
        nlibc_free(ptr);
        return NULL;
    }
    
    mem_block_header_t* block = (mem_block_header_t*)((char*)ptr - sizeof(mem_block_header_t));
    size_t aligned_size = align_size(size);
    
    /* If new size is smaller, just split the block */
    if (block->size >= aligned_size) {
        split_block(block, aligned_size);
        return ptr;
    }
    
    /* If next block is free and combined size is enough */
    if (block->next && block->next->is_free && 
        (block->size + sizeof(mem_block_header_t) + block->next->size) >= aligned_size) {
        
        /* Combine with the next block */
        block->size += sizeof(mem_block_header_t) + block->next->size;
        block->next = block->next->next;
        
        /* Split if necessary */
        split_block(block, aligned_size);
        
        return ptr;
    }
    
    /* Need to allocate a new block */
    void* new_ptr = nlibc_malloc(size);
    if (!new_ptr) return NULL;
    
    /* Copy data to the new block */
    size_t copy_size = block->size < size ? block->size : size;
    char* src = (char*)ptr;
    char* dest = (char*)new_ptr;
    
    for (size_t i = 0; i < copy_size; i++) {
        dest[i] = src[i];
    }
    
    nlibc_free(ptr);
    return new_ptr;
}

/* Implementation of aligned_alloc */
void* nlibc_aligned_alloc(size_t alignment, size_t size) {
    /* Check if alignment is a power of 2 */
    if (alignment == 0 || (alignment & (alignment - 1))) return NULL;
    
    /* Check if size is a multiple of alignment */
    if (size % alignment != 0) return NULL;
    
    /* For now, use our regular malloc and hope for the best */
    /* In a real implementation, we would ensure proper alignment */
    return nlibc_malloc(size);
}
