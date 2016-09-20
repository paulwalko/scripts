#!/bin/bash
echo 'This script was only tested in Ubuntu 16.04.1. Your mileage may vary'
echo 'This script also assumes you have sudo access, as you will be prompted for your password'

sudo apt-get install git cmake libusb-1.0-0-dev make gcc g++ libbluetooth-dev pkg-config libpcap-dev python-numpy python-pyside python-qt4 wireshark git

git clone https://github.com/greatscottgadgets/libbtbb.git
cd libbtbb
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig
cd ../..

git clone https://github.com/greatscottgadgets/ubertooth.git
cd ubertooth/host
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig
cd ../../..

sudo apt-get install wireshark wireshark-dev libwireshark-dev cmake
cd libbtbb/wireshark/plugins/btbb
mkdir build
cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make
sudo make install
cd ../../../../..

sudo apt-get install wireshark wireshark-dev libwireshark-dev cmake
cd libbtbb/wireshark/plugins/btbredr
mkdir build
cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make
sudo make install
cd ../../../../..

echo 'Adding user to wireshark group...'
sudo dpkg-reconfigure wireshark-common
sudo gpasswd -a $USER wireshark

echo 'If you plan to use wireshark to capture btle, be sure to follow the directions at the bottom of the page here to enable wireshark to recongize btle packets: https://github.com/greatscottgadgets/ubertooth/wiki/Capturing-BLE-in-Wireshark'
