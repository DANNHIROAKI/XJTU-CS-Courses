#include <iostream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

vector<string> article = {"Sun", "stressed", "that", "every", "resident", "in", "the", "municipality",
                          "with", "a", "permanent", "population", "of", "25", "million", "must", "undergo",
                          "nucleic", "acid", "tests", "in", "the", "citywide", "mass", "testing", ".", "She",
                          "said", "it", "is", "necessary", "to", "expand", "makeshift", "hospitals", "and",
                          "designated", "hospitals", "for", "COVID-19", "treatment", ",", "and", "required",
                          "the", "preparation", "of", "sufficient", "quarantine", "venues", "and", "swift",
                          "actions", "in", "transferring", "and", "treating", "patients", "."
                         };

void beauty_print(int *L, int M, int n) {
    //extra[i][j]表示将第i~j个单词打印到同一行时剩余的空格数
    int **extra = new int *[n + 1];
    for (int i = 0; i < n + 1; i++)
        extra[i] = new int[n + 1];
    //lc[i][j]表示将第i~j个单词打印到同一行时花费的代价
    unsigned long **lc = new unsigned long *[n + 1];
    for (int i = 0; i < n + 1; i++)
        lc[i] = new unsigned long[n + 1];
    //c[j]表示将第1~j个单词漂亮打印的最小代价
    unsigned long *c = new unsigned long[n + 1];
    //s[j]表示将第1~j个单词漂亮打印时最后一行的开头单词
    int *s = new int[n + 1];

    //初始化extra
    for (int i = 1; i <= n; i++) {
        for (int j = i; j <= n; j++) {
            int sum = 0;
            for (int k = i; k <= j; k++)
                sum += L[k];
            extra[i][j] = M - j + i - sum;
        }
    }

    //初始化lc
    for (int i = 1; i <= n; i++) {
        for (int j = i; j <= n; j++) {
            if (extra[i][j] < 0)
                lc[i][j] = INT_MAX;
            else if (j == n)
                lc[i][j] = 0;
            else
                lc[i][j] = (unsigned long)pow(extra[i][j], 3);
        }
    }

    //求解子问题
    c[0] = 0;
    for (int j = 1; j <= n; j++) {
        c[j] = lc[1][j];
        for (int i = 2; i <= j; i++) {
            unsigned long t = c[i - 1] + lc[i][j];
            if (t < c[j]) {
                c[j] = t;
                s[j] = i;
            }
        }
    }

    //构造最优解
    cout << "漂亮打印的最小代价：" << c[n] << endl;
    for (int i = 0; i < M; i++)
        cout << ' ';
    cout << 'M' << endl;
    vector<int> cut;
    int k = s[n];
    while (k > 0) {
        cut.push_back(k);
        k = s[k - 1];
    }
    reverse(cut.begin(), cut.end());
    int count = 0;
    for (int i = 0; i < article.size(); i++) {
        cout << article[i] << ' ';
        if (i == cut[count] - 2) {
            cout << endl;
            count++;
        }
    }

    //释放内存空间
    for (int i = 0; i < n + 1; i++)
        delete[] extra[i];
    delete[] extra;
    for (int i = 0; i < n + 1; i++)
        delete[] lc[i];
    delete[] lc;
    delete[] c;
    delete[] s;
}

//测试程序
int main(void) {
    int M = 50;
    int n = article.size();
    int *L = new int[n + 1];
    for (int i = 1; i <= n; i++)
        L[i] = article[i - 1].size();
    beauty_print(L, M, n);
    delete[] L;

    return 0;
}
