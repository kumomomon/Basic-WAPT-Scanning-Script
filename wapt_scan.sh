#!/bin/bash

hostname=$1
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
WHITE="\033[0;37m"

if [ -z "$hostname" ]
then
	echo -e "${RED}Hostname is not provided${WHITE}"
	echo "Usage: ./wapt_scan.sh <URL>"
	echo "Example: ./wapt_scan.sh www.example.com"
else
	echo "Checking if $hostname directory exist"
	if [ -d "$hostname" ]
	then
		echo "Directory exist!"
	else echo "Creating directory!"
		mkdir $hostname
	fi
	if [ -f "$hostname/nmapTCPscan.txt" ]
	then
		echo "Nmap TCP scan was already performed! Skipping Nmap TCP scan"
	else echo -e "Running TCP Nmap scan on ${RED}$hostname${WHITE}"
		nmap -T4 -p- -A $hostname > $hostname/nmapTCPscan.txt
	fi
	# if [ -f "$hostname/testssh.txt" ]
	# then
	#	echo "Nmap TCP scan was already performed! Skipping Nmap TCP scan"
	#	nmap -T4 -p- -A $hostname > $hostname/nmapTCPscan.txt
	# fi
	if [ -f "$hostname/whatweb.txt" ]
	then
		echo "WhatWeb was already performed! Skipping WhatWeb scan"
	else echo -e "Running WhatWeb on ${RED}$hostname${WHITE}"
		whatweb https://$hostname > $hostname/whatweb.txt
	fi
fi
