#include<iostream>
#include<stdio.h>
using namespace std;
#define INF 9999999999999999

void sort(int head, int tail,int pos[])
{
    //将输入的打乱的切割点排序
    //bubblesort
    
    for (int i = head; i < tail; i++)
        for (int j = head; j < head+tail - i; j++)
            if (pos[j] > pos[j + 1])
            {
                int temp = pos[j];
                pos[j] = pos[j + 1];
                pos[j + 1] = temp;
            }
}

void cut_rod(int L, int n, int pos[])
{
    sort(0, n - 1, pos);
    //初始化切割点位置数组
    for (int i = n; i >0;i--)
        pos[i] = pos[i - 1];
    //人为将整根钢条的两端看作两个切割点
    pos[0] = 0;
    pos[n+1] = L;

    int prize[500][500] = {0};
    //按照已知结论初始化代价数组
    for (int i = 0; i < n + 2;i++)
    {
        for (int j = 0; j < n+2;j++)
        {
            if(i-j==1||i==j)
            {
                prize[j][i] = 0;
                prize[i][j] = 0;
            }

            else if(i-j==2)
            {
                prize[j][i] = pos[i] - pos[j];
                prize[i][j] = pos[i] - pos[j];
            }
            else 
            {
                prize[j][i] = INF;
                prize[i][j] = INF;
            }
        }
    }
    
    //下面是整个动态规划的精髓***
    for (int i = 3; i < n + 2; i++)
    {
        //i控制问题的规模；规模为0，1，2的问题上面已经计算过了，因此从3开始，到n+1（整根钢条）结束
        for (int j = 0; j < n+2-i; j++)
        {
            //j控制求解哪一段规模为i的钢条；规模为i的钢条共有n+2-i个，依次求解
            int min = INF;
            for (int k = j; k < i + j; k++)
                //k控制从子钢条的哪一个切割点切，即求解具体的子问题
                if (prize[j][k] + prize[k][i+j] + pos[i+j] -pos[j]< min)
                    min = prize[j][k] + prize[k][i + j] + pos[i+j] - pos[j];
        prize[j][i+j] = min;
        }
    }
    cout << prize[0][n + 1] << endl;
}

int main()
{
    freopen("D:\\Algorithm\\algorithm\\exp2_in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
    int L, n;
    int pos[1000] = {0};//pos数组用来记录切割点的位置 pos[i]=u表示第i+1个切割点在整根钢条上的位置是u
    while(cin>>L>>n)
    {
        for (int i = 0; i < n; i++)
            cin >> pos[i];
        cut_rod(L, n, pos);
    }
    fclose(stdin);
    return 0;
}