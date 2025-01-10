#include <iostream>
#include <algorithm>
using namespace std;
void MinCost(int L, int n, int* p) {
    sort(p, p + n + 2);
    int** costList = new int* [n + 2];
    for (int i = 0; i < n + 2; i++) {
        costList[i] = new int[n + 2];
    }
    for (int start = 0; start <= n + 1; start++) {
        for (int final = 0; final <= n + 1; final++) {
            if (start + 1 == final)   costList[start][final] = 0;
            if (start + 2 == final)  costList[start][final] = p[final] - p[start];
            if (start >= final) costList[start][final] = 0;
        }
    }
    for (int k = 3; k < n + 2; k++) {
        for (int s = 0; s < n + 2 - k; s++) {
            int min = 0x7fffffff;
            int sum;
            for (int i = s + 1; i < s + k; i++) {
                sum = costList[s][i] + costList[i][s + k];
                if (sum < min) min = sum;
            }
            costList[s][s + k] = min + p[s + k] - p[s];
        }
    }
    cout << costList[0][n + 1] << endl;
    for (int i = 0; i < n + 2; i++) {
        delete[] costList[i];
    }
    delete[] costList;
}

int main() {
  // 后台自动给出测试代码放在这里，无需同学编写
  int L, n;
  cin>>L>>n;
  int *p;
  p = new int[n+2];
  p[0] = 0;
  p[n+1] = L;
  for(int i=1;i<n+1;i++){
    cin>>p[i];
  }
  MinCost(L,n,p);//调用函数输出一个切割最小的代价和，结果通过cout输出，均为int类型
  return 0;
}
