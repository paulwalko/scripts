#!/bin/bash
# Purpose: Install ubertooth and crackle libraries
# Author: Paul Walko <paul@walko.org>
# Last updated on: 12/17/16
# ------------------------------------------------

# Setup
echo -e 'Installs the latest stable ubertooth release and/or crackle (git) release to /opt'
echo -e 'This script was only tested in Arch Linux (12/16). Your mileage may vary'
echo -e 'This script also assumes you have sudo access, as you will be prompted for your password\n'

INSTALL_DIR="/opt"

# help
function help {
	echo -e 'Help:\n'
	echo -e '-h: This message\n'
	echo -e '-I: Custom installation directory; Defaults to '/opt/'\n'
	echo -e '--remove-{libbtbb, ubertooth, crackle}: Removes respective program\n\n'
}

# Set install directory
while getopts ":h:I:" args; do
	case "${args}" in
		h)
			help
			;;
		I)
			INSTALL_DIR=${OPTARG}
			;;
		*)
			;;
	esac
done

# libbtbb
cd $INSTALL_DIR
if [[ $* == *--remove-libbtbb* ]]; then
	# Remove libbtbb
	echo -e 'WARNING: THIS WILL REMOVE ANY FILES/DIRECTORIES WITH "libbtbb" IN THEIR NAME \nContinue? (y/N)\n'
	read yn
	if [[ $yn == y ]]; then
		suod rm *libbtbb*gz
		cd *libbtbb*/build
		sudo make uninstall
		cd $INSTALL_DIR
		sudo rm -r *libbtbb*
	fi
elif ! ls | grep -q "libbtbb"; then
	echo -e 'Installing libbtbb... (Ubertooth dependency)\n'

	wget https://github.com/greatscottgadgets/libbtbb/archive/2015-10-R1.tar.gz -O libbtbb-2015-10-R1.tar.gz
	tar xf libbtbb-2015-10-R1.tar.gz
	cd libbtbb-2015-10-R1
	mkdir build
	cd build
	cmake ..
	make
	sudo make install
else
	echo -e 'libbtbb is already installed... skipping \nRun with "--remove-libbtbb" before installing new version\n'
fi

# ubertooth
cd  $INSTALL_DIR
if [[ $* == *--remove-ubertooth* ]]
then
	# Remove ubertooth
	echo -e 'WARNING: THIS WILL REMOVE ANY FILES/DIRECTORIES WITH "ubertooth" IN THEIR NAME \nContinue? (y/N)\n'
	read yn
	if [[ $yn == y ]]; then
		sudo rm *ubertooth*xz
		cd *ubertooth*/host/build
		sudo make uninstall
		cd $INSTALL_DIR
		sudo rm -r *ubertooth*
	fi
elif ! type "ubertooth-util" > /dev/null; then
	# Install ubertooth
	echo -e 'Installing ubertooth...\n\n'

	wget https://github.com/greatscottgadgets/ubertooth/releases/download/2015-10-R1/ubertooth-2015-10-R1.tar.xz -O ubertooth-2015-10-R1.tar.xz
	tar xf ubertooth-2015-10-R1.tar.xz
	cd ubertooth-2015-10-R1/host
	mkdir build
	cd build
	cmake ..
	make
	sudo make install
else
	# Already installed
	echo -e 'ubertoooth is alrady installed... skipping \nRun with "--remove-ubertooth" before installing new version\n'
fi

# crackle
cd $INSTALL_DIR
if [[ $* == *--remove-crackle* ]]
then
	# Remove crackle
	echo -e 'Remove crackle? (y/N)\n'
	read yn
	if [[ $yn == y ]]; then
		cd crackle
		sudo make uninstall
		cd $INSTALL_DIR
		sudo rm -r crackle
	fi
elif ! type "crackle" > /dev/null; then
	echo -e 'Installing crackle... \n\n'

	git clone https://github.com/mikeryan/crackle.git
	cd crackle
	make
	sudo make install
else
	# Already installed
	echo -e 'crackle is alrady installed.. skipping \nRun with "--remove-crackle" before installing new version\n'
fi


echo -e 'Running ldconfig to fix some libraries... \n'
sudo ldconfig

echo -e 'If you plan to use wireshark to capture btle, be sure to follow the directions at the bottom of the page here to enable wireshark to recongize btle packets: \nhttps://github.com/greatscottgadgets/ubertooth/wiki/Capturing-BLE-in-Wireshark'
