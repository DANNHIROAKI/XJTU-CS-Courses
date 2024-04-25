#include<iostream>
using namespace std;

int ackerman(int m, int n)
{
    int ind[m + 1] = {0};
    int val[m + 1] = {0};
    for (int i = 0; i < m; i++)
    {
        ind[i + 1] = -1;
        val[i + 1] = -1;
    }
    //A(0,1)=1
    ind[0] = 0;
    val[0] = 1;

    while (ind[m] < n)
    {
       //A(0,x)=x+1，这是所有迭代的基础
        ind[0]++;
        val[0]++;

        //循环更新A(i,n)的值，其中1<i<=n
        for (int i = 1; i <= m; i++)
        {
            if(ind[i-1]==1)
            {
                //当A(m,1)=val时，有A(m+1,0)=val
                val[i] = val[i - 1];
                ind[i] = 0;
            }
            if (val[i] == ind[i - 1])
            {
                //当A(m,val2)=val1时，有A(m+1,n+1)=val1
                ind[i]++;
                val[i] = val[i - 1];
            }
        }
    }
    return val[m];
}

int main()
{
    int m = 3;
    int n = 3;
    int ack = ackerman(m, n);
    cout << "Ackerman(" << m << ", " << n << ")=" << ack << endl;
    return 0;
}
