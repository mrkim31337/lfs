#!/bin/sh

#check if run as root
[ ! $UID -eq 0 ] && echo "This needs to be run as root!" && exit 1

[ -z $LFS ] && echo "LFS environment variable isn't set." && exit 1

export LFS
chown -R root:root $LFS/tools
mkdir -pv $LFS/{bin,dev,proc,sys,run,root,etc,tmp}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

#mount the necessary virtual filesystems
! mount -v --bind /dev "${LFS}/dev" && exit 1
! mount -vt devpts none "${LFS}/dev/pts" -o gid=5,mode=620 && ( umount -v "${LFS}/dev"; exit 1  )
! mount -vt proc none "${LFS}/proc" && ( umount -v "${LFS}/dev/pts"; umount -v "${LFS}/dev"; exit 1 )
! mount -vt sysfs none "${LFS}/sys" && ( umount -v "${LFS}/proc"; umount -v "${LFS}/dev/pts"; umount -v "${LFS}/dev"; exit 1 )
! mount -vt tmpfs none "${LFS}/run" && ( umount -v "${LFS}/sys"; umount -v "${LFS}/proc"; umount -v "${LFS}/dev/pts"; umount -v "${LFS}/dev"; exit 1 )

#copy resolv.conf so that internet works
rm -v "${LFS}/etc/resolv.conf"
cp -v -L /etc/resolv.conf "${LFS}/etc/"

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

if [ -d "${LFS}/tools" ]
then #toolchain still exists
	chroot "$LFS" /tools/bin/env -i \
		HOME=/root					\
		TERM="$TERM"				\
		PS1='\u:\w\$ '				\
		PATH="/usr/bin:/tools/bin:/usr/local/bin"	\
		MANPATH="/usr/share/man:/tools/share/man"	\
		/tools/bin/bash --login +h
else	#toolchain has been removed
	chroot "$LFS" /bin/env -i \
		HOME=/root					\
		TERM="$TERM"				\
		PS1='\u:\w\$ '				\
		PATH="/usr/bin:/usr/local/bin"	\
		/bin/bash --login
fi

#rm -v "${LFS}/etc/resolv.conf"
#
#unmount all the filesystems
#umount -v "${LFS}/run"
#umount -v "${LFS}/sys"
#umount -v "${LFS}/proc"
#umount -v "${LFS}/dev/pts"
#umount -v "${LFS}/dev"
