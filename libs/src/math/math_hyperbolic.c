/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/math/math.h"

/* This file implements hyperbolic functions and other missing functions
 * from the math.h header that are not yet implemented in math.c
 */

/* Hyperbolic sine function using the definition: sinh(x) = (e^x - e^-x)/2 */
double nlibc_sinh(double x) {
    /* For small x, use Taylor series for better precision */
    if (nlibc_fabs(x) < 0.1) {
        double x_cubed = x * x * x;
        double x_five = x_cubed * x * x;
        return x + x_cubed / 6.0 + x_five / 120.0;
    }
    
    /* For larger values, use the exponential formula */
    double exp_pos = 1.0;
    double exp_neg = 1.0;
    double term = 1.0;
    double x_abs = nlibc_fabs(x);
    
    /* Calculate e^|x| */
    for (int i = 1; i <= 20; i++) { /* 20 terms is usually enough for good precision */
        term *= x_abs / i;
        exp_pos += term;
    }
    
    /* Calculate e^-|x| = 1/e^|x| */
    exp_neg = 1.0 / exp_pos;
    
    /* Calculate (e^x - e^-x)/2 */
    double result = (exp_pos - exp_neg) / 2.0;
    
    /* Adjust sign based on input */
    return (x < 0.0) ? -result : result;
}

/* Float version of hyperbolic sine */
float nlibc_sinhf(float x) {
    return (float)nlibc_sinh((double)x);
}

/* Hyperbolic cosine function using the definition: cosh(x) = (e^x + e^-x)/2 */
double nlibc_cosh(double x) {
    /* For small x, use Taylor series for better precision */
    if (nlibc_fabs(x) < 0.1) {
        double x_squared = x * x;
        double x_four = x_squared * x_squared;
        return 1.0 + x_squared / 2.0 + x_four / 24.0;
    }
    
    /* For larger values, use the exponential formula */
    double exp_pos = 1.0;
    double exp_neg = 1.0;
    double term = 1.0;
    double x_abs = nlibc_fabs(x);
    
    /* Calculate e^|x| */
    for (int i = 1; i <= 20; i++) {
        term *= x_abs / i;
        exp_pos += term;
    }
    
    /* Calculate e^-|x| = 1/e^|x| */
    exp_neg = 1.0 / exp_pos;
    
    /* Calculate (e^x + e^-x)/2 */
    return (exp_pos + exp_neg) / 2.0;
}

/* Float version of hyperbolic cosine */
float nlibc_coshf(float x) {
    return (float)nlibc_cosh((double)x);
}

/* Hyperbolic tangent function using the definition: tanh(x) = sinh(x)/cosh(x) */
double nlibc_tanh(double x) {
    /* For large values, tanh approaches ±1 */
    if (x > 20.0) return 1.0;
    if (x < -20.0) return -1.0;
    
    /* For small x, use Taylor series for better precision */
    if (nlibc_fabs(x) < 0.1) {
        return x - (x * x * x) / 3.0;
    }
    
    /* For other values, use the standard formula */
    double sinh_val = nlibc_sinh(x);
    double cosh_val = nlibc_cosh(x);
    
    return sinh_val / cosh_val;
}

/* Float version of hyperbolic tangent */
float nlibc_tanhf(float x) {
    return (float)nlibc_tanh((double)x);
}

/* Exponential function e^x using Taylor series */
double nlibc_exp(double x) {
    /* Handle special cases */
    if (x == 0.0) return 1.0;
    
    /* Use Taylor series e^x = 1 + x + x^2/2! + x^3/3! + ... */
    double result = 1.0;
    double term = 1.0;
    
    for (int i = 1; i <= 20; i++) {  /* 20 terms for good precision */
        term *= x / i;
        result += term;
        
        /* Check for convergence */
        if (nlibc_fabs(term) < 1e-12 * nlibc_fabs(result)) {
            break;
        }
    }
    
    return result;
}

/* Float version of exponential function */
float nlibc_expf(float x) {
    return (float)nlibc_exp((double)x);
}

/* Natural logarithm using a simple approximation */
double nlibc_log(double x) {
    /* Handle special cases */
    if (x <= 0.0) {
        /* Log of negative numbers is not defined in real numbers */
        return 0.0/0.0;  /* Return NaN */
    }
    if (x == 1.0) return 0.0;
    
    /* For values close to 1, use Taylor series */
    if (nlibc_fabs(x - 1.0) < 0.25) {
        double y = (x - 1.0) / (x + 1.0);
        double y_squared = y * y;
        
        return 2.0 * (y + y * y_squared / 3.0 + y * y_squared * y_squared / 5.0);
    }
    
    /* For other values, use a simple approximation method */
    /* Log(x) = n*log(2) + log(x/2^n) where 0.5 <= x/2^n < 1 */
    
    double m = 0.0;
    while (x >= 2.0) {
        x /= 2.0;
        m += 0.693147180559945;  /* log(2) */
    }
    while (x < 0.5) {
        x *= 2.0;
        m -= 0.693147180559945;  /* log(2) */
    }
    
    /* Now 0.5 <= x < 1, use a polynomial approximation */
    double y = (x - 1.0) / (x + 1.0);
    double y_squared = y * y;
    
    return m + 2.0 * (y + y * y_squared / 3.0 + y * y_squared * y_squared / 5.0);
}

/* Float version of natural logarithm */
float nlibc_logf(float x) {
    return (float)nlibc_log((double)x);
}

/* Base-10 logarithm using the identity log10(x) = log(x) / log(10) */
double nlibc_log10(double x) {
    /* log(10) ≈ 2.302585092994046 */
    return nlibc_log(x) / 2.302585092994046;
}

/* Float version of base-10 logarithm */
float nlibc_log10f(float x) {
    return (float)nlibc_log10((double)x);
}

/* Split a float into integer and fractional parts */
double nlibc_modf(double value, double* iptr) {
    int sign = 1;
    
    if (value < 0.0) {
        sign = -1;
        value = -value;
    }
    
    *iptr = (double)(long)value;
    double fractional = value - *iptr;
    
    if (sign < 0) {
        *iptr = -*iptr;
        fractional = -fractional;
    }
    
    return fractional;
}

/* Float version of modf */
float nlibc_modff(float value, float* iptr) {
    double d_iptr;
    float result = (float)nlibc_modf((double)value, &d_iptr);
    *iptr = (float)d_iptr;
    return result;
}

/* Decompose floating point value into mantissa and exponent */
double nlibc_frexp(double value, int* exp) {
    if (value == 0.0) {
        *exp = 0;
        return 0.0;
    }
    
    double abs_value = nlibc_fabs(value);
    int e = 0;
    
    /* Normalize to [0.5, 1.0) range */
    while (abs_value >= 1.0) {
        abs_value *= 0.5;
        e++;
    }
    
    while (abs_value < 0.5) {
        abs_value *= 2.0;
        e--;
    }
    
    *exp = e;
    return (value < 0.0) ? -abs_value : abs_value;
}

/* Float version of frexp */
float nlibc_frexpf(float value, int* exp) {
    return (float)nlibc_frexp((double)value, exp);
}

/* Scale a floating point value by a power of 2 */
double nlibc_ldexp(double x, int exp) {
    /* x * 2^exp */
    double result = x;
    
    if (exp > 0) {
        while (exp-- > 0) {
            result *= 2.0;
        }
    } else if (exp < 0) {
        while (exp++ < 0) {
            result *= 0.5;
        }
    }
    
    return result;
}

/* Float version of ldexp */
float nlibc_ldexpf(float x, int exp) {
    return (float)nlibc_ldexp((double)x, exp);
}
