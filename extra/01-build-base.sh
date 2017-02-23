#!/bin/sh

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build the BLFS base packages"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi

#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
	'bash-files'
	'ca-certificates'
	'openssl'
	'lsb-release'
	'nettle'
	'libtasn1'
	'nspr'
	'libffi'
	'sqlite'
	'tcl'
	'sharutils'
	'berkeley-db'
	'Python2'
	'libxml2'
	'sgml-common'
	'docbook-xml'
	'docbook-xsl'
	'libgpg-error'
	'pth'
	'libgcrypt'
	'libxslt'
	'nss'
	'p11-kit'
	'gnutls'
	'libtirpc'
	'cracklib'
	'Linux-PAM'
	'openssh'
	'sudo'
	'pcre'
	'elfutils'
	'glib'
	'gobject-introspection'
	'zip'
	'mozjs'
	'polkit'
	'libidn'
	'wget'
	'lvm2'
	'cryptsetup'
	'libpng'
	'slang'
	'mc'
	'Check'
	'screen'
)

mkdir -v pkg

[ -f build-base.log ] && rm build-base.log
touch build-base.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package"  | tee -a build-base.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-base.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done

echo "NOW REBUILD SHADOW FIRST FOR PAM SUPPORT AND THEN SYSTEMD"
echo "ALSO SET LOCALE eg localectl set-locale LANG=en_US.utf8"


