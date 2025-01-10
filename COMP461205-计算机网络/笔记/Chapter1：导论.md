# Chapter1：导论

# 1. 基本概念

> :one:网络：一个在两个或多个实体之间传输有价值物品的系统
>
> :two:计算机网络：多台独立计算机，通过通信设备和软件互联，以共享交换资源的集合
>
> :three:==计算机网络vs分布式系统==
>
> 1. 分布式系统：以提高整体性能为目的，各计算机协调自治，呈现给用户的是整体系统
> 2. 计算机网络：以资源共享为目的，各计算机独立，呈现给用户的是分散的系统

# 2. 基于网络的获取信息

> :one:C-S模式：客户端进程向服务器进程发请求，然后等待服务器响应，如访问网页
>
> <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/AtR3aGUCLgF8EOm.png" alt="image-20231231142047737" style="zoom:80%;" />  
>
> :two:P2P模式：无固定客户端/服务器，建立在另一个网络上的松散网络组
>
>  <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231142156846.png" alt="image-20231231142156846" style="zoom:50%;" /> 
>
> :three:端-端通信：即时通讯，推特，社交网络，Wiki(社区成员共同编辑)
>
> :four:电子商务 
>
> | 标签 | 全称           | 示例                         |
> | ---- | -------------- | ---------------------------- |
> | B2C  | 企业对消费者   | 在线订购书籍                 |
> | B2B  | 企业对企业     | 汽车制造商从供应商处订购轮胎 |
> | G2C  | 政府对消费者   | 电子方式分发纳税表格         |
> | C2C  | 消费者对消费者 | 在线拍卖二手产品             |
> | P2P  | 点对点         | 音乐或文件共享；Skype通话    |
>
> :five:娱乐
>
> 1. IPTV：基于IP技术的电视节目
> 2. 媒体流：通过网络实时传输的多媒体，如抖音，无需下载
> 3. 多人实时模拟游戏
> 4. 虚拟世界
>
> :six:万物互联
>
> 1. IoT(物联网)：将所有电子设备连接至互联网
> 2. 电力线网络：通过电线上网
> 3. 将计算融入生活：如智能家居

# 3. 计算机网络类型

> | 类型              | 描述                                         | 注意事项                                       |
>| ----------------- | -------------------------------------------- | ---------------------------------------------- |
> | 宽带接入网络      | 用铜线/同轴电缆/光纤，将家庭接入网络         | ==$网络价值\xleftrightarrow{正比于}用户数^2$== |
>| 移动/无线接入网络 | 基于IEEE802.11，有SMS/GPS/NFC等              | \                                              |
> | 数据中心网络      | 可以在数据中心内外大规模传输数据             | 数据中心=云                                    |
>| 内容分发网络CDN   | 存放内容副本于不同地理位置，加速本地访问速度 | \                                              |
> | 中转网络          | 当服务器和用户无法直达时，由中转网络桥接     | 不多用了，都用CDN/ISP                          |
>| 企业网络          | 通过VPN将分散的网络连接成一个逻辑网络        | \                                              |

# ==4. 网络技术类别==

> ## 4.1. 传输技术分类
>
> > :one:广播链接：一发多收(如广播电视)，有如下两种拓扑(总线和环)，需要解决共享信道和冲突
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231142223275.png" alt="image-20231231142223275" style="zoom: 67%;" />   
> >
> > :two:点对点链接：一发一收
>
> ## 4.2. 按照覆盖范围分类  
>
> > ### 4.2.1. PAN/LAN/MAN个域网&==(核心问题)==
> >
> > > :one:PAN个域网==(如何连接)==：设备仅在一个人的范围内通信，如蓝牙
> > >
> > > :two:LAN局域网==(怎么共享信道)==：范围扩展到了家庭/一栋楼，可为无线(左)/有线(以太网)
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231142522906.png" alt="image-20231231142522906" style="zoom:50%;" /> 
> > >
> > > :three:MAN城域网：信号接入总站然后分发，例如广播电视
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231142700908.png" alt="image-20231231142700908" style="zoom: 67%;" />  
> >
> > ### 4.2.2. WAN广域网==(寻找最优路径)==
> >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231144153271.png" alt="image-20231231144153271" style="zoom: 67%;" />    
> > >
> > > :one:子网：线路+路由器集合
> > >
> > > :two:WAN种类：VPN，ISP网络服务提供商==(其子网由不同的公司运营)==
> > >
> > > :three:示例：三地的网路采用租用线路/互联网/网络服务提供商连接
> > >
> > >  <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231143217031.png" alt="image-20231231143217031" style="zoom: 67%;" />
> > >
> > >   
> >

# 5. 网络实例

> ## 5.1. 互联网：各种类型/不同运营商的网络相连
>
> > :one:前互联网时代
> >
> > | 术语    | 简介                                                   |
> > | ------- | ------------------------------------------------------ |
> > | ARPANET | 互联网的前身，美国防高级研究计划署研发的早期网络       |
> > | NSFNET  | 美国国家科学基金会支持的网络，推动了互联网的发展和普及 |
> >
> > :two:互联网结构概览
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231144706306.png" alt="image-20231231144706306" style="zoom: 67%;" /> 
> >
> > | 术语     | 描述                                   |
> > | -------- | -------------------------------------- |
> > | POP      | 物理接入点，让企业和用户在特定地点入网 |
> > | IXP      | 物理设施，让不同网络交换流量           |
> > | CMTS     | 高速互联网接入服务(有线电视)           |
> > | DSLAM    | 收集用户的DSL连接，汇集到高速连接上    |
> > | 路由     | 负责在每个网络中交换数据包。           |
> > | 数据中心 | 聚集了服务器，承担了网络大部分流量     |
> > | 网络边缘 | 客户接入网络的地方                     |
> >
> > :two:互联网结构层次
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231145724266.png" alt="image-20231231145724266" style="zoom:67%;" />  
> >
> > 推荐一个好玩的网站http://www.opte.org/the-internet/
>
> ## 5.2. 移动网络
>
> > ### 5.2.1. 4G LTE结构
> >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231145948979.png" alt="image-20231231145948979" style="zoom: 50%;" /> 
> > >
> > > :one:E-UTRAN：无线接入部分，连接用户设备和网络
> > >
> > > :two:EPC：核心部分，完成数据路由和移动性管理
> > >
> > > | 术语 | 描述                                     |
> > > | ---- | ---------------------------------------- |
> > > | HSS  | 归属用户服务器，存储用户信息             |
> > > | MME  | 移动管理结点，负责移==动性管理==         |
> > > | S-GW | 服务网络网关，负责数据包的==路由和转发== |
> > > | P-GW | 分组数据网关，连接用户和外部网络         |
> >
> > ### 5.2.2. 3G结构
> >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171717902.png" alt="image-20231231171717902" style="zoom:67%;" />  
> > >
> > > | 术语 | 描述                                 |
> > > | ---- | ------------------------------------ |
> > > | UMTS | 通用移动通讯系统，宽带/移动/国际漫游 |
> > > | RNC  | 无线网络控制器                       |
> > > | MSC  | 移动交换中心                         |
> > > | HSS  | 归属用户服务器                       |
> > > | MGW  | 媒体网关                             |
> > > | PSTN | 交换电话网络                         |
> >
> > ### 5.2.3. 移动网络的世代
> >
> > > | 代数   | 描述                                          |
> > > | ------ | --------------------------------------------- |
> > > | 1G     | 模拟信号传输语音                              |
> >> | 2G     | 数字信号传输语音，容量大安全性高，提供SMS     |
> > > | 3G     | 数字语音/宽带数字数据服务，采用蜂窝设计(下图) |
> >> | 4G LTE | 速度更快                                      |
> > > | 5G     | 速度更更更快，但信号衰减也更快                |
> > >
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171732570.png" alt="image-20231231171732570" style="zoom:50%;" />  
> > 
> > ### 5.2.4. Wi-Fi(WLAN/IEEE802.11)
> > 
> > > :one: **基础设施无线局域网**：客户通过接入点接入，接入点通过有线方式连接其他网络
> > >
> > > :two: **Ad hoc网络**：在相同的无线范围内，客户端可以直接通信
> >>
> > > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171747487.png" alt="image-20231231171747487" style="zoom: 67%;" />  

# 6. 网络协议

> ## 6.0. 设计目标
>
> > :one: 可靠性：检错，纠错，正确路由
> >
> > :two: 资源分配和调度：拥塞控制，资源共享，可扩展
> >
> > :three: 可演化性：支持不断变化的网络，使用协议层次结构和地址机制
> >
> > :four:==安全性：保护机密、通信方认证、防止消息篡改==
>
> ## 6.1. 协议及有关概念
>
> > :one:协议：同一层内，==通信双方就如何通信的一种约定，包括<font color='red'>**语法/语义/时序**</font>==
> >
> > PS: ==语法：格式/封装/信息控制==
> >
> > :two:接口：定义两层之间如何交互
> >
> > :three:服务：==一层为给上一层==的操作，如请求/响应/确认，==用户进程通过原语来访问服务==
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20230917191846762.png" alt="image-20230917191846762" style="zoom: 33%;" /> 
>
> ## 6.2. 协议分层：划分网络功能的主要结构化方法
>
> > :one: 层堆叠：如下图
> >
> > 1. 每层只通过下面一层通信，第一层则直接访问物理媒介
> >
> > 2. 每个协议实例都与其对等实体进行虚拟通话
> >
> > 3. 网络架构=层+协议  
> >
> >    <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171645887.png" alt="image-20231231171645887" style="zoom: 67%;" />   
> >
> > :two: 协议堆栈：每一层都使用一个特定的协议，例如传输层的TCP/IP，然后一层层堆起来
> >
> > :three:==分层特点==
> >
> > 1. 各层独立：只需管好自己这一层(自己曾采用合适技术)，和与其他层的接口就行
> > 2. 灵活性好：任意层变化后，不影响接口的话，相邻层都不影响
> > 3. 易于实现和维护
> > 4. 促进标准化
>

# 7. 参考模型

> ## 7.1. OSI
>
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171636150.png" alt="image-20231231171636150" style="zoom:67%;" />   
> >
> > | OSI模型层级 | 功能描述                                         |
> >| ----------- | ------------------------------------------------ |
> > | 物理层      | 管理与物理媒体的直接交互，在物理媒介上传输比特流 |
> >| 数据链路层  | 在物理线路上实现可靠传输，将原始比特流封装为帧   |
> > | 网络层      | 让数据在链路上传送，包括路径选择和转发           |
> > | 传输层      | 确保链路上数据可靠的传输                         |
> > | 会话层      | 建立/管理/终止数据交换之间的会话                 |
> > | 表示层      | 讲传输/收到的数据正确解释和解码                  |
> > | 应用层      | 讲数据塞给对应APP                                |
> 
> ## 7.2. TCP/IP协议
> 
> > :one:与OSI结构的对应
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171823811.png" alt="image-20231231171823811" style="zoom: 67%;" /> 
> >
> > :two:每一层所用的协议
> >
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171854122.png" alt="image-20231231171854122" style="zoom:67%;" /> 
> 
> ## 7.3. 本书采用的混合模型
> 
> > <img src="https://raw.githubusercontent.com/DANNHIROAKI/New-Picture-Bed/main/img/image-20231231171920873.png" alt="image-20231231171920873" style="zoom:67%;" />  

# 8. 其他概念

> :one:网络标准化
>
> | Body | Area               | Examples               |
> | ---- | ------------------ | ---------------------- |
> | ITU  | Telecommunications | G.992/ADSL/H.264/MPEG4 |
> | IEEE | Communications     | Ethernet/802.11/ WiFi  |
> | IETF | Internet           | RFC/HTTP/DNS           |
> | W3C  | Web                | HTML5                  |
>
> :two:==有连接与无连接==
>
> 1. 向连接的服务：传数据前建立连接，传完断开(电话)，==可靠&顺序性好==
> 2. 无连接服务：无需预先建立持续连接(邮件)，==但可靠性&顺序性更差==
>
> :three:分组交换和电路交换
>
> 1. 分组交换：将数据分割成分组，让分组在网络中独立传输
>
> 2. 电路交换：双方之间建立一条固定物理线路，直到结束后才断开连接 



