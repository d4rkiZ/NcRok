#!/bin/bash

echo '[@] installing "jq" [@]'
apt install jq -y

echo '[@] installing "xterm" [@]'
apt install xterm -y
sleep 1.5

echo '[@] installing "konsole" [@]'
apt install konsole -y
sleep 1

echo '[@] installing "gnome-terminal" [@]'
apt install xterm -y
sleep 1.5

echo '[@] installing "ngrok" [@]'
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok

echo '[@] DONE, happy hacking[@]'








