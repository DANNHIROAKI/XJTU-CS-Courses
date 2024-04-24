#include <iostream>
#include <algorithm>
#include <ctime>
#include <limits>
#include <vector>
#include <queue>
#include <variant>
#include <stack>
#include <functional> // 用于 std::function
#include <type_traits>


//存储0!--(9-1)!
int f(int n) {
    if (n == 0 || n == 1) {
        return 1;
    }
    return n * f(n - 1);
}
int fact[] = { f(0), f(1), f(2), f(3), f(4), f(5), f(6), f(7), f(8) };


//康托展开
int cantor(int board[]) {
    int ans = 0;
    int i = 0;
    while (i < 9) {
        int a = 0;
        for (int j = i + 1; j < 9; ++j) {
            if (board[i] > board[j]) a++;
        }
        ans += a * fact[8 - i];
        ++i;
    }
    return ans;
}

//逆康托展开
void rev_cantor(int num, int board[]) {
    std::vector<int> vec;
    int i = 0;
    while (i < 9) {
        vec.push_back(i);
        ++i;
    }

    i = 0;
    while (i < 9) {
        int pos = num / fact[8 - i];
        board[i] = vec[pos];
        vec.erase(vec.begin() + pos);
        num %= fact[8 - i];
        ++i;
    }
}

//使用逆序数判断是否有解
bool access(int board1[], int board2[]) {
    int n1 = 0, n2 = 0;
    int i = 0, j;

    // 处理board1
    while (i < 9) {
        j = i + 1;
        while (j < 9) {
            switch (board1[i] != 0 && board1[j] != 0 && board1[i] > board1[j]) {
            case true:
                ++n1;
                break;
            default:
                break;
            }
            ++j;
        }
        ++i;
    }

    // 重置索引，处理board2
    i = 0;
    while (i < 9) {
        j = i + 1;
        while (j < 9) {
            switch (board2[i] != 0 && board2[j] != 0 && board2[i] > board2[j]) {
            case true:
                ++n2;
                break;
            default:
                break;
            }
            ++j;
        }
        ++i;
    }

    // 判断两个逆序数是否同为奇数或偶数
    if ((n1 % 2) == (n2 % 2)) {
        return true;
    }
    else {
        return false;
    }
}


//搜索树结点
struct Node {
    Node(int n = 0, Node* p1 = NULL, Node* p2 = NULL, int g = 0) :
        num(n), self(p1), parent(p2), G(g), H(0) {
        if (g > 0) {
            //计算启发函数值
            int goal_pos[9][2] = { {1, 1}, {0, 0}, {0, 1}, {0, 2}, {1, 2}, {2, 2}, {2, 1}, {2, 0}, {1, 0} };
            int board[9];
            rev_cantor(num, board);
            for (int i = 0; i < 9; ++i) {
                int x = i / 3, y = i % 3;
                H += std::abs(x - goal_pos[board[i]][0]) + std::abs(y - goal_pos[board[i]][1]);
            }
        }
    }
    bool operator<(const Node& node) const {
        return (this->G + this->H) > (node.G + node.H);
    }
    int num;        //康托展开值
    int G;          //初始结点到当前结点的代价（当前结点深度）
    int H;          //当前结点到目标结点的代价（曼哈顿距离）
    Node* self;
    Node* parent;
    static int goal[9];
};


int Node::goal[9] = { 1, 2, 3, 8, 0, 4, 7, 6, 5 };

//输入
void input(int board[]) {
    int flag[9];
begin:
    std::cout << "input:" << std::endl;
    for (int i = 0; i < 9; ++i)
        flag[i] = 0;
    for (int i = 0; i < 9; ++i) {
        std::cin >> board[i];
        if (board[i] >= 0 && board[i] < 9) {
            ++flag[board[i]];
            if (flag[board[i]] > 1) {
                std::cout << "Error input!" << std::endl;
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
                goto begin;
            }
        }
        else {
            std::cout << "Error input!" << std::endl;
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            goto begin;
        }
    }
}

//输出
void output(Node node) {
    std::vector<Node> ans;
    while (node.parent) {
        ans.push_back(node);
        node = *(node.parent);
    }
    std::cout << ans.size() << " step(s):" << std::endl;
    for (int i = ans.size() - 1; i >= 0; --i) {
        std::cout << "------" << std::endl;
        int board[9];
        rev_cantor(ans[i].num, board);
        for (int j = 0; j < 3; ++j) {
            for (int k = 0; k < 3; ++k)
                std::cout << board[3 * j + k] << ' ';
            std::cout << std::endl;
        }
    }
}

bool visited[362880] = { false };

// 集成的移动函数模板
template <typename Container>
void moveAndCheckUnified(int board[], int pos, int move, Container& dataStructure, Node* parent, int* depth = nullptr, int G = 0) {
    std::swap(board[pos], board[pos + move]);
    int num = cantor(board);
    if (!visited[num]) {
        Node* node_ptr = new Node(num, NULL, parent, (depth == nullptr) ? G + 1 : *depth);
        node_ptr->self = node_ptr;
        dataStructure.push(*node_ptr);
        visited[num] = true;

        if (depth != nullptr) { // 专门为DFS设计
            --(*depth);
        }
    }
    std::swap(board[pos], board[pos + move]);
}



//BFS移动函数
void moveAndCheck(int board[], int pos, int move, std::queue<Node>& Q, Node* parent) {
    std::swap(board[pos], board[pos + move]);
    int num = cantor(board);
    if (!visited[num]) {
        Node* node_ptr = new Node(num, NULL, parent);
        node_ptr->self = node_ptr;
        Q.push(*node_ptr);
        visited[num] = true;
    }
    std::swap(board[pos], board[pos + move]);
}

//DFS移动函数
bool moveAndCheckDFS(int board[], int pos, int move, std::stack<Node>& S, Node* parent, int& depth) {
    std::swap(board[pos], board[pos + move]);
    int num = cantor(board);
    if (!visited[num]) {
        Node* node_ptr = new Node(num, NULL, parent);
        node_ptr->self = node_ptr;
        S.push(*node_ptr);
        visited[num] = true;
        --depth;
        std::swap(board[pos], board[pos + move]);
        return true; // 表示移动并添加了新节点
    }
    std::swap(board[pos], board[pos + move]);
    return false; // 表示没有移动或添加新节点
}

//A*移动函数
void moveAndCheckAStar(int board[], int pos, int move, std::priority_queue<Node>& Q, Node* parent, int G) {
    std::swap(board[pos], board[pos + move]);
    int num = cantor(board);
    if (!visited[num]) {
        Node* node_ptr = new Node(num, NULL, parent, G + 1);
        node_ptr->self = node_ptr;
        Q.push(*node_ptr);
        visited[num] = true;
    }
    std::swap(board[pos], board[pos + move]);
}



//终止查找函数重载
void finalizeSearch(Node& node, const std::string& searchMethod, clock_t start, std::queue<Node>& dataStructure) {
    clock_t end = clock();
    std::cout << searchMethod << ": " << "time = " << end - start << "ms, ";
    output(node);

    while (!dataStructure.empty()) {
        delete dataStructure.front().self;
        dataStructure.pop();
    }
}
void finalizeSearch(Node& node, const std::string& searchMethod, clock_t start, std::stack<Node>& dataStructure) {
    clock_t end = clock();
    std::cout << searchMethod << ": " << "time = " << end - start << "ms, ";
    output(node);

    while (!dataStructure.empty()) {
        delete dataStructure.top().self;
        dataStructure.pop();
    }
}
void finalizeSearch(Node& node, const std::string& searchMethod, clock_t start, std::priority_queue<Node>& dataStructure) {
    clock_t end = clock();
    std::cout << searchMethod << ": " << "time = " << end - start << "ms, ";
    output(node);

    while (!dataStructure.empty()) {
        delete dataStructure.top().self;
        dataStructure.pop();
    }
}


//初始化函数
template<typename T>
std::pair<T, Node*> initializeSearch(int Board[], int& ans, clock_t& start) {
    int board[9];
    for (int i = 0; i < 9; ++i)
        board[i] = Board[i];

    start = clock();

    ans = cantor(Node::goal);
    for (int i = 0; i < 362880; ++i)
        visited[i] = false;

    T dataStructure;
    Node* node_ptr = new Node(cantor(board), NULL, NULL);
    node_ptr->self = node_ptr;
    dataStructure.push(*node_ptr);
    visited[dataStructure.front().num] = true;

    return { dataStructure, node_ptr };
}



//广度优先搜索
void BFS(int Board[]) {
    int board[9];
    for (int i = 0; i < 9; ++i)
        board[i] = Board[i];

    clock_t start, end;
    start = clock();

    int ans = cantor(Node::goal);
    for (int i = 0; i < 362880; ++i)
        visited[i] = false;

    std::vector<Node> tree;
    std::queue<Node> Q;
    Node* node_ptr = new Node(cantor(board), NULL, NULL);
    node_ptr->self = node_ptr;
    Q.push(*node_ptr);
    visited[Q.front().num] = true;

    while (!Q.empty()) {
        Node node = Q.front();
        Q.pop();
        tree.push_back(node);

        if (node.num == ans) { finalizeSearch(node, "BFS", start, Q); break; }

        rev_cantor(node.num, board);
        int pos = 0;
        for (/**/; board[pos] != 0; ++pos);
        int row = pos / 3;
        int col = pos % 3;

        if (col > 0) moveAndCheck(board, pos, -1, Q, node.self); // 左移
        if (row > 0) moveAndCheck(board, pos, -3, Q, node.self); // 上移
        if (col < 2) moveAndCheck(board, pos, +1, Q, node.self); // 右移
        if (row < 2) moveAndCheck(board, pos, +3, Q, node.self); // 下移
    }
}

//有界深度优先搜索
void DFS(int Board[], int d) {
    int board[9];
    for (int i = 0; i < 9; ++i)
        board[i] = Board[i];

    clock_t start, end;
    start = clock();

    int depth = d;
    int ans = cantor(Node::goal);
    for (int i = 0; i < 362880; ++i)
        visited[i] = false;

    std::vector<Node> tree;
    std::stack<Node> S;
    Node* node_ptr = new Node(cantor(board), NULL, NULL);
    node_ptr->self = node_ptr;
    S.push(*node_ptr);
    visited[S.top().num] = true;

    while (!S.empty()) {
        if (depth < 0) {
            ++depth;
            tree.push_back(S.top());
            S.pop();
        }

        Node node = S.top();

        if (node.num == ans) { finalizeSearch(node, "DFS", start, S); break; }

        rev_cantor(node.num, board);
        int pos = 0;
        for (/**/; board[pos] != 0; ++pos);
        int row = pos / 3;
        int col = pos % 3;

        // 使用 moveAndCheckDFS 函数处理四个方向的移动
        if (col > 0 && moveAndCheckDFS(board, pos, -1, S, node.self, depth)) continue; // 左移
        if (row > 0 && moveAndCheckDFS(board, pos, -3, S, node.self, depth)) continue; // 上移
        if (col < 2 && moveAndCheckDFS(board, pos, +1, S, node.self, depth)) continue; // 右移
        if (row < 2 && moveAndCheckDFS(board, pos, +3, S, node.self, depth)) continue; // 下移

        ++depth;
        tree.push_back(S.top());
        S.pop();
    }
    if (depth == d + 1) {
        for (int i = tree.size() - 1; i >= 0; --i)
            delete tree[i].self;
        std::cout << "No solution at current depth!" << std::endl;
    }
}

//A*算法
void Astar(int Board[]) {
    int board[9];
    for (int i = 0; i < 9; ++i)
        board[i] = Board[i];

    clock_t start, end;
    start = clock();

    int ans = cantor(Node::goal);
    for (int i = 0; i < 362880; ++i)
        visited[i] = false;

    std::vector<Node> tree;
    std::priority_queue<Node> Q;
    Node* node_ptr = new Node(cantor(board), NULL, NULL, 0);
    node_ptr->self = node_ptr;
    Q.push(*node_ptr);
    visited[Q.top().num] = true;

    while (!Q.empty()) {
        Node node = Q.top();
        Q.pop();
        tree.push_back(node);

        if (node.num == ans) { finalizeSearch(node, "A*", start, Q); break; }

        rev_cantor(node.num, board);
        int pos = 0;
        for (/**/; board[pos] != 0; ++pos);
        int row = pos / 3;
        int col = pos % 3;

        // 使用 moveAndCheckAStar 函数处理四个方向的移动
        if (col > 0) moveAndCheckAStar(board, pos, -1, Q, node.self, node.G); // 左移
        if (row > 0) moveAndCheckAStar(board, pos, -3, Q, node.self, node.G); // 上移
        if (col < 2) moveAndCheckAStar(board, pos, +1, Q, node.self, node.G); // 右移
        if (row < 2) moveAndCheckAStar(board, pos, +3, Q, node.self, node.G); // 下移
    }
}

int main(void) {
    //int board[] = { 2, 8, 3, 1, 0, 4, 7, 6, 5 };  //test
    //int board[] = { 2, 1, 6, 4, 0, 8, 7, 5, 3 };  //test
    int board[9];
    char ch;
    do {
        input(board);
        if (access(board, Node::goal)) {
            BFS(board);
            std::cout << std::endl;
            int depth = 10;
            std::cout << "depths for DFS: ";
            std::cin >> depth;
            DFS(board, depth);
            std::cout << std::endl;
            Astar(board);
            std::cout << std::endl;
        }
        else
            std::cout << "No solution!" << std::endl;
        std::cout << "Press 'q' to exit:" << std::endl;
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    } while (std::cin >> ch && ch != 'q');
}