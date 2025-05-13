#include "../../include/stdlib/stdlib.h"

/* Return absolute value of an integer */
int nlibc_abs(int j) {
    return (j < 0) ? -j : j;
}

/* Return absolute value of a long integer */
long nlibc_labs(long j) {
    return (j < 0) ? -j : j;
}

/* Return absolute value of a long long integer */
long long nlibc_llabs(long long j) {
    return (j < 0) ? -j : j;
}

/* Compute quotient and remainder of int division */
div_t nlibc_div(int numer, int denom) {
    div_t result;
    
    result.quot = numer / denom;
    result.rem = numer % denom;
    
    /* Adjust for negative values - ensure remainder has same sign as denominator */
    if (result.rem != 0 && ((numer < 0 && denom > 0) || (numer > 0 && denom < 0))) {
        result.quot--;
        result.rem += denom;
    }
    
    return result;
}

/* Compute quotient and remainder of long division */
ldiv_t nlibc_ldiv(long numer, long denom) {
    ldiv_t result;
    
    result.quot = numer / denom;
    result.rem = numer % denom;
    
    /* Adjust for negative values - ensure remainder has same sign as denominator */
    if (result.rem != 0 && ((numer < 0 && denom > 0) || (numer > 0 && denom < 0))) {
        result.quot--;
        result.rem += denom;
    }
    
    return result;
}

/* Compute quotient and remainder of long long division */
lldiv_t nlibc_lldiv(long long numer, long long denom) {
    lldiv_t result;
    
    result.quot = numer / denom;
    result.rem = numer % denom;
    
    /* Adjust for negative values - ensure remainder has same sign as denominator */
    if (result.rem != 0 && ((numer < 0 && denom > 0) || (numer > 0 && denom < 0))) {
        result.quot--;
        result.rem += denom;
    }
    
    return result;
}
