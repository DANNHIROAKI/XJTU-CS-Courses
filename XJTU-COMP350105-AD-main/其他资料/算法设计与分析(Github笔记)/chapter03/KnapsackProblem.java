package cn.edu.xjtu.algorithm.chapter03;

import cn.edu.xjtu.data_structure.chapter03_tree_and_binary_tree.btree.BinaryTreePtr;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/11/30 16:59
 */
public class KnapsackProblem {
    //0-1��������

    /**
     *
     * @param v v[1:n]����Ʒi�ļ�ֵ
     * @param w w[1:n]����Ʒi������
     * @param c ��������
     * @param n
     * @param m m[i][j]����������Ϊj����ѡ��ƷΪ[i:n]ʱ��0-1�������������ֵ
     */
    public static void Knapsack(int[]v,int[]w,int c,int n,int[][]m){
        int jMax = Math.min(w[n]-1,c);
        for (int j = 0; j <=jMax; j++) {
            m[n][j]=0;//j<=c&&j<w[n]����Ʒn�޷����뱳��
        }
        for (int j = w[n]; j <=c; j++) {
            m[n][j]=v[n];//w[n]<=j<=c����Ʒn���Է��뱳��
        }//���߽磬�Ӻ���ǰ��
        for (int i = n-1; i >1 ; i--) {
            jMax = Math.min(w[i]-1,c);
            for (int j = 0; j <=jMax; j++) {
                m[i][j]=m[i+1][j];//��Ʒi�޷����뱳��
            }
            for (int j = w[i]; j <=c ; j++) {//��Ʒi�ɷ��뱳��
                m[i][j]=Math.max(m[i+1][j],m[i+1][j-w[i]]+v[i]);
            }
        }
        m[1][c]=m[2][c];
        if (c>=w[1]){
            m[1][c]=Math.max(m[1][c],m[2][c-w[1]]+v[1]);
        }
    }

    /**
     * ���
     * @param m
     * @param w
     * @param c
     * @param n
     * @param x ����Ľ�
     */
    public static void TraceBack(int[][]m, int[]w,int c,int n,int[]x){
        for(int i=1;i<n;i++)
            if(m[i][c]==m[i+1][c])
                x[i]=0;
            else
            {
                x[i]=1;
                c-=w[i];
            }
        x[n]=(m[n][c]>0)?1:0;
    }

    public static void main(String[] args) {
        int[]v={0,1,13,8,4,5,6,7};
        int[]w={0,2,3,1,4,1,5,1};
        int c = 10;
        int n = v.length;
        int[] x = new int[n];
        int[][]m=new int[n][c+1];
        Knapsack(v,w,c,n-1,m);
        TraceBack(m,w,c,n-1,x);
        for (int i = 1; i < n; i++) {
            System.out.println(x[i]+" ");
        }
    }
}
