package cn.edu.xjtu.algorithm.chapter05;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/12/7 21:44
 */
public class nQueen {
    //n�ʺ�����
    private int n;//�ʺ����
    private int[] x;//��ǰ��
    private long sum;//��ǰ���ҵ����з�����

    public nQueen(int n) {
        this.n = n;
        this.sum = 0;
        this.x = new int[n + 1];
        for (int i = 0; i <= n; i++) {
            x[i] = 0;
        }
        this.backTrack(1);
    }

    /**
     * �����ڵ�k��
     *
     * @param k
     * @return �Ƿ����
     */
    private boolean place(int k) {
        for (int i = 1; i < k; i++) {
            if (Math.abs(k - i) == Math.abs(x[k] - x[i]) || x[i] == x[k]) {
                //��ͬһ�л���ͬһб��
                return false;
            }
        }
        return true;
    }

    /**
     * �ݹ����
     *
     * @param t
     */
    public void backTrack(int t) {
        if (t > n)
            sum++;
        else
            for (int i = 1; i <= n; i++) {//[1:n]��
                x[t] = i;//���ڵ�i��
                if (place(t))
                    backTrack(t + 1);
            }
    }

    /**
     * �ǵݹ����
     *
     * @param t
     */
    public void backTrack_o(int t) {
        x[1] = 0;
        int k = 1;
        while (k > 0) {
            x[k] += 1;  //��k�еķŵ���һ��
            //x[k]���ܷ��ã���ŵ���һ�У�ֱ���ɷ���
            while ((x[k] <= n) && !place(k))
                x[k] += 1;
            if (x[k] <= n)  //����n�з�Χ��
                if (k == n)  //�ѷ�n��
                    sum++;
                else  //����n��
                {
                    k++; //����һ��
                    x[k] = 0; //��һ���ִӵ�0�е����п�ʼ�Է�
                }
            else  //��k���޷����ã������·�����һ�У��ŵ���һ�У�
                k--;
        }
    }

}

