#ifndef NOESIS_MATH_H
#define NOESIS_MATH_H

/* Mathematical constants */
#define M_E         2.71828182845904523536  /* e */
#define M_LOG2E     1.44269504088896340736  /* log_2 e */
#define M_LOG10E    0.43429448190325182765  /* log_10 e */
#define M_LN2       0.69314718055994530942  /* log_e 2 */
#define M_LN10      2.30258509299404568402  /* log_e 10 */
#define M_PI        3.14159265358979323846  /* pi */
#define M_PI_2      1.57079632679489661923  /* pi/2 */
#define M_PI_4      0.78539816339744830962  /* pi/4 */
#define M_1_PI      0.31830988618379067154  /* 1/pi */
#define M_2_PI      0.63661977236758134308  /* 2/pi */
#define M_2_SQRTPI  1.12837916709551257390  /* 2/sqrt(pi) */
#define M_SQRT2     1.41421356237309504880  /* sqrt(2) */
#define M_SQRT1_2   0.70710678118654752440  /* 1/sqrt(2) */

/* Classification macros */
#define FP_NAN       0
#define FP_INFINITE  1
#define FP_ZERO      2
#define FP_SUBNORMAL 3
#define FP_NORMAL    4

/* Basic mathematical functions */
double nlibc_acos(double x);
float nlibc_acosf(float x);
double nlibc_asin(double x);
float nlibc_asinf(float x);
double nlibc_atan(double x);
float nlibc_atanf(float x);
double nlibc_atan2(double y, double x);
float nlibc_atan2f(float y, float x);
double nlibc_cos(double x);
float nlibc_cosf(float x);
double nlibc_sin(double x);
float nlibc_sinf(float x);
double nlibc_tan(double x);
float nlibc_tanf(float x);

/* Hyperbolic functions */
double nlibc_cosh(double x);
float nlibc_coshf(float x);
double nlibc_sinh(double x);
float nlibc_sinhf(float x);
double nlibc_tanh(double x);
float nlibc_tanhf(float x);

/* Exponential and logarithmic functions */
double nlibc_exp(double x);
float nlibc_expf(float x);
double nlibc_frexp(double value, int* exp);
float nlibc_frexpf(float value, int* exp);
double nlibc_ldexp(double x, int exp);
float nlibc_ldexpf(float x, int exp);
double nlibc_log(double x);
float nlibc_logf(float x);
double nlibc_log10(double x);
float nlibc_log10f(float x);
double nlibc_modf(double value, double* iptr);
float nlibc_modff(float value, float* iptr);

/* Power functions */
double nlibc_pow(double x, double y);
float nlibc_powf(float x, float y);
double nlibc_sqrt(double x);
float nlibc_sqrtf(float x);

/* Nearest integer, absolute value, and remainder functions */
double nlibc_ceil(double x);
float nlibc_ceilf(float x);
double nlibc_fabs(double x);
float nlibc_fabsf(float x);
double nlibc_floor(double x);
float nlibc_floorf(float x);
double nlibc_fmod(double x, double y);
float nlibc_fmodf(float x, float y);

/* Other functions */
double nlibc_round(double x);
float nlibc_roundf(float x);
double nlibc_trunc(double x);
float nlibc_truncf(float x);

#endif /* NOESIS_MATH_H */
