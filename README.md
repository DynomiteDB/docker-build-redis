# Build Redis

`build-redis` is a Docker container used to build Redis as a DynomiteDB backend.

# Compile Redis

Run the `build-redis` container to compile Redis.

Clone and then `cd` into the `redis` git repo.

```bash
mkdir -p ~/repos/ && cd $_

git clone https://github.com/antirez/redis.git

cd ~/repos/redis/

# Build a specific tag (i.e. release)
#git checkout tags/2.8.24
git checkout tags/3.0.7
```

Build all of the Redis binaries.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis
```

Create a debug build.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis -d
```

Clean the build directory.

```bash
docker run -it --rm -v $PWD:/src dynomitedb/build-redis -t clean

docker run -it --rm -v $PWD:/src dynomitedb/build-redis -t distclean
```

# Manually build the `build-redis` image

The `build-redis` Docker image, which is used to compile Redis, is automatically built via DockerHub.

The automated build is located at https://hub.docker.com/r/dynomitedb/build-redis.

However, you can manually build the `build-redis` image by executing the commands shown below.

First, clone the `docker-build-redis` repo and `cd` into the `docker-build-redis` directory.

```bash
mkdir -p ~/repos

git clone https://github.com/DynomiteDB/docker-build-redis.git

cd ~/repos/docker-build-redis
```

Create the `build-redis` image.

```bash
docker build -t dynomitedb/build-redis .
```

