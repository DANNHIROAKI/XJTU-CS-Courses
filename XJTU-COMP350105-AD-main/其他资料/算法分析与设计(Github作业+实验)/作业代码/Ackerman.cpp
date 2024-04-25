#include <iostream>

int Ackerman(const int &m, const int &n) {
    if (m < 0 || n < 0)
        return -1;
    if (m == 0)
        return n + 1;
    int *val = new int[m + 1];
    int *ind = new int[m + 1];

    val[0] = 1;
    ind[0] = 0;
    for (int i = 1; i <= m; i++) {
        val[i] = -1;
        ind[i] = -2;
    }
    while (ind[m] < n) {
        val[0]++;
        ind[0]++;
        for (int i = 0; i < m; i++) {
            if (ind[i] == 1 && ind[i + 1] < 0) {
                val[i + 1] = val[0];
                ind[i + 1] = 0;
            }
            if (val[i + 1] == ind[i]) {
                val[i + 1] = val[0];
                ind[i + 1]++;
            }
        }
    }

    int ans = val[m];
    delete[] val;
    delete[] ind;
    return ans;
}

//测试程序
int main(void) {
    std::cout << Ackerman(3, 10);
    return 0;
}
