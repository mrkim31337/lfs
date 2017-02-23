#run this after chroot.sh
echo "fix ssl error with wget"
mknod /dev/random c 1 8
ln -sv /tools/bin/bash /tools/bin/sh
ln -sv /tools/bin/sh /bin/sh
cat > ~/.bashrc << "EOF"
export CFLAGS="-march=native -mtune=native -O3 -pipe -fomit-frame-pointer"
export CXXFLAGS="${CFLAGS}"
export MAKEOPTS="-j5"
export MAKEFLAGS="-j5"
alias ls='ls --color'
EOF


echo "Now Run source ~/.bashrc"
echo "Also copy lfsmerc to ~/.lfs-me" 
echo "move sources files to new source directory"
