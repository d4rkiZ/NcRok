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


## What it does ## 

Got tired of creating a listener and then open a tunnel for it using ngrok / localtunnel etc?
this script will help you save some time.
This script is designed to create a TCP tunnel using ngrok and netcat, which allows a user to remotely access a local network service. it prompts the user to enter a port number and then starts a netcat listener on that port.

Next, the script starts an ngrok TCP server on the same port, which creates a secure tunnel to expose the netcat listener to the internet. it uses a trap to ensure that the ngrok and netcat processes are properly killed when the script receives a SIGINT signal (i.e. when the user presses Ctrl+C).

then it waits for the ngrok TCP server to start and retrieves the public URL using the ngrok API. If the URL starts with "tcp://", the script extracts the TCP IP port and prints a message informing the user how to access the listener from the WAN.

Finally, the script waits for a netcat connection to be established and then kills the ngrok and netcat processes. The script uses a while loop to constantly check whether a connection has been established, and it sleeps for 1 second between each check.



