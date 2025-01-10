#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <winsock2.h>

// 函数声明
int initialize_client_socket();
void connect_to_server(int client_socket, const char* server_ip);
void interact_with_server(int client_socket);

int main() {
    int client_socket = initialize_client_socket();  // 初始化客户端套接字
    connect_to_server(client_socket, "服务器IP地址");  // 连接到指定IP的服务器
    printf("已连接到服务器\n");
    interact_with_server(client_socket);  // 与服务器交互
    close(client_socket);  // 关闭客户端套接字
    return 0;
}

// 初始化客户端套接字
int initialize_client_socket() {
    int sock = socket(AF_INET, SOCK_STREAM, 0);  // 创建套接字
    if (sock == -1) {
        perror("socket");
        exit(1);
    }
    return sock;
}

// 连接到服务器
void connect_to_server(int client_socket, const char* server_ip) {
    struct sockaddr_in server_address;  // 服务器地址结构
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(1145);  // 服务器端口号
    // 将字符串格式的IP地址转换为网络字节序的二进制格式
    if (inet_pton(AF_INET, server_ip, &(server_address.sin_addr)) <= 0) {
        perror("inet_pton");
        exit(1);
    }

    // 连接到服务器
    if (connect(client_socket, (struct sockaddr*)&server_address, sizeof(server_address)) == -1) {
        perror("connect");
        exit(1);
    }
}

// 与服务器交互
void interact_with_server(int client_socket) {
    char word[20];  // 存储用户输入的词汇
    printf("请输入要查询的词汇：");
    scanf("%s", word);  // 获取用户输入

    // 将词汇发送到服务器
    if (send(client_socket, word, strlen(word), 0) == -1) {
        perror("send");
        exit(1);
    }

    char translation[20];  // 存储从服务器接收的翻译
    memset(translation, 0, sizeof(translation));  // 初始化数组

    // 从服务器接收数据
    if (recv(client_socket, translation, sizeof(translation), 0) == -1) {
        perror("recv");
        exit(1);
    }

    printf("翻译结果：%s\n", translation);  // 显示翻译结果
}

