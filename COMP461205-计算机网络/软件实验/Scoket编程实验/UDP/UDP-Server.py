import threading
import socket
import sys
import os

Users = [{'username': 'Admin', 'pwd': 'admin'}]
Client_Message = {}

def wait_for_exit():
    global server_socket
    while True:
        if input("") == 'exit':
            server_socket.close()
            os._exit(0)

def F(x):
    return x*x+2*x+1

def CS_thread(addr):
    global server_socket

    print("Connect Succeed!")
    sys.stdout.flush()
    print("Client Address:", addr)
    sys.stdout.flush()
    server_socket.sendto('欢迎访问1212服务器!\r\n'.encode('utf-8'), addr)
    # proof
    proof_flag = False
    while(True):
        # username
        try:
            server_socket.sendto(str('用户名: ').encode('utf8'), addr)
            while(len(Client_Message[addr]) == 0):
                pass
            username = Client_Message[addr][0].decode('utf8')
            del Client_Message[addr][0]
            print('用户名:', username)
            sys.stdout.flush()
        except:
            print("Disconnect:", addr)
            del Client_Message[addr]
            sys.stdout.flush()
            return
        # pwd
        try:
            server_socket.sendto(str('密码: ').encode('utf8'), addr)
            while(len(Client_Message[addr]) == 0):
                pass
            pwd = Client_Message[addr][0].decode('utf8')
            del Client_Message[addr][0]
            print('密码:', username)
            sys.stdout.flush()
        except:
            print("Disconnect:", addr)
            del Client_Message[addr]
            sys.stdout.flush()
            return
        # proofing
        for user in Users:
            if(user['username'] == username):
                if(user['pwd'] == pwd):
                    proof_flag = True
                    print('Proof Success!')
                    sys.stdout.flush()
                    server_socket.sendto(str('信息正确!\r\n').encode('utf8'), addr)
                    break
                else:
                    break
        # Wrong!
        if proof_flag == False:
            print('Proof Defeated!')
            sys.stdout.flush()
            server_socket.sendto(str('用户名或密码错误,请再次输入!\r\n').encode('utf8'), addr)
        else:
            break

    # Connected!
    while True:
        try:
            while(len(Client_Message[addr]) == 0):
                pass
            asked = Client_Message[addr][0]
            del Client_Message[addr][0]
        except:
            print("Disconnect: ", addr)
            del Client_Message[addr]
            sys.stdout.flush()
            return
        if asked.decode('utf8') == 'exit':
            print("Disconnect: ", addr)
            del Client_Message[addr]
            sys.stdout.flush()
            return
        print('客户端 - ', addr, ':', asked.decode('utf8'))
        sys.stdout.flush()
        try:
            answered = F(float(asked.decode('utf8')))
            print('服务器 - ', addr, ':', answered)
            sys.stdout.flush()
            server_socket.sendto(str(answered).encode('utf8'), addr)
        except:
            answered = "Please check your input!"
            print('服务器 -', addr, ':', answered)
            sys.stdout.flush()
            server_socket.sendto(answered.encode('utf8'), addr)

# main
server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)    
host = socket.gethostname()  
port = 1212
server_socket.bind((host, port))
threading.Thread(target=wait_for_exit).start()

while True:  
    try:
        data, addr = server_socket.recvfrom(1024)
        find_flag = False
        if(addr in Client_Message):
            Client_Message[addr].append(data)
        else:
            Client_Message[addr] = []
            threading.Thread(target=CS_thread, args=(addr, )).start()
    except:
        os._exit(0)
    