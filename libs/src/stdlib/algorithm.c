#include "../../include/stdlib/stdlib.h"

/* Helper function for qsort - swap two elements */
static void swap(char* a, char* b, size_t size) {
    char tmp;
    
    /* Swap byte by byte */
    for (size_t i = 0; i < size; i++) {
        tmp = a[i];
        a[i] = b[i];
        b[i] = tmp;
    }
}

/* Helper function for qsort - partition the array */
static char* partition(char* low, char* high, size_t size, int (*compar)(const void*, const void*)) {
    char* pivot = high; /* Choose the rightmost element as pivot */
    char* i = low - size;
    
    for (char* j = low; j <= high - size; j += size) {
        if (compar(j, pivot) < 0) {
            i += size;
            swap(i, j, size);
        }
    }
    
    i += size;
    swap(i, high, size);
    return i;
}

/* Helper function for qsort - recursive quicksort implementation */
static void quicksort(char* low, char* high, size_t size, int (*compar)(const void*, const void*)) {
    if (low < high) {
        char* pi = partition(low, high, size, compar);
        quicksort(low, pi - size, size, compar);
        quicksort(pi + size, high, size, compar);
    }
}

/* Sort an array using the quicksort algorithm */
void nlibc_qsort(void* base, size_t nmemb, size_t size, int (*compar)(const void*, const void*)) {
    if (base == NULL || size == 0 || nmemb <= 1 || compar == NULL) {
        return;
    }
    
    char* arr = (char*)base;
    quicksort(arr, arr + (nmemb - 1) * size, size, compar);
}

/* Search an array using binary search algorithm */
void* nlibc_bsearch(const void* key, const void* base, size_t nmemb, size_t size, int (*compar)(const void*, const void*)) {
    if (key == NULL || base == NULL || size == 0 || compar == NULL) {
        return NULL;
    }
    
    size_t low = 0;
    size_t high = nmemb - 1;
    const char* arr = (const char*)base;
    
    while (low <= high) {
        size_t mid = low + (high - low) / 2;
        const char* mid_ptr = arr + mid * size;
        int result = compar(key, mid_ptr);
        
        if (result == 0) {
            return (void*)mid_ptr;  /* Found the element */
        } else if (result < 0) {
            if (mid == 0) {
                break;  /* Avoid underflow */
            }
            high = mid - 1;
        } else {
            low = mid + 1;
        }
    }
    
    return NULL;  /* Element not found */
}
