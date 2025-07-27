#!/bin/bash

curl -sL 'https://raw.githubusercontent.com/retronas/retronas/main/install_retronas.sh' --output /tmp/install_retronas.sh
chmod a+x /tmp/install_retronas.sh
/tmp/install_retronas.sh
sudo apt-get -y autoremove

