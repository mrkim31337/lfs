#!/bin/sh

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build the X Server"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi
[ -z $XORG_PREFIX ] && echo "xorg prefix not set - install xorg-build-environment first" && exit 1
[ -z $XORG_CONFIG ] && echo "xorg congig not set - install xorg-build-environment first" && exit 1
#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
	'util-macros'
	'xorg-protocol-headers'
	'libXau'
	'libXdmcp'
	'xcb-proto'
	'libxcb'
	'which'
	'icu'
	'freetype'
	'lzo'
	'libarchive'
	'cmake'
	'graphite2'
	'harfbuzz'
	'fontconfig'
	'xorg-libraries'
	'xcb-util'
	'xcb-util-image'
	'xcb-util-keysyms'
	'xcb-util-renderutil'
	'xcb-util-wm'
	'xcb-util-cursor'
	'libdrm'
	'wayland'
	'wayland-protocols'
	'mesa'
	'xbitmaps'
	'xorg-applications'
	'xcursor-themes'
	'xorg-fonts'
	'xkeyboard-config'
	'pixman'
	'libepoxy'	
	'xorg-server'
	'libevdev'
	'mtdev'
	'libinput'
	'xf86-input-libinput'
	'xf86-video-vmware'
	'xterm'
	'xinit'
)

mkdir -v pkg

[ -f build-X11.log ] && rm build-X11.log
touch build-X11.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package"  | tee -a build-X11.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-X11.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done

echo "Rebuild Freetype and then Fontconfig now that HarfBuzz is installed"
echo "Build video driver if required"

