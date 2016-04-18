#!/bin/bash
set -e

# 
# The dynomite build container performs the following actions:
# 1. Checkout repo
# 2. Compile binary
# 3. Package binary in .tgz
# 4. Package binary in .deb
#
# Options:
# -v: tag version
# -d: debug
# -t <target>: add a make target
#

BUILD=/build/redis
SRC=/src
DEB=/deb


# Reset getopts option index
OPTIND=1

# If set, then build a specific tag version. If unset, then build unstable branch
version="unstable"
# If the -d flag is set then create a debug build of dynomite
mode="production"
# Additional make target
target=""


while getopts "v:d:t:" opt; do
	case "$opt" in
	v)  version=$OPTARG
		;;
	d)  mode=$OPTARG
		;;
	t)  target=$OPTARG
		;;
	esac
done

#
# Get the source code
#
git clone https://github.com/antirez/redis.git
cd $BUILD
if [ "$version" != "unstable" ] ; then
	echo "Building tagged version:  $version"
	git checkout tags/$version
else
	echo "Building branch: $version"
fi

# make clean is no longer necessary as all builds are clean by default
#if [ "$target" == "clean" ] ; then
#    make clean
#    exit 0;
#fi

#if [ "$target" == "distclean" ] ; then
#    make distclean
#    exit 0;
#fi

# Build Redis

# Change the value of target only if not explicitly set
if [ "$mode" == "debug" && "x$target" == "x" ] ; then
	target="noopt"
fi

# Default target == ""
make $target

#
# Create Redis package
#
rm -f $SRC/dynomitedb-redis_ubuntu-14.04.4-x64.tar.gz
rm -rf $SRC/dynomitedb-redis
mkdir -p $SRC/dynomitedb-redis/conf

# System binaries
cp $BUILD/src/redis-server $SRC/dynomitedb-redis/dynomitedb-redis-server
if [ "$mode" == "production" ] ; then
	cp $SRC/dynomitedb-redis/dynomitedb-redis-server $SRC/dynomitedb-redis/dynomitedb-redis-server-debug
	strip --strip-debug --strip-unneeded /src/dynomitedb-redis/dynomitedb-redis-server
fi

# Binaries
for b in "redis-benchmark" "redis-check-aof" "redis-check-dump" "redis-cli"
do
	cp $BUILD/src/$b $SRC/dynomitedb-redis/
	if [ "$mode" == "production" ] ; then
		strip --strip-debug --strip-unneeded $SRC/dynomitedb-redis/$b
	fi
done

# Static files
for s in "00-RELEASENOTES" "BUGS" "COPYING" "README"
do
	cp $BUILD/$s $SRC/dynomitedb-redis/
done

# Configuration file
# TODO: Add check for Redis version to use different conf files
cp $DEB/etc/dynomitedb/redis-3.0.7.conf $SRC/dynomitedb-redis/conf/redis.conf

#
# Create .tgz package
#
cd /src
tar -czf dynomitedb-redis_ubuntu-14.04.4-x64.tgz -C /src dynomitedb-redis

# Update .deb build files
# Set to future version is building against the dev branch
# TODO: Come up with a better solution for tagging builds against dev branch
if [ "$version" == "unstable" ] ; then
	version=999.999.999
fi
export REDIS_VERSION=$version
sed -i 's/0.0.0/'${version}'/' $DEB/changelog
sed -i 's/0.0.0/'${version}'/' $DEB/control

$DEB/fpm-build-deb.sh

