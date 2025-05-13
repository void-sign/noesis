/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Licensed under the Noesis License.
 */

#include "../../include/math/math.h"

/* Absolute value of int */
int nlibc_abs(int x) {
    return (x < 0) ? -x : x;
}

/* Absolute value of double */
double nlibc_fabs(double x) {
    return (x < 0.0) ? -x : x;
}

/* Absolute value of float */
float nlibc_fabsf(float x) {
    return (x < 0.0f) ? -x : x;
}

/* Floating point basic operations */

/* Implementation of sqrt using Newton's method */
double nlibc_sqrt(double x) {
    if (x < 0.0) {
        /* sqrt of negative number is not defined in real numbers */
        return 0.0/0.0;  /* Return NaN */
    }
    
    if (x == 0.0) {
        return 0.0;
    }
    
    /* Initial guess */
    double guess = x / 2.0;
    double epsilon = 1e-12;  /* Precision */
    
    /* Newton's method */
    while (nlibc_fabs(guess * guess - x) > epsilon) {
        guess = (guess + x / guess) * 0.5;
    }
    
    return guess;
}

/* Float version of square root */
float nlibc_sqrtf(float x) {
    return (float)nlibc_sqrt((double)x);
}

/* Power function implementation using a simple algorithm */
double nlibc_pow(double x, double y) {
    /* Handle special cases */
    if (y == 0.0) {
        return 1.0;
    }
    if (x == 0.0) {
        return 0.0;
    }
    if (y == 1.0) {
        return x;
    }
    
    /* Check for negative bases with non-integer exponents */
    if (x < 0.0 && y != (int)y) {
        /* This would give a complex number */
        return 0.0/0.0;  /* Return NaN */
    }
    
    /* Handle negative exponents */
    int invert = (y < 0.0);
    double absY = nlibc_fabs(y);
    
    /* Split y into integer and fractional parts */
    int intY = (int)absY;
    /* We're ignoring the fractional part for this simplified implementation */
    /* double fracY = absY - intY; */
    
    /* Calculate integer power */
    double result = 1.0;
    double base = x;
    
    while (intY > 0) {
        if (intY & 1) {
            result *= base;
        }
        base *= base;
        intY >>= 1;
    }
    
    /* Calculate fractional power using exp and log */
    /* Note: For a complete implementation, we'd need exp and log functions,
     * but we're simplifying here by omitting the fractional component */
    
    return invert ? (1.0 / result) : result;
}

/* Float version of power function */
float nlibc_powf(float x, float y) {
    return (float)nlibc_pow((double)x, (double)y);
}

/* Round to nearest integer, away from zero */
double nlibc_round(double x) {
    if (x < 0.0) {
        return (int)(x - 0.5);
    } else {
        return (int)(x + 0.5);
    }
}

/* Float version of round */
float nlibc_roundf(float x) {
    if (x < 0.0f) {
        return (int)(x - 0.5f);
    } else {
        return (int)(x + 0.5f);
    }
}

/* Round to smallest integral value not less than x */
double nlibc_ceil(double x) {
    int i = (int)x;
    return (x > i) ? (i + 1) : i;
}

/* Float version of ceil */
float nlibc_ceilf(float x) {
    int i = (int)x;
    return (x > i) ? (i + 1) : i;
}

/* Round to largest integral value not greater than x */
double nlibc_floor(double x) {
    int i = (int)x;
    return (x < i) ? (i - 1) : i;
}

/* Float version of floor */
float nlibc_floorf(float x) {
    int i = (int)x;
    return (x < i) ? (i - 1) : i;
}

/* Truncate to integer value */
double nlibc_trunc(double x) {
    return (x < 0.0) ? nlibc_ceil(x) : nlibc_floor(x);
}

/* Float version of truncate */
float nlibc_truncf(float x) {
    return (x < 0.0f) ? nlibc_ceilf(x) : nlibc_floorf(x);
}

/* Remainder of the floating point division operation */
double nlibc_fmod(double x, double y) {
    if (y == 0.0) {
        return 0.0/0.0;  /* Return NaN */
    }
    
    double quotient = x / y;
    return x - nlibc_trunc(quotient) * y;
}

/* Float version of fmod */
float nlibc_fmodf(float x, float y) {
    return (float)nlibc_fmod((double)x, (double)y);
}

/* Trigonometric functions */

/* Constant definitions for better precision */
#define NLIBC_PI 3.14159265358979323846
#define NLIBC_PI_2 1.57079632679489661923
#define NLIBC_PI_4 0.78539816339744830962

/* Sine function implementation using Taylor series */
double nlibc_sin(double x) {
    /* Normalize angle to -PI to PI range */
    while (x > NLIBC_PI) {
        x -= 2.0 * NLIBC_PI;
    }
    while (x < -NLIBC_PI) {
        x += 2.0 * NLIBC_PI;
    }
    
    /* Taylor series for sin(x) */
    double result = x;
    double term = x;
    double x_squared = x * x;
    
    /* First few terms of the series */
    for (int i = 1; i <= 5; i++) {
        term = -term * x_squared / (2 * i * (2 * i + 1));
        result += term;
    }
    
    return result;
}

/* Float version of sine */
float nlibc_sinf(float x) {
    return (float)nlibc_sin((double)x);
}

/* Cosine function using the identity cos(x) = sin(x + PI/2) */
double nlibc_cos(double x) {
    return nlibc_sin(x + NLIBC_PI_2);
}

/* Float version of cosine */
float nlibc_cosf(float x) {
    return (float)nlibc_cos((double)x);
}

/* Tangent function using the identity tan(x) = sin(x) / cos(x) */
double nlibc_tan(double x) {
    double c = nlibc_cos(x);
    if (c == 0.0) {
        /* Division by zero */
        return x > 0 ? 1.0/0.0 : -1.0/0.0;  /* Return infinity with appropriate sign */
    }
    return nlibc_sin(x) / c;
}

/* Float version of tangent */
float nlibc_tanf(float x) {
    return (float)nlibc_tan((double)x);
}

/* Arc sine function using a simple iterative approximation */
double nlibc_asin(double x) {
    /* Handle out of range inputs */
    if (x < -1.0 || x > 1.0) {
        return 0.0/0.0;  /* Return NaN */
    }
    
    /* Handle special cases */
    if (x == -1.0) return -NLIBC_PI_2;
    if (x == 0.0) return 0.0;
    if (x == 1.0) return NLIBC_PI_2;
    
    /* Use a simple approximation formula */
    return x + (x*x*x)/6 + (3*x*x*x*x*x)/40 + (5*x*x*x*x*x*x*x)/112;
}

/* Float version of arc sine */
float nlibc_asinf(float x) {
    return (float)nlibc_asin((double)x);
}

/* Arc cosine using the identity acos(x) = PI/2 - asin(x) */
double nlibc_acos(double x) {
    return NLIBC_PI_2 - nlibc_asin(x);
}

/* Float version of arc cosine */
float nlibc_acosf(float x) {
    return (float)nlibc_acos((double)x);
}

/* Arc tangent using a simple approximation */
double nlibc_atan(double x) {
    /* Handle special cases */
    if (x == 0.0) return 0.0;
    if (x == 1.0) return NLIBC_PI_4;
    if (x == -1.0) return -NLIBC_PI_4;
    
    /* Use range reduction for large values */
    if (nlibc_fabs(x) > 1.0) {
        return ((x > 0) ? NLIBC_PI_2 : -NLIBC_PI_2) - nlibc_atan(1.0/x);
    }
    
    /* Power series expansion */
    double x2 = x * x;
    return x - x * x2 / 3 + x * x2 * x2 / 5 - x * x2 * x2 * x2 / 7;
}

/* Float version of arc tangent */
float nlibc_atanf(float x) {
    return (float)nlibc_atan((double)x);
}

/* Two-argument arc tangent */
double nlibc_atan2(double y, double x) {
    /* Handle special cases */
    if (x == 0.0) {
        if (y > 0.0) return NLIBC_PI_2;
        if (y < 0.0) return -NLIBC_PI_2;
        return 0.0;  /* x = 0, y = 0 */
    }
    
    double angle = nlibc_atan(y / x);
    
    /* Adjust for quadrant */
    if (x < 0.0) {
        angle += (y >= 0.0) ? NLIBC_PI : -NLIBC_PI;
    }
    
    return angle;
}

/* Float version of two-argument arc tangent */
float nlibc_atan2f(float y, float x) {
    return (float)nlibc_atan2((double)y, (double)x);
}
