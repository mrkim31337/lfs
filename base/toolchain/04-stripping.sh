#!/bin/bash
/tools/bin/find /usr/lib -type f -name \*.a -exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /usr/lib -type f -name \*.so* -exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /usr/{bin,sbin,libexec} -type f -exec /tools/bin/strip --strip-all {} ';'
