#include "../../include/stdlib/stdlib.h"

/* Helper function to determine if a character is a digit */
static int is_digit(char c) {
    return (c >= '0' && c <= '9');
}

/* Helper function to determine if a character is a space */
static int is_space(char c) {
    return (c == ' ' || c == '\t' || c == '\n' || c == '\v' || c == '\f' || c == '\r');
}

/* Convert string to integer */
int nlibc_atoi(const char* nptr) {
    int result = 0;
    int sign = 1;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Convert digits */
    while (is_digit(*nptr)) {
        result = result * 10 + (*nptr - '0');
        nptr++;
    }
    
    return result * sign;
}

/* Convert string to long */
long nlibc_atol(const char* nptr) {
    long result = 0;
    int sign = 1;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Convert digits */
    while (is_digit(*nptr)) {
        result = result * 10 + (*nptr - '0');
        nptr++;
    }
    
    return result * sign;
}

/* Convert string to long long */
long long nlibc_atoll(const char* nptr) {
    long long result = 0;
    int sign = 1;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Convert digits */
    while (is_digit(*nptr)) {
        result = result * 10 + (*nptr - '0');
        nptr++;
    }
    
    return result * sign;
}

/* Convert string to double */
double nlibc_atof(const char* nptr) {
    return nlibc_strtod(nptr, NULL);
}

/* Convert string to long with custom base */
long nlibc_strtol(const char* nptr, char** endptr, int base) {
    long result = 0;
    int sign = 1;
    int digit;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Handle base prefix */
    if (base == 0) {
        if (*nptr == '0') {
            nptr++;
            if (*nptr == 'x' || *nptr == 'X') {
                nptr++;
                base = 16;
            } else {
                base = 8;
            }
        } else {
            base = 10;
        }
    } else if (base == 16) {
        if (*nptr == '0' && (*(nptr+1) == 'x' || *(nptr+1) == 'X')) {
            nptr += 2;
        }
    }
    
    /* Convert digits */
    while (1) {
        if (is_digit(*nptr)) {
            digit = *nptr - '0';
        } else if (*nptr >= 'A' && *nptr <= 'Z') {
            digit = *nptr - 'A' + 10;
        } else if (*nptr >= 'a' && *nptr <= 'z') {
            digit = *nptr - 'a' + 10;
        } else {
            break;
        }
        
        if (digit >= base) {
            break;
        }
        
        result = result * base + digit;
        nptr++;
    }
    
    if (endptr != NULL) {
        *endptr = (char*)nptr;
    }
    
    return result * sign;
}

/* Convert string to unsigned long with custom base */
unsigned long nlibc_strtoul(const char* nptr, char** endptr, int base) {
    unsigned long result = 0;
    int sign = 1;
    int digit;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Handle base prefix */
    if (base == 0) {
        if (*nptr == '0') {
            nptr++;
            if (*nptr == 'x' || *nptr == 'X') {
                nptr++;
                base = 16;
            } else {
                base = 8;
            }
        } else {
            base = 10;
        }
    } else if (base == 16) {
        if (*nptr == '0' && (*(nptr+1) == 'x' || *(nptr+1) == 'X')) {
            nptr += 2;
        }
    }
    
    /* Convert digits */
    while (1) {
        if (is_digit(*nptr)) {
            digit = *nptr - '0';
        } else if (*nptr >= 'A' && *nptr <= 'Z') {
            digit = *nptr - 'A' + 10;
        } else if (*nptr >= 'a' && *nptr <= 'z') {
            digit = *nptr - 'a' + 10;
        } else {
            break;
        }
        
        if (digit >= base) {
            break;
        }
        
        result = result * base + digit;
        nptr++;
    }
    
    if (endptr != NULL) {
        *endptr = (char*)nptr;
    }
    
    /* Handle negative sign for unsigned value */
    if (sign == -1) {
        result = (unsigned long)(-(long)result);
    }
    
    return result;
}

/* Convert string to long long with custom base */
long long nlibc_strtoll(const char* nptr, char** endptr, int base) {
    long long result = 0;
    int sign = 1;
    int digit;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Handle base prefix */
    if (base == 0) {
        if (*nptr == '0') {
            nptr++;
            if (*nptr == 'x' || *nptr == 'X') {
                nptr++;
                base = 16;
            } else {
                base = 8;
            }
        } else {
            base = 10;
        }
    } else if (base == 16) {
        if (*nptr == '0' && (*(nptr+1) == 'x' || *(nptr+1) == 'X')) {
            nptr += 2;
        }
    }
    
    /* Convert digits */
    while (1) {
        if (is_digit(*nptr)) {
            digit = *nptr - '0';
        } else if (*nptr >= 'A' && *nptr <= 'Z') {
            digit = *nptr - 'A' + 10;
        } else if (*nptr >= 'a' && *nptr <= 'z') {
            digit = *nptr - 'a' + 10;
        } else {
            break;
        }
        
        if (digit >= base) {
            break;
        }
        
        result = result * base + digit;
        nptr++;
    }
    
    if (endptr != NULL) {
        *endptr = (char*)nptr;
    }
    
    return result * sign;
}

/* Convert string to unsigned long long with custom base */
unsigned long long nlibc_strtoull(const char* nptr, char** endptr, int base) {
    unsigned long long result = 0;
    int sign = 1;
    int digit;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Handle base prefix */
    if (base == 0) {
        if (*nptr == '0') {
            nptr++;
            if (*nptr == 'x' || *nptr == 'X') {
                nptr++;
                base = 16;
            } else {
                base = 8;
            }
        } else {
            base = 10;
        }
    } else if (base == 16) {
        if (*nptr == '0' && (*(nptr+1) == 'x' || *(nptr+1) == 'X')) {
            nptr += 2;
        }
    }
    
    /* Convert digits */
    while (1) {
        if (is_digit(*nptr)) {
            digit = *nptr - '0';
        } else if (*nptr >= 'A' && *nptr <= 'Z') {
            digit = *nptr - 'A' + 10;
        } else if (*nptr >= 'a' && *nptr <= 'z') {
            digit = *nptr - 'a' + 10;
        } else {
            break;
        }
        
        if (digit >= base) {
            break;
        }
        
        result = result * base + digit;
        nptr++;
    }
    
    if (endptr != NULL) {
        *endptr = (char*)nptr;
    }
    
    /* Handle negative sign for unsigned value */
    if (sign == -1) {
        result = (unsigned long long)(-(long long)result);
    }
    
    return result;
}

/* Convert string to double */
double nlibc_strtod(const char* nptr, char** endptr) {
    double result = 0.0;
    int sign = 1;
    double fraction = 0.0;
    double divisor = 1.0;
    int exponent = 0;
    int exponent_sign = 1;
    
    /* Skip leading whitespace */
    while (is_space(*nptr)) {
        nptr++;
    }
    
    /* Handle sign */
    if (*nptr == '-') {
        sign = -1;
        nptr++;
    } else if (*nptr == '+') {
        nptr++;
    }
    
    /* Convert integer part */
    while (is_digit(*nptr)) {
        result = result * 10.0 + (*nptr - '0');
        nptr++;
    }
    
    /* Convert fractional part */
    if (*nptr == '.') {
        nptr++;
        
        while (is_digit(*nptr)) {
            divisor *= 10.0;
            fraction = fraction * 10.0 + (*nptr - '0');
            nptr++;
        }
        
        result += fraction / divisor;
    }
    
    /* Handle exponent */
    if (*nptr == 'e' || *nptr == 'E') {
        nptr++;
        
        /* Handle exponent sign */
        if (*nptr == '-') {
            exponent_sign = -1;
            nptr++;
        } else if (*nptr == '+') {
            nptr++;
        }
        
        /* Convert exponent */
        while (is_digit(*nptr)) {
            exponent = exponent * 10 + (*nptr - '0');
            nptr++;
        }
        
        /* Apply exponent */
        double power = 1.0;
        for (int i = 0; i < exponent; i++) {
            power *= 10.0;
        }
        
        if (exponent_sign > 0) {
            result *= power;
        } else {
            result /= power;
        }
    }
    
    if (endptr != NULL) {
        *endptr = (char*)nptr;
    }
    
    return result * sign;
}
