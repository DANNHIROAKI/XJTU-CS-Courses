#include <iostream>
#include <queue>
using namespace std;

const int N = 101;  //权值上限
const int n = 5;    //顶点个数

//邻接矩阵（-1表示边不存在）
const int edge[n][n] = {
    {0, 10, -1, 30, 100},
    {-1, 0, 50, -1, -1},
    {-1, -1, 0, -1, 10},
    {-1, -1, 20, 0, 60},
    {-1, -1, -1, -1, 0}
};

void dijkstra(const int &source) {
    //处理错误输入
    if (source <= 0 || source > n) {
        cout << "False input!" << endl;
        return;
    }

    //初始化辅助数组
    int dist[n];
    for (int i = 0; i < n; i++)
        dist[i] = -1;
    bool visited[n] = {false};
    queue<int> bucket[N * n];

    bucket[0].push(source - 1);
    int count = 0;
    //线性扫描队列数组
    for (int i = 0; i < N * n; i++) {
        while (!bucket[i].empty()) {
            //出队列
            int v = bucket[i].front();
            bucket[i].pop();
            if (visited[v])
                continue;
            //获取最短路径
            dist[v] = i;
            visited[v] = true;
            count++;
            if (count == n)
                break;
            //将未访问的相邻顶点入队列
            for (int j = 0; j < n; j++) {
                if (!visited[j] && edge[v][j] > 0)
                    bucket[i + edge[v][j]].push(j);
            }
        }
        if (count == n)
            break;
    }

    //输出
    for (int i = 0; i < n; i++)
        cout << "dist[" << i + 1 << "]:" << dist[i] << endl;
}

//测试程序
int main(void) {
    cout << "source point(from 1-" << n << "):";
    int s;
    cin >> s;
    dijkstra(s);
    return 0;
}
