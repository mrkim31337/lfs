#!/bin/sh

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build networkmanager with wifi support"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi

#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
	'dbus-glib'
	'libgudev'
	'libndp'
	'libnl'
	'gpm'
	'newt'
	'iptables'
	'libusb'
	'upower'
	'vala'
	'wpa_supplicant'
	'lzo'
	'libarchive'
	'cmake'
	'icu'
	'libical'
	'bluez'
	'libmbim'
	'libqmi'
	'modemmanager'
	'dhcpcd'
	'networkmanager'
)

mkdir -v pkg

[ -f build-base.log ] && rm build-networkmanager.log
touch build-base.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package"  | tee -a build-networkmanager.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-networkmanager.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done

echo "You can rebuild NetworkManager with PyGObject later if required"


