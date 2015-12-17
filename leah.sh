#!/bin/bash
ANON='true'
PS1='LEAH> '
echo '#################################################'
echo '#                                               #'
echo '# Leah Tools - Privledged Access being applied. #'
echo '#                                               #'
echo '#################################################'

function scan_local_network() {
    if [[ $1 != '' ]]; then
	NMAP_ARGS=$*
    else
	NMAP_ARGS='-O -F -v'
    fi
    IP_REGEXP="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
    IPs=`sudo arp-scan --localnet | grep -E -o $IP_REGEXP`
    nmap $NMAP_ARGS $IPs
}

function connect_wireless() {
    WPA=/etc/wpa_supplicant/$1.conf
    if [[ $ANON == 'true' ]]; then
	echo "Randomizing MAC address..."
	macchanger -r wlan0
    fi
    if [[ $1 != ''  ]]; then
	if [[ $2 != '' ]]; then
	    ### 2
	    echo "Generating $1 configuration..."
	    if [[ $3 != '' ]]; then
		echo "Generating Network configuration..."
		wpa_passphrase $2 $3 > $WPA
	    else
		echo "network={
ssid='$2'
key_mgmt=NONE
}
" > $WPA
	    fi
	else
	    echo "Using existing configuration for $1:"
	fi
	cat $WPA
	### 3
	echo "Starting Wireless Driver..."
	wpa_supplicant -Dwext -iwlan0 -c$WPA &
	echo "Starting DHCP Client..."
	dhclient -v -4 wlan0
    fi    
}

function run_wifite() {
    wifite
}

function run_tshark() {
    tshark $*
}
alias wifi='connect_wireless' 
alias hack='echo "Running network intrusion program: wifite"; run_wifite'
alias discover='scan_local_network'
alias spy='echo "Running network traffic monitoring program: tshark"; run_tshark'
echo "##########"
echo "# USAGE: #"
echo "##########"
echo "# wifi <location> [ssid] [key]"
echo "# hack"
echo "# discover [args]"
echo "# spy [args]"
echo "#############################"
echo "# Don't do anything stupid. #"
echo "#############################"
