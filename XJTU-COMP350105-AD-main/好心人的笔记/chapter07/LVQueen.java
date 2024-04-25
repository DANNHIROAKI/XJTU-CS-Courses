package cn.edu.xjtu.algorithm.chapter07;

import java.util.Random;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/12/8 20:33
 */
public class LVQueen {
    //��˹ά��˹�㷨�ӻ��ݷ����n������

    private Random rnd;  //�����������
    private int n;              //�ʺ����
    private int[] x;            //������
    private int[] y;            //���ս�����

    private void backtrack(int t) {
        if (t > n) {
            for (int i = 1; i <= n; i++)
                y[i] = x[i];
            return;
        } else
            for (int i = 1; i <= n; i++) {
                x[t] = i;
                if (place(t)) backtrack(t + 1);
            }
    }


    private boolean place(int k) {//���Իʺ�k���ڵ�x[k]�еĺϷ���
        for (int j = 1; j < k; j++)
            if (Math.abs(k - j) == Math.abs(x[j] - x[k]) || (x[j] == x[k])) {
                return false;
            }
        return true;
    }

    private boolean queensLV(int stopVegas) {//�������m���ʺ��Las Vegas�㷨
        rnd = new Random();
        int k = 1;
        int count = 1;
        while ((k <= stopVegas) && (count > 0)) {
            count = 0;
            int j = 0;
            for (int i = 1; i <= n; i++) {
                x[k] = i;
                if (place(k))
                    if (rnd.nextInt(++count) == 0) j = i;  //���λ��
            }
            if (count > 0) x[k++] = j;
        }
        return (count > 0); //count>0��ʾ���óɹ�
    }


    public LVQueen(int n, int stop) {//��n�������Las Vegas�㷨
        this.n = n;
        //��ʼ��
        x = new int[n + 1];
        y = new int[n + 1];
        for (int i = 0; i <= n; i++) {
            x[i] = 0;
            y[i] = 0;
        }
        //ǰstop������ţ����漸���û���
        while (!queensLV(stop)) ;
        backtrack(stop + 1);
        for (int i = 1; i <= n; i++) {
            System.out.println(y[i]);
        }
    }

    public static void main(String[] args) {
        LVQueen lvQueen = new LVQueen(4, 1);
    }
}
