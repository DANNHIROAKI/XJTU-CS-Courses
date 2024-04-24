# Verilog概述

## 1. 综合与仿真

> ### 2.1. 综合
>
> > <img src="C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20231128133401523.png" alt="image-20231128133401523" style="zoom: 38%;" />
> >
> > :one:Verilog是硬件描述语言：用代码描述硬件功能，也可用于测试
> >
> > :two:综合：解释Verilog代码，转化(烧写)为实际电路(网表)
> >
> > :three:综合器：常见有DC，VIVADO，QUARTUS
> >
> > :four:综合过程：
> >
> > 1. 简单示例：`assign a=b&c`，EDA综合工具去元件库调用二输入与门，输入端接上b,c输出端接上a
> >
> > 2. 复合示例
> > ```verilog
> > assign a=b&c;
> > assign c=e|f;
> > assign e=x^y;
> > ```
> >
> > 综合工具会把这些逻辑电路用门电路连接
> >
> > 3. 优化示例：`assing a=b&~b`不会调用与门，而会让恒接0
>
>
> ### 2.2. 仿真
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231128133952642.png" alt="image-20231128133952642" style="zoom:38%;" /> 
> >
> > :one:含义：在综合之前，模拟运行Verilog生成的电路，来degug
> >
> > :two:测试文件：模拟必须要有Verilog编写的测试文件
> >
> > :three:仿真流程：测试文件描述仿真对象的输入激励情况→输入激励到对象，查看对象输出是否和预期
> >
> > :heavy_plus_sign:Verilog语法分为测试语法，设计语法
>
> ### 2.3. 可综合设计
>
> > :one:可综合和不可综合语法：看语法结构能不能映射成实际电路结构，可以就是可综合
> >
> > 1. 可综合的过程：解释代码→从库中选择部件→部件按照逻辑搭建成门电路
> > 2. 不可综合：找不到对应门来将代码转为电路吗，例如延时/打印等用于测试的代码
> >
> > :two:不可综合代码
> >
> > | 关键字    | 英文                 | 描述                                     |
> > | --------- | -------------------- | ---------------------------------------- |
> > | 初始      | initial              | 只能在测试中用                           |
> > | 任务/函数 | task/function        | 都可，不建议在设计中用                   |
> > | 循环      | for                  | 都可，不建议在设计中用                   |
> > | 循环      | while/repeat/forever | 产生测试激励，只能在测试中用             |
> > | 整型      | integer              | 信号类型，不建议在设计中用               |
> > | 三态门    |                      | 内部模块不允许有三态门，只可用于顶层文件 |
> > | 分支      | casex/casez          | 设计内最好不用X或Z条件                   |
> > | 并发      | force/wait/fork      | 只能在测试中使用                         |
> > | 参数      | #n                   | 延时多少纳秒，只能在测试中使用。         |
> >
> > :three:可综合代码
> >
> > | 关键字                 | 描述                                                |
> > | ---------------------- | --------------------------------------------------- |
> > | reg/wire               | 信号类型，只有reg(always设计时)和wire(其他时候)两种 |
> > | parameter              | 设计中所有的参数，如长度/决定机会分等               |
> > | assign/always          | 程序主要部分，详见下边                              |
> > | if else和case          | always里面来选择逻辑                                |
> > | 算术运算符             | 用+, －, ×综合出相应电路，/和％不推荐用             |
> > | 赋值运算符             | =(组合逻辑用), <mark><=</mark>(时序逻辑用)        |
> > | 关系运算符             | ==, !=, >, <, >=, <mark><=</mark>(这两个符号就是一样的)     |
> > | 逻辑运算符             | &&, \|\|, !                                         |
> > | 位运算符  |                             ~, \|, ^, &                        |
> > | 移位运算符   |    <<, >>                                                 |
> > | 拼接运算符  |          (){}                                           |
> >
> > ```verilog
> > /*组合逻辑*/
> > always@(*) begin
> > //代码语句；
> > end
> > 
> > /*时序逻辑*/
> > always@(posedge clk or negedgerst_n) begin
> >     if(rst_n==1’b0)begin
> >         //代码语句
> >         end
> >     else begin
> >         //代码语句
> >         end
> > ```
> >

## 2. 模块结构

> ### 2.1. 模块概述
>
> > :one:什么是模块：Verilog的基本描述单元与设计单元，描述某设计的结构功能+与其他模块通信的接口
> >
> > :two:模块的特点
> >
> > 1. 可用来表示独立器件(各种门)，或者宏单元(计数器，ALU，CPU)
> > 2. 可被另一个模块调用
> >
> > :three:Top-Down设计思想
> >
> > 1. 设计大型电路时，分割为多个小模块
> > 2. 每个小模块实现特定功能
> > 3. 用顶层模块调用子模块来实现功能
>
> ### 2.2. 模块结构
>
> > 端口定义+参数定义(Optional)+IO说明+内部信号声明+功能定义，下例
> >
> > ```verilog
> > /*端口定义*/
> > module module_name //以关键词module开始
> >     (
> >         clk ,      //端口1，时钟
> >         rst_n ,    //端口2，复位
> >         dout       //其他信号      
> >     );
> > /*参数定义*/
> >     parameter DATA_W=8;
> > /*IO说明*/
> >     input clk ;               //输入信号定义
> >     input rst_n ;             //输入信号定义 
> >     output[DATA_W-1:0] dout;  //输出信号定义
> > /*信号说明*/
> >     reg [DATA_W-1:0] dout;    //信号类型(reg、wire)定义 
> >     reg signal1;              //信号类型(reg、wire)定义
> > /*********描述功能*********/
> > /*功能定义*/
> >     //组合逻辑写法
> >     always@(*)begin
> >     end
> >     //时序逻辑写法
> >     always@(posedge clk or negedge rst_n)begin
> >         if(rst_n==1'b0)begin
> >         end
> >         else begin
> >         end
> >     end
> > endmodule                     //以关键词endmodule开始
> > ```
> >
> > #### 2.2.1. 模块名+端口定义
> >
> > > :one:模块名：此处是module，是模块的唯一标识符，一般与文件同名
> > >
> > > :two:模块端口：模块IO的端口名+与其他模块联系端口的标识
> >
> > #### 2.2.2. 参数定义(可选择)
> >
> > > :one:一般格式：`parameter DATA_W = x`
> > >
> > > :two:用途：将常量用符号代替，增加代码可读性
> >
> > #### 2.2.3. 接口定义(IO说明)
> >
> > > 可以是输入/输出/双向端口，格式如下
> > >
> > > ```verilog
> > > \\输入端口
> > > input [信号位宽-1 ： 0] 端口名 1；
> > > input [信号位宽-1 ： 0] 端口名 2；
> > > \\输出端口
> > > output [信号位宽-1 ： 0] 端口名 1；
> > > output [信号位宽-1 ： 0] 端口名 2；
> > > \\双向端口
> > > inout [信号位宽-1 ： 0] 端口名 1；
> > > inout [信号位宽-1 ： 0] 端口名 2；
> > > ```
> >
> > #### 2.2.4. 信号类型
> >
> > > 分为`reg`，`wire`两种类型变量，定义了模块内使用的信号类型，且与端口有关
> > >
> > > ```verilog
> > > reg  [width-1 : 0] R 变量 1, R 变量 2……；
> > > wire [width-1 : 0] W 变量 1, W 变量 2……；
> > > ```
> > >
> > > 无信号类型时，默认为`wire`型且位宽为1
> >
> > #### 2.2.5. 功能描述
> >
> > > 最重要的部分，产生逻辑，定义功能；有三种方式
> > >
> > > :one:`assign`和`alwanys`语句
> > >
> > > :two:模块例化：见下
> >
> > #### 2.2.6. 模块例化：在一个模块中调用另一个模块
> >
> > > :one:数字系统设计思路
> > >
> > > 1. 系统化为几个功能模块→功能模块再划分为下一层子模块→每个最小模块设计一个Verilog程序
> > > 2. 结构化设计系统顶层模块，其中分别调用各个功能模块
> > >
> > > :two:格式
> > >
> > > ```verilog
> > > module_nameinstance_name(port_associations) ;
> > > 
> > > /*两种关联方式*/
> > > port_expr //通过位置。
> > > .PortName (port_expr) //通过名称。
> > > ```
> > >
> > > :three:示例
> > >
> > > ```verilog
> > > module and (C，A，B);
> > > input A，B；
> > > output C；
> > > /*省略*/
> > > endmodule
> > > ```
> > >
> > > 在下面的“and_2”块中对上一模块“and”进行例化，可以有两种方式
> > >
> > > ```verilog
> > > /*位置关联*/
> > > /*
> > > **将模块实例化为名为A1的实例
> > > **T3对应输出端口C，A对应A，B对应B
> > > */
> > > module and_2(xxxxx)
> > > and A1 (T3, A, B );//
> > > endmodule;
> > > ```
> > >
> > > ```verilog
> > > /*名字关联*/
> > > /*
> > > **将模块实例化为名为A1的实例
> > > **.C是and器件的端口.C(T3)表示这个端口与信号T3相连
> > > **.A(A)与.B(B)表示接收外部的A,B信号
> > > */
> > > module and_2(xxxxx)
> > > and A2
> > >     (
> > >         .C(T3)，
> > >         .A(A)， 
> > >         .B(B)
> > >     )； 
> > > endmodule;
> > > ```
> > >
> > > :four:Tips：多用名字关联，因为实例化中不是所有管脚都会用到，位置关联容易出错
> > >
> > > ```verilog
> > > DFF d1
> > > (
> > >     .Q(QS), 
> > >     .Qbar(),    // 该管脚悬空
> > >     .Data(D) , 
> > >     .Preset(),  // 该管脚悬空
> > >     .Clock(CK)  // 名称对应方式
> > > ); 
> > > ```

## 3. 信号类型

> ### 3.1. 信号位宽`[msb: lsb]`
>
> > :one:信号定义时必须定义位宽，缺省则默认为1
> >
> > :two:位宽为$n$的信号，能表示最大无符号值为$2^n-1$，例如信号最大值为1000时$n=10$
> >
> > :three:示例
> >
> > ```verilog
> > wire [3:0] Sat;               //Sat为4位线型信号
> > wire Cnt;                     //1位线型信号
> > reg [31:0] Kisp, Pisp, Lisp ; // Kisp, Pisp, Lisp都是32位的寄存器型信号
> > ```
>
> ### 3.2. `wire` 和`reg`
>
> > :one:语法
> >
> > ```verilog
> > reg  [msb: lsb] reg1, reg2, . . . reg N;
> > wire [msb: lsb] wire1, wire2, . . .,wireN;
> > ```
> >
> > :two:什么时候用`reg`什么时候用`wire`
> >
> > 1. `reg `型信号并不一定生成寄存器
> >
> > 2. 使用`always `设计的信号都定义为`reg `型，其他信号都定义为`wire `型
> >
> >    ```verilog
> >    /*cnt1是reg类型，add_cnt1和end_cnt是wire类型*/
> >    always @(posedge clk or negedge rst_n) begin
> >        if (!rst_n) begin
> >            cnt1 <= 0;  
> >        end  
> >        else if (add_cnt1) begin
> >            if (end_cnt1) 
> >                cnt1 <= 0; 
> >            else 
> >                cnt1 <= cnt1 + 1; 
> >        end 
> >    end 
> >       
> >    assign add_cnt1 = end_cnt0; 
> >    assign end_cnt1 = add_cnt1 && (cnt1 == 8-1);
> >    ```
> >
> > 3. 例化模块的输出必定是`wire`类型，因为它必不可能是`always`生成的

## 4. 程序语句

> ### 4.1. `assign`语句
>
> > :one:功能：将一个变量的值不间断赋给另一变量(二者一定是`wire`类型)，模拟实际中的连线
> >
> > :two:格式：`assign a = b (逻辑运算符) c`
> >
> > :three:特点：多条assign间互相独立，并行执行
>
> ### 4.2. `always`语句
>
> > :one:结构与功能：敏感事件每满足一次，就执行一次程序
> >
> > ```verilog
> > always @(敏感事件)begin
> > //程序语句 
> > end
> > ```
> >
> > :two:组合逻辑：条件信号变化，结果立即变化的`always`语句示例如下(注意赋值用阻塞式`=`)
> >
> > 信号`a,b,d`之一发生变化，就执行一次下面的语句
> >
> > ```verilog
> > always @(a or b or d) begin
> >     if (sel == 0)
> >         c = a + b;
> >     else
> >         c = a + d;
> > end
> > /*几点说明
> > **1.always触发后，模块会完整执行一次，在结束执行前，即使abd变化，也不会中断or重开
> > **2.存在一个问题，当sel变化时并不会触发always，由此sel=0时不一定执行c=a+b，反之亦然
> > **3.解决方案如下
> > */
> > 
> > /*改进版：sel=0时c的结果一定为a+b，此外c的结果一定是a+d*/
> > always @(a or b or d or sel) begin //其余不变
> >     
> > /*可以用`*`代指程序中所有条件信号，在此处可做出替换*/ 
> > always @(*) begin //(*)在这等同于(a or b or d or sel)，其余不变
> > ```
> >
> > :three:时序逻辑：信号上升沿或者下降沿才变化的`always`，示例如下(注意赋值用非阻塞式`<=`)
> >
> > ```verilog
> > //posedge为上升沿，negedge为下降沿
> > 
> > //clk由1变0瞬间执行一次代码
> > always @(negedge clk)begin 
> >     
> > //clk由0变1，或rst_n由1变0瞬间执行一次代码，给出完整代码
> > always @(posedge clk or negedge rst_n) begin
> >     if (rst_n == 1'b0) begin
> >         c <= 0;
> >     end else if (sel == 0) begin
> >         c <= a + b;
> >     end else begin
> >         c <= a + d;
> >     end
> > end
> > ```
> >
> > ps.时钟信号判断：放在敏感列表+边沿触发(上升/下降沿)的信号
> >
> > ps.复位信号判断：放在敏感列表+边沿触发+程序首先要判断其值(优先级更高)，如以下`rst_n`

## 5. 数字进制

> ### 5.1. Verilog数字表示方式：`<位宽>'<基数><数值>`
>
> > :one:位宽：用十进制表示二进制常量所含位数，比如`4'b1011=4'hb`4位宽，物理上表示四根线
> >
> > :two:基数：就是几进制，可为b/B, d/D, o/O, h/H，缺省时默认为十进制，例如`4'hb=4'o13=11`
> >
> > :three:数值：表示常量真实值，一个注意点就是高位没写完则自动补0，如`32'h12=32'h00000012`
>
> ### 5.2. Verilog的二进制
>
> > #### 5.2.1. 几种基本大表示
> >
> > > :one:芯片A向芯片B传送一位二进制：用一根线a连着，a发出低电平表示0，高电平表示1
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129120452314.png" alt="image-20231129120452314" style="zoom:50%;" /> 
> > >
> > > :three:A→B两位二进制数：两根线ab连着
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129120750174.png" alt="image-20231129120750174" style="zoom:50%;" /> 
> > >
> > > :three:A→B两位二有符号数：三根线，一根表示正负
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129123150541.png" alt="image-20231129123150541" style="zoom: 50%;" /> 
> > >
> > > `3'b111`可以表示二进制的111(十进制的7)，也可以表示十进制的-3
> >
> > #### 5.2.2. 如何表示定点小数
> >
> > > :one:首先明确一点，就是比如`3'bxxx`二进制的值是多少是可以定义的，只要能保证正常通信
> > >
> > > :two:常用的定点小数定义
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129124226847.png" alt="image-20231129124226847" style="zoom: 67%;" /> 
> > >
> > > :three:定点小数的运算
> > >
> > > 1. 实现0.125+0.75=0.8725，直接`3'b001 +3'b110=3'b111`即可，或者：
> > >
> > >    ```verilog
> > >    If(a==3’b001 && b==3’b110)
> > >        c<= 3’b111; 
> > >    ```
> > >
> > > 2. 实现0.5+0.75=1.25
> > >
> > >    可以增加位宽为`3'b100 + 3'b110 = 4'b1010`
> > >
> > >    或只表示小数位`3'b100 + 3'b110 = 3'b010`
>
> ### 5.3. 不定态X
>
> > :one:X态：不定态，不关心他是高还是低电平，用作判断条件
> >
> > :two:示例：`if (din==4'b10x0)`实质上等于`if(din==4'b1000||din==4'b1010)`
>
> ### 5.4. 高阻态(无信号)Z
>
> > :one:Z态：高阻态，表示不驱动总线行为，用于三态门的接口
> >
> > :two:示例：Verilog实现三态门
> >
> > 1. 三态门原理
> >
> >    <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129130941686.png" alt="image-20231129130941686" style="zoom: 33%;" /> 
> >
> >    当写使能`wr_en==1`时，`wr_data=0/1`会赋值给`data=0/1`
> >
> >    当写使能`wr_en==1`时，`wr_data=0/1`无法给`data`赋值，即不驱动
> >
> > 2. Verilog实现，注意高阻态z的作用
> >
> >    ```verilog
> >    assign data = (wr_en==1)?wr_data:1'bz;
> >    assign rd_data = data;
> >    ```

## 6. 运算符

> ### 6.1. 算术运算符
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129161015908.png" style="zoom: 15%;" /> 
> >
> > :one:位宽问题：运算结果最终取决于<mark>等号左边信号位宽</mark>，截取低位or高位补0
> >
> > ```verilog
> > wire c;                //默认位宽=1
> > wire[1:0] d;           //位宽=2
> > wire[2:0] e;           //位宽=3
> > wire[2:0] f;           //位宽=3
> > wire[4:0] g;           //位宽=5
> > 
> > //1’b1+1’b1=2'b10
> > assign c = 1’b1 + 1’b1;//强制保留位1位，c=1'b0
> > assign d = 1’b1 + 1’b1;//强制保留位2位，c=2'b10
> > assign e = 1’b1 + 1’b1;//强制保留位3位，c=2'b010
> > assign f = 1 + 1;      //强制保留位3位，c=2'b0010，注意这里1默认为32位
> > 
> > //0-1=32个1
> > assign c = 0-1;        //强制保留位1位，c=1'b1
> > assign d = 0-1;        //强制保留位2位，d=2'b11
> > assign e = 0-1;        //强制保留位3位，e=3'b111
> > 
> > //2’b11*3’b101=4'b1111
> > assign d=2’b11*3’b101; //强制保留位2位，d=2'd11
> > assign g=2’b11*3’b101; //强制保留位5位，d=5'd01111
> > ```
> >
> > 结果保存的位宽至关重要，足以影响正确性
> >
> > :two:基于补码
> >
> > 1. Verilog中所有加减运算都用补码表示
> >
> > 2. 运算步骤：预估结果位宽→将参与运算的数扩展为相应位宽→运算得补码结果
> > 3. 负数补码：符号位保留，非符号位取反+1
> >
> > ```verilog
> > 3’b001 + 3’b110 = 3’b111 //  1  +(-2)=-1
> > 3’b111 - 3’b110 = 3’b001 // (-1)-(-2)= 1
> > ```
> ### 6.2. 逻辑运算符
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/Verilog逻辑运算_页面_1.jpg" alt="Verilog逻辑运算_页面_1" style="zoom:13%;" /> 
> >
> > :one:以下面运算为例
> >
> > <mark>所有逻辑运算的结果必然是1位</mark>，所以位宽直接默认
> >
> > ```verilog
> > assign a = 4’b0111 && 4’b1000;
> > assign b = 4’b0111 || 4’b1000;
> > assign c = !4’b0111;
> > ```
> >
> > 多为逻辑，现在转化成一位，全为0认为是假，不全为0认为是真
> >
> > ```verilog
> > assign a = 1’b1 && 1’b1;
> > assign b = 1’b1 || 1’b1;
> > assign c = !(1’b1);
> > ```
> >
> > a 为逻辑真，b 为逻辑真，c 为逻辑假
> >
> > :two:优先级：
> >
> > ```verilog
> > (a<b)&&(c > d) //a<b&&c>d ；
> > (a==b)||(c==d）//a==b||c==d ；
> > (!a)||(a>b)    //a||a>b 
> > ```
> >
> > 一般还是用括号区分优先级更直观
> >
> > :three:逻辑运算符两侧都是1比特信号，例如`010101110&&0000`会变成`1&&0`
> >
> > :four:少用非逻辑
>
> ### 6.3. 按位逻辑运算符
>
> >  <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129223050426.png" alt="vERILOG按位逻辑运算符_面_1" style="zoom:15%;" /> 
> >
> > :one:**<font color='red'>真值表</font>**
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129211946814.png" alt="image-20231129211946814" style="zoom: 58%;" /> 
> >
> > :two:逻辑运算符`&&、||、!`和位运算符`&、|、~`的区别，见下面的例子
> >
> > ```verilog
> > assign a = 4’b0111 && 4’b1000; //a=1’b1
> > assign b = 4’b0111 || 4’b1000; //b=1’b1
> > assign c = !4’b0111;           //c=1’b0(将每一位取或，再将所得结果取反)
> > assign d = 4’b0111 & 4’b1000;  //d=4’b0000
> > assign e = 4’b0111 | 4’b1000;  //e=4’b1111
> > assign f = ~4’b0111;           //=4’b1000
> > ```
>
> ### 6.4. 关系运算符(比较器)
>
> > :one:规则：
> >
> > 1. 五种操作符：相等(==)/大于(>)/大于等于(>=)/小于(<)/小于等于(<=)
> > 2. 关系操作符的结果只可能是0/1，操作数中有一个位包含x/z时结果为x
> > 3. 操作数长度不用时，自动高位补齐0
> >
> > ```verilog
> > 23 > 45              //结果为假0
> > 52 < 8'hxFF          //结果为x
> > 4'b1000 > = 5'b01110 //等价于：5'b01000 > = 5'b01110
> > ```
> >
> > :two:代码
> >
> > ```verilog
> > always@(*)begin
> >     if(A==B)//或者>,>=,<,<=
> >     C=1; 
> >     else    
> >     C=0; 
> > end 
> > ```
> >
> > :three:电路示意图：AB间可以是任意一种符号
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129230601090.png" alt="image-20231129230601090" style="zoom: 50%;" />  
>
> ### 6.5. 移位运算符
>
> > #### 6.5.1. 左移右移概述
> >
> > > :one:含义：将操作数A往左/右边移n位，然后补0(逻辑位移)，示例
> > >
> > > ```verilog
> > > wire[3:0] a;
> > > assign a = 4’b0111<< 2; //左移a = 4’b1100
> > > assign a = 4’b0111>> 2; //右移a = 4’b0001
> > > ```
> > >
> > > :two:左移的实现：不消耗逻辑资源，只需要线就行了
> > >
> > > ```verilog
> > > wire[3:0] c;
> > > wire[3:0] b;
> > > assign c = b << 2;//对应左图
> > > assign c = b >> 2;//对应右图
> > > ```
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130010917046.png" alt="image-20231130010917046" style="zoom:67%;" />    
> > >
> > > :three:**<font color='red'>左移</font>**后<mark>根据位宽存储结果</mark>
> > >
> > > 此时`4’b1001<<1=4’b0010`
> > >
> > > ```verilog
> > > wire[3:0] a;
> > > assign b = 4’b1001;
> > > assign a = b << 1;
> > > ```
> > >
> > > 此时`4’b1001<<1=5’b10010`
> > >
> > > ```verilog
> > > wire[4:0] a;
> > > assign b = 4’b1001;
> > > assign a = b << 1;
> > > ```
> > >
> > > :four:左移/右移位数，可以是常数也可以是变量(信号)
> > >
> > > ```verilog
> > > // 定义变量
> > > reg [4:0] a;
> > > reg [2:0] cnt;
> > > 
> > > // 带有cnt和同步复位的always块
> > > always @(posedge clk or negedge rst_n) begin
> > >     if (!rst_n) begin
> > >         cnt <= 3'b0;
> > >     end else begin
> > >         cnt <= cnt + 1'b1;
> > >     end
> > > end
> > > 
> > > // 有位移的always块
> > > always @(*) begin
> > >     a = 4'b1 << cnt;
> > > end
> > > ```
> > >
> > > 1. 由此a一个时钟周期的变化为：
> > >
> > >    <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129234432630.png" alt="image-20231129234432630" style="zoom: 67%;" /> 
> > >
> > > 2. 移位数为信号时，综合出的电路不再是连线而是选择器，在本例中为：
> > >
> > >    <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231129234619821.png" alt="image-20231129234619821" style="zoom: 67%;" />  
> >
> > #### 6.5.2. 左移右移应用
> >
> > > :one:左移—乘法运算：Verilog中乘法运算开销大，用`<<`会节省很多
> > >
> > > 1. 乘二次幂时：$a<<n\xleftrightarrow{代替}a*2^n$
> > >
> > > 2. 乘以其他时：用移位简化
> > >
> > >    ```verilog
> > >    assign b = a*127;
> > >    assign b = (a<<7) –a;
> > >    
> > >    assign c = a*67;
> > >    assign c = (a<<6) +(a<<1) +a;
> > >    ```
> > >
> > > 3. 乘数为常数时，综合工具都可自动优化，但当乘数为变量时尽量将信号转化为$2^n$倍
> > >
> > >    例如要扩大100倍不如直接扩大128倍
> > >
> > > :two:右移实现除法：$a>>n\xleftrightarrow{代替}a/2^n$，当除数不为为二次幂时则就不能采取位移简化了
> > >
> > > :three:左移生成数字
> > >
> > > 1. 生成独热码：所有位中只有一个为1的数如`5’b00010`，用于多选一电路，表示机器状态
> > >
> > >    ```verilog
> > >    4'b0010 //可以是4’b1 << 1
> > >    ```
> > >
> > > 2. 其他数字
> > >
> > >    ```verilog
> > >    5’b00111，//(5’b1<<3)-1。
> > >    5’b11100，//~((5’b1<<2)-1)
> > >    ```
> ### 6.6. 条件运算符
>
> > #### 6.6.1. 三条目算符
> >
> > > :one:规则与语法：`条件表达式S? 真表达式u:假表达式t;`
> > >
> > > 1. 条件表达式=1执行真表达式，条件表达式=0执行假表达式
> > > 2. 条件表达式=x或z时，比较真表达式和假表达式，二者都为0时得0/都为1时得1/其余情况为x
> > >
> > > 3. 电路示意图，可用if-else代替条件表达式
> > >
> > >    <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130011001557.png" alt="image-20231130011001557" style="zoom: 67%;" /> 
> > >
> > > :two:使用方法
> > >
> > > 1. 条件赋值：`assign student = Marks >18 ?Grade_A：Grade_C ;`
> > >
> > >    <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130011243643.png" alt="image-20231130011243643" style="zoom: 50%;" /> 
> > >
> > > 2. 嵌套使用：`assign OUT = (M==1)?(CTL ? A:B):(CLT ? C:D);`
> > >
> > >    例如，M==1为真时判断CTL是否为真，如果CTL为真就将A赋值给OUT
> > >
> > >    <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130011904992.png" alt="image-20231130011904992" style="zoom: 50%;" /> 
> >
> > #### 6.6.2. `if`语句
> >
> > > :one:语法与含义
> > >
> > > ```verilog
> > > if(condition_1) begin 
> > >     statement_1;       //condition_1满足，不管其他条件怎么样，只执行statement_1
> > > end
> > > 
> > > else if(condition_2) begin
> > >     statement_2;       //condition_1不满足，condition_2满足时，只执行statement_2
> > > end
> > > 
> > > else begin
> > >     statement_3;       //其余情况才执行statement_3
> > > end
> > > ```
> > >
> > > | condition_1 | condition_2 |               statement_1                |               statement_2                |               statement_3                |
> > > | :---------: | :---------: | :--------------------------------------: | :--------------------------------------: | :--------------------------------------: |
> > > |      1      |      1      | <font color='cornflowerblue'>执行</font> |     <font color='red'>不执行</font>      |     <font color='red'>不执行</font>      |
> > > |      1      |      0      | <font color='cornflowerblue'>执行</font> |     <font color='red'>不执行</font>      |     <font color='red'>不执行</font>      |
> > > |      0      |      1      |     <font color='red'>不执行</font>      | <font color='cornflowerblue'>执行</font> |     <font color='red'>不执行</font>      |
> > > |      0      |      0      |     <font color='red'>不执行</font>      |     <font color='red'>不执行</font>      | <font color='cornflowerblue'>执行</font> |
> > >
> > > :two:若为if - if 语句，使用块语句begin --- end清晰化结构，如下所示
> > >
> > > ```verilog
> > > if(Clk) begin
> > >     if(Reset) 
> > >         Q = 0; 
> > >     else 
> > >     Q = D; 
> > > end
> > > ```
> >
> > #### 6.6.3. Case语句，看例子就行
> >
> > > ```verilog
> > > case (HEX) 
> > >     4'b0001 : LED = 7'b1111001; // HEX= 4'b0001时LED = 7'b1111001
> > >     4'b0010 : LED = 7'b0100100; 
> > >     4'b0011 : LED = 7'b0110000; 
> > > endcase
> > > ```
> > > 
> > >相比if-else语句具有优先级，case语句每条的优先级是平等的
> > #### 6.6.4. 选择语句vect
> >
> > > :one:含义：
> > >
> > > 1. `vect[a+:b]`等于`vect[a:a+b-1]`，`vect[a+:b]`等于`vect[a:a+b-1]`
> > > 2. `+`代表升序，`-`代表降序
> > >
> > > :two:示例：`data[15-8*cnt -: 8] <= din[7:0]`
> > >
> > > 1. cnt==0，将din[7:0]赋值给data[15:8]
> > > 2. cnt==1，将din[7:0]赋值给data[7:0]
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130114638976.png" alt="image-20231130114638976" style="zoom:50%;" /> 
>
> ### 6.7. 拼接运算符
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130115953113.png" alt="image-20231130115953113" style="zoom: 67%;" /> 
> >
> > :one:拼接不消耗任何逻辑资源
> >
> > :two:示例
> >
> > ```verilog
> > wire [7:0] Dbus;
> > assign Dbus[7:4]={Dbus[0],Dbus[1],Dbus[2],Dbus[3]};
> > //以反转的顺序将低端4位赋给高端4位
> > assign Dbus={Dbus[3:0],Dbus[7:4]};
> > //高4位与低4位交换
> > ```

## 7. 时序逻辑

> ### 7.1. 同步/异步复位时序逻辑
>
> > :one:同步复位：复位不是立即有效，在时钟上升沿是才有效
> >
> > :two:异步复位(用这个)：复位立即有效，与时钟无关
> >
> > ```verilog
> > always@(posedge clk) begin //同步复位
> > always@(posedge clk or negedge rst_n) begin //异步复位
> >     if(rst_n==1’b0) 
> >         //代码语句; 
> >     else begin 
> >         //代码语句;
> >     end 
> > end 
> > ```
>
> ### 7.2. D触发器
>
> > #### 7.2.1. 结构
> >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130123431855.png" alt="image-20231130123431855" style="zoom:50%;" />  
> > >
> > > :one:`rst_n==0`时，无论如何都有`q=0`
> > >
> > > :two:`rst_n==1`时，`clk`上升沿时`q=d`
> >
> > #### 7.2.2. D触发器波形
> >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130123824702.png" alt="image-20231130123824702" style="zoom: 67%;" /> 
> > >
> > > :one:先有时钟上升沿(因)，然后再将d值赋给q(果)，但其实后者的发生在实际上会有一定延时
> > >
> > > :two:复位其实是特殊情况，只在开始/异常时刻才用
> >
> > #### 7.2.3. D触发器代码
> >
> > > ```verilog
> > > always @(posedge clk or negedge rst_n)begin
> > >     if(rst_n==1'b0)begin 
> > >         q <= 0;
> > >     end
> > >     else begin
> > >         q <= d;
> > >     end
> > > end
> > > ```
>
> ### 7.3. 时钟
>
> > :one:基本概念
> >
> > 1. 时钟：每隔固定时间上下变化的信号
> > 2. 时钟周期：两次相邻上升沿的时间差，其倒数就为时间频率(即每秒时钟出现上升沿的次数)
> > 3. 占空比：高电平占整个时钟周期时间(一般为50%)
> >
> > :two:对时钟的要求：时钟要稳定，时钟越少越好，所以不要把信号放在时序逻辑敏感列表
>
> ### 7.4. 时序逻辑示例
>
> > :one:写法1
> > ```verilog
> > always @(posedge clk or negedge rst_n)begin
> >  if(rst_n==1'b0)begin 
> >      q <= 0; 
> >  end
> >  else begin
> >      q <= a + d;
> >  end 
> > end
> > ```
> >
> > :two:写法2
> >
> > ```verilog
> > always @(posedge clk or negedge rst_n)begin
> >     if(rst_n==1'b0)begin 
> >         q <= 0;
> >     end
> >     else begin
> >         q <= c;
> >     end
> > end
> > always @(*)begin
> >     c = a + d;
> > end
> > ```
> >
> > :three:电路图
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130133244881.png" alt="image-20231130133244881" style="zoom: 67%;" />  
> >
> > :four:波形图
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231130133305421.png" alt="image-20231130133305421" style="zoom:67%;" /> 
>
> ### 7.5. 阻塞赋值`=`和非阻塞赋值`<=`
>
> > :one:阻塞赋值`=`：多用于组合逻辑，一个`begin end`中阻塞赋值是按顺序执行
> >
> > :two:非阻塞赋值`<=`：多用于时序逻辑，一个`begin end`中非阻塞赋值是同时执行
> >
> > :three:示例
> >
> > ```verilog
> > begin 
> >     c = a;     //先执行这个
> >     d = c + a; //用上一步得到的结果，再执行这个
> > end 
> > begin
> >     c <= a;    //同时执行
> >     d <= c + a;//同时执行，不管其他步骤的结果是什么
> > end
> > ```
> >













