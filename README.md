## OverView ## 

This script streamlines the process of creating a TCP tunnel to remotely access a local network service. Specifically, the script utilizes the ngrok and netcat utilities to facilitate this process.

Upon execution, the user is prompted to enter a port number, after which the script initializes a netcat listener on that port. The script subsequently establishes an ngrok TCP server on the same port, thereby creating a secure tunnel through which the netcat listener can be accessed from the internet. A trap is implemented to ensure that the ngrok and netcat processes are properly terminated upon receipt of a SIGINT signal.

The script then waits for the ngrok TCP server to commence operation and retrieves the public URL using the ngrok API. If the URL commences with "tcp://", the script extracts the TCP IP port and conveys to the user how they can access the listener from the WAN.

Lastly, the script waits for a netcat connection to be established, following which the ngrok and netcat processes are terminated. A while loop is employed to periodically verify if a connection has been established, and the script pauses for one second between each iteration.

![image](https://user-images.githubusercontent.com/97190263/223876790-476587dd-5896-4b0d-b0a5-e5c0920a53f3.png)




## How to use ##

To use this script, you can follow these steps:

Save the script as a file with a ".sh" extension (e.g. "ngrok-netcat-tcp.sh").

Make the script executable by running the following command in your terminal: chmod +x ngrok-netcat-tcp.sh.

Run the script by entering the following command in your terminal: ./ngrok-netcat-tcp.sh.

When prompted, enter the port number for the local network service that you want to expose to the internet.
Wait for the script to start the netcat listener and ngrok TCP server, and then retrieve the TCP IP port number that you can use to access the listener from the WAN.

Use a client application (e.g. telnet or netcat) to connect to the TCP IP port and access the local network service.

When you are finished, press Ctrl+C to stop the script and terminate the ngrok and netcat processes.

*Note that this script requires the ngrok and jq utilities to be installed on your system. You can install ngrok by visiting the ngrok website (https://ngrok.com) and downloading the appropriate version for your system. You can install jq by running the following command in your terminal: sudo apt-get install jq (for Debian/Ubuntu) or sudo yum install jq (for CentOS/RHEL).*




