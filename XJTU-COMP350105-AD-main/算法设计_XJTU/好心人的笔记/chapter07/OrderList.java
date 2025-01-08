package cn.edu.xjtu.algorithm.chapter07;

import java.util.Random;

/**
 * @author yjq
 * @version 1.0
 * @date 2021/11/11 10:57
 */
public class OrderList<Type> {
    private int n;//��ǰ�����е�Ԫ�ظ���
    private int maxLength;//�����е����Ԫ�ظ���
    private Type[] value;//�洢����Ԫ�ص�����
    private int[] link;//ָ������
    private Random random;//���������
    private Type small;//����Ԫ���е��½�
    private Type tailKey;//����Ԫ���е��Ͻ�

    public int complare(Type a, Type b) {
        return 0;
    }

    public OrderList(int maxLength, Type small, Type tailKey) {
        this.maxLength = maxLength;
        this.small = small;
        this.tailKey = tailKey;
        this.value = (Type[]) new Object[this.maxLength + 1];
        this.link = new int[this.maxLength + 1];
        this.n = 0;
        this.link[0] = 0;
        this.value[0] = this.tailKey;
    }

    public int search(Type x) {
        //����������ָ��Ԫ��
        int index = -1;
        Type max = small;
        int m = (int) Math.floor(Math.sqrt(n));
        for (int i = 1; i <= m; i++) {
            int j = random.nextInt(n) + 1;//�����������Ԫ��λ��
            Type y = value[j];
            if (complare(max, y) < 0 && complare(y, x) < 0) {
                max = y;
                index = j;
            }
        }
        while (complare(value[link[index]],x)<0){
            index=link[index];
        }
        return index;
    }
    public void insert(Type k){
        if (n==maxLength||(complare(k,tailKey)>0))return;
        int index=search(k);
        if (index==-1){
            value[++n]=k;
            link[n]=link[index];
            link[index]=n;
        }
    }
}
