#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
using namespace std;

//各个作业所需时间
vector<float> a = {2, 14, 4, 16, 6, 5, 3};

struct work {
    int id;         //作业编号
    float time;     //所需处理时间
    work(int a, float b): id(a), time(b) {}
    bool operator <(const work &x)const {
        return x.time < time;
    }
};

struct machine {
    int id;         //机器编号
    float avail;    //完成当前作业所需时间
    machine(int a, float b): id(a), avail(b) {}
    bool operator <(const machine &x)const {
        return x.avail < avail;
    }
};

//贪心算法
float LPT(int m) {
    int n = a.size();
    if (n <= m) {
        cout << "为每个作业分配一台机器" << endl;
        float total_time = a[0];
        for (int i = 1; i < n; i++)
            total_time = (a[i] > total_time) ? a[i] : total_time;
        return total_time;
    }

    //初始化作业
    vector<work> job;
    for (int i = 0; i < n; i++)
        job.push_back(work(i + 1, a[i]));
    //按作业处理时间降序排序
    sort(job.begin(), job.end());

    //初始化机器，建立小顶堆
    priority_queue<machine> MinHeap;
    for (int i = 0; i < m; i++)
        MinHeap.push(machine(i + 1, 0));

    //取堆顶机器，分配工作
    for (int i = 0; i < n; i++) {
        machine x = MinHeap.top();
        MinHeap.pop();
        cout << "将机器" << x.id << "从" << x.avail << "到" << x.avail + job[i].time
             << "的时间段分配给工作" << job[i].id << endl;
        x.avail += job[i].time;
        MinHeap.push(x);
    }

    //取最长工作时间
    for (int i = 0; i < m - 1; i++)
        MinHeap.pop();
    return MinHeap.top().avail;
}

int main(void) {
    int t = LPT(3);
    cout << "最短时间：" << t << endl;

    return 0;
}
