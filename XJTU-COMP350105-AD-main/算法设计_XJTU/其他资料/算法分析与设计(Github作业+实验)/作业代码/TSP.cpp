#include <iostream>
#include <cfloat>
using namespace std;

const int n = 5;            //图G的顶点个数
int x[n + 1];               //当前解
int best_x[n + 1];          //当前最优解
float cost = 0;             //当前费用
float min_cost = FLT_MAX;   //当前最优值
float min_x[n + 1];         //从顶点i发出的边的最小费用

int count = 0;              //记录递归次数

//邻接矩阵
float a[n + 1][n + 1] = {
    0, 0, 0, 0, 0, 0,
    0, -1, 5, 61, 34, 12,
    0, 57, -1, 43, 20, 7,
    0, 39, 42, -1, 8, 21,
    0, 6, 50, 42, -1, 8,
    0, 41, 26, 10, 35, -1
};

//求从各顶点发出的边的最小费用
void x_min(void) {
    for (int i = 1; i <= n; i++) {
        min_x[i] = FLT_MAX;
        for (int j = 1; j <= n; j++) {
            if (j != i && a[i][j] < min_x[i])
                min_x[i] = a[i][j];
        }
    }
}

//约束函数
bool constraint(int t) {
    return a[x[t - 1]][x[t]] > 0;
}

//限界函数
bool bound(int t) {
    float sum_min = 0;
    for (int i = t; i <= n; i++)
        sum_min += min_x[x[i]];
    return min_cost > (cost + a[x[t - 1]][x[t]] + sum_min);
}

/*
//教材上的限界函数
bool bound(int t) {
    return min_cost > (cost + a[x[t - 1]][x[t]]);
}
*/

void backtrack(int t) {
    ::count++;
    if (t == n) {
        if (a[x[n - 1]][x[n]] > 0 && a[x[n]][1] > 0 && min_cost > cost + a[x[n - 1]][x[n]] + a[x[n]][1]) {
            for (int i = 1; i <= n; i++)
                best_x[i] = x[i];
            min_cost = cost + a[x[n - 1]][x[n]] + a[x[n]][1];
        }
    } else {
        for (int i = t; i <= n; i++) {
            //是否可以进入x[t]子树
            if (constraint(t) && bound(t)) {
                swap(x[t], x[i]);
                cost += a[x[t - 1]][x[t]];
                backtrack(t + 1);
                cost -= a[x[t - 1]][x[t]];
                swap(x[t], x[i]);
            }
        }
    }
}

float tsp(void) {
    for (int i = 1; i <= n; i++)
        x[i] = i;
    x_min();
    backtrack(2);
    return min_cost;
}

//测试程序
int main(void) {
    cout << "最小费用：" << tsp() << endl;
    cout << "路径：";
    for (int i = 1; i <= n; i++)
        cout << best_x[i] << "->";
    cout << best_x[1] << endl;
    cout << "递归次数：" << ::count << endl;

    return 0;
}
