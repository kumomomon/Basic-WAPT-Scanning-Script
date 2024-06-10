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
	exit 1
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
		echo -e "Command: nmap -T4 -p- -A $hostname\n" > $hostname/nmapTCPscan.txt
                nmap -T4 -p- -A $hostname >> $hostname/nmapTCPscan.txt
        fi
        if [ -f "$hostname/whatweb.txt" ]
        then
                echo "WhatWeb was already performed! Skipping WhatWeb scan"
        else echo -e "Running WhatWeb on ${RED}$hostname${WHITE}"
		echo -e "Command: whatweb https://$hostname\n" > $hostname/whatweb.txt
                whatweb https://$hostname >> $hostname/whatweb.txt
        fi
        if [ -f "$hostname/whois.txt" ]
        then
                echo "WhoIS was already performed! Skipping WhoIS search"
        else echo -e "Running WhoIS on ${RED}$hostname${WHITE}"
		wwwless_hostname=$(echo "$hostname" | sed 's/^www\.//')
  		echo -e "Command: whois $wwwless_hostname\n" > $hostname/whois.txt
                whois $wwwless_hostname >> $hostname/whois.txt
        fi
        if [ -f "$hostname/wafw00f.txt" ]
        then
                echo "Wafw00f was already performed! Skipping Wafw00f check"
        else echo -e "Running Wafw00f on ${RED}$hostname${WHITE}"
		echo -e "Command: wafw00f https://$hostname\n" > $hostname/wafw00fs.txt
                wafw00f https://$hostname >> $hostname/wafw00fs.txt
        fi
		if [ -f "$hostname/testssh.txt" ]
	then
		echo "testssl check already performed! Skipping testssl check"
	else echo -e "Running testssl scan on ${RED}$hostname${WHITE}"
		echo -e "testssl --csv --log $hostname:443\n" > $hostname/testssh.txt
		testssl --csv --log $hostname:443 >> $hostname/testssh.txt
	fi
        if [ -f "$hostname/lbd.txt" ]
        then
                echo "LBD was already performed! Skipping LBD load balancer check"
        else echo -e "Running LBD on ${RED}$hostname${WHITE}"
		echo -e "Command: lbd $hostname\n" > $hostname/lbd.txt
                lbd $hostname >> $hostname/lbd.txt
        fi
        if [ -f "$hostname/nikto.txt" ]
        then
                echo "Nikto was already performed! Skipping Nikto scan"
        else echo -e "Running Nikto on ${RED}$hostname${WHITE}"
		echo -e "Command: nikto -h https://$hostname" > $hostname/nikto.txt
                nikto -h https://$hostname >> $hostname/nikto.txt
        fi

fi

