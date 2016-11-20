#!/bin/bash

PWD=$(pwd)
# add repos
sudo add-apt-repository -y "deb https://apt.dockerproject.org/repo ubuntu-xenial main"
sudo add-apt-repository -y ppa:mystic-mirage/pycharm
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# install apps
sudo apt-get -y install
    terminator git pycharm wget qt5-default libfftw3-dev cmake pkg-config \
    liblog4cpp5-dev vim automake build-essential chromium-browser python-pip \
    python3-pip

sudo apt-get -y remove firefox

echo ""
echo "========================"
echo " General Settings! "
echo "========================"
echo ""

mkdir ~/bin
mkdir ~/Programs

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
cp -a data/dotfiles/.* ~
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
rm ~/examples.desktop

# terminator
mkdir -p ~/.config/terminator
cp ./data/config/terminator ~/.config/terminator/config

echo ""
echo "========================"
echo " Done General Settings! "
echo "========================"
echo ""



echo ""
echo "========================"
echo " General Programs! "
echo "========================"
echo ""

# install gitkraken
mkdir ~/build
cd ~/build
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
rm gitkraken-amd64.deb
cd ~ && rm -rf ~/build

# install docker
sudo apt-get install docker-engine apt-transport-https ca-certificates
sudo bash -c "curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

# Install atom
cd ~
wget https://atom-installer.github.com/v1.12.4/atom-amd64.deb
sudo dpkg -i atom-amd64.deb
rm aton-amd64.deb

echo ""
echo "========================"
echo " Done General Programs! "
echo "========================"
echo ""



echo ""
echo "========================"
echo " Installing SDR Crap! "
echo "========================"
echo ""

sudo apt-get install -y libarmadillo-dev libcomedi-dev portaudio19-dev \
libsndfile1-dev libitpp-dev libtecla-dev libqt5svg5-dev

# Add RTLSDR To Blacklist
sudo bash -c 'cat <<EOL > /etc/modprobe.d/rtlsdr.conf
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
EOL'


# install liquid-dsp
mkdir ~/build
cd ~/build
git clone git://github.com/jgaeddert/liquid-dsp.git
cd liquid-dsp
./bootstrap.sh
CFLAGS="-march=native" ./configure --enable-fftoverride
make -j && sudo make install
cd ~ && rm -rf ~/build

# install baudline
cd ~/Programs
wget http://www.baudline.com/baudline_1.08_linux_x86_64.tar.gz
tar xzf baudline_1.08_linux_x86_64.tar.gz
rm baudline_1.08_linux_x86_64.tar.gz
ln baudline_1.08_linux_x86_64/baudline ~/bin/baudline
ln baudline_1.08_linux_x86_64/baudline_jack ~/bin/baudline_jack

# install inspectrum
mkdir ~/build
cd ~/build
git clone https://github.com/miek/inspectrum
mkdir inspectrum/build && cd inspectrum/build
cmake .. && make -j && sudo make install
cd ~ && rm -rf ~/build

# install gnuradio
mkdir -p ~/build/gnuradio
cd ~/build/gnuradio
wget http://www.sbrac.org/files/build-gnuradio
sudo chmod +x build-gnuradio
./build-gnuradio -m -ja -v

# install gr-baz blocks for gnuradio
cd ~/build
git clone https://github.com/balint256/gr-baz
mkdir ./gr-baz/build && cd gr-baz/build
cmake .. && make -j && sudo make install
cd .. && rm -rf build

# install gr-dsd
cd ~/build
git clone https://github.com/argilo/gr-dsd
mkdir ./gr-dsd/build && cd gr-dsd/build
cmake .. && make -j && sudo make install
cd .. && rm -rf build

# install gr-ais
cd ~/build
git clone https://github.com/bistromath/gr-ais
mkdir ./gr-ais/build && cd gr-ais/build
cmake .. && make -j && sudo make install
cd .. && rm -rf build

# folders
mkdir ~/Desktop/gnuradio-blocks
mv ~/build/gr-dsd ~/Desktop/gnuradio-blocks/
mv ~/build/gr-baz ~/Desktop/gnuradio-blocks/
mv ~/build/gr-ais ~/Desktop/gnuradio-blocks/

# DMR Samples
git clone https://github.com/BrashEndeavours/dsd-samples ~/Desktop/DMR-samples

# GNURadio Examples
mkdir ~/Desktop/grc-examples
cd ~/Desktop/grc-examples
mv ~/Desktop/gnuradio-blocks/gr-baz/samples/* ./
git clone https://github.com/argilo/sdr-examples

# install GQRX
mkdir ~/build
cd ~/build
git clone https://github.com/csete/gqrx
mkdir gqrx/build && cd gqrx/build
cmake .. && make -j && sudo make install
cd ~ && rm -rf ~/build

echo ""
echo "========================"
echo " Done SDR Crap! "
echo "========================"
echo ""



echo ""
echo "========================"
echo " Installing RE Crap! "
echo "========================"
echo ""

# CTF Tools
cd ~
sudo apt-get install -y build-essential libtool g++ gcc texinfo curl wget  \
    automake autoconf python python-dev git subversion unzip virtualenvwrapper \
    libtool-bin bison
git clone https://github.com/zardus/ctf-tools
~/ctf-tools/bin/manage-tools setup
source ~/.bashrc

# American Fuzzy Lop
manage-tools -s install afl

# Keystone Engine
mkdir ~/build
cd ~/build
git clone https://github.com/keystone-engine/keystone
mkdir keystone/build
cd keystone/build
../make-share.sh
sudo make install
cd ../bindings/python/
sudo python3 setup.py install
sudo python setup.py install
cd ~ && sudo rm -rf build
sudo ldconfig

# Capstone Engine
mkdir ~/build
cd ~/build
git clone https://github.com/aquynh/capstone
cd capstone
./make.sh
sudo ./make.sh install
cd bindings/python/
sudo python3 setup.py install
sudo python setup.py install
cd ~ && sudo rm -rf build
sudo ldconfig

# Unicorn Engine
mkdir ~/build
cd ~/build
git clone https://github.com/unicorn-engine/unicorn.git
cd unicorn
./make.sh
sudo ./make.sh install
cd bindings/python/
sudo make install
cd ~ && sudo rm -rf build
sudo ldconfig


# GEF
manage-tools -s install gef


echo ""
echo "========================"
echo " Done RE Crap! "
echo "========================"
echo ""

# update system settings
#gsettings set com.canonical.indicator.power show-percentage true

# update some more system settings
#dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 32

# requires clicks
#sudo apt-get install -y ubuntu-restricted-extras

# prompt for a reboot
clear
echo ""
echo "========================"
echo " TIME FOR A REBOOT! "
echo "========================"
echo ""
