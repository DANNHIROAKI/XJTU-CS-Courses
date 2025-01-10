package cn.edu.xjtu.algorithm.chapter05;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/12/8 8:05
 */
public class TSP {
    /**
     * �Ѹ�һ��n�����[��ȫͼ])��ÿ���߶���һ�����ȣ�
     * ���ܳ�����̵ľ���ÿ����������һ�εķ�ջ�·
     */
    private int n;//ͼ�Ķ�����
    private int[] x;//��ǰ��
    private int[] bestx;//��ǰ���Ž�
    private int[][] a;//�ڽӾ���
    private int cc;//��ǰ����
    private int bestc;//��ǰ����ֵ
    private static final int NO_EDGE = Integer.MAX_VALUE;//�ޱ߱��

    public TSP(int[][] a, int[] v, int n) {
        this.a = a;
        this.n = n;
        this.bestx = v;
        this.x = new int[n + 1];
        this.bestc=NO_EDGE;
        this.cc = 0;
        this.backTrack(2);
    }

    public void backTrack(int i) {
        if (i == n) {
            //��i=nʱ����ǰ��չ�������������Ҷ���ĸ���㣬��ʱ���ͼG�Ƿ����һ����
            // ����x[n-1]������x[n]�ıߺ�һ���Ӷ���x[n]������1�ıߣ���������߶����ڣ�
            // ���ҵ�һ����·�����жϴ˻�·�ķ����Ƿ����ڵ�ǰ���Ż�·�ķ��ã�������µ�ǰ����ֵ�����Ž⡣
            if (a[x[n - 1]][x[n]] != NO_EDGE && a[x[n]][1] != NO_EDGE &&
                    (cc + a[x[n - 1]][x[n]] + a[x[n]][1] < bestc || bestc == NO_EDGE)) {
                for (int j = 1; j <= n; j++) {
                    bestx[j] = x[j];
                }
                bestc = cc + a[x[n - 1]][x[n]] + a[x[n]][1];
            }
        } else {
            //��i<nʱ����ǰ��չ���λ���������ĵ�i-1�㡣ͼG�д��ڴӶ���x[i-1]��x[i]�ı�ʱ��
            // ���x[1:i]�ķ����Ƿ�С�ڵ�ǰ����ֵ����������������ĵ�i�㣬�����ȥ��Ӧ������
            for (int j = i; j <= n; j++) {
                if (a[x[i - 1]][x[j]] != NO_EDGE && (cc + a[x[i - 1]][x[j]] < bestc || bestc == NO_EDGE)) {
                    swap(x,i,j);
                    cc += a[x[i - 1]][x[i]];
                    backTrack(i + 1);
                    cc -= a[x[i - 1]][x[i]];
                    swap(x,i,j);
                }
            }
        }
    }

    private void swap(int[]a, int x, int y) {
        int temp = a[x];
        a[x] = a[y];
        a[y] = a[temp];
    }
}
