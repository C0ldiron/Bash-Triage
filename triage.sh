###############
#Triage Script#
#Kelvin Ashton#
###############

#!/bin/sh

#Variables are all made from the outputs of commands for later use.
#The grep command is used to filter out specific text strings.
#The awk command is used to pull only specific pieces from a line of text to be saved as a variable.

os="$(uname -or)" #Finds the Operating System.
ver="$(uname -v)" #Finds the Version of the Operating System.
sysname="$(hostname -f)" #Finds the name of the system currently in use.
ram="$(grep MemTotal /proc/meminfo | awk '{print $2}')" #Finds RAM info in the system and prints only the total amount of RAM.
cpu="$(grep 'cpu' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')" #Finds and cuts out specific CPU usage.
totalstg="$(df -H --total | grep total | awk '{print $2}')" #Finds storage info and pulls out specifically the total amount of RAM.
availstg="$(df -H --total | grep total | awk '{print $4}')" #Does the same as the previous line but finds available storage amount.
ip="$(ip route get 8.8.8.8 | awk '{print $NF; exit}')" #Sends a ping and traces it to find the IP address of the machine in use.
network="$(ip route get 8.8.8.8 | awk '{print $5; exit}')" #Sends a ping to find what network interface is being used as the main.
ipv6="$(ifconfig ${network} | grep "inet6" | awk '{print $2; exit}')" #Ifconfigs the interface and grabs the IPv6 address.
subnet="$(ifconfig ${network} | grep "inet" | awk '{print $4; exit}')" #Ifconfigs the interface and grabs the subnet.
dns="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')" #Opens the resolv.conf file and grabs the DNS.

#After the variables are made, the script echos out all the variables and a list of triage information is provided.
echo "Triage Results"
echo "-----------------------------"
echo "Operating System: ${os}"
echo "Version: ${ver}"
echo "System Name: ${sysname}"
echo "RAM Total: ${ram}" kb
echo "CPU Usage: ${cpu}"
echo "Total Storage: ${totalstg}"
echo "Available Storage: ${availstg}"
echo "Network Interface: ${network}"
echo "IP Address: ${ip}"
echo "IPv6 Address: ${ipv6}"
echo "Subnet: ${subnet}"
echo "DNS: ${dns}"

#After the list is displayed, teh script asks the user if they would like to see what services are currently running.
echo "Would you like to see what services are running? yes or no: "
read response #The script reads the response the user inputs.
if [ $response == "yes" ]; then
service --status-all | grep "+" #If the response is yes, the script will display a list of services that are enabled.
else
echo "Have fun triaging" #If anything else is inputted besides yes then the script will echo a message then end.
fi
#End of script
