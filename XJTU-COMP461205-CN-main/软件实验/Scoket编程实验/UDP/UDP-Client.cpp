//g++ -o UDP-Client UDP-Client.cpp -lpthread -static-libstdc++

#include <iostream>
#include <string>
#include <thread>
#include <atomic>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <cstring>

/*定义三个atomic布尔变量，用于控制程序的不同状态
** 2. exit_flag用于指示程序何时退出
** 3. proof_flag用于指示用户是否通过了身份验证
** 4. recv_flag用于控制接收和发送数据的同步
*/
std::atomic<bool> exit_flag(false);
std::atomic<bool> proof_flag(false);
std::atomic<bool> recv_flag(true);

/*
** 等待退出命令的函数
** 不断检查exit_flag的状态，当exit_flag被设置为true时，关闭套接字并退出程序
*/
void wait_for_exit(int sock) 
{
    while (!exit_flag.load()) {}
    close(sock);
    exit(0);
}

/*
** 接收来自服务器的数据
** 无限循环中执行，不断检查是否接收到从服务器发送的数据
*/
void CS_Server(int sock, sockaddr_in addr) 
{
    /*
    ** 1. 用buffer作接收数据的缓冲区
    ** 2. 定义一个socklen_t类型的变量len，用于存储地址结构的长度，这对于recvfrom函数来说是必须的
    */
    char buffer[1024];
    socklen_t len = sizeof(addr);

    /*
    **不断检查和接收从服务器发送过来的数据
    */
    while (true) 
    {
        /*
        ** 1. 检查退出标志exit_flag的状态。
        **    - 如果exit_flag为true，表示程序应当终止，这时候函数会返回，停止接收数据
        ** 2. 使用recvfrom函数从套接字sock接收数据。
        **    - buffer数组用于存储接收到的数据。
        **    - 1024定义了buffer的最大长度，即最多可以接收1024字节的数据。
        **    - (struct sockaddr *)&addr和&len提供了关于发送端(服务器)地址的信息。
        **    - recvfrom函数返回接收到的字节数，如果没有接收到数据则返回0。
        **    - 收到的数据被存储在buffer数组中。
        */
        if (exit_flag.load()) return;
        int received = recvfrom(sock, buffer, 1024, 0, (struct sockaddr *)&addr, &len);

        if (received > 0) 
        {
            
            /*
            ** 1. 确保接收到的数据以空字符结束，形成一个有效的C字符串。
            ** 2. 将接收到的数据转换为std::string类型，便于后续处理
            */   
            buffer[received] = '\0'; 
            std::string data(buffer);

            /*
            ** 1. 如果身份验证已经通过（proof_flag为true），
            **    则在控制台输出从服务器接收到的数据，并用"服务器:"标签指示这些数据来自服务器
            **    然后设置接收标志为true，表示客户端已准备好发送下一条数据
            ** 2. 如果身份验证还未通过，直接输出接收到的数据
            ** 3. 当接收到特定消息（"信息正确!\r\n"）时，
            **    表明身份验证成功，设置proof_flag为true。
            **    然后在控制台提示"客户端:"，表示现在可以从客户端发送数据。
            */
            if (proof_flag.load()) 
            {
                std::cout << "服务器: " << data << std::endl;
                recv_flag.store(true);
            } 
            else 
            {
                std::cout << data;
            }
            if (data == "信息正确!\r\n") 
            {
                proof_flag.store(true);
                std::cout << "客户端: ";
            }
        }
    }
}


/*
** 持续在一个循环中运行，用于发送数据到服务器
*/
void CS_Client(int sock, sockaddr_in addr) 
{
    //在无限循环中运行，持续监听用户输入并发送到服务器
    while (true) 
    {
        /*
        ** 1. 检查退出标志exit_flag，如果为true，则终止函数
        ** 2. 不退出的话，就创建一个可以存储和处理用户输入的字符串变量data
        */
        if (exit_flag.load()) return;
        std::string data;

        /*
        ** 1. 检查身份验证标志proof_flag。
        **    - 如果已验证(proof_flag为true)，则等待接收标志recv_flag为true。
        ** 2. 循环等待，直到recv_flag变为true
        **    - 表示客户端已经准备好接收用户的下一个输入
        ** 3. 打印提示信息，获取一行用户文本，将输入存储到字符串data中
        ** 4. 将recv_flag设置为false，表示当前的用户输入已经获取，并准备发送到服务器
        */
        if (proof_flag.load()) 
        {
            while (!recv_flag.load()) {}
            std::cout << "客户端: ";
            std::getline(std::cin, data);
            recv_flag.store(false);
        } 

        /*
        ** 1. 如果用户还未通过身份验证(proof_flag为false)
        ** 2. 也获取用户输入的数据，然后准备发往服务器
        */
        else 
        {
            std::getline(std::cin, data);
            recv_flag.store(false);
        }

        /*使用sendto函数将用户输入的数据发送到服务器
        **  - data.c_str()获取字符串的C风格表示，适用于sendto函数
        **  - data.length()提供要发送的数据长度
        **  - (struct sockaddr *)&addr和sizeof(addr)提供服务器的地址信息
        */
        sendto(sock, data.c_str(), data.length(), 0, (struct sockaddr *)&addr, sizeof(addr));

        /*检查用户是否输入了"exit"命令，以决定是否退出程序
        **  - 如果输入了"exit"，则设置退出标志exit_flag为true
        **  - 然后退出函数，进而终止客户端程序
        */
        if (data == "exit") 
        {
            exit_flag.store(true);
            return;
        }
    }
}

int main() {
    /*
    ** 1. 创建UDP套接字。
    **    - AF_INET指定IPv4协议
    **    - SOCK_DGRAM指定数据报套接字(UDP)
    **    - 如果创建套接字失败(返回值小于0)，则输出错误信息并退出程序
    */
    int client_socket = socket(AF_INET, SOCK_DGRAM, 0);
    if (client_socket < 0) {
        std::cerr << "Socket creation failed." << std::endl;
        return -1;
    }

    /*
    ** 2. 设置服务器地址。
    **    - sin_family设置为AF_INET，指定IPv4地址
    **    - sin_port设置服务器端口号，htons(1212)将主机字节顺序转换为网络字节顺序
    **    - inet_pton转换IP地址为网络字节顺序，这里使用的是本地地址(127.0.0.1)
    */
    sockaddr_in server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(1212);
    inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr); // 使用 localhost

    /*
    ** 3. 向服务器发送初始消息"Hello!"。
    **    - sendto用于发送数据到指定的地址
    */
    sendto(client_socket, "Hello!", strlen("Hello!"), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
    std::cout << "Connect Succeed!" << std::endl;

    /*
    ** 4. 启动三个线程处理不同的任务：
    **    - exit_thread负责监听退出命令
    **    - server_thread负责处理来自服务器的消息
    **    - client_thread负责处理客户端用户的输入
    */
    std::thread exit_thread(wait_for_exit, client_socket);
    std::thread server_thread(CS_Server, client_socket, server_addr);
    std::thread client_thread(CS_Client, client_socket, server_addr);

    /*
    ** 5. join这三个线程，等待它们的完成
    **    - 这保证了主函数会等待所有线程完成它们的任务
    */
    exit_thread.join();
    server_thread.join();
    client_thread.join();

    return 0;
}
