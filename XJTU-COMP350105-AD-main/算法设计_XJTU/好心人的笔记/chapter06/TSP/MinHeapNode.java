package cn.edu.xjtu.algorithm.chapter06.TSP;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/11/10 19:02
 */
public class MinHeapNode {
    private int lcost;//�������õ��½�
    private int cc;//��ǰ����
    private int rcost;//x[s:n-1]�ж�����С���߷��ú�
    private int s;//����㵽��ǰ����·��Ϊx[0:s]
    private int[] x;//��Ҫ��һ�������Ķ���Ϊx[s+1:n-1]
}
