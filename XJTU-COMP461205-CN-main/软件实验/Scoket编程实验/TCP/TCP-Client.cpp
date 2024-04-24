#include <iostream>
#include <string>
#include <thread>
#include <atomic>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

std::atomic<bool> exit_flag(false);
std::atomic<bool> proof_flag(false);
std::atomic<bool> recv_flag(true);
int client_socket;

void wait_for_exit() 
{
    while (!exit_flag.load()) {}
    close(client_socket);
    exit(0);
}

void CS_Server() 
{
    char buffer[1024];
    while (true) 
    {
        if (exit_flag.load()) return;

        int received = recv(client_socket, buffer, 1024, 0);
        if (received <= 0) continue;

        buffer[received] = '\0'; // 确保字符串以空字符结束
        std::string data(buffer);

        if (proof_flag.load()) 
        {
            std::cout << "服务器: " << data << std::endl;
            recv_flag.store(true);
        } 
        else 
        {
            std::cout << data;
            if (data == "信息正确!\r\n") 
            {
                proof_flag.store(true);
                std::cout << "客户端: ";
            }
        }
    }
}

void CS_Client() 
{
    while (true) 
    {
        std::string data;
        if (proof_flag.load()) 
        {
            while (!recv_flag.load()) {}
            std::cout << "客户端: ";
            std::getline(std::cin, data);
            recv_flag.store(false);
        } 
        else 
        {
            std::getline(std::cin, data);
            recv_flag.store(false);
        }

        send(client_socket, data.c_str(), data.length(), 0);
        if (data == "exit") 
        {
            exit_flag.store(true);
            return;
        }
    }
}

int main() {
    client_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (client_socket < 0) 
    {
        std::cerr << "Socket creation failed." << std::endl;
        return -1;
    }

    sockaddr_in server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(1212);
    inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr); // 使用 localhost

    if (connect(client_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) 
    {
        std::cerr << "Connection failed." << std::endl;
        return -1;
    }

    std::cout << "Connect Succeed!" << std::endl;

    std::thread exit_thread(wait_for_exit);
    std::thread server_thread(CS_Server);
    std::thread client_thread(CS_Client);

    exit_thread.detach();
    server_thread.detach();
    client_thread.join();

    return 0;
}

