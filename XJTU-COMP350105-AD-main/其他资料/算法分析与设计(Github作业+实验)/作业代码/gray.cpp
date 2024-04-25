#include <iostream>
#include <cmath>
using namespace std;
int count = 0;

int *Gray(int n) {
    int *a = new int[(int)pow(2, n) + 1];
    if (n == 1) {
        a[1] = 0;
        a[2] = 1;
        return a;
    }
    int *temp = Gray(n - 1);
    for (int i = 1; i <= (int)pow(2, n - 1); i++)
        a[i] = temp[i];
    for (int i = (int)pow(2, n - 1) + 1, k = 0; i <= (int)pow(2, n); i++, k++)
        a[i] = a[(int)pow(2, n - 1) - k] + (int)pow(2, n - 1);
    delete[] temp;
    return a;
}

void binary(int num, int n) {
    count++;
    int remainder;
    if (num <= 1) {
        if (count < n)
            for (int i = 0; i < n - count; i++)
                cout << 0;
        cout << num;
        return;
    }
    remainder = num % 2;
    binary(num >> 1, n);
    cout << remainder;
}

void printGray(int n) {
    int *a = Gray(n);
    for (int i = 1; i <= (int)pow(2, n); i++) {
        binary(a[i], n);
        cout << endl;
        count = 0;
    }
}

int main(void) {
    int n;
    cin >> n;
    printGray(n);
    return 0;
}
