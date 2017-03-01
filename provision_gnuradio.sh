#!/bin/bash
set -x
PWD=$(pwd)

echo ""
echo "========================"
echo " Update! "
echo "========================"
echo ""

# basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

echo ""
echo "========================"
echo " Done Update! "
echo "========================"
echo ""


echo ""
echo "========================"
echo " General Programs! "
echo "========================"
echo ""

# General Programs
sudo apt-get -y install \
    terminator git wget qt5-default libfftw3-dev cmake pkg-config \
    liblog4cpp5-dev vim automake build-essential python-pip \
    python3-pip libarmadillo-dev libcomedi-dev portaudio19-dev \
    libsndfile1-dev libitpp-dev libtecla-dev libqt5svg5-dev audacity libusb-dev

echo ""
echo "========================"
echo " Done General Programs! "
echo "========================"
echo ""

echo ""
echo "========================"
echo " Installing GNURadio! "
echo "========================"
echo ""


cd ~
sudo pip install pybombs # Install pybombs build system for gnuradio
# Add the pybombs recipes
pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git
pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git

# Make a home directory and initialize a prefix
mkdir ~/gnuradio
pybombs prefix init -a default gnuradio/default

# Install a good base of packages
cd gnuradio/default
source ./setup_env.sh
pybombs config builddocs ON
pybombs install apache-thrift
pybombs install pygraphviz
pybombs install gnuradio
pybombs install gr-baz
pybombs install gr-dsd
pybombs install gr-ais
pybombs install gr-op25
pybombs install rtl-sdr
pybombs install gqrx

echo ""
echo "========================"
echo " Done GNURadio Crap! "
echo "========================"
echo ""

echo ""
echo "==================================="
echo " Installing Machine Learning Stuff! "
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
echo " Done Machine Learning ! "
echo "============================="
echo ""


echo ""
echo "========================"
echo " All installed!"
echo " To use: "
echo " "
echo " >>cd ~/gnuradio/default"
echo " >>source ./setup_env.sh"
echo " >>gnuradio-companion"
echo " "
echo " TIME FOR A REBOOT! "
echo "========================"
echo ""
