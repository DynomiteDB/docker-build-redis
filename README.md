# Build Redis

The `build-redis` container provides a clean, reusable and immutable build environment in which to compile the Redis backend for DynomiteDB.

The `build-redis` container performs the following steps:

1. `git clone` the Redis repository from GitHub
2. Compile Redis
3. Create a `.tgz` package
4. Create a `.deb` package

Compiling Redis has two discrete steps:

1. Build the `build-redis` Docker image (automated via DockerHub)
2. Compile Redis

Building the `build-redis` Docker image is automated by DockerHub. Therefore, you only need to run the commands below to compile Redis.

# Compile Redis

## Options

`build-redis` supports optional flags:

- `-v tag-version`: Specify a tagged release to build based on GitHub tags. If `-v` is not used then the `unstable` branch is used for the build.
- `-d [mode]`: Default mode is `production` which enables optimizations. `debug` mode disables optimizations. Possible values: `debug`, `production`.
- `-t target`: Specify a `make` build target.

## Build tagged version

Build Redis using a tagged version. For example, to build the tagged release `3.0.7` execute the command below.

> It is strongly recommended that you build a specific tagged Redis version as shown below.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis -v 3.0.7
```

## Build `unstable` branch

Run `build-redis` without any arguments to compile Redis from the `unstable` branch. This option is only recommended for testing and not production usage.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis
```

## Build Redis debug binary

Create a debug build with the `-d` flag.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis -d
```

# Manually build the `build-redis` image

The `build-redis` Docker image, which is used to compile Redis, is automatically built via DockerHub. The automated build is located at https://hub.docker.com/r/dynomitedb/build-redis.

However, you can manually build the `build-redis` image by executing the commands shown below.

First, clone the `docker-build-redis` repo.

```bash
mkdir -p ~/repos && cd $_

git clone https://github.com/DynomiteDB/docker-build-redis.git

cd ~/repos/docker-build-redis
```

Next, create the `build-redis` image.

```bash
docker build -t dynomitedb/build-redis .
```

