#include <iostream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>

using namespace std;

// 算法要求：请编写一个算法，能够确定一个切割方案，使切割的总代价最小。

// 函数原型：

void MinCost(int L, int n, int *p) {
    //将切割点位置按升序排序
    sort(p, p + n + 2);

    //分配二维数组空间，c[i][j]表示从位置i到位置j的最小切割代价
    int **c = new int *[n + 2];
    for (int i = 0; i < n + 2; i++)
        c[i] = new int[n + 2];

    //为最小段钢条的切割代价赋初值0
    for (int i = 0; i < n + 1; i++) {
        c[i][i] = 0;
        c[i][i + 1] = 0;
    }
    c[n + 1][n + 1] = 0;

    //自底向上求解子问题
    for (int r = 3; r <= n + 2; r++) {
        for (int i = 0; i <= n - r + 2; i++) {
            int j = i + r - 1;
            c[i][j] = c[i + 1][j] + p[j] - p[i];
            for (int k = i + 2; k < j; k++) {
                int t = c[i][k] + c[k][j] + p[j] - p[i];
                if (t < c[i][j])
                    c[i][j] = t;
            }
        }
    }

    //输出结果
    cout << c[0][n + 1];

    //释放内存空间
    for (int i = 0; i < n + 2; i++)
        delete[] c[i];
    delete[] c;
}

//你的代码只需要补全上方函数来实现算法,可根据自己需要建立别的函数

//其中L是钢条长度，n是位置点个数，p包含n 个切割点的位置（乱序）

//只需要提交这几行代码，其他的都是后台系统自动完成的。类似于 LeetCode

int main() {

    // 后台自动给出测试代码放在这里，无需同学编写

    int L, n;
    cin >> L >> n;
    int *p;
    p = new int[n + 2];
    p[0] = 0;
    p[n + 1] = L;
    for (int i = 1; i < n + 1; i++) {
        cin >> p[i];
    }

    MinCost(L, n, p); //调用函数输出一个切割最小的代价和，结果通过cout输出，均为int类型

    return 0;

}
