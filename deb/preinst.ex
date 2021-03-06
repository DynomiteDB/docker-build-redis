#!/bin/sh
# preinst script for dynomite
#
# see: dh_installdeb(1)

set -e

# summary of how this script can be called:
#        * <new-preinst> `install'
#        * <new-preinst> `install' <old-version>
#        * <new-preinst> `upgrade' <old-version>
#        * <old-preinst> `abort-upgrade' <new-version>
# for details, see http://www.debian.org/doc/debian-policy/ or
# the debian-policy package

REDIS_USER="dynomitedb"
REDIS_GROUP="dynomitedb"
REDIS_HOME="/usr/local/dynomitedb/redis"

case "$1" in
    install|upgrade)
	# If NIS is used, then allow errors
	if which ypwhich >/dev/null 2>&1 && ypwhich >/dev/null 2>&1
	then
	    set +e
	fi

	# Add dynomitedb group if group does not exist
	if ! getent group $REDIS_GROUP >/dev/null
	then
	    addgroup --system $REDIS_GROUP >/dev/null
	fi

	# Add dynomitedb user if user does not exist
	if ! getent passwd $REDIS_USER >/dev/null
	then
	    adduser --system --disabled-login --ingroup dynomitedb --no-create-home --home /usr/local/dynomitedb/home --gecos "dynomitedb" --shell /bin/false dynomitedb >/dev/null
	fi
	
	# end of NIS tolerance zone
	set -e

    ;;

    abort-upgrade)
    ;;

    *)
        echo "preinst called with unknown argument \`$1'" >&2
        exit 1
    ;;
esac

exit 0
