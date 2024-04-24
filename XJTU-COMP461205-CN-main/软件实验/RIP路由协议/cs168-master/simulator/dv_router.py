import sim.api as api
from cs168.dv import RoutePacket, \
                     Table, TableEntry, \
                     DVRouterBase, Ports, \
                     FOREVER, INFINITY


class DVRouter(DVRouterBase):

    ROUTE_TTL = 15
    GARBAGE_TTL = 10
    SPLIT_HORIZON = False
    POISON_REVERSE = False
    POISON_EXPIRED = True
    SEND_ON_LINK_UP = False
    POISON_ON_LINK_DOWN = False

    def __init__(self):
        assert not (self.SPLIT_HORIZON and self.POISON_REVERSE), \
                    "Split horizon and poison reverse can't both be on"

        self.start_timer() 
        self.ports = Ports()
        self.table = Table()
        self.table.owner = self

    #阶段1
    #接收两参数，host为主机标识符，port为连接到主机的端口
    def add_static_route(self, host, port):
        #确保传入的 port 是一个当前激活的端口
        assert port in self.ports.get_all_ports(), "Link should be up, but is not."

        #在路由器的路由表self.table中，为指定的host添加一个新的表项(TableEntry)
        #包含以下内容
        #  1.目的地dst设置为传入的host
        #  2.指定要使用的端口为传入端口
        #  3.self.ports.get_latency(port)会返回连接到指定端口的延迟值
        #  4.设置这条路由的过期时间为永久
        self.table[host] = TableEntry(dst=host, port=port, latency=self.ports.get_latency(port), expire_time=FOREVER)

    #阶段2
    #接收两参数，packet(接收到的数据包)和in_port(数据包进入的端口)
    def handle_data_packet(self, packet, in_port):
        #self.table.get(packet.dst)用于获取与 packet.dst相关联的路由表条目
        #packet.dst不在self.table中，get方法将返回None
        export = self.table.get(packet.dst)

        #要求条目在路由表种存在，并且延迟小于INFINITY
        #当满足两个条件时，才不会丢弃数据包
        if not export or export.latency >= INFINITY: return

        #两个条件都满足时，用self.send(packet, export.port)进行数据包转发
        self.send(packet, export.port)



    #阶段3
    #single_port指定是否只向一个特定的端口发送路由信息
    def send_routes(self, force=False, single_port=None):
        #决定路由信息应该发送到哪些端口
        #如果single_port被指定，路由信息将只发送到这个端口
        #否则，路由信息将发送到路由器上的所有端口
        if single_port:
            ports_to_send = [single_port]
        else:
            ports_to_send = self.ports.get_all_ports()
    
       #循环遍历所有需要发送路由信息的端口
        for port in ports_to_send:
            #遍历路由表中的每个条目。host 是目的地地址，entry是关联的路由表条目
            for host, entry in self.table.items():
                #应用两种路由优化：毒性逆转和分割视界
                #如果启用了毒性逆转且条目的端口与当前端口相同，则将延迟设置为无限大以防止路由循环
                #如果启用了分割视界且条目的端口与当前端口相同，则跳过此条目(不向来源端口广播)
                #否则，使用条目中的原始延迟值
                if self.POISON_REVERSE and entry.port == port:
                    latency_now = INFINITY
                elif self.SPLIT_HORIZON and port == entry.port:
                    continue
                else:
                    latency_now = entry.latency
    
                # 发送路由，构造一个路由包，包含目的地dst，延迟值latency_now，并通过指定的端口发送
                self.send_route(port=port, dst=host, latency=latency_now)

        #更新了self.last_table，将其设置为当前路由表的副本
        self.last_table = self.table.copy()

    #阶段4
    #当接收到邻居传来的路由广播后，用此方法更新路由器的路由表
    #更新方法为：选择当前路由和新路由中较好的一个，如果两条路由性能相等则优先选择新路由
    #接收三个参数：目标路由route_dst，到达该目标路由的延迟route_latency，接收广告的端口port
    def handle_route_advertisement(self, route_dst, route_latency, port):
        #首先考虑延时无穷大(路由不可达)的情况
        if route_latency == INFINITY: 
            #检查当前路由表的表项，如果目标路由已存在于路由表中，并且端口与收到广播的相同
            if route_dst in self.table and self.table[route_dst].port == port:
                entry = self.table[route_dst]
                #如果路由表中的该条目的延迟小于无穷大，说明之前这条路由是有效的，现在才变得不可达
                #因此，设置该路由的新过期时间为当前时间加上路由存活时间
                if (entry.latency < INFINITY): 
                    expire_time_now=self.ROUTE_TTL + api.current_time()
                #否则的话，说明该条目的延迟已经是无穷大，则维持原有的过期时间
                else:
                    expire_time_now=entry.expire_time

                # 更新路由表，设置目的地为不可达(延迟为无穷大)并更新过期时间
                self.table[route_dst] = TableEntry(
                    dst = route_dst, 
                    port=port, 
                    latency=INFINITY,
                    expire_time=expire_time_now
                    )
                
        #当收到的路由延迟不是无穷大时，计算新路由的总延迟       
        else:
            #新延时包括接收到的路由延迟和当前端口的延迟
            #计算新路由的过期时间，为当前时间加上路由的存活时间
            new_latency = route_latency + self.ports.get_latency(port)
            new_expire_time = api.current_time()+self.ROUTE_TTL

            #创建一个新的路由表条目，包含目的地、端口、新计算的延迟和过期时间
            new_table = TableEntry(
                dst=route_dst, 
                port=port,
                latency=new_latency, 
                expire_time=new_expire_time
                )
            
            #如果路由表中不存在这个目的地的路由，直接在路由表中添加这个新路由
            if not self.table.get(route_dst): 
                self.table[route_dst] = new_table

            #如果路由表中已经有这个目的地的路由，获取当前的路由条目
            else: 
                entry = self.table[route_dst]
                #如果新路由是通过相同的端口接收或新路由的延迟更低
                #则用新路由更新路由表中的这个目的地的路由
                if new_table.port==entry.port or new_table.latency<entry.latency:
                    self.table[route_dst] = new_table

    #阶段4       
    def expire_routes(self):
        #创建一个新的空路由表用于更新
        renew_table = Table()
        # 获取当前时间
        current_time = api.current_time()

        #遍历当前路由表中的所有条目
        for host,entry in self.table.items():

            #检查每个条目的过期时间是否仍然大于当前时间
            #如果该条目未过期，则将其添加到新的路由表中
            if entry.expire_time > current_time:
                renew_table[host] = entry

            #如果启用了过期路由的“中毒逆转”，并且条目的延迟不是无穷大
            #为这个过期路由设置一个新的过期时间
            #然后在新路由表中添加一个更新后的条目，将延迟设置为无穷大
            #表示路由现在不可用
            elif self.POISON_EXPIRED and entry.latency < INFINITY:
                new_expire_time = current_time + self.ROUTE_TTL
                renew_table[host] =TableEntry(
                    dst=entry.dst, 
                    port=entry.port, 
                    latency=INFINITY,
                    expire_time=new_expire_time)
                
        #使用新的路由表替换旧的路由表
        self.table = renew_table


    def handle_link_up(self, port, latency):
        self.ports.add_port(port, latency)

    def handle_link_down(self, port):
        self.ports.remove_port(port)
