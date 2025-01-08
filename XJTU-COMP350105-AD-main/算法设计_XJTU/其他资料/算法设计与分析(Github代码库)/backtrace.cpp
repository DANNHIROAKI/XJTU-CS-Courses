#include<iostream>
#include<stdio.h>
using namespace std;

int a[1001][21] = {0};//样本矩阵
int x[21] = {0};//当前解，0表示不选，1表示在a集合，2表示在b集合
int bestx[21] = {0};//最优解
int cmax = 0;//当前解
int maxnum = 0;//最优值 

void update()
{
    //更新最优解
    
    for (int i = 1; i <= 20;i++)
        bestx[i] = x[i];
}

int getsum(int arr[])
{
    //计算A集合中元素和
    
    int sum = 0;
    for (int i = 1; i <= 20;i++)
        if(arr[i]==1)
            sum += i-1;
    return sum;
}

int getnum(int arr[])
{
    //计算A集合中元素个数
    
    int num = 0;
    for (int i = 1; i <= 20;i++)
        if(arr[i]==1)
            num++;
    return num;
}

int getabs(int arr[])
{
    //计算AB集合元素个数差值的绝对值
    
    int tempa = 0;
    int tempb = 0;
    for (int i = 1; i <= 20;i++)
    {
        if(arr[i]==1)
            tempa++;
        else if(arr[i]==2)
            tempb++;
    }
    return tempa - tempb >= 0 ? tempa - tempb : tempb - tempa;
}

bool not_null()
{
    //判断是否AB集合均非空
    
    bool flag_a=false;
    bool flag_b=false;
    for (int i = 1; i <= 20;i++)
    {
        if(x[i]==1)
            flag_a = true;
        if(x[i]==2)
            flag_b = true;
    }
    if(flag_a==true&&flag_b==true)
        return true;
    return false;
}

int getcmax()
{
    //计算当前加入AB集合的元素个数
    
    int temp = 0;
    for (int i = 1; i <= 20;i++)
        if(x[i]==1||x[i]==2)
            temp++;
    return temp;
}

void merge(int t,int op)
{
    //把待选列加到当前解中
    
    if(op==0)
    {
        //不选 直接返回
        return;
    }
    else if(op==1)
    {
        //加到a组
        x[t] = 1;
    }
    else
    {
        //加到b组
        x[t] = 2;
    } 
}

bool not_collide(int t,int op)
{
    //选择这列后，会和原集合产生冲突吗

    if(op==0)
    {
        //不选这列 肯定没冲突
        return true;
    }
    else if(op==1)
    {
        //放在a集合，则对b的每一列，分别用待加入列和他判断是否产生冲突
        for (int i = 1; i <= 20;i++)
        {
            if(x[i]==2)
            {
                //是属于b分组的一列
                for (int j = 1; j <= 1000; j++)
                {
                    if (a[j][t]==1&&a[j][i]==1)
                    {
                        //和b组冲突了，不能加进来
                        return false;
                    }
                }
            }
        }
        //和b组所有列都判断了一遍，没冲突
        return true;
    }
    else
    {
        //放在b集合，则对a的每一列，分别用待加入列和他判断是否产生冲突
        for (int i = 1; i <= 20;i++)
        {
            if(x[i]==1)
            {
                //是属于a分组的一列
                for (int j = 1; j <= 1000; j++)
                {
                    if (a[j][t]==1&&a[j][i]==1)
                    {
                        //和a组冲突了，不能加进来
                        return false;
                    }
                }
            }
        }
        //和a组所有列都判断了一遍，没冲突
        return true;
    }
}

void backtrack(int t)
{
    //递归搜索每一节点
    
    if(t>20)
    {
        //20列全部判断完毕,选择更新最优解
        cmax = getcmax();
        if (cmax > maxnum && not_null())
        {
            update();
            maxnum = cmax;
        }
        else if(cmax == maxnum && not_null())
        {
            //按照输出规则选择更新最优解

            //首先取ab集合元素个数相差最小的最优解
            int a = getabs(x);
            int b = getabs(bestx);
            if(a<b)
            {
                //新最优解元素相差个数更少，更新
                update();
            }
            else if(a==b)
            {
                int numa_new = getnum(x);
                int numa_old = getnum(bestx);
                if (numa_new > numa_old)
                {
                    //新最优解中A的元素个数更多
                    update();
                }
                else if(numa_new==numa_old)
                {
                    int suma_new = getsum(x);
                    int suma_old = getsum(bestx);
                    if(suma_new<suma_old)
                    {
                        update();
                    }
                }
            }
        }    
    }
    else
    {
        //还在遍历中
        for (int i = 0; i <= 2;i++)
        {
            x[t] = i;
            if (not_collide(t, i) && getcmax() + 20 - t >= maxnum)
            {
                //新选择的列没有和原集合冲突，则把他加进来
                merge(t,i);
                backtrack(t + 1);
            }
            x[t] = 0;
        }
    }   
}

int main()
{
    freopen("D:\\Algorithm\\algorithm\\exp6_in.txt", "r", stdin);
    for (int k = 0; k < 10;k++)
    {
        for (int i = 1; i <= 1000; i++)
            for (int j = 1; j <= 20; j++)
            {
                cin >> a[i][j];
            }
        backtrack(1);

        //输出
        
        for (int i = 1; i <= 20;i++)
        {
            if(bestx[i]==1)
            cout << i-1 << " ";
        }
        cout << endl;
        for (int i = 1; i <= 20;i++)
        {
            if(bestx[i]==2)
            cout << i-1 << " ";
        }
        cout << endl;
        
        //初始化全局变量
        
        for (int i = 1; i <= 20;i++)
        {
            x[i] = 0;
            bestx[i] = 0;
        }
        maxnum = 0;
        cmax = 0;
    }
    return 0;
}