#!/bin/sh

#check if run as root
[ ! $UID -eq 0 ] && echo "This needs to be run as root!" && exit 1

[ -z $LFS ] && echo "LFS environment variable isn't set." && exit 1

export LFS

	chroot "$LFS" /usr/bin/env -i \
		HOME=/root					\
		TERM="$TERM"				\
		PS1='\u:\w\$ '				\
		PATH="/usr/bin:/usr/local/bin"	\
		/bin/bash --login +h
