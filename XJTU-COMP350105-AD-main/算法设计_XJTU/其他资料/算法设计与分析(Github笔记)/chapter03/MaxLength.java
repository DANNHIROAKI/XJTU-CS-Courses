package cn.edu.xjtu.algorithm.chapter03;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/11/29 20:52
 */
public class MaxLength {
    /**
     * ���������������
     *
     * @param x ��������
     * @param y ��������
     * @param c �洢x[1:i]��y[1:j]������������еĳ���
     * @param b ��¼����c[i][j]��ֵ�����ĸ�������Ľ�õ���
     */
    public static void LCSLength(char[] x, char[] y, int[][] c, int[][] b) {
        int m = x.length - 1;
        int n = y.length - 1;
        for (int i = 1; i <= m; i++) {
            c[i][0] = 0;
        }
        for (int i = 1; i <= n; i++) {
            c[0][i] = 0;
        }//��ʼ��
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (x[i] == y[j]) {
                    c[i][j] = c[i - 1][j - 1] + 1;
                    b[i][j] = 1;
                    //��ʾXi��Yi�����������������Xi-1��Yi-1���������������β������xi���õ��ġ�
                } else if (c[i - 1][j] >= c[i][j - 1]) {
                    c[i][j] = c[i - 1][j];
                    b[i][j] = 2;
                    //��ʾXi��Yi���������������Xi-1��Yi���������������ͬ
                } else {
                    c[i][j] = c[i][j - 1];
                    b[i][j] = 3;
                    //��ʾXi��Yi���������������Xi��Yi-1���������������ͬ
                }
            }
        }
    }

    public static void MyLCSLength(char[] x, char[] y, int[][] c, int[][] b) {
        int m = x.length - 1;
        int n = y.length - 1;
        for (int i = 1; i <= m; i++) {
            c[i][0] = 0;
        }
        for (int j = 1; j <= n; j++) {
            c[0][j] = 0;
        }
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (x[i] == y[j]) {
                    c[i][j] = c[i - 1][j - 1] + 1;
                    b[i][j] = 1;
                } else if (c[i][j - 1] >= c[i - 1][j]) {
                    c[i][j] = c[i][j - 1];
                    b[i][j] = 2;
                } else {
                    c[i][j] = c[i - 1][j];
                    b[i][j] = 3;
                }
            }
        }
    }

    public static void LCS(int m, int n, char[] x, int[][] b) {
        if (m == 0 || n == 0) {
            return;
        }
        if (b[m][n] == 1) {
            LCS(m - 1, n - 1, x, b);
            System.out.print(x[m]);
        } else if (b[m][n] == 2) {
            LCS(m - 1, n, x, b);
        } else {
            LCS(m, n - 1, x, b);
        }
    }

    public static void main(String[] args) {
        char[] x = "*abdscde".toCharArray();
        char[] y = "*bcde".toCharArray();
        int m = x.length;
        int n = y.length;
        int[][] c = new int[m][n];
        int[][] b = new int[m][n];
        MyLCSLength(x, y, c, b);
        System.out.println(c[m - 1][n - 1]);
        LCS(m - 1, n - 1, x, b);
    }
}
