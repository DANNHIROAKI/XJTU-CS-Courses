//sudo apt --fix-broken install
//sudo apt-get install libstdc++6

//g++ -o UDP-Server UDP-Server.cpp -lpthread -static-libstdc++

#include <iostream>
#include <string>
#include <thread>
#include <vector>
#include <map>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <cstring>


/*
** 1. 定义用户结构体，存储用户消息(用户名+密码)
** 2. 定义User类型的向量，用于存储一系列的用户，并且初始化一个用户名DHY密码dhy的用户
** 3. 定义Client_Message，以一整型为关键字，存贮与特定客户端有关的消息
*/
struct User 
{
    std::string username;
    std::string pwd;
};
std::vector<User> Users = {{"DHY", "dhy"}};
std::map<int, std::vector<std::string>> Client_Message;

/*
** 定义服务器套接字+服务器地址和客户端地址
*/
int server_socket;
sockaddr_in server_addr, client_addr;

/*
** 等待退出命令的函数
** 功能：等待用户在命令行输入exit，然后退出
*/
void wait_for_exit() 
{
    std::string input;
    while (true) {
        std::cin >> input;
        if (input == "exit") 
        {
            close(server_socket);
            exit(0);
        }
    }
}

/*
** 在服务器端完成一个简单的数学运算然后传回客户端
** 客户端传来x时，服务器就返回给客户端x * x + 2 * x + 1
*/
float F(float x) 
{
    return x * x + 2 * x + 1;
}


/*
** 处理客户端请求的线程函数
*/
void CS_thread(sockaddr_in client_addr) 
{
    /*
    ** 1. 声明一个长1024的数组buffer，用于缓存从客户端接收的数据
    ** 2. 定义len变量，并初始化为客户端地址长，当作收发数据的地址结构长
    ** 3. 定于proof_flag用于判断用户是否通过了身份验证
    */ 
    char buffer[1024];
    socklen_t len = sizeof(client_addr);
    bool proof_flag = false;

    /* 当连接成功后
    ** 1. 向服务器的控制台打印连接成功的提示信息
    ** 2. 打印出连接的客户端的IP地址，inet_ntoa将二进制IP转化为十进制
    ** 3. 用sendto在客户端终端打印出欢迎信息
    */
    std::cout << "Connect Succeed!" << std::endl;
    std::cout << "Client Address: " << inet_ntoa(client_addr.sin_addr) << std::endl;
    sendto(server_socket, "欢迎访问1212服务器!\r\n", strlen("欢迎访问1212服务器!\r\n"), 0, (struct sockaddr *)&client_addr, len);

    /* 
    ** 负责处理客户端的身份验证
    ** 通过一个无限循环来实现这个过程
    */
    while (true) 
    {
        /* 这一段是为了接收用户名
        ** 1. 通过sendto函数，服务器向客户端发送一个提示，要求输入用户名
        ** 2. 使用recvfrom函数接收客户端用户输入(发来)的用户名，并将用户名放在buffer中
        ** 3. 在服务器端的控制台中，打印出从客户端发来的用户名
        */
        sendto(server_socket, "用户名: ", strlen("用户名: "), 0, (struct sockaddr *)&client_addr, len);
        recvfrom(server_socket, buffer, 1024, 0, (struct sockaddr *)&client_addr, &len);
        std::string username(buffer);
        std::cout << "用户名: " << username << std::endl;

        /*这一段是为了接收用户在客户端输入的密码
        ** 1. 服务器再次使用sendto函数向客户端发送一个提示，要求输入密码
        ** 2. 使用recvfrom函数来接收客户端发送的密码，密码也被存储在buffer数组中
        ** 3. 在服务器端的控制台中，打印出从客户端输入并且发来的密码
        */
        sendto(server_socket, "密码: ", strlen("密码: "), 0, (struct sockaddr *)&client_addr, len);
        recvfrom(server_socket, buffer, 1024, 0, (struct sockaddr *)&client_addr, &len);
        std::string pwd(buffer);
        std::cout << "密码: " << pwd << std::endl;

        /*这一段是为了身份验证
        ** 1. 循环遍历服务器维护的用户数据库向量User，这个向量中存储了有效的用户名和密码组合
        ** 2. 检查客户端所提供的用户名和密码，是否和某个表项相符
        ** 3. 如果找到相符的，则更改proof_flag，在服务器端输出验证成功消息，然后通过sendto向客户端发送确认
        */
        for (const auto& user : Users) 
        {
            if (user.username == username && user.pwd == pwd) 
            {
                proof_flag = true;
                std::cout << "Proof Success!" << std::endl;
                sendto(server_socket, "信息正确!\r\n", strlen("信息正确!\r\n"), 0, (struct sockaddr *)&client_addr, len);
                break;
            }
        }

        /*身份验证有误时
        ** 1. 遍历所有表项后都没找到的话，说明输入账号密码有误
        ** 2. 先在服务器端输出错误提示
        ** 3. 通过sendto函数向客户端发送错误提示，要求重新输入用户名和密码
        */
        if (!proof_flag) 
        {
            std::cout << "Proof Defeated!" << std::endl;
            sendto(server_socket, "用户名或密码错误,请再次输入!\r\n", strlen("用户名或密码错误,请再次输入!\r\n"), 0, (struct sockaddr *)&client_addr, len);
        } 
        else 
        {
            break;
        }
    }

    /* 
    ** 登陆完成后，C-S就可进行交互了
    ** 以下程序负责处理从客户端接收到的请求
    ** 通过一个无限循环，用于不断接收和处理来自客户端的请求
    */
    while (true) 
    {
        /*
        ** 1. 在接收客户端发来的数据之钱，用memset函数清空缓存buffer，保证每次接收新数据时缓冲区都是干净的
        ** 2. 使用recvfrom函数接收客户端发送的数据，接收到的数据存储在buffer中
        ** 3. 将缓存在buffer中的数据，转化为std::string类型字符asked
        */
        memset(buffer, 0, sizeof(buffer));
        recvfrom(server_socket, buffer, 1024, 0, (struct sockaddr *)&client_addr, &len);
        std::string asked(buffer);
        
        /*客户端请求断开连接
        ** 1. 检查asked是否为exit
        ** 2. 如果是，则在服务器控制台打印客户端断开连接的消息
        ** 3. 然后用return退出函数，即断开与客户端的连接
        */
        if (asked == "exit") 
        {
            std::cout << "Disconnect: " << inet_ntoa(client_addr.sin_addr) << std::endl;
            return;
        }

        /*
        ** 不断开连接的情况下，页打印客户端的IP和客户端发送的数据
        */
        std::cout << "客户端 - " << inet_ntoa(client_addr.sin_addr) << ": " << asked << std::endl;


        /*try-catch是异常处理结构，用于处理可能在执行代码时发生的错误
        ** 1. try模块在正常运行时总是被执行
        ** 2. catch模块在try块内的代码抛出异常时执行
        ** 3. 在此处，这个所谓的异常是指，asked包含非数字字符，从而转化为浮点数失败
        */
        try 
        {
            /*
            ** 1. 将客户端发送的字符串asked转为浮点数，通过F计算后结果存储在answer中
            ** 2. 打印answer计算结果，显示是来自于哪个客户端的请求
            ** 3. 将answer计算结果转为字符串
            ** 4. 将得到的字符串送回客户端
            */
            float answer = F(std::stof(asked));
            std::cout << "服务器 - " << inet_ntoa(client_addr.sin_addr) << ": " << answer << std::endl;
            std::string response = std::to_string(answer);
            sendto(server_socket, response.c_str(), response.length(), 0, (struct sockaddr *)&client_addr, len);
        } 
        catch (const std::exception& e) 
        {
            /*
            ** 1. 先设置打印/响应错误输入的消息
            ** 2. 打印输错误消息，以及客户端的IP等信息
            ** 3. 通过sendto函数将错误消息返回给客户端
            */
            std::string response = "Please check your input!";
            std::cout << "服务器 - " << inet_ntoa(client_addr.sin_addr) << ": " << response << std::endl;
            sendto(server_socket, response.c_str(), response.length(), 0, (struct sockaddr *)&client_addr, len);
        }
    }
}


int main() 
{
    /*创建套接字
    ** 1. 创建一个UDP套接字，AF_INET表示使用IPv4，SOCK_DGRAM指定套接字类型为数据报，即无连接的UDP
    ** 2. 检查套接字是否创建成功，失败的话就返回失败信息
    */
    server_socket = socket(AF_INET, SOCK_DGRAM, 0);
    if (server_socket < 0) 
    {
        std::cerr << "Socket creation failed." << std::endl;
        return -1;
    }

    /*设置服务器地址
    ** 1. 设置地址族为 IPv4
    ** 2. 指定服务器套接字绑定到所有可用的接口上，htonl和INADDR_ANY确保地址格式正确
    ** 3. 设置服务器端口为 1212，htons确保端口号格式正确
    */
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_port = htons(1212);

    /*绑定套接字到地址
    ** 1. 将之前创建的套接字绑定到指定的地址(IP和端口)
    ** 2. 如果绑定失败，则打印错误信息并返回-1，绑定失败基本就是因为端口号已经被占用了
    ** 3. 用buffer来缓存收到的客户端的数据
    */
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) 
    {
        std::cerr << "Bind failed." << std::endl;
        return -1;
    }
    char buffer[1024];
    /*当总是因为端口号被占用而返回失败时的解决方案
    ** 1. 用sudo netstat -tulnp | grep 1212命令查找占用1212端口的进程PID
    ** 2. 暴力杀掉这个进程，sudo kill -9 <进程PID>
    */
    
    /*启动一个新线程(对象exitThread)来处理退出命令
    ** 1. 在新线程中运行wait_for_exit，后者监控输入，以便在特定输入(exit)时关闭服务器
    ** 2. 将新创建线程从对象中分离，转而在后台运行
    */
    std::thread exitThread(wait_for_exit);
    exitThread.detach();


    /*
    ** 持续监听和处理来自客户端的数据
    */
    while (true) 
    {
       /*
       ** 1. 始化一个变量len来存储客户端地址结构的大小
       ** 2. 使用recvfrom函数从套接字server_socket接收数据
       **    接收到的数据被存储在buffer数组中，最多可接收1024字节
       */
       socklen_t len = sizeof(client_addr);
       int received = recvfrom(server_socket, buffer, 1024, 0, (struct sockaddr *)&client_addr, &len);

        /*
        **如果有接收到数据，则做如下处理
        */
        if (received > 0) 
        {
            //不论如何都将收到的数据以空字符结尾，以形成有效的字符串
            buffer[received] = '\0';

            /*
            ** 1. 定义it变量，用于检查客户端是否已连接
            ** 2. 如果找到了客户端的地址(即客户端已经连接过)
            **    则将缓存在buffer中的已收到消息添加到客户端的消息列表中
            */
            auto it = Client_Message.find(client_addr.sin_addr.s_addr);
            if (it != Client_Message.end()) 
            {
                it->second.push_back(std::string(buffer));
            } 

            /*
            ** 1. 若客户端是新连接的，则在新客户端的Client_Message中创建一个新消息列表
            ** 2. 为新的客户端创建一个线程，该线程调用CS_thread，负责处理与客户端的进一步通信与交互
            ** 3. 最后将新线程从对象中分离，使之可以独立运行
            */
            else 
            {
                Client_Message[client_addr.sin_addr.s_addr] = std::vector<std::string>(1, std::string(buffer));
                std::thread clientThread(CS_thread, client_addr);  // 定义并启动客户端线程
                clientThread.detach();
            }
        } 

        /*
        **如果有接收到数据或者数据有错误，则返回错误信息
        */
        else 
        {
            std::cerr << "Error in receiving data." << std::endl;
        }
    }

    return 0;
}
