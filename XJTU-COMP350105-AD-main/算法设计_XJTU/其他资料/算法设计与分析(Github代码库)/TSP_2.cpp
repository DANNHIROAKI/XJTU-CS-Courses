#include<iostream>
#define INF 99999
using namespace std;

int n = 0;
int x[10] = {0};
int bestx[10] = {0};
int bestc = INF;
int cc = 0;
int bestl = 0;
int dis[10][10] = {0};
int minc[10] = {0};

int get_min_val(int i)
{
    //find sum of min[x_i...x_n]
    int min_sum = 0;
    for (int j = i; j <= n; j++)
    {
        min_sum += minc[x[j]];
    }
    return min_sum;
}

void create_min_map()
{
    for (int i = 1; i <= n; i++)
    {
        int min = INF;
        for (int j = 1; j <= n; j++)
        {
            if (dis[i][j] > 0 && dis[i][j] < min)
                min = dis[i][j];
        }
        minc[i] = min;
    }
}

void myswap(int i, int j)
{
    int* p = &x[i];
    int* q = &x[j];
    int temp = *p;
    *p = *q;
    *q = temp;
}

void backpack(int t)
{
    if(t>n)
    {
        if (dis[x[n]][1] > 0 && cc + dis[x[n]][1] == bestl)
        {
            bestc == bestl;
            for (int i = 1; i <= n; i++)
                bestx[i] = x[i];
            return; 
        }
        else if (dis[x[n]][1] > 0 && cc + dis[x[n]][1] < bestc)
        {
            bestc = cc + dis[x[n]][1];
            for (int i = 1; i <= n; i++)
                bestx[i] = x[i];
        }
    }
    else
    {
        for (int i = t; i <= n; i++)
        {
            if (dis[x[t - 1]][x[i]] > 0 && cc + dis[x[t - 1]][x[i]] < bestc)
            {
                myswap(t,i);
                cc += dis[x[t - 1]][x[t]];
                bestl = cc + get_min_val(t);
                backpack(t + 1);
                cc -= dis[x[t - 1]][x[t]];
                myswap(t,i);
            }
        }  
    }
}

int main()
{
    cin >> n;
    for (int i = 1; i <= n;i++)
        for (int j = 1; j <= n;j++)
            cin >> dis[i][j];

    for (int i = 1; i <= n;i++)
        x[i] = i;

    create_min_map();
    backpack(2);

    cout << "The minium value is " << bestc << endl;
    cout << "The route is ";
    for (int i = 1; i <= n;i++)
        cout << bestx[i] << " ";
    cout << bestx[1];
    return 0;
}