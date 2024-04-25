#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <vector>
#include <algorithm>
using namespace std;

// 算法要求：设计一个算法求 T 的最小顶点集合 S，使 T/S 为一个 d 森林。

//树的结点
struct Node {
    float weight;           //该结点到父结点的边上的权值
    int parent_id;          //该结点的父结点编号
    int num;                //该结点的子结点个数
    float max_road = 0;     //该结点到根结点的最大路径
    bool cut = false;       //是否在集合 S 中
};

class dTree {
    public:
        dTree(int a, int b) : n(a), d(b) {
            //此处为构造函数，初始化构建树。
            node = new Node[n];
            node[0].parent_id = -1;
            node[0].weight = 0;
            for (int i = 0; i < n; i++) {
                cin >> node[i].num;
                for (int j = 0; j < node[i].num; j++) {
                    int index;
                    cin >> index;
                    cin >> node[index].weight;
                    node[index].parent_id = i;
                }
            }
        }
        ~dTree(void) {
            delete[] node;
        }
        void solution(void) {
            //main函数通过调用dTree类的solution函数，通过cout输出结果。
            int count = 0;
            for (int i = n - 1; i >= 0; i--) {
                if (node[i].max_road > d) {
                    //删除结点
                    node[i].cut = true;
                    count++;
                } else {
                    //更新父结点
                    int par = node[i].parent_id;
                    if (par >= 0 && node[par].max_road < node[i].max_road + node[i].weight)
                        node[par].max_road = node[i].max_road + node[i].weight;
                }
            }
            cout << count;
        }
    private:
        int n;          //结点个数
        int d;          //最大路径长度
        Node *node;     //结点数组
};

//你的代码只需要补全上方dTree类来实现算法

//类所需要的其他变量、函数可自己定义编写

//只需要提交这几行代码，其他的都是后台系统自动完成的，类似于 LeetCode，下面为main函数的代码


int main() {
    int n, d;           //n为顶点个数，d为路径长度
    cin >> n >> d;
    dTree dt(n, d);     //构建与初始化树
    dt.solution();      //通过solution函数输出结果
    return 0;
}
