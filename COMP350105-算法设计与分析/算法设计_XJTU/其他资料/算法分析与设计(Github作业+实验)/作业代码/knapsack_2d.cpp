#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

vector<int> weight = { 600, 400, 200, 200, 300 };

vector<int> volume = { 800, 400, 200, 200, 300 };

vector<int> value = { 8, 10, 4, 5, 5 };

void knapsack_2d(const int &c, const int &d) {
    const int n = value.size();
    //分配内存空间，存储m(i,j,k)
    int ***m = new int **[n + 1];
    for (int i = 0; i <= n; i++) {
        m[i] = new int *[c + 1];
        for (int j = 0; j <= c; j++)
            m[i][j] = new int[d + 1];
    }
    //分配内存空间，存储0-1向量
    int *x = new int[n + 1];

    //初始化m(n,j,k)
    for (int j = 0; j <= c; j++) {
        for (int k = 0; k <= d; k++) {
            m[n][j][k] = 0;
            if (j >= weight[n - 1] && k >= volume[n - 1])
                m[n][j][k] = value[n - 1];
        }
    }

    //求解子问题
    for (int i = n - 1; i > 0; i--) {
        for (int j = 0; j <= c; j++) {
            for (int k = 0; k <= d; k++) {
                m[i][j][k] = m[i + 1][j][k];
                if (j >= weight[i - 1] && k >= volume[i - 1])
                    m[i][j][k] = max(m[i + 1][j][k], m[i + 1][j - weight[i - 1]][k - volume[i - 1]] + value[i - 1]);
            }
        }
    }

    //构造最优解
    int temp1 = c, temp2 = d;
    for (int i = 1; i < n; i++) {
        if (m[i][temp1][temp2] == m[i + 1][temp1][temp2])
            x[i] = 0;
        else {
            x[i] = 1;
            temp1 -= weight[i - 1];
            temp2 -= volume[i - 1];
        }
    }
    x[n] = (m[n][c][d] > 0) ? 1 : 0;

    //输出
    cout << "最大价值：" << m[1][c][d] << endl;
    cout << "0-1向量：";
    for (int i = 1; i <= n; i++)
        cout << x[i] << ' ';

    //释放内存空间
    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= c; j++)
            delete[] m[i][j];
        delete[] m[i];
    }
    delete[] m;
    delete[] x;
}

//测试程序
int main(void) {
    int c = 1000;
    int d = 1000;
    knapsack_2d(c, d);

    return 0;
}
