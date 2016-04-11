#
# DynomiteDB: Compile Redis
#
FROM dynomitedb/build-c

MAINTAINER Akbar S. Ahmed <akbar@dynomitedb.com>

#
# Environment variables
#

#
# Mountable directories
#

#
# Working directory (similar to `cd $WORKDIR` for all following commands)
#
WORKDIR /src

#
# Default command
#
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
