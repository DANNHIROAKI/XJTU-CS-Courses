# 2. 知识工程

> ## 2.1. 产生式系统求解问题的步骤
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231120210147522.png" alt="image-20231120210147522" style="zoom:50%;" /> 
> >
> > 例题：
> >
> > ```txt
> > 数据库：{有毛,吃草,黑条纹}
> > 规则库: R1：有毛→哺乳类
> >        R3：哺乳类∧吃肉→食肉类
> >        R4：哺乳类∧吃草→有蹄类
> >        R5：食肉类∧黄褐色∧有斑点→猎狗
> >        R6：有蹄类∧黑条纹→斑马                            
> > 1.匹配到R1->更新事实库：{哺乳动物,有毛,吃草,黑条纹}
> > 2.匹配到R4->更新事实库：{哺乳动物,有毛,吃草,黑条纹,有蹄类}
> > 3.匹配到R8->更新事实库：{哺乳动物,有毛,吃草,黑条纹,有蹄类,斑马}
> > ```

# 3. 确定性推理

> ## 3.1. 代换的复合
>
> > $ \theta = \{f(y)/x, z/y\} $，$ \lambda = \{a/x, b/y, y/z\} $
> >
> > 1. $ \theta \circ \lambda =\{\{\theta{}\lambda{}\},\{\lambda\}\}= \{f(y)\lambda/x, z\lambda/y, a/x, b/y, y/z\}$
> > 2. ==$f(y)\lambda$表示在$f(y)$中运用$\lambda$替换得到$f(b)$==，$z\lambda$表示在$z$中运用$\lambda$替换得到$y$
> > 3. 化简为$\{f(b)/x, \cancel{y/y}, \cancel{a/x}, \cancel{b/y}, y/z\} = \{f(b)/x,y/z\} $
>
> ## 3.2. 求最一般合一
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121011535400.png" alt="image-20231121011535400" style="zoom:50%;" /> 
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121013536569.png" alt="image-20231121013536569" style="zoom:46%;" /> 
>
> ## 3.3. 谓词公式化成子句集的步骤
>
> > ==以$(\forall{x})[(\forall{y})P(x,y)→\neg{}(\forall{y})(Q(x,y)→R(x,y))]$为例==
> >
> > 1. 消去→和↔(用等价关系)
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121145429852.png" alt="image-20231121145429852" style="zoom:33%;" /> 
> >
> > 2. 让¬紧靠谓词(用等价关系)
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121150247762.png" alt="image-20231121150247762" style="zoom:34%;" /> 
> >
> > 3. 重命名变元，使不同量词约束的变元名字不同
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121150931588.png" alt="image-20231121150931588" style="zoom:36.5%;" /> 
> >
> > 4. 消去存在量词
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121152331150.png" alt="image-20231121152331150" style="zoom:43%;" /> 
> >
> > 5. 全称量词移到公式左边，示例中$\forall$已经在左边
> >
> > 6. 将公式化为Skolem标准形(用等价关系)
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121153517775.png" alt="image-20231121153517775" style="zoom: 35%;" /> 
> >
> > 7. 消去全称量词，消去合取词，就得到了子句集
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231121154026611.png" alt="image-20231121154026611" style="zoom:42%;" /> 
>
> ## 3.4. 二元归结式
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20240102163304940.png" alt="image-20240102163304940" style="zoom:67%;" /> 
>
> ## 3.5. 归结反演推理
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231122001740141.png" alt="image-20231122001740141" style="zoom:50%;" /> 
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231122003947821.png" alt="image-20231122003947821" style="zoom:50%;" /> 
>
> ## 3.6. 用归结原理求取问题
>
> > A,B,C 三人，$T(x)$表示$x$说真，证明$\neg{}T(A)$
> >
> > 1. 有人全说谎，有人全说真
> > 2. A说：BC说谎
> > 3. B说：AC说谎
> > 4. C说：AB至少一人说谎
> >
> > :dagger:前提化为子句集
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231122164643111.png" alt="image-20231122164643111" style="zoom:25%;" /> 
> >
> > :santa:整理，简化子句集
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231122170334006.png" alt="image-20231122170334006" style="zoom: 43%;" /> 
> >
> > :airplane:开始归结
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231122170829291.png" alt="image-20231122170829291" style="zoom:50%;" /> 
> >
> > :face_with_head_bandage:推广：题目改为，判断谁是说真话，引入Answer谓词
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231122172621503.png" alt="image-20231122172621503" style="zoom: 40%;" />  

# 5. 模糊推理

> ## 5.1. 模糊关系$R$的扎得构造法
>
> > 题目与核心公式
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231124145847188.png" alt="image-20231124145847188" style="zoom: 33%;" /> 
> >
> > 模糊集补集的求法
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231124151457307.png" alt="image-20231124151457307" style="zoom:33%;" /> 
> >
> > 求笛卡尔乘积
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231124153246939.png" alt="image-20231124153246939" style="zoom: 28%;" /> 
> >
> > 求笛卡尔并——(笛卡尔交就是取二者之一的较小者)
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/7HNDE%257O4%7DF5FJW2%5B63F2%5DK.png" alt="7HNDE%7O4}F5FJW2[63F2]K" style="zoom:29%;" /> 
> >
> > 求笛卡尔有界和
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/LD%25ZSAD%40%7D%7BTVI0Q6%7BRGQ%7E%7DL.png" alt="LD%ZSAD@}{TVI0Q6{RGQ~}L" style="zoom: 29%;" /> 
> >
> > 合成模糊关系
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231124161240979.png" alt="image-20231124161240979" style="zoom:29%;" />  

# 6. 搜索策略

> ## 6.1. 广度优先的重排九宫
>
> > 从$S_0\to{}S_g$的重排九宫，==这个例子一定看明白==
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231125193843463.png" alt="image-20231125193843463" style="zoom:59%;" /> 
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231125193937300.png" alt="image-20231125193937300" style="zoom:33%;" /> 
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/1.png" alt="1" style="zoom: 51%;" /> 