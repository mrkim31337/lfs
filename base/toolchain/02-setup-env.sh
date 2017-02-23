cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin:/usr/local/bin
export LFS LC_ALL LFS_TGT PATH
export CFLAGS="-march=native -mtune=native -O3 -pipe -fomit-frame-pointer"
export CXXFLAGS="${CFLAGS}"
export MAKEOPTS="-j5"
export MAKEFLAGS="-j5"
alias ls='ls --color'
EOF

source ~/.bash_profile


