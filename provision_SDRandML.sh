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
    libqt5svg5-dev audacity libusb-dev libcgraph6 graphviz-dev graphviz

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

# Install VS Code
cd ~
wget https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code*.deb
rm code*.deb

# Install Jupyter
cd ~
sudo pip install jupyter tqdm
sudo pip install --no-binary :all: numpy h5py scipy keras

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

# install GNURADIO/BLOCKS
cd ~
sudo pip install pybombs
sudo pip install networkx
sudo pip install matplotlib
sudo pip install pygraphviz
yes | pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git
yes | pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
mkdir gnuradio/
pybombs prefix init -a default gnuradio/default

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
mkdir ~/build
cd ~/build
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda libcupti-dev libhdf5-dev

rm cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

# cuDNN v6.0
mkdir ~/build
cd ~/build

### FETCH THE FILE BELOW MANUALLY
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v5.1/prod_20161129/8.0/cudnn-8.0-linux-x64-v6.0-tgz

tar -xzvf cudnn-8.0-linux-x64-v6.0.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

sudo pip install --install-option="--jobs=6" --no-binary :all: --upgrade numpy scipy pyyaml h5py keras
sudo pip  install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.3.0rc1-cp27-none-linux_x86_64.whl

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
