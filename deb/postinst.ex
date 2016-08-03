#!/bin/sh
# postinst script for dynomite
#
# see: dh_installdeb(1)

set -e

# summary of how this script can be called:
#        * <postinst> `configure' <most-recently-configured-version>
#        * <old-postinst> `abort-upgrade' <new version>
#        * <conflictor's-postinst> `abort-remove' `in-favour' <package>
#          <new-version>
#        * <postinst> `abort-remove'
#        * <deconfigured's-postinst> `abort-deconfigure' `in-favour'
#          <failed-install-package> <version> `removing'
#          <conflicting-package> <version>
# for details, see http://www.debian.org/doc/debian-policy/ or
# the debian-policy package

REDIS_USER="dynomitedb"
REDIS_GROUP="dynomitedb"
REDIS_HOME="/usr/local/dynomitedb/redis"

case "$1" in
    configure)
        mkdir -p /etc/dynomitedb
        mkdir -p /usr/local/dynomitedb/home
        mkdir -p /var/log/dynomitedb/redis
        mkdir -p /var/run/dynomitedb
        mkdir -p /var/dynomitedb/redis/data

        # TODO: Set permissions
        chown $REDIS_USER:$REDIS_GROUP /usr/local/dynomitedb/redis
        chown $REDIS_USER:$REDIS_GROUP /var/dynomitedb/redis
        chown $REDIS_USER:$REDIS_GROUP /var/log/dynomitedb/redis
        chown $REDIS_USER:$REDIS_GROUP /var/run/dynomitedb

        update-rc.d dynomitedb-redis defaults

        #service dynomitedb-redis start
    ;;

    abort-upgrade|abort-remove|abort-deconfigure)
    ;;

    *)
        echo "postinst called with unknown argument \`$1'" >&2
        exit 1
    ;;
esac

exit 0
