#include <iostream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>

using namespace std;

// 算法要求：请编写一段代码，能够在最坏情况下用 O(n)时间找出 n 个元素的带权中位数

// 函数原型：

void WeightMedian(int length, vector<int> num, vector<double> weight, int index) {
    if (length == 1) {
        cout << num[index];
        return;
    }

    //将元素随机划分成两组
    int low = index, high = length + index - 1;
    int temp = rand() % (length - 1) + index + 1;   //避免随机选择的结果是首元素
    swap(num[low], num[temp]);
    swap(weight[low], weight[temp]);
    int pivot = num[low];
    double pivot_w = weight[low];
    while (low < high) {
        while (low < high && num[high] > pivot)
            --high;
        num[low] = num[high];
        weight[low] = weight[high];
        while (low < high && num[low] <= pivot)
            ++low;
        num[high] = num[low];
        weight[high] = weight[low];
    }
    num[low] = pivot;
    weight[low] = pivot_w;

    //分别计算左右两组的权重和
    double left_weight = 0, right_weight = 0;
    for (int i = index; i < low; i++)
        left_weight += weight[i];
    for (int i = low + 1; i < length + index; i++)
        right_weight += weight[i];

    //递归
    if (left_weight <= 0.5 && right_weight <= 0.5)
        cout << num[low];
    else if (left_weight > right_weight) {
        weight[low] += right_weight;
        WeightMedian(low - index + 1, num, weight, index);
    } else {
        weight[low] += left_weight;
        WeightMedian(length - low + index, num, weight, low);
    }
}

//你的代码只需要补全上方函数来实现算法

//其中length为输入长度，num是包含n个互不相同元素值的向量，weight是包含元素值对应的权重的向量，index为递归调用时的索引(下标)

//只需要提交这几行代码，其他的都是后台系统自动完成的。类似于 LeetCode

int main() {

    // 后台自动给出测试代码放在这里，无需同学编写

    //测试代码将测试用例的三行数据分别导入length，num，和weight中

    //调用WeightMedian(length,num, weight,index)函数，函数内部使用cout输出得到的中位数，测试代码默认index初始值为0

    vector<int> num = { 719, 449, 446, 981, 431, 993, 919, 389, 549, 453 };
    vector<double> weight = { 0.01757775, 0.02028202, 0.16863048, 0.07320842, 0.16283562, 0.16167665, 0.14970060, 0.04095036, 0.12806645, 0.07707166 };
    int n = num.size();
    WeightMedian(n, num, weight, 0);

    return 0;

}
