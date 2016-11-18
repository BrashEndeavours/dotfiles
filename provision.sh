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
    libfftw3-dev cmake pkg-config libarmadillo-dev liblog4cpp5-dev \
    libsndfile1-dev libitpp-dev vim

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

# install baudline
mkdir ~/Programs || cd ~/Programs
wget http://www.baudline.com/baudline_1.08_linux_x86_64.tar.gz
tar xzf baudline_1.08_linux_x86_64.tar.gz
rm baudline_1.08_linux_x86_64.tar.gz
ln baudline_1.08_linux_x86_64/baudline ~/bin/baudline
ln baudline_1.08_linux_x86_64/baudline_jack ~/bin/baudline_jack

# install inspectrum
cd ~/build
git clone https://github.com/miek/inspectrum
mkdir inspectrum/build && cd build
cmake .. && make -j && sudo make install

# install gnuradio
mkdir -p ~/build/gnuradio || cd ~/build/gnuradio
wget http://www.sbrac.org/files/build-gnuradio
sudo chmod +x ./build-gnuradio && ./build-gnuradio
rm -rf ~/build/gnuradio

# install GQRX
cd ~/build
git clone https://github.com/csete/gqrx
mkdir gqrx/build && cd gqrx/build
cmake .. && make -j && sudo make install
rm -rf ~/build/gqrx

# install gr-baz blocks for gnuradio
cd ~/build
git clone https://github.com/balint256/gr-baz
mkdir ./gr-baz/build && cd gr-baz/build
cmake .. && make -j && sudo make install
cd .. && rm -rf ~/build/gr-baz/build

# install gr-dsd
cd ~/build
git clone https://github.com/argilo/gr-dsd
mkdir ./gr-dsd/build && cd gr-dsd/build
cmake .. && make -j && sudo make install
cd .. && rm -rf ~/build/gr-dsd/build

# install gr-ais
cd ~/build
git clone https://github.com/bistromath/gr-ais
mkdir ./gr-ais/build && cd gr-ais/build
cmake .. && make -j && sudo make install
cd .. && rm -rf ~/build/gr-ais/build

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
mkdir ~/Desktop/gnuradio-blocks
mv ~/build/gr-dsd ~/Desktop/gnuradio-blocks/
mv ~/build/gr-baz ~/Desktop/gnuradio-blocks/
mv ~/build/gr-ais ~/Desktop/gnuradio-blocks/

git clone https://github.com/BrashEndeavours/dsd-samples ~/Desktop/DMR-samples

mkdir ~/Desktop/grc-examples
cd ~/Desktop/grc-examples 
mv ~/Desktop/gnuradio-blocks/gr-baz/samples/* ./
git clone https://github.com/argilo/sdr-examples


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
