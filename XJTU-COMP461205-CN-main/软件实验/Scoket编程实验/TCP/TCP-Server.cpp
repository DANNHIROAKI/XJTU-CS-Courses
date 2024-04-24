#include <iostream>
#include <string>
#include <thread>
#include <vector>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

struct User 
{
    std::string username;
    std::string pwd;
};

std::vector<User> Users = {{"DHY", "dhy"}};
int server_socket;

void wait_for_exit() 
{
    std::string input;
    while (true) 
    {
        std::cin >> input;
        if (input == "exit") 
        {
            close(server_socket);
            exit(0);
        }
    }
}

float F(float x) 
{
    return x * x + 2 * x + 1;
}

void CS_thread(int client_socket, sockaddr_in addr) 
{
    char buffer[1024];
    bool proof_flag = false;
    std::cout << "Connect Succeed!" << std::endl;
    std::cout << "Client Address: " << inet_ntoa(addr.sin_addr) << std::endl;

    send(client_socket, "欢迎访问1212服务器!\r\n", strlen("欢迎访问1212服务器!\r\n"), 0);

    while (!proof_flag) 
    {
        // Username
        send(client_socket, "用户名: ", strlen("用户名: "), 0);
        int received = recv(client_socket, buffer, 1024, 0);
        buffer[received] = '\0';
        std::string username(buffer);
        std::cout << "用户名: " << username << std::endl;

        // Password
        send(client_socket, "密码: ", strlen("密码: "), 0);
        received = recv(client_socket, buffer, 1024, 0);
        buffer[received] = '\0';
        std::string pwd(buffer);
        std::cout << "密码: " << pwd << std::endl;

        // Authentication
        for (const auto& user : Users) 
        {
            if (user.username == username && user.pwd == pwd) 
            {
                proof_flag = true;
                std::cout << "Proof Success!" << std::endl;
                send(client_socket, "信息正确!\r\n", strlen("信息正确!\r\n"), 0);
                break;
            }
        }

        if (!proof_flag) 
        {
            std::cout << "Proof Defeated!" << std::endl;
            send(client_socket, "用户名或密码错误,请再次输入!\r\n", strlen("用户名或密码错误,请再次输入!\r\n"), 0);
        }
    }

    // Connected
    while (true) 
    {
        int received = recv(client_socket, buffer, 1024, 0);
        if (received <= 0) 
        {
            std::cout << "Disconnect: " << inet_ntoa(addr.sin_addr) << std::endl;
            close(client_socket);
            return;
        }

        buffer[received] = '\0';
        std::string asked(buffer);
        std::cout << "客户端 - " << inet_ntoa(addr.sin_addr) << ": " << asked << std::endl;

        try 
        {
            float answered = F(std::stof(asked));
            std::cout << "服务器 - " << inet_ntoa(addr.sin_addr) << ": " << answered << std::endl;
            std::string response = std::to_string(answered);
            send(client_socket, response.c_str(), response.length(), 0);
        } catch (const std::exception& e) 
        {
            std::string response = "Please check your input!";
            std::cout << "服务器 - " << inet_ntoa(addr.sin_addr) << ": " << response << std::endl;
            send(client_socket, response.c_str(), response.length(), 0);
        }
    }
}

int main() 
{
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket < 0) 
    {
        std::cerr << "Socket creation failed." << std::endl;
        return -1;
    }

    sockaddr_in server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_port = htons(1212);

    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) 
    {
        std::cerr << "Bind failed." << std::endl;
        return -1;
    }

    listen(server_socket, 5);
    std::thread exitThread(wait_for_exit);
    exitThread.detach();

    while (true) 
    {
        sockaddr_in client_addr;
        socklen_t len = sizeof(client_addr);
        int client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &len);
        if (client_socket < 0) 
        {
            continue;
        }
        std::thread(CS_thread, client_socket, client_addr).detach();
    }

    return 0;
}

    