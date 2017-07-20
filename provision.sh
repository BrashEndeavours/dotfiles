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
cp -R ./data ~
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

# install docker
sudo apt-get -y install \
  docker-engine apt-transport-https ca-certificates
sudo bash -c "curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

# Install atom
cd ~
https://go.microsoft.com/fwlink/?LinkID=760868
#wget https://atom-installer.github.com/v1.12.4/atom-amd64.deb
sudo dpkg -i *_amd64.deb
rm *_amd64.deb

# Install Jupyter
cd ~
sudo pip install jupyter

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

# install GNURADIO/BLOCKS
cd ~
sudo pip install pybombs
pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git
pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
mkdir gnuradio/
pybombs prefix init -a default gnuradio/default

cd gnuradio/default
source ./setup_env.sh
pybombs install apache-thrift
pybombs install pygraphviz
pybombs install gnuradio
pybombs install gr-baz
pybombs install gr-dsd
pybombs install gr-ais
#pybombs install gr-op25
pybombs install rtl-sdr
pybombs install gqrx

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

wget http://upload.cppreference.com/mwiki/images/3/37/html_book_20170409.tar.gz
tar -xzf html_book_20170409.tar.gz && rm html_book_20170409.tar.gz
rm *.xml
mv reference c++

wget https://docs.python.org/2/archives/python-2.7.13-docs-html.tar.bz2
tar -xjf python-2.7.13-docs-html.tar.bz2 && rm python-2.7.13-docs-html.tar.bz2
mv python-2.7.13-docs-html python-2.7

wget https://keras.io/ -D keras.io -rkp -l6
find ./keras.io -name "*.html" -exec sed -i 's_/">_/index.html">_' {} \;

#wget http://www.tensorflow.com -D www.tensorflow.com -rkp -l6


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

# Development headers
sudo apt-get install linux-headers-$(uname -r)

# CUDA® Toolkit 8.0
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda
bash -c 'cat <<EOL > ~/.bashrc
export PATH="/usr/local/cuda/bin:${PATH}"                                   
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
EOL' 
sudo rm cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
 
# cuDNN v5.1
https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v5.1/prod_20161129/8.0/cudnn-8.0-linux-x64-v5.1-tgz
tar -xzf cudnn-8.0-linux-x64-v5.1-tgz 
rm cudnn-8.0-linux-x64-v5.1-tgz
sudo mv cuda /usr/local/cuDNN
sudo rm libcudnn5-dev_5.1.10-1+cuda8.0_amd64-deb
bash -c 'cat <<EOL > ~/.bashrc
export LD_LIBRARY_PATH="/usr/local/cuDNN/lib64:$LD_LIBRARY_PATH"
EOL' 

sudo apt-get install libcupti-dev
sudo pip install tensorflow-gpu

sudo pip install numpy
sudo pip install scipy
sudo pip install pyyaml
sudo pip install h5py
sudo pip install keras
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
