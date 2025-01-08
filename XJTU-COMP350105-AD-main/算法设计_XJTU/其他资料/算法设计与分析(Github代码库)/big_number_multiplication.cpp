#include<iostream>
#include<string.h>
#include<math.h>
using namespace std;

long long big_number_multiplication(string, string, int);

int main()
{
    string num1 = "12345678";
    string num2 = "87654321";
    int len = num1.length();
    long long ans = big_number_multiplication(num1, num2, len);
    cout << ans << endl;
    return 0;
}

long long big_number_multiplication(string num1, string num2, int len)
{
    int size = 0;
    string u1, u2, u3, v1, v2, v3;
    long long a = 0, b = 0, c = 0, d = 0, e = 0, f = 0;
    long long m1, m2, m3, m4, m5;
    long long w1, w2, w3, w4, w5;
    long long ans;

    if (len % 3 == 1)
    {
        num1 = "00" + num1;
        num2 = "00" + num2;
        len += 2;
    }
    else if (len % 3 == 2)
    {
        num1 = "0" + num1;
        num2 = "0" + num2;
        len += 1;
    }
    size = len / 3;
    for (int i = 0; i < size;i++)
    {
        u1 += num1[i];
        u2 += num1[i + size];
        u3 += num1[i + 2 * size];
        v1 += num2[i];
        v2 += num2[i + size];
        v3 += num2[i + 2 * size];
    }
    a = atoi(u1.c_str());
    b = atoi(u2.c_str());
    c = atoi(u3.c_str());
    d = atoi(v1.c_str());
    e = atoi(v2.c_str());
    f = atoi(v3.c_str());

    m1 = a * d;
    m2 = c * f;
    m3 = (a + b + c) * (d + e + f);
    m4 = (a - b + c) * (d - e + f);
    m5 = (a - 2 * b + 4 * c) * (d - 2 * e + 4 * f);

    w1 = m1;
    w2 = (m5 + 3 * m1 - 12 * m2 + 2 * m3 - 6 * m4) / 6;
    w3 = (m3 + m4) / 2 - m1 - m2;
    w4 = (-m5 - 3 * m1 + 12 * m2 + m3 + 3 * m4) / 6;
    w5 = m2;

    ans = w1 * pow(10.0, 4.0 * size) + w2 * pow(10.0, 3.0 * size) + w3 * pow(10.0, 2.0 * size) + w4 * pow(10.0, size) + w5;
    return ans;
}