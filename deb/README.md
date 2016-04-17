# DynomiteDB package

This directory builds a single dynomitedb package that includes:

- dynomite
- dyno CLI app
- backend-redis
- backend-ledis
    - RocksDB
    - LMDB

# Build new version

```bash
vi control
```

Update the `Version:` in the `control file.

```bash
vi fpm-build-deb.sh
```

Update the version in the `fpm` command via the `-v` flag.

# Redis configuration

The following are additional changes that must be made to a host system running Dynomite + Redis.

## Increase `ulimit`

```bash
vi /etc/security/limits.conf
```

```bash
*               hard    nofile          100000
*               soft    nofile          100000
```

TODO: Put the following in the Redis init script.

```bash
sysctl -w fs.file-max=100000
ulimit -Sn 100000
```

## WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.

```bash
vi /etc/rc.local
```

Add the following.

```bash
sysctl -w net.core.somaxconn=65535
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```

or

echo 511 > /proc/sys/net/core/somaxconn

## Update `/etc/sysctl.conf`

```bash
vi /etc/sysctl.conf
```

Add the following.

```bash
vm.overcommit_memory = 1
```

Or add the following to the Redis init script.

```bash
sysctl vm.overcommit_memory=1
```

