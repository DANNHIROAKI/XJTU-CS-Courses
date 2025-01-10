#include "poly.h"
#include "time.h"
void poly_optim(const double a[], double x, long degree, double* result) {
    double round[12];
    double x_value[12];

    round[4] = a[degree - 4];
    round[10] = a[degree - 10];
    round[8] = a[degree - 8];
    round[2] = a[degree - 2];
    round[6] = a[degree - 6];
    round[0] = a[degree];
    round[7] = a[degree - 7];
    round[1] = a[degree - 1];
    round[9] = a[degree - 9];
    round[11] = a[degree - 11];
    round[3] = a[degree - 3];
    round[5] = a[degree - 5];

    x_value[2] = x * x;
    x_value[3] = x_value[2] * x;
    x_value[4] = x_value[3] * x;
    x_value[5] = x_value[4] * x;
    x_value[6] = x_value[5] * x;
    x_value[7] = x_value[6] * x;
    x_value[8] = x_value[7] * x;
    x_value[9] = x_value[8] * x;
    x_value[10] = x_value[9] * x;
    x_value[11] = x_value[10] * x;
    x_value[12] = x_value[6] * x_value[6];

    int k = degree - 12;
    while (k >= 11)
    {
        round[0] = a[k] + round[0] * x_value[12];
        round[1] = a[k - 1] + round[1] * x_value[12];
        round[2] = a[k - 2] + round[2] * x_value[12];
        round[3] = a[k - 3] + round[3] * x_value[12];
        round[4] = a[k - 4] + round[4] * x_value[12];
        round[5] = a[k - 5] + round[5] * x_value[12];
        round[6] = a[k - 6] + round[6] * x_value[12];
        round[7] = a[k - 7] + round[7] * x_value[12];
        round[8] = a[k - 8] + round[8] * x_value[12];
        round[9] = a[k - 9] + round[9] * x_value[12];
        round[10] = a[k - 10] + round[10] * x_value[12];
        round[11] = a[k - 11] + round[11] * x_value[12];
        k = k - 12;
    }
    long degree_2 = degree + 1;
    int rest = (degree_2) % 12;
    double t_one = 0;
    int j = rest;
    while (j > 0)
    {
        t_one = t_one * x;
        t_one = t_one + a[j - 1];
        --j;
    }

    double mul_1 = round[0] * x_value[11];
    double mul_2 = round[1] * x_value[10];
    double mul_3 = round[2] * x_value[9];
    double mul_4 = round[3] * x_value[8];
    double mul_5 = round[4] * x_value[7];
    double mul_6 = round[5] * x_value[6];
    double mul_7 = round[6] * x_value[5];
    double mul_8 = round[7] * x_value[4];
    double mul_9 = round[8] * x_value[3];
    double mul_10 = round[9] * x_value[2];
    double mul_11 = round[10] * x + round[11];

    double t_two = mul_1 + mul_2 + mul_3 + mul_4 + mul_5 + mul_6 + mul_7 + mul_8 + mul_9 + mul_10 + mul_11;
    int i = 0;
    while (i < rest)
    {
        t_two = t_two * x;
        i++;
    }
    *result = t_one + t_two;
}


void measure_time(poly_func_t poly, const double a[], double x, long degree, double* time) {
    clock_t start_time, end_time;
    start_time = clock();
    int iteration = 0;
    while (iteration < 1000)
    {
        poly(a, x, degree, time);
        iteration++;
    }
    end_time = clock();
    clock_t time_while = end_time - start_time;
    *time = (double)(time_while);
}