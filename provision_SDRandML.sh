#!/bin/bash
set -x
PWD=$(pwd)

# add repos
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

# install apps
sudo apt-get -y install \
    terminator git wget qt5-default libfftw3-dev cmake pkg-config \
    liblog4cpp5-dev vim automake build-essential chromium-browser python-pip \
    python3-pip codeblocks qtcreator libboost-all-dev libarmadillo-dev \
    libcomedi-dev portaudio19-dev libsndfile1-dev libitpp-dev libtecla-dev \
    libqt5svg5-dev audacity libusb-dev libcgraph6 graphviz-dev graphviz libgconf-2-4

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
cd ~/dotfiles
cp -R ./data/.* ~/
chown $(whoami).$(whoami) ~/*
rm -rf ~/Documents
rm -rf ~/Public
rm -rf ~/Templates
rm -rf ~/Videos
rm -rf ~/Music
rm ~/examples.desktop

# terminator
mkdir -p ~/.config/terminator
cp ~/data/etc/terminator/config ~/.config/terminator/config

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

# Upgrade pip
pip install --upgrade pip

# install gitkraken
mkdir ~/build
cd ~/build
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
rm gitkraken-amd64.deb
cd ~ && rm -rf ~/build

# Install VS Code
cd ~
wget https://go.microsoft.com/fwlink/?LinkID=760868
sudo chmod +x index.html?LinkID=760868
sudo dpkg -i index.html?LinkID=760868
rm index.html?LinkID=760868

# Install Jupyter
cd ~
sudo pip install jupyter tqdm

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
make -j4 && sudo make install

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

# Ensure kernel.shmmax=32147483647 is set in kernel, for gnuradio
sudo -s -- <<EOF
grep -q '^kernel.shmmax' /etc/sysctl.conf && sed -i 's/^kernel.shmmax.*/kernel.shmmax = 32147483647/' /etc/sysctl.conf || echo 'kernel.shmmax = 32147483648' >> /etc/sysctl.conf
EOF

# Ensure kernel.shmmni = 64000 is set in kernel, for gnuradio
sudo -s -- <<EOF
grep -q '^kernel.shmmni' /etc/sysctl.conf && sed -i 's/^kernel.shmmni.*/kernel.shmmni = 64000/' /etc/sysctl.conf || echo 'kernel.shmmni = 64000' >> /etc/sysctl.conf
EOF

# Install GNURADIO/BLOCKS
cd ~
sudo pip install --upgrade pybombs networkx matplotlib pygraphviz
yes | pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git
yes | pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
mkdir gnuradio/
yes | pybombs prefix init -a default gnuradio/default

cd gnuradio/default
source ./setup_env.sh
yes | pybombs install apache-thrift
yes | pybombs install pygraphviz
yes | pybombs install gnuradio
yes | pybombs install gr-baz
yes | pybombs install gr-dsd
yes | pybombs install gr-ais
yes | pybombs install gr-op25
yes | pybombs install rtl-sdr
yes | pybombs install gqrx

# install thesis
cd ~/Desktop
mkdir work
cd work
git clone http://github.com/brashendeavours/gr-thesis

# install extras
cd ~/Desktop
mkdir extras
cd extras
git clone https://github.com/f4exb/dsdcc

# install references
cd ~/Desktop
mkdir references
cd references
wget https://github.com/egoist/devdocs-app/releases/download/v0.2.2/DevDocs_0.2.2_amd64.deb
sudo dpkg -i DevDocs_0.2.2_amd64.deb
rm DevDocs_0.2.2_amd64.deb


mkdir standards
cd standards
wget http://www.etsi.org/deliver/etsi_ts/102300_102399/10236101/02.04.01_60/ts_10236101v020401p.pdf
wget http://www.etsi.org/deliver/etsi_ts/102300_102399/10236102/02.03.01_60/ts_10236102v020301p.pdf
wget http://www.etsi.org/deliver/etsi_ts/102300_102399/10236103/01.02.01_60/ts_10236103v010201p.pdf
wget http://www.etsi.org/deliver/etsi_ts/102300_102399/10236104/01.08.01_60/ts_10236104v010801p.pdf


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

# Development headers
sudo apt-get install linux-headers-$(uname -r)

# CUDA® Toolkit 8.0
mkdir ~/build/cuda
cd ~/build/cuda
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda_8.0.61.2_linux-run
sudo chmod +x cuda*
./cuda_8.0.61_375.26_linux-run --tar mxvf
sudo cp InstallUtils.pm /usr/lib/x86_64-linux-gnu/perl-base
sudo ./cuda_8.0.61_375.26_linux-run --override
sudo ldconfig
sudo ./cuda_8.0.61.2_linux-run
sudo ldconfig

sudo apt-get update
sudo apt-get install -y libcupti-dev libhdf5-dev

# cuDNN v7.0
mkdir ~/build
cd ~/build
read -p "Download the cuDNN for Cuda 8, place it in ~/build/ and press enter to continue"
tar xzf cudnn*
cd cudnn
sudo cp include/* /usr/local/cuda-8.0/include/
sudo cp lib64/* /usr/local/cuda-8.0/lib64/

sudo pip install --no-binary :all: --upgrade numpy scipy pyyaml h5py keras
sudo pip install --upgrade tensorflow-gpu

sudo touch /usr/local/lib/python2.7/dist-packages/google/__init__.py
sudo touch /usr/local/lib/python2.7/dist-packages/mpl_toolkits/__init__.py
sudo touch /usr/local/lib/python2.7/dist-packages/ruamel/__init__.py

echo ""
echo "============================="
echo " Done Machine Learning Crap! "
echo "============================="
echo ""

sudo ldconfig
echo ""
echo "========================"
echo " TIME FOR A REBOOT! "
echo "========================"
echo ""
