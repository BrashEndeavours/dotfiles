#!/bin/bash
set -x
PWD=$(pwd)

# add repos
sudo add-apt-repository -y "deb https://apt.dockerproject.org/repo ubuntu-xenial main"
#sudo add-apt-repository -y ppa:mystic-mirage/pycharm
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# install apps
sudo apt-get -y install \
    terminator git wget qt5-default libfftw3-dev cmake pkg-config \
    liblog4cpp5-dev vim automake build-essential chromium-browser python-pip \
    python3-pip codeblocks qtcreator

sudo apt-get -y remove firefox

echo ""
echo "========================"
echo " General Settings! "
echo "========================"
echo ""

mkdir ~/bin
mkdir ~/Programs

# swappiness
sudo bash -c 'cat ./data/etc/sysctl-append >> /etc/sysctl.conf'

# fonts
mkdir ~/.fonts
cp -ar ./data/fonts/* ~/.fonts/

# scripts
mkdir ~/.scripts
cp -ar ./data/scripts/* ~/.scripts/
chmod +x ~/.scripts/*

# dotfiles
cp -a ./data/.* ~
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
rm ~/examples.desktop

# terminator
mkdir -p ~/.config/terminator
cp ./data/etc/terminator/config ~/.config/terminator/config

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
sudo apt-get -y install \
  docker-engine apt-transport-https ca-certificates
sudo bash -c "curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

# Install atom
cd ~
wget https://atom-installer.github.com/v1.12.4/atom-amd64.deb
sudo dpkg -i atom-amd64.deb
rm atom-amd64.deb

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

sudo apt-get -y install \
  libarmadillo-dev libcomedi-dev portaudio19-dev libsndfile1-dev libitpp-dev \
  libtecla-dev libqt5svg5-dev audacity libusb-dev

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
./configure --enable-fftoverride CFLAGS="-march=native"
make -j && sudo make install

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
cmake .. && make -j4 && sudo make install

# install GNURADIO/BLOCKS
cd ~
sudo pip install pybombs
pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git
pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
mkdir gnuradio/
pybombs prefix init -a default gnuradio/default

cd gnuradio/default
source ./setup_env.sh
pybombs install apache thrift
pybombs install gnuradio
pybombs install gr-baz
pybombs install gr-dsd
pybombs install gr-ais
pybombs install gr-op25
pybombs install rtl-sdr
pybombs install gqrx

# install r820tweak
cd ~/build
git clone https://github.com/gat3way/r820tweak
cd r820tweak
make -j && sudo make install

# folders
cd ~
mkdir ~/Desktop/gnuradio-blocks
#mv ~/build/gr-dsd ~/Desktop/gnuradio-blocks/
#mv ~/build/gr-baz ~/Desktop/gnuradio-blocks/
#mv ~/build/gr-ais ~/Desktop/gnuradio-blocks/
#mv ~/build/op25 ~/Desktop/gnuradio-blocks/

# DMR Samples
git clone https://github.com/BrashEndeavours/dsd-samples ~/Desktop/DMR-samples

# install octave
sudo apt-get -y install \
  octave gnuplot octave-signal octave-communications octave-common
# Fix the messed up permissions on octave installer....
sudo chown ${USER}:${USER} ~/.config/octave -R

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
sudo apt-get -y install \
  build-essential libtool g++ gcc texinfo curl wget automake autoconf python \
  python-dev git subversion unzip virtualenvwrapper libtool-bin bison
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
sudo ldconfig


# GEF
manage-tools -s install gef ropper
pip3 install retdec-python ropgadget
pip install ropgadget

echo ""
echo "========================"
echo " Done RE Crap! "
echo "========================"
echo ""

echo ""
echo "========================"
echo " Installing LATEX Crap! "
echo "========================"
echo ""

sudo apt-get install -y texstudio texlive-math-extra texlive-latex-extra

echo ""
echo "========================"
echo " Done LATEX Crap! "
echo "========================"
echo ""

echo ""
echo "==================================="
echo " Installing Machine Learning Crap! "
echo "==================================="
echo ""

pip install tensorflow
pip install numpy
pip install scipy
pip install pyyaml
pip install h5py
pip install keras
sudo apt-get install libhdf5-dev

echo ""
echo "============================="
echo " Done Machine Learning Crap! "
echo "============================="
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
