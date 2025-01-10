# 0. 判断实时系统可调度

> <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231114141228848.png" alt="image-20231114141228848" style="zoom:45%;" /> 

# 1. 进程管理

> ##  1.1. 进程调度
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/xxx.png" alt="xxx" style="zoom:13%;" /> 
>
> ## 1.2. 信号量计算
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231117145245092.png" alt="image-20231117145245092" style="zoom:67%;" /> 
>
> ## 1.3. 死锁的判断
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231117145333062.png" alt="image-20231117145333062" style="zoom:68%;" /> 
>
> ## 1.4. 银行家算法
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231115163621139.png" alt="image-20231115163621139" style="zoom: 67%;" /> 

# 3. 内存管理

> ## 3.1. 地址位数
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231117145511254.png" alt="image-20231117145511254" style="zoom: 67%;" /> 
>
> ## 3.2. 逻辑-物理地址转换
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231115172047161.png" alt="image-20231115172047161" style="zoom: 43%;" />  
>
> ## 3.3. 分页替换
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/yyyy.png" alt="yyyy" style="zoom: 26%;" /> 

# 4. 磁盘调度

> <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231114223509634.png" alt="image-20231114223509634" style="zoom:67%;" /> 

# 5. PV操作

> # 5.1. Pre
>
> > :one:**互斥信号量**：
> >
> > 1. 为临界资源设置一个互斥信号量 mutex=1
> > 2. 每个进程的临界区代码置于P(mutex) 和V(mutex) 原语之间
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231116210432577.png" style="zoom:50%;" /> 
> >
> > **:two:前驱关系**
> >
> > 1. P1，P2并发执行，要求代码C1要在代码C2开始前完成
> > 2. 为该前驱关系设置一个信号量S12=0
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231116211204153.png" alt="image-20231116211204153" style="zoom: 33%;" /> 
>
> ## 5.2. 生产者-消费者问题1
>
> > #### 题目 
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231115231507893.png" alt="image-20231115231507893" style="zoom: 67%;" /> 
> >
> > #### 解析
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/wfrsbzegdnhf%20.png" alt="wfrsbzegdnhf " style="zoom:10%;" /> 
>
> ## 5.3. 生产者-消费者问题2
>
> > ####  题目 
> >
> >  <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231115233538764.png" alt="image-20231115233538764" style="zoom: 67%;" /> 
> >
> > #### 解析
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231115233634997.png" alt="image-20231115233634997" style="zoom: 67%;" /> 
>
> ## 5.4. 生产者-消费者问题3
>
> > #### 题目
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231117151705287.png" alt="image-20231117151705287" style="zoom:65%;" /> 
> >
> > #### 解析
> >
> > <img src="C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20231117151717762.png" alt="image-20231117151717762" style="zoom:67%;" />**
>
> ## 5.5. 利用进程前驱图问题
>
> > #### 题目 
> >
> > 1. 进程A每读入一批数据后把数据分解成二个可并发计算的数据块
> > 2. 进程B和C分别处理两个分出来的数据块，<mark>BC处理涉及的是同一数据结构</mark>
> > 3. 当进程B和C均完成处理后，再由进程D善后
> >
> > #### 解析
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231116000532339.png" alt="image-20231116000532339" style="zoom:67%;" /> 
>
> ## 5.6. 读者写者问题
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231116013653510.png" alt="image-20231116013653510" style="zoom: 67%;" /> 





