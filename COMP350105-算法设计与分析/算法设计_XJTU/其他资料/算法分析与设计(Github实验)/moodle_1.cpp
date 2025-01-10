#include <iostream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>
#include <fstream>
using namespace std;

// 算法要求：请编写一段代码，能够在最坏情况下用 O(n)时间找出 n 个元素的带权中位数

int partition(int length, vector<int>& num, vector<double>& weight, int index , int p) {
    int tmpNum = num[index];
    num[index] = num[p];
    num[p] = tmpNum;
    double tmpWei = weight[index];
    weight[index] = weight[p];
    weight[p] = tmpWei;
    int pivotNum = num[index], L = index, R = length + index - 1;
    double pivotWei = weight[index];
    while (L < R) {
        while (num[R] > pivotNum && L < R) {
            R--;
        }
        num[L] = num[R];
        weight[L] = weight[R];
        while (num[L] <= pivotNum && L < R) {
            L++;
        }
        num[R] = num[L];
        weight[R] = weight[L];
    }
    num[L] = pivotNum;
    weight[L] = pivotWei;
    return L;
}

void print(int length, vector<int>& num, vector<double>& weight, int index,int mid,double left,double right) {
    for (int i = index; i < index + length; i++) {
        cout << num[i] << "\t" << weight[i] << endl;
    }
    double sum = 0;
    for (int i = index; i < index + length; i++) {
        sum += weight[i];
    }
    cout << "sum=" << sum << endl;
    cout << "left=" << left << "  right=" << right << "  wei[mid]=" << weight[mid] << endl << endl;
}
double sumWei(vector<double>& weight, int s, int f) {
    double ret = 0;
    for (int i = s; i < f; i++) {
        ret += weight[i];
    }
    return ret;
}
void WeightMedian(int length, vector<int>num, vector<double>weight, int index) {
    double left = 0, right = 0;
    int randInt = rand() % (length)+index;
    int mid = partition(length, num, weight, index, randInt);
    if (mid == index) {
        randInt = rand() % (length)+index;
        partition(length, num, weight, index, randInt);
    }
    left = sumWei(weight, index, mid);
    right = sumWei(weight, mid + 1, index + length);
    print(length, num, weight, index, mid, left, right);
    if (left <= 0.5 && right <= 0.5) {
        cout << num[mid] << endl;
        return;
    }
    if (left < right) {
        weight[mid] += left;
        WeightMedian(length - (mid - index), num, weight, mid);
    }
    else{
        weight[mid] += right;
        WeightMedian(mid - index + 1, num, weight, index);
    }
}

//你的代码只需要补全上方函数来实现算法

//其中length为输入长度，num是包含n个互不相同元素值的向量，weight是包含元素值对应的权重的向量，index为递归调用时的索引(下标)

//只需要提交这几行代码，其他的都是后台系统自动完成的。类似于 LeetCode

int main() {
    vector<int>num; vector<double>weight;
    ifstream data(".\\mooIn.txt");
    int length;
    data >> length;
    double L = 0, R = 0;
    for (int i = 0; i < length; i++) {
        int t;
        data >> t;
        num.push_back(t);
    }
    for (int i = 0; i < length; i++) {
        double t;
        data >> t;
        if (num[i] < 90473)    L += t;
        if (num[i] > 90473)    R += t;
        weight.push_back(t);
    }
    WeightMedian(length, num, weight, 0);
 
    // 后台自动给出测试代码放在这里，无需同学编写

    //测试代码将测试用例的三行数据分别导入length，num，和weight中

    //调用WeightMedian(length,num, weight,index)函数，函数内部使用cout输出得到的中位数，测试代码默认index初始值为0

    return 0;

}
