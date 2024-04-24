#include <iostream>
#include <vector>
#include <list>
#include <unordered_set>
#include <unordered_map>
#include <random>

using namespace std;

const int PAGES = 10; // 可用的页数范围为0-9
const int REFERENCE_LENGTH = 20; // 生成的页面引用串的长度

// 该函数生成一个随机页面引用串
vector<int> generateReferenceString() {
    vector<int> reference;
    random_device rd; // 用于种子生成器
    mt19937 gen(rd()); // 基于随机设备的随机数生成器
    uniform_int_distribution<> dist(0, PAGES - 1); // 均匀分布，用于生成0-9的随机数

    for (int i = 0; i < REFERENCE_LENGTH; i++) {
        reference.push_back(dist(gen));
    }
    return reference;
}

// FIFO（先进先出）页面置换算法
int fifo(const vector<int>& reference, int frames) {
    int pageFaults = 0;
    unordered_set<int> s; // 当前帧的集合
    list<int> indexes; // 用于追踪页面到达的顺序

    for (int ref : reference) {
        // 如果页面不在当前帧中
        if (s.find(ref) == s.end()) {
            // 如果帧已满
            if (s.size() == frames) {
                int firstIn = indexes.front(); // 获取第一个进入的页面
                indexes.pop_front();
                s.erase(firstIn); // 从当前帧中移除该页面
            }
            s.insert(ref); // 插入新的页面到当前帧中
            indexes.push_back(ref); // 添加页面到追踪列表的末尾
            pageFaults++;
        }
    }

    return pageFaults;
}

// LRU（最近最少使用）页面置换算法
int lru(const vector<int>& reference, int frames) {
    int pageFaults = 0;
    unordered_set<int> s; // 当前帧的集合
    unordered_map<int, int> indexes; // 页面与其最近引用的索引的映射

    for (int i = 0; i < reference.size(); i++) {
        int ref = reference[i];
        if (s.find(ref) == s.end()) {
            if (s.size() == frames) {
                int lruPage = -1, lruIdx = INT_MAX;
                for (int page : s) {
                    if (indexes[page] < lruIdx) {
                        lruIdx = indexes[page];
                        lruPage = page;
                    }
                }
                s.erase(lruPage);
            }
            s.insert(ref);
            pageFaults++;
        }
        indexes[ref] = i; // 更新页面的最新索引
    }

    return pageFaults;
}

// OPT（最优）页面置换算法
int opt(const vector<int>& reference, int frames) {
    int pageFaults = 0;
    unordered_set<int> s; // 当前帧的集合
    unordered_map<int, int> nextUse; // 页面与其下一次使用的索引的映射

    for (int i = 0; i < reference.size(); i++) {
        int ref = reference[i];
        if (s.find(ref) == s.end()) {
            if (s.size() == frames) {
                int farthestIdx = -1, replacePage = -1;
                for (int page : s) {
                    // 如果页面在未来不会被引用，立即替换它
                    if (nextUse.find(page) == nextUse.end()) {
                        replacePage = page;
                        break;
                    } else if (nextUse[page] > farthestIdx) {
                        farthestIdx = nextUse[page];
                        replacePage = page;
                    }
                }
                s.erase(replacePage);
            }
            s.insert(ref);
            pageFaults++;
        }
        // 查找此页面的下一次引用
        nextUse.erase(ref);
        for (int j = i + 1; j < reference.size(); j++) {
            if (reference[j] == ref) {
                nextUse[ref] = j;
                break;
            }
        }
    }

    return pageFaults;
}

int main() {
    vector<int> reference = generateReferenceString();
    cout << "Generated Reference String: ";
    for (int r : reference) {
        cout << r << " ";
    }
    cout << endl;

    // 为1到7帧评估所有三种页面置换算法
    for (int frames = 1; frames <= 7; frames++) {
        cout << "\nFor " << frames << " frames:" << endl;
        cout << "FIFO: " << fifo(reference, frames) << " page faults." << endl;
        cout << "LRU : " << lru(reference, frames) << " page faults." << endl;
        cout << "OPT : " << opt(reference, frames) << " page faults." << endl;
    }

    return 0;
}
