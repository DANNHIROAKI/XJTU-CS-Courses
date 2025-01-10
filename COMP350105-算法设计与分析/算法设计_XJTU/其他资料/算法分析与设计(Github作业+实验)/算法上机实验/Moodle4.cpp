#include <iostream>
#include <cmath>
#define ROW 1000
#define COL 20
#define A -1
#define B 1
using namespace std;

int matrix[ROW][COL];
bool mutex[COL][COL];
int result[COL];
int best[COL];
int now_sum;
int max_sum;

//判断第i列和第j列是否互斥
void judge(void) {
    for (int i = 0; i < COL; i++)
        for (int j = 0; j < COL; j++)
            mutex[i][j] = true;

    for (int i = 0; i < COL - 1; i++) {
        for (int j = i + 1; j < COL; j++) {
            bool tab = false;
            for (int k = 0; k < ROW; k++) {
                if (matrix[k][i] && matrix[k][j]) {
                    tab = true;
                    break;
                }
            }
            if (tab)
                mutex[i][j] = mutex[j][i] = false;
        }
    }
}

//判断集合是否为空
bool empty(int k) {
    for (int i = 0; i < COL; i++)
        if (result[i] == k)
            return false;
    return true;
}

//约束函数
//第j列可以放入集合A（k=-1）或B（k=1）中
bool constraint(int k, int j) {
    for (int i = 0; i < COL; i++) {
        if (result[i] != -k)
            continue;
        else if (mutex[i][j])
            continue;
        else
            return false;
    }
    return true;
}

//计算集合元素个数
int count(int k, int *array) {
    int sum = 0;
    for (int i = 0; i < COL; i++) {
        if (array[i] == k)
            sum++;
    }
    return sum;
}

//输出控制
//假设输出第一行为T1，第二行为T2
//T1的元素个数大于T2
//若元素个数相同，则T1的元素和小于T2
int output_control(void) {
    int A_num = count(A, best), B_num = count(B, best);
    if (A_num > B_num)
        return A;
    else if (A_num < B_num)
        return B;
    else {
        int A_sum = 0, B_sum = 0;
        for (int i = 0; i < COL; i++) {
            if (best[i] == A)
                A_sum += i;
            else if (best[i] == B)
                B_sum += i;
        }
        return (A_sum < B_sum) ? A : B;
    }
}

//回溯法
void backtrack(int t) {
    if (t == COL) {
        if (!empty(A) && !empty(B)) {
            if (now_sum > max_sum) {
                max_sum = now_sum;
                for (int i = 0; i < COL; i++)
                    best[i] = result[i];
            }
            //A和B元素个数差的绝对值最小
            else if (now_sum == max_sum) {
                int a1 = count(A, best), b1 = count(B, best);
                int a2 = count(A, result), b2 = count(B, result);
                if (abs(a1 - b1) > abs(a2 - b2))
                    for (int i = 0; i < COL; i++)
                        best[i] = result[i];
            }
        }
    } else {
        if (constraint(A, t)) {
            result[t] = A;
            now_sum++;
            backtrack(t + 1);
            now_sum--;
            result[t] = 0;
        }
        if (constraint(B, t)) {
            result[t] = B;
            now_sum++;
            backtrack(t + 1);
            now_sum--;
            result[t] = 0;
        }
        backtrack(t + 1);
    }
}

int main(void) {
    //输入
    for (int i = 0; i < ROW; i++)
        for (int j = 0; j < COL; j++)
            cin >> matrix[i][j];

    //求解
    judge();
    backtrack(0);

    //输出
    int k = output_control();
    for (int i = 0; i < COL; i++)
        if (best[i] == k)
            cout << i << ' ';
    cout << endl;
    for (int i = 0; i < COL; i++)
        if (best[i] == -k)
            cout << i << ' ';

    return 0;
}
