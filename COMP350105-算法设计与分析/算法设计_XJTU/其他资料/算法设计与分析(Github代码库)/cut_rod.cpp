#include<iostream>
using namespace std;
#define INF 9999999999999999

void sort(int head, int tail,int pos[])
{
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
    for (int i = n; i >0;i--)
        pos[i] = pos[i - 1];
    pos[0] = 0;
    pos[n+1] = L;

    int prize[500][500] = {0};
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

    for (int i = 3; i < n + 2; i++)
    {
        for (int j = 0; j < n+2-i; j++)
        {
            int min = INF;
            for (int k = j; k < i + j; k++)
                if (prize[j][k] + prize[k][i+j] + pos[i+j] -pos[j]< min)
                    min = prize[j][k] + prize[k][i + j] + pos[i+j] - pos[j];
        prize[j][i+j] = min;
        }
    }
    cout << prize[0][n + 1] << endl;
}

int main()
{
    int L, n;
    int pos[1000] = {0};
    cin >> L >> n;
    for (int i = 0; i < n;i++)
        cin >> pos[i];
    cut_rod(L, n, pos);
    return 0;
}