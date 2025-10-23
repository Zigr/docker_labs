# Docker image of PostgreSQL with vector database extension **pgvector** on Alpine Linux

<style type="text/css" media="screen">
.success{padding:1rem;border-radius:0.5em;background-color:#95d5b2;color:black}
.warn{padding:1rem;border-radius:0.5em;background-color:#ffe1a8;color:#250902}
.success a:link { color:#33348e; text-decoration: none; }
.success a:visited { color:#33348e; text-decoration: none; }
.success a:hover { color:#33348e; text-decoration: none; }
.success a:active { color:#7476b4; text-decoration: underline; }
</style>

## Goals

- To build a Docker image which makes a small image-size footprint.
- To make quick installable **docker compose** services, which support both relational and vector databases.

## Versions used

| **Alpine**     | 3.21  |
|----------------|-------|
| **PostgreSQL** | 15.12 |
| **Pgvector**   | 0.8.0 |

## Requrements

Docker version >= **version 23.0**,  in which Docker **BuildKit** was introduced. To check this issue enter a terminal command:

```shell
docker buildx build --help
```

Probably, an older Docker version would be work. But this is not garanteed. See [Creating Issues](#creating-issues)

---

## Install from Docker Hub

```shell

docker pull  zigr/pg15-pgvector08:alpine3.21

```

## Create/build an image locally  by cloning this repo

### 1. Clone the repo

### 2. Build the image with Docker CLI

#### Command:  docker build [OPTIONS] PATH | URL | -

#### Argument Used

The last parameter **PATH | URL | -**  is called a  [Build Context](https://docs.docker.com/build/concepts/context/)
In case of default repo clone, PATH is relative path, which points to current directory.

#### OPTIONS Used

| **OPTION**     | Description                                     |
|----------------|-------------------------------------------------|
|**-t**          | Name and optionally a tag (format: "name:tag")  |
|**-D, --debug** | Enable debug logging                            |
|**--check**     | The --check flag evaluates build checks without executing the build |
| **--no-cache** | Do not use cache when building the image        |
|**--build-arg** | Set build-time variables. Do not set empty vals |

#### Example 1: Check that image can be built, see warnings, if any, etc, In the local [Build Context](https://docs.docker.com/build/concepts/context/)

It's assumed you clone the repo in the directory by default

```shell
cd ./docker_labs
docker build -t  mypostgres-pgvector -D --no-cache --check .
```

#### Example 2: Build image from local [Build Context](https://docs.docker.com/build/concepts/context/)

```shell
cd ./docker_labs
docker build -t  mypostgres-pgvector [--build-arg=""] [-D] [--no-cache] .
```

**See** [⚠️ Important Note](#important-note)

---

<div class="success">

## 😎 Create/build an image using github repository

### Example 1: Check that image can be built, see warnings, if any, etc, In the remote [Build Context](https://docs.docker.com/build/concepts/context/)

```shell
docker docker  build -t  mypostgres-pgvector -D --no-cache -f Dockerfile.postgresql --check https://github.com/Zigr/docker_labs.git#master:/postgres-pgvector

```

### Example 2: Build image from remote [Build Context](https://docs.docker.com/build/concepts/context/)

```shell
docker build -t  mypostgres-pgvector -f Dockerfile.postgresql [--build-arg=""] [-D] [--no-cache] https://github.com/Zigr/docker_labs.git#master:postgres-pgvector

```

**See** [⚠️ Important Note](#important-note)

</div>

---

## Create and run a new container from an image

### Command:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

### Arguments Used

|**ARGUMENT** | Description                       |
|-------------|-----------------------------------|
|**IMAGE**    | The only required command argument|

### OPTIONS Used

|**OPTION**       | Description                                 |
|-----------------|---------------------------------------------|
|**--name**        | Assign a name to the container             |
|**-p, --publish** | Publish a container's port(s) to the host  |
|**--mount**       | Attach a file system mount to the container|
|**-e, --env**     | Set environment variables                  |
|**--rm**          | Automatically remove the container and its associated anonymous volumes when it exits |
|**-t, --tty**     | Allocate a pseudo-TTY(terminal)            |
|**-i, --interactive** | Keep STDIN open even if not attached  |
|**-d, --detach**  | Run container in background and print container ID  |

#### Example 1. Start container with various OPTIONS

```shell
docker run [--rm] [--interactive] [--tty] [--detach] --name my_pg_pgvector -p 5432:5432 --mount type=volume,src=my_pg_data,dst=/var/lib/postgresql/data,volume-nocopy -e POSTGRES_DB=mydb -e POSTGRES_USER=root -e POSTGRES_PASSWORD='!ChangeMe!' -e PGDATA=/var/lib/postgresql/data/pgdata zigr/pg15-pgvector08:alpine3.21
```

**See** [⚠️ Important Note](#important-note)

---
<div class="warn" >

## Important Note

- remove brackets around OPTION(s), i.e. [OPTION] -> OPTION  in order the OPTION will take effect
- or replace [OPTION] with a space character, i.e [OPTION] -> **space character** in order the  [OPTION] will not be present in a command

</div>

---

## Running on the local network example

### 1. Build images

```shell
docker build -t mypostgres-pgvector -f Dockerfile.postgres .
docker build -t mypsql -f Dockerfile.client .

```

### 2. Start the PostgreSQL server container:

```shell

docker network create mynetwork
docker run -d --name postgres-server --network mynetwork -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydatabase mypostgres-pgvector

```

### 3. Start the client container and connect to the server

```shell

docker run -it --rm --network mynetwork mypsql -h postgres-server -U myuser -d mydatabase

```

Now, the psql client should connect to the PostgreSQL server running in the other container.

---

## Creating Issues

In case of image does not build or/and run, then  <a href="https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue" target="_blank" >create an issue</a>

## Links

- [pgvector](https://github.com/pgvector/pgvector/tree/master)

