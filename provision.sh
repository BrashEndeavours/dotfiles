#!/bin/bash

# add repos
#sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
#sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo add-apt-repository -y "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -sc) main"
sudo add-apt-repository -y ppa:mystic-mirage/pycharm
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# install apps
sudo apt-get -y install \
    terminator apt-transport-https ca-certificates docker-engine \
    docker-compose git pycharm wget gitkraken qt5-default \
    libfftw3-dev cmake pkg-config

# install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

# install liquid-dsp
mkdir ~/build || cd ~/build
git clone git://github.com/jgaeddert/liquid-dsp.git
cd liquid-dsp
./bootstrap.sh
CFLAGS="-march=native" ./configure --enable-fftoverride
make -j && sudo make install

# install inspectrum
mkdir ~/build || cd ~/build
git clone https://github.com/miek/inspectrum
mkdir inspectrum/build && cd build
cmake .. && make -j && sudo make install

# swappiness
cat ./data/etc/sysctl-append >> /etc/sysctl.conf

# fonts
mkdir ~/.fonts
cp -ar ./data/fonts/* ~/.fonts/

# scripts
mkdir ~/.scripts
cp -ar ./data/scripts/* ~/.scripts/
chmod +x ~/.scripts/*

# dotfiles
cp -a ./data/dotfiles/* ~

# folders
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
rm ~/examples.desktop


# update system settings
#gsettings set com.canonical.indicator.power show-percentage true



# update some more system settings
#dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 32


# requires clicks
#sudo apt-get install -y ubuntu-restricted-extras


# prompt for a reboot
clear
echo ""
echo "===================="
echo " TIME FOR A REBOOT! "
echo "===================="
echo ""
