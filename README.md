# Build Redis

The `build-redis` container provides a clean, reusable and immutable build environment in which to compile the Redis backend for DynomiteDB.

Compiling Redis has two discrete steps:

1. Build the `build-redis` Docker image (automated via DockerHub)
2. Compile Redis

# Compile Redis

Build Dynomite using a tagged version. For example, to build the tagged release `v0.5.8` execute the command below.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis -v 3.0.7
```

Build the Redis binaries.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis
```

Create a debug build.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis -d
```

# Manually build the `build-redis` image

The `build-redis` Docker image, which is used to compile Redis, is automatically built via DockerHub.

The automated build is located at https://hub.docker.com/r/dynomitedb/build-redis.

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

