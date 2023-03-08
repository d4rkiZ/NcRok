#!/bin/bash

# Function to kill ngrok process and netcat listener
function kill_ngrok {
    pkill ngrok
    if pgrep -x nc > /dev/null; then
        pkill nc
    fi
}

# Get user input for port number
echo -e "\e[1mEnter port number:\e[0m"
read port

# Start netcat listener on specified port
echo -e "\e[1mStarting netcat listener on port \e[32m$port\e[0m"
xterm -e "nc -lvp $port" &

# Create ngrok TCP server on the same port
echo -e "\e[1mStarting ngrok TCP server on port \e[32m$port\e[0m"
ngrok tcp $port --log=stdout >/dev/null & disown

# Set trap to kill ngrok and netcat processes when script receives SIGINT signal
trap kill_ngrok SIGINT

# Wait for ngrok to start and get the TCP IP port
while true; do
    ngrok_url=$(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    if [[ $ngrok_url == *"tcp://"* ]]; then
        tcp_port=${ngrok_url#*tcp://}
        echo -e "\e[1mAccess the listener from the WAN using TCP IP port: \e[32m$tcp_port\e[0m"
        break
    fi
    sleep 1
done

# Wait for netcat connection to be established and then kill ngrok and netcat processes
while true; do
    if netstat -ant | grep -q $port && ! pgrep -x nc > /dev/null; then
        pkill ngrok
        exit 0
    fi
    sleep 1
done

