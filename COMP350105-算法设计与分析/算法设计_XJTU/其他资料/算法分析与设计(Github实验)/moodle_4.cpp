//解空间是一颗三叉子集树，三个子树分别表示进入A，进入B，都不进入
#include <iostream>
#include <math.h>
#include <fstream>
using namespace std;
class ExcAB{
private:
    int matrix[1000][20];//原始矩阵
    int exclusion[20][20];//互斥表，为1表示互斥，为0表示不互斥。初始化时计算一次，后续直接查表
    int result[20];//记录当前结果,1表示进入A，2表示进入B，0表示都不进入
    int bestResult[20];//当前最优解
    int sizeA;//当前A的大小
    int sizeB;//当前B的大小
    int bestA;//当前最优解A的大小
    int bestB;//当前最优解B的大小，最优解为bestA+bestB最大
public:
    ExcAB();
    int isExclusion(int a,int b);//判断a列和b列是否互斥，只用于初始化互斥表，后续直接查表判断是否互斥
    void refresh();//更新当前结果为最优解
    bool isExc(int i,const char set);//判断加入第i列是否与set集合互斥，set只能为'A'或'B'
    void solve(int n);//递归回溯求解
    void print();//输出结果
};
ExcAB::ExcAB(){
    for(int i=0;i<1000;i++){
        for(int j=0;j<20;j++){
            cin>>matrix[i][j];
        }
    }
    for(int i=0;i<20;i++){//初始化互斥表
        for(int j=i;j<20;j++){
            exclusion[i][j]=isExclusion(i,j);
            exclusion[j][i]=exclusion[i][j];//对称，只计算一半
        }
    }
    for(int i=0;i<20;i++){//初始化结果
        result[i]=0;
        bestResult[i]=0;
    }
    sizeA=0;
    sizeB=0;
    bestA=0;
    bestB=0;
}
int ExcAB::isExclusion(int a,int b){//第a列某一行中存在1，第b列这一行中也存在1，那么a和b互斥
    for(int i=0;i<1000;i++){
        if(matrix[i][a]==1&&matrix[i][b]==1){
            return 1;
        }
    }
    return 0;
}
void ExcAB::refresh(){
    if(sizeA<sizeB){//确保A的大小>=B的大小
        for(int i=0;i<20;i++){
            if(result[i]==1){
            bestResult[i]=2;
            }
            if(result[i]==2){
                bestResult[i]=1;
            }
            if(result[i]==0){
                bestResult[i]=0;
            }
        }
        bestA=sizeB;
        bestB=sizeA;
    }
    else{
        for(int i=0;i<20;i++){
            bestResult[i]=result[i];
        }
        bestA=sizeA;
        bestB=sizeB;
    }

}
bool ExcAB::isExc(int i,const char set){
    if(set=='A'){//判断是否与A集合互斥，i加入B集合时判断
        for(int j=0;j<20;j++){
            if(result[j]==1&&exclusion[i][j]==1){
                return true;
            }
        }
    }
    if(set=='B'){//判断是否与B集合互斥，i加入A集合时判断
        for(int j=0;j<20;j++){
            if(result[j]==2&&exclusion[i][j]==1){
                return true;
            }
        }
    }
    return false;
}
void ExcAB::solve(int n){
    if(n==20){//递归结束条件
        if(sizeA==0||sizeB==0){//A和B都不能为空
            return;
        }
        if(sizeA+sizeB>bestA+bestB){//找到更优解
            refresh();
        }
        if(sizeA+sizeB==bestA+bestB&&abs(sizeA-sizeB)<abs(bestA-bestB)){//选取更合适的解
            refresh();
        }
        return;
    }
    if(sizeA+sizeB+20-n<bestA+bestB){//剪枝，当前解与最优解相差20-n，不可能找到更优解
       return;
    }
    if(!isExc(n,'B')){//不和B互斥，进入A
        result[n]=1;
        sizeA++;
        solve(n+1);
        result[n]=0;
        sizeA--;
    }
    if(!isExc(n,'A')){//不和A互斥，进入B
        result[n]=2;
        sizeB++;
        solve(n+1);
        result[n]=0;
        sizeB--;
    }
    solve(n+1);//AB都不进入
}
void ExcAB::print(){
    //cout<<"A"<<endl;
    for(int i=0;i<20;i++){
        if(bestResult[i]==1){
            cout<<i<<" ";
        }
    }
    cout<<endl;
    //cout<<"B"<<endl;
    for(int i=0;i<20;i++){
        if(bestResult[i]==2){
            cout<<i<<" ";
        }
    }
    cout<<endl;
}

int main(){
    ExcAB excAB;
    excAB.solve(0);
    excAB.print();
    return 0;
}
