###############
#Triage Script#
#Kelvin Ashton#
###############

#!/bin/sh

#Variables are all made from the outputs of commands for later use.
#The grep command is used to sniff out specific text strings.
#The awk command is used to pull only specific pieces from a line of text to be saved as a variable.

os="$(uname -or)"
ver="$(uname -v)"
sysname="$(hostname -f)"
ram="$(grep MemTotal /proc/meminfo | awk '{print $2}')"
cpu="$(grep 'cpu' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"
totalstg="$(df -H --total | grep total | awk '{print $2}')"
availstg="$(df -H --total | grep total | awk '{print $4}')"
ip="$(ip route get 8.8.8.8 | awk '{print $NF; exit}')"
network="$(ip route get 8.8.8.8 | awk '{print $5; exit}')"
ipv6="${ifconfig ${network} | grep "inet6" | awk '{print $2; exit}')"
subnet="$(ifconfig ${network} | grep "inet" | awk '{print $2}')"
dns="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')"

echo "Triage Results"
echo "---------------------------"
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
echo "Subnet Mask: ${subnet}"
echo "DNS: ${dns}"
echo "---------------------------"

echo "Would you like to see what services are running? yes or no: "
read answer
if [ $answer == "yes" ]; then
service --status-all | grep +
else echo "Have fun triaging"
fi


