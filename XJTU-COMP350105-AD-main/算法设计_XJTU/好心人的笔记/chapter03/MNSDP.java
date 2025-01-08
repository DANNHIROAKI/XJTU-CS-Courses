package cn.edu.xjtu.algorithm.chapter03;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/11/30 16:36
 */
public class MNSDP {
    //��·��������

    /**
     *
     * @param C C[i]������[i]
     * @param n
     * @param size size[i][j]��N(i,j)������ཻ�Ӽ������ߵ���Ŀ
     */
    void MNS(int C[],int n,int[][]size){
        for(int j=0; j<C[1]; j++) //i=1��j<��(1)
            size[1][j]=0;
        for(int j=C[1]; j<=n; j++) //i=1��j>=��(1)
            size[1][j]=1;
        for(int i=2; i<n; i++) //1<i<n
        {
            for(int j=0; j<C[i]; j++) //j<��(i)
                size[i][j]=size[i-1][j];
            for(int j=C[i]; j<=n; j++) //j>=��(i)
                size[i][j]=Math.max(size[i-1][j],size[i-1][C[i]-1]+1);
        }
        size[n][n]=Math.max(size[n-1][n],size[n-1][C[n]-1]+1); //i=n,j=n
    }

}
