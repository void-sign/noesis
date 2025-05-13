/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/math/math.h"

/* Exponential function implementation using Taylor series */
double nlibc_exp(double x) {
    /* Handle special cases */
    if (x == 0.0) {
        return 1.0;
    }
    
    /* For very large positive values, return infinity */
    if (x > 709.0) {
        return 1.0/0.0; /* Positive infinity */
    }
    
    /* For very large negative values, return 0 */
    if (x < -709.0) {
        return 0.0;
    }
    
    /* Use a Taylor series expansion for exp(x) */
    double result = 1.0;
    double term = 1.0;
    int n = 1;
    
    /* Sum the series until the term becomes small enough */
    do {
        term *= x / n;
        result += term;
        n++;
    } while (nlibc_fabs(term) > 1e-15 && n < 100); /* Limit iterations for safety */
    
    return result;
}

/* Float version of exponential function */
float nlibc_expf(float x) {
    return (float)nlibc_exp((double)x);
}

/* Implementation of frexp */
double nlibc_frexp(double value, int* exp) {
    *exp = 0;
    
    if (value == 0.0) {
        return 0.0;
    }
    
    double abs_value = nlibc_fabs(value);
    int sign = (value < 0.0) ? -1 : 1;
    
    /* Scale the value to between 0.5 and 1.0 */
    while (abs_value >= 1.0) {
        abs_value /= 2.0;
        (*exp)++;
    }
    
    while (abs_value < 0.5) {
        abs_value *= 2.0;
        (*exp)--;
    }
    
    return sign * abs_value;
}

/* Float version of frexp */
float nlibc_frexpf(float value, int* exp) {
    return (float)nlibc_frexp((double)value, exp);
}

/* Implementation of ldexp: x * 2^exp */
double nlibc_ldexp(double x, int exp) {
    if (x == 0.0) {
        return 0.0;
    }
    
    /* Simple implementation: multiply by powers of 2 */
    double result = x;
    if (exp > 0) {
        for (int i = 0; i < exp; i++) {
            result *= 2.0;
        }
    } else if (exp < 0) {
        for (int i = 0; i > exp; i--) {
            result /= 2.0;
        }
    }
    
    return result;
}

/* Float version of ldexp */
float nlibc_ldexpf(float x, int exp) {
    return (float)nlibc_ldexp((double)x, exp);
}

/* Natural logarithm (base e) implementation */
double nlibc_log(double x) {
    /* Handle special cases */
    if (x <= 0.0) {
        return 0.0/0.0; /* NaN for invalid inputs */
    }
    if (x == 1.0) {
        return 0.0;
    }
    
    /* Use a simplified approach based on properties of logarithms */
    int exponent;
    double mantissa = nlibc_frexp(x, &exponent);
    
    /* log(x) = log(mantissa * 2^exponent) = log(mantissa) + exponent * log(2) */
    double log2 = 0.693147180559945309; /* ln(2) */
    
    /* Use a series expansion for log(1+y) where y is small */
    double y = mantissa - 1.0;
    double y2 = y * y;
    double log_mantissa = y - y2/2.0 + y*y2/3.0 - y2*y2/4.0;
    
    return log_mantissa + exponent * log2;
}

/* Float version of logarithm */
float nlibc_logf(float x) {
    return (float)nlibc_log((double)x);
}

/* Base-10 logarithm implementation */
double nlibc_log10(double x) {
    /* log10(x) = log(x) / log(10) */
    return nlibc_log(x) * 0.434294481903251828; /* 1/ln(10) */
}

/* Float version of base-10 logarithm */
float nlibc_log10f(float x) {
    return (float)nlibc_log10((double)x);
}

/* Implementation of modf to split a value into integer and fractional parts */
double nlibc_modf(double value, double* iptr) {
    int sign = (value < 0.0) ? -1 : 1;
    double abs_value = value * sign;
    
    /* Extract the integer part */
    long integer_part = (long)abs_value;
    *iptr = (double)integer_part * sign;
    
    /* Return the fractional part */
    return value - *iptr;
}

/* Float version of modf */
float nlibc_modff(float value, float* iptr) {
    double int_part;
    float frac_part = (float)nlibc_modf((double)value, &int_part);
    *iptr = (float)int_part;
    return frac_part;
}
