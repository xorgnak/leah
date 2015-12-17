#!/bin/bash

echo 'su' > /usr/bin/leah
chmod +x /usr/bin/leah
apt-get install nmap arp-scan grep wpasupplicant macchanger tshark wifite netcat ii
cp -fv leah.sh /root/leah.sh
echo "source leah.sh" >> /root/.bashrc
