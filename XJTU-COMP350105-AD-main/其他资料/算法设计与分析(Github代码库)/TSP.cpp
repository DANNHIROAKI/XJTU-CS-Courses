#include<iostream>
using namespace std;

int n = 0;
int x[10] = {0};
int bestx[10] = {0};
int bestc = 0;
int cc = 0;
int dis[10][10] = {0};

int get_max_val()
{
    int sum_max = 0;
    for (int i = 0; i < n;i++)
    {
        int max = 0;
        for (int j = 0; j < n; j++)
        {
            if(dis[i][j]>max)
                max = dis[i][j];
        }
        sum_max += max;
    }
    return sum_max + 1;
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
        if (dis[x[n]][1] > 0 && cc + dis[x[n]][1] < bestc)
        {
            bestc = cc + dis[x[n]][1];
            for (int i = 1; i <= n;i++)
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

    bestc = get_max_val();
    for (int i = 1; i <= n;i++)
        x[i] = i;
    
    backpack(2);

    cout << "The minium value is " << bestc << endl;
    cout << "The route is ";
    for (int i = 1; i <= n;i++)
        cout << bestx[i] << " ";
    cout << bestx[1];
    return 0;
}