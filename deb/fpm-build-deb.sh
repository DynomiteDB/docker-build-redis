#!/bin/bash

#
# Build: DynomiteDB Redis backend 
# OS:    Ubuntu 14.04
# Type:  .deb
#
# 1. Compile binaries using Docker
# 2. Create .deb package using fpm
#

PWD=`pwd`
echo $PWD

#
# Remove prior build
#

rm -rf /tmp/dynomite/

#
# Create a packaging directory structure for the package
#
mkdir -p /tmp/dynomite
# Defaults
mkdir -p /tmp/dynomite/etc/default
# init scripts
mkdir -p /tmp/dynomite/etc/init.d
# Configuration files
mkdir -p /tmp/dynomite/etc/dynomitedb
# Log configuration
mkdir -p /tmp/dynomite/etc/logrotate.d
# Binaries
mkdir -p /tmp/dynomite/usr/local/bin
mkdir -p /tmp/dynomite/usr/local/sbin
# Man pages
#mkdir -p /tmp/dynomite/usr/local/share/man/man1
#mkdir -p /tmp/dynomite/usr/local/share/man/man8
# Static files
mkdir -p /tmp/dynomite/usr/local/dynomitedb/redis
# Data dirs
mkdir -p /tmp/dynomite/var/dynomitedb/redis/data
# Logs
mkdir -p /tmp/dynomite/var/log/dynomitedb/redis
# PID files
mkdir -p /tmp/dynomite/var/run
# lintian
mkdir -p /tmp/dynomite/usr/share/lintian/overrides
cp ${PWD}/dynomitedb-redis.lintian-overrides /tmp/dynomite/usr/share/lintian/overrides/dynomitedb-redis
chmod 0644 /tmp/dynomite/usr/share/lintian/overrides/dynomitedb-redis

# Set directory permissions for the package
chmod -R 0755 /tmp/dynomite/


#
# Copy the package files into the packaging directory structure
#

# Man pages
#chmod 0644 /tmp/dynomite/usr/local/share/man/man8/*

#
# Redis
#
# System binaries
cp ~/repos/redis/package-server/redis-server /tmp/dynomite/usr/local/sbin/dynomitedb-redis-server
# User binaries
cp ~/repos/redis/package-tools/redis-benchmark /tmp/dynomite/usr/local/bin/
cp ~/repos/redis/package-tools/redis-check-aof /tmp/dynomite/usr/local/bin/
cp ~/repos/redis/package-tools/redis-check-dump /tmp/dynomite/usr/local/bin/
cp ~/repos/redis/package-tools/redis-cli /tmp/dynomite/usr/local/bin/
# Configuration (default dynomite.yaml is for single server Redis)
cp ${PWD}/etc/dynomitedb/redis-3.0.7.conf /tmp/dynomite/etc/dynomitedb/redis.conf 
cp ${PWD}/etc/default/dynomitedb-redis /tmp/dynomite/etc/default/ 
chmod 0644 /tmp/dynomite/etc/dynomitedb/*
cp ${PWD}/etc/logrotate.d/dynomitedb-redis /tmp/dynomite/etc/logrotate.d/
# init
cp ${PWD}/etc/init.d/dynomitedb-redis /tmp/dynomite/etc/init.d/
# Static files
cp ~/repos/redis/package-server/00-RELEASENOTES /tmp/dynomite/usr/local/dynomitedb/redis/
cp ~/repos/redis/package-server/BUGS /tmp/dynomite/usr/local/dynomitedb/redis/
cp ~/repos/redis/package-server/COPYING /tmp/dynomite/usr/local/dynomitedb/redis/
cp ~/repos/redis/package-server/README /tmp/dynomite/usr/local/dynomitedb/redis/
cp ${PWD}/var/dynomitedb/redis/data/README.md /tmp/dynomite/var/dynomitedb/redis/data/
chmod 0644 /tmp/dynomite/usr/local/dynomitedb/redis/*
chmod 0644 /tmp/dynomite/var/dynomitedb/redis/data/README.md

#
# General perms
#
chmod 0755 /tmp/dynomite/etc/init.d/*
chmod 0644 /tmp/dynomite/etc/default/*
chmod 0644 /tmp/dynomite/etc/logrotate.d/*
chmod 0755 /tmp/dynomite/usr/local/sbin/*
chmod 0755 /tmp/dynomite/usr/local/bin/*

#--config-files /tmp/dynomite/etc/dynomitedb/dynomite/dynomite.yaml \
#--config-files "/tmp/dynomite/etc/dynomitedb/dynomite/dynomite.yaml" \

#--deb-custom-control ~/repos/go/src/gitlab.com/DynomiteDB/DynomiteDB/packaging/ubuntu/dynomite/control \
#--deb-upstart /etc/init.d/dynomite \
#--deb-upstart "/etc/init.d/dynomite" \
#--deb-user "dynomite" \
#--deb-group "dynomite" \

# Works
	#--deb-upstart $HOME/repos/go/src/gitlab.com/DynomiteDB/DynomiteDB/packaging/ubuntu/dynomite/dynomite \
	#--deb-init $HOME/repos/go/src/gitlab.com/DynomiteDB/DynomiteDB/packaging/ubuntu/dynomite/dynomite \
	#--before-install $HOME/repos/go/src/gitlab.com/DynomiteDB/DynomiteDB/packaging/ubuntu/dynomite/preinst.ex \

# Replaced with custom control file
	#--vendor "DynomiteDB" \
	#--category "database" \
	#-m "akbar@dynomitedb.com" \
	#--description "A fast and scalable database with pluggable backends" \
	#--url "http://www.dynomitedb.com" 

fpm \
	-f \
	-s dir \
	-t deb \
	-C /tmp/dynomite/ \
	--directories /tmp/dynomite/ \
	--config-files /etc/dynomitedb/ \
	--deb-custom-control ${PWD}/control \
	--before-install ${PWD}/preinst.ex \
	--after-install ${PWD}/postinst.ex \
	--before-remove ${PWD}/prerm.ex \
	--after-remove ${PWD}/postrm.ex \
	-n "dynomitedb-redis" \
	-v 3.0.7 \
	--epoch 0

#
# Sign the .deb package
#
#dpkg-sig -k 7FC9E9A0 --sign origin dynomitedb_0.0.1_amd64.deb
