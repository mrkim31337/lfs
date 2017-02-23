#!/bin/bash
LFS=/mnt/lfs
=======
mkdir -v $LFS/tools
ln -sv $LFS/tools /
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
chown -v lfs $LFS/tools

