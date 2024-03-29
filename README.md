![image](https://user-images.githubusercontent.com/97190263/224708215-48678f24-64c3-4161-bf2b-7b67bb3a6844.png)



## OverView ## 

This script streamlines the process of creating a TCP tunnel to remotely access a local network service. Specifically, the script utilizes the ngrok and netcat utilities to facilitate this process.

Upon execution, the user is prompted to enter a port number, after which the script initializes a netcat listener on that port. The script subsequently establishes an ngrok TCP server on the same port, thereby creating a secure tunnel through which the netcat listener can be accessed from the internet. A trap is implemented to ensure that the ngrok and netcat processes are properly terminated upon receipt of a SIGINT signal.

The script then waits for the ngrok TCP server to commence operation and retrieves the public URL using the ngrok API while also using "dig" to get its ip address.

Lastly, the script waits for a netcat connection to be established, following which the ngrok and netcat processes are terminated. A while loop is employed to periodically verify if a connection has been established, and the script pauses for one second between each iteration.

## Dependencies ##

* xterm / konsole / genome-terminal  [unless you use ncrok.py]
* ngrok
* jq 

can be installed by using requirements.sh
* chmod +x requirements.sh
* bash requirements.sh





## How to use ##

To use this script, you can follow these steps:

Save the script as a file with a ".sh" extension (e.g. "NcRok.sh") [or just download and save NcRok.py].

Make the script executable by running the following command in your terminal: chmod +x NcRok.sh.

Run the script by entering the following command in your terminal: ./NcRok.sh.

When prompted, enter the port number for the local network service that you want to expose to the internet.
Wait for the script to start the netcat listener and ngrok TCP server, and then retrieve the TCP IP port number that you can use to access the listener from the WAN.

Use a client application (e.g. telnet or netcat) to connect to the TCP IP port and access the local network service.

When you are finished, press Ctrl+C to stop the script and terminate the ngrok and netcat processes.

*Note that this script requires the ngrok and jq utilities to be installed on your system. You can install ngrok by visiting the ngrok website (https://ngrok.com) and downloading the appropriate version for your system. You can install jq by running the following command in your terminal: sudo apt-get install jq (for Debian/Ubuntu) or sudo yum install jq (for CentOS/RHEL).*




