#!/bin/sh
export STEAM_RUNTIME=0
# Workaround for dbus fatal termination related coredumps (SIGABRT)
# https://github.com/ValveSoftware/steam-for-linux/issues/4464
export DBUS_FATAL_WARNINGS=0
# Override some libraries as these are what games linked against.
export LD_LIBRARY_PATH="/opt/lib32"
LIBGL_DRIVER_PATH='/opt/lib32/dri' exec /usr/lib/steam/steam "$@"

