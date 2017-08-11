#!/bin/bash

VIRTUALBOX="YES"
ARC_THEME="YES"
SUBLIME_TEXT="YES"
ATOM="YES"
ECLIPSE="YES"
DOCKER="YES"

cd /tmp

### UPDATE BEFORE BEGINNING ###
apt update && apt upgrade

### Virtualbox ###
if [ $VIRTUALBOX == "YES" ] ; then
	echo "Running Install Virtualbox"
	apt install curl dkms build-essential linux-headers-$(uname -r)
	echo "Insert VBoxLinuxAdditions CDROM and enter \"yes\""
	read response
	if [ $response == "yes" ] ; then
		mount /media/cdrom
		sh /media/cdrom/VBoxLinuxAdditions.run
	fi
fi

### Arc theme and icons ###
if [ $ARC_THEME == "YES" ] ; then
	echo "Running Install Arc Theme and Icons"
	apt install arc-theme
	apt install git
	git clone https://github.com/horst3180/arc-icon-theme --depth 1
	cp -R arc-icon-theme/Arc /usr/share/icons/
fi

# Apparence --> Polices / Gestionnaire de fenetres
# Sans 11 - 96

### Sublime Text ###
if [ $SUBLIME_TEXT == "YES" ] ; then
	echo "Running Install Sublime Text"
	apt install apt-transport-https
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
	echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
	apt update
	apt install sublime-text
	# install package boxy theme
fi

### Atom Editor ###
if [ $ATOM == "YES" ] ; then
	echo "Running Install Atom Editor"
	apt install gconf2 gvfs-bin
	wget https://atom.io/download/deb -O atom.deb
	dpkg -i atom.deb
fi

### Eclipse ###
if [ $ECLIPSE == "YES" ] ; then
	echo "Running Install Eclipse"
	apt install eclipse
fi

### Docker ###
if [ $DOCKER == "YES" ] ; then
	echo "Running Install Docker"
	apt install \
		 apt-transport-https \
		 ca-certificates \
		 curl \
		 gnupg2 \
		 software-properties-common
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/debian \
	   $(lsb_release -cs) \
	   stable"

	apt-get update
	apt-get install docker-ce
	curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
fi

# Purge 
# rm -rf /tmp/*

echo "All Done."

