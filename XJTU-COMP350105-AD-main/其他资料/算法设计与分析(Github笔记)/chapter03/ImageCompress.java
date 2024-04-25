package cn.edu.xjtu.algorithm.chapter03;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/11/30 14:54
 */
public class ImageCompress {
    //ͼ��ѹ������

    /**
     * ����ʮ������i����Ķ�����λ��
     *
     * @param i
     * @return
     */
    static int length(int i) {
        int k = 1;
        i = i / 2;
        while (i > 0) {
            k++;
            i = i / 2;
        }
        return k;
    }

    /**
     * @param n
     * @param l [p1:pi]�����ŷֶ������1���ֶε����ظ���
     * @param p p[p1:pn]�����ص�Ҷ�ֵ����
     * @param s ��������[p1:pi]�����ŷֶ�����Ĵ洢λ��
     * @param b ����p[i]����Ĵ洢λ��
     */
    public static void Compress(int n, int[] p, int[] s, int[] l, int[] b) {
        int Lmax = 255;//ÿ���ֶεĳ��Ȳ�����255λ
        int header = 11;//�ֶζ�ͷ�����λ��,��ʾһ���εĸ�����Ϣ
        s[0] = 0;
        for (int i = 1; i <= n; i++) //[p1:pi]
        {
            b[i] = length(p[i]);
            int bmax = b[i];
            s[i] = s[i - 1] + bmax; //k=1
            l[i] = 1;
            for (int j = 2; j <= i && j <= Lmax; j++) //����1���ֶ�����j������
            {
                if (bmax < b[i - j + 1])
                    bmax = b[i - j + 1];//��һ���е����λ��
                if (s[i] > s[i - j] + j * bmax) {//�ҵ����õķֶ�
                    s[i] = s[i - j] + j * bmax;
                    l[i] = j;
                }
            }
            s[i] += header;//���϶��⿪��
        }
    }


    public static int Traceback(int n, int i, int[] s, int[] l) {
        if (n == 0)
            return i;
        i = Traceback(n - l[n], i, s, l);
        s[i++] = n - l[n];// ����Ϊs[]���鸳ֵ�������洢�ֶ�λ��
        return i;
    }

    static void Output(int s[], int l[], int b[], int n) {
        System.out.println("The optimal value is " + s[n]);
        int m = 0;
        m=Traceback(n, m, s, l);  //m:�ֶ���
        s[m] = n;  //m���ֶ����ص��ۻ��ͣ�Traceback�㵽m-1��
        System.out.println("Decompose into " + m + " segments");
        for (int j = 1; j <= m; j++) {
            l[j] = l[s[j]]; //�����j���ֶ����ظ���: l[j]
            b[j] = b[s[j]];  //�����j���ֶ�����Ĵ洢λ��: b[j]
        }
        for (int j = 1; j <= m; j++)
            System.out.println(l[j] + " " + b[j]);
    }


    public static void main(String[] args) {
        int p[] = {0,10,12,15,255,2,1};//��һλ����
        int N=p.length;
        int s[] = new int[N];
        int l[] = new int[N];
        int b[] = new int[N];
        Compress(N-1, p, s, l, b);
        Output(s, l, b, N-1);
    }
}
