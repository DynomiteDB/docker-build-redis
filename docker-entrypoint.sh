#!/bin/bash
set -e

#
# Build with debug: -d
# Add a target to make: -t <target>
#

# Reset getopts option index
OPTIND=1

# Additional make target
target=""
# If the -d flag is set then create a debug build of dynomite
mode="production"

while getopts "dt:" opt; do
    case "$opt" in
    d)  mode="debug"
        ;;
    t)  target=$OPTARG
        ;;
    esac
done

if [ "$target" == "clean" ] ; then
    make clean
    exit 0;
fi

if [ "$target" == "distclean" ] ; then
    make distclean
    exit 0;
fi

# Build Redis

if [ "$mode" == "debug" ] ; then
    target="noopt"
fi

# Default target == ""
make $target

#
# Create server package
#
rm -f /src/dynomitedb-redis-server_ubuntu-14.04.4-x64.tar.gz
rm -rf /src/dynomitedb-redis-server
mkdir -p /src/dynomitedb-redis-server/conf

cp /src/src/redis-server /src/dynomitedb-redis-server/
if [ "$mode" == "production" ] ; then
	cp /src/dynomitedb-redis-server/redis-server /src/dynomitedb-redis-server/redis-server-debug
    strip --strip-debug --strip-unneeded /src/dynomitedb-redis-server/redis-server
fi

# Static files
for s in "00-RELEASENOTES" "BUGS" "COPYING" "README"
do
	cp /src/$s /src/dynomitedb-redis-server/
done

# Configuration file
# TODO: Change this to the redis.conf file used by DynomiteDB
cp /src/redis.conf /src/dynomitedb-redis-server/conf/

tar -czf dynomitedb-redis-server_ubuntu-14.04.4-x64.tar.gz -C /src dynomitedb-redis-server

#
# Create tools package
#
rm -f /src/dynomitedb-redis-tools_ubuntu-14.04.4-x64.tar.gz
rm -rf /src/dynomitedb-redis-tools
mkdir -p /src/dynomitedb-redis-tools

# Binaries
for b in "redis-benchmark" "redis-check-aof" "redis-check-dump" "redis-cli"
do
    cp /src/src/$b /src/dynomitedb-redis-tools/
    if [ "$mode" == "production" ] ; then
        strip --strip-debug --strip-unneeded /src/dynomitedb-redis-tools/$b
    fi
done

# Static files
for s in "00-RELEASENOTES" "BUGS" "COPYING" "README"
do
	cp /src/$s /src/dynomitedb-redis-tools/
done

tar -czf dynomitedb-redis-tools-14.04.4-x64.tar.gz -C /src dynomitedb-redis-tools
