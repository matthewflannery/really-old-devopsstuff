#!/bin/bash 
#First phase of script: Install puppet, enable it
apt-get install -y puppet && puppet agent --enable 

#Second phase: Lock puppet version to 3.4.*

cat >/etc/apt/preferences.d/00-puppet.pref <<EOL
Package: puppet puppet-common
Pin: version 3.4*
Pin-Priority: 501
EOL
