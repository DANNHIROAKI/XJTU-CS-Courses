import threading
import socket
import sys
import os

Users = [{'username': 'Admin', 'pwd': 'admin'}]

def wait_for_exit():
    global server_socket
    while True:
        if input("") == 'exit':
            server_socket.close()
            os._exit(0)

def F(x):
    return x*x+2*x+1

def CS_thread(sock, addr):
    print("Connect Succeed!")
    sys.stdout.flush()
    print("Client Address:", addr)
    sys.stdout.flush()
    sock.send('欢迎访问1212服务器!\r\n'.encode('utf-8'))
    # proof
    proof_flag = False
    while(True):
        # username
        try:
            sock.send(str('用户名: ').encode('utf8'))
            username = sock.recv(1024)
            username = username.decode('utf8')
            print('用户名:', username)
            sys.stdout.flush()
        except:
            print("Disconnect:", addr)
            sys.stdout.flush()
            sock.close()
            return
        # pwd
        try:
            sock.send(str('密码: ').encode('utf8'))
            pwd = sock.recv(1024)
            pwd = pwd.decode('utf8')
            print('密码:', pwd)
            sys.stdout.flush()
        except:
            print("Disconnect:", addr)
            sys.stdout.flush()
            sock.close()
            return
        # proofing
        for user in Users:
            if(user['username'] == username):
                if(user['pwd'] == pwd):
                    proof_flag = True
                    print('Proof Success!')
                    sys.stdout.flush()
                    sock.send(str('信息正确!\r\n').encode('utf8'))
                    break
                else:
                    break
        # Wrong!
        if proof_flag == False:
            print('Proof Defeated!')
            sys.stdout.flush()
            sock.send(str('用户名或密码错误,请再次输入!\r\n').encode('utf8'))
        else:
            break

    # Connected!
    while True:
        try:
            asked = sock.recv(1024)
        except:
            sock.close()
            print("Disconnect: ", addr)
            sys.stdout.flush()
            return
        if asked.decode('utf8') == 'exit':
            sock.close()
            print("Disconnect: ", addr)
            sys.stdout.flush()
            return
        print('客户端 - ', addr, ':', asked.decode('utf8'))
        sys.stdout.flush()
        try:
            answered = F(float(asked.decode('utf8')))
            print('服务器 - ', addr, ':', answered)
            sys.stdout.flush()
            sock.send(str(answered).encode('utf8'))
        except:
            answered = "Please check your input!"
            print('服务器 -', addr, ':', answered)
            sys.stdout.flush()
            sock.send(answered.encode('utf8'))

# main
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
host = socket.gethostname()
port = 1212
server_socket.bind((host, port))
threading.Thread(target=wait_for_exit).start()

server_socket.listen(5)
  
while True:
    try:
        client_socket, addr = server_socket.accept()
    except:
        os._exit(0)
    threading.Thread(target=CS_thread, args=(client_socket, addr)).start()    
    