#!/bin/sh
# prerm script for dynomite
#
# see: dh_installdeb(1)

set -e

# summary of how this script can be called:
#        * <prerm> `remove'
#        * <old-prerm> `upgrade' <new-version>
#        * <new-prerm> `failed-upgrade' <old-version>
#        * <conflictor's-prerm> `remove' `in-favour' <package> <new-version>
#        * <deconfigured's-prerm> `deconfigure' `in-favour'
#          <package-being-installed> <version> `removing'
#          <conflicting-package> <version>
# for details, see http://www.debian.org/doc/debian-policy/ or
# the debian-policy package


case "$1" in
    remove|upgrade|deconfigure)
	if which service >/dev/null 2>&1; then
            if service dynomitedb-redis status >/dev/null 2>&1; then
	        service dynomitedb-redis stop
            fi
	elif which invoke-rc.d >/dev/null 2>&1; then
	    invoke-rc.d dynomitedb-redis stop
	else
	    /etc/init.d/dynomitedb-redis stop
	fi

    ;;

    failed-upgrade)
    ;;

    *)
        echo "prerm called with unknown argument \`$1'" >&2
        exit 1
    ;;
esac

exit 0
