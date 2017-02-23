#!/bin/sh

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build Firefox"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi

#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
	'atk'
	'gdk-pixbuf'
	'gsettings-desktop-schemas'
	'glib-networking'
	'at-spi2-core'
	'at-spi2-atk'
	'json-glib'
	'libsoup'
	'rest'
	'librsvg'
	'hicolor-icon-theme'
	'adwaita-icon-theme'
	'gtk+'
	'libcroco'
	'libevent'
	'libvpx'
	'dbus-glib'
	'gconf'
	'giflib'
	'fribidi'
	'libwebp'
	'libass'
	'fdk-aac'
	'flac'
	'lame'
	'opus'
	'x264'
	'x265'
	'libva'
	'libvdpau'
	'sdl2'
	'xvid'
	'ffmpeg'
	'liboauth'
	'autoconf-firefox'
)

mkdir -v pkg

[ -f build-toolchain.log ] && rm build-toolchain.log
touch build-toolchain.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package" --no-cert-check | tee -a build-toolchain.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-toolchain.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done

echo "You can now edit mozconfig in sources dir and build firefox"

