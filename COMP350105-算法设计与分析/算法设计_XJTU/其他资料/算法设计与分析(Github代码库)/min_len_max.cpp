#include<iostream>
using namespace std;

int dist[100][100] = {0};//原图信息
int part[100] = {0};//连通分量
bool link[100][100] = {0};//记录两点间是否连通
int x, y;

int get_min_dist(int n)
{
    //在加入后不形成圈的情况下，返回最小权值的路
    int min_dist = 99999;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n;j++)
            if (dist[i][j] < min_dist && part[i] != part[j])
            {
                x = i;
                y = j;
                min_dist = dist[i][j];
            }
    int temp = part[y];
    for (int i = 0; i < n;i++)
        if(part[i]==temp)
            part[i] = part[x];
    link[x][y] = 1;
    link[y][x] = 1;
    cout << "(" << x + 1 << "," << y + 1 << ")" << endl;
    return min_dist;
}

void min_len_max(int n)
{
    bool flag = 0;
    int min_dist = 0;
    for (int i = 0; i < n; i++)
    {
        //所有数组初始化
        part[i] = i;
        for (int j = 0; j < n;j++)
            link[i][j] = 0;
    }
    
    while (flag == 0)
    {
        min_dist = get_min_dist(n);
        flag = 1;
        int p = part[0];
        for (int i = 0; i < n; i++)
            if (part[i] != p)
            {
                flag = 0;
                break;
            }
    }
    cout << "The max_length is " << min_dist << endl;
}

int main()
{
    int n = 6;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            dist[i][j] = 99999;
    //这里用的图时课本100页的图4-8
    dist[0][1] = 6;
    dist[0][2] = 1;
    dist[0][3] = 5;
    dist[1][2] = 5;
    dist[1][4] = 3;
    dist[2][3] = 5;
    dist[2][4] = 6;
    dist[2][5] = 4;
    dist[3][5] = 2;
    dist[4][5] = 6;
    min_len_max(n);
    return 0;
}