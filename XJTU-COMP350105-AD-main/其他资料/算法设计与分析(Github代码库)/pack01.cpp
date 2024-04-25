#include<bits/stdc++.h>
using namespace std;
const int N=100;
const int inf=99999;
typedef long long ll;

class HeadNode{
public:
    double upper, prize, weight; //upper:节点上界，节点价值,节点重量
    int leve, x[N];
};

stack<HeadNode> high;

double w[N], p[N], cw, cp, c;
int n;

int cmp(int x,int y)
{
    return p[x] / w[x] > p[y] / w[y];
}

void add(double up,double cp,double cw,bool ch,int leve)//存放节点
{
    HeadNode be;//生成一个空节点
    be.upper = up;
    be.prize = cp;
    be.weight = cw;
    be.leve = leve;
    if(leve<=n)
    {
        high.push(be);
    }
}

double MaxBound(int j)//更新上界
{
    double left = c - cw, b = cp; //left:剩余的容量,b:此时的价值
    while(j<=n&&w[j]<=left)//通过单位体积价值算出理想情况下的最优解
    {
        left -= w[j];
        b += p[j];
        j++;
    }
    if(j<=n)
        b += p[j] / w[j] * left;

    return b;
}

int bfs()
{
    int i = 1, cw = 0, cp = 0;          //初始在第一层，当前重量为0，当前价值为0
    double bestp = 0, up = MaxBound(1); //bestp:最优解，up=MaxBound(1):在根节点时候的上界
    while (1)
    {

        double wt = cw + w[i]; //搜索左子树的可行解
        if (wt <= c)
        {
            bestp = max(bestp, cp + p[i]);
            add(up, cp + p[i], cw + w[i], true, i + 1); //将此节点放入栈中
        }
        up = MaxBound(i + 1); //右节点不放
        if (up >= bestp)      //右节点可能含有最优解
        {
            add(up, cp, cw, false, i + 1);
        }
        if (high.empty())
            return bestp;           //当栈为空的时候，此时的bestp就是最优解
        HeadNode node = high.top(); //把栈顶的点拿出来
        high.pop();
        cw = node.weight;
        cp = node.prize;
        up = node.upper;
        i = node.leve;
   }

}
int main()
{

    cin>>n>>c;//n个物品，背包容量为c

    for(int i=1;i<=n;i++)
        cin>>w[i];

    for(int i=1;i<=n;i++)
        cin>>p[i];
    sort(p+1,p+1+n,cmp);
    cout<<bfs()<<endl;
    return 0;
}