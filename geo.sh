#!/bin/bash
echo "Collecting IP Information"
myip=`echo $SSH_CLIENT | awk '{ print $1}'` | ufw status | grep DENY | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep -vwE "($myip|192.168.0.10|192.168.0.20|192.168.0.30)" | sort | uniq -u > raw-ips.txt
sleep 5
echo "Getting Country Information"
while read line; do curl -s https://freegeoip.app/json/$line | jq -r '.country_name'; done < ./raw-ips.txt > countries.txt
sleep 5
echo "Getting Top Ten Rankings"

if      [ -z "$1" ]
then
        sort countries.txt | uniq -c | sort -nr | head
else
        sort countries.txt | uniq -c | sort -nr | head -$1
fi
echo "Completed"
