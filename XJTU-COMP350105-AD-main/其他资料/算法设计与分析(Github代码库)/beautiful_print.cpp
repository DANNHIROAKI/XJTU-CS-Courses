#include<iostream>
using namespace std;

void print(int n, int p[], int array[])
{
    //漂亮地输出原数组

    int i = n, k = 0;
    int temp[n] = {0};
    while (p[i] - 1 > 0)
    {
        temp[k] = p[i] - 1;
        k++;
        i = p[i] - 1;
    }
    for (int i = 0; i < k; i++)
    {
        p[i] = temp[k - i - 1];
    }
    k = 0;
    cout << "Print the original artical beautifully:\n"
         << "(in this case, we use the length of the word to represent the word)"
         << endl;
    for (int i = 0; i < n; i++)
    {
        if(i==p[k])
        {
            cout<<endl;
            k++;
        }
        cout << array[i] << " ";
    }
    cout << endl;
}

int getlen(int m, int n, int i, int j, int array[])
{
    //获取当第i个数到第j个数在同一行时，
    //这一行产生的多余空格数

    int len = 0;
    for (int k = i-1; k <= j-1; k++)
    {
        len += array[k];
    }
    int space = m - j + i - len;
    if (space < 0)
    {
        //溢出了，不可在这里打断
        return 99999999;
    }
    else if (j == n)
    {
        //这是最后一行，多余空格不计入
        return 0;
    }
    else
    {
        //一般情况
        return space * space * space;
    }
}

void beautiful_print(int n, int m, int array[])
{
    int c[n] = {0};//c[i]保存从第1~i个单词所用的最少的多余空格立方和
    int p[n] = {0};//保存断开位置
    c[0] = 0;//当有0个单词时，多余空格为0

    for (int i = 1; i <= n; i++)
    {
        //从一个单词开始，计算最少空格数
        //初始化一个很大的数
        c[i] = 99999999;
        for (int j = 1; j <= i; j++)
        {
            //c[i]=min{c[j-1]+len(j,i)}
            if (c[i] > c[j - 1] + getlen(m, n, j, i, array))
            {
                c[i] = c[j - 1] + getlen(m, n, j, i, array);
                p[i] = j;
            }
        }
    }
    //c[n]即保存着第1~n个单词漂亮排列后多余空格数的立方和
    print(n, p, array);
    cout << endl;
    cout <<"The minium number of space is " << c[n] << endl;    
}

int main()
{
    int n = 5, m = 5;
    int array[n] = {4, 1, 1, 3, 3};
    beautiful_print(n, m, array);
    return 0;
}