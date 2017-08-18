#!/bin/bash

VIRTUALBOX="YES"
ARC_THEME="YES"
SUBLIME_TEXT="NO"
ATOM="YES"
ECLIPSE="NO"
DOCKER="YES"
THUNDERBIRD="NO"
CHROME="YES"
SSH_KEYGEN="YES"
GIT_CLONE="NO"
LAMP="YES"
NODEJS="YES"
MONGODB="YES"

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

### Thunderbird ###
if [ $THUNDERBIRD == "YES" ] ; then
	echo "Running Install Thunderbird"
	apt install thunderbird thunderbird-l10n-fr
fi

### Chrome ###
if [ $CHROME == "YES" ] ; then
	echo "Running Install Chrome"
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
	apt update && apt install google-chrome-stable
fi

### LAMP ###
if [ $LAMP == "YES" ] ; then
	echo "Running Install LAMP"
	apt install openssh-server apache2 php mysql-server libapache2-mod-php php-mysql unzip php-zip phpmyadmin php-gd
	echo "sql_mode = \"NO_ENGINE_SUBSTITUTION\"" >> /etc/mysql/my.cnf
	a2enmod rewrite
	{
        echo -e "<ifModule mod_rewrite.c>"
        echo -e "\tRewriteEngine On"
        echo -e "</ifModule>"
    } >> /etc/apache2/apache2.conf
fi

### NODEJS ###
if [ $NODEJS == "YES" ] ; then
	echo "Running Install NODEJS"
	curl -sL https://deb.nodesource.com/setup_6.x | bash -
	apt-get install -y nodejs
	node -v
fi

### MONGODB ###
if [ $MONGODB == "YES" ] ; then
	echo "Running Install MONGODB"
	apt install mongodb
fi

user=bvi
adduser $user sudo

### Session with $user ###
echo "Begin session $user"
su - $user << EOF
	### Ssh keygen ###
	if [ $SSH_KEYGEN == "YES" ] ; then
	        echo "Running ssh keygen"
	        ssh-keygen -t rsa -b 4096
	fi

	### Git Clone ###
	if [ $GIT_CLONE == "YES" ] ; then
	    mkdir -p /home/$user/Git
	    cd /home/$user/Git
	    git clone git@github.com:benkenobi31/linux.git
	    git clone git@github.com:benkenobi31/docker.git
		git clone git@github.com:benkenobi31/NodeJS.git
	fi
EOF

echo "All Done."
